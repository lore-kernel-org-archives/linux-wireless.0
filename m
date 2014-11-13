Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44111 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbaKMNxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 08:53:06 -0500
Message-ID: <1415886781.2021.5.camel@sipsolutions.net> (sfid-20141113_145312_395972_F297C712)
Subject: Re: [PATCH v4 2/2] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Nov 2014 14:53:01 +0100
In-Reply-To: <1415886592-18253-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_145007_695801_4D8E9F47)
References: <1415886592-18253-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415886592-18253-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141113_145007_695801_4D8E9F47)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-13 at 15:49 +0200, Jukka Rissanen wrote:
> An attribute NL80211_ATTR_SOCKET_OWNER can be set by the scan initiator.
> If present, the attribute will cause the scan to be stopped if the client
> dies.

> +	if (rtnl_trylock()) {
> +		__cfg80211_stop_sched_scan(rdev, false);
> +		rtnl_unlock();
> +	}

Umm, no. Locking in the kernel doesn't work this way.

johannes

