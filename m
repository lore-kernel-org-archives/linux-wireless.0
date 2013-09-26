Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7518 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3IZIzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 04:55:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/13] ath10k: introduce dynamic WMI structures
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 11:54:52 +0300
In-Reply-To: <1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 25 Sep 2013 11:37:59 +0200")
Message-ID: <87ob7grmhv.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_105511_009461_5D6B6F23)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This is the initial framework to implement dynamic
> WMI API in order to support new firmware (from so
> called 10.X branch)
>
> The realization is to have a static WMI cmd map for
> each of the firmwares, registered upom wmi init.
>
> This patch creates such map for MAIN FW, updates
> wmi_cmd_send() calls to take as a parameter
> the map value instead of direct WMI enum.
>
> As soon as complete 10.X API will be on place,
> we will introduce the FW IE mechanics to dynamicaly
> identify which FW is being used and based on that
> we will use correct map, API, structures, etc.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---

[...]

> @@ -1293,7 +1438,8 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
>  	if (skb == NULL)
>  		return -ENOMEM;
>  
> -	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_RESUME_CMDID);
> +	return ath10k_wmi_cmd_send(ar, skb,
> +				   ar->wmi.cmd->wmi_pdev_resume_cmdid);
>  }

I was thinking of adding a macro WMI_PDEV_RESUME_CMDID(ar) for all
dynamic wmi ids, that way it would look as closely as possible with the
original code. But I'm not sure if that makes sense anymore. Thoughts?

-- 
Kalle Valo
