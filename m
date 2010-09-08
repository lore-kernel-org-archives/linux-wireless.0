Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65375 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0IHS6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:58:23 -0400
Received: by mail-ey0-f174.google.com with SMTP id 6so346757eyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 11:58:22 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/06] rt2x00: fix oops in rt2x00lib_txdone with rt61pci
Date: Wed, 8 Sep 2010 20:57:40 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Pavel Roskin <proski@gnu.org>
References: <201009082055.38033.IvDoorn@gmail.com> <201009082056.53759.IvDoorn@gmail.com> <201009082057.11427.IvDoorn@gmail.com>
In-Reply-To: <201009082057.11427.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009082057.41892.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix a typo introduced in "rt2x00: Add helper function for reporting tx
status" that results in an oops in rt2x00lib_txdone.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 4aec344..97b3935 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2117,7 +2117,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 				"TX status report missed for entry %d\n",
 				entry_done->entry_idx);
 
-			rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
+			rt2x00lib_txdone_noinfo(entry_done, TXDONE_UNKNOWN);
 			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		}
 
-- 
1.7.2.2

