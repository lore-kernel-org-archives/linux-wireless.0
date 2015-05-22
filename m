Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36298 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992477AbbEVVpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 17:45:40 -0400
Received: by wgbgq6 with SMTP id gq6so28857007wgb.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 14:45:38 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3] brcmfmac: allow NVRAM values to contain spaces
Date: Fri, 22 May 2015 23:45:28 +0200
Message-Id: <1432331128-24011-1-git-send-email-zajec5@gmail.com> (sfid-20150522_234543_654050_8575BA24)
In-Reply-To: <1432145701-15150-1-git-send-email-zajec5@gmail.com>
References: <1432145701-15150-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Platform NVRAMs often contain values with spaces. Even if right now most
firmware-supported entries are simple values, we shouldn't reject these
with spaces. It was semi-confirmed by Broadocm in the early patch adding
support for platform NVRAMs.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Minor change in commit message only. Provide an example of NVRAM entry
    using space (not just a '#'). It's unprefixed (shouldn't be uploaded to
    hardware anyway), but proves it's allowed in general.
V3: As commented by Arend, accept space only (not a '#').
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 45d7191..baad939 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -66,6 +66,12 @@ struct nvram_parser {
 	bool multi_dev_v2;
 };
 
+/**
+ * is_nvram_char() - check if char is a valid one for NVRAM entry
+ *
+ * It accepts all printable ASCII chars except for '#' which opens a comment.
+ * Please note that ' ' (space) while accepted is not a valid key name char.
+ */
 static bool is_nvram_char(char c)
 {
 	/* comment marker excluded */
@@ -73,7 +79,7 @@ static bool is_nvram_char(char c)
 		return false;
 
 	/* key and value may have any other readable character */
-	return (c > 0x20 && c < 0x7f);
+	return (c >= 0x20 && c < 0x7f);
 }
 
 static bool is_whitespace(char c)
@@ -120,7 +126,7 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
 			nvp->multi_dev_v1 = true;
 		if (strncmp(&nvp->fwnv->data[nvp->entry], "pcie/", 5) == 0)
 			nvp->multi_dev_v2 = true;
-	} else if (!is_nvram_char(c)) {
+	} else if (!is_nvram_char(c) || c == ' ') {
 		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
 			  nvp->line, nvp->column);
 		return COMMENT;
-- 
1.8.4.5

