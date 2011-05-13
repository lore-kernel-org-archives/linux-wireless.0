Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2936 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/32] staging: brcm80211: Kconfig fix for 'Broadcom I/O
 order fix'
Date: Fri, 13 May 2011 11:59:31 +0200
Message-ID: <1305280792-9475-11-git-send-email-arend@broadcom.com> (sfid-20110513_120050_644954_3D9CB92D)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Config item 'Broadcom I/O order fix' would pop up during the build process
on non-MIPs platforms.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index a11ffc7..816c1b5 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -40,7 +40,7 @@ config BRCMDBG
 config BRCM_FIX_IO_ORDER
 	bool "Broadcom I/O order fix"
 	default n
-	depends on BRCMSMAC
+	depends on MIPS && BRCMSMAC
 	---help---
-	  Select this for for platforms running on bcm4706, 4716, 4717 or 4718.
+	  Select this for platforms running on bcm4706, 4716, 4717 or 4718.
 	  It resolves an I/O issue with the PCIe core used in these chips.
-- 
1.7.4.1


