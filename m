Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:38010 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbeH1FoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 01:44:19 -0400
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: wireless: ath: Convert to using %pOFn instead of device_node.name
Date: Mon, 27 Aug 2018 20:52:37 -0500
Message-Id: <20180828015252.28511-36-robh@kernel.org> (sfid-20180828_035704_856247_380ADF55)
In-Reply-To: <20180828015252.28511-1-robh@kernel.org>
References: <20180828015252.28511-1-robh@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to remove the node name pointer from struct device_node,
convert printf users to use the %pOFn format specifier.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 58fb227a849f..54132af70094 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -710,8 +710,8 @@ static bool check_device_tree(struct ath6kl *ar)
 	for_each_compatible_node(node, NULL, "atheros,ath6kl") {
 		board_id = of_get_property(node, board_id_prop, NULL);
 		if (board_id == NULL) {
-			ath6kl_warn("No \"%s\" property on %s node.\n",
-				    board_id_prop, node->name);
+			ath6kl_warn("No \"%s\" property on %pOFn node.\n",
+				    board_id_prop, node);
 			continue;
 		}
 		snprintf(board_filename, sizeof(board_filename),
-- 
2.17.1
