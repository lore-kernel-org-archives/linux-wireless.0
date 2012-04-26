Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail132.messagelabs.com ([216.82.242.115]:4976 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab2DZSF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:05:58 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFC: hci/core.c: local variables should not be exposed globally
Date: Thu, 26 Apr 2012 11:05:40 -0700
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<lauro.venancio@openbossa.org>, <aloisio.almeida@openbossa.org>,
	<sameo@linux.intel.com>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-ID: <201204261105.41355.hartleys@visionengravers.com> (sfid-20120426_200625_721104_5FD6C433)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable 'hci_nfc_ops' is only referenced in this file and
should be marked static to prevent it from being exposed globally.

Quites the sparse warning:

warning: symbol 'hci_nfc_ops' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 86fd00d..0ce5ee4 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -605,7 +605,7 @@ static int hci_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
 	return 0;
 }
 
-struct nfc_ops hci_nfc_ops = {
+static struct nfc_ops hci_nfc_ops = {
 	.dev_up = hci_dev_up,
 	.dev_down = hci_dev_down,
 	.start_poll = hci_start_poll,
