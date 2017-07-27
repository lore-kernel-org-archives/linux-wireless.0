Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0054.outbound.protection.outlook.com ([104.47.41.54]:14641
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751593AbdG0XH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:29 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 03/12] qtnfmac: add missing bus lock
Date: Fri, 28 Jul 2017 02:06:45 +0300
Message-Id: <20170727230654.30850-4-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010735_592047_2E99B907)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing bus lock into get_mac_chan_info command.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 8be96f02888f..f5a294f3c2a4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1442,6 +1442,9 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 
 	cmd = (struct qlink_cmd_chans_info_get *)cmd_skb->data;
 	cmd->band = qband;
+
+	qtnf_bus_lock(mac->bus);
+
 	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
 				       sizeof(*resp), &info_len);
 
@@ -1465,6 +1468,7 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 	ret = qtnf_cmd_resp_fill_channels_info(band, resp, info_len);
 
 out:
+	qtnf_bus_unlock(mac->bus);
 	consume_skb(resp_skb);
 
 	return ret;
-- 
2.11.0
