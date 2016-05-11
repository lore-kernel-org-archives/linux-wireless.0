Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38526 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcEKKk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 06:40:59 -0400
Received: by mail-wm0-f54.google.com with SMTP id g17so74726903wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 03:40:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462835475-11079-4-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
	<1462835475-11079-4-git-send-email-greearb@candelatech.com>
Date: Wed, 11 May 2016 12:40:56 +0200
Message-ID: <CA+BoTQmbn_6TzfV5eNieD4=B5_CieQ2XRKeXVLKSgfaEQ_2kUg@mail.gmail.com> (sfid-20160511_124103_294931_9831C919)
Subject: Re: [PATCH 03/21] ath10k: Support setting debug mask from driver code.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2016 at 01:10,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Might want to turn off verbose debug as soon as you
> see a firmware crash, for instance.  Helps keep dmesg
> output from over-running the stuff you care about.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c | 5 +++++
>  drivers/net/wireless/ath/ath10k/debug.h | 1 +
>  2 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index e251155..a689bf1 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -194,6 +194,11 @@ void ath10k_print_driver_info(struct ath10k *ar)
>  }
>  EXPORT_SYMBOL(ath10k_print_driver_info);
>
> +void ath10k_set_debug_mask(unsigned int v) {

The { should be on new line.


> +       ath10k_debug_mask = v;
> +}
> +EXPORT_SYMBOL(ath10k_set_debug_mask);

I didn't see any uses of this in your patchset (it's commented out in
21/21) and I'm not fully convinced it's a good idea to override
debug_mask like that. Once I set a debug_mask I expect it to stay
unchanged. What if I do want to trace what happens after fw crash?

Wouldn't it be better to have a knob to tell ath10k whether hw
recovery should be automatic or manual?


Michał
