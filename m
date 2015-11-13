Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36555 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbbKMLT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 06:19:57 -0500
Received: by wmww144 with SMTP id w144so24404963wmw.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 03:19:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=qB-Hmr60CLyS-eV_Vx1bWL5YLP2VQ0ipV5Okphyd-OiA@mail.gmail.com>
References: <CALhHN=ov0kqqgGGHwPMOq3VaVsg9oD59Ed_NNsdcKVyS2+go2Q@mail.gmail.com>
	<1447410786-31874-1-git-send-email-borja.salazar@fon.com>
	<CADqurOGEoZ15BtcqLwQGXLoBJLUCcd6ciypuYBzVjJb7MAHYng@mail.gmail.com>
	<CALhHN=qB-Hmr60CLyS-eV_Vx1bWL5YLP2VQ0ipV5Okphyd-OiA@mail.gmail.com>
Date: Fri, 13 Nov 2015 12:19:55 +0100
Message-ID: <CALhHN=pVj2XbcndJ_tEAsSgdtBhMDPh5oJ3QqudrBAxkmn6K5Q@mail.gmail.com> (sfid-20151113_122001_333087_00952DA7)
Subject: Re: [PATCH v2] ath9k: incorrect queue may be stopped/awaken
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Borja Salazar <borja.salazar@fon.com>
Cc: linux-wireless@vger.kernel.org,
	Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send again as txt.


On 13 November 2015 at 12:17, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
>
>
>
> On 13 November 2015 at 11:45, Borja Salazar <borja.salazar@fon.com> wrote:
>>
>> Hi,
>>
>> Let me explain the patch more thoroughly. We are testing MCC and we've found some issues with the queues handlers, the main problem is that when we transmit a multicast/broadcast frame, where hw_queue is 8 (CAB), we check queue status, which is 2(q), and if it is full and we have to stop it, we end stopping the wrong queue, 8, which is not full. From this point onwards stations are unable to connect to the AP.
>>
>> Let me know if something is not clear.
>>
> I am interested if you reintroduce bug that Sujith already fix in commit:
> ath9k: Enable HW queue control only for MCC
>
> While as I understand correctly this patch disable hw queues for non-mcc (also clear IEEE80211_HW_QUEUE_CONTROL) and your
>
> +       if (ath9k_is_chanctx_enabled())
> +               q = fi->txq;
> +       else
> +               q = info->hw_queue;
>
> Use again hw_queue for standard non-mcc operation.
>
> Please check this, I am sure while did only simple check :)
>
> BR
> Janusz
>
>
>>
>> Regards,
>>
>> Borja Salazar
>> Firmware team
>> All information in this email is confidential
>>
>> On Fri, Nov 13, 2015 at 11:33 AM, Borja Salazar <borja.salazar@fon.com> wrote:
>>>
>>> When channel context is enabled, we could be
>>> stopping/awakening an incorrect queue.
>>>
>>> Signed-off-by: Borja Salazar <borja.salazar@fon.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/xmit.c | 22 ++++++++++++----------
>>>  1 file changed, 12 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>>> index 3e3dac3..9b17a59 100644
>>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>> @@ -147,7 +147,12 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
>>>  {
>>>         struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>>>         struct ath_frame_info *fi = get_frame_info(skb);
>>> -       int q = fi->txq;
>>> +       int q;
>>> +
>>> +       if (ath9k_is_chanctx_enabled())
>>> +               q = fi->txq;
>>> +       else
>>> +               q = info->hw_queue;
>>>
>>>         if (q < 0)
>>>                 return;
>>> @@ -158,10 +163,7 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
>>>
>>>         if (txq->stopped &&
>>>             txq->pending_frames < sc->tx.txq_max_pending[q]) {
>>> -               if (ath9k_is_chanctx_enabled())
>>> -                       ieee80211_wake_queue(sc->hw, info->hw_queue);
>>> -               else
>>> -                       ieee80211_wake_queue(sc->hw, q);
>>> +               ieee80211_wake_queue(sc->hw, q);
>>>                 txq->stopped = false;
>>>         }
>>>  }
>>> @@ -2299,17 +2301,17 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>>>          * info are no longer valid (overwritten by the ath_frame_info data.
>>>          */
>>>
>>> -       q = skb_get_queue_mapping(skb);
>>> +       if (ath9k_is_chanctx_enabled())
>>> +               q = skb_get_queue_mapping(skb);
>>> +       else
>>> +               q = info->hw_queue;
>>>
>>>         ath_txq_lock(sc, txq);
>>>         if (txq == sc->tx.txq_map[q]) {
>>>                 fi->txq = q;
>>>                 if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
>>>                     !txq->stopped) {
>>> -                       if (ath9k_is_chanctx_enabled())
>>> -                               ieee80211_stop_queue(sc->hw, info->hw_queue);
>>> -                       else
>>> -                               ieee80211_stop_queue(sc->hw, q);
>>> +                       ieee80211_stop_queue(sc->hw, q);
>>>                         txq->stopped = true;
>>>                 }
>>>         }
>>> --
>>> 2.3.6
>>>
>>
>
