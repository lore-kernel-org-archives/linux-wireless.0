Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:12279 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCCJhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 04:37:54 -0500
Received: by wf-out-1314.google.com with SMTP id 28so3216601wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2009 01:37:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18860.6782.4168.588808@gargle.gargle.HOWL>
References: <20090302145514.GB4660@myhost.users.atheros.com>
	 <18860.6782.4168.588808@gargle.gargle.HOWL>
Date: Tue, 3 Mar 2009 15:07:51 +0530
Message-ID: <8e92b4100903030137r4c412ccdu17020c482d6cb1b3@mail.gmail.com> (sfid-20090303_103757_733857_84DD8A15)
Subject: Re: [PATCH] ath9k: Handle power modes in isr for power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 2, 2009 at 11:12 PM, Sujith <m.sujith@gmail.com> wrote:
> Vivek Natarajan wrote:
>> Restore network sleep mode in isr if power save is enabled.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> ---
>> =A0drivers/net/wireless/ath9k/ath9k.h | =A0 =A03 ++-
>> =A0drivers/net/wireless/ath9k/main.c =A0| =A0 =A02 ++
>> =A02 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wirele=
ss/ath9k/ath9k.h
>> index 6481ea4..69292f3 100644
>> --- a/drivers/net/wireless/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath9k/ath9k.h
>> @@ -677,7 +677,8 @@ static inline void ath9k_ps_wakeup(struct ath_so=
ftc *sc)
>> =A0static inline void ath9k_ps_restore(struct ath_softc *sc)
>> =A0{
>> =A0 =A0 =A0 if (atomic_dec_and_test(&sc->ps_usecount))
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (sc->hw->conf.flags & IEEE80211_CONF_PS=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((sc->hw->conf.flags & IEEE80211_CONF_P=
S) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !(sc->sc_flags & SC_OP_WAIT_FOR_BE=
ACON))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ath9k_hw_setpower(sc->sc=
_ah,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 sc->sc_ah->restore_mode);
>> =A0}
>
> This needs proper locking.

SC_OP_WAIT_FOR_BEACON is being changed in rx_tasklet and in isr which
are mutually exclusive. Even though it might be changed  in these two
regions, it won't affect the ps_wake/ps_restore cycle.

IEEE80211_CONF_PS is changed in siwpower() and also in
dynamic_ps_work. Even if it is changed while we are executing this
ps_restore, there won't be any race condition on ps_wake/ps_restore
cycle and it will work fine.

hw_setpower is just a register write function which may not need a prot=
ection(?)

And for the protection of ps_wake/ps_restore itself, there is
ps_count(atomic) which takes care of properly restoring power save
state.

Overall, from my perspective there is no need for any more lock.

Thanks,
Vivek.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
