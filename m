Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22856 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3FCPuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:50:51 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kirshenbaum Erez <erezk@wilocity.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Fix channel index in WMI PCP start
Date: Mon, 3 Jun 2013 18:50:47 +0300
Message-ID: <1587839.LYoJ4ehe3P@lx-vladimir> (sfid-20130603_175055_625355_C556C21D)
In-Reply-To: <1370251153-13791-1-git-send-email-erezk@wilocity.com>
References: <1370251153-13791-1-git-send-email-erezk@wilocity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 03, 2013 12:19:13 PM Kirshenbaum Erez wrote:
> Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
> ---
>  drivers/net/wireless/ath/wil6210/wmi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
> index 45b04e3..26f760a 100644
> --- a/drivers/net/wireless/ath/wil6210/wmi.c
> +++ b/drivers/net/wireless/ath/wil6210/wmi.c
> @@ -724,7 +724,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
>  		.bcon_interval = cpu_to_le16(bi),
>  		.network_type = wmi_nettype,
>  		.disable_sec_offload = 1,
> -		.channel = chan,
> +		.channel = chan-1,
>  	};

Fix for this already merged, see commit
adc2d12 - wil6210: channel off by 1

To make sure you are aligned, please, prior to sending patch,
rebase on 'master' from
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

>  	struct {
>  		struct wil6210_mbox_hdr_wmi wmi;
> @@ -733,9 +733,9 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
>  
>  	if (!wil->secure_pcp)
>  		cmd.disable_sec = 1;
> -
> +	/* This may take some time (FW set/calibrate new freq) */
>  	rc = wmi_call(wil, WMI_PCP_START_CMDID, &cmd, sizeof(cmd),
> -		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 100);
> +		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 5000);
>  	if (rc)
>  		return rc;
This chunk does not belong to this patch, yes?

Thanks, Vladimir
