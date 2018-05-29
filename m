Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933532AbeE2MA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:29 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 3/9] qtnfmac: decode error codes from firmware replies
Date: Tue, 29 May 2018 14:59:59 +0300
Message-Id: <20180529120005.21498-4-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140042_933410_AEE58F05)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Introduce a function that will map an error code reported in reply
to a firmware command, into one of standard errno codes.
Use additional error codes to improve error reporting
for MAC address changes.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 26 +++++++++++++++++++++--
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  2 ++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index deca0060eb27..9dc4560be5d8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -55,6 +55,28 @@ static int qtnf_cmd_check_reply_header(const struct qlink_resp *resp,
 	return 0;
 }
 
+static int qtnf_cmd_resp_result_decode(enum qlink_cmd_result qcode)
+{
+	switch (qcode) {
+	case QLINK_CMD_RESULT_OK:
+		return 0;
+	case QLINK_CMD_RESULT_INVALID:
+		return -EINVAL;
+	case QLINK_CMD_RESULT_ENOTSUPP:
+		return -ENOTSUPP;
+	case QLINK_CMD_RESULT_ENOTFOUND:
+		return -ENOENT;
+	case QLINK_CMD_RESULT_EALREADY:
+		return -EALREADY;
+	case QLINK_CMD_RESULT_EADDRINUSE:
+		return -EADDRINUSE;
+	case QLINK_CMD_RESULT_EADDRNOTAVAIL:
+		return -EADDRNOTAVAIL;
+	default:
+		return -EFAULT;
+	}
+}
+
 static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 				    struct sk_buff *cmd_skb,
 				    struct sk_buff **response_skb,
@@ -810,10 +832,10 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
 	if (unlikely(ret))
 		goto out;
 
-	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+	ret = qtnf_cmd_resp_result_decode(res_code);
+	if (ret) {
 		pr_err("VIF%u.%u: CMD %d failed: %u\n", vif->mac->macid,
 		       vif->vifid, cmd_type, res_code);
-		ret = -EFAULT;
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 9ab27e158023..f85deda703fb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -674,6 +674,8 @@ enum qlink_cmd_result {
 	QLINK_CMD_RESULT_ENOTSUPP,
 	QLINK_CMD_RESULT_ENOTFOUND,
 	QLINK_CMD_RESULT_EALREADY,
+	QLINK_CMD_RESULT_EADDRINUSE,
+	QLINK_CMD_RESULT_EADDRNOTAVAIL,
 };
 
 /**
-- 
2.11.0
