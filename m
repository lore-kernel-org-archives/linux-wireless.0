Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39484 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0K2RPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 12:15:18 -0500
Received: by bwz15 with SMTP id 15so4111746bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 09:15:16 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: [RFC] mac80211: filter multicast rx (was: Re: carl9170: wnda3100 only 54MB/s)
Date: Mon, 29 Nov 2010 18:14:57 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <AANLkTimXGQLnSaU6ASeRPkw1YThF18_zC7peu_uCeGKU@mail.gmail.com> <201010021332.09809.chunkeey@googlemail.com>
In-Reply-To: <201010021332.09809.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011291814.58230.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 October 2010 13:32:09 Christian Lamparter wrote:
> On Saturday 02 October 2010 08:18:07 Saqeb Akhter wrote:
> > I guess you were right about it being unstable - almost unusable for
> > video streaming.
> Video streaming? Does your application use QoS AC_VI(deo) for streaming,
> or just bulk data (AC_BE(st effort))?
> 
> > sakhter@sakhter-laptop:~$ dmesg | grep Reason
> > [ 1166.512087] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 1526.059997] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 2125.324356] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 2845.783011] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 3565.994832] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 5128.903576] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 5726.046230] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 6326.042938] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 6835.689445] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > [ 7197.337060] wlan1: deauthenticated from 30:46:9a:10:49:f7 (Reason: 7)
> > 
> > Seems to disconnect quite frequently. Even tried uninstalling networkmanager.
> Reason 7 is: [AP received a] class 3 (data) frame from non-associated STA.
> This can happen when your are "actively" disassociating from the AP (unlikely),
> when the AP thinks you are out-of-reach(unlikely, since your signal seems to
> be strong and PSM isn't enabled by default) or when the AP crashes and resets.
> 
I think I found the reason. Apparently, there's something wrong with the AES
engine. As you may know, as soon as the hwcrypto is disabled, the problem
"magically" disappears... It looks like carl9170 (and otus?) is generating
frames with slightly bogus SA/TA addresses.

e.g.:

(the correct SA/TA would be: 00:1f:31:f8:64:ff)
[ 2314.402316] Ignore 9f:1f:31:f8:64:ff
[ 2314.402321] Ignore 9f:1f:31:f8:64:ff
[ 2352.453804] Ignore 0d:1f:31:f8:64:ff
[ 2352.453808] Ignore 0d:1f:31:f8:64:ff
					   ^ notice: the group address flag!

Since the AP doesn't know from where the frame comes from, it creates
a valid DEAUTH (with the correct reason: 7). Because the RA/DA looks
too similar for the hardware/software filters to discard, the stack
thinks it was kicked by the AP...

The attached patch -for now- only "enhances" mac80211's rx frame filter
when operating as a station (what about mesh, adhoc?). The filter takes
a closer look at each multicast frame and verifies that the group
address is listed in the multicast list before processing it.

Best regards,
	Christian
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2fcd22..fe99d66 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2543,8 +2543,21 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	ieee80211_rx_handlers(&rx, &frames);
 }
 
-/* main receive path */
+static bool check_mc_group(struct ieee80211_local *local,
+			   u8 *da)
+{
+	struct netdev_hw_addr *ha;
+	if (is_broadcast_ether_addr(da))
+		return true;
 
+	netdev_hw_addr_list_for_each(ha, &local->mc_list) {
+		if (compare_ether_addr(ha->addr, da) == 0)
+			return true;
+	}
+	return false;
+}
+
+/* main receive path */
 static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
@@ -2558,8 +2571,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 	case NL80211_IFTYPE_STATION:
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return 0;
-		if (!multicast &&
-		    compare_ether_addr(sdata->vif.addr, hdr->addr1) != 0) {
+		if ((!multicast &&
+		    compare_ether_addr(sdata->vif.addr, hdr->addr1) != 0) ||
+		    (multicast && !check_mc_group(rx->local, hdr->addr1))) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
