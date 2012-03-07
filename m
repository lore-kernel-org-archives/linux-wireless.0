Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42625 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932652Ab2CGUXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 15:23:34 -0500
Message-ID: <1331151811.2140.75.camel@joe2Laptop> (sfid-20120307_212340_628487_104067E1)
Subject: [PATCH] iwlwifi: Add __printf verification
From: Joe Perches <joe@perches.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Date: Wed, 07 Mar 2012 12:23:31 -0800
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure that arguments match formats.
All current uses do.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 01b2330..42e6bbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -34,10 +34,14 @@
 
 struct iwl_priv;
 
+__printf(4, 5)
 void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
 		const char *fmt, ...);
+__printf(2, 3)
 void __iwl_warn(struct device *dev, const char *fmt, ...);
+__printf(2, 3)
 void __iwl_info(struct device *dev, const char *fmt, ...);
+__printf(2, 3)
 void __iwl_crit(struct device *dev, const char *fmt, ...);
 
 /* No matter what is m (priv, bus, trans), this will work */
@@ -47,10 +51,12 @@ void __iwl_crit(struct device *dev, const char *fmt, ...);
 #define IWL_CRIT(m, f, a...) __iwl_crit(trans(m)->dev, f, ## a)
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
+__printf(6, 7)
 void __iwl_dbg(struct iwl_shared *shared, struct device *dev,
 	       u32 level, bool limit, const char *function,
 	       const char *fmt, ...);
 #else
+__printf(6, 7)
 static inline void
 __iwl_dbg(struct iwl_shared *shared, struct device *dev,
 	  u32 level, bool limit, const char *function,


