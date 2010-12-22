Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0LVNQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 08:16:20 -0500
Date: Wed, 22 Dec 2010 14:15:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: fix scan tx antenna setting on 5Ghz band
Message-ID: <20101222131515.GA2242@redhat.com>
References: <1292864713-2756-1-git-send-email-sgruszka@redhat.com>
 <1292868816.22230.45.camel@wwguy-ubuntu>
 <20101221120511.GA2287@redhat.com>
 <1292952108.3997.39.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1292952108.3997.39.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

> > > If its is 2.4, we need to use the correct tx antenna, I think we can
> > > remove this block of code all together since check already done above.
> > > 
> > >   if (priv->cfg->scan_tx_antennas[band])
> > >   	scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
> > 
> > Is correct to use all antennas on 5GHz when blutooth is enabled?
> > For me, more logical would be limiting to one antenna no matter of band,
> > since antennas are used anyway, only frequencies differ.
> > 
> > For rx_ant, we do not check the band, only limit to first one
> > when bluetooth is used.
> 
> there is no BT coex if 5GHz is used because there is not interference
> between 2.4 and 5GHz, so both antenna can be used. WiFi should operated
> in normal condition.
> 
> For 2.4GHz, we also can use both antenna if there is not high traffic
> load on BT side.
> 
> but you have a good catch, driver need to check band before use it
> (scan_tx_antenna[band])

So how about this patch (rfc only):

>From 26d0570ed5cd85097702d0fedb2c3f831dce9714 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 22 Dec 2010 13:03:31 +0100
Subject: [RFC PATCH] iwlagn: fix scan tx antenna setting on 5Ghz band

Looks that we do not set correctly antennas when scanning
on 5Ghz band and when bluetooth is enabled, because
priv->cfg->scan_tx_antennas[band] is only defined for
IEEE80211_BAND_2GHZ.

To fix we check band before limiting antennas to first one.
This allow to remove hard coded cfg->scan_tx_antennas[band].

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    7 +------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    9 +++------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f4bec32..af505bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -596,12 +596,7 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.adv_pm = true,						\
-	/*							\
-	 *Due to bluetooth, we transmit 2.4 GHz probes		\
-	 * only on antenna A					\
-	 */							\
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A
+	.adv_pm = true						\
 
 struct iwl_cfg iwl6030_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4bc82fc..322a2bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1492,15 +1492,12 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (priv->cfg->scan_rx_antennas[band])
 		rx_ant = priv->cfg->scan_rx_antennas[band];
 
-	if (priv->cfg->scan_tx_antennas[band])
-		scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
-
-	if (priv->cfg->bt_params &&
+	if (band == IEEE80211_BAND_2GHZ &&
+	    priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
-		scan_tx_antennas = first_antenna(
-			priv->cfg->scan_tx_antennas[band]);
+		scan_tx_antennas = first_antenna(scan_tx_antennas);
 	}
 
 	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f80685a..a347437 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -411,7 +411,6 @@ struct iwl_cfg {
 	const bool need_dc_calib;	  /* if used set to true */
 	const bool need_temp_offset_calib; /* if used set to true */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
-	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
-- 
1.7.1


