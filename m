Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:51530 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbeAQK4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 05:56:34 -0500
From: Luis de Bethencourt <luisbg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] rtl8xxxu: Fix trailing semicolon
Date: Wed, 17 Jan 2018 10:56:22 +0000
Message-Id: <20180117105622.3717-1-luisbg@kernel.org> (sfid-20180117_115748_046838_31AB1571)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards 
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 95e3993d8a33..8828baf26e7b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1172,7 +1172,7 @@ struct rtl8723bu_c2h {
 
 			u8 basic_rate:1;
 			u8 bt_has_reset:1;
-			u8 dummy4_1:1;;
+			u8 dummy4_1:1;
 			u8 ignore_wlan:1;
 			u8 auto_report:1;
 			u8 dummy4_2:3;
-- 
2.15.1
