Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3625 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYEPRux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 13:50:53 -0400
Date: Fri, 16 May 2008 13:25:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: mrv8k vs. mac80211
Message-ID: <20080516172535.GA9880@tuxdriver.com> (sfid-20080516_195058_116314_E09A7632)
References: <1210694421.24737.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1210694421.24737.19.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 12:00:21PM -0400, Dan Williams wrote:
> Hi,
> 
> mrv8k has commands that should be sent before a scan is started, and
> after a scan has finished.  There aren't really pre/post scan hooks in
> mac80211, though there certainly could be without too much trouble.  The
> other possibility is to inspect the filter flags when
> ops->configure_filter gets called, since FIF_BCN_PRBRESP_PROMISC gets
> flipped before and after the scan.  But that seems ugly and unstable.
> 
> Any objections to adding ops->pre_scan and ops->post_scan hooks?  Or
> should I just use the configure_filter hack...  or is there a better
> way?

The pre/post hooks make sense to me...Johannes?

John
-- 
John W. Linville
linville@tuxdriver.com
