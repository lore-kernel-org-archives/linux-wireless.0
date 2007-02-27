Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2272 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXB0Deu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 22:34:50 -0500
Received: from ra.tuxdriver.com (ra.tuxdriver.com [127.0.0.1])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l1R3Yfc8015225
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2007 22:34:46 -0500
Received: (from uucp@localhost)
	by ra.tuxdriver.com (8.13.7/8.13.6/Submit) with UUCP id l1R3VTt4015202
	for linux-wireless@vger.kernel.org; Mon, 26 Feb 2007 22:31:29 -0500
Received: from linville-t43.mobile (linville-t43.mobile [127.0.0.1])
	by linville-t43.mobile (8.13.8/8.13.8) with ESMTP id l1R3RxXc018729
	for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2007 22:28:00 -0500
Received: (from linville@localhost)
	by linville-t43.mobile (8.13.8/8.13.8/Submit) id l1R3RwMZ018723
	for linux-wireless@vger.kernel.org; Mon, 26 Feb 2007 22:27:58 -0500
Date: Mon, 26 Feb 2007 22:27:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: rename d80211 -> mac80211
Message-ID: <20070227032756.GA6569@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been threatening to do this for a while.  Since I've recently
pulled from everyone, the incoming patch rate is slow this week,
and we are getting close to being in -mm, now seems as good a time
as any to do it...

I've changed all references in wireless-dev from d80211 to mac80211
and from D80211 to MAC80211, including renaming files and directories
appropriately.  If you have outstanding patches, please account for
this change.  Filtering them through sed should do the job nicely:

	cat old.patch | sed -e 's/d80211/mac80211/g' \
		-e 's/D80211/MAC80211/g' > new.patch

I don't think it would have been appropriate to keep the old name,
with its veiled reference to its origin but no real meaning to the
uninitiated.  I think the mac80211 name is more indicative of the
component's function, and it matches the naming motif we are using
for cfg80211 and nl80211.

I apologize if this seems sudden, but I don't really think doing
it with a lot of warning would have been any better.  So, I made
the decision and did it.  Please don't complain unless it is just
unbearable for you. :-)

The patch has been pushed to wireless-dev, and hopefully will be
available by the time you read this.

Thanks,

John

P.S.  The actual patch is too large to post here.  It is available
on www.kernel.org:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-dev/master/0738-wireless-rename-d80211-mac80211.patch

-- 
John W. Linville
linville@tuxdriver.com
