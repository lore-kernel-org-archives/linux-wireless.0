Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:55916 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaLXRJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 12:09:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>
Subject: Re: [PATCH v2 1/4] mwifiex: enable -D__CHECK_ENDIAN__ for sparse by default
References: <1418903926-11859-1-git-send-email-patila@marvell.com>
Date: Wed, 24 Dec 2014 19:09:22 +0200
In-Reply-To: <1418903926-11859-1-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Thu, 18 Dec 2014 17:28:43 +0530")
Message-ID: <8738857z5p.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_180933_890189_EECCEB7A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> Enable the endian checks by default.
>
> v2: remove -DDEBUG as suggested by Joe Perches

Please don't add the change log to the commit log. Instead add it after
'---' line so that git am can automatically skip it. Alternatively send
a cover letter and include the change log there.

Can fix that, please?

> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---

<Add the changelog here>

>  drivers/net/wireless/mwifiex/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
> index 9487d72..fdfd9bf 100644
> --- a/drivers/net/wireless/mwifiex/Makefile
> +++ b/drivers/net/wireless/mwifiex/Makefile
> @@ -53,3 +53,5 @@ obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
>  
>  mwifiex_usb-y += usb.o
>  obj-$(CONFIG_MWIFIEX_USB) += mwifiex_usb.o
> +
> +ccflags-y += -D__CHECK_ENDIAN

-- 
Kalle Valo
