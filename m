Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1845 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767Ab0KVHA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 02:00:58 -0500
Message-ID: <4CEA1527.5030502@gmail.com>
Date: Mon, 22 Nov 2010 08:00:55 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data
 two-byte alignment
References: <201011131908.15595.IvDoorn@gmail.com> <20101117150721.GD2639@tuxdriver.com> <AANLkTimCzzgMavoLNhWTE-bZNTMimg++VKKft5f8sDQG@mail.gmail.com> <201011171741.15796.helmut.schaa@googlemail.com>
In-Reply-To: <201011171741.15796.helmut.schaa@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------040706050607010503040103"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040706050607010503040103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/17/10 17:41, Helmut Schaa wrote:
> Am Mittwoch 17 November 2010 schrieb Gertjan van Wingerde:
>> On Wed, Nov 17, 2010 at 4:07 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>>> On Wed, Nov 17, 2010 at 11:48:04AM +0100, Helmut Schaa wrote:
>>>
>>>> John, should I send a follow-up (with a nice description why it this is needed)
>>>> or are you simply reverting this one?
>>>
>>> Is there no chance for a fix in short order?
> 
> I don't have a clever idea on how to fix that without reverting this commit.
> IMO this patch is just not correct as it passes the skb back to mac80211 with
> reduced headroom (due to the header & payload alignment) which causes trouble
> when mac80211 requeues the frame. Of course just requesting 4 additional bytes
> headroom would "fix" the symptoms but sounds like a hack to me.
> 
>> I may have an idea on how we can fix this, without incurring the
>> performance penalty.
> 
> I'm still not convinced that this is really the root cause for the
> performance issues Jay noticed. AFAIK mac80211 doesn't access the payload
> anymore when reporting the frame back (with some exceptions like monitor
> interfaces).
> 
> Jay, could you please run a few more performance tests with and without this
> patch to track down if this issue is really the cause for the performance
> degradation?
> 
>> Basic idea is to no longer work on the original skb that mac80211
>> supplied us, but to
>> use a copy of that skb. This would prevent us from having to undo any
>> changes we did,
>> as we can simply return the original skb to mac80211 (which wasn't
>> modified in the first
>> place).
>> I'm not sure how this would impact performance, but it would allow us
>> a lot less copying
>> around to undo the changes done before uploading to the HW.
> 
> But cloning the skb would double the amount of memory needed to transmit each
> frame. Not sure though if that behaves better or not. Might be worth a try.
> 
>> However, I won't be able to look into that opportunity before the weekend.
>>
>> Helmut, can you wait that long and hold off reverting until then?
> 

OK. Find attached the patch I cooked up. AFAICS the driver still works correctly,
but unfortunately I am unable to test performance and throughput of the driver
with this patch.

Jay and Helmut, can you test this patch before I submit it?

---
Gertjan.

--------------040706050607010503040103
Content-Type: text/plain;
 name="0001-rt2x00-Ensure-TX-ed-skbs-are-returned-to-mac80211-in.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rt2x00-Ensure-TX-ed-skbs-are-returned-to-mac80211-in.pa";
 filename*1="tch"

>From 52beaf9b38475520bfdc2eea920fc7f45993bba4 Mon Sep 17 00:00:00 2001
From: Gertjan van Wingerde <gwingerde@gmail.com>
Date: Sun, 21 Nov 2010 17:45:14 +0100
Subject: [PATCH] rt2x00: Ensure TX-ed skbs are returned to mac80211 in original state.

Instead of moving the buffer around make sure that we return the skb in its
original state, by using an internal copy of the skb inside rt2x00.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   41 +++++------------------------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   12 +++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    3 ++
 3 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c879f9a..ac8d84a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -247,10 +247,10 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb_orig);
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
-	unsigned int header_length, i;
+	unsigned int i;
 	u8 rate_idx, rate_flags, retry_rates;
 	u8 skbdesc_flags = skbdesc->flags;
 	bool success;
@@ -261,36 +261,6 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	rt2x00queue_unmap_skb(entry);
 
 	/*
-	 * Remove the extra tx headroom from the skb.
-	 */
-	skb_pull(entry->skb, rt2x00dev->ops->extra_tx_headroom);
-
-	/*
-	 * Signal that the TX descriptor is no longer in the skb.
-	 */
-	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
-
-	/*
-	 * Determine the length of 802.11 header.
-	 */
-	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-
-	/*
-	 * Remove L2 padding which was added during
-	 */
-	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
-		rt2x00queue_remove_l2pad(entry->skb, header_length);
-
-	/*
-	 * If the IV/EIV data was stripped from the frame before it was
-	 * passed to the hardware, we should now reinsert it again because
-	 * mac80211 will expect the same data to be present it the
-	 * frame as it was passed to us.
-	 */
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
-		rt2x00crypto_tx_insert_iv(entry->skb, header_length);
-
-	/*
 	 * Send frame to debugfs immediately, after this call is completed
 	 * we are going to overwrite the skb->cb array.
 	 */
@@ -380,14 +350,17 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * send the status report back.
 	 */
 	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
-		ieee80211_tx_status(rt2x00dev->hw, entry->skb);
+		ieee80211_tx_status(rt2x00dev->hw, entry->skb_orig);
 	else
-		dev_kfree_skb_any(entry->skb);
+		dev_kfree_skb_any(entry->skb_orig);
+
+	dev_kfree_skb_any(entry->skb);
 
 	/*
 	 * Make this entry available for reuse.
 	 */
 	entry->skb = NULL;
+	entry->skb_orig = NULL;
 	entry->flags = 0;
 
 	rt2x00dev->ops->lib->clear_entry(entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a3d79c7..4b356b2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -497,7 +497,14 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	entry->skb = skb;
+	entry->skb_orig = skb;
+	entry->skb = skb_copy(entry->skb_orig, GFP_KERNEL);
+	if (!entry->skb) {
+		ERROR(queue->rt2x00dev,
+		      "Failed to allocated copy of the frame.\n");
+		return -ENOMEM;
+	}
+
 	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
 	/*
@@ -550,7 +557,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 */
 	if (unlikely(rt2x00queue_write_tx_data(entry, &txdesc))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		entry->skb = NULL;
+		dev_kfree_skb_any(entry->skb);
+		entry->skb_orig = NULL;
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 29b051a..abc1e0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -355,6 +355,7 @@ enum queue_entry_flags {
  * @queue: The data queue (&struct data_queue) to which this entry belongs.
  * @skb: The buffer which is currently being transmitted (for TX queue),
  *	or used to directly recieve data in (for RX queue).
+ * @skb_orig: The buffer that we received from mac80211 (for TX; unused for RX).
  * @entry_idx: The entry index number.
  * @priv_data: Private data belonging to this queue entry. The pointer
  *	points to data specific to a particular driver and queue type.
@@ -366,6 +367,8 @@ struct queue_entry {
 
 	struct sk_buff *skb;
 
+	struct sk_buff *skb_orig;
+
 	unsigned int entry_idx;
 
 	void *priv_data;
-- 
1.7.3.2


--------------040706050607010503040103--
