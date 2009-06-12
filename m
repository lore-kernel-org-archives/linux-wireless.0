Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64953 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZFLLRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:17:15 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 24/33] wl12xx: Use chipset specific join commands
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:52 +0300
Message-ID: <20090612111652.8877.59676.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add implementation to use chipset specific join commands.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/cmd.h    |    2 +-
 drivers/net/wireless/wl12xx/main.c   |    9 +++++----
 drivers/net/wireless/wl12xx/wl1251.c |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    2 ++
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index fb4e996..cad258d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -253,7 +253,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait)
 {
 	unsigned long timeout;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 7aef1f2..a2eae54 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -36,7 +36,7 @@ int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len);
 int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
 int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable);
-int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait);
 int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode);
 int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 245544e..a2aebac 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -243,7 +243,8 @@ static void wl12xx_filter_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
+	/* FIXME: replace the magic numbers with proper definitions */
+	ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -534,7 +535,7 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (channel != wl->channel) {
 		/* FIXME: use beacon interval provided by mac80211 */
-		ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1082,7 +1083,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl12xx_cmd_join(wl, wl->bss_type, 5, 100, 1);
+			ret = wl->chip.op_cmd_join(wl, wl->bss_type, 5, 100, 1);
 			if (ret < 0)
 				goto out;
 		}
@@ -1106,7 +1107,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out;
 
-		ret = wl12xx_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
 
 		if (ret < 0)
 			goto out;
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index 5f6e75c..77494a9 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -717,6 +717,7 @@ void wl1251_setup(struct wl12xx *wl)
 	wl->chip.op_plt_init = wl1251_plt_init;
 	wl->chip.op_fw_version = wl1251_fw_version;
 	wl->chip.op_tx_flush = wl1251_tx_flush;
+	wl->chip.op_cmd_join = wl1251_cmd_join;
 
 	wl->chip.p_table = wl1251_part_table;
 	wl->chip.acx_reg_table = wl1251_acx_reg_table;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index c38aa54..c673cdb 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -165,6 +165,8 @@ struct wl12xx_chip {
 	int (*op_plt_init)(struct wl12xx *wl);
 	void (*op_tx_flush)(struct wl12xx *wl);
 	void (*op_fw_version)(struct wl12xx *wl);
+	int (*op_cmd_join)(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+			    u16 beacon_interval, u8 wait);
 
 	struct wl12xx_partition_set *p_table;
 	enum wl12xx_acx_int_reg *acx_reg_table;

