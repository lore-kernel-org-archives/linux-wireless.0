Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:63700 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950AbbAYTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:50 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/14] brcmfmac: fix nvram processing
Date: Sun, 25 Jan 2015 20:31:43 +0100
Message-ID: <1422214303-7816-15-git-send-email-arend@broadcom.com> (sfid-20150125_203214_288883_C76C1817)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nvram file can hold a key=value combination in which the value
may have spaces, ie. 'RAW1=80 02 fe ff'. The parsing functionality
did not deal with this so it gives an error message:

[621746.311635] brcmfmac: brcmf_nvram_handle_key
	warning: ln=90:col=11: '=' expected, skip invalid key entry

because RAW1=80 is being considerd as key=value pair and it expects
'=' sign after '02' for next key=value pair. This entry can be
completely ignored as firmware does not need it.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 1ff787d..9cb9915 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -103,7 +103,11 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
 
 	c = nvp->fwnv->data[nvp->pos];
 	if (c == '=') {
-		st = VALUE;
+		/* ignore RAW1 by treating as comment */
+		if (strncmp(&nvp->fwnv->data[nvp->entry], "RAW1", 4) == 0)
+			st = COMMENT;
+		else
+			st = VALUE;
 	} else if (!is_nvram_char(c)) {
 		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
 			  nvp->line, nvp->column);
-- 
1.9.1

