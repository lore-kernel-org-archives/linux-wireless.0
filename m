Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61944 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbaHHKYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 06:24:49 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so5399039wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 03:24:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2cbz3wy.fsf@kamboji.qca.qualcomm.com>
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	<87d2cbz3wy.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 8 Aug 2014 12:24:48 +0200
Message-ID: <CA+BoTQkF3+-1ded_dj63BGH7-bdD_uxLSkTZjGMb654yPzbtnA@mail.gmail.com> (sfid-20140808_122452_727436_F74D5CCB)
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 August 2014 12:11, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The 10.x and main firmware branches have
>> conflicting WMI service bitmap definitions.
>>
>> This also fixes WMI services parsing on big-endian
>> hosts and changes debugfs output to be more human
>> friendly.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Based on Joe's suggestion, I'm planning to change the macro like below.
> Are you ok with that?
>
> It actually adds a new checkpatch warning but I'm going to ignore that
> for now:
>
> drivers/net/wireless/ath/ath10k/wmi.h:177: ERROR: Macros with complex values should be enclosed in parenthesis
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 109ea684f88f..e70836586756 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -174,46 +174,48 @@ enum wmi_main_service {
>
>  static inline char *wmi_service_name(int service_id)
>  {
> -#define SVCSTR(x) { case x: return #x; }
> +#define SVCSTR(x) case x: return #x
> +
[...]

This was the checkpatch warning I originally fixed by using { .. } :-)

Anyway, I don't see a problem with the macro change you suggest.
Apparently we're doomed to have a checkpatch warning either way unless
we don't use a macro at all.


Michał
