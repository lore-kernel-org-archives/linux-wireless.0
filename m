Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33800 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbDMHq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 03:46:28 -0400
Received: by lbcga7 with SMTP id ga7so52297449lbc.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 00:46:26 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 2/2] ath10k: don't disable PS when not connected
Date: Mon, 13 Apr 2015 09:45:41 +0200
Message-Id: <1428911141-6534-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150413_094631_757387_B41D347F)
In-Reply-To: <1428911141-6534-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1428911141-6534-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't disable PS while we are not connected.
In other case we will get higher power consumption.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 52c5b1f..b896dd4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1730,7 +1730,13 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		enable_ps = false;
 	}
 
-	if (enable_ps) {
+	if (!arvif->is_started) {
+		/* enable power save mode while not connected,
+		 * in other case after iface up we will get
+		 * higher power consumption - firmware design
+		 */
+		psmode = WMI_STA_PS_MODE_ENABLED;
+	} else if (enable_ps) {
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
-- 
1.9.1

