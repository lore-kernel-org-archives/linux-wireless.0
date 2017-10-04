Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:49155 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdJDX1z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 19:27:55 -0400
Received: by mail-pg0-f42.google.com with SMTP id v13so7324094pgq.6
        for <linux-wireless@vger.kernel.org>; Wed, 04 Oct 2017 16:27:55 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
        Chris Metcalf <cmetcalf@mellanox.com>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Harish Patil <harish.patil@cavium.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Julian Wiedmann <jwi@linux.vnet.ibm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        Mark Gross <mark.gross@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Reed <mdr@sgi.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sebastian Reichel <sre@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        linux1394-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] timer: Remove init_timer_pinned() in favor of timer_setup()
Date: Wed,  4 Oct 2017 16:26:58 -0700
Message-Id: <1507159627-127660-5-git-send-email-keescook@chromium.org> (sfid-20171005_013453_730071_5AE7F396)
In-Reply-To: <1507159627-127660-1-git-send-email-keescook@chromium.org>
References: <1507159627-127660-1-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactors the only users of init_timer_pinned() to use
the new timer_setup() and from_timer(). Drops the definition of
init_timer_pinned().

Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/tile/tilepro.c | 9 ++++-----
 include/linux/timer.h               | 2 --
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index 49ccee4b9aec..56d06282fbde 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -608,9 +608,9 @@ static void tile_net_schedule_egress_timer(struct tile_net_cpu *info)
  * ISSUE: Maybe instead track number of expected completions, and free
  * only that many, resetting to zero if "pending" is ever false.
  */
-static void tile_net_handle_egress_timer(unsigned long arg)
+static void tile_net_handle_egress_timer(struct timer_list *t)
 {
-	struct tile_net_cpu *info = (struct tile_net_cpu *)arg;
+	struct tile_net_cpu *info = from_timer(info, t, egress_timer);
 	struct net_device *dev = info->napi.dev;
 
 	/* The timer is no longer scheduled. */
@@ -1004,9 +1004,8 @@ static void tile_net_register(void *dev_ptr)
 		BUG();
 
 	/* Initialize the egress timer. */
-	init_timer_pinned(&info->egress_timer);
-	info->egress_timer.data = (long)info;
-	info->egress_timer.function = tile_net_handle_egress_timer;
+	timer_setup(&info->egress_timer, tile_net_handle_egress_timer,
+		    TIMER_PINNED);
 
 	u64_stats_init(&info->stats.syncp);
 
diff --git a/include/linux/timer.h b/include/linux/timer.h
index b10c4bdc6fbd..9da903562ed4 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -128,8 +128,6 @@ static inline void init_timer_on_stack_key(struct timer_list *timer,
 
 #define init_timer(timer)						\
 	__init_timer((timer), 0)
-#define init_timer_pinned(timer)					\
-	__init_timer((timer), TIMER_PINNED)
 #define init_timer_deferrable(timer)					\
 	__init_timer((timer), TIMER_DEFERRABLE)
 
-- 
2.7.4
