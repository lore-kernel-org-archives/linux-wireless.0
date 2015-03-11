Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40184 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbCKPLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:11:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: fix watchdog timer regression
Date: Wed, 11 Mar 2015 16:11:33 +0100
Message-ID: <1426086693-13876-8-git-send-email-arend@broadcom.com> (sfid-20150311_161149_610461_D40D9E30)
In-Reply-To: <1426086693-13876-1-git-send-email-arend@broadcom.com>
References: <1426086693-13876-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog timer is used to put the device in a low-power mode when
it is idle for some time. This timer is stopped during that mode and
should be restarted upon activity. This has been broken by commit
d4150fced0365 ("brcmfmac: Simplify watchdog sleep."). This patch
restores the behaviour as it was before that commit.

Reported-by: Pontus Fuchs <pontusf@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 5202e76..17a7212 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -972,7 +972,6 @@ static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 			brcmf_sdio_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
 		brcmf_sdio_htclk(bus, true, pendok);
-		brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 		break;
 
 	case CLK_SDONLY:
@@ -984,7 +983,6 @@ static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 		else
 			brcmf_err("request for %d -> %d\n",
 				  bus->clkstate, target);
-		brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 		break;
 
 	case CLK_NONE:
@@ -993,7 +991,6 @@ static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 			brcmf_sdio_htclk(bus, false, false);
 		/* Now remove the SD clock */
 		brcmf_sdio_sdclk(bus, false);
-		brcmf_sdio_wd_timer(bus, 0);
 		break;
 	}
 #ifdef DEBUG
@@ -1048,6 +1045,7 @@ end:
 			brcmf_sdio_clkctl(bus, CLK_NONE, pendok);
 	} else {
 		brcmf_sdio_clkctl(bus, CLK_AVAIL, pendok);
+		brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
 	}
 	bus->sleeping = sleep;
 	brcmf_dbg(SDIO, "new state %s\n",
@@ -4242,6 +4240,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		if (bus->ci) {
 			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
 				sdio_claim_host(bus->sdiodev->func[1]);
+				brcmf_sdio_wd_timer(bus, 0);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
 				 * 'passive'. This is done by resetting all
-- 
1.9.1

