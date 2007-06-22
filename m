Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:49399 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbXFVRBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 13:01:07 -0400
Message-ID: <467C003C.30803@warmcat.com>
Date: Fri, 22 Jun 2007 18:00:44 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	<20070621143558.68fc8e4a@griffin.suse.cz>	<1182429920.21939.1.camel@johannes.berg>	<20070621151441.500d62d5@griffin.suse.cz>	<20070622154545.29eeebdb@griffin.suse.cz>	<467BDCB1.1010604@warmcat.com> <20070622173940.30280046@griffin.suse.cz>
In-Reply-To: <20070622173940.30280046@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:

> On Fri, 22 Jun 2007 15:29:05 +0100, Andy Green wrote:
>> But for any nontrivial use, you need to capture RX and not blindly
>> inject, and so you have a monitor mode interface up anyway.
> 
> No, why? You can encapsulate received management frames (only the ones
> that need to go to user space or so) in the same way and send them
> through the regular interface.

For my usage case I want specific unencrypted packets filtered by a MAC
address that isn't part of the authenticated network, so the reception
action needs to be effectively promisc a la Monitor mode, not just
"received management frames".  But I guess it can be done with IFF_PROMISC.

By piping everything down "wlan0" normal packets will not have the
radiotap metadata on their capture, but presumably the abnormal packets
can have it via a special ethernet frame type + radiotap header.  Maybe
it doesn't matter for any actual use.

-Andy
