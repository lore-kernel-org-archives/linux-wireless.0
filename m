Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:41677 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaBYTap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:45 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/14] brcmfmac: Minimize SDIO dpc scheduling.
Date: Tue, 25 Feb 2014 20:30:31 +0100
Message-ID: <1393356639-19169-8-git-send-email-arend@broadcom.com> (sfid-20140225_203123_089599_E691168B)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

SDIO dpc scheduling is done (repeated) when counter is set. This
counter gets decreased when dpc is finished. It is more efficient
to set counter to 0 before the dpc is actullay run. This will
minimize the frequency with which dpc is executed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ce99732..cc0f1ad 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3758,8 +3758,8 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 					      datawork);
 
 	while (atomic_read(&bus->dpc_tskcnt)) {
+		atomic_set(&bus->dpc_tskcnt, 0);
 		brcmf_sdio_dpc(bus);
-		atomic_dec(&bus->dpc_tskcnt);
 	}
 }
 
-- 
1.7.10.4

