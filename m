Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10743 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXJVIxj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 04:53:39 -0400
Subject: Re: [PATCH] ipw2200: batch non-user-requested scan result
	notifications
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
In-Reply-To: <1191952524.617.7.camel@localhost.localdomain>
References: <1191952524.617.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 16:45:19 +0800
Message-Id: <1193042719.3069.166.camel@debian.sh.intel.com> (sfid-20071022_095343_071895_C0B3B10B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-10-09 at 13:55 -0400, Dan Williams wrote:
> ipw2200 makes extensive use of background scanning when unassociated
> or
> down.  Unfortunately, the firmware sends scan completed events many
> times per second, which the driver pushes directly up to userspace.
> This needlessly wakes up processes listening for wireless events many
> times per second.  Batch together scan completed events for
> non-user-requested scans and send them up to userspace every 4
> seconds.
> Scan completed events resulting from an SIOCSIWSCAN call are pushed up
> without delay.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

I'm OK with this one except the round_jiffies part.

Thanks,
-yi
