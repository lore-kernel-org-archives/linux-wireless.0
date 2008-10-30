Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbYJ3VCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 17:02:46 -0400
Subject: Re: [PATCH] iwlagn: avoid sleep in softirq context
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225390341-7117-1-git-send-email-linville@tuxdriver.com>
References: <>  <1225390341-7117-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 14:03:11 -0700
Message-Id: <1225400591.1115.359.camel@rc-desk> (sfid-20081030_220251_880205_B186B626)
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
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)

I forgot to mention that this patch will cause some trivial (name change) conflicts when merged together with one we submitted recently (http://marc.info/?l=linux-wireless&m=122531440910147&w=2 )

Reinette


