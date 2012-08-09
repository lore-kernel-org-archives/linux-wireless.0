Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51620 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2HIM1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 08:27:51 -0400
Received: by ghrr11 with SMTP id r11so338563ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 05:27:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120808164813.0011148e@mj>
References: <CAA2SeNLv9pE_3_-99Df_s0gF+56O6TFjfDfV-QuVxsOc6_Z5TQ@mail.gmail.com>
	<20120808164813.0011148e@mj>
Date: Thu, 9 Aug 2012 14:27:51 +0200
Message-ID: <CAA2SeNLHW=wA9nVG5YS5938vO7nZCJxMT8KiJCooPrFkvrv77g@mail.gmail.com> (sfid-20120809_142755_391068_489C8319)
Subject: Re: [PATCH 1/1] ath9k: decrypt_error flag issue
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 8 Aug 2012 19:20:15 +0200
> Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> wrote:
>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> ---
>
> Please see Documentation/SubmittingPatches in Linux sources.  In
> particular, you separated the description of the patch from its
> contents.  Single patch doesn't need to be send as series.  The
> description for the series is not a substitute for a description of
> every patch.
>
> Also, the subject should summarize the patch.  I know, it may be hard
> to fit, but not impossible.
>

Ack. I will rewrite the mail.

> When exactly would you have the problem that decrypt_error is not
> unset, but should be?  It's important that you show your assumptions so
> that others can see if they are correct, in addition to checking the
> code.  Other developers are more likely to check your patch if you
> show understanding of the code you have changed.
>

Assume hw reports a decryption error, the flag decrypt_error is set to
true in ath9k_rx_accept.
Since this flag is initialized to false just out of  ath_rx_tasklet while cycle,
all subsequent frames are marked as corrupted until ath_rx_tasklet ends.


>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -1780,7 +1780,6 @@
>
> That's weird, recv.c is 1273 lines long in wireless-testing.git.
>
> --
> Regards,
> Pavel Roskin

Regards

Lorenzo
