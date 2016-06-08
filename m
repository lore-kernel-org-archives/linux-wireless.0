Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbcFHRHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 13:07:54 -0400
From: Maya Erez <qca_merez@qualcomm.com>
Cc: Maya Erez <qca_merez@qualcomm.com>, linux-wireless@vger.kernel.org,
	wil6210@qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/2] wil6210: fix chan check in wil_p2p_listen
Date: Wed,  8 Jun 2016 20:07:47 +0300
Message-Id: <1465405668-15881-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160608_190758_813396_3BE021FA)
In-Reply-To: <1465405668-15881-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1465405668-15881-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wil_p2p_listen chan is checked to protect against NULL
pointer access only before setting channel = chan->hw_value.
Add a global parameter check to cover all accesses to chan.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/p2p.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index 1c91538..213b825 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -114,8 +114,10 @@ int wil_p2p_listen(struct wil6210_priv *wil, unsigned int duration,
 	u8 channel = P2P_DMG_SOCIAL_CHANNEL;
 	int rc;
 
-	if (chan)
-		channel = chan->hw_value;
+	if (!chan)
+		return -EINVAL;
+
+	channel = chan->hw_value;
 
 	wil_dbg_misc(wil, "%s: duration %d\n", __func__, duration);
 
-- 
1.8.5.2

