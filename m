Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2KIQ25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 11:28:57 -0500
Message-ID: <1352478572.9238.14.camel@jlt4.sipsolutions.net> (sfid-20121109_172900_745991_C856C763)
Subject: Re: [PATCH] nl/cfg80211: advertise OBSS scan offload capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 09 Nov 2012 17:29:32 +0100
In-Reply-To: <1352415240-5168-1-git-send-email-bzhao@marvell.com>
References: <1352415240-5168-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 14:54 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> New flag is added to inform userspace that this driver doesn't
> internally perform OBSS scan. It can use this feature available
> in userspace application.

Shouldn't that be a little more precisely worded? Most drivers already
expect wpa_s to do this, but apparently the assumption was that without
the flag, full-MAC drivers, i.e. drivers implementing the nl80211
connect API (rather than auth/assoc) do it themselves?

Or maybe mac80211 should just set the flag?

johannes

