Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:32833 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966867AbcAZQ5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:57:25 -0500
Received: by mail-lf0-f41.google.com with SMTP id s81so2865605lfd.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:57:24 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] brcmfmac: allow storing PMU core without wrapper address
Date: Tue, 26 Jan 2016 17:57:02 +0100
Message-Id: <1453827425-16455-3-git-send-email-zajec5@gmail.com> (sfid-20160126_175735_486961_461B00C0)
In-Reply-To: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
References: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Separated PMU core can be found in new devices and should be used for
accessing PMU registers (which were routed through ChipCommon so far).
This core is one of exceptions that doesn't have or need wrapper address
to be still safely accessible.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index e434e2a..55952d4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -883,7 +883,8 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
 		rev = (val & DMP_COMP_REVISION) >> DMP_COMP_REVISION_S;
 
 		/* need core with ports */
-		if (nmw + nsw == 0)
+		if (nmw + nsw == 0 &&
+		    id != BCMA_CORE_PMU)
 			continue;
 
 		/* try to obtain register address info */
-- 
1.8.4.5

