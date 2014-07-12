Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24177 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935AbaGLD5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 23:57:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/7] mwifiex: define TDLS idle timeout macro with units
Date: Fri, 11 Jul 2014 20:57:13 -0700
Message-ID: <1405137435-14045-2-git-send-email-bzhao@marvell.com> (sfid-20140712_055745_069193_032B8085)
In-Reply-To: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
References: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The unit of this timeout is in seconds.

Reported-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h      | 2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5561573..49da2d5 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -713,7 +713,7 @@ struct mwifiex_ie_types_vendor_param_set {
 	u8 ie[MWIFIEX_MAX_VSIE_LEN];
 };
 
-#define MWIFIEX_TDLS_IDLE_TIMEOUT	60
+#define MWIFIEX_TDLS_IDLE_TIMEOUT_IN_SEC	60
 
 struct mwifiex_ie_types_tdls_idle_timeout {
 	struct mwifiex_ie_types_header header;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 0f077aa..733de92 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1647,7 +1647,7 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 		timeout = (void *)(pos + config_len);
 		timeout->header.type = cpu_to_le16(TLV_TYPE_TDLS_IDLE_TIMEOUT);
 		timeout->header.len = cpu_to_le16(sizeof(timeout->value));
-		timeout->value = cpu_to_le16(MWIFIEX_TDLS_IDLE_TIMEOUT);
+		timeout->value = cpu_to_le16(MWIFIEX_TDLS_IDLE_TIMEOUT_IN_SEC);
 		config_len += sizeof(struct mwifiex_ie_types_tdls_idle_timeout);
 
 		break;
-- 
1.8.2.3

