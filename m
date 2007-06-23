Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42188 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753907AbXFWLoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 07:44:55 -0400
Date: Sat, 23 Jun 2007 13:44:51 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Green <andy@warmcat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070623134451.643dd40c@logostar.upir.cz>
In-Reply-To: <1182581630.21939.105.camel@johannes.berg>
References: <1182418939.10821.8.camel@johannes.berg>
	<20070621143558.68fc8e4a@griffin.suse.cz>
	<1182429920.21939.1.camel@johannes.berg>
	<20070621151441.500d62d5@griffin.suse.cz>
	<20070622154545.29eeebdb@griffin.suse.cz>
	<467BDCB1.1010604@warmcat.com>
	<1182526221.21939.94.camel@johannes.berg>
	<20070622174953.500817e0@griffin.suse.cz>
	<1182543620.21939.98.camel@johannes.berg>
	<467CB691.2090806@warmcat.com>
	<1182581630.21939.105.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 23 Jun 2007 08:53:50 +0200, Johannes Berg wrote:
> Who started this anti-nl80211 thing anyway? I still don't see what's so
> wrong with sending frames down a PF_NETLINK socket rather than a
> PF_PACKET socket.

Perhaps it was just my misunderstanding about the monitor interface tx
injection patches; I though this mechanism should be used for hostapd and
user space MLME, which I consider wrong. Johannes' comment about different
needs (and thus having both injection through monitor iface and through
netlink) makes perfectly sense, though.

Andy, is using a monitor interface (for both injecting and receiving of
frames) acceptable for you? If yes, let's drop my proposal (I said it might
turn up to be useless :-)), apply patches for monitor iface injection and
implement a netlink soultion as a replacement of the current management
interface.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
