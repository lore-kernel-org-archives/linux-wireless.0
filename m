Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3095 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 22/82] staging: brcm80211: use native error code in
 brcmf_c_pattern_atoh()
Date: Mon, 8 Aug 2011 15:58:06 +0200
Message-ID: <1312811946-16713-23-git-send-email-arend@broadcom.com> (sfid-20110808_155943_065680_404FD491)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_c_pattern_atoh() returned meaningless -1 value.
These have been replaced by linux error code -EINVAL.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 1e757b7..4412893 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -841,12 +841,12 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
 		BRCMF_ERROR(("Mask invalid format. Needs to start with 0x\n"));
-		return -1;
+		return -EINVAL;
 	}
 	src = src + 2;		/* Skip past 0x */
 	if (strlen(src) % 2 != 0) {
 		BRCMF_ERROR(("Mask invalid format. Length must be even.\n"));
-		return -1;
+		return -EINVAL;
 	}
 	for (i = 0; *src != '\0'; i++) {
 		char num[3];
-- 
1.7.4.1


