Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:58979 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYCIVup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:45 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1362530fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:43 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 03/24] rt2x00: Use the correct size when copying the control info in txdone
Date: Sun, 9 Mar 2008 22:39:32 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092239.32604.IvDoorn@gmail.com> (sfid-20080309_215047_396226_DA60AA15)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

The sizeof() operator was incorrectly applied to the pointer, not the struct.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b3a639a..141b9b8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -521,7 +521,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	tx_status.ack_signal = 0;
 	tx_status.excessive_retries = (txdesc->status == TX_FAIL_RETRY);
 	tx_status.retry_count = txdesc->retry;
-	memcpy(&tx_status.control, txdesc->control, sizeof(txdesc->control));
+	memcpy(&tx_status.control, txdesc->control, sizeof(*txdesc->control));
 
 	if (!(tx_status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
 		if (success)
-- 
1.5.4.3

