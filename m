Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36605 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbbGVEAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 00:00:13 -0400
Received: by pdjr16 with SMTP id r16so133800824pdj.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 21:00:12 -0700 (PDT)
From: Su Kang Yin <cantona@cantona.net>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Su Kang Yin <cantona@cantona.net>
Subject: [PATCH] mac80211_hwsim: unregister genetlink family properly
Date: Wed, 22 Jul 2015 11:57:38 +0800
Message-Id: <1437537458-25931-1-git-send-email-cantona@cantona.net> (sfid-20150722_060017_865098_FD720F66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During hwsim_init_netlink(), we should call genl_unregister_family()
if failed on netlink_register_notifier() since the genetlink is
already registered.

Signed-off-by: Su Kang Yin <cantona@cantona.net>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 99e873d..16d953e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3120,8 +3120,10 @@ static int hwsim_init_netlink(void)
 		goto failure;
 
 	rc = netlink_register_notifier(&hwsim_netlink_notifier);
-	if (rc)
+	if (rc) {
+		genl_unregister_family(&hwsim_genl_family);
 		goto failure;
+	}
 
 	return 0;
 
-- 
1.9.1

