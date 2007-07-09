Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from NS6.Sony.CO.JP ([137.153.0.32]:38120 "EHLO ns6.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXGIKz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 06:55:29 -0400
Received: from mail7.sony.co.jp (localhost [127.0.0.1])
	by mail7.sony.co.jp (R8/Sony) with ESMTP id l69AtNLb016620
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jul 2007 19:55:23 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail7.sony.co.jp (R8/Sony) with ESMTP id l69AtMYc016611
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jul 2007 19:55:22 +0900 (JST)
Date: Mon, 09 Jul 2007 19:54:39 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
Message-Id: <20070709193744.D021.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes some duplicated wireless ioctl entries in the array
'struct ioctl_trans ioctl_start[]' of fs/compat_ioctl.c

These entries are registered twice like:

	COMPATIBLE_IOCTL(SIOCGIWPRIV)

and

	HANDLE_IOCTL(SIOCGIWPRIV, do_wireless_ioctl)


Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 fs/compat_ioctl.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -3156,12 +3156,9 @@ COMPATIBLE_IOCTL(SIOCSIWSENS)
 COMPATIBLE_IOCTL(SIOCGIWSENS)
 COMPATIBLE_IOCTL(SIOCSIWRANGE)
 COMPATIBLE_IOCTL(SIOCSIWPRIV)
-COMPATIBLE_IOCTL(SIOCGIWPRIV)
 COMPATIBLE_IOCTL(SIOCSIWSTATS)
-COMPATIBLE_IOCTL(SIOCGIWSTATS)
 COMPATIBLE_IOCTL(SIOCSIWAP)
 COMPATIBLE_IOCTL(SIOCGIWAP)
-COMPATIBLE_IOCTL(SIOCSIWSCAN)
 COMPATIBLE_IOCTL(SIOCSIWRATE)
 COMPATIBLE_IOCTL(SIOCGIWRATE)
 COMPATIBLE_IOCTL(SIOCSIWRTS)


--
Masakazu MOKUNO

