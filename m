Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:41020 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751700AbbGIIOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 04:14:00 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Daniel Kim <dekim@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>
Subject: [PATCH 2/3] brcmfmac: dhd_sdio.c: use existing atomic_or primitive
Date: Thu, 9 Jul 2015 13:43:18 +0530
Message-ID: <1436429599-10762-3-git-send-email-vgupta@synopsys.com> (sfid-20150709_101512_386844_1FBC5A11)
In-Reply-To: <1436429599-10762-1-git-send-email-vgupta@synopsys.com>
References: <1436429599-10762-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's already a generic implementation so use that instead.
---
I'm not sure if the driver usage of atomic_or?() is correct in terms of
storage size of @val for 64 bit arches.

Assuming LP64 programming model for linux on say x86_64: atomic_or()
callers in this driver use long (sana 64 bit) storage and pass it to
atomic_orr/atomic_or which downcasts it to 32 bits. Is that OK ?
---
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Cc: Daniel Kim <dekim@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index d36f5f3d931b..f990e3d0e696 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2564,15 +2564,6 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 	}
 }
 
-static void atomic_orr(int val, atomic_t *v)
-{
-	int old_val;
-
-	old_val = atomic_read(v);
-	while (atomic_cmpxchg(v, old_val, val | old_val) != old_val)
-		old_val = atomic_read(v);
-}
-
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
 	struct brcmf_core *buscore;
@@ -2595,7 +2586,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 	if (val) {
 		brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
 		bus->sdcnt.f1regdata++;
-		atomic_orr(val, &bus->intstatus);
+		atomic_or(val, &bus->intstatus);
 	}
 
 	return ret;
@@ -2712,7 +2703,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	/* Keep still-pending events for next scheduling */
 	if (intstatus)
-		atomic_orr(intstatus, &bus->intstatus);
+		atomic_or(intstatus, &bus->intstatus);
 
 	brcmf_sdio_clrintr(bus);
 
-- 
1.9.1

