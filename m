Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:45880 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932432AbXB1Vmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 16:42:47 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: [PATCH 5/5] d80211: switch STA interfaces to PS mode during scan
Date: Wed, 28 Feb 2007 16:42:20 -0500
Cc: linux-wireless@vger.kernel.org
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <20070228203943.11473.88812.stgit@magic.sourmilk.net> <20070228210926.GM31074@devicescape.com>
In-Reply-To: <20070228210926.GM31074@devicescape.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1870306.LCFWj25hOa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702281642.24404.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1870306.LCFWj25hOa
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 28 February 2007 16:09, Jouni Malinen wrote:
> Why bother with PS Poll in this case? Just send data::nullfunc with PS
> Poll flag cleared. That will make the AP deliver all buffered frames (if
> any).
Didn't think of it. :)

Here's a version that does that:

=2D-

d80211: switch STA interfaces to PS mode during scan

=46rom: Michael Wu <flamingice@sourmilk.net>

This makes scans switch STA interfaces into PS mode so the AP queues frames
destined for us while we are scanning. This is achieved by sending a
nullfunc data frame with the PS mode bit set before scanning commences,
and a PS poll frame after scanning is completed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/linux/ieee80211.h    |    7 ++++++
 net/mac80211/ieee80211_sta.c |   51=20
+++++++++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4379b1d..836bde2 100644
=2D-- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -203,6 +203,13 @@ struct ieee80211_cts {
 	__u8 ra[6];
 } __attribute__ ((packed));
=20
+struct ieee80211_ps_poll {
+	__le16 frame_control;
+	__le16 aid;
+	__u8 bssid[6];
+	__u8 ta[6];
+} __attribute__ ((packed));
+
=20
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 280b24f..747662d 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2523,6 +2523,37 @@ int ieee80211_sta_set_bssid(struct net_d
 }
=20
=20
+static void ieee80211_send_nullfunc(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata,
+				    int powersave)
+{
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	u16 fc;
+
+	skb =3D dev_alloc_skb(local->hw.extra_tx_headroom + 24);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc =3D (struct ieee80211_hdr *) skb_put(skb, 24);
+	memset(nullfunc, 0, 24);
+	fc =3D IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
+	     IEEE80211_FCTL_TODS;
+	if (powersave)
+		fc |=3D IEEE80211_FCTL_PM;
+	nullfunc->frame_control =3D cpu_to_le16(fc);
+	memcpy(nullfunc->addr1, sdata->u.sta.bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
+
+	ieee80211_sta_tx(sdata->dev, skb, 0);
+}
+
+
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
@@ -2544,10 +2575,12 @@ void ieee80211_scan_completed(struct iee
=20
 	spin_lock_bh(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
=2D		netif_wake_queue(sdata->dev);
=2D
=2D		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
+		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA) {
+			if (sdata->u.sta.associated)
+				ieee80211_send_nullfunc(local, sdata, 0);
 			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+		}
+		netif_wake_queue(sdata->dev);
 	}
 	spin_unlock_bh(&local->sub_if_lock);
=20
@@ -2667,9 +2700,6 @@ static int ieee80211_sta_start_scan(stru
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
=20
=2D	/* TODO: if assoc, move to power save mode for the duration of the
=2D	 * scan */
=2D
 	if (local->sta_scanning) {
 		if (local->scan_dev =3D=3D dev)
 			return 0;
@@ -2691,8 +2721,12 @@ static int ieee80211_sta_start_scan(stru
 	local->sta_scanning =3D 1;
=20
 	spin_lock_bh(&local->sub_if_lock);
=2D	list_for_each_entry(sdata, &local->sub_if_list, list)
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		netif_stop_queue(sdata->dev);
+		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA &&
+		    sdata->u.sta.associated)
+			ieee80211_send_nullfunc(local, sdata, 1);
+	}
 	spin_unlock_bh(&local->sub_if_lock);
=20
 	if (ssid) {
@@ -2706,7 +2740,8 @@ static int ieee80211_sta_start_scan(stru
 					 list);
 	local->scan_channel_idx =3D 0;
 	local->scan_dev =3D dev;
=2D	schedule_delayed_work(&local->scan_work, 0);
+	/* TODO: start scan as soon as all nullfunc frames are ACKed */
+	schedule_delayed_work(&local->scan_work, IEEE80211_CHANNEL_TIME);
=20
 	return 0;
 }

--nextPart1870306.LCFWj25hOa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5fdAT3Oqt9AH4aERAm+iAKCJ+PI1NTUbr64gWOKGa5yX5VO1WwCeOVPK
XRrVYQ6C8KaERvjdhGdM8A8=
=GoCz
-----END PGP SIGNATURE-----

--nextPart1870306.LCFWj25hOa--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
