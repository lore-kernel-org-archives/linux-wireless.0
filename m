Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39914 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbbAZTwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 14:52:42 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so13670862pab.5
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 11:52:41 -0800 (PST)
From: David Ramos <davidramos2007@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: Uninitialized memcpy length (segfault) in airo_get_essid (drivers/net/wireless/airo.c)
Date: Mon, 26 Jan 2015 11:52:37 -0800
Message-Id: <3B0A4D15-A224-40B4-8BC0-2577B68231CB@gmail.com> (sfid-20150126_205245_251001_D1A1DE50)
Cc: linux-wireless@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Our UC-KLEE tool found an uninitialized memcpy length (segfault) bug in airo_get_essid (drivers/net/wireless/airo.c). We found the bug in kernel 3.16.3, but it appears to date back beyond the original kernel git commit in 2005 (1da177e4c3f41524e886b7f1b8a0c1fc7321cac2).

The offending code is as follows:

5912   readStatusRid(local, &status_rid, 1);
5913
5914   /* Note : if dwrq->flags != 0, we should                                                                                                                                                    
5915    * get the relevant SSID from the SSID list... */
5916
5917   /* Get the current SSID */
5918   memcpy(extra, status_rid.SSID, le16_to_cpu(status_rid.SSIDlen));

The call to readStatusRid() on line 5912 fails if PC4500_readrid() fails, which can happen if down_interruptible() fails (e.g., is interrupted). This leaves the ‘status_rid’ struct uninitialized. The memcpy() at line 5918 then uses garbage values from the stack as the memcpy length, which can corrupt memory or cause a kernel segfault.

The recommended fix is to check the return value of readStatusRid() and return an error when it fails.

Please let me know if you have any questions.

Thanks,
-David


