Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:53985 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754070AbbE1S1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 14:27:37 -0400
Message-ID: <1432837654.1556.2.camel@perches.com> (sfid-20150528_202740_337581_5E6CBE8E)
Subject: Re: [PATCH 01/17] mwifiex: verbose logging for association failure
 messages
From: Joe Perches <joe@perches.com>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, huxm@marvell.com
Date: Thu, 28 May 2015 11:27:34 -0700
In-Reply-To: <1432817889-26250-2-git-send-email-patila@marvell.com>
References: <1432817889-26250-1-git-send-email-patila@marvell.com>
	 <1432817889-26250-2-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 18:27 +0530, Avinash Patil wrote:
> This patch adds more logging support for association failure -
> reason and states.
[]
> diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
[]
> @@ -419,8 +419,12 @@ enum P2P_MODES {
>  #define HS_CFG_COND_MAC_EVENT		0x00000004
>  #define HS_CFG_COND_MULTICAST_DATA	0x00000008
>  
> -#define MWIFIEX_TIMEOUT_FOR_AP_RESP		0xfffc
> -#define MWIFIEX_STATUS_CODE_AUTH_TIMEOUT	2
> +#define ASSOC_ERR_AUTH_ERR_STA_FAILURE		0xFFFB
> +#define ASSOC_ERR_ASSOC_ERR_TIMEOUT		0xFFFC
> +#define ASSOC_ERR_ASSOC_ERR_AUTH_REFUSED	0xFFFD

Is there really value in duplicating ASSOC_ERR_
	ASSOC_ERR_ASSOC_ERR_<foo>


