Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40759 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXLSQJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:57 -0500
Subject: [PATCH 116/48] libertas: add SLEEP_PERIOD and FW_WAKE_METHOD command definitions
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50tp-0001zw-OG@pmac.infradead.org> (sfid-20071219_160959_419318_4129913B)
Date: Wed, 19 Dec 2007 15:31:57 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 16 Dec 2007 21:43:40 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/host.h    |    2 ++
 drivers/net/wireless/libertas/hostcmd.h |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index fe00081..bdf9017 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -84,8 +84,10 @@
 #define CMD_802_11_KEY_MATERIAL			0x005e
 #define CMD_802_11_SLEEP_PARAMS			0x0066
 #define CMD_802_11_INACTIVITY_TIMEOUT		0x0067
+#define CMD_802_11_SLEEP_PERIOD			0x0068
 #define CMD_802_11_TPC_CFG			0x0072
 #define CMD_802_11_PWR_CFG			0x0073
+#define CMD_802_11_FW_WAKE_METHOD		0x0074
 #define CMD_802_11_SUBSCRIBE_EVENT		0x0075
 #define CMD_802_11_RATE_ADAPT_RATESET		0x0076
 #define CMD_802_11_TX_RATE_QUERY		0x007f
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index ea4d484..b38502f 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -439,6 +439,20 @@ struct cmd_ds_set_boot2_ver {
 	__le16 version;
 };
 
+struct cmd_ds_802_11_fw_wake_method {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 method;
+};
+
+struct cmd_ds_802_11_sleep_period {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 period;
+};
+
 struct cmd_ds_802_11_ps_mode {
 	__le16 action;
 	__le16 nullpktinterval;
-- 
1.5.3.4

