Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58068 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbcCAPIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:08:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 12/15] wil6210: clean ioctl debug message
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1456781570-16552-13-git-send-email-qca_merez@qca.qualcomm.com>
Date: Tue, 01 Mar 2016 17:08:46 +0200
In-Reply-To: <1456781570-16552-13-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Mon, 29 Feb 2016 23:32:47 +0200")
Message-ID: <87bn6yme0x.fsf@purkki.adurom.net> (sfid-20160301_160856_056540_70F1D179)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Lior David <qca_liord@qca.qualcomm.com>
>
> Fix a debug message related to IOCTL that was incorrectly logged
> with the MISC category, and move it inside wil_ioctl so it will
> always be logged even if we call wil_ioctl from other places.
>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/wil6210/ioctl.c
> +++ b/drivers/net/wireless/ath/wil6210/ioctl.c
> @@ -161,13 +161,20 @@ out_free:
>  
>  int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd)
>  {
> +	int ret;
> +
>  	switch (cmd) {
>  	case WIL_IOCTL_MEMIO:
> -		return wil_ioc_memio_dword(wil, data);
> +		ret = wil_ioc_memio_dword(wil, data);
> +		break;
>  	case WIL_IOCTL_MEMIO_BLOCK:
> -		return wil_ioc_memio_block(wil, data);
> +		ret = wil_ioc_memio_block(wil, data);
> +		break;
>  	default:
>  		wil_dbg_ioctl(wil, "Unsupported IOCTL 0x%04x\n", cmd);
>  		return -ENOIOCTLCMD;
>  	}
> +
> +	wil_dbg_ioctl(wil, "ioctl(0x%04x) -> %d\n", cmd, ret);
> +	return ret;
>  }

ioctl interfaces don't belong to wireless drivers and this should be
converted something else, like debugfs. I think there was a discussion
about this a year ago or so. I can take this patch still but please
replace this interface altogether.

-- 
Kalle Valo
