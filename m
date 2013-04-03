Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2978 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450Ab3DCKlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 20/25] brcmfmac: initialize struct brcmf_fws_info fields
 before iovar
Date: Wed, 3 Apr 2013 12:40:45 +0200
Message-ID: <1364985650-11719-21-git-send-email-arend@broadcom.com> (sfid-20130403_124305_635751_F4A36850)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If iovar to the firmware fails the firmware-signalling module
does a cleanup for which it needs pointer to struct brcmf_pub, which
it gets from struct brcmf_fws_info::drvr. Assign this field before
doing the tlv iovar.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 314aedc..6d036b7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -919,6 +919,10 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
+	/* set linkage back */
+	drvr->fws->drvr = drvr;
+	drvr->fws->fcmode = fcmode;
+
 	/* enable proptxtstatus signaling by default */
 	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
 	if (rc < 0) {
@@ -937,10 +941,6 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	/* create debugfs file for statistics */
 	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
 
-	/* set linkage back */
-	drvr->fws->drvr = drvr;
-	drvr->fws->fcmode = fcmode;
-
 	/* TODO: remove upon feature delivery */
 	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
 		  drvr->fw_signals ? "enabled" : "disabled", tlv);
-- 
1.7.10.4


