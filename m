Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3A1Jih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:38:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 17/37] iwlwifi: add the MVM driver (led)
Date: Mon, 28 Jan 2013 10:37:24 +0100
Message-Id: <1359365864-4259-18-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103928_775616_173814A2)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware revisions have a completely new
firmware API. This is the new driver for this
new API.

I've listed the people who directly contributed
code, but many others from various teams have
contributed in other ways.

Change-Id: Id62a7ce1b80ec762c9a902b93188d3502837b77b
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Amit Beka <amit.beka@intel.com>
Cc: Amnon Paz <amnonx.paz@intel.com>
Cc: Assaf Krauss <assaf.krauss@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
Cc: Dor Shaish <dor.shaish@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/led.c | 135 +++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/led.c

diff --git a/drivers/net/wireless/iwlwifi/mvm/led.c b/drivers/net/wireless/iwlwifi/mvm/led.c
new file mode 100644
index 0000000..db460a3
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/led.c
@@ -0,0 +1,135 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <linux/leds.h>
+#include "iwl-io.h"
+#include "iwl-csr.h"
+#include "mvm.h"
+
+/* Set led register on */
+static void iwl_mvm_led_enable(struct iwl_mvm *mvm)
+{
+	iwl_write32(mvm->trans, CSR_LED_REG, CSR_LED_REG_TURN_ON);
+}
+
+/* Set led register off */
+static void iwl_mvm_led_disable(struct iwl_mvm *mvm)
+{
+	iwl_write32(mvm->trans, CSR_LED_REG, CSR_LED_REG_TURN_OFF);
+}
+
+static void iwl_led_brightness_set(struct led_classdev *led_cdev,
+				   enum led_brightness brightness)
+{
+	struct iwl_mvm *mvm = container_of(led_cdev, struct iwl_mvm, led);
+	if (brightness > 0)
+		iwl_mvm_led_enable(mvm);
+	else
+		iwl_mvm_led_disable(mvm);
+}
+
+int iwl_leds_init(struct iwl_mvm *mvm)
+{
+	int mode = iwlwifi_mod_params.led_mode;
+	int ret;
+
+	switch (mode) {
+	case IWL_LED_DEFAULT:
+	case IWL_LED_RF_STATE:
+		mode = IWL_LED_RF_STATE;
+		break;
+	case IWL_LED_DISABLE:
+		IWL_INFO(mvm, "Led disabled\n");
+		return 0;
+	default:
+		return -EINVAL;
+	};
+
+	mvm->led.name = kasprintf(GFP_KERNEL, "%s-led",
+				   wiphy_name(mvm->hw->wiphy));
+	mvm->led.brightness_set = iwl_led_brightness_set;
+	mvm->led.blink_set = NULL;
+	mvm->led.max_brightness = 1;
+
+	if (mode == IWL_LED_RF_STATE)
+		mvm->led.default_trigger =
+			ieee80211_get_radio_led_name(mvm->hw);
+
+	ret = led_classdev_register(mvm->trans->dev, &mvm->led);
+	if (ret) {
+		kfree(mvm->led.name);
+		IWL_INFO(mvm, "Failed to enable led\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+void iwl_leds_exit(struct iwl_mvm *mvm)
+{
+	if (iwlwifi_mod_params.led_mode == IWL_LED_DISABLE)
+		return;
+
+	led_classdev_unregister(&mvm->led);
+	kfree(mvm->led.name);
+}
-- 
1.8.0

