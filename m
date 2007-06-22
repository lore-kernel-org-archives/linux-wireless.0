Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:48278 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758040AbXFVO3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 10:29:23 -0400
Message-ID: <467BDCB1.1010604@warmcat.com>
Date: Fri, 22 Jun 2007 15:29:05 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	<20070621143558.68fc8e4a@griffin.suse.cz>	<1182429920.21939.1.camel@johannes.berg>	<20070621151441.500d62d5@griffin.suse.cz> <20070622154545.29eeebdb@griffin.suse.cz>
In-Reply-To: <20070622154545.29eeebdb@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Thu, 21 Jun 2007 15:14:41 +0200, Jiri Benc wrote:
>> That's true. Still, couldn't we find a better solution?
> 
> I have a new idea. Maybe it will turn out to have fatal design or
> implementation problems, but anyway.
> 
> First, I thought how all of this would be easier if we have a native
> 802.11 (virtual) interfaces and don't translate from Ethernet. Then I
> realized it wouldn't help us much - we want to specify some parameters
> for each frame, so we'd have to use some encapsulation anyway to allow
> radiotap headers. Hm, wait a moment - why we cannot use the
> encapsulation we currently have? That means, why can't we encapsulate
> raw 802.11 frames in Ethernet frames?
> 
> Before you reject the whole idea, please think a moment about it.

I don't reject it at all, it's fine for injection.

But for any nontrivial use, you need to capture RX and not blindly
inject, and so you have a monitor mode interface up anyway.  The
footprint in the political networking space is less if it just goes in
as a monitor mode TX action.

-Andy
