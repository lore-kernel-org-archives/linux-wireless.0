Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37997 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbbBXJ6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:58:25 -0500
Message-ID: <1424771892.2192.9.camel@sipsolutions.net> (sfid-20150224_105840_213260_5F9E2D91)
Subject: Re: [PATCH] nl80211: Fix possible leak in nl80211_new_interface on
 MONITOR_FLAG_ACTIVE
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 10:58:12 +0100
In-Reply-To: <1423943521-2896-1-git-send-email-cengelma@gmx.at> (sfid-20150214_205224_679047_9F3F20CE)
References: <1423943521-2896-1-git-send-email-cengelma@gmx.at>
	 (sfid-20150214_205224_679047_9F3F20CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-02-14 at 20:52 +0100, Christian Engelmayer wrote:
> In case of NL80211_IFTYPE_MONITOR and flag MONITOR_FLAG_ACTIVE, the already
> allocated sk_buff 'msg' is not freed, when the function exits in case the
> feature is not supported. Detected by Coverity CID 1269116.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested only. Applies against linux-next.

Thanks for the report. I've fixed this in a different way.

johannes

