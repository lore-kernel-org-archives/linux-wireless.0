Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:59549 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbYHDOtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 10:49:15 -0400
Received: from wilson.telenet-ops.be (unknown [195.130.132.42])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 7B5865CAFFE
	for <linux-wireless@vger.kernel.org>; Mon,  4 Aug 2008 16:49:38 +0200 (CEST)
Message-ID: <489716D3.1030101@telenet.be> (sfid-20080804_164919_470707_365BD78C)
Date: Mon, 04 Aug 2008 16:48:51 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort
 handler
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com> <1217836848-24288-2-git-send-email-yi.zhu@intel.com> <1217836848-24288-3-git-send-email-yi.zhu@intel.com> <1217836848-24288-4-git-send-email-yi.zhu@intel.com> <1217836848-24288-5-git-send-email-yi.zhu@intel.com> <1217836848-24288-6-git-send-email-yi.zhu@intel.com> <1217836848-24288-7-git-send-email-yi.zhu@intel.com> <1217836848-24288-8-git-send-email-yi.zhu@intel.com> <1217836848-24288-9-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1217836848-24288-9-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the exact same code is in iwl3945-base.c, looks to me as if it might require the same fix.

Zhu Yi wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This patch decrements rx skb counter in scan abort handler.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index 5a00ac2..9bb6adb 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -202,6 +202,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
>  		clear_bit(STATUS_SCAN_HW, &priv->status);
>  	}
>  
> +	priv->alloc_rxb_skb--;
>  	dev_kfree_skb_any(cmd.meta.u.skb);
>  
>  	return ret;
