Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25965 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab0IIPuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:50:06 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 9 Sep 2010 08:50:03 -0700
Subject: RE: [PATCH 09/12] iwlwifi: force scan complete after timeout
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501280FDC94@orsmsx506.amr.corp.intel.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-10-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-10-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
Sent: Thursday, September 09, 2010 6:52 AM
To: Johannes Berg; Guy, Wey-Yi W; Chatre, Reinette; John W. Linville
Cc: linux-wireless@vger.kernel.org; Stanislaw Gruszka
Subject: [PATCH 09/12] iwlwifi: force scan complete after timeout

If we do not get notification from hardware about scan complete, after
timeout do mac80211 scan completion anyway. This assure we end scan
in case of firmware hung.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   15 +++------------
 drivers/net/wireless/iwlwifi/iwl-scan.c |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 87a2e40..7c1819f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2041,7 +2041,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 {
        struct iwl_priv *priv = hw->priv;
        struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-       bool scan_completed = false;

        IWL_DEBUG_MAC80211(priv, "enter\n");

@@ -2050,15 +2049,10 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
        WARN_ON(ctx->vif != vif);
        ctx->vif = NULL;

-       iwl_scan_cancel_timeout(priv, 100);
+       if (priv->scan_vif == vif)
+               iwl_scan_cancel_timeout(priv, 100);
        iwl_set_mode(priv, vif);

-       if (priv->scan_vif == vif) {
-               scan_completed = true;
-               priv->scan_vif = NULL;
-               priv->scan_request = NULL;
-       }
-
        /*
         * When removing the IBSS interface, overwrite the
         * BT traffic load with the stored one from the last
@@ -2072,9 +2066,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
        memset(priv->bssid, 0, ETH_ALEN);
        mutex_unlock(&priv->mutex);

-       if (scan_completed)
-               ieee80211_scan_completed(priv->hw, true);
-
        IWL_DEBUG_MAC80211(priv, "leave\n");

 }
@@ -2255,6 +2246,7 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)

        spin_unlock_irqrestore(&priv->lock, flags);

+       iwl_scan_cancel_timeout(priv, 100);

Not sure, do we need to check vif match?

Thanks
Wey

