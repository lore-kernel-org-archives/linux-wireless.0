Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59079 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3J2Sej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 14:34:39 -0400
Received: by mail-wi0-f171.google.com with SMTP id f4so1718854wiw.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 11:34:38 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/3] ath: fix usage of freq_reg_info()
Date: Tue, 29 Oct 2013 19:34:24 +0100
Message-Id: <1383071666-26817-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_193441_981475_B2610D55)
In-Reply-To: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

freq_reg_info() expects KHz and not MHz, fix this. In
this case we'll now be getting the no-ir flags cleared
on channels for any channel when the country IE trusts
that channel.

@@
struct ieee80211_channel *ch;
struct wiphy *wiphy;
const struct ieee80211_reg_rule *rule;
@@

-rule = freq_reg_info(wiphy, ch->center_freq);
+rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));

Generated-by: Coccinelle SmPL
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Reported-by: Mihir Shete <smihir@qti.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index a258283..bc9ba78 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -182,7 +182,7 @@ static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
 {
 	const struct ieee80211_reg_rule *reg_rule;
 
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
 	if (IS_ERR(reg_rule))
 		return;
 
-- 
1.8.4.rc3

