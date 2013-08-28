Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:44165 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3H1Twd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 15:52:33 -0400
Received: by mail-we0-f173.google.com with SMTP id x54so5685714wes.32
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 12:52:32 -0700 (PDT)
Message-ID: <1377719543.6577.5.camel@canaries32-MCP7A> (sfid-20130828_215236_720279_2C426348)
Subject: [PATCH] staging: vt6656: baseband.h re: baseband.c:877:26: sparse:
 incorrect type in assignment (different base types)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-wireless@vger.kernel.org
Date: Wed, 28 Aug 2013 20:52:23 +0100
In-Reply-To: <20130828000913.GB22736@kroah.com>
References: <521d3206.kvo7haa9KidRYAUN%fengguang.wu@intel.com>
	 <20130828000913.GB22736@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse warnings: (new ones prefixed by >>)
...
>> drivers/staging/vt6656/baseband.c:877:26: sparse: incorrect type in assignment (different base types)
   drivers/staging/vt6656/baseband.c:877:26:    expected unsigned short [unsigned] [usertype] len
   drivers/staging/vt6656/baseband.c:877:26:    got restricted __le16 [usertype] <noident>
>> drivers/staging/vt6656/baseband.c:880:26: sparse: incorrect type in assignment (different base types)
   drivers/staging/vt6656/baseband.c:880:26:    expected unsigned short [unsigned] [usertype] len
   drivers/staging/vt6656/baseband.c:880:26:    got restricted __le16 [usertype] <noident>

vnt_phy_field member len should be __le16.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index a8db17d..79faedf4 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -85,7 +85,7 @@
 struct vnt_phy_field {
 	u8 signal;
 	u8 service;
-	u16 len;
+	__le16 len;
 } __packed;
 
 unsigned int
-- 
1.8.1.2

