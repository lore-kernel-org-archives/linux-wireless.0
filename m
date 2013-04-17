Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4193 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966589Ab3DQT0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/10] brcmfmac: check memory allocation in
 brcmf_add_if()
Date: Wed, 17 Apr 2013 21:25:50 +0200
Message-ID: <1366226758-20641-3-git-send-email-arend@broadcom.com> (sfid-20130417_212625_041361_C37F6BA6)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For P2P_DEVICE interface the struct brcmf_if instance is
allocated using kzalloc() which can fail. Add pointer
check and return -ENOMEM if it failed. Fixes the following
smatch error:

"drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:770
brcmf_add_if()
  error: potential null dereference 'ifp'. (kzalloc returns null)"

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 763a84e..269fde2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -754,6 +754,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		/* this is P2P_DEVICE interface */
 		brcmf_dbg(INFO, "allocate non-netdev interface\n");
 		ifp = kzalloc(sizeof(*ifp), GFP_KERNEL);
+		if (!ifp)
+			return ERR_PTR(-ENOMEM);
 	} else {
 		brcmf_dbg(INFO, "allocate netdev interface\n");
 		/* Allocate netdev, including space for private structure */
-- 
1.7.10.4


