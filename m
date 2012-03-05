Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15403 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab2CEPAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 10:00:45 -0500
Message-ID: <4F54D517.2090001@qca.qualcomm.com> (sfid-20120305_160056_773838_E1B333ED)
Date: Mon, 5 Mar 2012 20:30:39 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<senthilb@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>,
	<rodrigue@qca.qualcomm.com>,
	Rajkumar_contact <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
Subject: Re: [RFC 1/2] ath9k: use ieee80211_free_txskb
References: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com> <4F4F0B83.9050203@qca.qualcomm.com> <4F4F60A0.5040006@qca.qualcomm.com> <4F4F7DC2.8030204@qca.qualcomm.com>
In-Reply-To: <4F4F7DC2.8030204@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

ping

On Thursday 01 March 2012 07:16 PM, Mohammed Shafi Shajakhan wrote:
> On Thursday 01 March 2012 05:12 PM, Mohammed Shafi Shajakhan wrote:
>> On Thursday 01 March 2012 11:09 AM, Mohammed Shafi Shajakhan wrote:
>>> Hi Christian,
>>>
>>> On Monday 27 February 2012 09:40 PM, Christian Lamparter wrote:
>>>> With the new tx status API: "mac80211: implement wifi TX status"
>>>> All skb originating from mac80211 needs to be given back to mac80211.
>>>>
>>>> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
>>>> ---
>>>> It's high time we change all calls in the tx-path from
>>>> dev_kfree_skb into ieee80211_free_txskb.
>>>>
>>>> The call in ath9k_tx is straightforward, but the one in
>>>> ath_tx_setup_buffer gives me headaches. I'm not sure if
>>>> we even need to check bf->bf_state.bfs_paprd at this
>>>> stage since ath_tx_start_dma sets bf->bf_state.bfs_paprd
>>>> "after" calling ath_tx_setup_buffer?!
>>>
>>> yes, i think its a problem, we cannot exactly say its the skb from
>>> mac80211 (or) its our PAPRD skb. though with the current code(as the
>>> PAPRD) is disabled the skb would be always from mac80211. let us see if
>>> we have some good solution.
>>
>>
>> got some idea, need to make sure this works perfectly, paprd frames are
>> not aggregated, so we can look only at the non-aggregated path.
>>
>> lets ignore aggregated path:
>>
>> *ath_tx_form_aggr
>> *ath_tx_send_ampdu
>>
>>
>> non-aggregated path :
>>
>> *ath_tx_start_dma
>> *ath_send_normal
>>
>> -> 'ath_tx_setup_buffer' called from 'ath_tx_start_dma' can have a
>> 'is_paprd' check based on 'txctl->paprd' which holds which chain we are
>> sending PAPRD frame.
>>
>> -> 'ath_send_normal' called from
>> -ath_tx_start_dma ( then 'bf' should be valid and we would not have
>> called 'ath_tx_setup_buffer'
>> -ath_tx_flush_tid ( which is an aggregation path) ignore it.
>>
>>
>> attached rough patch for ath9k, need to be compiled and tested. i will
>> also analyze if this can be done in a better way or any flaws in it
>>
>
> compilation fails with previous patch, forgot to declare the field in
> the declaration, attached patch passes compilation.
>
>

would you like me to test this patch, i can just ran a test parallel y 
enabling PAPRD,with this proposed patch.

-- 
thanks,
shafi
