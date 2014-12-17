Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45342 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbaLQKbI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:31:08 -0500
From: Avinash Patil <patila@marvell.com>
To: Joe Perches <joe@perches.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>
Date: Wed, 17 Dec 2014 02:30:34 -0800
Subject: RE: [PATCH 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by
 default
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A07@SC-VEXCH2.marvell.com> (sfid-20141217_113113_005601_D353F612)
References: <1418817273-22669-1-git-send-email-patila@marvell.com>,<1418809260.14140.18.camel@perches.com>
In-Reply-To: <1418809260.14140.18.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for review, Joe.

I will send v2 with -DDEBUG removed.

Thanks,
Avinash
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Joe Perches [joe@perches.com]
Sent: Wednesday, December 17, 2014 3:11 PM
To: Avinash Patil
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Marc Yang
Subject: Re: [PATCH 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by default

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


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
