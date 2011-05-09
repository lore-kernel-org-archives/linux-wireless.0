Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3188 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1EIOdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/9] staging: brcm80211: move another file only used by
 brcmsmac into appropriate dir
Date: Mon, 9 May 2011 16:33:08 +0200
Message-ID: <1304951590-2411-8-git-send-email-arend@broadcom.com> (sfid-20110509_163608_309029_61C78F5C)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

nvram functions are only needed by brcmsmac.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    2 +-
 .../{util/nvram/nvram_ro.c => brcmsmac/nvram.c}    |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/staging/brcm80211/{util/nvram/nvram_ro.c => brcmsmac/nvram.c} (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 1cd3a1e..ccf1ced 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -53,7 +53,7 @@ BRCMSMAC_OFILES := \
 	nicpci.o \
 	../util/bcmutils.o \
 	../util/bcmwifi.o \
-	../util/nvram/nvram_ro.o
+	nvram.o
 
 MODULEPFX := brcmsmac
 
diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/brcmsmac/nvram.c
similarity index 100%
rename from drivers/staging/brcm80211/util/nvram/nvram_ro.c
rename to drivers/staging/brcm80211/brcmsmac/nvram.c
-- 
1.7.4.1


