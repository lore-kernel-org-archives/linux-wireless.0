Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33793 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932575AbeB1Rbb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 12:31:31 -0500
Received: by mail-qt0-f173.google.com with SMTP id l25so3987623qtj.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 09:31:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519780965-15292-1-git-send-email-greearb@candelatech.com>
References: <1519780965-15292-1-git-send-email-greearb@candelatech.com>
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date: Wed, 28 Feb 2018 18:31:30 +0100
Message-ID: <CABvG-CU1jf4xN+LZdkdejqr67Mcs-JdvGrvHnh0pB2VSJjJZzQ@mail.gmail.com> (sfid-20180228_183217_543895_093A5233)
Subject: Re: [RFC] ath10k: Attempt to work around napi_synchronize hang.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2018 at 02:22,  <greearb@candelatech.com> wrote:
[...]
> @@ -2086,8 +2087,28 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
>         ath10k_pci_irq_disable(ar);
>         ath10k_pci_irq_sync(ar);
>         ath10k_pci_flush(ar);
> -       napi_synchronize(&ar->napi);
> -       napi_disable(&ar->napi);
> +
> +       /* Calling napi_disable twice in a row (w/out starting it and/or =
without
> +        * having NAPI active leads to deadlock because napi_disable sets
> +        * NAPI_STATE_SCHED and NAPI_STATE_NPSVC when it returns, as far =
as I
> +        * can tell.  So, guard this call to napi_disable.  I believe the
> +        * failure case is something like this:
> +        * rmmod ath10k_pci ath10k_core
> +        *   Firmware crashes before hif_stop is called by the rmmod path
> +        *   The crash handling logic calls hif_stop
> +         *   Then rmmod gets around to calling hif_stop, but spins endle=
ssly
> +        *   in napi_synchronize.
> +        *
> +        *  I think one way this could happen is that ath10k_stop checks
> +        *  for state !=3D ATH10K_STATE_OFF, but STATE_RESTARTING is also
> +        *  a possibility.  That might be how we can have hif_stop called=
 twice
> +        *  without a hif_start in between. --Ben
> +        */
> +       if (ar->napi_enabled) {
> +               napi_synchronize(&ar->napi);
> +               napi_disable(&ar->napi);
> +               ar->napi_enabled =3D false;
> +       }

Looking at the code and your comment the described fail case seems
legit. I would consider tuning ath10k_stop() so that it calls
ath10k_halt() only if ar->state !=3D OFF & ar->state !=3D RESTARTING
though. Or did you try already?

While your approach will probably work it won't prevent other non-NAPI
bad things from happening. Even if there's nothing today it might
creep up in the future. And you'd need to update ahb.c too.


Micha=C5=82
