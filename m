Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33295 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbcAaLOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:14:47 -0500
Received: by mail-lf0-f42.google.com with SMTP id m1so5061114lfg.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 03:14:46 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: treat NULL character in NVRAM as separator
Date: Sun, 31 Jan 2016 12:14:34 +0100
Message-Id: <1454238874-20118-1-git-send-email-zajec5@gmail.com> (sfid-20160131_121451_126145_44D36FA3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Platform NVRAM (stored on a flash partition) has entries separated by a
NULL (\0) char. Our parsing code switches from VALUE state to IDLE
whenever it meets a NULL (\0). When that happens our IDLE handler should
simply consume it and analyze whatever is placed ahead.

This fixes harmless warnings spamming debugging output:
[  155.165624] brcmfmac: brcmf_nvram_handle_idle warning: ln=1:col=20: ignoring invalid character
[  155.180806] brcmfmac: brcmf_nvram_handle_idle warning: ln=1:col=44: ignoring invalid character
[  155.195971] brcmfmac: brcmf_nvram_handle_idle warning: ln=1:col=63: ignoring invalid character

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 1365c12..7269056 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -93,7 +93,7 @@ static enum nvram_parser_state brcmf_nvram_handle_idle(struct nvram_parser *nvp)
 	c = nvp->data[nvp->pos];
 	if (c == '\n')
 		return COMMENT;
-	if (is_whitespace(c))
+	if (is_whitespace(c) || c == '\0')
 		goto proceed;
 	if (c == '#')
 		return COMMENT;
-- 
1.8.4.5

