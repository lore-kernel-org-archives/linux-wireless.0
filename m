Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:7770 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbYGRSlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:41:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so160308nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 11:41:17 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/6] rt2x00: Fix EIFS timing value
Date: Fri, 18 Jul 2008 20:43:51 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807182043.08990.IvDoorn@gmail.com> <200807182043.34057.IvDoorn@gmail.com>
In-Reply-To: <200807182043.34057.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807182043.52015.IvDoorn@gmail.com> (sfid-20080718_204120_604514_0A4487CA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Olivier reported a difference between the EIFS
values used in the legacy driver and the one in
the rt2x00 drivers.

In rt2x00 the value was
	( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
	which comes down to 314us

while the legacy driver uses the value 364us

This patch will hardcode the EIFS to the correct value.

Reported-by: Olivier Cornu <o.cornu@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9fab0df..ec57da9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -108,7 +108,7 @@
 #define SHORT_PIFS		( SIFS + SHORT_SLOT_TIME )
 #define DIFS			( PIFS + SLOT_TIME )
 #define SHORT_DIFS		( SHORT_PIFS + SHORT_SLOT_TIME )
-#define EIFS			( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
+#define EIFS			364
 
 /*
  * Chipset identification
-- 
1.5.6.1

