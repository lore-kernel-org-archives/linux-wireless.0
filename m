Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032852Ab2CPPVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:21:45 -0400
Subject: Re: [RFC] cfg80211: Indicate the automatic channel selection
 capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331909733-16767-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120316_155551_647367_7F3C7BB8)
References: <1331909733-16767-1-git-send-email-nataraja@qca.qualcomm.com>
	 (sfid-20120316_155551_647367_7F3C7BB8)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 16:21:42 +0100
Message-ID: <1331911302.6753.26.camel@jlt3.sipsolutions.net> (sfid-20120316_162148_685342_A72D04B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 20:25 +0530, Vivek Natarajan wrote:
> Let the driver automatically select the channel based on the
> channel conditions when it is not explicitly set.
> The drivers which have this capability in the firmware can set
> the WIPHY_FLAG_SUPPORTS_ACS flag to indicate that to the
> userspace.

> + * @NL80211_ATTR_ACS: Indicates whether the firmware is capable of doing
> + *      automatic channel selection if the channel is not explicitly set.

Ok so ... this is lacking a lot of information. The state "channel is
not explicitly set" doesn't even really exist either for AP mode. I'm
assuming you're talking about AP mode since you never actually said
so ......

Since there's no "channel unset" state, you'd want to have some sort of
"please select a good channel and tell me" when you do START_AP in
nl80211, or something like that, right?

Please think about this a bit more.

johannes

