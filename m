Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25731 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0CZCsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 22:48:17 -0400
Subject: Re: [ipw3945-devel] [PATCH 21/22] iwlwifi: change spin_lock to
 spin_lock_irqsave
From: Zhu Yi <yi.zhu@intel.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1269551457.2626.12.camel@mj>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
	 <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
	 <1269551457.2626.12.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 10:49:02 +0800
Message-ID: <1269571742.4043.161.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 05:10 +0800, Pavel Roskin wrote:
> As far as I understand, spin_lock_irqsave() is superfluous in
> interrupt handlers, since interrupt handlers are run with interrupts
> disabled.

spin_lock_irqsave is required if multiple interrupts are used, i.e.
MSI-X. IOAPIC only guarantees the same interrupt line is disabled during
the isr.

Thanks,
-yi

