Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbYIXAAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 20:00:16 -0400
Date: Tue, 23 Sep 2008 16:59:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: ath9k on arm
Message-Id: <20080923165921.983b2b6c.akpm@linux-foundation.org> (sfid-20080924_020022_405002_BB552EC2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/usr/src/devel/arch/arm/include/asm/string.h:42:1: warning: this is the location of the previous definition
In file included from drivers/net/wireless/ath9k/recv.c:21:
drivers/net/wireless/ath9k/core.h:88:1: warning: "memzero" redefined
In file included from include/linux/string.h:19,
                 from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:89,
                 from include/linux/mmzone.h:16,
                 from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from drivers/net/wireless/ath9k/core.h:23,
                 from drivers/net/wireless/ath9k/recv.c:21:
/usr/src/devel/arch/arm/include/asm/string.h:42:1: warning: this is the location of the previous definition
In file included from drivers/net/wireless/ath9k/xmit.c:21:
drivers/net/wireless/ath9k/core.h:88:1: warning: "memzero" redefined
In file included from include/linux/string.h:19,
                 from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:89,
                 from include/linux/mmzone.h:16,
                 from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from drivers/net/wireless/ath9k/core.h:23,
                 from drivers/net/wireless/ath9k/xmit.c:21:
/usr/src/devel/arch/arm/include/asm/string.h:42:1: warning: this is the location of the previous definition
In file included from drivers/net/wireless/ath9k/rc.c:22:
drivers/net/wireless/ath9k/core.h:88:1: warning: "memzero" redefined
In file included from include/linux/string.h:19,
                 from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:89,
                 from include/linux/mmzone.h:16,
                 from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from drivers/net/wireless/ath9k/core.h:23,
                 from drivers/net/wireless/ath9k/rc.c:22:
/usr/src/devel/arch/arm/include/asm/string.h:42:1: warning: this is the location of the previous definition
In file included from drivers/net/wireless/ath9k/core.c:19:
drivers/net/wireless/ath9k/core.h:88:1: warning: "memzero" redefined
In file included from include/linux/string.h:19,
                 from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:89,
                 from include/linux/mmzone.h:16,
                 from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from drivers/net/wireless/ath9k/core.h:23,
                 from drivers/net/wireless/ath9k/core.c:19:
/usr/src/devel/arch/arm/include/asm/string.h:42:1: warning: this is the location of the previous definition
(etc)


/* XXX: remove */
#define memzero(_buf, _len) memset(_buf, 0, _len)

I agree. asap, please.


Practically nothing in arm uses memzero() so I'd suggest that this
quite risky definition be removed from arm also.  Just use memset.
