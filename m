Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXKZOVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:50 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 08/15] iwlwifi: 802.11n remove unnecessary config dependency
Date: Mon, 26 Nov 2007 16:14:35 +0200
Message-Id: <11960864912323-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_142159_540169_9719CB41)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes MAC80211_HT config dependency as it has been
eliminated in mac80211, and adds a needed QoS dependency

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index abd0ce0..d87e34b 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -33,6 +33,14 @@ config IWL4965_QOS
 	  This option will enable wireless quality of service (QoS) for the
 	  iw4965 driver.
 
+config IWL4965_HT
+	bool "Enable 802.11n HT features in iwl4965 driver"
+	depends on EXPERIMENTAL
+	depends on IWL4965 && IWL4965_QOS
+	---help---
+	  This option enables IEEE 802.11n High Throughput features
+	  for the iwl4965 driver.
+
 config IWL4965_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iw4965 driver"
 	depends on IWL4965
@@ -46,14 +54,6 @@ config IWL4965_SENSITIVITY
 	  This option will enable sensitivity calibration for the iwl4965
 	  driver.
 
-config IWL4965_HT
-	bool "Enable 802.11n HT features in iwl4965 driver"
-	depends on EXPERIMENTAL
-	depends on IWL4965 && MAC80211_HT
-	---help---
-	  This option enables IEEE 802.11n High Throughput features
-	  for the iwl4965 driver.
-
 config IWL4965_DEBUG
 	bool "Enable full debugging output in iwl4965 driver"
 	depends on IWL4965
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
