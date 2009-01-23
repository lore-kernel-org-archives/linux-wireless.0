Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:42095 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbZAWQEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:04:14 -0500
Received: by ewy13 with SMTP id 13so3698997ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 08:04:12 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/3] rt2x00: rt2x00_rev() should return u32
Date: Fri, 23 Jan 2009 17:03:06 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901231703.06609.IvDoorn@gmail.com> (sfid-20090123_170419_416005_0783BDF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "rev" field in chipset definition is an u32,
which means that rt2x00_rev() which returns that field
should be of the same type.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index cc56637..d39e834 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -868,7 +868,7 @@ static inline char rt2x00_rf(const struct rt2x00_chip *chipset, const u16 chip)
 	return (chipset->rf == chip);
 }
 
-static inline u16 rt2x00_rev(const struct rt2x00_chip *chipset)
+static inline u32 rt2x00_rev(const struct rt2x00_chip *chipset)
 {
 	return chipset->rev;
 }
-- 
1.5.6.1

