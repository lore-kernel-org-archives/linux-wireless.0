Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:40806 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbbAGXSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 18:18:54 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v1] libertas: avoid potential null-pointer dereference
Date: Thu,  8 Jan 2015 01:18:41 +0200
Message-Id: <1420672721-8400-1-git-send-email-andy.shevchenko@gmail.com> (sfid-20150108_001857_396591_14E4D783)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to check pointer before dereferencing it.

Reported-by: Andrey Karpov <karpov@viva64.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/net/wireless/libertas/cfg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 34f09ef..1d335e6 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1109,7 +1109,7 @@ static int lbs_associate(struct lbs_private *priv,
 	size_t len, resp_ie_len;
 	int status;
 	int ret;
-	u8 *pos = &(cmd->iebuf[0]);
+	u8 *pos;
 	u8 *tmp;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
@@ -1138,6 +1138,8 @@ static int lbs_associate(struct lbs_private *priv,
 	cmd->listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
 	cmd->capability = cpu_to_le16(bss->capability);
 
+	pos = cmd->iebuf;
+
 	/* add SSID TLV */
 	rcu_read_lock();
 	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
-- 
1.8.3.101.g727a46b

