Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0HHCNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:13:11 -0400
Subject: [PATCH 2/5] libertas: add two-stage firmware request helper
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1281233470.6235.12.camel@dcbw.foobar.com>
References: <1281233470.6235.12.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:14:33 -0500
Message-ID: <1281233673.6235.15.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO, GSPI, and CS all use 2-stage firmware and the loading
process and logic should be the same.  Allow module parameters
to override the automatic firmware choice, otherwise just walk
the bus driver's firmware table and pick out the first firmware
pair that exists for the given model.

Some special care is taken to allow overriding of just the helper
or the main firmware, but let the other of the pair be chosen
automatically.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/decl.h |   13 ++++
 drivers/net/wireless/libertas/main.c |  105 ++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 1d141fe..2ae752d 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -8,7 +8,14 @@
 #define _LBS_DECL_H_
 
 #include <linux/netdevice.h>
+#include <linux/firmware.h>
 
+/* Should be terminated by a NULL entry */
+struct lbs_fw_table {
+	int model;
+	const char *helper;
+	const char *fwname;
+};
 
 struct lbs_private;
 struct sk_buff;
@@ -53,4 +60,10 @@ int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
 
+int lbs_get_firmware(struct device *dev, const char *user_helper,
+			const char *user_mainfw, u32 card_model,
+			const struct lbs_fw_table *fw_table,
+			const struct firmware **helper,
+			const struct firmware **mainfw);
+
 #endif
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 24958a8..47ce5a6 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1047,6 +1047,111 @@ void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx)
 }
 EXPORT_SYMBOL_GPL(lbs_notify_command_response);
 
+/**
+ *  @brief Retrieves two-stage firmware
+ *
+ *  @param dev     	A pointer to device structure
+ *  @param user_helper	User-defined helper firmware file
+ *  @param user_mainfw	User-defined main firmware file
+ *  @param card_model	Bus-specific card model ID used to filter firmware table
+ *                         elements
+ *  @param fw_table	Table of firmware file names and device model numbers
+ *                         terminated by an entry with a NULL helper name
+ *  @param helper	On success, the helper firmware; caller must free
+ *  @param mainfw	On success, the main firmware; caller must free
+ *
+ *  @return		0 on success, non-zero on failure
+ */
+int lbs_get_firmware(struct device *dev, const char *user_helper,
+			const char *user_mainfw, u32 card_model,
+			const struct lbs_fw_table *fw_table,
+			const struct firmware **helper,
+			const struct firmware **mainfw)
+{
+	const struct lbs_fw_table *iter;
+	int ret;
+
+	BUG_ON(helper == NULL);
+	BUG_ON(mainfw == NULL);
+
+	/* Try user-specified firmware first */
+	if (user_helper) {
+		ret = request_firmware(helper, user_helper, dev);
+		if (ret) {
+			lbs_pr_err("couldn't find helper firmware %s",
+					user_helper);
+			goto fail;
+		}
+	}
+	if (user_mainfw) {
+		ret = request_firmware(mainfw, user_mainfw, dev);
+		if (ret) {
+			lbs_pr_err("couldn't find main firmware %s",
+					user_mainfw);
+			goto fail;
+		}
+	}
+
+	if (*helper && *mainfw)
+		return 0;
+
+	/* Otherwise search for firmware to use.  If neither the helper or
+	 * the main firmware were specified by the user, then we need to
+	 * make sure that found helper & main are from the same entry in
+	 * fw_table.
+	 */
+	iter = fw_table;
+	while (iter && iter->helper) {
+		if (iter->model != card_model)
+			goto next;
+
+		if (*helper == NULL) {
+			ret = request_firmware(helper, iter->helper, dev);
+			if (ret)
+				goto next;
+
+			/* If the device has one-stage firmware (ie cf8305) and
+			 * we've got it then we don't need to bother with the
+			 * main firmware.
+			 */
+			if (iter->fwname == NULL)
+				return 0;
+		}
+
+		if (*mainfw == NULL) {
+			ret = request_firmware(mainfw, iter->fwname, dev);
+			if (ret && !user_helper) {
+				/* Clear the helper if it wasn't user-specified
+				 * and the main firmware load failed, to ensure
+				 * we don't have mismatched firmware pairs.
+				 */
+				release_firmware(*helper);
+				*helper = NULL;
+			}
+		}
+
+		if (*helper && *mainfw)
+			return 0;
+
+  next:
+		iter++;
+	}
+
+  fail:
+	/* Failed */
+	if (*helper) {
+		release_firmware(*helper);
+		*helper = NULL;
+	}
+	if (*mainfw) {
+		release_firmware(*mainfw);
+		*mainfw = NULL;
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(lbs_get_firmware);
+
 static int __init lbs_init_module(void)
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
-- 
1.7.2.1


