Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753030AbdCHOBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 09:01:03 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v3 3/3] brcmfmac: Handle status == BRCMF_E_STATUS_ABORT in cfg80211_escan_handler
Date: Wed,  8 Mar 2017 14:50:17 +0100
Message-Id: <20170308135017.29867-3-hdegoede@redhat.com> (sfid-20170308_150134_915484_810EC891)
In-Reply-To: <20170308135017.29867-1-hdegoede@redhat.com>
References: <20170308135017.29867-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a scan gets aborted BRCMF_SCAN_STATUS_BUSY gets cleared in
cfg->scan_status and when we receive an abort event from the firmware
the BRCMF_SCAN_STATUS_BUSY check in the cfg80211_escan_handler will
trigger resulting in multiple errors getting logged.

Check for a status of BRCMF_E_STATUS_ABORT and in this case simply
cleanly exit the cfg80211_escan_handler. This also avoids a
BRCMF_E_STATUS_ABORT event arriving after a new scan has been started
causing the new scan to complete prematurely without any data.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Changes in v3:
-Add Arend's Acked-by
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7765ad0..4e1ca69 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3097,6 +3097,9 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 
 	status = e->status;
 
+	if (status == BRCMF_E_STATUS_ABORT)
+		goto exit;
+
 	if (!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		brcmf_err("scan not ready, bsscfgidx=%d\n", ifp->bsscfgidx);
 		return -EPERM;
-- 
2.9.3
