Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34598 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbcBDVAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 16:00:51 -0500
Received: by mail-pf0-f178.google.com with SMTP id o185so55779854pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 13:00:51 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Joe Perches <joe@perches.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>, x86@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] lib: add "on" and "off" to strtobool
Date: Thu,  4 Feb 2016 13:00:39 -0800
Message-Id: <1454619643-14444-1-git-send-email-keescook@chromium.org> (sfid-20160204_220247_482633_659286A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This consolidates logic for handling "on"/"off" parsing for bools into
the strtobool function, by way of moving it into kstrtobool (with helpers),
and updating various callers.

 arch/powerpc/kernel/rtasd.c                    |    9 ---
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |   10 ----
 arch/s390/kernel/time.c                        |    8 ---
 arch/s390/kernel/topology.c                    |    7 ---
 arch/x86/kernel/aperture_64.c                  |   12 -----
 drivers/net/wireless/marvell/mwifiex/debugfs.c |   10 +---
 fs/cifs/cifs_debug.c                           |   58 ++++++-------------------
 fs/cifs/cifs_debug.h                           |    2 
 fs/cifs/cifsfs.c                               |    6 +-
 fs/cifs/cifsglob.h                             |    4 -
 include/linux/kernel.h                         |    3 +
 include/linux/string.h                         |    6 ++
 include/linux/tick.h                           |    2 
 kernel/time/hrtimer.c                          |   10 ----
 kernel/time/tick-sched.c                       |   10 ----
 lib/kstrtox.c                                  |   49 +++++++++++++++++++++
 lib/string.c                                   |   29 ------------
 17 files changed, 98 insertions(+), 137 deletions(-)

-Kees

