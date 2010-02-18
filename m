Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:56161 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0BRTSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 14:18:50 -0500
Received: by pzk32 with SMTP id 32so432396pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Feb 2010 11:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100218182946.GF8069@bombadil.infradead.org>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	<1266124222.13902.42.camel@mj> <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	<1266358340.2659.37.camel@mj> <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
	<1266464675.3065.30.camel@mj> <20100218182946.GF8069@bombadil.infradead.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 18 Feb 2010 11:18:30 -0800
Message-ID: <43e72e891002181118x609bd80egb96dd38a65fb4bcd@mail.gmail.com>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 10:29 AM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> On Wed, Feb 17, 2010 at 10:44:35PM -0500, Pavel Roskin wrote:
>> On Tue, 2010-02-16 at 14:59 -0800, Luis R. Rodriguez wrote:
>>
>> > > Anyway, I'd rather see
>> > > dma_sync_single_range_for_device() for ARM backported.
>> >
>> > Patches are welcomed for it indeed.
>>
>> Here's the patch.  I'm not sure if include/net/compat-2.6.27.h or
>> compat/compat-2.6.27.h is the real source file, as I was patching the
>> downloaded tarball.
>
> For 2.6.32 compat.ko is not created and it is also not managed through
> a separate git tree so compat/compat-2.6.27.h would have been the right
> file for patching purposes.
>
> I tend to prefer to apply things first on bleeding edge and then trickle
> things down just as with upstream. I started to package the general
> kernel compatibility stuff into its own git tree for the 2.6.33 release,
> so for future compat-wireless compat-*.[ch] files go there and patches
> should be sent against:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
>
> In that tree I have branches for each stable release, just as with
> the compat-wireless git tree. I apply on the master for bleedinge edge
> and then trickle down the stable releases.
>
> Thanks for your patch I have sucked it in and applied it to all
> the respective trees.
>
>> The missing functions are only used by b44.  The functions available in
>> 2.6.26 don't have the offset argument, so I had to extend the range to
>> start at zero.  This could affect the b44 throughput, but I would not
>> worry too much about it.
>>
>> The is another problem.  For some reason, CONFIG_SSB_PCMCIAHOST is
>> enabled in compat_autoconf.h, even though the target kernel lacks PCMCIA
>> support.  However, CONFIG_SSB_PCMCIAHOST is not set in the makefiles, so
>> ssb.ko is compiled with CONFIG_SSB_PCMCIAHOST, but pcmcia.o is not
>> linked into it, which leads to unresolved symbols.  However, the build
>> succeeds and there are no warnings about it.
>
> Ah, try this patch, or you can just git pull.
>
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date: Thu, 18 Feb 2010 10:17:52 -0800
> Subject: [PATCH] compat-wireless: make CONFIG_SSB_PCMCIAHOST depend on CONFIG_PCMCIA
>
> The dependency was created but since we don't use our own mconf magic
> thing we have to create our own build dep for our
> include/linux/compat_autoconf.h file. We currently handle these sort
> of dependencies on a case by case basis as compat-wireless was
> relatively simple.
>
> Adding this case would generate this on the compat_autoconf.h file:
>
> ifdef CONFIG_PCMCIA
> ifndef CONFIG_SSB_PCMCIAHOST
> define CONFIG_SSB_PCMCIAHOST 1
> endif /* CONFIG_SSB_PCMCIAHOST */
> else
>
> Reported-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  scripts/gen-compat-autoconf.sh |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
> index 6c7cae7..6184392 100755
> --- a/scripts/gen-compat-autoconf.sh
> +++ b/scripts/gen-compat-autoconf.sh
> @@ -169,6 +169,10 @@ for i in $(grep '^CONFIG_' $COMPAT_CONFIG); do
>                define_config_dep $VAR $VALUE CONFIG_USB_NET_CDCETHER
>                continue
>                ;;
> +       CONFIG_SSB_PCMCIAHOST)
> +               define_config_dep $VAR $VALUE CONFIG_PCMCIA
> +               continue
> +               ;;
>        # ignore this, we have a special hanlder for this at the botttom
>        # instead. We still need to keep this in config.mk to let Makefiles
>        # know its enabled so just ignore it here.

Sorry, I just noticed this would break CONFIG_B43_PCMCIA, and making
that also depend on PCMCIA doesn't work on my end. Eh.

  Luis
