Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45359
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXGaJsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 05:48:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 4/7] iwlwifi: Endainity fix for rx configuration
Date: Tue, 31 Jul 2007 11:48:07 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com> <11858506013260-git-send-email-yi.zhu@intel.com> <11858506033857-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858506033857-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311148.07995.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007, Zhu Yi wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch fixes endianity issues in rx configuration
> related code.
> 
> Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwl-4965.c |   26 ++++---
>  drivers/net/wireless/iwl-base.c |  148 +++++++++++++++++++++------------------
>  drivers/net/wireless/iwl-hw.h   |   10 ++--
>  3 files changed, 101 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
> index 19591a6..786c5d0 100644
> --- a/drivers/net/wireless/iwl-4965.c
> +++ b/drivers/net/wireless/iwl-4965.c
> @@ -3615,8 +3615,8 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
>  
>  		hdr = (void *)(pkt->u.raw +
>  			       sizeof(struct iwl4965_rx_mpdu_res_start));
> -		rx_end = (u32 *) (((u8 *) hdr) + amsdu->byte_count);
>  		len = amsdu->byte_count;
> +		rx_end = (u32 *) (((u8 *) hdr) + len);

I doubt rx_end is a pointer to u32. Most likely you want to use
(__le32 *) here and also audit the users of rx_end, if they
need le32_to_cpu().
