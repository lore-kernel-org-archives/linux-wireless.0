Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2116 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959Ab3HMUEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 04/13] brcmsmac: add switch control table for BCM4313
 iPA BT-combo cards
Date: Tue, 13 Aug 2013 22:03:31 +0200
Message-ID: <1376424220-10765-5-git-send-email-arend@broadcom.com> (sfid-20130813_220441_166609_CA9BA232)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bcm4313 iPA BT-WLAN combo cards need to be initialized with
a different switch control table. This patch adds that table.

Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |   72 ++++++++++++++++++++
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |    1 +
 2 files changed, 73 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
index deae3a7..36c41df 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -2044,6 +2044,73 @@ static const u16 dot11lcn_sw_ctrl_tbl_4313_rev0[] = {
 	0x0005,
 };
 
+static const u16 dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo[] = {
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+};
+
 static const u16 dot11lcn_sw_ctrl_tbl_rev0[] = {
 	0x0004,
 	0x0004,
@@ -2808,6 +2875,11 @@ const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313 = {
 	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_rev0), 15, 0, 16
 };
 
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa = {
+	&dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo,
+	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo), 15, 0, 16
+};
+
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0,
 	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_epa_rev0), 15, 0, 16
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 5f75e16..489422a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -20,6 +20,7 @@
 extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa_combo;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
-- 
1.7.10.4


