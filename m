Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab2EGKcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:55 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 16/20] NFC: HCI ops should not be exposed globally
Date: Mon,  7 May 2012 12:31:27 +0200
Message-Id: <1336386691-24840-17-git-send-email-sameo@linux.intel.com> (sfid-20120507_123258_216412_E94139A6)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: H Hartley Sweeten <hartleys@visionengravers.com>

The variable 'hci_nfc_ops' is only referenced in this file and
should be marked static to prevent it from being exposed globally.

Quites the sparse warning:

warning: symbol 'hci_nfc_ops' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/hci/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index f7e4f5a..0fdb96f 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -585,7 +585,7 @@ static int hci_check_presence(struct nfc_dev *nfc_dev,
 	return 0;
 }
 
-struct nfc_ops hci_nfc_ops = {
+static struct nfc_ops hci_nfc_ops = {
 	.dev_up = hci_dev_up,
 	.dev_down = hci_dev_down,
 	.start_poll = hci_start_poll,
-- 
1.7.9.1

