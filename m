Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58698 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbaKKOy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 09:54:59 -0500
Message-ID: <1415717695.2163.6.camel@sipsolutions.net> (sfid-20141111_155533_125936_DF9209F8)
Subject: Re: [PATCH] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Nov 2014 15:54:55 +0100
In-Reply-To: <1415716059-608-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141111_152746_888050_18874AA2)
References: <1415716059-608-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141111_152746_888050_18874AA2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-11 at 16:27 +0200, Jukka Rissanen wrote:
> A new attribute NL80211_ATTR_SCAN_SOCKET_OWNER can be set by the
> scan initiator. If present, the attribute will cause the scan to
> be stopped if the client dies.

We already have NL80211_ATTR_IFACE_SOCKET_OWNER, maybe we can repurpose
this flag to a more general "owner" flag?

Of course we need to keep ABI (same attribute number) and API (a
#define) but that's not an issue.

johannes

