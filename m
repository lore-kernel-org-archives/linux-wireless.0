Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0JILge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 07:36:34 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so23937ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 04:36:33 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/06] rt2x00: Remove superfluous initialization of qidx
Date: Sat, 9 Oct 2010 13:35:13 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010091333.17274.IvDoorn@gmail.com> <201010091334.12741.IvDoorn@gmail.com> <201010091334.44618.IvDoorn@gmail.com>
In-Reply-To: <201010091334.44618.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010091335.13894.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

There is no need to initialize qidx to zero as it will ever be
overwritten by the correct value.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 85a134c..cc4e17c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -573,7 +573,7 @@ static void rt2800pci_kick_tx_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
-	unsigned int qidx = 0;
+	unsigned int qidx;
 
 	if (queue->qid == QID_MGMT)
 		qidx = 5;
-- 
1.7.2.3

