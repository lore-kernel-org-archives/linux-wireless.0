Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:46447 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbZKMT3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:29:01 -0500
Received: by iwn8 with SMTP id 8so2883335iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 11:29:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF49AE9.1040603@redfish-solutions.com>
References: <4AF49AE9.1040603@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 11:28:47 -0800
Message-ID: <43e72e890911131128l1ca48121sba7f148efd4fe52@mail.gmail.com>
Subject: Re: [PATCH] Don't build SSB modules when SSB isn't present
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 1:53 PM, Philip A. Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> From: Philip A Prindeville <philipp@redfish-solutions.com>
>
> If you're building for a platform that has (for example) no SSB,
> then having a single knob to turn to disable this is a major
> win.  Especially if more devices get add later that are SSB-based.

Applied, thanks. Just one comment below.

> Signed-off-by: Philip A Prindeville <philipp@redfish-solutions.com>
> ---
>  config.mk |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/config.mk b/config.mk
> index ce70832..49be2d0 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -9,6 +9,8 @@ ifeq ($(wildcard $(KLIB_BUILD)/.config),)
>  CONFIG_PCI=y
>  CONFIG_USB=y
>  CONFIG_PCMCIA=y
> + CONFIG_SSB_POSSIBLE=y
> + CONFIG_SSB=m

This works only if you don't have SSB on your kernel as otherwise I
believe regardless of this you'll end up coming ssb. So if you want to
enable not compiling ssb we'd have to use another config option like
CONFIG_COMPAT_26_SSB and use that in the makefile. But another easier
option is to just enable *only* want you want in compat-wireless by
using ./scripts/driver-select. In the future we may want to take
porting the kernel's existing kconfig over and using mconf for example
to enable menuconfig. But to get that working right we'd need to
invent our own kconfig entries and replaces the kernels's with our
own. An issue might also be in trying to ensure the new invented
kconfig won't bust a kernel with its own kconfig entries.

  Luis
