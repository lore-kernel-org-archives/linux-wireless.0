Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZLXBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 20:03:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	johannes@sipsolutions.net, Jonathan May <jonathan.may@atheros.com>,
	David Quan <david.quan@atheros.com>
Subject: [PATCH 1/5] mac80211: fix race with suspend and dynamic_ps_disable_work
Date: Wed, 23 Dec 2009 20:03:25 -0500
Message-Id: <1261616609-518-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 suspends it calls a driver's suspend callback
as a last step and after that the driver assumes no calls will
be made to it until we resume and its start callback is kicked.
If such calls are made, however, suspend can end up throwing
hardware in an unexpected state and making the device unusable
upon resume.

This situation is observed with ath9k but likely possible
with any other device which supports and supports dynampic PS
and enabled. When mac80211 suspends it tears down BA sessions
with ieee80211_sta_tear_down_BA_sessions() and since this ends
up transmitting frames through ieee80211_xmit() mac80211 could
end up scheduling the dynamic_ps_disable_work work onto the
mac80211 workqueue. This allows for a race between the work
kicking off and mac80211 completing the suspend work by calling
the driver's stop callback. If the driver's stop callback is
run first and the scheduled work runs later (this is expected
as we don't flush in between) the driver's config callback
could run after the hardware has been turned off which amongst
other things could end up leaving the card with enabled
interrupts and awake leaving the harware in an unpredictable
state prior to suspend. Upon resume the device can become
completely unfunctional displaying PCI-express errors such as
"unsupported request detected" and the driver's respective
start callback would failing. Apart from leaving the hardware
in an unresponsive state since mac80211 currently allows failed
start calls to go through new interrupts will be unhandled and
as such the interrupt for the device will end up getting disabled
as follows:

irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.31.4-intel-menlow #5
Call Trace:
 [<c105ca3e>] __report_bad_irq+0x2e/0x6f
 [<c105cb74>] note_interrupt+0xf5/0x14d
 [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
 [<c10048c1>] handle_irq+0x3b/0x46
 [<c1004103>] do_IRQ+0x41/0x95
 [<c1003189>] common_interrupt+0x29/0x30
 [<c103007b>] ? ptrace_notify+0x12/0x97
 [<c1040f07>] ? tick_nohz_stop_sched_tick+0x2ee/0x2f6
 [<c1001e11>] cpu_idle+0x27/0x5e
 [<c12feb73>] rest_init+0x53/0x55
 [<c14b0805>] start_kernel+0x2f6/0x2fb
 [<c14b0070>] i386_start_kernel+0x70/0x77

Fix this by preventing mac80211 to schedule dynamic_ps_disable_work
by checking for when mac80211 starts to suspend and starts
quiescing. Frames should be allowed to go through though as
that is part of the quiescing steps and we do not flush the
mac80211 workqueue since it was already done towards the
beginning of suspend cycle.

The other mac80211 issue will be hanled in the next patch.

For further details see refer to the thread:

http://marc.info/?t=126144866100001&r=1&w=2

Cc: stable@kernel.org
Cc: johannes@sipsolutions.net
Cc: Jonathan May <jonathan.may@atheros.com>
Cc: David Quan <david.quan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/tx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ac48c86..42bfd97 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1418,6 +1418,10 @@ static bool need_dynamic_ps(struct ieee80211_local *local)
 	if (!local->ps_sdata)
 		return false;
 
+	/* No point if we're going to suspend */
+	if (local->quiescing)
+		return false;
+
 	return true;
 }
 
-- 
1.6.3.3

