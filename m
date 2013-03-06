Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:41232 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3CFG4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 01:56:13 -0500
Subject: [PATCH] ath6kl: print firmware capabilities
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 06 Mar 2013 08:56:06 +0200
Message-ID: <20130306065606.23473.77631.stgit@localhost6.localdomain6> (sfid-20130306_075616_728178_4F50CEA1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Printin the  firmware capabilities during the first firmware boot makes it easier to find out what
features firmware supports.

Obligatory screenshot:

[21025.678481] ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144 api 3
[21025.678667] ath6kl: firmware supports: sched-scan,sta-p2pdev-duplex,rsn-cap-override

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   73 ++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 072a229..3e45adc 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1549,10 +1549,81 @@ static const char *ath6kl_init_get_hif_name(enum ath6kl_hif_type type)
 	return NULL;
 }
 
+
+static const struct fw_capa_str_map {
+	int id;
+	const char *name;
+} fw_capa_map[] = {
+	{ ATH6KL_FW_CAPABILITY_HOST_P2P, "host-p2p" },
+	{ ATH6KL_FW_CAPABILITY_SCHED_SCAN, "sched-scan" },
+	{ ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX, "sta-p2pdev-duplex" },
+	{ ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT, "inactivity-timeout" },
+	{ ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE, "rsn-cap-override" },
+	{ ATH6KL_FW_CAPABILITY_WOW_MULTICAST_FILTER, "wow-mc-filter" },
+	{ ATH6KL_FW_CAPABILITY_BMISS_ENHANCE, "bmiss-enhance" },
+	{ ATH6KL_FW_CAPABILITY_SCHED_SCAN_MATCH_LIST, "sscan-match-list" },
+	{ ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD, "rssi-scan-thold" },
+	{ ATH6KL_FW_CAPABILITY_CUSTOM_MAC_ADDR, "custom-mac-addr" },
+	{ ATH6KL_FW_CAPABILITY_TX_ERR_NOTIFY, "tx-err-notify" },
+	{ ATH6KL_FW_CAPABILITY_REGDOMAIN, "regdomain" },
+	{ ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2, "sched-scan-v2" },
+	{ ATH6KL_FW_CAPABILITY_HEART_BEAT_POLL, "hb-poll" },
+};
+
+static const char *ath6kl_init_get_fw_capa_name(unsigned int id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fw_capa_map); i++) {
+		if (fw_capa_map[i].id == id)
+			return fw_capa_map[i].name;
+	}
+
+	return "<unknown>";
+}
+
+static void ath6kl_init_get_fwcaps(struct ath6kl *ar, char *buf, size_t buf_len)
+{
+	u8 *data = (u8 *) ar->fw_capabilities;
+	size_t trunc_len, len = 0;
+	int i, index, bit;
+	char *trunc = "...";
+
+	for (i = 0; i < ATH6KL_FW_CAPABILITY_MAX; i++) {
+		index = i / 8;
+		bit = i % 8;
+
+		if (index >= sizeof(ar->fw_capabilities) * 4)
+			break;
+
+		if (buf_len - len < 4) {
+			ath6kl_warn("firmware capability buffer too small!\n");
+
+			/* add "..." to the end of string */
+			trunc_len = strlen(trunc) + 1;
+			strncpy(buf + buf_len - trunc_len, trunc, trunc_len);
+
+			return;
+		}
+
+		if (data[index] & (1 << bit)) {
+			len += scnprintf(buf + len, buf_len - len, "%s,",
+					    ath6kl_init_get_fw_capa_name(i));
+		}
+	}
+
+	/* overwrite the last comma */
+	if (len > 0)
+		len--;
+
+	buf[len] = '\0';
+}
+
 static int __ath6kl_init_hw_start(struct ath6kl *ar)
 {
 	long timeleft;
 	int ret, i;
+	char buf[200];
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT, "hw start\n");
 
@@ -1615,6 +1686,8 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 			    ar->wiphy->fw_version,
 			    ar->fw_api,
 			    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
+		ath6kl_init_get_fwcaps(ar, buf, sizeof(buf));
+		ath6kl_info("firmware supports: %s\n", buf);
 	}
 
 	if (ar->version.abi_ver != ATH6KL_ABI_VERSION) {

