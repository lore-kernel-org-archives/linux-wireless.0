Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30879 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1KGVDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:03:41 -0500
Message-ID: <4EB8479B.8090705@qca.qualcomm.com> (sfid-20111107_220344_762490_51BBCE28)
Date: Mon, 7 Nov 2011 23:03:23 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 07/11] ath6kl: Invoke WOW suspend/resume calls during
 PM operation
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com> <1320643547-3578-8-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1320643547-3578-8-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 07:25 AM, Raja Mani wrote:
> Link ath6kl's wow suspend/resume functions with the actual suspend/resume path.
> 
> WOW mode is selected when the host sdio controller supports both
> MMC_PM_KEEP_POWER and MMC_PM_WAKE_SDIO_IRQ capabilities.
> 

[...]

> @@ -1833,6 +1860,7 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
>  			ath6kl_warn("Failed to boot hw in resume: %d\n", ret);
>  			return ret;
>  		}
> +		break;
>  
>  	default:
>  		break;


Good catch, I had missed that break. But when you make small fixes like
this, please also mention that in the commit log.

Kalle
