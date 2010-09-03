Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0ICMHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:07:40 -0400
Subject: Re: [PATCH 04/13] iwlwifi: cancel scan when down the device
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1283515056-11523-5-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 14:07:20 +0200
Message-ID: <1283515640.4700.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-03 at 13:57 +0200, Stanislaw Gruszka wrote:
> Always cancel scan when stooping device and scan is currently pending,
> we should newer have scan running after down device.
> 
> To assure we start scan cancel from restart work we have to schedule
> abort_scan to different workqueue than priv->workqueue.

Hmmm...

> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2875,8 +2875,9 @@ static void __iwl_down(struct iwl_priv *priv)
>  
>  	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
>  
> -	if (!exit_pending)
> -		set_bit(STATUS_EXIT_PENDING, &priv->status);
> +	iwl_scan_cancel_timeout(priv, 200);

This introduces a locking issue, because iwl_scan_cancel_timeout() drops
the mutex. I suspect you fix that later though, but for example the
restart work uses the mutex to atomically track a few BT related
variables.

johannes

