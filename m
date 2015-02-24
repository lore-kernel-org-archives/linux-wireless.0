Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38179 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbbBXKPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:15:22 -0500
Message-ID: <1424772920.2192.20.camel@sipsolutions.net> (sfid-20150224_111526_353852_4C92F772)
Subject: Re: [PATCH] mac80211_hwsim: support any address in userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 11:15:20 +0100
In-Reply-To: <1424705624-7964-1-git-send-email-me@bobcopeland.com> (sfid-20150223_163628_160158_62E4F7CC)
References: <1424705624-7964-1-git-send-email-me@bobcopeland.com>
	 (sfid-20150223_163628_160158_62E4F7CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-23 at 10:33 -0500, Bob Copeland wrote:
> Due to the checks in get_hwsim_data_ref_from_addr, wmediumd
> was only able to use the second mac address (those starting with
> 0x42).  This is confusing and needlessly limiting, so allow any
> configured address.
> 
> While at it, use ether_addr_equal since data->addresses and the
> address from the netlink payload are aligned(2).

As I mentioned on IRC, I think you should iterate the interfaces to
identify the currently live MAC addresses instead of the fake "hw
addresses" we assign to each hwsim radio.

johannes

