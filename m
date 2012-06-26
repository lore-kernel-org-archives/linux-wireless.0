Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4063 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab2FZT1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: fix sparse warning introduced with
 checkdied patch
Date: Tue, 26 Jun 2012 21:26:40 +0200
Message-ID: <1340738800-14087-8-git-send-email-arend@broadcom.com> (sfid-20120626_212728_914623_12D08FE2)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "brcmfmac: introduce checkdied debugfs functionality"
also introduced a sparse warning:

..../brcmfmac/dhd_sdio.c:3147:45: sparse: cast to restricted __le32

This patch fixes this sparse warning.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5c5f1cd..5c868ba 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3145,7 +3145,7 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 			le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
 			le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
 			le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
-			le32_to_cpu(tr.pc), le32_to_cpu(sh->trap_addr),
+			le32_to_cpu(tr.pc), sh->trap_addr,
 			le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
 			le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
 			le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
-- 
1.7.9.5


