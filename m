Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55610 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2AaPvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 10:51:21 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so83344wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 07:51:20 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] wl12xx: add new coex params
Date: Tue, 31 Jan 2012 17:54:43 +0200
Message-Id: <1328025283-22888-4-git-send-email-eliad@wizery.com> (sfid-20120131_165126_225564_19885254)
In-Reply-To: <1328025283-22888-1-git-send-email-eliad@wizery.com>
References: <1328025283-22888-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

new params were added to the coex params.
Add them with default value of 0.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on the "wl12xx: update fw api" patchset

 drivers/net/wireless/wl12xx/conf.h |    4 ++++
 drivers/net/wireless/wl12xx/main.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a179510..823535c 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -317,6 +317,10 @@ enum {
 	CONF_AP_BT_ACL_VAL_BT_SERVE_TIME,
 	CONF_AP_BT_ACL_VAL_WL_SERVE_TIME,
 
+	/* CTS Diluting params */
+	CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH,
+	CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER,
+
 	CONF_SG_TEMP_PARAM_1,
 	CONF_SG_TEMP_PARAM_2,
 	CONF_SG_TEMP_PARAM_3,
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d67acc3..2dea2ee 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -116,6 +116,9 @@ static struct conf_drv_settings default_conf = {
 			[CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
 			[CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
 			[CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
+			/* CTS Diluting params */
+			[CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
+			[CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
 		},
 		.state = CONF_SG_PROTECTIVE,
 	},
-- 
1.7.6.401.g6a319

