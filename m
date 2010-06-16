Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54455 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0FPBUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 21:20:41 -0400
Received: by pva4 with SMTP id 4so421322pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 18:20:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276649713.6127.276.camel@emiko>
References: <1276649713.6127.276.camel@emiko>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Jun 2010 18:20:19 -0700
Message-ID: <AANLkTikp4M3Pnh0FEYEayo75FMY8M8j4OaByiiV6EAXJ@mail.gmail.com>
Subject: Re: [PATCH] ipw2200: Enable LED by default
To: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: reinette.chatre@intel.com, ilw@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	TJ <ubuntu@tjworld.net>, BrianK.Lee@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 5:55 PM, Leann Ogasawara
<leann.ogasawara@canonical.com> wrote:
> Hi All,
>
> As documented in 2005 in Documentation/networking/README.ipw2200, "The
> LED code has been reported to hang some systems when running ifconfig
> and is therefore disabled by default."  We've however been carrying the
> following patch in our Ubuntu kernel for quite some time which enables
> the ipw2200 LED by default.  This was a result of numerous user
> requests.  We've seen no subsequent bug reports of systems hanging due
> to the the LED code being enabled by default.  I'd therefore like to
> propose the following patch to enable the LED by default.  This patch
> was originally authored by TJ.  I apologize in advance that I do not
> have TJ's full first and last name for provenance.
>
> Thanks,
> Leann
>
> >From 315246037a0edab4d626de6ccb68c73d3fe61ce3 Mon Sep 17 00:00:00 2001
> From: ubuntu@tjworld.net <ubuntu@tjworld.net>
> Date: Mon, 23 Mar 2009 20:29:28 +0000
> Subject: [PATCH] ipw2200: Enable LED by default
>
> BugLink: http://bugs.launchpad.net/bugs/21367
>
> Enable LED by default and update the MODULE_PARM_DESC.  The original
> reason for defaulting to disabled was documented in 2005 and noted, "The
> LED code has been reported to hang some systems when running ifconfig
> and is therefore disabled by default."  This no longer appears
> applicable and users have been requesting this be enabled for several
> years.
>
> Originally-by: TJ <ubuntu@tjworld.net>

Does Originally-by also imply he has read the Certificate of Origin
and that he agrees for his code to be used in that way? That is the
purpose of the SOB anyway, but if you took his code, does that imply
that he agrees to it too?

This is from Documentation/SubmittingPatches

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.


  Luis

> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> Acked-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
> ---
>  Documentation/networking/README.ipw2200 |    2 +-
>  drivers/net/wireless/ipw2x00/ipw2200.c  |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
> index 80c7285..e4d3267 100644
> --- a/Documentation/networking/README.ipw2200
> +++ b/Documentation/networking/README.ipw2200
> @@ -171,7 +171,7 @@ Where the supported parameter are:
>
>   led
>        Can be used to turn on experimental LED code.
> -       0 = Off, 1 = On.  Default is 0.
> +       0 = Off, 1 = On.  Default is 1.
>
>   mode
>        Can be used to set the default mode of the adapter.
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 3aa3bb1..0805569 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -96,7 +96,7 @@ static int network_mode = 0;
>  static u32 ipw_debug_level;
>  static int associate;
>  static int auto_create = 1;
> -static int led_support = 0;
> +static int led_support = 1;
>  static int disable = 0;
>  static int bt_coexist = 0;
>  static int hwcrypto = 0;
> @@ -12083,7 +12083,7 @@ module_param(auto_create, int, 0444);
>  MODULE_PARM_DESC(auto_create, "auto create adhoc network (default on)");
>
>  module_param_named(led, led_support, int, 0444);
> -MODULE_PARM_DESC(led, "enable led control on some systems (default 0 off)");
> +MODULE_PARM_DESC(led, "enable led control on some systems (default 1 on)");
>
>  module_param(debug, int, 0444);
>  MODULE_PARM_DESC(debug, "debug output mask");
> --
> 1.7.0.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
