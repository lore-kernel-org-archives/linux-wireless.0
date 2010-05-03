Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0ECUuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:50:17 -0400
Subject: Re: [PATCH wireless-2.6] iwlwifi: work around passive scan issue
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <20100503180659.GC25748@tuxdriver.com>
References: <1272668402-3722-1-git-send-email-reinette.chatre@intel.com>
	 <20100503180659.GC25748@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 13:50:16 -0700
Message-ID: <1272919816.7879.5955.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Mon, 2010-05-03 at 11:07 -0700, John W. Linville wrote:
> On Fri, Apr 30, 2010 at 04:00:02PM -0700, Reinette Chatre wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Some firmware versions don't behave properly when
> > passive scanning is requested on radar channels
> > without enabling active scanning on receiving a
> > good frame. Work around that issue by asking the
> > firmware to only enable the active scanning after
> > receiving a huge number of good frames, a number
> > that can never be reached during our dwell time.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> What is the consequence of this bug?  It is very late in the 2.6.34
> cycle and it isn't obvious to me that this is something that has to
> be fixed in this cycle.  I see the comment about "sysassert", but I
> don't know if that leads to something inconvenient (like restarting
> the firmware) or something much worse?

Unfortunately a sysassert does lead to firmware restart.

Reinette


