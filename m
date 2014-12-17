Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:52152 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750799AbaLQJlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 04:41:03 -0500
Message-ID: <1418809260.14140.18.camel@perches.com> (sfid-20141217_104108_651447_C43D7CF5)
Subject: Re: [PATCH 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by
 default
From: Joe Perches <joe@perches.com>
To: Avinash Patil <patila@marvell.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	akarwar@marvell.com, cluo@marvell.com, yangyang@marvell.com
Date: Wed, 17 Dec 2014 01:41:00 -0800
In-Reply-To: <1418817273-22669-1-git-send-email-patila@marvell.com>
References: <1418817273-22669-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 17:24 +0530, Avinash Patil wrote:
> Enable the endian checks by default.
[]
> diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
[]
> @@ -53,3 +53,5 @@ obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
>  
>  mwifiex_usb-y += usb.o
>  obj-$(CONFIG_MWIFIEX_USB) += mwifiex_usb.o
> +
> +ccflags-y += -D__CHECK_ENDIAN__ -DDEBUG

I think the -DDEBUG should not be there.

This also forces all the dev_dbg / wiphy_dbg
statement to always be emitted.


