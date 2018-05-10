Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39914 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756729AbeEJKon (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 06:44:43 -0400
Received: by mail-wm0-f68.google.com with SMTP id f8-v6so3527575wmc.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2018 03:44:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
References: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 10 May 2018 12:44:42 +0200
Message-ID: <CACna6rwUiJbMnFeAn7DvrpKvMsqsBMuctGNdUW199kGhcY2+gQ@mail.gmail.com> (sfid-20180510_124447_675073_F6334A61)
Subject: Re: [PATCH] ssb: Fix regression caused by disabling PCI cores on
 non-MIPS architecture
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 May 2018 at 18:42, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Some MPIS-based SoCs use chips driven by b43 for wireless capability.
> When ssb is configured as a module, build errors happen on these
> platforms as described in the commit 882164a4a928 ("ssb: Prevent build
> of PCI host features in module"). Unfortunately that change leads to
> the removal of code needed for correct operation on platforms that use
> PCI cores on the chip bus. The fix allows ssb to be build as a module
> for all architectures other than MIPS. This approach is ad-hoc, but it
> is the same as done in commit a9e6d44ddecc ("ssb: Do not disable PCI
> host on non-Mips").
>
> This problem was reported and discussed in
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349.
>
> Fixes: commit 882164a4a928 ("ssb: Prevent build of PCI host features in m=
odule")
> Tested-by: Matt Redfearn <matt.redfearn@mips.com>
> Tested-by: Bruno Wolff III <bruno@wolff.to>
> Cc: Michael B=C3=BCsch <m@bues.ch>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Kalle,
>
> This patch fixes the regression in 4.17 that was discussed on the
> wireless mailing list. I'm not really happy about the ad-hoc rejection
> of ssb as a module only on MIPS; however, that seems to be a unique
> implementation of this hardware.
>
> Larry
>
> Michael,
>
> Although I think your version of the patch is superior, this is the one t=
hat
> Matt tested, thus I'm submitting this version.
>
> Larry
>
> ---
>  drivers/ssb/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index 9371651d8017..3743533c8057 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -117,7 +117,7 @@ config SSB_SERIAL
>
>  config SSB_DRIVER_PCICORE_POSSIBLE
>         bool
> -       depends on SSB_PCIHOST && SSB =3D y
> +       depends on SSB_PCIHOST && (SSB =3D y || !MIPS)
>         default y
>
>  config SSB_DRIVER_PCICORE

I don't like hacking SSB_DRIVER_PCICORE_POSSIBLE while the original
problem seems to be related to the SSB_PCICORE_HOSTMODE.

We should rather revert breaking commit & fix original problem properly.

--=20
Rafa=C5=82
