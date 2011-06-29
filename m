Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2016 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab1F2Xsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:43 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 029/119] staging: brcm80211: add missing KERN_ facility
 level to printk()
Date: Wed, 29 Jun 2011 16:46:53 -0700
Message-ID: <1309391303-22741-30-git-send-email-frankyl@broadcom.com> (sfid-20110630_014923_523096_D3695C9C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Debug printk() call was missing KERN_DEBUG facility level.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 57fff0f..c79c047 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -24564,7 +24564,8 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 	}
 
 	if (bcmerror != 0) {
-		printk("%s: Failed, cnt = %d\n", __func__, cal_retry);
+		printk(KERN_DEBUG "%s: Failed, cnt = %d\n", __func__,
+			cal_retry);
 
 		if (cal_retry < CAL_RETRY_CNT) {
 			cal_retry++;
-- 
1.7.1


