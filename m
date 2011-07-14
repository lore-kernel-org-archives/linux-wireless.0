Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab1GNXEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 19:04:46 -0400
Received: by iyb12 with SMTP id 12so658671iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 16:04:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310678971-28952-6-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com> <1310678971-28952-6-git-send-email-frankyl@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 15 Jul 2011 09:04:25 +1000
Message-ID: <CAGRGNgWx5-8cbU3zSnHQbbCdbf5xOGjYEnkcxnz5M4kB1s0nUQ@mail.gmail.com> (sfid-20110715_010453_210851_EF672AA2)
Subject: Re: [PATCH 05/35] staging: brcm80211: removed function declaration
 typedefs from aiutils.h
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jul 15, 2011 at 07:29, Franky Lin <frankyl@broadcom.com> wrote:
> From: Roland Vossen <rvossen@broadcom.com>
>
> Softmac related code cleanup. Typedefs are undesirable according to the
> CodingStyle document.
>
> Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> ---
> diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
> index a25901e..5a5fc4b 100644
> --- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
> +++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
> @@ -1279,9 +1279,9 @@ ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
>
>        sii = SI_INFO(sih);
>        sii->intr_arg = intr_arg;
> -       sii->intrsoff_fn = (si_intrsoff_t) intrsoff_fn;
> -       sii->intrsrestore_fn = (si_intrsrestore_t) intrsrestore_fn;
> -       sii->intrsenabled_fn = (si_intrsenabled_t) intrsenabled_fn;
> +       sii->intrsoff_fn = (u32 (*)(void *)) intrsoff_fn;
> +       sii->intrsrestore_fn = (void (*) (void *, u32)) intrsrestore_fn;
> +       sii->intrsenabled_fn = (bool (*)(void *)) intrsenabled_fn;
>        /* save current core id.  when this function called, the current core
>         * must be the core which provides driver functions(il, et, wl, etc.)
>         */

Are these casts necessary - as in could better types be chosen for
these function pointers and the underlying functions themselves?

I see the same issue in patches 6 - 10.

(my apologies if you've addressed this later)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
