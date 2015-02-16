Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58295 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbbBPGyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 01:54:19 -0500
Received: by mail-wg0-f41.google.com with SMTP id b13so27591091wgh.0
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2015 22:54:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87mw4fgolp.fsf@kamboji.qca.qualcomm.com>
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
	<87mw4fgolp.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 16 Feb 2015 07:54:17 +0100
Message-ID: <CA+BoTQkZJLaAYy+PnoLiFn5S3sfJujgRRkWcMqgdxJbbf3FHeQ@mail.gmail.com> (sfid-20150216_075423_264246_6FAD624B)
Subject: Re: [PATCH] ath10k: fix AP/IBSS CSA with template based fw
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 February 2015 at 16:51, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> qca6174 with wmi-tlv firmware uses offloaded
>> beaconing scheme (i.e. templates). This requires a
>> little different approach when implementing CSA.
>>
>> Add missing code to update CS count and report CSA
>> completion to mac80211. Without it channel switch
>> was never finished.
>>
>> To avoid races during interface teardown data_lock
>> has been used to protect is_up and is_started so
>> they can be compared against before scheduling
>> count down work.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>
>> @Kalle: I'm deferring the chanctx patchset v4
>> until this gets applied. I'd like to avoid posting
>> patches without a valid parent id and leaving you
>> with some weird conflicts and implicit depndencies
>> in the code to deal with.
>
> Ok.
>
> I actually had strange conflicts already with this patch (in mac.c). As
> I'm travelling, please check my resolution from the pending branch very
> carefully. I might have done something stupid.

There's a mistake. Only `arvif->is_up` should be protected by
`ar->data_lock` in ath10k_bss_assoc():

@@ -1852,7 +1901,9 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
                return;
        }

+       spin_lock_bh(&arvif->ar->data_lock);
        arvif->is_up = true;
+       spin_unlock_bh(&arvif->ar->data_lock);

        /* Workaround: Some firmware revisions (tested with qca6174
   (...)
 }


Michał
