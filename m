Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43124 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752321AbXCAFnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 00:43:35 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 5/5] d80211: switch STA interfaces to PS mode during scan
Date: Thu, 1 Mar 2007 00:43:10 -0500
Cc: "Jouni Malinen" <jkm@devicescape.com>,
	linux-wireless@vger.kernel.org
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <200702281642.24404.flamingice@sourmilk.net> <200702281644.42038.flamingice@sourmilk.net>
In-Reply-To: <200702281644.42038.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1534455.Wv1Be8lvB8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703010043.10565.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1534455.Wv1Be8lvB8
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 28 February 2007 16:44, Michael Wu wrote:
> On Wednesday 28 February 2007 16:42, Michael Wu wrote:
> > This makes scans switch STA interfaces into PS mode so the AP queues
> > frames destined for us while we are scanning. This is achieved by sendi=
ng
> > a nullfunc data frame with the PS mode bit set before scanning commence=
s,
> > and a PS poll frame after scanning is completed.
>
> Er. I should update the description too..
>
And drop the ps_poll part since we don't use the ps poll frame now..

=2D-

d80211: switch STA interfaces to PS mode during scan

=46rom: Michael Wu <flamingice@sourmilk.net>

This makes scans switch STA interfaces into PS mode so the AP queues frames
destined for us while we are scanning. This is achieved by sending a
nullfunc data frame with the PS mode bit set before scanning commences,
and a nullfunc data frame without the PS mode bit set after scanning is
completed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_sta.c |   51 +++++++++++++++++++++++++++++++++++---=
=2D---
 1 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index ce7dc28..087f176 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2520,6 +2520,37 @@ int ieee80211_sta_set_bssid(struct net_d
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
@@ -2541,10 +2572,12 @@ void ieee80211_scan_completed(struct iee
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
@@ -2664,9 +2697,6 @@ static int ieee80211_sta_start_scan(stru
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
=20
=2D	/* TODO: if assoc, move to power save mode for the duration of the
=2D	 * scan */
=2D
 	if (local->sta_scanning) {
 		if (local->scan_dev =3D=3D dev)
 			return 0;
@@ -2688,8 +2718,12 @@ static int ieee80211_sta_start_scan(stru
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
@@ -2703,7 +2737,8 @@ static int ieee80211_sta_start_scan(stru
 					 list);
 	local->scan_channel_idx =3D 0;
 	local->scan_dev =3D dev;
=2D	schedule_delayed_work(&local->scan_work, 0);
+	/* TODO: start scan as soon as all nullfunc frames are ACKed */
+	schedule_delayed_work(&local->scan_work, IEEE80211_CHANNEL_TIME);
=20
 	return 0;
 }

--nextPart1534455.Wv1Be8lvB8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5mfuT3Oqt9AH4aERAkj0AJ9gGPLoku8L6FX1M5CoctRjqB5lqQCfeb2B
18BvbDS9PwLH8s7hCghPtnY=
=XpxA
-----END PGP SIGNATURE-----

--nextPart1534455.Wv1Be8lvB8--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
