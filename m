Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:54896 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab1ILLMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:13 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 87C1D8C79D
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:11 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 736272BD47
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:07 +0300 (EEST)
Subject: [PATCH 1/9] ath6kl: query device tree for firmware board-id
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:06 +0300
Message-ID: <20110912111206.16921.90687.stgit@localhost6.localdomain6> (sfid-20110912_131221_507177_E4E4C22E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

When no default board data file is present query the device tree for a
board-id setting to identify the board data to use.  If the FDT lacks the
necesary info fall back to the previous behaviour of using a compile-time
board filename.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   64 ++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index eca34aa..9171670 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -15,6 +15,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/of.h>
 #include <linux/mmc/sdio_func.h>
 #include "core.h"
 #include "cfg80211.h"
@@ -680,6 +681,64 @@ static int ath6kl_get_fw(struct ath6kl *ar, const char *filename,
 	return ret;
 }
 
+#ifdef CONFIG_OF
+static const char *get_target_ver_dir(const struct ath6kl *ar)
+{
+	switch (ar->version.target_ver) {
+	case AR6003_REV1_VERSION:
+		return "ath6k/AR6003/hw1.0";
+	case AR6003_REV2_VERSION:
+		return "ath6k/AR6003/hw2.0";
+	case AR6003_REV3_VERSION:
+		return "ath6k/AR6003/hw2.1.1";
+	}
+	ath6kl_warn("%s: unsupported target version 0x%x.\n", __func__,
+		    ar->version.target_ver);
+	return NULL;
+}
+
+/*
+ * Check the device tree for a board-id and use it to construct
+ * the pathname to the firmware file.  Used (for now) to find a
+ * fallback to the "bdata.bin" file--typically a symlink to the
+ * appropriate board-specific file.
+ */
+static bool check_device_tree(struct ath6kl *ar)
+{
+	static const char *board_id_prop = "atheros,board-id";
+	struct device_node *node;
+	char board_filename[64];
+	const char *board_id;
+	int ret;
+
+	for_each_compatible_node(node, NULL, "atheros,ath6kl") {
+		board_id = of_get_property(node, board_id_prop, NULL);
+		if (board_id == NULL) {
+			ath6kl_warn("No \"%s\" property on %s node.\n",
+				    board_id_prop, node->name);
+			continue;
+		}
+		snprintf(board_filename, sizeof(board_filename),
+			 "%s/bdata.%s.bin", get_target_ver_dir(ar), board_id);
+
+		ret = ath6kl_get_fw(ar, board_filename, &ar->fw_board,
+				    &ar->fw_board_len);
+		if (ret) {
+			ath6kl_err("Failed to get DT board file %s: %d\n",
+				   board_filename, ret);
+			continue;
+		}
+		return true;
+	}
+	return false;
+}
+#else
+static bool check_device_tree(struct ath6kl *ar)
+{
+	return false;
+}
+#endif /* CONFIG_OF */
+
 static int ath6kl_fetch_board_file(struct ath6kl *ar)
 {
 	const char *filename;
@@ -704,6 +763,11 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 		return 0;
 	}
 
+	if (check_device_tree(ar)) {
+		/* got board file from device tree */
+		return 0;
+	}
+
 	/* there was no proper board file, try to use default instead */
 	ath6kl_warn("Failed to get board file %s (%d), trying to find default board file.\n",
 		    filename, ret);

