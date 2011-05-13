Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35342 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab1EMUez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 16:34:55 -0400
Date: Fri, 13 May 2011 21:34:49 +0100
From: James Hogan <james@albanarts.com>
To: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: BUG: scheduling while atomic 2.6.39-rc7 (iwl3945_irq_tasklet)
Message-ID: <20110513203448.GA3523@gandalf> (sfid-20110513_223515_230171_21D9C89C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 2.6.39-rc7 I've seen a panic due to "BUG: scheduling while atomic"
with the backtrace below (not much detail as it was written in a text
message while it was displayed on the screen!). All worked fine in
2.6.38.

This was soon after resuming from suspend (enough time to unlock the
screen, but not much else). I think it was the same bug I saw in rc2 but
didn't have time to track down. I can probably get it to happen again if
more detail is needed. It doesn't happen every suspend (I think it had
survived a couple of suspend/resume cycles at this point).

I could bisect if necessary, but hopefully the backtrace will be enough
to see what's going on?

Cheers
James

...
die
do_general_protection
? restore_args
general protection
? iwl3945_irq_tasklet
? handle_irq_event
tasklet_action
__do_softirq
? lock_release
call_softirq
do_softirq
irq_exit
do_IRQ
common_interrupt
