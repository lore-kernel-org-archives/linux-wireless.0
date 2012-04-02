Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41567 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2DBUlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 16:41:42 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Don't delete key from hw if using sw-crypt.
Date: Mon,  2 Apr 2012 13:41:32 -0700
Message-Id: <1333399292-23231-1-git-send-email-greearb@candelatech.com> (sfid-20120402_224145_891681_DA1C3844)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This spams logs if we are using large numbers of stations,
for instance:

ath: wiphy0: keyreset: keycache entry 228 out of range
ath: wiphy0: keyreset: keycache entry 228 out of range

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 917032a... 65e7281... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 917032a..65e7281 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1771,6 +1771,9 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 	if (!an->ps_key)
 	    return;
 
+	if (ath9k_modparam_nohwcrypt)
+		return;
+
 	ath_key_delete(common, &ps_key);
 }
 
-- 
1.7.3.4

