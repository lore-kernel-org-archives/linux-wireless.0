Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63265 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1H3GUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:20:54 -0400
Received: by wyg24 with SMTP id 24so4644482wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 23:20:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5C7E91.8090106@openwrt.org>
References: <1314643245-59142-1-git-send-email-nbd@openwrt.org>
	<1314643245-59142-2-git-send-email-nbd@openwrt.org>
	<CAD2nsn1rRBR=5aFp1wqHkfzW+h---gGR-eATF3r5Z+8ELvv8vg@mail.gmail.com>
	<4E5C7E91.8090106@openwrt.org>
Date: Tue, 30 Aug 2011 11:50:53 +0530
Message-ID: <CAD2nsn2R1L=5imxR_rF+68rmjJ-wadnssXNmv6mr5MtBdnQA8A@mail.gmail.com> (sfid-20110830_082057_977651_27D23962)
Subject: Re: [PATCH v7 2/4] ath9k: always call ath_reset from workqueue context
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 11:39 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-08-30 7:57 AM, Mohammed Shafi wrote:
>>
>> On Tue, Aug 30, 2011 at 12:10 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>
>>>  This makes it much easier to add further rework to avoid race conditions
>>>  between reset and other work items.
>>>  Move other functions to make ath_reset static.
>>>
>>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>>  ---
>>>   drivers/net/wireless/ath/ath9k/ath9k.h  |    3 +-
>>>   drivers/net/wireless/ath/ath9k/beacon.c |    4 +-
>>>   drivers/net/wireless/ath/ath9k/init.c   |    1 +
>>>   drivers/net/wireless/ath/ath9k/main.c   |  152
>>> ++++++++++++++++---------------
>>>   drivers/net/wireless/ath/ath9k/xmit.c   |    6 +-
>>>   5 files changed, 86 insertions(+), 80 deletions(-)
>>>
>>>  diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
>>> b/drivers/net/wireless/ath/ath9k/xmit.c
>>>  index 49b93c2..f60706b 100644
>>>  --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>>  +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>>  @@ -582,7 +582,7 @@ static void ath_tx_complete_aggr(struct ath_softc
>>> *sc, struct ath_txq *txq,
>>>         rcu_read_unlock();
>>>
>>>         if (needreset)
>>>  -               ath_reset(sc, false);
>>>  +               ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
>>
>> Hi Felix,
>>
>> retry_tx is set to 'false' in ath_reset here, but ath_reset_work
>> always has it true. had i missed some thing?
>
> Since the reset work is deferred now, it can be allowed to retry tx now
> instead of dropping all packets in the queue.

oh ok, in this path we need reset when the chip becomes deaf/mute(as
mentioned  in the comment),
so i am not sure retrying tx will help rather than doing immediate
reset of the chip.
thanks.

>
> - Felix
>



-- 
shafi
