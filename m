Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35222 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932113AbdA3PKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 10:10:13 -0500
Received: by mail-lf0-f68.google.com with SMTP id v186so31623252lfa.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 07:10:05 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] brcmfmac: be more verbose when PSM's watchdog fires
Date: Mon, 30 Jan 2017 16:09:52 +0100
Message-Id: <20170130150952.7133-2-zajec5@gmail.com> (sfid-20170130_161021_380080_2699C8A7)
In-Reply-To: <20170130150952.7133-1-zajec5@gmail.com>
References: <20170130150952.7133-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It's important to inform user so he knows things went wrong. He may also
want to get memory dump for further debugging purposes.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index 6f8a4b074c31..f4644cf371c7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -58,10 +58,18 @@ static int brcmf_debug_psm_watchdog_notify(struct brcmf_if *ifp,
 					   const struct brcmf_event_msg *evtmsg,
 					   void *data)
 {
+	int err;
+
 	brcmf_dbg(TRACE, "enter: bsscfgidx=%d\n", ifp->bsscfgidx);
 
-	return brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
-					  evtmsg->datalen);
+	brcmf_err("PSM's watchdog has fired!\n");
+
+	err = brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
+					 evtmsg->datalen);
+	if (err)
+		brcmf_err("Failed to get memory dump, %d\n", err);
+
+	return err;
 }
 
 void brcmf_debugfs_init(void)
-- 
2.11.0
