Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755173AbcK2X7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 18:59:09 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, briselec@gmail.com
Subject: [PATCH 1/1] rtl8xxxu: Work around issue with 8192eu and 8723bu devices not reconnecting
Date: Tue, 29 Nov 2016 18:59:02 -0500
Message-Id: <20161129235902.11882-2-Jes.Sorensen@redhat.com> (sfid-20161130_005911_589832_0272B6C6)
In-Reply-To: <20161129235902.11882-1-Jes.Sorensen@redhat.com>
References: <20161129235902.11882-1-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The H2C MEDIA_STATUS_RPT command for some reason causes 8192eu and
8723bu devices not being able to reconnect.

Reported-by: Barry Day <briselec@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index a9137ab..3a86675 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4372,6 +4372,13 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
+#ifdef RTL8XXXU_GEN2_REPORT_CONNECT
+	/*
+	 * Barry Day reports this causes issues with 8192eu and 8723bu
+	 * devices reconnecting. The reason for this is unclear, but
+	 * until it is better understood, leave the code in place but
+	 * disabled, so it is not lost.
+	 */
 	struct h2c_cmd h2c;
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
@@ -4383,6 +4390,7 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
+#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
-- 
2.7.4
