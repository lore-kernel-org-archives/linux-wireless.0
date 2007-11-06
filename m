Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:35864 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbXKFOsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 09:48:42 -0500
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IpPjO-0004Fb-C6
	for linux-wireless@vger.kernel.org; Tue, 06 Nov 2007 09:48:42 -0500
Date: Tue, 6 Nov 2007 09:47:02 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] WIRELESS:  Use more obvious "is_power_of_2" macro.
Message-ID: <Pine.LNX.4.64.0711060945510.5429@localhost.localdomain> (sfid-20071106_144846_065180_75F3A9F3)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4f22a71..53b4b4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -50,6 +50,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/log2.h>

 #include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
@@ -343,7 +344,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,

 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+	BUILD_BUG_ON(!is_power_of_2(TFD_QUEUE_SIZE_MAX));
 	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);

 	iwl_hw_tx_queue_init(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d60adcb..5f3bcb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -50,6 +50,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/log2.h>

 #include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
@@ -342,7 +343,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,

 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+	BUILD_BUG_ON(!is_power_of_2(TFD_QUEUE_SIZE_MAX));
 	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);

 	iwl_hw_tx_queue_init(priv, txq);

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
