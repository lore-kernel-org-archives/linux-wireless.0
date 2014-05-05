Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38921 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaEEJUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 05:20:35 -0400
Message-ID: <536757DA.1010205@openwrt.org> (sfid-20140505_112039_190828_53E08479)
Date: Mon, 05 May 2014 11:20:26 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.15] cfg80211: allow restricting supported dfs regions
References: <1399150555-36041-1-git-send-email-nbd@openwrt.org> <1399275222.22235.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399275222.22235.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-05 09:33, Johannes Berg wrote:
> On Sat, 2014-05-03 at 22:55 +0200, Felix Fietkau wrote:
>> At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
>> radar patterns.
> 
> It seems this should also be advertised to the userspace.
Right.

>> Add a bitmap in the interface combinations, indicating which DFS regions
>> are supported by the detector.
> 
> Does that make sense? It seems unlikely to me that it would be interface
> combination specific?
Having it there made about as much sense to me as having the supportede
channel width there :)
Got any better suggestions?

> I think it's already questionable to put this in after -rc4, in
> particular with the userspace advertising part. Can we do anything
> else? 
I mostly pushed it for 3.15, because right now you can already enable
DFS and it will bring it up on a FCC regdomain and it will appear to be
working (but probably just not recognize any radars).

However, now that I look at the description of the options that you have
to enable, it should be clear enough that this is not guaranteed to be
functional yet, so I guess it can wait for 3.16.

- Felix
