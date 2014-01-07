Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaAGPf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:35:28 -0500
Message-ID: <1389108924.4645.14.camel@jlt4.sipsolutions.net> (sfid-20140107_163532_219008_9EE11A76)
Subject: Re: [PATCH 3/3] cfg80211: processing regulatory requests on netdev
 notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:35:24 +0100
In-Reply-To: <1387486399-4053-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215341_748002_0553EE53)
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
	 <1387486399-4053-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131219_215341_748002_0553EE53)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
> This adds a trigger to review any pending regulatory
> requests whenever an 802.11 device interface is brought
> down or up. We use this as an opportunistic trigger
> for checking the regulatory work queues as otherwise
> they they're only checked upon an initial regulatory
> request or when beacon hints are found.
> 
> This opportunistic mechanism can be used to trigger
> kicking the queues regulatory queues at any time from
> userspace without having to change the regulatory state.

I don't like this. Can't we just have a self-contained timeout on the
userspace request instead?

johannes

