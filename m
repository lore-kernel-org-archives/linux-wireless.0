Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61183 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaFYUPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:30 -0400
Received: by mail-wg0-f51.google.com with SMTP id x12so2648209wgg.10
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/17] staging: vt6656: mac80211 conversion: vRunCommand change beacon
Date: Wed, 25 Jun 2014 21:14:30 +0100
Message-Id: <1403727278-6666-10-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221554_036622_4779087C)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove bMgrPrepareBeaconToSend

Check that vif is not null

Call vnt_beacon_make and turn on TCR_AUTOBCNTX.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 85adc1c..3095689 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -843,7 +843,13 @@ void vRunCommand(struct work_struct *work)
 		break;
 
 	case WLAN_CMD_BECON_SEND_START:
-		bMgrPrepareBeaconToSend(pDevice, pMgmt);
+		if (!pDevice->vif)
+			break;
+
+		vnt_beacon_make(pDevice, pDevice->vif);
+
+		vnt_mac_reg_bits_on(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+
 		break;
 
 	case WLAN_CMD_SETPOWER_START:
-- 
1.9.1

