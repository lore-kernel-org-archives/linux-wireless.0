Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32579 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYKXUaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 15:30:15 -0500
Subject: Re: [PATCH 1/2] mac80211: enabling an AP that can't support fully
	PS clients (wireless-testing).
From: Pavel Roskin <proski@gnu.org>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, j@w1.fi
In-Reply-To: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com>
References: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 15:30:12 -0500
Message-Id: <1227558612.28878.1.camel@dv> (sfid-20081124_213019_748805_AB0310EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-24 at 09:44 +0200, Rami Rosen wrote:
> This patch enables mac80211 to support the PS challenged mode when
> used in master mode.
> A new attribute, NL80211_ATTR_WIPHY_AP_PS_CHALLENGED, was added to
> nl80211_attrs; also a new member (ap_ps_challenged) was added to
> struct wiphy; and nl80211_send_wiphy() was adjusted accordingly.
> 
> User space applications (like hostapd) should check the
> NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
> attribute and  display a proper message, if it is set, to inform the
> users.

Maybe it would be better to require a switch to hostapd to enable
support for such devices?  Messages are too easy to ignore.

-- 
Regards,
Pavel Roskin
