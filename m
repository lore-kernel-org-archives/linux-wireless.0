Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33044 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934417Ab3FSOaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:30:13 -0400
Date: Wed, 19 Jun 2013 10:24:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: Re: [PATCH 2/3] mwifiex: add basic 11h support for station
Message-ID: <20130619142446.GC12079@tuxdriver.com> (sfid-20130619_163020_244389_332C217F)
References: <1371598618-26593-1-git-send-email-bzhao@marvell.com>
 <1371598618-26593-2-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371598618-26593-2-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 18, 2013 at 04:36:57PM -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> This patch adds code to parse requested AP's 11h capabilities
> and add 11h information in association request.
> 
> Also, deauth is sent to the AP after receiving channel switch
> announcement event from firmware. This happens when AP advertises
> WLAN_EID_CHANNEL_SWITCH IE in it's beacon.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Paul Stewart <pstew@chromium.org>
> ---

>  drivers/net/wireless/mwifiex/sta_event.c |   7 +++

> diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
> index 41aafc7..0f7b4cf 100644
> --- a/drivers/net/wireless/mwifiex/sta_event.c
> +++ b/drivers/net/wireless/mwifiex/sta_event.c
> @@ -427,6 +427,13 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
>  
>  		break;
>  
> +	case EVENT_CHANNEL_SWITCH_ANN:
> +		dev_dbg(adapter->dev, "event: Channel Switch Announcement\n");
> +		ret = mwifiex_send_cmd_async(priv,
> +			HostCmd_CMD_802_11_DEAUTHENTICATE,
> +			HostCmd_ACT_GEN_SET, 0,
> +			priv->curr_bss_params.bss_descriptor.mac_address);
> +
>  	default:
>  		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
>  			eventcause);

Do you mean for this case to fall-through to the default case?


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
