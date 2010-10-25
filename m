Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0JYIby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 04:31:54 -0400
Date: Mon, 25 Oct 2010 10:34:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] iwlwifi: warn when send tx power settings during scan
Message-ID: <20101025083436.GB2343@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
 <1287760985.8143.0.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1287760985.8143.0.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Fri, Oct 22, 2010 at 08:23:05AM -0700, Guy, Wey-Yi wrote:
> On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> > +	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
> > +		      "TX Power requested while scanning!\n"))
> > +		return -EIO;
> 
> what reason we want to return -EIO instead of -EAGAIN?

I though EAGAIN should be used for file nonblock I/O, but seems
it can be used anywhere when resources are unavailable. If it
make difference, we can apply this patch instead:

>From 7905309bfeae1a8374d3caa757d9f9383c15d700 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 22 Oct 2010 13:23:41 +0200
Subject: [PATCH 1/7 v2] iwlwifi: warn when send tx power settings during scan

Add WARN_ONCE when scanning is pending. Use STATUS_SCAN_HW bit since we
can have scan canceled or completed but STATUS_SCANNING bit still set.

v1 -> v2: replace EIO to EAGAIN

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   10 +++-------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    4 ++++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 176e525..93db6a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1451,6 +1451,10 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
 	};
 	u16 chan;
 
+	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
+		      "TX Power requested while scanning!\n"))
+		return -EAGAIN;
+
 	chan = le16_to_cpu(priv->contexts[IWL_RXON_CTX_BSS].active.channel);
 
 	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b207e3e..924f335 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1377,13 +1377,9 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 	u8 ctrl_chan_high = 0;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		/* If this gets hit a lot, switch it to a BUG() and catch
-		 * the stack trace to find out who is calling this during
-		 * a scan. */
-		IWL_WARN(priv, "TX Power requested while scanning!\n");
-		return -EAGAIN;
-	}
+	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
+		      "TX Power requested while scanning!\n"))
+		return -EAGAIN;
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b555edd..5d76a5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -496,6 +496,10 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	struct iwlagn_tx_power_dbm_cmd tx_power_cmd;
 	u8 tx_ant_cfg_cmd;
 
+	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
+		      "TX Power requested while scanning!\n"))
+		return -EAGAIN;
+
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
 
-- 
1.7.1

