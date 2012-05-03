Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52099 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2ECFNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:13:38 -0400
Received: from aeonflux.amr.corp.intel.com (unknown [81.253.16.139])
	by mail.holtmann.org (Postfix) with ESMTPSA id 64D788B3B6
	for <linux-wireless@vger.kernel.org>; Thu,  3 May 2012 07:13:37 +0200 (CEST)
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] NFC: Select CRC_CCITT for SHDLC link layer of HCI based drivers
Date: Thu,  3 May 2012 07:12:48 +0200
Message-Id: <1336021968-19478-1-git-send-email-marcel@holtmann.org> (sfid-20120503_071341_272312_03723F1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SHDLC link layer of HCI based drivers uses CRC-CCITT and thus
needs to select that kernel option.

Otherwise it ends up with this linking error:

net/built-in.o: In function `nfc_shdlc_add_len_crc':
net/nfc/hci/shdlc.c:113: undefined reference to `crc_ccitt'

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/nfc/hci/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/nfc/hci/Kconfig b/net/nfc/hci/Kconfig
index 17213a6..fd67f51 100644
--- a/net/nfc/hci/Kconfig
+++ b/net/nfc/hci/Kconfig
@@ -9,6 +9,7 @@ config NFC_HCI
 
 config NFC_SHDLC
 	depends on NFC_HCI
+	select CRC_CCITT
 	bool "SHDLC link layer for HCI based NFC drivers"
 	default n
 	---help---
-- 
1.7.7.6

