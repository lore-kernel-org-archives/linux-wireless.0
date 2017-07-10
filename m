Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:56187 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbdGJOpl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 10:45:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 2/2] wl3501_cs: reduce stack size for KASAN
Date: Mon, 10 Jul 2017 16:44:25 +0200
Message-Id: <20170710144425.2238584-2-arnd@arndb.de> (sfid-20170710_164611_019437_F5F69CC1)
In-Reply-To: <20170710144425.2238584-1-arnd@arndb.de>
References: <20170710144425.2238584-1-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inlining functions with local variables can lead to excessive stack usage
with KASAN after a previous patch that modifies the outsb/insb helpers
on x86.

drivers/net/wireless/wl3501_cs.c: In function 'wl3501_rx_interrupt':
drivers/net/wireless/wl3501_cs.c:1103:1: error: the frame size of 2232 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

Marking the two callers of insb/outb 'noinline' prevents the compiler
from adding up the stack usage for each of the local variables passed
into those, reducing the maximum stack frame size to 800 bytes with
KASAN again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/wl3501_cs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index acec0d9ec422..2cce22571b4c 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -242,8 +242,8 @@ static int wl3501_get_flash_mac_addr(struct wl3501_card *this)
  *
  * Move 'size' bytes from PC to card. (Shouldn't be interrupted)
  */
-static void wl3501_set_to_wla(struct wl3501_card *this, u16 dest, void *src,
-			      int size)
+static noinline void wl3501_set_to_wla(struct wl3501_card *this,
+				       u16 dest, void *src, int size)
 {
 	/* switch to SRAM Page 0 */
 	wl3501_switch_page(this, (dest & 0x8000) ? WL3501_BSS_SPAGE1 :
@@ -264,8 +264,8 @@ static void wl3501_set_to_wla(struct wl3501_card *this, u16 dest, void *src,
  *
  * Move 'size' bytes from card to PC. (Shouldn't be interrupted)
  */
-static void wl3501_get_from_wla(struct wl3501_card *this, u16 src, void *dest,
-				int size)
+static noinline void wl3501_get_from_wla(struct wl3501_card *this,
+					 u16 src, void *dest, int size)
 {
 	/* switch to SRAM Page 0 */
 	wl3501_switch_page(this, (src & 0x8000) ? WL3501_BSS_SPAGE1 :
-- 
2.9.0
