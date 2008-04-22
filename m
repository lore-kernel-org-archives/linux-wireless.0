Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbYDVDA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 23:00:27 -0400
Subject: Re: [Ipw2100-devel] ipw2200: queue direct scans
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1208829043.5327.13.camel@debian.sh.intel.com>
References: <1208800153.30994.25.camel@localhost.localdomain>
	 <1208829043.5327.13.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 22:56:36 -0400
Message-Id: <1208832996.4232.10.camel@localhost.localdomain> (sfid-20080422_050118_561655_2ABF72D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-22 at 09:50 +0800, Zhu Yi wrote:
> On Mon, 2008-04-21 at 13:49 -0400, Dan Williams wrote:
> > When another scan is in progress, a direct scan gets dropped on the
> > floor.  However, that direct scan is usually the scan that's really
> > needed by userspace, and gets stomped on by all the broadcast scans
> > the
> > ipw2200 driver issues internally.  Make sure the direct scan happens
> > eventually, and as a bonus ensure that the passive scan worker is
> > cleaned up when appropriate.
> > 
> > The change of request_passive_scan form a struct work to struct
> > delayed_work is only to make the set_wx_scan() code a bit simpler,
> > it's
> > still only used with a delay of 0 to match previous behavior.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> I agree with you the idea to split the current active request_scan into
> active direct scan and active broadcast scan. But can you merge your
> ipw_request_direct_scan_helper into ipw_request_scan_helper so that we
> don't duplicate the code?

Sure, can give that a shot.

Dan


