Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62104 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYDVCBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 22:01:06 -0400
Subject: Re: [Ipw2100-devel] ipw2200: queue direct scans
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1208800153.30994.25.camel@localhost.localdomain>
References: <1208800153.30994.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 09:50:43 +0800
Message-Id: <1208829043.5327.13.camel@debian.sh.intel.com> (sfid-20080422_040155_932936_539C7819)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-21 at 13:49 -0400, Dan Williams wrote:
> When another scan is in progress, a direct scan gets dropped on the
> floor.  However, that direct scan is usually the scan that's really
> needed by userspace, and gets stomped on by all the broadcast scans
> the
> ipw2200 driver issues internally.  Make sure the direct scan happens
> eventually, and as a bonus ensure that the passive scan worker is
> cleaned up when appropriate.
> 
> The change of request_passive_scan form a struct work to struct
> delayed_work is only to make the set_wx_scan() code a bit simpler,
> it's
> still only used with a delay of 0 to match previous behavior.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

I agree with you the idea to split the current active request_scan into
active direct scan and active broadcast scan. But can you merge your
ipw_request_direct_scan_helper into ipw_request_scan_helper so that we
don't duplicate the code?

Thanks,
-yi

