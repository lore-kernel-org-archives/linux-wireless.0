Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53144 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0ECSPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 14:15:14 -0400
Date: Mon, 3 May 2010 14:07:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH wireless-2.6] iwlwifi: work around passive scan issue
Message-ID: <20100503180659.GC25748@tuxdriver.com>
References: <1272668402-3722-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1272668402-3722-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 30, 2010 at 04:00:02PM -0700, Reinette Chatre wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some firmware versions don't behave properly when
> passive scanning is requested on radar channels
> without enabling active scanning on receiving a
> good frame. Work around that issue by asking the
> firmware to only enable the active scanning after
> receiving a huge number of good frames, a number
> that can never be reached during our dwell time.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

What is the consequence of this bug?  It is very late in the 2.6.34
cycle and it isn't obvious to me that this is something that has to
be fixed in this cycle.  I see the comment about "sysassert", but I
don't know if that leads to something inconvenient (like restarting
the firmware) or something much worse?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
