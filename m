Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0C2Bqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 21:46:51 -0400
Subject: Re: [PATCH 21/22] iwlwifi: change spin_lock to spin_lock_irqsave
From: Zhu Yi <yi.zhu@intel.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1269615842.5202.7.camel@wwguy-ubuntu>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
	 <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
	 <1269551457.2626.12.camel@mj>  <1269615842.5202.7.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 09:47:25 +0800
Message-ID: <1269827245.4043.245.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 23:04 +0800, Guy, Wey-Yi wrote:
> There are two solutions.  The first is to take the
> lock with spin_lock_irqsave(). The second is to specify
> IRQF_DISABLED to request_irq() so that the kernel runs the entire
> interrupt routine with interrupts disabled. 

FYI. IRQF_DISABLED is not suggested to use together with IRQF_SHARED.
See the warning in request_threaded_irq().

Thanks,
-yi

