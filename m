Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0JILgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 07:36:36 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so23937ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 04:36:35 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/06] rt2x00: Fix tx status handling in rt2800pci
Date: Sat, 9 Oct 2010 13:35:48 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010091333.17274.IvDoorn@gmail.com> <201010091334.44618.IvDoorn@gmail.com> <201010091335.13894.IvDoorn@gmail.com>
In-Reply-To: <201010091335.13894.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010091335.49039.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The patches "rt2x00: Improve TX status entry validation" and "rt2x00: rework tx
status handling in rt2800pci" together were causing problems with tx status
processing in rt2800pci:

phy1 -> rt2800pci_txdone: Warning - Got TX status for an empty queue 3, dropping
phy1 -> rt2800pci_txdone: Warning - Got TX status for an unavailable queue 7, dropping

Fix this by using the correct field definition for getting the QID out of the
tx status report.

Reported-by: Luis Correia <luis.f.correia@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Tested-by: Luis Correia <luis.f.correia@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index cc4e17c..b267395 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -676,7 +676,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		}
 
-		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_TYPE) - 1;
+		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
 		if (qid >= QID_RX) {
 			/*
 			 * Unknown queue, this shouldn't happen. Just drop
-- 
1.7.2.3

