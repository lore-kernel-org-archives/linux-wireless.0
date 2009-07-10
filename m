Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9750 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZGJQbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 12:31:25 -0400
Subject: Re: [PATCH] cfg80211: don't look at wdev->ssid for giwessid
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247241214.29747.5.camel@johannes.local>
References: <1247241214.29747.5.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 12:31:22 -0400
Message-Id: <1247243482.2877.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-10 at 17:53 +0200, Johannes Berg wrote:
> This variable is only used internally, _while_ connected.
> If we use it, the sequence
> 
> # iwconfig wlan1 essid foo
> <connects>
> # iwconfig wlan1 essid ""
> <disconnects>
> # iwconfig

That was quick, thank you!  Indeed, it's possible to unset ESSID not and
set it to another value.  But switching from "foo" to "bar" is still not
working.

-- 
Regards,
Pavel Roskin
