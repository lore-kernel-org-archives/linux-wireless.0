Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61171 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab3CNNIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 09:08:38 -0400
Received: by mail-ee0-f45.google.com with SMTP id b57so1053020eek.32
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 06:08:36 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Reply-To: isedev@gmail.com
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4312 / b43 DMA transmission sequence errors
Date: Thu, 14 Mar 2013 14:08:33 +0100
Message-ID: <4530943.RJ7WpUJOSz@wks001.ise.net> (sfid-20130314_140842_043226_21139E6A)
In-Reply-To: <51413800.6050300@lwfinger.net>
References: <1695808.c7XUjJpf0R@wks001.ise.net> <1476129.oNtxuF3Ght@wks001.ise.net> <51413800.6050300@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 Mar 2013 21:37:52 Larry Finger wrote:
> On 03/13/2013 08:06 PM, ISE Development wrote:
> 
> >
> > I've hacked the driver to 'skip' one header and data frame if receiving an interrupt for the first slot + 2. It's not pretty and I have literally no idea if it will causes other problems, but it has allowed me to keep the Wifi connection up for a little over 3 hours now (as compared to the 45 seconds previously). It does not appear to be corrupting the data stream (checked by download large signed binaries and verifying the signature) and as far as my limited knowledge can tell, it should not be causing a memory leak.
> >
> > The patch is listed below, for reference. However, I do not claim that it is valid, safe or even reasonsable. It does provide me with much needed relief though.
> >
> > The diff is against the current head of linville/wireless-testing.git (d41d9c7419e3ac9c81841f43bbd7639dd0a5819e).
> >
> 
> I am testing the patch on BCM4312 and other cards.
> 
> Larry
> 

Here's a slighted cleaner version, with comments, in case you are considering integrating it.

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 38bc5a7..edc759d 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1489,6 +1489,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
        struct b43_dmadesc_meta *meta;
        int slot, firstused;
        bool frame_succeed;
+       int skip;
 
        ring = parse_cookie(dev, status->cookie, &slot);
        if (unlikely(!ring))
@@ -1501,13 +1502,22 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
        firstused = ring->current_slot - ring->used_slots + 1;
        if (firstused < 0)
                firstused = ring->nr_slots + firstused;
+
+       skip = 0;
        if (unlikely(slot != firstused)) {
                /* This possibly is a firmware bug and will result in
                 * malfunction, memory leaks and/or stall of DMA functionality. */
                b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
                       "Expected %d, but got %d\n",
                       ring->index, firstused, slot);
-               return;
+               if(slot == firstused + 2) {
+                       /* If a single header/data pair was missed, skip over the first
+                        * two slots in an attempt to recover. */
+                       slot = firstused;
+                       skip = 2;
+               } else {
+                       return;
+               }
        }
 
        ops = ring->ops;
@@ -1522,6 +1532,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
                               slot, firstused, ring->index);
                        break;
                }
+
                if (meta->skb) {
                        struct b43_private_tx_info *priv_info =
                                b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
@@ -1552,7 +1563,18 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
                         * Call back to inform the ieee80211 subsystem about
                         * the status of the transmission.
                         */
-                       frame_succeed = b43_fill_txstatus_report(dev, info, status);
+                       if(!skip)
+                       {
+                               frame_succeed = b43_fill_txstatus_report(dev, info, status);
+                       }
+                       else
+                       {
+                           /* When skipping over a missed TX status report, use a status
+                            * structure which indicates that the frame was not sent
+                            * (frame_count 0) and not acknowledged */
+                               struct b43_txstatus fake = B43_FAKE_TXSTATUS;
+                               frame_succeed = b43_fill_txstatus_report(dev, info, &fake);
+                       }
 #ifdef CONFIG_B43_DEBUG
                        if (frame_succeed)
                                ring->nr_succeed_tx_packets++;
@@ -1580,12 +1602,14 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
                /* Everything unmapped and free'd. So it's not used anymore. */
                ring->used_slots--;
 
-               if (meta->is_last_fragment) {
+               if (meta->is_last_fragment && !skip) {
                        /* This is the last scatter-gather
                         * fragment of the frame. We are done. */
                        break;
                }
                slot = next_slot(ring, slot);
+               if(skip > 0)
+                       --skip;
        }
        if (ring->stopped) {
                B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 98d9074..eae730c 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -218,6 +218,9 @@ struct b43_txstatus {
        u8 acked;               /* Wireless ACK received */
 };
 
+/* This needs to match the b43_txstatus structure above, all zeroed-out */
+#define B43_FAKE_TXSTATUS { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
+
 /* txstatus supp_reason values */
 enum {
        B43_TXST_SUPP_NONE,     /* Not suppressed */


-- 
-- isedev
