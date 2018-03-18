Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10869 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752379AbeCRC4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 22:56:25 -0400
Date: Sun, 18 Mar 2018 10:56:08 +0800
From: kbuild test robot <lkp@intel.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC PATCH] brcmfmac: brcmf_fw_request_is_valid() can be static
Message-ID: <20180318025608.GA27678@intel11> (sfid-20180318_035733_023178_08BD7866)
References: <1521195085-439-8-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521195085-439-8-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes: 212cd4371451 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 firmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index b5f9430..95004db 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -588,7 +588,7 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 	kfree(fwctx);
 }
 
-bool brcmf_fw_request_is_valid(struct brcmf_fw_request *req)
+static bool brcmf_fw_request_is_valid(struct brcmf_fw_request *req)
 {
 	struct brcmf_fw_item *item;
 	int i;
