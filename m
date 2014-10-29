Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35851 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbaJ2RqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:13 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so2466529wgg.33
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:46:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 34/34] staging: vt6655: reset tsf on dissociation
Date: Wed, 29 Oct 2014 17:44:09 +0000
Message-Id: <1414604649-9105-35-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184623_143021_5653E1A1)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensuring that tsf counter does not run while idle.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 968ea9a..07d2101 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2980,6 +2980,11 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 			CARDvSetFirstNextTBTT(priv->PortOffset,
 					      conf->beacon_int);
+		} else {
+			VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL,
+				     TFTCTL_TSFCNTRST);
+			VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL,
+				     TFTCTL_TSFCNTREN);
 		}
 	}
 }
-- 
2.1.0

