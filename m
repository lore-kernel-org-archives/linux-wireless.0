Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44667 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1KTAkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 19:40:15 -0500
Received: by wwe5 with SMTP id 5so7865543wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 16:40:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn37SxnbwponwWPGMgxfcY3sEZjUFXkNBonobGZ=3Dr38Q@mail.gmail.com>
References: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com>
	<CAD2nsn37SxnbwponwWPGMgxfcY3sEZjUFXkNBonobGZ=3Dr38Q@mail.gmail.com>
Date: Sat, 19 Nov 2011 19:40:14 -0500
Message-ID: <CALGY4fvN=KCsRE7qjpXcZ_Fx1q_ygLwAC07JRP3OMsHMddny0w@mail.gmail.com> (sfid-20111120_014020_154413_E6C66374)
Subject: Re: [PATCH] ath9k: Improve ath_tx_aggr_stop to avoid TID stuck in
 cleanup state.
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2011/11/19 Mohammed Shafi <shafi.wireless@gmail.com>:

>>        }
>>
>>        spin_unlock_bh(&txq->axq_lock);
>> +
>> +       if (tid->baw_head == tid->baw_tail) {
>> +               tid->state &= ~AGGR_ADDBA_COMPLETE;
>> +               tid->state &= ~AGGR_CLEANUP;
>> +       }
>
> should this in be protected by axq_lock ?

   In ath_tx_aggr_stop update of tid->state are protected by axq_lock.
In ath_tx_complete_aggr the updates of these flags were (before this
patch) not protected by axq_lock (unless I miss something here). So I
quess you are right - this actually should be protected by lock, I'll
send new version of this patch.

>
>>  }
>>
>>  static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
>> @@ -556,15 +561,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>>                spin_unlock_bh(&txq->axq_lock);
>>        }
>>
>> -       if (tid->state & AGGR_CLEANUP) {
>> +       if (tid->state & AGGR_CLEANUP)
>>                ath_tx_flush_tid(sc, tid);
>>
>> -               if (tid->baw_head == tid->baw_tail) {
>> -                       tid->state &= ~AGGR_ADDBA_COMPLETE;
>> -                       tid->state &= ~AGGR_CLEANUP;
>> -               }
>> -       }
>> -
>>        rcu_read_unlock();
>>
>>        if (needreset) {
>
> based on my understanding if we don't clear this flag, i assume we
> might have problem in ath_tx_aggr_start?
> but should not this be properly cleared ath_txcomplete_aggr via tasklet path?
> please let me know if i had  missed somthing?

  If AGGR_CLEANUP is not cleared up TID permanently stays in 'paused'
state and is never reused. To the best of my understanding this flag
is cleared in two places: ath_tx_aggr_stop and ath_tx_complete_aggr.
The flag should be removed when TID is empty.
  ath_tx_aggr_stop had (before patch) a problem in which it didn't
clear the flag when TID was empty in some cases. Basically what
happened is that ath_tx_aggr_stop called ath_tx_flush_tid.
ath_tx_flush_tid tries to send packets that were not sent before and
if packet was already tried it removes it from TID. So under certain
conditions execution of ath_tx_flush_tid can result in empty TID.
ath_tx_aggr_stop didn't expect this and didn't clear the flag. When
TID is empty the ath_txcomplete_aggr is never called, so it doesn't
get a chance to cleanup the flag.
  All I did is to move flag cleanup from ath_tx_complete_aggr to
ath_tx_flush_tid. ath_tx_flush_tid actually flushes TID and if TID is
empty after it was executed the flag should be removed. So, After my
patch both ath_tx_aggr_stop and ath_tx_complete_aggr clean up the flag
when appropriate.
  I actually observed this problem (i.e. forever paused TID with no
packets and CLENUP flag up) and I think it can be recreated if one
tries to disable TID many times via debugfs when link is loaded with
traffic.

  Please let me know if you have any more questions or suggestions.
  Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
