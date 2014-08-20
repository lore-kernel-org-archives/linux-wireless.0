Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60480 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbaHTS5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 14:57:01 -0400
Received: by mail-vc0-f180.google.com with SMTP id ij19so9624595vcb.39
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 11:57:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Aug 2014 13:57:00 -0500
Message-ID: <CAFZT-j+2U4gfjtOSHrZqt1F1AEKwEv-CJUzjVAAfK9BgwNh6Eg@mail.gmail.com> (sfid-20140820_205719_200113_82D70E0A)
Subject: Missing mutex_unlock and possible race scenraio in function
 (wl1271_remove) in file (linux3.2/drivers/net/wireless/wl12xx/sdio.c)
From: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bug Report Filed: https://bugzilla.kernel.org/show_bug.cgi?id=82901
Linux Version [3.2] and [android-omap-3.0]

Function's Source Code:
http://lxr.free-electrons.com/source/drivers/net/wireless/wl12xx/sdio.c?v=3.2#L313

function (wl1271_remove) in file (linux3.2/drivers/net/wireless/wl12xx/sdio.c):

The mutex object (&wl->mutex) may get locked upon exit of function
(wl1271_unregister_hw) through the call to function
(__wl1271_plt_stop). However, the lock is never released upon exit of
function (wl1271_unregister_hw).

The buggy scenario happens as follows:

(wl1271_remove) calls (wl1271_unregister_hw) which acquires the locks.
Then, (wl1271_remove) calls (wl1271_free_hw) which tries to lock the
object the already locked in (wl1271_unregister_hw) which causes a
race scenario.

Possible fix is to call (wl1271_plt_stop) instead of
(__wl1271_plt_stop) in function (wl1271_unregister_hw) in file
(http://lxr.free-electrons.com/source/drivers/net/wireless/wl12xx/main.c?v=3.2#L4650).

The bug also occurs in Android Linux kernel:
https://android.googlesource.com/kernel/omap/+/android-omap-3.0/drivers/net/wireless/wl12xx/sdio.c
@ line 319

Bug found via C-Atlas tool [http://www.ensoftcorp.com/]
