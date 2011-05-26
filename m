Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38260 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab1EZM0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 08:26:25 -0400
Received: by pwi15 with SMTP id 15so310042pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 05:26:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com>
References: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com>
Date: Thu, 26 May 2011 17:56:24 +0530
Message-ID: <BANLkTinaz4tmMSTRN7RJgYjOvchLY9NKog@mail.gmail.com> (sfid-20110526_142649_595871_5893B13A)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix Kiwi (AR9287) initial calibration
From: Mohammed Shafi <shafi.ath9k@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 10:30 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> The AR9287 initial calibration in ar9002_hw_init_cal() isn't ever
> called because the Kite check (AR_SREV_9285_12_OR_LATER()) matches on
> MACs versioned Kite and later.

yes, instead  the calibration initialization for AR9285_12_OR_LATER  is called.

>
> The Atheros newma code checks it is Kite as well as being Kite >= 1.2.

yes thats true.

>
> I don't currently have Linux ath9k on something with an AR9287 so I'd
> appreciate it if this were verified by someone who has.


did a quick preliminary tx throughput test not much difference.

>
> The patch is quite simple:
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> index 015d974..2d4c091 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> @@ -829,7 +829,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah,
> struct ath9k_channel *chan)
>        if (AR_SREV_9271(ah)) {
>                if (!ar9285_hw_cl_cal(ah, chan))
>                        return false;
> -       } else if (AR_SREV_9285_12_OR_LATER(ah)) {
> +       } else if (AR_SREV_9285(ah) && AR_SREV_9285_12_OR_LATER(ah)) {
>                if (!ar9285_hw_clc(ah, chan))
>                        return false;
>        } else {
>
> Thanks,
>
>
> Adrian
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
