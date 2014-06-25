Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:62771 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaFYUPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:36 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so2593147wes.22
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/17] staging: vt6656: mac80211 conversion: vRunCommand channel changes
Date: Wed, 25 Jun 2014 21:14:33 +0100
Message-Id: <1403727278-6666-13-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221601_317560_3F3B5EFF)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice->hw->conf.chandef.chan->hw_value to find current channel

Remove bChannelSwitch, uCurrChannel, byNewChannel and bStopDataPkt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 3095689..81a6683 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -855,7 +855,7 @@ void vRunCommand(struct work_struct *work)
 	case WLAN_CMD_SETPOWER_START:
 
 		vnt_rf_setpower(pDevice, pDevice->wCurrentRate,
-							pMgmt->uCurrChannel);
+				pDevice->hw->conf.chandef.chan->hw_value);
 
 		break;
 
@@ -895,10 +895,7 @@ void vRunCommand(struct work_struct *work)
 		break;
 
 	case WLAN_CMD_11H_CHSW_START:
-		vnt_set_channel(pDevice, pDevice->byNewChannel);
-		pDevice->bChannelSwitch = false;
-		pMgmt->uCurrChannel = pDevice->byNewChannel;
-		pDevice->bStopDataPkt = false;
+		vnt_set_channel(pDevice, pDevice->hw->conf.chandef.chan->hw_value);
 		break;
 
 	case WLAN_CMD_CONFIGURE_FILTER_START:
-- 
1.9.1

