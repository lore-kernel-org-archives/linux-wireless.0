Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57271 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbbF2IOl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 04:14:41 -0400
Message-ID: <1435565678.2156.9.camel@sipsolutions.net> (sfid-20150629_101447_360817_E4688716)
Subject: Re: Null pointer dereference when station associates [introduced by
 4.0.5?]
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Hughes <tom@compton.nu>, linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Mon, 29 Jun 2015 10:14:38 +0200
In-Reply-To: <558EC27A.60804@compton.nu> (sfid-20150627_181129_907073_7F8F41EE)
References: <558EC27A.60804@compton.nu>
	 (sfid-20150627_181129_907073_7F8F41EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-06-27 at 16:34 +0100, Tom Hughes wrote:
> 
> Interestingly from what I can see this is trying to create a file
> for the station at a path something like:
> 
> ieee80211/phy0/netdev:XXXX/stations/XXXXXX

indeed.

> but in my (currently working) boot under 4.0.4 there is no netdev
> directory under phy0 in debugfs... but then maybe that is the problem
> as well if the inode pointer was null?
> 

This is pretty strange - if the dentry pointer (sdata
->debugfs.subdir_stations) was NULL or an ERR_PTR(), the code would
return pretty much immediately.

So it looks like that pointer is valid, but it's ->d_inode was NULL?

I'm not really sure how that could happen.

Since 4.0.4 was stable, and 4.0.5 crashes, you'd think there's
something wrong between those two kernels and there were no changes to
mac80211 related to these code paths in there.

johannes
