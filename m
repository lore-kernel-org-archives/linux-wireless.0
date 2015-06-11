Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:35675 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbbFKLGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:06:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id C6D928E4AA6
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 13:06:37 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: matthias.may@neratec.com
Subject: [PATCHv2 2/4] ath: send minimum bandwidth to handle.
Date: Thu, 11 Jun 2015 13:06:29 +0200
Message-Id: <1434020791-16291-3-git-send-email-matthias.may@neratec.com> (sfid-20150611_130648_879422_E9AD2A86)
In-Reply-To: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add 20MHz minimum bandwidth to the calls of freq_reg_info()

Signed-off-by: Matthias May <matthias.may@neratec.com>
---
 drivers/net/wireless/ath/regd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 06ea6cc..57b2e44 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -264,7 +264,8 @@ static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
 {
 	const struct ieee80211_reg_rule *reg_rule;
 
-	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq),
+				 MHZ_TO_KHZ(20));
 	if (IS_ERR(reg_rule))
 		return;
 
-- 
2.1.4

