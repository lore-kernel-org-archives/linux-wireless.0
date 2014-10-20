Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36264 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbaJTJrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:47:25 -0400
Message-ID: <1413798437.10246.12.camel@jlt4.sipsolutions.net> (sfid-20141020_114737_037262_91FE6DE8)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Johannes Berg <johannes@sipsolutions.net>
To: vadim4j@gmail.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 20 Oct 2014 11:47:17 +0200
In-Reply-To: <20141014121627.GA5115@angus-think.lan> (sfid-20141014_142515_817763_5937F980)
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	 <1411075535.2034.5.camel@jlt4.sipsolutions.net>
	 <20141014121627.GA5115@angus-think.lan>
	 (sfid-20141014_142515_817763_5937F980)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-14 at 15:16 +0300, vadim4j@gmail.com wrote:

> The reason for this was to make possible to change netns for wireless
> dev via 'ip link' too like for 'iw' util. I just think that changing
> namespace for netdev should have the generic way. May be you can suggest
> a better way

That's a respectable goal, but I think you're way overshooting it and
thus getting it wrong. You're changing the semantics from

 "please switch this interface to that other netns"

to
 "please switch this interface *and all others on this HW* to that other
netns"

which is, in my opinion, something so much more unexpected and prone to
breaking people's setups than returning "not supported" here.

johannes

