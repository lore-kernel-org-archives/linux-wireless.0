Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:39391 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310AbYERSn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 14:43:59 -0400
Received: by py-out-1112.google.com with SMTP id u52so1548670pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 18 May 2008 11:43:58 -0700 (PDT)
Message-ID: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com> (sfid-20080518_204425_789187_C8282DCB)
Date: Sun, 18 May 2008 14:43:58 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi Makefile issue in compat-wireless-2008-05-18
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

 Went to install the new version and found that it wasn't installing
the iwl4965 driver.  I did a diff against my last good version (back
in April so not sure how long its been like this)


I noticed this change, and when I reverted it back, the driver built fine:


compat-wireless-2008-05-18$ diff -u
/usr/local/src/compat-wireless-2008-04-08/drivers/net/wireless/Makefile
 drivers/net/wireless/Makefile
--- /usr/local/src/compat-wireless-2008-04-08/drivers/net/wireless/Makefile
    2008-04-08 00:12:21.000000000 -0400
+++ drivers/net/wireless/Makefile       2008-05-18 00:11:30.000000000 -0400
@@ -23,12 +23,9 @@

 obj-$(CONFIG_ADM8211)  += adm8211.o

-obj-$(CONFIG_IWL3945)  += iwlwifi/
-obj-$(CONFIG_IWL4965)  += iwlwifi/
+obj-$(CONFIG_IWLWIFI)  += iwlwifi/
 obj-$(CONFIG_RT2X00)   += rt2x00/





Hope this helps to straighten this issue out.


Thanks,
John
