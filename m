Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38427 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKXPT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 10:19:29 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Date: Mon, 24 Nov 2008 16:19:28 +0100
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <f76a32050811210612i13ee251ewd6c1cab616a62529@mail.gmail.com> <1227533874.2927.2.camel@johannes.berg>
In-Reply-To: <1227533874.2927.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AYsKJ4BHD3Egug7"
Message-Id: <200811241619.28606.chunkeey@web.de> (sfid-20081124_161934_533658_CB179304)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_AYsKJ4BHD3Egug7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 24 November 2008 14:37:54 Johannes Berg wrote:
> On Fri, 2008-11-21 at 15:12 +0100, Stefan Steuerwald wrote:
> 
> > - frame 7: http request
> > - frame 13: iPod goes to sleep
> > - frame 23: AP beacon indicates traffic for iPod (AID 1 in TIM)
> 
> in 24 too, the ipod probably didn't see the beacon in frame 23 even
> though 23 was a dtim beacon (which is a bit odd, but maybe the ipod
> doesn't care about mcast at this point)
> 
> > - frame 25: iPod wakes up
> 
> 26: ack from the AP
> 
> > - in between: MISSING DATA ???
> > - frame 27: AP beacon with no traffic indicated ???
> > - frame 29: iPod goes to sleep again
> > - subsequent frames: repetitions of this, until the TCP connection is closed
> > 
> > My understanding is that the AP would not indicate any traffic without
> > actually having some ready to send? Wrong assumption?
> 
> Indeed. Christian, is it possible that the p54 device is actually
> filtering these frames? I'm pretty sure mac80211 behaves correctly, and
> it unsetting the TIM bit means that it must no longer have traffic
> buffered.
As far as I know it works like this:
If a frame with a the PS-Bit in the FC set is received, the firmware
will mark the source mac / aid as "sleeping". And every frame from
this moment on for this device will be buffered.

To remove the "mark" again, the driver has to call p54_sta_unlock.
And the firmware will send out all buffered frames.
Or if we only need for one frame (e.g: probe resp) we have a tx_flag (_NO_CANCEL)

If for some reason the "mark" doesn't get removed the firmware will eventually timeout
the stuck frame and sets a the P54_TX_PSM_CANCELLED flag in tx_status.
And we pass this on to the mac with IEEE80211_TX_STAT_TX_FILTERED.

one thing: p54 reports the tx_status through the rx-ring-buffer.
so I hope there's no rx/tx race here since everything is in the same "boat" here.

based on that:
I made two different patches to address the problem.

one fiddles with mac80211 only (set-and-clear.diff).
It assumes that if a station comes out of PS, we have to set
the CLEAR_PS_FILT on the same time we clear the WLAN_STA_PS.

the other one is only for p54 (p54-sta-flags.diff)... Doesn't do very much,
it just checks if the CLEAR_PS_FILT is set and then sets the
NO_CANCEL flag on that frame, so the firmware won't buffer it.

Of course you can test both patches on the same time, if it doesn't help.

And finally of course, I could be totally wrong and this is all nothing but useless gibberish.

Regards,
	Chr

BTW: I couldn't test the patches, so it may OOps

--Boundary-00=_AYsKJ4BHD3Egug7
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="set-and-clear.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="set-and-clear.diff"

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..077fdb7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -657,7 +657,8 @@ static void ap_sta_ps_start(struct sta_info *sta)
 	DECLARE_MAC_BUF(mac);
 
 	atomic_inc(&sdata->bss->num_sta_ps);
-	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
+	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL |
+				WLAN_STA_CLEAR_PS_FILT);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -674,7 +675,8 @@ static int ap_sta_ps_end(struct sta_info *sta)
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
-	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	set_and_clear_sta_flags(sta, WLAN_STA_CLEAR_PS_FILT,
+				WLAN_STA_PS | WLAN_STA_PSPOLL);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);

--Boundary-00=_AYsKJ4BHD3Egug7
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54-sta-flags.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-sta-flags.diff"

diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-24 13:07:09.053832187 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-24 16:03:26.862045588 +0100
@@ -1067,9 +1067,15 @@ static int p54_tx_fill(struct ieee80211_
 			*queue = 3;
 			return 0;
 		}
-		if (info->control.sta)
+		if (info->control.sta) {
+			if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
+				ret = p54_sta_unlock(dev, info->control.sta->addr);
+				if (ret)
+					return ret;
+				*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			}
 			*aid = info->control.sta->aid;
-		else
+		} else
 			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 	}
 	return ret;
@@ -1083,7 +1089,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len, tim_len = 0;
-	int i, j, ridx;
+	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue;
 	u8 cts_rate = 0x20;
@@ -1093,7 +1099,10 @@ static int p54_tx(struct ieee80211_hw *d
 
 	queue = skb_get_queue_mapping(skb);
 
-	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
+	ret = p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid);
+	if (ret < 0)
+		return NETDEV_TX_BUSY;
+	if (ret) {
 		current_queue = &priv->tx_stats[queue];
 		if (unlikely(current_queue->len > current_queue->limit))
 			return NETDEV_TX_BUSY;
@@ -1106,17 +1115,6 @@ static int p54_tx(struct ieee80211_hw *d
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
-	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
-		if (info->control.sta)
-			if (p54_sta_unlock(dev, info->control.sta->addr)) {
-				if (current_queue) {
-					current_queue->len--;
-					current_queue->count--;
-				}
-				return NETDEV_TX_BUSY;
-			}
-	}
-
 	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 

--Boundary-00=_AYsKJ4BHD3Egug7--
