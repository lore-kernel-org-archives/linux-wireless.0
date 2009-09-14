Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbZINJKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 05:10:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: make ath9k_common_ops const
Date: Mon, 14 Sep 2009 05:10:35 -0400
Message-Id: <1252919435-24305-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As noted by Jiri.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 588ee89..3223b30 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1583,7 +1583,7 @@ static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 	return val;
 }
 
-static struct ath_ops ath9k_common_ops = {
+static const struct ath_ops ath9k_common_ops = {
 	.read = ath9k_ioread32,
 	.write = ath9k_iowrite32,
 };
-- 
1.6.3.3

