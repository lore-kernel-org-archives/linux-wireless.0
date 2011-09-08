Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47845 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab1IHMjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:36 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so422913eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:36 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/7] rt2x00: Use the available helper functions to initialize the WCID table
Date: Thu, 8 Sep 2011 14:39:04 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201109081434.23635.IvDoorn@gmail.com> <201109081438.02330.IvDoorn@gmail.com> <201109081438.37130.IvDoorn@gmail.com>
In-Reply-To: <201109081438.37130.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109081439.05539.IvDoorn@gmail.com> (sfid-20110908_143941_899654_FF69AD4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Use rt2800_config_wcid and rt2800_delete_wcid_attr to initialize the
WCID table instead of writing to the registers directly.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2f4d51a..3d9f355 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2846,11 +2846,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 					 SHARED_KEY_MODE_ENTRY(i), 0);
 
 	for (i = 0; i < 256; i++) {
-		static const u32 wcid[2] = { 0xffffffff, 0x00ffffff };
-		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
-					      wcid, sizeof(wcid));
-
-		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 0);
+		rt2800_config_wcid(rt2x00dev, NULL, i);
+		rt2800_delete_wcid_attr(rt2x00dev, i);
 		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
 	}
 
-- 
1.7.3.4
