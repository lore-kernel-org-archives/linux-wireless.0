Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43354 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbbBFRhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:37:06 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/6] brcmfmac: Dont sleep when ctrl frames to transmit.
Date: Fri, 6 Feb 2015 18:36:46 +0100
Message-ID: <1423244207-9707-6-git-send-email-arend@broadcom.com> (sfid-20150206_183716_251505_D46E56B9)
In-Reply-To: <1423244207-9707-1-git-send-email-arend@broadcom.com>
References: <1423244207-9707-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The SDIO watchdog will put the device in sleep mode when there is
no activity for some time and nothing to do anymore. This check
is incomplete and should also check if there is a control frame
to transmit.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index ea403d1..f365cde 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -1027,6 +1027,7 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 			/* Don't sleep if something is pending */
 			if (atomic_read(&bus->intstatus) ||
 			    atomic_read(&bus->ipend) > 0 ||
+			    bus->ctrl_frame_stat ||
 			    (!atomic_read(&bus->fcstate) &&
 			    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
 			    data_ok(bus))) {
-- 
1.9.1

