Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41816 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965972AbXD1QmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 7/7] mac80211: Allow drivers to configure default regulatory domain
Date: Sat, 28 Apr 2007 12:36:02 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163602.27203.93106.stgit@magic.sourmilk.net>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch allows drivers to configure the default set of channels if the
device reports its default regulatory domain.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/net/mac80211.h   |    8 ++++++--
 net/mac80211/ieee80211.c |    3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f0cfe88..96321be 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -52,7 +52,9 @@
  * freq, and val fields. Other fields will be filled in by 80211.o based on
  * hostapd information and low-level driver does not need to use them. The
  * limits for each channel will be provided in 'struct ieee80211_conf' when
- * configuring the low-level driver with hw->config callback. */
+ * configuring the low-level driver with hw->config callback. If a device has
+ * a default regulatory domain, IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED
+ * can be set to let the driver configure all fields */
 struct ieee80211_channel {
 	short chan; /* channel number (IEEE 802.11) */
 	short freq; /* frequency in MHz */
@@ -528,7 +530,9 @@ struct ieee80211_hw {
 	 * receive all probe responses while scanning */
 #define IEEE80211_HW_NO_PROBE_FILTERING (1<<10)
 
-	/* please fill this gap when adding new flags */
+	/* Channels are already configured to the default regulatory domain
+	 * specified in the device's EEPROM */
+#define IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED (1<<11)
 
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
 #define IEEE80211_HW_TKIP_INCLUDE_MMIC (1<<12)
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 2b6cb06..f609e6c 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4837,7 +4837,8 @@ int ieee80211_register_hwmode(struct ieee80211_hw *hw,
 		local->hw.conf.chan = local->oper_channel;
 	}
 
-	ieee80211_init_client(local->mdev);
+	if (!(hw->flags & IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED))
+		ieee80211_init_client(local->mdev);
 
 	return 0;
 }

