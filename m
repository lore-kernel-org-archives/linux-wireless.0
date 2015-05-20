Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35234 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbbETMAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:00:10 -0400
Received: by wgfl8 with SMTP id l8so50306941wgf.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 05:00:09 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: treat \0 as end of comment when parsing NVRAM
Date: Wed, 20 May 2015 13:59:54 +0200
Message-Id: <1432123194-12584-1-git-send-email-zajec5@gmail.com> (sfid-20150520_140013_937158_B903FD0B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes brcmfmac dealing with NVRAM coming from platform e.g. from a
flash MTD partition. In such cases entries are separated by \0 instead
of \n which caused ignoring whole content after the first "comment".
While platform NVRAM doesn't usually contain comments, we switch to
COMMENT state after e.g. finding an unexpected char in key name.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 0d02e31..45d7191 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -162,17 +162,20 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
 static enum nvram_parser_state
 brcmf_nvram_handle_comment(struct nvram_parser *nvp)
 {
-	char *eol, *sol;
+	char *eoc, *sol;
 
 	sol = (char *)&nvp->fwnv->data[nvp->pos];
-	eol = strchr(sol, '\n');
-	if (eol == NULL)
-		return END;
+	eoc = strchr(sol, '\n');
+	if (!eoc) {
+		eoc = strchr(sol, '\0');
+		if (!eoc)
+			return END;
+	}
 
 	/* eat all moving to next line */
 	nvp->line++;
 	nvp->column = 1;
-	nvp->pos += (eol - sol) + 1;
+	nvp->pos += (eoc - sol) + 1;
 	return IDLE;
 }
 
-- 
1.8.4.5

