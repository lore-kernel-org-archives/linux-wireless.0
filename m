Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35712 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbbLOAuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 19:50:23 -0500
Received: by pff63 with SMTP id 63so20349919pff.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 16:50:22 -0800 (PST)
Subject: Re: [PATCH v2] wcn36xx: handle rx skb allocation failure to avoid
 system crash
To: Julian Calaby <julian.calaby@gmail.com>
References: <1450087610-32477-1-git-send-email-fengwei.yin@linaro.org>
 <CAGRGNgWoub75=8HZdhdwL3gVCO+3GntQ3_aD-WN_r7S3AmQaew@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org, Bob Copeland <me@bobcopeland.com>,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <566F63CD.9010406@linaro.org> (sfid-20151215_015035_545173_19BC2FF6)
Date: Tue, 15 Dec 2015 08:50:21 +0800
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWoub75=8HZdhdwL3gVCO+3GntQ3_aD-WN_r7S3AmQaew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/12/15 6:47, Julian Calaby wrote:
> Hi Fengwei,
>
> On Mon, Dec 14, 2015 at 9:06 PM, Fengwei Yin <fengwei.yin@linaro.org> wrote:
>> Lawrence reported that git clone could make system crash on a
>> Qualcomm ARM soc based device (DragonBoard, 1G memory without
>> swap) running 64bit Debian.
>>
>> It's turned out the crash is related with rx skb allocation
>> failure. git could consume more than 600MB anonymous memory.
>> And system is in extremely memory shortage case.
>>
>> But driver didn't handle the rx allocation failure case. This patch
>> doesn't submit skb to upper layer if rx skb allocation fails.
>> Instead, it reuse the old skb for rx DMA again. It's more like
>> drop the packets if system is in memory shortage case.
>>
>> With this change, git clone is OOMed instead of system crash.
>>
>> Reported-by: King, Lawrence <lking@qti.qualcomm.com>
>> Signed-off-by: Fengwei Yin <fengwei.yin@linaro.org>
>> ---
>> Changes from v1:
>>   * Move switch block out of while loop.
>>   * Remove the warning of unknown channel because we didn't deal with it.
>>
>>   drivers/net/wireless/ath/wcn36xx/dxe.c | 50 ++++++++++++++++++++--------------
>>   1 file changed, 30 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
>> index f8dfa05..6b61874 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
>> @@ -467,6 +467,18 @@ out_err:
>>
>>   }
>>
>> +#define        GET_CH_CTRL_VALUE(x)                    \
>> +       ({ u32 __v = WCN36XX_DXE_CTRL_RX_H;     \
>> +          if ((x) == WCN36XX_DXE_CH_RX_L)      \
>> +               __v = WCN36XX_DXE_CTRL_RX_L;    \
>> +          __v; })
>> +
>> +#define        GET_CH_INT_MASK(x)                      \
>> +       ({ u32 __v = WCN36XX_DXE_INT_CH3_MASK;  \
>> +          if ((x) == WCN36XX_DXE_CH_RX_L)      \
>> +               __v = WCN36XX_DXE_INT_CH1_MASK; \
>> +          __v; })
>> +
>
> Why add these ugly macros if you're only calling them once?
>
>>   static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>>                                       struct wcn36xx_dxe_ch *ch)
>>   {
>> @@ -474,36 +486,34 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>>          struct wcn36xx_dxe_desc *dxe = ctl->desc;
>>          dma_addr_t  dma_addr;
>>          struct sk_buff *skb;
>> +       int ret = 0, int_mask;
>> +       u32 value;
>> +
>
> Surely something like:
>
> if (ch->ch_type == WCN36XX_DXE_CH_RX_L) {
>      value = WCN36XX_DXE_CTRL_RX_L;
>      int_mask = WCN36XX_DXE_INT_CH1_MASK;
> } else {
>      value = WCN36XX_DXE_CTRL_RX_H;
>      int_mask = WCN36XX_DXE_INT_CH3_MASK;
> }
>
> would be much cleaner.
OK. I will remove the ugly macros. Thanks a lot for reviewing it.

Regards
Yin, Fengwei

>
> Thanks,
>
