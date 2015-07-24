Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38073 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbbGXLMt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 07:12:49 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH 2/4] mwifiex: remove redundant reset of cmd_wait_q status
Date: Fri, 24 Jul 2015 11:12:43 +0000
Message-ID: <d91203738e9448ccb90c127e3db316b2@SC-EXCH04.marvell.com> (sfid-20150724_131252_993312_13C5A9E9)
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
 <1437117186-25243-3-git-send-email-afenkart@gmail.com>
In-Reply-To: <1437117186-25243-3-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> From: Andreas Fenkart [mailto:afenkart@gmail.com]
> Sent: Friday, July 17, 2015 12:43 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Kalle Valo; Andreas Fenkart
> Subject: [PATCH 2/4] mwifiex: remove redundant reset of cmd_wait_q
> status
> 
> mwifiex_cancel_pending_ioctl is called only from
> mwifiex_cmd_timeout_func. There the wait_q status is set to -ETIMEDWAIT
> before calling this function. Whether we reset the status to -1 or leave
> it at -ETIMEDWAIT at end doesn't matter since both are != 0 hence mean
> failure
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/cmdevt.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cmdevt.c
> b/drivers/net/wireless/mwifiex/cmdevt.c
> index 2f4715e..87b6dee 100644
> --- a/drivers/net/wireless/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/mwifiex/cmdevt.c
> @@ -1123,7 +1123,6 @@ mwifiex_cancel_pending_ioctl(struct
> mwifiex_adapter *adapter)
>  			}
>  		}
>  	}
> -	adapter->cmd_wait_q.status = -1;
>  }
> 
>  /*
> --
> 2.1.4

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
