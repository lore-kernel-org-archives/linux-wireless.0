Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52718 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757004AbXFVPty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 11:49:54 -0400
Date: Fri, 22 Jun 2007 17:49:53 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Green <andy@warmcat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070622174953.500817e0@griffin.suse.cz>
In-Reply-To: <1182526221.21939.94.camel@johannes.berg>
References: <1182418939.10821.8.camel@johannes.berg>
	<20070621143558.68fc8e4a@griffin.suse.cz>
	<1182429920.21939.1.camel@johannes.berg>
	<20070621151441.500d62d5@griffin.suse.cz>
	<20070622154545.29eeebdb@griffin.suse.cz>
	<467BDCB1.1010604@warmcat.com>
	<1182526221.21939.94.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jun 2007 17:30:21 +0200, Johannes Berg wrote:
> In addition, we still have the problem with receiving encrypted eapol
> frames etc. that we really need to see unencrypted but can't make it to
> the network interface.

Hm, are you able to get such management frames if you're not root (or
has CAP_NET_RAW capabilities)?

> I'm still for using netlink. It's just a socket too after all, and
> what's the conceptual difference between packing network packets into
> other packets or packing them into netlink messages? I don't see why
> people are so dead set against using nl80211 for the userspace MLME
> needs including frame stuff.

I think netlink is fine if it is used for injection too (at least of
management frames and WPA stuff).

 Jiri

-- 
Jiri Benc
SUSE Labs
