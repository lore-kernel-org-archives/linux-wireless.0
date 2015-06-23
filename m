Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38629 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbFWH25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 03:28:57 -0400
Received: by wibdq8 with SMTP id dq8so7532923wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 00:28:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKtt4uKAd-VkEuK9WThGg9au0y_-yYhJ7S7bmXeQzw7nA@mail.gmail.com>
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
	<1434973385-15865-2-git-send-email-janusz.dziedzic@tieto.com>
	<CABPxzYJadyBVPn7yZzqsJpnWQ4Jx_dUoR10FXNze041WDYJp+Q@mail.gmail.com>
	<CA+BoTQ=Rqq4xh1nXd3RQwuwqR8QT=OgOzfpOeB=QhmJ8Ke=6kw@mail.gmail.com>
	<CABPxzYKtt4uKAd-VkEuK9WThGg9au0y_-yYhJ7S7bmXeQzw7nA@mail.gmail.com>
Date: Tue, 23 Jun 2015 09:28:55 +0200
Message-ID: <CALhHN=ppitfj6goqmXkkf9_AGCmttA781J_O=75EPkebASzMQg@mail.gmail.com> (sfid-20150623_092901_592208_82F6FE01)
Subject: Re: [PATCH 1/3] ath9k: handle RoC abort correctly
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Sujith Manoharan <sujith@msujith.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 June 2015 at 16:01, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> On Mon, Jun 22, 2015 at 6:32 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 22 June 2015 at 13:56, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
>>> On Mon, Jun 22, 2015 at 5:13 PM, Janusz Dziedzic
>>> <janusz.dziedzic@tieto.com> wrote:
>>>> In case we will get ROC abort we should not call
>>>> ieee80211_remain_on_channel_expired().
>>>>
>>>> In other case I hit such warning on MIPS and
>>>> p2p negotiation failed (tested with use_chanctx=1).
>>>>
>>>> ath: phy0: Starting RoC period
>>>> ath: phy0: Channel definition created: 2412 MHz
>>>> ath: phy0: Assigned next_chan to 2412 MHz
>>>> ath: phy0: Offchannel duration for chan 2412 MHz : 506632
>>>> ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
>>>> ath: phy0: Stopping current chanctx: 2412
>>>> ath: phy0: Flush timeout: 200
>>>> ath: phy0: ath_chanctx_set_next: Set channel 2412 MHz
>>>> ath: phy0: Set channel: 2412 MHz width: 0
>>>> ath: phy0: Reset to 2412 MHz, HT40: 0 fastcc: 0
>>>> ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_TSF_TIMER, state: ATH_CHANCTX_STATE_IDLE
>>>> ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
>>>> ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
>>>> ath: phy0: Cancel RoC
>>>> ath: phy0: RoC aborted
>>>> ath: phy0: RoC request on vif: 00:03:7f:4e:a0:cd, type: 1 duration: 500
>>>> ath: phy0: Starting RoC period
>>>> ath: phy0: Channel definition created: 2412 MHz
>>>> ath: phy0: Assigned next_chan to 2412 MHz
>>>> ath: phy0: Offchannel duration for chan 2412 MHz : 506705
>>>> ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
>>>> ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
>>>> ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
>>>> ------------[ cut here ]------------
>>>> WARNING: CPU: 0 PID: 3312 at drivers/net/wireless/ath/ath9k/main.c:2319
>>>> Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211
>>>>
>>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>>> ---
>>>>  drivers/net/wireless/ath/ath9k/channel.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
>>>> index 2066650..e211325 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/channel.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/channel.c
>>>> @@ -926,7 +926,8 @@ void ath_roc_complete(struct ath_softc *sc, bool abort)
>>>>
>>>>         sc->offchannel.roc_vif = NULL;
>>>>         sc->offchannel.roc_chan = NULL;
>>>> -       ieee80211_remain_on_channel_expired(sc->hw);
>>>> +       if (!abort)
>>>> +               ieee80211_remain_on_channel_expired(sc->hw);
>>>>         ath_offchannel_next(sc);
>>>>         ath9k_ps_restore(sc);
>>>>  }
>>> If HW aborts RoC in middle, should not we inform mac80211
>>> that RoC is expired?
>>
>> Good point. The ath_roc_complete() can be called with abort=true from
>> ath9k_cancel_pending_offchannel() as well. I guess ath_roc_complete()
>> needs a "reason" argument (instead of "abort") with: expired, aborted,
>> cancelled values. ieee80211_remain_on_channel_expired() should be
>> called whenever reason != cancelled.
> Agree, make sense.
>> By the way - is ath_roc_complete() lock protected properly? It looks
>> like it isn't from a quick glance. Neither sdata lock nor local->mtx
>> can be implied in all contexts and sc->mutex isn't always held while
>> it's called, hmm.. or am I missing something?
>>
>>> Also the we are clearing roc_vif independent of abort, so the warning
>>> indicates that roc_complete has not come from FW, may be we should
>>> understand that first?
>>
>> There's no FW in ath9k.
>>
>> The problem is the following sequence:
>>  1. mac80211 requests roc A
>>  2. mac80211 cancels roc A
>>    a. ath9k calls expired() and hw_roc_done work is scheduled
>>  3. mac80211 requests roc B
>>  4. mac80211 starts to process the scheduled hw_roc_done
>>  5. mac80211 thinks roc B has expired
>>  6. mac80211 requests roc C
>>  7. ath9k WARN_ON is hit
>>
>> There's a race between (3) and (4). Depending on circumstances (3) and
>> (4) may be reordered so the current code doesn't fail all the time.
> Ok i understand, but if we get roc_complete for B before 6, then it works
> fine at least at ath9k level, C will be unblocked.
>
> Anyways, handling the cancel case should resolve it along with proper locking.

Thanks for comments, will send v2

BR
Janusz
