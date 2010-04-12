Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56517 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0DLF3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 01:29:45 -0400
Received: by qyk9 with SMTP id 9so3465245qyk.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Apr 2010 22:29:44 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Apr 2010 00:29:42 -0500
Message-ID: <n2icdc21431004112229n9303fcc1s788eadda177d079a@mail.gmail.com>
Subject: On ath9k debugfs, having trouble recompiling and inserting only ath9k
From: Rakesh Kumar <gopchandani@gmail.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I modified few entries in ath9k's debug.c and used them in the
code. Recompiled the module ath9k, went painlessly. But when I try to
do following:

sudo insmod drivers/net/wireless/ath/ath9k/ath9k.ko

I get the following error: insmod: error inserting
'drivers/net/wireless/ath/ath9k/ath9k.ko': -1 Unknown symbol in module
I remember this error occurs when the module being inserted is not
compiled with the kernel currently running. But in my case, that's not
true.

dmesg only yeilds following pertinent line:

[29471.324717] ath9k: Unable to create debugfs root: -2

Which indicates a failure to create the root directory under
/sys/kernel/debug/ath9k/...

Any ideas on why this is happening would be highly appreciated!

--
Rakesh
