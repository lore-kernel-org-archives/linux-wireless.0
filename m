Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:14299 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYGSODR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:03:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so250599nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 07:03:16 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/5] rt2x00: Fix EIFS timing value
Date: Sat, 19 Jul 2008 16:16:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Olivier Cornu <o.cornu@gmail.com>
References: <200807191615.22752.IvDoorn@gmail.com> <200807191615.42755.IvDoorn@gmail.com>
In-Reply-To: <200807191615.42755.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807191616.13129.IvDoorn@gmail.com> (sfid-20080719_160321_683540_E5D6E1F9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Olivier reported a difference between the EIFS
values used in the legacy driver and the one in
the rt2x00 drivers.

In rt2x00 the value was
	( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
which comes down to 314us while the legacy driver uses the value 364us

This was caused because EIFS is: SIFS + DIFS + AckTime
This patch will fix this by adding the DIFS by the above value,
and creating a SHORT_EIFS define which uses the SHORT_DIFS.

Reported-by: Olivier Cornu <o.cornu@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    5 ++++-
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9fab0df..fe5ee8a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -108,7 +108,10 @@
 #define SHORT_PIFS		( SIFS + SHORT_SLOT_TIME )
 #define DIFS			( PIFS + SLOT_TIME )
 #define SHORT_DIFS		( SHORT_PIFS + SHORT_SLOT_TIME )
-#define EIFS			( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
+#define EIFS			( SIFS + DIFS + \
+				  (8 * (IEEE80211_HEADER + ACK_SIZE)) )
+#define SHORT_EIFS		( SIFS + SHORT_DIFS + \
+				  (8 * (IEEE80211_HEADER + ACK_SIZE)) )
 
 /*
  * Chipset identification
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index f20ca71..3f89516 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -271,7 +271,7 @@ config:
 		libconf.sifs = SIFS;
 		libconf.pifs = short_slot_time ? SHORT_PIFS : PIFS;
 		libconf.difs = short_slot_time ? SHORT_DIFS : DIFS;
-		libconf.eifs = EIFS;
+		libconf.eifs = short_slot_time ? SHORT_EIFS : EIFS;
 	}
 
 	libconf.conf = conf;
-- 
1.5.6.1

