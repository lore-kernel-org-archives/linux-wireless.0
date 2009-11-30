Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57157 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZK3RNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:13:14 -0500
Date: Mon, 30 Nov 2009 18:13:20 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 08/12] mwl8k: increase firmware loading timeouts
Message-ID: <20091130171320.GK20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The time between loading the helper image and starting to upload the
main firmware image should be at least 5 ms or so.  We were doing an
msleep(1) before, and 1 ms appears to not be enough in almost all
cases, but building with HZ=100 has always masked this so far.  Bumping
the msleep argument to 5 fixes firmware loading e.g. when HZ=1000.

Some firmware images need more than 200ms to initialize.  Bump the
ready code timeout to 500ms to accommodate for this.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8f7546f..b3eba35 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -571,7 +571,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 			       "helper image\n", pci_name(priv->pdev));
 			return rc;
 		}
-		msleep(1);
+		msleep(5);
 
 		rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
 	} else {
@@ -588,9 +588,8 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 		iowrite32(MWL8K_MODE_AP, priv->regs + MWL8K_HIU_GEN_PTR);
 	else
 		iowrite32(MWL8K_MODE_STA, priv->regs + MWL8K_HIU_GEN_PTR);
-	msleep(1);
 
-	loops = 200000;
+	loops = 500000;
 	do {
 		u32 ready_code;
 
-- 
1.5.6.4
