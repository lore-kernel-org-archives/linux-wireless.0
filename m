Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29444 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1LUR1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 12:27:06 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH v2 2/6] ath9k: make ath_mci_duty_cycle static
Date: Wed, 21 Dec 2011 09:27:01 -0800
Message-ID: <1324488421-16364-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111221_182712_019299_E0BFBC49)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This fixes this sparse warning:

  CHECK   drivers/net/wireless/ath/ath9k/mci.c
drivers/net/wireless/ath/ath9k/mci.c:23:4: warning: symbol 'ath_mci_duty_cycle' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---

This uses const as suggeste by Joe.

 drivers/net/wireless/ath/ath9k/mci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index fee8c6f..15629f7 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -20,7 +20,7 @@
 #include "ath9k.h"
 #include "mci.h"
 
-u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
+static const u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
 
 static struct ath_mci_profile_info*
 ath_mci_find_profile(struct ath_mci_profile *mci,
-- 
1.7.4.15.g7811d

