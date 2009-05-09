Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZEILJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 07:09:09 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1241827331.4903.75.camel@localhost.localdomain>
References: <1241677107.2918.4.camel@localhost.localdomain>
	 <1241696104.27208.2.camel@johannes.local>
	 <1241704437.4903.15.camel@localhost.localdomain>
	 <1241705979.27208.31.camel@johannes.local>
	 <1241827331.4903.75.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pl8vNaszl1NOPR4hqj6q"
Date: Sat, 09 May 2009 13:09:07 +0200
Message-Id: <1241867347.31262.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pl8vNaszl1NOPR4hqj6q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 17:02 -0700, Marcel Holtmann wrote:

> phy0: AddBA: ssn=3D277, dialog_token=3D1 tid=3D0 timeout=3D0ba_policy=3D1

> Rx A-MPDU request on tid 0 result 0
> wlan0: CTS protection enabled (BSSID=3D00:1c:f0:xx:xx:xx)
> wlan0: CTS protection disabled (BSSID=3D00:1c:f0:xx:xx:xx)
> wlan0: no probe response from AP 00:1c:f0:xx:xx:xx - disassociating

At this point we tell the driver we're no longer associated. I think the
driver takes that as a reason to remove the station struct it keeps
track of in the driver. However,

> Tx BA session stop requested for 00:1c:f0:xx:xx:xx tid 0

now we stop the TX BA session

> iwlagn 0000:03:00.0: Invalid station for AGG tid 0

and iwlwifi no longer finds the station for it, returns an error

> ------------[ cut here ]------------
> WARNING: at net/mac80211/agg-tx.c:142 ___ieee80211_stop_tx_ba_session+0x6=
b/0x7e [mac80211]()

which causes the warning

> Rx BA session stop requested for 00:1c:f0:xx:xx:xx tid 0
> iwlagn 0000:03:00.0: Invalid station for AGG tid 0
> HW problem - can not stop rx aggregation for tid 0

same here -- but it's not a WARN_ON (though it probably should be!)

> phy0: device now idle
> phy0: Removed STA 00:1c:f0:xx:xx:xx

_Now_ mac80211 starts removing the station info.

> mac80211-phy0: failed to remove key (0, 00:1c:f0:xx:xx:xx) from hardware =
(-22)

before it asks the driver to remove the station with sta_notify, it
removes the key for the station. But even that fails, since iwlwifi
knows nothing about the station.

> phy0: Destroyed STA 00:1c:f0:xx:xx:xx

Now mac80211 has gotten rid of the sta struct completely.


I really really think the problem is that iwlwifi insists on keeping
track of station information with the wrong callback. It should be using
the sta_notify() callback, but it uses the bss_info_changed() callback,
which leads to ordering issues because we first tell the driver that we
disassociated, and _then_ remove all the information about the STA.

Now, I guess it's debatable whether or not we should tell the driver
that we disassociated _before_ we remove the station for the AP. But if
we reorder, other drivers might get confused because, well, we first
remove the AP STA and then tell them we disassociated -- but what from?

Therefore, I think disassociating first and then removing the station
information is correct.

However, to test my theory, you could apply the below patch. I suspect
it will no longer happen with this patch and iwlwifi.

Ultimately though I think iwlwifi just needs to be fixed wrt. station
handling. A whole lot of complex lookup code will go away because
mac80211 passes station structs wherever needed, which will improve
performance and reduce code size significantly.

johannes

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-09 13:06:54.000000000=
 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-09 13:07:59.000000000 +020=
0
@@ -1062,9 +1062,6 @@ static void ieee80211_set_disassoc(struc
 		config_changed |=3D IEEE80211_CONF_CHANGE_PS;
 	}
=20
-	ieee80211_hw_config(local, config_changed);
-	ieee80211_bss_info_change_notify(sdata, changed);
-
 	rcu_read_lock();
=20
 	sta =3D sta_info_get(local, ifmgd->bssid);
@@ -1078,6 +1075,9 @@ static void ieee80211_set_disassoc(struc
 	rcu_read_unlock();
=20
 	sta_info_destroy(sta);
+
+	ieee80211_hw_config(local, config_changed);
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
=20
 static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdat=
a)


--=-pl8vNaszl1NOPR4hqj6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKBWRPAAoJEODzc/N7+Qmagp4P/jDoACFC5XKpqFrVuyfJhD6z
pBsJ+F2RgSnP3tR0CICUqMs7N23k9NGbYb2Ym2eLlRiCGuqQFQj6/EstkLAY2Ebu
S2/y7FOrBZXv1AMAOZsNqdai+ZWvVagHubTboBvzOEO7/Co9fqDtui15nAn/qMCm
+7tQdlP+evYuSdLW2CNuFQQTVF0/YFlH6D9xuETADMueEAf/cAQcboNgbLJ95f+8
baAynw6mC7TU/B5NKtL9Hi3KVQo1dwmyylBSlIqIIWomkoTDc0sJuVqDD+FdTvfh
A48PJJX70NZLotw7BsPiF5fUowSxvFoqTE2xxCgwjvfY7H+Ow38Xq1vKt7mP6Jiu
v0c5HhQVW1kyQj2GAkxFqSATQK6LL4AZPnHD75L7iOgRqdkpkWwmT53rYXWr980u
g57V9RN5/qhh0Jdh9u8cH3Q+ZfOrZmBT/S8QR0fmQelKxCLgdLCGl+fiGc0JHcql
AOWmLkDlmf66hVCrjm+la8zktJtlQdnz64j3df5YGiREfWdVtcjoW6+sTf6STa12
X+USTSkUt8rwJaQwANWHdbx0NgSJDBrYrKxOMk4wVsZES4tKU1wegdkzzyWltpXW
MWaViDBkJSUaDUd9kUduBo3v2rvojmnlXVBswy/9mSGwTFC4Jf/yBUpjY6o9ruVM
iiEOPIEE99NkaKzNc1V6
=f1hO
-----END PGP SIGNATURE-----

--=-pl8vNaszl1NOPR4hqj6q--

