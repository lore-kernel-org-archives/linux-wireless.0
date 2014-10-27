Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaJ0Kpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 06:45:33 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211-hwsim: Rename CREATE and DESTROY radio to NEW and DEL radio
Date: Mon, 27 Oct 2014 12:44:46 +0200
Message-Id: <1414406688-3827-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114542_004307_3D71781D)
In-Reply-To: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the name HWSIM_CMD_NEW_RADIO and HWSIM_CMD_DEL_RADIO is more
fitting on how other pieces of the wireless system work.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index c9d0315..1f4f790 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -65,9 +65,10 @@ enum hwsim_tx_control_flags {
  * kernel, uses:
  *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
  *	%HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
- * @HWSIM_CMD_CREATE_RADIO: create a new radio with the given parameters,
- *	returns the radio ID (>= 0) or negative on errors
- * @HWSIM_CMD_DESTROY_RADIO: destroy a radio
+ * @HWSIM_CMD_NEW_RADIO: create a new radio with the given parameters,
+ *	returns the radio ID (>= 0) or negative on errors, if successful
+ *	then multicast the result
+ * @HWSIM_CMD_DEL_RADIO: destroy a radio, reply is multicasted
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -75,12 +76,15 @@ enum {
 	HWSIM_CMD_REGISTER,
 	HWSIM_CMD_FRAME,
 	HWSIM_CMD_TX_INFO_FRAME,
-	HWSIM_CMD_CREATE_RADIO,
-	HWSIM_CMD_DESTROY_RADIO,
+	HWSIM_CMD_NEW_RADIO,
+	HWSIM_CMD_DEL_RADIO,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
 
+#define HWSIM_CMD_CREATE_RADIO   HWSIM_CMD_NEW_RADIO
+#define HWSIM_CMD_DESTROY_RADIO  HWSIM_CMD_DEL_RADIO
+
 /**
  * enum hwsim_attrs - hwsim netlink attributes
  *
-- 
1.8.3.1

