Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38787 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1LTSqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:46:22 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 2/6] ath9k: make ath_mci_duty_cycle static
Date: Tue, 20 Dec 2011 10:46:07 -0800
Message-ID: <1324406771-7100-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194626_171743_4915A436)
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
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
+static u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
 
 static struct ath_mci_profile_info*
 ath_mci_find_profile(struct ath_mci_profile *mci,
-- 
1.7.4.15.g7811d

