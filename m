Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59355 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaJ2RqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:12 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so2446158wgg.36
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:46:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 33/34] staging: vt6655: don't update bUpdateBBVGA when off channel
Date: Wed, 29 Oct 2014 17:44:08 +0000
Message-Id: <1414604649-9105-34-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184624_372930_17326CD8)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check flag conf IEEE80211_CONF_OFFCHANNEL so that RSSI doesn't swing wildly
on scanning.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c5eca10..968ea9a 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2040,6 +2040,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			if (pDevice->vif &&
 			    pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
 				if (pDevice->bUpdateBBVGA &&
+				    !(pDevice->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) &&
 				    pDevice->vif->bss_conf.assoc &&
 				    pDevice->uCurrRSSI) {
 					long            ldBm;
-- 
2.1.0

