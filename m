Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:51991 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3IHO4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:56:15 -0400
Subject: [PATCH 8/8] ath10k: print phymode as a string
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:56:14 +0300
Message-ID: <20130908145614.3136.89727.stgit@localhost6.localdomain6> (sfid-20130908_165618_253594_58B338D5)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it easier to read debug logs.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    9 ++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |   42 +++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b8c81bb..2b11856 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -460,6 +460,11 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 		arg.ssid_len = arvif->vif->bss_conf.ssid_len;
 	}
 
+	ath10k_dbg(ATH10K_DBG_MAC,
+		   "mac vdev %d start center_freq %d phymode %s\n",
+		   arg.vdev_id, arg.channel.freq,
+		   ath10k_wmi_phymode_str(arg.channel.mode));
+
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
 		ath10k_warn("WMI vdev start failed: ret %d\n", ret);
@@ -1104,8 +1109,8 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 		break;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac peer %pM phymode %d\n",
-		   sta->addr, phymode);
+	ath10k_dbg(ATH10K_DBG_MAC, "mac peer %pM phymode %s\n",
+		   sta->addr, ath10k_wmi_phymode_str(phymode));
 
 	arg->peer_phymode = phymode;
 	WARN_ON(phymode == MODE_UNKNOWN);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 40fcf05..ab46582 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -508,6 +508,48 @@ enum wmi_phy_mode {
 	MODE_MAX        = 14
 };
 
+static inline const char *ath10k_wmi_phymode_str(enum wmi_phy_mode mode)
+{
+	switch (mode) {
+	case MODE_11A:
+		return "11a";
+	case MODE_11G:
+		return "11g";
+	case MODE_11B:
+		return "11b";
+	case MODE_11GONLY:
+		return "11gonly";
+	case MODE_11NA_HT20:
+		return "11na-ht20";
+	case MODE_11NG_HT20:
+		return "11ng-ht20";
+	case MODE_11NA_HT40:
+		return "11na-ht40";
+	case MODE_11NG_HT40:
+		return "11ng-ht40";
+	case MODE_11AC_VHT20:
+		return "11ac-vht20";
+	case MODE_11AC_VHT40:
+		return "11ac-vht40";
+	case MODE_11AC_VHT80:
+		return "11ac-vht80";
+	case MODE_11AC_VHT20_2G:
+		return "11ac-vht20-2g";
+	case MODE_11AC_VHT40_2G:
+		return "11ac-vht40-2g";
+	case MODE_11AC_VHT80_2G:
+		return "11ac-vht80-2g";
+	case MODE_UNKNOWN:
+		/* skip */
+		break;
+
+		/* no default handler to allow compiler to check that the
+		 * enum is fully handled */
+	};
+
+	return "<unknown>";
+}
+
 #define WMI_CHAN_LIST_TAG	0x1
 #define WMI_SSID_LIST_TAG	0x2
 #define WMI_BSSID_LIST_TAG	0x3

