Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2493 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbYFMNcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 09:32:43 -0400
Date: Fri, 13 Jun 2008 09:03:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
Message-ID: <20080613130310.GA5333@tuxdriver.com> (sfid-20080613_153245_430286_CBBA23C6)
References: <484FEA26.1040305@gmail.com> <1213241315.7814.696.camel@debian.sh.intel.com> <20080612135936.GA5031@tuxdriver.com> <1213342523.7814.865.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213342523.7814.865.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 03:35:23PM +0800, Zhu Yi wrote:
> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
> > How does the hardware scan differ from what mac80211 does when
> > scanning?
> 
> Software scan disables Tx during the scan process while hardware scan
> doesn't. So you are expected to see continous ping responds instead of a
> freeze during the scan period. Hardware scan is also more efficient
> since it is handled by the firmware.
> 
> > I still see a lot of mysterious iwlwifi (especially iwl3945)
> > problems in Fedora that seem to disappear with disable_hw_scan=1.
> 
> I don't see this problem from my side. I'll do more testing for 3945.

FWIW, I don't have a reproducing environment that requires
disable_hw_scan either.  But I could probably dig-out several Fedora
bug reports that claim to need it.

> > Honestly I'm tempted to change it to "enable_hw_scan" instead...
> 
> Give the advantages, I'd like to use it if we can fix the bug (I haven't
> seen what the bug is myself). But you are free to change the default
> value until it is fixed. There is no such problem for 4965, right?

AFAICT only the 3945 seems to need it.

John
-- 
John W. Linville
linville@tuxdriver.com
