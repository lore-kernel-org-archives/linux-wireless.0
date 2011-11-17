Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49262 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1KQSPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 13:15:21 -0500
Received: by yenq3 with SMTP id q3so1416006yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 10:15:21 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] rtlwifi: Remove redundant code from PCI interrupt
Date: Thu, 17 Nov 2011 12:14:45 -0600
Message-Id: <1321553685-31154-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111117_191528_939760_039A67FA)
In-Reply-To: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interrupt routine for PCI devices has a special exit that
executes the same instructions as does the normal exit.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index eb61061..b6683a2 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -890,9 +890,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	if (rtlpriv->rtlhal.earlymode_enable)
 		tasklet_schedule(&rtlpriv->works.irq_tasklet);
 
-	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-	return IRQ_HANDLED;
-
 done:
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
 	return IRQ_HANDLED;
-- 
1.7.7

