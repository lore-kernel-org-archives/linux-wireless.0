Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58363 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1BYJp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 04:45:26 -0500
Received: by vws12 with SMTP id 12so1211149vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 01:45:25 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 25 Feb 2011 10:45:25 +0100
Message-ID: <AANLkTim24Dwv6GitGHS8VGc==yZKC40XChoz9E0-oqtB@mail.gmail.com>
Subject: compat-wireless-2011-02-24 does not compile against kernel 2.6.24
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to compile compat-wireless against a 2.6.24 kernel and
when compiling compat-2.6.39.c, i get the following errors:


/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:
In function tty_set_termios:
/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:81:
error: struct tty_struct has no member named ctrl_lock
/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:91:
error: struct tty_struct has no member named ctrl_lock
/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:96:
error: struct tty_struct has no member named ops
/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:97:
error: struct tty_struct has no member named ops
/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:103:
error: struct tty_ldisc has no member named ops
/home/xxx/Documents/01_Src/03_LinuxKernels/compat-wireless-2011-02-24/compat/compat-2.6.39.c:104:
error: struct tty_ldisc has no member named ops

I also checked, and in the 2.6.24 kernel, there is no ctrl_lock or ops
 within the tty_struct structure.

This seems to be a bluetooth issue (as bluetooth is only supported by
2.6.27 and up, so I guess that needs to be checked in 2.6.39.

Or else, am I missing something?

Regards,

Juan Carlos
