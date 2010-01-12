Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36955 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752367Ab0ALOcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 09:32:55 -0500
Date: Tue, 12 Jan 2010 09:32:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Johannes Berg <johannes@sipsolutions.net>
cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.33] cfg80211: fix refcount imbalance when wext is
 disabled
In-Reply-To: <1263222897.29743.2.camel@johannes.local>
Message-ID: <Pine.LNX.4.44L0.1001120931400.3018-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 11 Jan 2010, Johannes Berg wrote:

> When CONFIG_CFG80211_WEXT is not set, there is
> a refcount imbalance with rdev->opencount, fix
> that by moving it out of the ifdef.
> 
> Reported-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I confirm that this fixes hang in rmmod.  And enabling 
CONFIG_CFG80211_WEXT fixes the issue about the wireless card not 
working.

Tested-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern


