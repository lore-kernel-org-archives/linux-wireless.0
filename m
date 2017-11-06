Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.91]:33631 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754016AbdKFWQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 17:16:06 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 017BA4B4234
        for <linux-wireless@vger.kernel.org>; Mon,  6 Nov 2017 15:53:23 -0600 (CST)
Date: Mon, 6 Nov 2017 15:53:21 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] rsi: rsi_91x_ps: remove redundant code in str_psstate
Message-ID: <20171106215321.GA25539@embeddedor.com> (sfid-20171106_231612_851551_12137F33)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"INVALID_STATE" is already being returned in the default case and this
code cannot be reached.

Addresses-Coverity-ID: 1398384
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/net/wireless/rsi/rsi_91x_ps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_ps.c b/drivers/net/wireless/rsi/rsi_91x_ps.c
index 523f532..01472fa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_ps.c
+++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
@@ -36,7 +36,6 @@ char *str_psstate(enum ps_state state)
 	default:
 		return "INVALID_STATE";
 	}
-	return "INVALID_STATE";
 }
 
 static inline void rsi_modify_ps_state(struct rsi_hw *adapter,
-- 
2.7.4
