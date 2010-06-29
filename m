Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0F2UTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 16:19:00 -0400
Subject: Re: [PATCH] iwlwifi: do not export iwl_leds_background
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1277840378-18305-1-git-send-email-linville@tuxdriver.com>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
	 <1277840378-18305-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 13:18:59 -0700
Message-ID: <1277842739.4197.54.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-29 at 12:39 -0700, John W. Linville wrote:
> It is only used from within the iwlcore module.
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-led.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
> index db5bfcb..486244b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-led.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
> @@ -214,7 +214,6 @@ void iwl_leds_background(struct iwl_priv *priv)
>  	priv->last_blink_time = jiffies;
>  	priv->last_blink_rate = blink_idx;
>  }
> -EXPORT_SYMBOL(iwl_leds_background);
>  
>  void iwl_leds_init(struct iwl_priv *priv)
>  {

Nack.

Please take a closer look at how it is used ... it is used in iwl-core.h
in an inline (iwl_update_stats) function that is used by both iwlagn and
iwl3945.

Reinette



