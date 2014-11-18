Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42845 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaKRN60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 08:58:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath10k: unify rx undecapping
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
	<1415110931-10945-5-git-send-email-michal.kazior@tieto.com>
	<87ppclq4mu.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=Ws0JGsVBd2J0fe2_JqAhCVpHmNkn10CJx6BCNG-r0cg@mail.gmail.com>
	<87vbmdoo9q.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQm1tzJhz7HtF941z8hrkOpyCpfJhqzmx1tifVFCMo=R1A@mail.gmail.com>
Date: Tue, 18 Nov 2014 15:58:19 +0200
In-Reply-To: <CA+BoTQm1tzJhz7HtF941z8hrkOpyCpfJhqzmx1tifVFCMo=R1A@mail.gmail.com>
	(Michal Kazior's message of "Tue, 18 Nov 2014 07:46:35 +0100")
Message-ID: <87r3x0k3us.fsf@kamboji.qca.qualcomm.com> (sfid-20141118_145829_569017_FE15E557)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 17 November 2014 16:11, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>> On 17 November 2014 15:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>>>> This patch had few checkpatch warnings. I fixed them with the folded
>>>> patch and full patch here:
>>>>
>>>> https://github.com/kvalo/ath/commit/71fbd07d43e54f5f9f442bc5f2f4f9ef83aead63
> [...]
>>>> @@ -1132,7 +1133,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>>>         bool has_fcs_err;
>>>>         bool has_crypto_err;
>>>>         bool has_tkip_err;
>>>> -       bool has_peer_idx_invalid;
>>>> +       bool has_idx_invalid;
>>>>         bool is_decrypted;
>>>
>>> I don't really like the has_idx_invalid. Perhaps has_peer_err conveys
>>> a bit more of the original meaning?
>>
>> What about just peer_idx_invalid? IMHO we really don't need the has_
>> prefix in that relatively small function.
>
> Good point but the assignment line with `peer_idx_invalid` will still
> be over 80 chars long, no?

I actually test with 83 char limit nowadays. I should add the checkpatch
command line to the wiki.

> So perhaps instead of doing `rxd->attention.flags &
> __cpu_to_le32(FLAG)` it could be `attention =
> __le32_to_cpu(rxd->attention.flags)` and then `attention & FLAG` ?
> This way it shouldn't exceed the 80 char limit and var names won't
> need to be changed. Hopefully compiler will optimize it away.

That's much better and actually has a lot less calls to cpu_le32(). I
folded the patch below.

But aren't the '!!' operators useless? 'has_*' variables are booleans,
doesn't compiler handle that automatically?

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6f58b7f912cd..6abb3b6a348f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1133,8 +1133,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	bool has_fcs_err;
 	bool has_crypto_err;
 	bool has_tkip_err;
-	bool has_idx_invalid;
+	bool has_peer_idx_invalid;
 	bool is_decrypted;
+	u32 attention;
 
 	if (skb_queue_empty(amsdu))
 		return;
@@ -1162,14 +1163,12 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	/* Some attention flags are valid only in the last MSDU. */
 	last = skb_peek_tail(amsdu);
 	rxd = (void *)last->data - sizeof(*rxd);
-	has_fcs_err = !!(rxd->attention.flags &
-			 __cpu_to_le32(RX_ATTENTION_FLAGS_FCS_ERR));
-	has_crypto_err = !!(rxd->attention.flags &
-			    __cpu_to_le32(RX_ATTENTION_FLAGS_DECRYPT_ERR));
-	has_tkip_err = !!(rxd->attention.flags &
-			  __cpu_to_le32(RX_ATTENTION_FLAGS_TKIP_MIC_ERR));
-	has_idx_invalid = !!(rxd->attention.flags &
-			     __cpu_to_le32(RX_ATTENTION_FLAGS_PEER_IDX_INVALID));
+	attention = __le32_to_cpu(rxd->attention.flags);
+
+	has_fcs_err = !!(attention & RX_ATTENTION_FLAGS_FCS_ERR);
+	has_crypto_err = !!(attention & RX_ATTENTION_FLAGS_DECRYPT_ERR);
+	has_tkip_err = !!(attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
+	has_peer_idx_invalid = !!(attention & RX_ATTENTION_FLAGS_PEER_IDX_INVALID);
 
 	/* Note: If hardware captures an encrypted frame that it can't decrypt,
 	 * e.g. due to fcs error, missing peer or invalid key data it will
@@ -1178,7 +1177,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	is_decrypted = (enctype != HTT_RX_MPDU_ENCRYPT_NONE &&
 			!has_fcs_err &&
 			!has_crypto_err &&
-			!has_idx_invalid);
+			!has_peer_idx_invalid);
 
 	/* Clear per-MPDU flags while leaving per-PPDU flags intact. */
 	status->flag &= ~(RX_FLAG_FAILED_FCS_CRC |




-- 
Kalle Valo
