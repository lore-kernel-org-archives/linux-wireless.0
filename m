Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47485 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbcBXWI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 17:08:58 -0500
Message-ID: <56CE29A9.8040404@codeaurora.org> (sfid-20160224_230902_871366_6AE88781)
Date: Wed, 24 Feb 2016 14:07:37 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	Peter Oh <poh@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: set MAC timestamp in management Rx frame
References: <bed91e066a4998603c33ebcfaf507ccd2fabab5e.1456256461.git.poh@qca.qualcomm.com> <CA+BoTQ=GhHdbkiy9sNVM+BgFcrnsgNb_RxO+c8b_tpgacVYzWg@mail.gmail.com>
In-Reply-To: <CA+BoTQ=GhHdbkiy9sNVM+BgFcrnsgNb_RxO+c8b_tpgacVYzWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/24/2016 12:40 AM, Michal Kazior wrote:
> On 23 February 2016 at 20:44, Peter Oh <poh@qca.qualcomm.com> wrote:
>> From: poh <poh@qca.qualcomm.com>
>>
>> Check and set Rx MAC timestamp when firmware indicates it.
>> Firmware adds it in Rx beacon frame only at this moment.
>> Driver and mac80211 may utilize it to detect such clockdrift
>> or beacon collision and use the result for beacon collision
>> avoidance.
>>
>> Signed-off-by: poh <poh@qca.qualcomm.com>
> Your from/s-o-b doesn't seem right - just "poh"? Shouldn't it say
> "Peter Oh" instead? :)
>
>
>
>> ---
>>
>> v2:
>>          - fix kbuild test robot warning, left shift count >= width of
>> type,
>>          at __le32_to_cpu(arg.ext_info.rx_mac_timestamp_u32) << 32
>>
>>   drivers/net/wireless/ath/ath10k/wmi.c | 14 ++++++++++++++
>>   drivers/net/wireless/ath/ath10k/wmi.h |  8 ++++++++
>>   2 files changed, 22 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
>> b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 0f01a8d..b2a4cda 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -2167,6 +2167,7 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct
>> ath10k *ar, struct sk_buff *skb,
>>          struct wmi_mgmt_rx_event_v1 *ev_v1;
>>          struct wmi_mgmt_rx_event_v2 *ev_v2;
>>          struct wmi_mgmt_rx_hdr_v1 *ev_hdr;
>> +       struct wmi_mgmt_rx_ext_info *ext_info;
>>          size_t pull_len;
>>          u32 msdu_len;
>>
>> @@ -2195,6 +2196,12 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct
>> ath10k *ar, struct sk_buff *skb,
>>          if (skb->len < msdu_len)
>>                  return -EPROTO;
>>
>> +       if (arg->status & WMI_RX_STATUS_EXT_INFO) {
>> +               ext_info = (struct wmi_mgmt_rx_ext_info *)
>> +                          (skb->data + arg->buf_len);
> I would expect the ext_info structure to be aligned at 4 byte
> boundaries (or is it?)
Yes.
> but buf_len isn't guaranteed to be multiple of
> 4.
Correct.
>   This could mean you grab garbage in some cases depending on the
> mgmt frame size (i.e. whether its size is multiple of 4). It might be
> coincidence it works for you?
I'll send out 3rd patch.
>
>
> Michał
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

