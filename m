Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56326 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbdGJOpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 10:45:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 1/2] x86: mark target address as output in 'insb' asm
Date: Mon, 10 Jul 2017 16:44:24 +0200
Message-Id: <20170710144425.2238584-1-arnd@arndb.de> (sfid-20170710_164605_113357_CF8BC265)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The -Wmaybe-uninitialized warning triggers for one driver using the output
of the 'insb' I/O helper on x86:

drivers/net/wireless/wl3501_cs.c: In function ‘wl3501_mgmt_scan_confirm’:
drivers/net/wireless/wl3501_cs.c:665:9: error: ‘sig.status’ is used uninitialized in this function [-Werror=uninitialized]
drivers/net/wireless/wl3501_cs.c:668:12: error: ‘sig.cap_info’ may be used uninitialized in this function [-Werror=maybe-uninitialized]

Apparently the assember constraints are slightly off here, as marking the
'addr' argument as a memory output seems appropriate here and gets rid
of the warning. For consistency I'm also adding it as input for outsb().

Unfortunately, this fix triggers another problem when CONFIG_KASAN is
set, again only in this one driver:

drivers/net/wireless/wl3501_cs.c: In function 'wl3501_rx_interrupt':
drivers/net/wireless/wl3501_cs.c:1103:1: error: the frame size of 2232 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

I'm not an x86 person and gcc inline assembly mystifies me all the time,
so please review this carefully and suggest a better way if this is not
how it should be done.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/include/asm/io.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7afb0e2f07f4..d107251eabd9 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -328,13 +328,13 @@ static inline unsigned type in##bwl##_p(int port)			\
 static inline void outs##bwl(int port, const void *addr, unsigned long count) \
 {									\
 	asm volatile("rep; outs" #bwl					\
-		     : "+S"(addr), "+c"(count) : "d"(port));		\
+		     : "+S"(addr), "+c"(count) : "d"(port), "m" (addr));\
 }									\
 									\
 static inline void ins##bwl(int port, void *addr, unsigned long count)	\
 {									\
 	asm volatile("rep; ins" #bwl					\
-		     : "+D"(addr), "+c"(count) : "d"(port));		\
+		     : "+D"(addr), "+c"(count), "=m" (addr) : "d"(port));\
 }
 
 BUILDIO(b, b, char)
-- 
2.9.0
