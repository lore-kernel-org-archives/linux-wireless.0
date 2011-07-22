Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3336 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/29] staging: brcm80211: use PCI_DEVICE() macro in
 device table
Date: Fri, 22 Jul 2011 20:56:51 +0200
Message-ID: <1311361036-3175-5-git-send-email-arend@broadcom.com> (sfid-20110722_205737_982623_9C36EA39)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro PCI_DEVICE() fills in the entry in abbreviated manner. Using
this removes the "lines over 80 characters" checkpatch warning on these
entries.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 3987ccf..a9ad95a 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -94,11 +94,10 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 /* recognized PCI IDs */
 static DEFINE_PCI_DEVICE_TABLE(brcms_pci_id_table) = {
-	{PCI_VENDOR_ID_BROADCOM, 0x4357, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 43225 2G */
-	{PCI_VENDOR_ID_BROADCOM, 0x4353, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 43224 DUAL */
-	{PCI_VENDOR_ID_BROADCOM, 0x4727, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 4313 DUAL */
-	/* 43224 Ven */
-	{PCI_VENDOR_ID_BROADCOM, 0x0576, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) }, /* 43225 2G */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) }, /* 43224 DUAL */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) }, /* 4313 DUAL */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) }, /* 43224 Ven */
 	{0}
 };
 
-- 
1.7.4.1


