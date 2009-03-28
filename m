Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:62207 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455AbZC1Tww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 15:52:52 -0400
Received: by ey-out-2122.google.com with SMTP id 4so441054eyf.37
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 12:52:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/4] rt2x00: Fix Sparse warning
Date: Sat, 28 Mar 2009 20:51:41 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <200903282051.25112.IvDoorn@gmail.com>
In-Reply-To: <200903282051.25112.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903282051.41343.IvDoorn@gmail.com> (sfid-20090328_205305_871512_EA7597AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00link_reset_qual() is not declared in a header,
and is only internally used within rt2x00link.c.
It should be declared as static.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00link.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 7eb5cd7..eb9b981 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -387,7 +387,7 @@ void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
 		rt2x00link_antenna_reset(rt2x00dev);
 }
 
-void rt2x00link_reset_qual(struct rt2x00_dev *rt2x00dev)
+static void rt2x00link_reset_qual(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_qual *qual = &rt2x00dev->link.qual;
 
-- 
1.5.6.1

