Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14341 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbKBKy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 05:54:27 -0500
Message-ID: <563740CE.7080806@qti.qualcomm.com> (sfid-20151102_115430_887320_D5706BD1)
Date: Mon, 2 Nov 2015 16:24:06 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: Fix peerid configuration in htt tx desc for
 htt version < 3.4
References: <1446453229-22982-1-git-send-email-vthiagar@qti.qualcomm.com>	<1446453229-22982-2-git-send-email-vthiagar@qti.qualcomm.com> <CA+BoTQn4WHGU8nbrcqZyBTm1tkdJZk5NJT63SXi4s7tp=mGiXg@mail.gmail.com>
In-Reply-To: <CA+BoTQn4WHGU8nbrcqZyBTm1tkdJZk5NJT63SXi4s7tp=mGiXg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 02 November 2015 03:57 PM, Michal Kazior wrote:
> On 2 November 2015 at 09:33, Vasanthakumar Thiagarajan
> <vthiagar@qti.qualcomm.com> wrote:
>> Of a word in struct htt_data_tx_desc htt version >= 3.4 firmware uses LSB 16-bit
>> for frequency configuration which is used for offchannel tx and MSB 16-bit
>> is for peerid. But other firmwares using version 2.X (10.1, 10.2.2, 10.2.4
>> and 10.4) are using 32-bit for peerid in htt tx desc. So far no issue is found
>> with the existing code setting peerid and freq for HTT version 2.X, this could
>> be mainly because of 0 as frequecy (home channel) is being always passed with
>> those firmwares. There may be issues when non-zero freq is passed with firmware
>> using < 3.4 htt version. To be safe use target_version_major and target_version_minor
>> along with htt-op-version before configuring peer id and freq in htt tx desc.
>>
>> Fixes: 8d6d36243610 ("ath10k: fix offchan reliability")
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt.h    |  9 +++++++--
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 13 +++++++++++--
>>   2 files changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
>> index 2bad50e..44fb4f2 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt.h
>> +++ b/drivers/net/wireless/ath/ath10k/htt.h
>> @@ -166,8 +166,13 @@ struct htt_data_tx_desc {
>>          __le16 len;
>>          __le16 id;
>>          __le32 frags_paddr;
>> -       __le16 peerid;
>> -       __le16 freq;
>> +       union {
>> +               __le32 peerid;
>> +               struct {
>> +                       __le16 peerid;
>> +                       __le16 freq;
>> +               } __packed offchan_tx;
>> +       } __packed;
>>          u8 prefetch[0]; /* start of frame, for FW classification engine */
>>   } __packed;
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> index 1682397..bf19247 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> @@ -681,8 +681,17 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>>          skb_cb->htt.txbuf->cmd_tx.len = __cpu_to_le16(msdu->len);
>>          skb_cb->htt.txbuf->cmd_tx.id = __cpu_to_le16(msdu_id);
>>          skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
>> -       skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le16(HTT_INVALID_PEERID);
>> -       skb_cb->htt.txbuf->cmd_tx.freq = __cpu_to_le16(skb_cb->htt.freq);
>> +       if (ar->htt.target_version_major >= 3 &&
>> +           ar->htt.target_version_minor >= 4 &&
>> +           ar->htt.op_version == ATH10K_FW_HTT_OP_VERSION_TLV) {
>
> Hmm.. I think it'd be better to rename
> ath10k_mac_need_offchan_tx_work() to, e.g.
> ath10k_htt_tx_frm_has_freq() and add the htt.op_version check to it.


Sure, thanks.

Vasanth

