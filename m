Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:49261 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1I3XI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 19:08:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linville@tuxdriver.com,
	kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH net-next] drivers/net: Add module.h to wireless/ath/ath6kl/sdio.c
Date: Fri, 30 Sep 2011 19:07:59 -0400
Message-Id: <1317424079-31793-1-git-send-email-paul.gortmaker@windriver.com> (sfid-20111001_010834_065680_E7CC2B50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file uses various MODULE_* macros, and so needs the full
module.h header called out explicitly.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

---

[Dave: I can't carry this in the module.h tree with all the other one
line patches, as it only exists in trees based off wireless/net-next.
It fixes a compile failure that shows up in linux-next.  Thanks.]

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 3417160..ca4a93e 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/module.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/host.h>
-- 
1.7.6

