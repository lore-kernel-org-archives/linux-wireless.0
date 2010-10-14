Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51348 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0JNWrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:47:18 -0400
Message-ID: <4CB78870.8040207@candelatech.com>
Date: Thu, 14 Oct 2010 15:47:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAE1DFB.303@candelatech.com>	<1286479642.20974.32.camel@jlt3.sipsolutions.net>	<AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>	<AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>	<AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>	<4CB378CD.1080800@candelatech.com>	<AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>	<4CB3D598.7050904@candelatech.com>	<AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>	<4CB4AA89.1070009@candelatech.com>	<20101013053141.GA15798@vasanth-laptop>	<4CB5E0A8.5020502@candelatech.com>	<AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
In-Reply-To: <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 02:52 PM, Björn Smedman wrote:
> 2010/10/13 Björn Smedman<bjorn.smedman@venatech.se>:
>> Hi Ben,
>>
>> First of all keep up the good work. :)
>>
>> On Wed, Oct 13, 2010 at 6:39 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> [snip]
>>> Either way, it seems safer to null out the bf_ampdu field after
>>> the memory is consumed..it could prevent some tricky bugs later.
>>
>> I think this is a good idea. But it probably wont be enough to null
>> out bf_mpdu. You also need to look at bf_buf_addr (which if I
>> understand correctly is the physical address the DMA engine will
>> actually write RXed frames to) and bf_dmacontext (which seems in most
>> cases to hold an identical address and may in fact be where the DMA
>> engine will really write the frame).
>
> I took another look at the code. It turns out both bf_buf_addr and
> bf_dmacontext are in fact meaningless to the DMA. Instead each bf
> holds a pointer (bf_desc) to the real DMA descriptor which in turn
> holds the address (ds_data) where the DMA will really (really this
> time) write the frame. There is also a field to hold the virtual
> address of the same place (ds_vdata).
>
> It's a little too much work for me to set up the testbed you have Ben
> but would be interesting to see what happens if you set
> bf->bf_desc->ds_{data,vdata} = 0 as well. No?

I tried the patch below, and it didn't seem to help.  Might even
have hurt..as it died on divide-by-zero error:

Call Trace:
  [<c075e490>] ? printk+0xf/0x17
  [<c075e37e>] panic+0x50/0x153
  [<c07619db>] oops_end+0x92/0xa1
  [<c04051cc>] die+0x53/0x59
  [<c07612a3>] do_trap+0x89/0xa2
  [<c0403b12>] ? do_divide_error+0x0/0x78
  [<c0403b80>] do_divide_error+0x6e/0x78
  [<faef811e>] ? ath9k_hw_ani_monitor+0x37/0x40e [ath9k_hw]
  [<fb1f77d9>] ? ath9k_ioread32+0x25/0x5b [ath9k]
  [<c045553a>] ? trace_hardirqs_off+0xb/0xd
  [<c0581210>] ? trace_hardirqs_off_thunk+0xc/0x10
  [<c076103f>] error_code+0x5f/0x70
  [<c0403b12>] ? do_divide_error+0x0/0x78
  [<faef811e>] ? ath9k_hw_ani_monitor+0x37/0x40e [ath9k_hw]
  [<fb1fa783>] ath_ani_calibrate+0x143/0x20b [ath9k]
  [<c043d58f>] run_timer_softirq+0x14f/0x1e7

That might be an existing bug, however...

Thanks,
Ben

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0c917e5..8fba13d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -737,4 +737,6 @@ bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
  void ath_start_rfkill_poll(struct ath_softc *sc);
  extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);

+void ath_clear_dma_ptrs(struct ath_buf *bf);
+
  #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 97d471f..cc406f9 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -139,7 +139,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
                 dma_unmap_single(sc->dev, bf->bf_buf_addr,
                                  skb->len, DMA_TO_DEVICE);
                 dev_kfree_skb_any(skb);
-               bf->bf_buf_addr = 0;
+               ath_clear_dma_ptrs(bf);
         }

         /* Get a new beacon from mac80211 */
@@ -167,8 +167,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
                                          skb->len, DMA_TO_DEVICE);
         if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
                 dev_kfree_skb_any(skb);
-               bf->bf_mpdu = NULL;
-               bf->bf_buf_addr = 0;
+               ath_clear_dma_ptrs(bf);
                 ath_print(common, ATH_DBG_FATAL,
                           "dma_mapping_error on beaconing\n");
                 return NULL;
@@ -256,8 +255,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
                 dma_unmap_single(sc->dev, bf->bf_buf_addr,
                                  skb->len, DMA_TO_DEVICE);
                 dev_kfree_skb_any(skb);
