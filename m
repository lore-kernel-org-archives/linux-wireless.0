Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1795 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1HHN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 57/82] staging: brcm80211: use PCI_DEVICE() macro in
 device table
Date: Mon, 8 Aug 2011 15:58:41 +0200
Message-ID: <1312811946-16713-58-git-send-email-arend@broadcom.com> (sfid-20110808_160108_991307_B0239D09)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro PCI_DEVICE() fills in the entry in abbreviated manner. Using
this removes the "lines over 80 characters" checkpatch warning on these
entries.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 35d9ee8..1437e51 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -95,11 +95,10 @@ MODULE_LICENSE("Dual BSD/GPL");
 
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


