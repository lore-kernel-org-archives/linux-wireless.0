Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8B5C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65F44205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfDZPuD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:50:03 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21644 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbfDZPuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:50:01 -0400
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367519"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:42 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889767"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:42 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 4/9] wil6210: add support for multiple sections in brd file
Date:   Fri, 26 Apr 2019 18:43:32 +0300
Message-Id: <1556293417-27097-5-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Current board file loading procedure assumes that the board file
includes only one section.
New board files can include multiple sections.
Add the ability to read multiple addresses and max size from FW
file and load multiple sections from the board file into those
addresses.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/fw.h      |  11 ++-
 drivers/net/wireless/ath/wil6210/fw_inc.c  | 148 +++++++++++++++++++++--------
 drivers/net/wireless/ath/wil6210/main.c    |   3 +-
 drivers/net/wireless/ath/wil6210/wil6210.h |   9 +-
 4 files changed, 126 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index 3e7a280..fa31647 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2014,2016 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -109,12 +109,17 @@ struct wil_fw_record_concurrency { /* type == wil_fw_type_comment */
 
 /* brd file info encoded inside a comment record */
 #define WIL_BRD_FILE_MAGIC (0xabcddcbb)
+
+struct brd_info {
+	__le32 base_addr;
+	__le32 max_size_bytes;
+} __packed;
+
 struct wil_fw_record_brd_file { /* type == wil_fw_type_comment */
 	/* identifies brd file record */
 	struct wil_fw_record_comment_hdr hdr;
 	__le32 version;
-	__le32 base_addr;
-	__le32 max_size_bytes;
+	struct brd_info brd_info[0];
 } __packed;
 
 /* perform action
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 3ec0f2f..94ebfa3 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -156,17 +156,52 @@ static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
 		   size_t size)
 {
 	const struct wil_fw_record_brd_file *rec = data;
+	u32 max_num_ent, i, ent_size;
 
-	if (size < sizeof(*rec)) {
-		wil_err_fw(wil, "brd_file record too short: %zu\n", size);
-		return 0;
+	if (size <= offsetof(struct wil_fw_record_brd_file, brd_info)) {
+		wil_err(wil, "board record too short, size %zu\n", size);
+		return -EINVAL;
+	}
+
+	ent_size = size - offsetof(struct wil_fw_record_brd_file, brd_info);
+	max_num_ent = ent_size / sizeof(struct brd_info);
+
+	if (!max_num_ent) {
+		wil_err(wil, "brd info entries are missing\n");
+		return -EINVAL;
 	}
 
-	wil->brd_file_addr = le32_to_cpu(rec->base_addr);
-	wil->brd_file_max_size = le32_to_cpu(rec->max_size_bytes);
+	wil->brd_info = kcalloc(max_num_ent, sizeof(struct wil_brd_info),
+				GFP_KERNEL);
+	if (!wil->brd_info)
+		return -ENOMEM;
 
-	wil_dbg_fw(wil, "brd_file_addr 0x%x, brd_file_max_size %d\n",
-		   wil->brd_file_addr, wil->brd_file_max_size);
+	for (i = 0; i < max_num_ent; i++) {
+		wil->brd_info[i].file_addr =
+			le32_to_cpu(rec->brd_info[i].base_addr);
+		wil->brd_info[i].file_max_size =
+			le32_to_cpu(rec->brd_info[i].max_size_bytes);
+
+		if (!wil->brd_info[i].file_addr)
+			break;
+
+		wil_dbg_fw(wil,
+			   "brd info %d: file_addr 0x%x, file_max_size %d\n",
+			   i, wil->brd_info[i].file_addr,
+			   wil->brd_info[i].file_max_size);
+	}
+
+	wil->num_of_brd_entries = i;
+	if (wil->num_of_brd_entries == 0) {
+		kfree(wil->brd_info);
+		wil->brd_info = NULL;
+		wil_dbg_fw(wil,
+			   "no valid brd info entries, using brd file addr\n");
+
+	} else {
+		wil_dbg_fw(wil, "num of brd info entries %d\n",
+			   wil->num_of_brd_entries);
+	}
 
 	return 0;
 }
@@ -634,6 +669,11 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 	}
 	wil_dbg_fw(wil, "Loading <%s>, %zu bytes\n", name, fw->size);
 
+	/* re-initialize board info params */
+	wil->num_of_brd_entries = 0;
+	kfree(wil->brd_info);
+	wil->brd_info = NULL;
+
 	for (sz = fw->size, d = fw->data; sz; sz -= rc1, d += rc1) {
 		rc1 = wil_fw_verify(wil, d, sz);
 		if (rc1 < 0) {
@@ -662,11 +702,13 @@ static int wil_brd_process(struct wil6210_priv *wil, const void *data,
 {
 	int rc = 0;
 	const struct wil_fw_record_head *hdr = data;
-	size_t s, hdr_sz;
+	size_t s, hdr_sz = 0;
 	u16 type;
+	int i = 0;
 
-	/* Assuming the board file includes only one header record and one data
-	 * record. Each record starts with wil_fw_record_head.
+	/* Assuming the board file includes only one file header
+	 * and one or several data records.
+	 * Each record starts with wil_fw_record_head.
 	 */
 	if (size < sizeof(*hdr))
 		return -EINVAL;
@@ -674,40 +716,67 @@ static int wil_brd_process(struct wil6210_priv *wil, const void *data,
 	if (s > size)
 		return -EINVAL;
 
-	/* Skip the header record and handle the data record */
-	hdr = (const void *)hdr + s;
+	/* Skip the header record and handle the data records */
 	size -= s;
-	if (size < sizeof(*hdr))
-		return -EINVAL;
-	hdr_sz = le32_to_cpu(hdr->size);
 
-	if (wil->brd_file_max_size && hdr_sz > wil->brd_file_max_size)
-		return -EINVAL;
-	if (sizeof(*hdr) + hdr_sz > size)
-		return -EINVAL;
-	if (hdr_sz % 4) {
-		wil_err_fw(wil, "unaligned record size: %zu\n",
-			   hdr_sz);
-		return -EINVAL;
-	}
-	type = le16_to_cpu(hdr->type);
-	if (type != wil_fw_type_data) {
-		wil_err_fw(wil, "invalid record type for board file: %d\n",
-			   type);
-		return -EINVAL;
+	for (hdr = data + s;; hdr = (const void *)hdr + s, size -= s, i++) {
+		if (size < sizeof(*hdr))
+			break;
+
+		if (i >= wil->num_of_brd_entries) {
+			wil_err_fw(wil,
+				   "Too many brd records: %d, num of expected entries %d\n",
+				   i, wil->num_of_brd_entries);
+			break;
+		}
+
+		hdr_sz = le32_to_cpu(hdr->size);
+		s = sizeof(*hdr) + hdr_sz;
+		if (wil->brd_info[i].file_max_size &&
+		    hdr_sz > wil->brd_info[i].file_max_size)
+			return -EINVAL;
+		if (sizeof(*hdr) + hdr_sz > size)
+			return -EINVAL;
+		if (hdr_sz % 4) {
+			wil_err_fw(wil, "unaligned record size: %zu\n",
+				   hdr_sz);
+			return -EINVAL;
+		}
+		type = le16_to_cpu(hdr->type);
+		if (type != wil_fw_type_data) {
+			wil_err_fw(wil,
+				   "invalid record type for board file: %d\n",
+				   type);
+			return -EINVAL;
+		}
+		if (hdr_sz < sizeof(struct wil_fw_record_data)) {
+			wil_err_fw(wil, "data record too short: %zu\n", hdr_sz);
+			return -EINVAL;
+		}
+
+		wil_dbg_fw(wil,
+			   "using info from fw file for record %d: addr[0x%08x], max size %d\n",
+			   i, wil->brd_info[i].file_addr,
+			   wil->brd_info[i].file_max_size);
+
+		rc = __fw_handle_data(wil, &hdr[1], hdr_sz,
+				      cpu_to_le32(wil->brd_info[i].file_addr));
+		if (rc)
+			return rc;
 	}
-	if (hdr_sz < sizeof(struct wil_fw_record_data)) {
-		wil_err_fw(wil, "data record too short: %zu\n", hdr_sz);
+
+	if (size) {
+		wil_err_fw(wil, "unprocessed bytes: %zu\n", size);
+		if (size >= sizeof(*hdr)) {
+			wil_err_fw(wil,
+				   "Stop at offset %ld record type %d [%zd bytes]\n",
+				   (long)((const void *)hdr - data),
+				   le16_to_cpu(hdr->type), hdr_sz);
+		}
 		return -EINVAL;
 	}
 
-	wil_dbg_fw(wil, "using addr from fw file: [0x%08x]\n",
-		   wil->brd_file_addr);
-
-	rc = __fw_handle_data(wil, &hdr[1], hdr_sz,
-			      cpu_to_le32(wil->brd_file_addr));
-
-	return rc;
+	return 0;
 }
 
 /**
@@ -738,7 +807,8 @@ int wil_request_board(struct wil6210_priv *wil, const char *name)
 		rc = dlen;
 		goto out;
 	}
-	/* Process the data record */
+
+	/* Process the data records */
 	rc = wil_brd_process(wil, brd->data, dlen);
 
 out:
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 9b9c9ec..03ca8e5 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -838,6 +838,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	wmi_event_flush(wil);
 	destroy_workqueue(wil->wq_service);
 	destroy_workqueue(wil->wmi_wq);
+	kfree(wil->brd_info);
 }
 
 static void wil_shutdown_bl(struct wil6210_priv *wil)
@@ -1709,7 +1710,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		rc = wil_request_firmware(wil, wil->wil_fw_name, true);
 		if (rc)
 			goto out;
-		if (wil->brd_file_addr)
+		if (wil->num_of_brd_entries)
 			rc = wil_request_board(wil, board_file);
 		else
 			rc = wil_request_firmware(wil, board_file, true);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 8724d99..dc40002 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -913,6 +913,11 @@ struct wil_fw_stats_global {
 	struct wmi_link_stats_global stats;
 };
 
+struct wil_brd_info {
+	u32 file_addr;
+	u32 file_max_size;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	u32 bar_size;
@@ -927,8 +932,8 @@ struct wil6210_priv {
 	const char *hw_name;
 	const char *wil_fw_name;
 	char *board_file;
-	u32 brd_file_addr;
-	u32 brd_file_max_size;
+	u32 num_of_brd_entries;
+	struct wil_brd_info *brd_info;
 	DECLARE_BITMAP(hw_capa, hw_capa_last);
 	DECLARE_BITMAP(fw_capabilities, WMI_FW_CAPABILITY_MAX);
 	DECLARE_BITMAP(platform_capa, WIL_PLATFORM_CAPA_MAX);
-- 
1.9.1

