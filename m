Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58192 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaHGJjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:39:17 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so10258999wiv.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:39:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8738d84pgg.fsf@kamboji.qca.qualcomm.com>
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
	<1407402308-29899-6-git-send-email-michal.kazior@tieto.com>
	<8738d84pgg.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 7 Aug 2014 11:39:16 +0200
Message-ID: <CA+BoTQnCHA5cKFTTF+v1GHqb65JyFxFUXcJt6_AFBtS7jWHKJQ@mail.gmail.com> (sfid-20140807_113925_478790_0480B792)
Subject: Re: [PATCH 5/5] ath10k: flush hif buffers before recovery
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 August 2014 11:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Transport buffers weren't flushed and processed
>> before queueing hw recovery request to mac80211.
>>
>> This could in theory result in an unwanted htt/wmi
>> rx events being processed while mac80211 recovers
>> the device and possibly interfere or even crash
>> the system.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This one had a conflict in ath-next-test, I changed the patch to this:
>
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -666,6 +666,7 @@ static void ath10k_core_restart(struct work_struct *work)
>         case ATH10K_STATE_ON:
>                 ar->state = ATH10K_STATE_RESTARTING;
>                 ath10k_scan_finish(ar);
> +               ath10k_hif_stop(ar);
>                 ieee80211_restart_hw(ar->hw);

Oops. I've accidentally posted an old version of this single patch.
The hif_stop() should be _before_ scan_finish/reset(). I'll wait for
more comments before posting a v2 though.


Michał
