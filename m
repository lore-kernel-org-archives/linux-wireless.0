Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933561AbeE2MAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:36 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 6/9] qtnfmac: fix firmware command error path
Date: Tue, 29 May 2018 15:00:02 +0300
Message-Id: <20180529120005.21498-7-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140108_926873_A3C1EA39)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

Free command skb if bus state is not QTNF_FW_STATE_ACTIVE.

Signed-off-by: Dmitry Lebed <dlebed@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 1 +
 drivers/net/wireless/quantenna/qtnfmac/trans.c    | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 9dc4560be5d8..e2fc57be1cdd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -102,6 +102,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 		pr_warn("VIF%u.%u: drop cmd 0x%.4X in fw state %d\n",
 			mac_id, vif_id, le16_to_cpu(cmd->cmd_id),
 			bus->fw_state);
+		dev_kfree_skb(cmd_skb);
 		return -ENODEV;
 	}
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.c b/drivers/net/wireless/quantenna/qtnfmac/trans.c
index ccddfebc508a..345f34ec9750 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/trans.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.c
@@ -35,8 +35,10 @@ int qtnf_trans_send_cmd_with_resp(struct qtnf_bus *bus, struct sk_buff *cmd_skb,
 	bool resp_not_handled = true;
 	struct sk_buff *resp_skb = NULL;
 
-	if (unlikely(!response_skb))
+	if (unlikely(!response_skb)) {
+		dev_kfree_skb(cmd_skb);
 		return -EFAULT;
+	}
 
 	spin_lock(&ctl_node->resp_lock);
 	ctl_node->seq_num++;
-- 
2.11.0
