Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:48345 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031401AbbD2I1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 04:27:34 -0400
Message-ID: <1430296046.2411.100.camel@x220> (sfid-20150429_102754_080654_7A1ED5E4)
Subject: Re: [PATCH] drivers/nfc: remove obsolete setting of DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Joe Perches <joe@perches.com>, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	rupran@einserver.de, stefan.hengelein@fau.de
Date: Wed, 29 Apr 2015 10:27:26 +0200
In-Reply-To: <1430212127-5841-1-git-send-email-valentinrothberg@gmail.com>
References: <1430212127-5841-1-git-send-email-valentinrothberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Added Joe.]

On Tue, 2015-04-28 at 11:08 +0200, Valentin Rothberg wrote:
> The CPP identifier 'DEBUG' is not used in the source code of nfc at all,
> so we can safely remove setting it in both Makefiles.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
> ---
> I detected this issue with ./scripts/checkkconfigsymbols.py since
> CONFIG_NFC_DEBUG is not defined in Kconfig.

The patch should be fine, as there is no NFC_DEBUG Kconfig symbol, but
I'm not sure whether the commit explanation is correct.

As it turns out I submitted a very similar patch two years ago (see
https://lkml.kernel.org/r/1365179481.1830.69.camel@x61.thuisdomein ).
And it was pointed out to me that the DEBUG macro is used by the
pr_debug() macro and friends. I already forgot the details but, in
short, DEBUG is a bit of  a gotcha: you can't say whether or not it's
used by just grepping for it. 

> ---
>  drivers/nfc/Makefile         | 2 --
>  drivers/nfc/nxp-nci/Makefile | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
> index a4292d790f9b..13b648baf175 100644
> --- a/drivers/nfc/Makefile
> +++ b/drivers/nfc/Makefile
> @@ -14,5 +14,3 @@ obj-$(CONFIG_NFC_TRF7970A)	+= trf7970a.o
>  obj-$(CONFIG_NFC_ST21NFCA)  	+= st21nfca/
>  obj-$(CONFIG_NFC_ST21NFCB)	+= st21nfcb/
>  obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
> -
> -ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
> diff --git a/drivers/nfc/nxp-nci/Makefile b/drivers/nfc/nxp-nci/Makefile
> index c008be30bb18..c9ec7869dbd2 100644
> --- a/drivers/nfc/nxp-nci/Makefile
> +++ b/drivers/nfc/nxp-nci/Makefile
> @@ -7,5 +7,3 @@ nxp-nci_i2c-objs = i2c.o
>  
>  obj-$(CONFIG_NFC_NXP_NCI) += nxp-nci.o
>  obj-$(CONFIG_NFC_NXP_NCI_I2C) += nxp-nci_i2c.o
> -
> -ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG

Thanks,


Paul Bolle

