Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:49050 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751600AbdHCTIa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 15:08:30 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Lior David <qca_liord@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v4 01/10] wil6210: protect against invalid length of tx management frame
Date: Thu,  3 Aug 2017 22:08:13 +0300
Message-Id: <1501787302-22885-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170803_210834_939419_3ADFDAD1)
In-Reply-To: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Validate buffer length has the minimum needed size
when sending management frame to protect against
possible buffer overrun.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 3 +++
 drivers/net/wireless/ath/wil6210/debugfs.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 0b5383a..77af749 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -884,6 +884,9 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	wil_hex_dump_misc("mgmt tx frame ", DUMP_PREFIX_OFFSET, 16, 1, buf,
 			  len, true);
 
+	if (len < sizeof(struct ieee80211_hdr_3addr))
+		return -EINVAL;
+
 	cmd = kmalloc(sizeof(*cmd) + len, GFP_KERNEL);
 	if (!cmd) {
 		rc = -ENOMEM;
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index f82506d..a2b5d59 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -801,6 +801,9 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 	int rc;
 	void *frame;
 
+	if (!len)
+		return -EINVAL;
+
 	frame = memdup_user(buf, len);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
-- 
1.9.1
