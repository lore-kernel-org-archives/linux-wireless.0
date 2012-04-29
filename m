Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45020 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab2D2AwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:52:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 19/19] brcmsmac: handle non pci in ai_deviceremoved()
Date: Sun, 29 Apr 2012 02:50:43 +0200
Message-Id: <1335660643-26368-20-git-send-email-hauke@hauke-m.de> (sfid-20120429_025209_039843_25762795)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is based on code from the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index dd4698d..6d8b721 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -816,6 +816,9 @@ bool ai_deviceremoved(struct si_pub *sih)
 
 	sii = (struct si_info *)sih;
 
+	if (sii->icbus->hosttype != BCMA_HOSTTYPE_PCI)
+		return false;
+
 	pci_read_config_dword(sii->pcibus, PCI_VENDOR_ID, &w);
 	if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
 		return true;
-- 
1.7.9.5

