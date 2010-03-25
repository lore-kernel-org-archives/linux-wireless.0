Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:25547 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab0CYVK7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 17:10:59 -0400
Subject: Re: [PATCH 21/22] iwlwifi: change spin_lock to spin_lock_irqsave
From: Pavel Roskin <proski@gnu.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
In-Reply-To: <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
	 <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Thu, 25 Mar 2010 17:10:57 -0400
Message-Id: <1269551457.2626.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-25 at 13:44 -0700, Reinette Chatre wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Use spin_lock_irqsave() in interrupt handler to disable interrupts locally
> and provide the spinlock on SMP. This covers both interrupt and SMP
> concurrency.
> 
> With this changes, also fix the sparse warning issues.

As far as I understand, spin_lock_irqsave() is superfluous in interrupt
handlers, since interrupt handlers are run with interrupts disabled.

I wonder if you hit the problem that my patch should fix:
https://patchwork.kernel.org/patch/84441/

Basically, sparse diagnostics for not fully preemptible SMP kernels is
so bogus that it should be ignored completely.

-- 
Regards,
Pavel Roskin
