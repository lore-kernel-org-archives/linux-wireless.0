Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44271 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2ICUPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 16:15:40 -0400
Date: Mon, 3 Sep 2012 22:15:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Fix uninitialized variable in ath6kl ath6kl_sdio_enable_scatter
Message-ID: <20120903201536.GA16230@one.firstfloor.org> (sfid-20120903_221603_832201_67E97C53)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.8 warns

/backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/ath/ath6kl/sdio.c:
In function 'ath6kl_sdio_enable_scatter':
/backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/ath/ath6kl/sdio.c:748:16:
warning: 'ret' may be used uninitialized in this function
[-Wmaybe-uninitialized]
  if (virt_scat || ret) {
                ^

The variable can indeed be uninitialized when the previous if branch is
skipped. I just set it to zero for now. I'm not fully sure the fix is
correct, maybe the || should be an && ? 

Signed-off-by: Andi Kleen <ak@linux.intel.com>


diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 05b9540..f495899 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -709,7 +709,7 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct htc_target *target = ar->htc_target;
-	int ret;
+	int ret = 0;
 	bool virt_scat = false;
 
 	if (ar_sdio->scatter_enabled)


-- 
ak@linux.intel.com -- Speaking for myself only.
