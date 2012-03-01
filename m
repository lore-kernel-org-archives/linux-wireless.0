Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57557 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2CALme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 06:42:34 -0500
Message-ID: <4F4F60A0.5040006@qca.qualcomm.com> (sfid-20120301_124247_455427_A38E2A0E)
Date: Thu, 1 Mar 2012 17:12:24 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<senthilb@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>,
	<rodrigue@qca.qualcomm.com>,
	Rajkumar_contact <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
Subject: Re: [RFC 1/2] ath9k: use ieee80211_free_txskb
References: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com> <4F4F0B83.9050203@qca.qualcomm.com>
In-Reply-To: <4F4F0B83.9050203@qca.qualcomm.com>
Content-Type: multipart/mixed;
	boundary="------------030301020603050900000702"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------030301020603050900000702
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On Thursday 01 March 2012 11:09 AM, Mohammed Shafi Shajakhan wrote:
> Hi Christian,
>
> On Monday 27 February 2012 09:40 PM, Christian Lamparter wrote:
>> With the new tx status API: "mac80211: implement wifi TX status"
>> All skb originating from mac80211 needs to be given back to mac80211.
>>
>> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
>> ---
>> It's high time we change all calls in the tx-path from
>> dev_kfree_skb into ieee80211_free_txskb.
>>
>> The call in ath9k_tx is straightforward, but the one in
>> ath_tx_setup_buffer gives me headaches. I'm not sure if
>> we even need to check bf->bf_state.bfs_paprd at this
>> stage since ath_tx_start_dma sets bf->bf_state.bfs_paprd
>> "after" calling ath_tx_setup_buffer?!
>
> yes, i think its a problem, we cannot exactly say its the skb from
> mac80211 (or) its our PAPRD skb. though with the current code(as the
> PAPRD) is disabled the skb would be always from mac80211. let us see if
> we have some good solution.


got some idea, need to make sure this works perfectly, paprd frames are 
not aggregated, so we can look only at the non-aggregated path.

lets ignore aggregated path:

*ath_tx_form_aggr
*ath_tx_send_ampdu


non-aggregated path :

*ath_tx_start_dma
*ath_send_normal

->  'ath_tx_setup_buffer' called from 'ath_tx_start_dma' can have a 
'is_paprd' check based on 'txctl->paprd' which holds which chain we are 
sending PAPRD frame.

-> 'ath_send_normal' called from
                                  -ath_tx_start_dma ( then 'bf' should 
be valid and we would not have called 'ath_tx_setup_buffer'
				 -ath_tx_flush_tid ( which is an aggregation path) ignore it.


attached rough patch for ath9k, need to be compiled and tested. i will 
also analyze if this can be done in a better way or any flaws in it


>>
>> Regards,
>> Chr
>> ---
>> drivers/net/wireless/ath/ath9k/main.c | 2 +-
>> drivers/net/wireless/ath/ath9k/xmit.c | 6 +++++-
>> 2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c
>> b/drivers/net/wireless/ath/ath9k/main.c
>> index c81304d..4471ed9 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -1162,7 +1162,7 @@ static void ath9k_tx(struct ieee80211_hw *hw,
>> struct sk_buff *skb)
>>
>> return;
>> exit:
>> - dev_kfree_skb_any(skb);
>> + ieee80211_free_txskb(sc->hw, skb);
>> }
>>
>> static void ath9k_stop(struct ieee80211_hw *hw)
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
>> b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 3182408..0dadbc3 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -1858,7 +1858,11 @@ static struct ath_buf
>> *ath_tx_setup_buffer(struct ath_softc *sc,
>> return bf;
>>
>> error:
>> - dev_kfree_skb_any(skb);
>> +
>> + if (bf->bf_state.bfs_paprd)
>> + dev_kfree_skb_any(skb);
>> + else
>> + ieee80211_free_txskb(sc->hw, skb);
>> return NULL;
>> }
>>
>
>


-- 
thanks,
shafi

--------------030301020603050900000702
Content-Type: text/x-patch; name="use-mac80211-api-freeing-skb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="use-mac80211-api-freeing-skb.patch"

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 02e95c8..1a37a43 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1148,7 +1148,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	return;
 exit:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(sc->hw, skb);
 }
 
 static void ath9k_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5dd27d2..699086c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -811,7 +811,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 		if (!fi->bf)
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb, false);
 
 		if (!bf)
 			continue;
@@ -1728,7 +1728,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		return;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 	if (!bf)
 		return;
 
@@ -1752,10 +1752,12 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct list_head bf_head;
 	struct ath_buf *bf;
+	bool is_paprd = false;
 
 	bf = fi->bf;
+
 	if (!bf)
-		bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+		bf = ath_tx_setup_buffer(sc, txq, tid, skb, false);
 
 	if (!bf)
 		return;
@@ -1816,7 +1818,8 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   bool is_paprd)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
@@ -1857,7 +1860,11 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	return bf;
 
 error:
-	dev_kfree_skb_any(skb);
+	if (is_paprd)
+		dev_kfree_skb_any(skb);
+	else
+		ieee80211_free_txskb(sc->hw, skb);
+
 	return NULL;
 }
 
@@ -1870,6 +1877,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
 	u8 tidno;
+	bool is_paprd = false;
 
 	if ((sc->sc_flags & SC_OP_TXAGGR) && txctl->an &&
 		ieee80211_is_data_qos(hdr->frame_control)) {
@@ -1887,7 +1895,10 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 		 */
 		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		if (txctl->paprd)
+			is_paprd = true;
+
+		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, is_paprd);
 		if (!bf)
 			return;
 

--------------030301020603050900000702--
