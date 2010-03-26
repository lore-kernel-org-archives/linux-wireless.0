Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50591 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0CZQZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 12:25:31 -0400
Subject: Re: [PATCH 21/22] iwlwifi: change spin_lock to spin_lock_irqsave
From: Pavel Roskin <proski@gnu.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1269615842.5202.7.camel@wwguy-ubuntu>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
	 <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
	 <1269551457.2626.12.camel@mj>  <1269615842.5202.7.camel@wwguy-ubuntu>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 12:25:29 -0400
Message-Id: <1269620729.6452.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 08:04 -0700, Guy, Wey-Yi wrote:

> There are two solutions.  The first is to take the
> lock with spin_lock_irqsave(). The second is to specify
> IRQF_DISABLED to request_irq() so that the kernel runs the entire
> interrupt routine with interrupts disabled.
> 
> Since we do not need to hold the lock for the whole time interrupt
> is running, the first solution is more suitable for it.

OK, I wasn't aware of such details.  I just didn't want that change to
be done only because of sparse.  I'm fine with the patch now.

-- 
Regards,
Pavel Roskin
