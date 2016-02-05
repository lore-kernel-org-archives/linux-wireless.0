Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34047 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbcBEVMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 16:12:54 -0500
Received: by mail-pa0-f50.google.com with SMTP id uo6so40614871pac.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 13:12:54 -0800 (PST)
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
Subject: [PATCH v3 0/4] lib: add "on" and "off" to strtobool
Date: Fri,  5 Feb 2016 13:12:45 -0800
Message-Id: <1454706769-8729-1-git-send-email-keescook@chromium.org> (sfid-20160205_221513_453844_8E453AB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This consolidates logic for handling "on"/"off" parsing for bools into the
strtobool function, by way of moving it into kstrtobool (with helpers),
and updating various callers.

v3:
- removed unused "base" argument
- fixed missing description change
- retained inverted __setup return values
- removed needless extra buffer in cifs

v2:
- moved to kstroto* style

 arch/powerpc/kernel/rtasd.c                    |    7 --
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |   10 ---
 arch/s390/kernel/time.c                        |    8 ---
 arch/s390/kernel/topology.c                    |    7 --
 arch/x86/kernel/aperture_64.c                  |   12 ----
 drivers/net/wireless/marvell/mwifiex/debugfs.c |   10 +--
 fs/cifs/cifs_debug.c                           |   56 +++++----------------
 fs/cifs/cifs_debug.h                           |    2 
 fs/cifs/cifsfs.c                               |    6 +-
 fs/cifs/cifsglob.h                             |    4 -
 include/linux/kernel.h                         |    2 
 include/linux/string.h                         |    6 +-
 include/linux/tick.h                           |    2 
 kernel/time/hrtimer.c                          |   10 ---
 kernel/time/tick-sched.c                       |   10 ---
 lib/kstrtox.c                                  |   64 +++++++++++++++++++++++++
 lib/string.c                                   |   29 -----------
 17 files changed, 110 insertions(+), 135 deletions(-)

-Kees

