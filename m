Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab1DSMAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 08:00:52 -0400
Date: Tue, 19 Apr 2011 14:00:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 02/10] iwlagn: remove most BUG_ON instances
Message-ID: <20110419120002.GA2220@redhat.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
 <1303145057-6545-3-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303145057-6545-3-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2011 at 09:44:09AM -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> @@ -394,7 +394,9 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
>  		return -EINVAL;
>  	}
>  
> -	BUG_ON(addr & ~DMA_BIT_MASK(36));
> +	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
> +		return -EINVAL;
Seems useless.

> @@ -169,10 +171,12 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  	int cmd_idx;
>  	int ret;
>  
> -	lockdep_assert_held(&priv->mutex);
I think better keep it.
 
