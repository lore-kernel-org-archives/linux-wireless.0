Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:25892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYLIGf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 01:35:58 -0500
Subject: Re: iwlwifi build failure
From: reinette chatre <reinette.chatre@intel.com>
To: Sujith <m.sujith@gmail.com>
Cc: "Halperin, Daniel C" <daniel.c.halperin@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <18749.61316.313728.426082@localhost.localdomain>
References: <18749.61316.313728.426082@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 22:36:59 -0800
Message-Id: <1228804619.30670.8.camel@rc-desk> (sfid-20081209_073602_905154_3BE79999)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-08 at 20:09 -0800, Sujith wrote:
> /home/sujith/dev/wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_rx_reply_rx':
> /home/sujith/dev/wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c:1074: error: 'struct iwl_priv' has no member named 'debug_level'
> 
> From my .config:
> 
> CONFIG_IWLWIFI=m
> CONFIG_IWLCORE=m
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWLWIFI_RFKILL=y
> # CONFIG_IWLWIFI_DEBUG is not set
> CONFIG_IWLAGN=m
> CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
> CONFIG_IWLAGN_LEDS=y
> CONFIG_IWL4965=y
> CONFIG_IWL5000=y
> # CONFIG_IWL3945 is not set
> 
> A missing #ifdef CONFIG_IWLWIFI_DEBUG in iwl-rx.c ?

Sorry ... please use this patch below. 

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1938e6d..0a22e94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1071,8 +1071,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
 	/* Set "1" to report good data frames in groups of 100 */
-	if (unlikely(priv->debug_level & IWL_DL_RX))
-		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
+	iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
 		rx_status.signal, rx_status.noise, rx_status.signal,


