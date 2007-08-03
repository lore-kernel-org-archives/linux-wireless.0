Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:41232 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759473AbXHCKtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:49:14 -0400
Message-ID: <46B30828.3000507@warmcat.com>
Date: Fri, 03 Aug 2007 11:49:12 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 driver interface semantics
References: <46B27729.5030406@gentoo.org>	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>	 <1186134894.4647.24.camel@johannes.berg>  <46B3032C.5040306@warmcat.com>	 <1186137166.4647.34.camel@johannes.berg>  <46B304FF.3000305@warmcat.com> <1186137715.4647.36.camel@johannes.berg>
In-Reply-To: <1186137715.4647.36.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Fri, 2007-08-03 at 11:35 +0100, Andy Green wrote:
> 
>> Right, but since we marked up the skb "the integrity of the IP checksum
>> is unknown", if anything wants to use the packet it should re-check it
>> itself.  Won't that do?
> 
> It'll check the IP checksum anyway since we don't have hardware that
> checks it as far as I know, but we want to check the FCS.

I guess I didn't understand where the problem can come from, then.

''Because if you have both a hard monitor and a regular interface
(monitor_during_oper allowed) then we will never check the CRC on frames
that enter the networking path and can get corrupted TCP packets in etc.''

If the rest of the networking stack didn't trust the packet anyway and
confirms the IP-level checksum, then it can make its own opinion about
the packet.

For stuff that is looking at the whole rx packet including the ieee80211
header, we can add a bit in the radiotap flags on top of the packet
noting that it failed FCS.

-Andy
