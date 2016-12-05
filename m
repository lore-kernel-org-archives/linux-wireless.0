Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48890 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcLESTK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 13:19:10 -0500
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
To: Michal Kazior <michal.kazior@tieto.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
 <CA+BoTQn0d1bEB662r-Yivmdk_21LhjCQjJP_GoPaj-WT2wA=1g@mail.gmail.com>
 <57B70AED.2010200@candelatech.com>
 <ba1cc818-6194-11d6-7cc3-1db28036a519@candelatech.com>
 <ef7e16a6-9353-0f63-ac70-fc8e234d6c25@candelatech.com>
 <CA+BoTQnuLbVzuEVvf9+wOGhj7i3DV2LaMqGBfGhQHEgOSXei4g@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <4c1d2822-05cd-c0cb-7c57-a3f6c7ced709@candelatech.com> (sfid-20161205_191913_850122_E33A2181)
Date: Mon, 5 Dec 2016 10:19:08 -0800
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnuLbVzuEVvf9+wOGhj7i3DV2LaMqGBfGhQHEgOSXei4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2016 12:50 AM, Michal Kazior wrote:
> On 2 December 2016 at 01:24, Ben Greear <greearb@candelatech.com> wrote:
>> On 12/01/2016 02:52 PM, Ben Greear wrote:
>>>
>>> On 08/19/2016 06:34 AM, Ben Greear wrote:
>>>>
>>>>
>>>>
>>>> On 08/18/2016 11:59 PM, Michal Kazior wrote:
>>>>>
>>>>> On 19 August 2016 at 03:26,  <greearb@candelatech.com> wrote:
>>>>>>
>>>>>> From: Ben Greear <greearb@candelatech.com>
>>>>>>
>>>>>> I was seeing kernel crashes due to accessing freed memory
>>>>>> while debugging a 9984 firmware that was crashing often.
>>>>>>
>>>>>> This patch fixes the crashes.  I am not certain if there
>>>>>> is a better way or not.
>>
>>
>> Michal, thanks for the help on IRC.  I added this logic:
>>
>> static void ieee80211_drv_tx(struct ieee80211_local *local,
>>                              struct ieee80211_vif *vif,
>>                              struct ieee80211_sta *pubsta,
>>                              struct sk_buff *skb)
>> {
>>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>>         struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>>         struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>>         struct ieee80211_tx_control control = {
>>                 .sta = pubsta,
>>         };
>>         struct ieee80211_txq *txq = NULL;
>>         struct txq_info *txqi;
>>         u8 ac;
>>
>>         if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
>>             (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
>>                 goto tx_normal;
>>
>>         if (!ieee80211_is_data(hdr->frame_control))
>>                 goto tx_normal;
>>
>>         if (unlikely(!ieee80211_sdata_running(sdata))) {
>>                 WARN_ON_ONCE(1);
>>                 goto delete_and_return;
>>         }
>>
>> ...
>>
>>         if (atomic_read(&sdata->txqs_len[ac]) >=
>>             (local->hw.txq_ac_max_pending * 2)) {
>>                 /* Must be that something is not paying attention to
>>                  * max-pending, like pktgen, so just drop this frame.
>>                  */
>> delete_and_return:
>>                 ieee80211_free_txskb(&local->hw, skb);
>>                 return;
>>         }
>>
>>
>> But, I still see the txq entries on the ar->txqs list in the
>> ath10k_mac_txq_init
>> after firmware crash in my test case.  Is this the test you were suggesting?
>
> Yes.
>
> Now that I think about it mac80211 doesn't call anything in driver
> during hw_restart that would unref txqs. This means you'll have them
> still linked when add_interface/sta_state is called, no?
>
> This means that either:
>  (a) txq (re-)init should be smarter in ath10k
>  (b) txqs should be purged during hw_restart in ath10k

I posted a patch that does (a) last Friday:

"ath10k:  work-around for stale txq in ar->txqs"

I realized it will not apply upstream because it is also patching the previous
work-around I had in the patch that originated this email thread.

With these patches and the iterate hack to mac80211, then I no longer
see crashes in my test case that previously crashed very readily.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
