Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933381AbeE2MAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:25 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 1/9] qtnfmac: remove unused function declarations
Date: Tue, 29 May 2018 14:59:57 +0300
Message-Id: <20180529120005.21498-2-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140033_710725_4DCDE874)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Functions qtnf_cmd_resp_parse and qtnf_cmd_resp_check have
been removed. Remove their declarations as well.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 69a7d56f7e58..cf9274add26d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -58,11 +58,6 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 			     struct station_parameters *params);
 int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 			  struct station_del_parameters *params);
-
-int qtnf_cmd_resp_parse(struct qtnf_bus *bus, struct sk_buff *resp_skb);
-int qtnf_cmd_resp_check(const struct qtnf_vif *vif,
-			const struct sk_buff *resp_skb, u16 cmd_id,
-			u16 *result, const u8 **payload, size_t *payload_size);
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac);
 int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 			  struct cfg80211_connect_params *sme);
-- 
2.11.0
