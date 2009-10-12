Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZJLT6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 15:58:17 -0400
Subject: Re: [PATCH 02/17 v2.6.32] iwl3945: update iwl3945_apm_init()
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <20091012185943.GC2794@tuxdriver.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
	 <1255119634-3060-3-git-send-email-reinette.chatre@intel.com>
	 <20091012185943.GC2794@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 12:57:40 -0700
Message-Id: <1255377460.30637.150.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Mon, 2009-10-12 at 11:59 -0700, John W. Linville wrote:
> On Fri, Oct 09, 2009 at 01:20:18PM -0700, Reinette Chatre wrote:
> > From: Ben Cahill <ben.m.cahill@intel.com>
> > 
> > Update iwl3945_apm_init() to set up device registers in sequence most recently
> > recommended by factory.
> > 
> > Add resets for APMG interrupts and radio chip, formerly done only in
> > iwl3945_apm_reset(); moving them here assures that apm_init() will do
> > a complete job of preparing hardware not only after platform boot,
> > but also after apm_stop() has executed (due to rfkill, ifconfig down,
> > driver unload, etc.).  This is in preparation to completely remove apm_reset().
> > 
> > Add some comments.
> > 
> > Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Is this actually a regression?  Can you provide a reference to the bug report?

This is something we discovered in the lab when we connected power
measurement tools to the device when the interface was down. In this
scenario the device is using a lot of power. This is not a regression
from the previous kernel version, it is something that was broken for a
while and only recently discovered. 

Patches 2/17 and 3/17 address this issue and the above comment applies
to both.

We are still looking into issues related to this discovery and you may
see more fixes for this problem.

Reinette




