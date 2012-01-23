Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:43705 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab2AWR63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 12:58:29 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RpO9y-00074t-N9
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 18:58:26 +0100
Received: from localhost ([::1]:56305 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RpO9y-00039v-MU
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 18:58:26 +0100
Received: from [195.4.92.20] (port=45621 helo=10.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RpO7E-0000eU-67
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 18:55:36 +0100
Received: from [2002:4fde:11a5:2:5054:ff:feb8:40bd] (port=33471 helo=mail.maya.org)
	by 10.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RpO7D-0005Dj-PW
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 18:55:36 +0100
Message-Id: <201201231755.q0NHtQUR002682@mail.maya.org> (sfid-20120123_185831_900058_58DC8C36)
Date: Mon, 23 Jan 2012 18:55:24 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat: add __cancel_delayed_work()
In-Reply-To: <CAB=NE6UBBRg53EjW3t8YEUoGLvQS00dnx6Z=-rmBa7pb-D_TCg@mail.gmail.com>
References: <1327153475-28081-1-git-send-email-hauke@hauke-m.de> <CAB=NE6UBBRg53EjW3t8YEUoGLvQS00dnx6Z=-rmBa7pb-D_TCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez schrieb:
> On Sat, Jan 21, 2012 at 5:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> __cancel_delayed_work is needed by include/net/bluetooth/l2cap.h and
>> not available in old kernel versions. This was just copied from the
>> kernel.
>>
>> This should also go into compat-wireless-stable-3.3.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> Thanks! Applied all onto compat-wireless.git and compat.git, in
> addition to the linux-3.3.y branch for compat.git as you indicated for
> this patch. Will roll out a new tarball right away.

BTW: I've to apply always the following patch to some older
compat-wireless packages (3.2 e.g) to get it compiled with kernel 3.1:

--- drivers/misc/eeprom/Makefile.orig	2012-01-10 02:10:51.000000000 +0100
+++ drivers/misc/eeprom/Makefile	2012-01-10 05:14:40.082494612 +0100
@@ -1,3 +1,3 @@
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
-obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
+# obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
 obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o

Is this eventually needed in 3.3, too?


Thanks,
Andreas
