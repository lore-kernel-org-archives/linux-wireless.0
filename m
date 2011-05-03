Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1623 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1ECJgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 01/61] staging: brcm80211: fixed error in non-DHD_DEBUG
 fullmac build
Date: Tue, 3 May 2011 11:35:01 +0200
Message-ID: <1304415361-7813-2-git-send-email-arend@broadcom.com> (sfid-20110503_113627_837858_4856C708)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

A build error was introduced with recent fullmac changes when building without
debug option configured:

drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function
  ‘dhdsdio_sdiod_drive_strength_init’:
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:6366:3: error: ‘chn’ undeclared

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6debc1e..e6beeb7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -6338,9 +6338,7 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 	struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask = 0;
 	u32 str_shift = 0;
-#ifdef BCMDBG
 	char chn[8];
-#endif
 
 	if (!(bus->ci->cccaps & CC_CAP_PMU))
 		return;
-- 
1.7.4.1


