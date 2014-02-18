Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48935 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBRBKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:35 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so7485380eek.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:33 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 1/7] rtl818x: Explicitly enable contetion window
Date: Tue, 18 Feb 2014 02:10:40 +0100
Message-Id: <1392685846-10116-2-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021038_009469_D0255771)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

Currently the contention window enable/disable HW flag is not
touched by the driver.

This patch explicitly set it to the correct value to make sure
contention window is enabled (AFAIK contention window must be
enabled in most (if not all) cases.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 7980ab1..470a1e3 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -642,6 +642,8 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	else
 		reg &= ~RTL818X_TX_CONF_HW_SEQNUM;
 
+	reg &= ~RTL818X_TX_CONF_DISCW;
+
 	/* different meaning, same value on both rtl8185 and rtl8180 */
 	reg &= ~RTL818X_TX_CONF_SAT_HWPLCP;
 
-- 
1.8.3.2

