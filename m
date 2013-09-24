Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8094 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3IXGrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 02:47:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 3/4] ath10k: cleanup RX decap handling
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
	<1379335757-15180-4-git-send-email-michal.kazior@tieto.com>
	<8738p4laid.fsf@qca.qualcomm.com>
	<CA+BoTQ=q9ojX4bp61rExY7b9Pk+=Zpg_qNxfXYvt8eXscdC=bA@mail.gmail.com>
Date: Tue, 24 Sep 2013 09:47:39 +0300
In-Reply-To: <CA+BoTQ=q9ojX4bp61rExY7b9Pk+=Zpg_qNxfXYvt8eXscdC=bA@mail.gmail.com>
	(Michal Kazior's message of "Tue, 17 Sep 2013 07:19:35 +0200")
Message-ID: <87ioxqbtro.fsf@kamboji.qca.qualcomm.com> (sfid-20130924_084750_555350_E019DDC1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 16 September 2013 23:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> Native Wifi frames are always decapped as non-QoS
>>> data frames meaning mac80211 couldn't set sk_buff
>>> priority properly. The patch fixes this by using
>>> the original 802.11 header.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> The patch title doesn't seem to match with the content. Unless I'm
>> mistaken it looks like you are adding native wifi frame format support
>> and doing some cleanup at the same time. They should be in separate
>> patches.
>
> You're right. I'll split it up.
>
> Nwifi was supported, however QoS Data frames were reported as Data
> frames though.

Oh, ok. It would be good to document that in the commit log as well.

>>>       case RX_MSDU_DECAP_RAW:
>>> -             /* remove trailing FCS */
>>> -             skb_trim(skb, skb->len - 4);
>>> +             skb_trim(skb, skb->len - FCS_LEN);
>>>               break;
>>
>> Please keep the comment still
>
> Why? The point of the comment was to explain the literal "4". Using
> define makes the comment redundant.

I know it's redundant, but this is just to improve readability.

>>>       case RX_MSDU_DECAP_ETHERNET2_DIX:
>>> -             /* macaddr[6] + macaddr[6] + ethertype[2] */
>>> -             skb_pull(skb, 6 + 6 + 2);
>>> +             rfc1042 = hdr;
>>> +             rfc1042 += roundup(hdr_len, 4);
>>> +             rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
>>> +
>>> +             skb_pull(skb, sizeof(struct ethhdr));
>>> +             memcpy(skb_push(skb, sizeof(struct rfc1042_hdr)),
>>> +                    rfc1042, sizeof(struct rfc1042_hdr));
>>> +             memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
>>>               break;
>>
>> Ditto.
>
> Comment was supposed to explain where those numbers come from. Using
> structures explains it now.

Sure, the structures are very good here. But like above, having small
comments improve readability. Think of it as a "title" or something like
that.

>>>       case RX_MSDU_DECAP_8023_SNAP_LLC:
>>> -             /* macaddr[6] + macaddr[6] + len[2] */
>>> -             /* we don't need this for non-A-MSDU */
>>> -             skb_pull(skb, 6 + 6 + 2);
>>> +             skb_pull(skb, sizeof(struct amsdu_subframe_hdr));
>>> +             memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
>>>               break;
>>
>> And here.
>
> Ditto.

Same here :)

-- 
Kalle Valo
