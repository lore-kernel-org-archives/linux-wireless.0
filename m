Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59323 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaE0K4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/16] brcmfmac: restore mpc before passing scan status to cfg80211
Date: Tue, 27 May 2014 12:56:14 +0200
Message-ID: <1401188188-16492-3-git-send-email-arend@broadcom.com> (sfid-20140527_125638_481047_58B0D82B)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before informing cfg80211 about the scan status the device should
be put back in mpc state. If done after user-space may initiate
another (scheduled) scan and fail because scan is still busy as
shown in logging below:

[ 3301.367376] brcmfmac: brcmf_fweh_event_worker event ESCAN_RESULT (69)
[ 3301.377305] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0
[ 3301.384993] brcmutil: event payload, len=12
[ 3301.389208] 00000000: 0c 00 00 00 6d 00 00 00 34 12 00 00
[ 3301.389214] brcmfmac: brcmf_sdio_kso_control Enter: on=0
[ 3301.402196] brcmfmac: brcmf_inform_bss scanned AP count (0)
[ 3301.407808] brcmfmac: brcmf_notify_escan_complete Enter
[ 3301.413064] brcmfmac: brcmf_notify_escan_complete ESCAN Completed scan: Done
[ 3301.420137] brcmfmac: brcmf_sdio_bus_txctl Enter
[ 3301.420368] brcmfmac: brcmf_cfg80211_sched_scan_start Enter
[ 3301.420370] brcmfmac: brcmf_cfg80211_sched_scan_start:
				Scanning already: status (1)
[ 3301.440190] brcmfmac: brcmf_sdio_kso_control Enter: on=1
[ 3301.448695] brcmfmac: brcmf_sdio_tx_ctrlframe Enter
[ 3301.453662] brcmfmac: brcmf_sdio_bus_rxctl Enter
[ 3301.458326] brcmfmac: brcmf_sdio_isr Enter
[ 3301.462523] brcmfmac: brcmf_sdio_dpc Enter
[ 3301.466632] brcmfmac: brcmf_sdio_readframes Enter
[ 3301.471431] brcmfmac: brcmf_sdio_read_control Enter
[ 3301.476340] brcmfmac: brcmf_set_mpc MPC : 1

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 10aacc9..df42a10 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -640,6 +640,9 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		if (err)
 			brcmf_err("Scan abort  failed\n");
 	}
+
+	brcmf_set_mpc(ifp, 1);
+
 	/*
 	 * e-scan can be initiated by scheduled scan
 	 * which takes precedence.
@@ -649,12 +652,10 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		cfg->sched_escan = false;
 		if (!aborted)
 			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
-		brcmf_set_mpc(ifp, 1);
 	} else if (scan_request) {
 		brcmf_dbg(SCAN, "ESCAN Completed scan: %s\n",
 			  aborted ? "Aborted" : "Done");
 		cfg80211_scan_done(scan_request, aborted);
-		brcmf_set_mpc(ifp, 1);
 	}
 	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
 		brcmf_dbg(SCAN, "Scan complete, probably P2P scan\n");
-- 
1.7.9.5

