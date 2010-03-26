Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38606 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0CZDhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 23:37:06 -0400
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
From: Zhu Yi <yi.zhu@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100325072627.GA2562@dhcp-lab-161.englab.brq.redhat.com>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
	 <20100324140034.6a6d91c9@dhcp-lab-109.englab.brq.redhat.com>
	 <1269447362.6935.2.camel@jlt3.sipsolutions.net>
	 <20100325072627.GA2562@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 11:37:51 +0800
Message-ID: <1269574671.4043.189.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-25 at 15:26 +0800, Stanislaw Gruszka wrote:
> 
> But wait, isn't that all just workaround for bad performing allocator,
> what should be fixed in proper place not in mac80211 nor iwlwifi. What
> for exactly this is needed, concretes please - that is not described
> in patch changelog. 

If a devices is capable of DMA a frame to/from physically discontinuous
host memory, the paged SKB handling can mitigate memory subsystem
pressure for large chunk of continuous memory allocation and also avoid
CPU cycles for memcpy. In Linux kernel, since TCP/IP stacks and
(capable) devices support paged SKBs, mac80211 will become the
bottleneck if it still couldn't provide the support. For devices don't
support paged SKBs, this patch doesn't bring performance issues. So it
should be a good thing to have for us.

Thanks,
-yi

