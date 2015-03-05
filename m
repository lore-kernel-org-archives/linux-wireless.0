Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38374 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825AbbCEPxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 10:53:52 -0500
Message-ID: <1425570829.2493.28.camel@sipsolutions.net> (sfid-20150305_165355_483055_FBBC5B87)
Subject: Re: [RFC] mac80211: lock rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Marek Lindner <marek@open-mesh.com>
Date: Thu, 05 Mar 2015 16:53:49 +0100
In-Reply-To: <4955461.tuO2xra8Dr@bentobox> (sfid-20150305_165241_332301_188B5342)
References: <1425569832-22373-1-git-send-email-johannes@sipsolutions.net>
	 <4955461.tuO2xra8Dr@bentobox> (sfid-20150305_165241_332301_188B5342)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-05 at 16:52 +0100, Sven Eckelmann wrote:

> > I've manipulated hostapd to test this, by having it change its
> > advertised bandwidth roughly ever 150ms. At the same time, I'm
> > running a flood ping between the client and the AP, which causes
> > this race of update vs. get_rate/status to easily happen on the
> > client. With this change, the system survives this test.

> I will ask if it is possible to test this patch in an affected network. But I 
> am quite sure that this will not be possible before next week. And your test 
> already sounds quite nice.

Note that I tested with iwlwifi, not with minstrel. However, I'm pretty
sure it's the same problem.

johannes

