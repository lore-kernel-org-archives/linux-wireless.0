Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4699 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1HWMOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/8] staging: brcm80211: only enable brcmsmac if bcma is
 not set
Date: Tue, 23 Aug 2011 14:13:53 +0200
Message-ID: <1314101640-4229-2-git-send-email-arend@broadcom.com> (sfid-20110823_141427_602202_9A066D66)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

brcmsmac doesn't yet use bcma, but both drivers attempt to claim the same
device.  For now, turn of brcmsmac if bcma is enabled.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index 621570a..ef77b44 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -7,6 +7,7 @@ config BRCMSMAC
 	default n
 	depends on PCI
 	depends on WLAN && MAC80211
+	depends on BCMA=n
 	select BRCMUTIL
 	select FW_LOADER
 	select CRC_CCITT
-- 
1.7.4.1


