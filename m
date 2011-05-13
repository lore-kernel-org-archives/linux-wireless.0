Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4887 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1EMKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/32] staging: brcm80211: fix makefiles for building
 drivers in kernel
Date: Fri, 13 May 2011 11:59:30 +0200
Message-ID: <1305280792-9475-10-git-send-email-arend@broadcom.com> (sfid-20110513_120019_485010_20D2FCE6)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The makefiles used obj-m which forcibly builds the drivers as
modules ignoring the Kconfig setting. This has been fixed in this
patch.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile |    2 +-
 drivers/staging/brcm80211/brcmsmac/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 8c9c0dc..c5ec562 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -52,5 +52,5 @@ DHDOFILES = \
 	bcmsdh_sdmmc.o \
 	bcmsdh_sdmmc_linux.o
 
-obj-m += brcmfmac.o
+obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += $(DHDOFILES)
diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 84ae245..8d75fe1 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -55,5 +55,5 @@ BRCMSMAC_OFILES := \
 
 MODULEPFX := brcmsmac
 
-obj-m	+= $(MODULEPFX).o
+obj-$(CONFIG_BRCMSMAC)	+= $(MODULEPFX).o
 $(MODULEPFX)-objs	= $(BRCMSMAC_OFILES)
-- 
1.7.4.1


