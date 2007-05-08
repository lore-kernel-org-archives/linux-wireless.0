Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19213 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966504AbXEHRJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2007 13:09:43 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Date: Tue, 8 May 2007 13:08:47 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Andy Green <andy@warmcat.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704262023.52833.flamingice@sourmilk.net> <46319E31.4090101@linux.intel.com>
In-Reply-To: <46319E31.4090101@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1471188.3SqzCXpgeR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705081308.52200.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1471188.3SqzCXpgeR
Content-Type: multipart/mixed;
  boundary="Boundary-01=_f6KQGoWPfPuBiI1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_f6KQGoWPfPuBiI1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 27 April 2007 02:54, James Ketrenos wrote:
> 	hw scan: 2.2s
> 	sw scan: 4.7s
>
Alright, so I put together a patch to optimize software scanning a little a=
nd=20
tune the delays to be a bit closer to what the iwlwifi firmware uses. I don=
't=20
actually have a ipw3945 card, so I asked Andy Green to test it. Here are hi=
s=20
results:

options iwlwifi disable_hw_scan=3D0 debug=3D0x800

real    0m2.974s
real    0m2.855s
real    0m2.853s
real    0m2.753s

options iwlwifi disable_hw_scan=3D1 debug=3D0x800

real    0m2.754s
real    0m2.753s
real    0m2.757s
real    0m2.754s

The hw scans settle around 2.753s so there's basically no difference in spe=
ed=20
between sw and hw scan for this particular case. This is with 11 active, 2=
=20
passive 2.4ghz channels and 4 active, 16 passive 5.4ghz channels. For peopl=
e=20
not in Europe, software scanning should be roughly 20ms slower due to some=
=20
(fixable) dumbness in the ieee80211_sta scanning code.

Patch containing the optimizations and delay adjustments attached.=20
IEEE80211_HW_NO_PROBE_FILTER also needs to be set in dev->flags (or=20
the "[PATCH 10/13] mac80211: set bssid to broadcast before scan" patch back=
ed=20
out) in order for software scanning to work with iwlwifi.

=2DMichael Wu

--Boundary-01=_f6KQGoWPfPuBiI1
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="26-optimize-scanning.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="26-optimize-scanning.diff"

mac80211: optimize scanning code

=46rom: Michael Wu <flamingice@sourmilk.net>


=2D--

 net/mac80211/ieee80211_sta.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index d0a3aa0..f3017a1 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -45,9 +45,8 @@
 #define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
 #define IEEE80211_IBSS_JOIN_TIMEOUT (20 * HZ)
=20
=2D#define IEEE80211_PROBE_DELAY (HZ / 33)
=2D#define IEEE80211_CHANNEL_TIME (HZ / 33)
=2D#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
+#define IEEE80211_CHANNEL_TIME (HZ / 50)
+#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 9)
 #define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
@@ -2669,15 +2668,17 @@ void ieee80211_sta_scan_work(struct work_struct *wo=
rk)
 		if (skip)
 			break;
=20
=2D		next_delay =3D IEEE80211_PROBE_DELAY +
=2D			     usecs_to_jiffies(local->hw.channel_change_time);
+		next_delay =3D usecs_to_jiffies(local->hw.channel_change_time);
 		local->scan_state =3D SCAN_SEND_PROBE;
=2D		break;
+		if (local->hw.channel_change_time)
+			break;
 	case SCAN_SEND_PROBE:
 		if (local->scan_channel->flag & IEEE80211_CHAN_W_ACTIVE_SCAN) {
 			ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
 						 local->scan_ssid_len);
 			next_delay =3D IEEE80211_CHANNEL_TIME;
+			if (local->scan_hw_mode->mode =3D=3D MODE_IEEE80211A)
+				next_delay >>=3D 1;
 		} else
 			next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->scan_state =3D SCAN_SET_CHANNEL;

--Boundary-01=_f6KQGoWPfPuBiI1--

--nextPart1471188.3SqzCXpgeR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGQK6kT3Oqt9AH4aERAn26AJ9iKhTKRRDl9j5mY6hTFu8ik4g+xgCfQ2jE
t4LNDfoKiEx7gNkpLI/XWEU=
=rjB5
-----END PGP SIGNATURE-----

--nextPart1471188.3SqzCXpgeR--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
