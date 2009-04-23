Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZDWRR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:17:27 -0400
Subject: Re: [PATCH] iwlwifi: notify on scan completion even when shutting
 down
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240476304.30082.174.camel@johannes.local>
References: <1240476304.30082.174.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 10:23:34 -0700
Message-Id: <1240507414.27723.15.camel@rc-desk> (sfid-20090423_191730_625998_9D02451D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-04-23 at 01:45 -0700, Johannes Berg wrote:
> Under certain circumstances iwlwifi can get stuck and will no
> longer accept scan requests, because the core code (cfg80211)
> thinks that it's still processing one. This fixes one of the
> points where it can happen, but I've still seen it (although
> only with my radio-off-when-idle patch).
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-scan.c	2009-04-21 23:36:10.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-scan.c	2009-04-23 10:43:08.000000000 +0200
> @@ -814,12 +814,12 @@ void iwl_bg_scan_completed(struct work_s
>  
>  	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
>  
> -	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> -		return;
> -
>  	priv->scan_request = NULL;
>  	ieee80211_scan_completed(priv->hw, false);
>  
> +	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> +		return;
> +
>  	/* Since setting the TXPOWER may have been deferred while
>  	 * performing the scan, fire one off */
>  	mutex_lock(&priv->mutex);
> 
> 

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette


