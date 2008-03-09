Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYCIVv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:27 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:26 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 21/24] rt2x00: Fix compile error when rfkill is disabled
Date: Sun, 9 Mar 2008 22:48:28 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092248.29080.IvDoorn@gmail.com> (sfid-20080309_222528_349645_482EEF70)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix obvious error that prevented compilation while rfkill
was disabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00lib.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index fd25797..64fae7e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -171,8 +171,13 @@ static inline void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
 }
 
-static inline void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev);
-static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev);
+static inline void rt2x00rfkill_suspend(struct rt2x00_dev *rt2x00dev)
+{
+}
+
+static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev)
+{
+}
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 /*
-- 
1.5.4.3

