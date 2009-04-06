Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([204.127.217.106]:42609 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZDFDym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 23:54:42 -0400
Message-ID: <49D97CF5.4040808@lwfinger.net> (sfid-20090406_055446_566442_F2A74F76)
Date: Sun, 05 Apr 2009 22:54:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: b43 WARN_ON
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the latest rfkill patches posted by Johannes, I am hitting the following

        if (WARN_ON(!wl->rfkill.registered))
                return -EINVAL;

in b43_rfkill_soft_set() as follows:

------------[ cut here ]------------
WARNING: at drivers/net/wireless/b43/rfkill.c:77 b43_rfkill_soft_set+0x38/0xb3
[b43]()
Hardware name: HP Pavilion dv2700 Notebook PC
--snip--
---[ end trace a1ef19d1571fdb71 ]---
b43 ssb0:0: firmware: requesting b43/ucode5.fw
b43 ssb0:0: firmware: requesting b43/pcm5.fw
b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0: Radio turned on by software

Larry
