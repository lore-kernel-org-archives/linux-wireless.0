Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab1CCSsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:25 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:25 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/19] rt2x00: Add unlikely macro to special case tx status handling
Date: Thu, 3 Mar 2011 19:40:33 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031939.28091.IvDoorn@gmail.com> <201103031939.57117.IvDoorn@gmail.com>
In-Reply-To: <201103031939.57117.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031940.34167.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This special case shouldn't happen very often. Only if a frame that
is not intended to be aggregated ends up in an AMPDU _and_ was intended
to be sent at a different MCS rate as the aggregate. Hence, using
unlikely is justified.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7dba354..66ff8d5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -681,7 +681,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
 	 * confuse the rate control algortihm by providing clearly wrong
 	 * data.
 	 */
-	if (aggr == 1 && ampdu == 0 && real_mcs != mcs) {
+	if (unlikely(aggr == 1 && ampdu == 0 && real_mcs != mcs)) {
 		skbdesc->tx_rate_idx = real_mcs;
 		mcs = real_mcs;
 	}
-- 
1.7.2.3

