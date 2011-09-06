Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12269 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1IFHbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 03:31:45 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Process regulatory requests from firmware.
Date: Tue, 6 Sep 2011 13:01:36 +0530
Message-ID: <1315294296-3712-1-git-send-email-vivek.natarajan@qca.qualcomm.com> (sfid-20110906_093149_226980_A1766E55)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <nataraja@qca.qualcomm.com>

Process the regulatory code from eeprom and pass the
country information to cfg80211.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   78 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |    6 +++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index c9ec630..8f2ff33 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -18,6 +18,8 @@
 #include "core.h"
 #include "debug.h"
 #include "testmode.h"
+#include "../regd.h"
+#include "../regd_common.h"
 
 static int ath6kl_wmi_sync_point(struct wmi *wmi);
 
@@ -745,6 +747,81 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
+static struct country_code_to_enum_rd*
+ath6kl_regd_find_country(u16 countryCode)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
+		if (allCountries[i].countryCode == countryCode)
+			return &allCountries[i];
+	}
+
+	return NULL;
+}
+
+static struct reg_dmn_pair_mapping*
+ath6kl_get_regpair(u16 regdmn)
+{
+	int i;
+
+	if (regdmn == NO_ENUMRD)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++) {
+		if (regDomainPairs[i].regDmnEnum == regdmn)
+			return &regDomainPairs[i];
+	}
+
+	return NULL;
+}
+
+static struct country_code_to_enum_rd*
+ath6kl_regd_find_country_by_rd(u16 regdmn)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
+		if (allCountries[i].regDmnEnum == regdmn)
+			return &allCountries[i];
+	}
+
+	return NULL;
+}
+
+static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
+{
+
+	struct ath6kl_wmi_regdomain *ev;
+	struct country_code_to_enum_rd *country = NULL;
+	struct reg_dmn_pair_mapping *regpair = NULL;
+	char alpha2[2];
+	u32 reg_code;
+
+	ev = (struct ath6kl_wmi_regdomain *) datap;
+	reg_code = le32_to_cpu(ev->reg_code);
+
+	if ((reg_code >> ATH6KL_COUNTRY_RD_SHIFT) & COUNTRY_ERD_FLAG)
+		country = ath6kl_regd_find_country((u16) reg_code);
+	else if (!(((u16) reg_code & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)) {
+
+		regpair = ath6kl_get_regpair((u16) reg_code);
+		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
+		ath6kl_dbg(ATH6KL_DBG_WMI, "ath6kl: Regpair used: 0x%0x\n",
+				regpair->regDmnEnum);
+	}
+
+	if (country) {
+		alpha2[0] = country->isoName[0];
+		alpha2[1] = country->isoName[1];
+
+		regulatory_hint(wmi->parent_dev->wdev->wiphy, alpha2);
+
+		ath6kl_dbg(ATH6KL_DBG_WMI, "ath6kl: Country alpha2 being used: %c%c\n",
+				alpha2[0], alpha2[1]);
+	}
+}
+
 static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_disconnect_event *ev;
@@ -3033,6 +3110,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_REGDOMAIN_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REGDOMAIN_EVENTID\n");
+		ath6kl_wmi_regdomain_event(wmi, datap, len);
 		break;
 	case WMI_PSTREAM_TIMEOUT_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PSTREAM_TIMEOUT_EVENTID\n");
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index a78e21b..bb4edff 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1306,6 +1306,12 @@ enum wmi_disconnect_reason {
 	IBSS_MERGE = 0xe,
 };
 
+#define ATH6KL_COUNTRY_RD_SHIFT        16
+
+struct ath6kl_wmi_regdomain {
+	__le32 reg_code;
+};
+
 struct wmi_disconnect_event {
 	/* reason code, see 802.11 spec. */
 	__le16 proto_reason_status;
-- 
1.7.1

