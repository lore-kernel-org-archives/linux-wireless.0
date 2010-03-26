Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41501 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0CZOHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 10:07:31 -0400
Subject: Re: [PATCH 21/22] iwlwifi: change spin_lock to spin_lock_irqsave
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1269551457.2626.12.camel@mj>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
	 <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
	 <1269551457.2626.12.camel@mj>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 08:04:02 -0700
Message-Id: <1269615842.5202.7.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

On Thu, 2010-03-25 at 14:10 -0700, Pavel Roskin wrote:
> On Thu, 2010-03-25 at 13:44 -0700, Reinette Chatre wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > Use spin_lock_irqsave() in interrupt handler to disable interrupts locally
> > and provide the spinlock on SMP. This covers both interrupt and SMP
> > concurrency.
> > 
> > With this changes, also fix the sparse warning issues.
> 
> As far as I understand, spin_lock_irqsave() is superfluous in interrupt
> handlers, since interrupt handlers are run with interrupts disabled.
> There are two solutions.  The first is to take the
lock with spin_lock_irqsave() or spin_lock_irq() (see
Documentation/DocBook/kernel-locking).  The second is to specify
IRQF_DISABLED to request_irq() so that the kernel runs the entire
interrupt routine with interrupts disabled.

If your MSI interrupt routine does not hold the lock for the whole time
it is running, the first solution may be best.  The second solution is
normally preferred as it avoids making two transitions from interrupt
disabled to enabled and back again.
> I wonder if you hit the problem that my patch should fix:
> https://patchwork.kernel.org/patch/84441/
> 
> Basically, sparse diagnostics for not fully preemptible SMP kernels is
> so bogus that it should be ignored completely.
> 
Just like Yi's reply, with pin-based interrupts or a single MSI, it is
not necessary to disable interrupts (Linux guarantees the same interrupt
will not be re-entered).  If a device uses multiple interrupts, the
driver must disable interrupts while the lock is held.  If the device
sends a different interrupt, the driver will deadlock trying to
recursively acquire the spinlock.

There are two solutions.  The first is to take the
lock with spin_lock_irqsave(). The second is to specify
IRQF_DISABLED to request_irq() so that the kernel runs the entire
interrupt routine with interrupts disabled.

Since we do not need to hold the lock for the whole time interrupt
is running, the first solution is more suitable for it.

Best Regards
Wey
  

