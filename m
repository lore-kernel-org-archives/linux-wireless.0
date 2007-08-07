Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:48182 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbXHGJrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:47:24 -0400
Message-ID: <46B83FA9.20507@warmcat.com>
Date: Tue, 07 Aug 2007 10:47:21 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor interfaces for injection
References: <20070802223857.19090.70108.stgit@localhost> <1186428789.4067.12.camel@johannes.berg>
In-Reply-To: <1186428789.4067.12.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Thu, 2007-08-02 at 23:38 +0100, warmcat wrote:
> 
>> This patch adds a new attribute to ieee80211_tx_control's flags field,
>> IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO, which is set for injected
>> packets.  The code to add a new radiotap header and echo the packet
>> down monitor mode interfaces is now conditional on this attribute not
>> being set.
> 
> Regardless of whether my approach (just posted) will be accepted, this
> patch cannot go in: it stops injected packets from showing up on all
> monitor interfaces but the one they were injected into. If my
> IFF_NO_MIRROR approach is rejected then we'll have to make this a bit
> more elaborate by storing the injection device ifindex in the info
> instead of just a flag.

Yep, fair enough.

-Andy
