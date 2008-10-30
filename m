Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44513 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYJ3Ukl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:40:41 -0400
Subject: Re: [PATCH] iwlagn: avoid sleep in softirq context
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225390341-7117-1-git-send-email-linville@tuxdriver.com>
References: <>  <1225390341-7117-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 13:41:05 -0700
Message-Id: <1225399265.1115.356.camel@rc-desk> (sfid-20081030_214046_487793_5D89910E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-30 at 11:12 -0700, John W. Linville wrote:
> __ieee80211_tasklet_handler -> __ieee80211_rx ->
> 	__ieee80211_rx_handle_packet -> ieee80211_invoke_rx_handlers ->
> 	ieee80211_rx_h_decrypt -> ieee80211_crypto_tkip_decrypt ->
> 	ieee80211_tkip_decrypt_data -> iwl4965_mac_update_tkip_key ->
> 	iwl_scan_cancel_timeout -> msleep
> 
> Ooops!
> 
> Avoid the sleep by changing iwl_scan_cancel_timeout with
> iwl_scan_cancel and simply returning on failure if the scan persists.
> This will cause hardware decryption to fail and we'll handle a few more
> frames with software decryption.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thank you very much

>  
> -	iwl_scan_cancel_timeout(priv, 100);
> +	if (iwl_scan_cancel(priv)) {
> +		/* cancel scan failed, just live w/ bad key and rely
> +		   briefly on SW decrpyption */

Could you please add some debugging (IWL_DEBUG_MAC80211 ) here to log
the problem? Also watch for the small typo. 

Reinette



