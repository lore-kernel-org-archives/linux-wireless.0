Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaFEMoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:44:22 -0400
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] ieee80211.h: Add definitions for 20/40 BSS Coexistence Management action frame
Date: Thu,  5 Jun 2014 14:44:15 +0200
Message-Id: <1401972255-18815-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20140605_144426_668083_A4E70ED7)
In-Reply-To: <1401972255-18815-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1401972255-18815-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 include/linux/ieee80211.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6bff13f..bd5fcb1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -836,6 +836,36 @@ enum ieee80211_vht_opmode_bits {
 	IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF	= 0x80,
 };
 
+/**
+ * struct ieee80211_2040_bss_coexist_ie - 20/40 BSS coexist IE
+ */
+struct ieee80211_bss_2040_coexist_ie {
+	u8 coexist_info;
+} __packed;
+
+/**
+ * enum bss_2040_coexist_flags - 20/40 BSS Coexistence IE info field flags
+ *
+ * @IEEE80211_BSS2040_COEXIST_INFO_REQ: STA is requesting recipient to transmit
+ *	a 20/40 BSS Coexistence Management frame with transmitting STA as
+ *	recipient
+ * @IEEE80211_BSS2040_COEXIST_40_INTOLERANT: Prohibit an AP receiving this
+ *	information or reports of this transmit from operating a 20/40 MHz BSS
+ * @IEEE80211_BSS2040_COEXIST_20_BSS_REQ: Prohibit a receiving AP from
+ *	operating it's BSS as a 20/40 MHz BSS. Used for intra-BSS communication
+ * @IEEE80211_BSS2040_COEXIST_OBSS_SCAN_EXEM_REQ: Request excemption from OBSS
+ *	scanning
+ * @IEEE80211_BSS2040_COEXIST_OBSS_SCAN_EXEM_GRANT: Receiving STA is granted
+ *	excemption from OBSS scanning
+ */
+enum bss_2040_coexist_flags {
+	IEEE80211_BSS2040_COEXIST_INFO_REQ		= 0x01,
+	IEEE80211_BSS2040_COEXIST_40_INTOLERANT		= 0x02,
+	IEEE80211_BSS2040_COEXIST_20_BSS_REQ		= 0x04,
+	IEEE80211_BSS2040_COEXIST_OBSS_SCAN_EXEM_REQ	= 0x08,
+	IEEE80211_BSS2040_COEXIST_OBSS_SCAN_EXEM_GRANT	= 0x10,
+};
+
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
 struct ieee80211_mgmt {
@@ -973,6 +1003,12 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 operating_mode;
 				} __packed vht_opmode_notif;
+				struct{
+					u8 action_code;
+					struct ieee80211_bss_2040_coexist_ie
+						bss_coexistence;
+					u8 variable[0];
+				} __packed bss_2040_coexist;
 			} u;
 		} __packed action;
 	} u;
-- 
1.9.3