-               bf->bf_mpdu = NULL;
-               bf->bf_buf_addr = 0;
+               ath_clear_dma_ptrs(bf);
         }

         /* NB: the beacon data buffer must be 32-bit aligned. */
@@ -302,8 +300,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
                                          skb->len, DMA_TO_DEVICE);
         if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
                 dev_kfree_skb_any(skb);
-               bf->bf_mpdu = NULL;
-               bf->bf_buf_addr = 0;
+               ath_clear_dma_ptrs(bf);
                 ath_print(common, ATH_DBG_FATAL,
                           "dma_mapping_error on beacon alloc\n");
                 return -ENOMEM;
@@ -329,8 +326,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
                         dma_unmap_single(sc->dev, bf->bf_buf_addr,
                                          skb->len, DMA_TO_DEVICE);
                         dev_kfree_skb_any(skb);
-                       bf->bf_mpdu = NULL;
-                       bf->bf_buf_addr = 0;
+                       ath_clear_dma_ptrs(bf);
                 }
                 list_add_tail(&bf->list, &sc->beacon.bbuf);

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bcd3892..1722a21 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -213,6 +213,17 @@ static void ath_update_survey_stats(struct ath_softc *sc)
         ath_update_survey_nf(sc, pos);
  }

+void ath_clear_dma_ptrs(struct ath_buf *bf)
+{
+       struct ath_desc *ds = bf->bf_desc;
+       bf->bf_buf_addr = 0;
+       bf->bf_mpdu = NULL;
+       if (ds) {
+               ds->ds_data = 0;
+               ds->ds_vdata = NULL;
+       }
+}
+
  /*
   * Set/change channels.  If the channel is really being changed, it's done
   * by reseting the chip.  To accomplish this we must first cleanup any pending
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fd778d2..5afb46f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -269,8 +269,7 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
                 if (unlikely(dma_mapping_error(sc->dev,
                                                 bf->bf_buf_addr))) {
                                 dev_kfree_skb_any(skb);
-                               bf->bf_mpdu = NULL;
-                               bf->bf_buf_addr = 0;
+                               ath_clear_dma_ptrs(bf);
                                 ath_print(common, ATH_DBG_FATAL,
                                         "dma_mapping_error() on RX init\n");
                                 error = -ENOMEM;
@@ -360,8 +359,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
                         if (unlikely(dma_mapping_error(sc->dev,
                                                         bf->bf_buf_addr))) {
                                 dev_kfree_skb_any(skb);
-                               bf->bf_mpdu = NULL;
-                               bf->bf_buf_addr = 0;
+                               ath_clear_dma_ptrs(bf);
                                 ath_print(common, ATH_DBG_FATAL,
                                           "dma_mapping_error() on RX init\n");
                                 error = -ENOMEM;
@@ -396,8 +394,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
                                                 common->rx_bufsize,
                                                 DMA_FROM_DEVICE);
                                 dev_kfree_skb(skb);
-                               bf->bf_buf_addr = 0;
-                               bf->bf_mpdu = NULL;
+                               ath_clear_dma_ptrs(bf);
                         }
                 }

@@ -1741,8 +1738,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
                 if (unlikely(dma_mapping_error(sc->dev,
                           bf->bf_buf_addr))) {
                         dev_kfree_skb_any(requeue_skb);
-                       bf->bf_mpdu = NULL;
-                       bf->bf_buf_addr = 0;
+                       ath_clear_dma_ptrs(bf);
                         ath_print(common, ATH_DBG_FATAL,
                                   "dma_mapping_error() on RX\n");
                         ath_rx_send_to_mac80211(hw, sc, skb, rxs);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a5e5f27..e86f59c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1644,8 +1644,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
         bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
                                          skb->len, DMA_TO_DEVICE);
         if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
-               bf->bf_mpdu = NULL;
-               bf->bf_buf_addr = 0;
+               ath_clear_dma_ptrs(bf);
                 ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
                           "dma_mapping_error() on TX\n");
                 return -ENOMEM;
@@ -1915,7 +1914,6 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
         }

         dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
-       bf->bf_buf_addr = 0;

         if (bf->bf_state.bfs_paprd) {
                 if (time_after(jiffies,
@@ -1931,7 +1929,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
         /* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
          * accidentally reference it later.
          */
-       bf->bf_mpdu = NULL;
+       ath_clear_dma_ptrs(bf);

         /*
          * Return the list of ath_buf of this mpdu to free queue


>
> /Björn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

