Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35975 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967484AbaLLO2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 09:28:48 -0500
Message-ID: <548AFB9C.1060408@openwrt.org> (sfid-20141212_152852_707708_4AB14ED2)
Date: Fri, 12 Dec 2014 15:28:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add an intermediate software queue implementation
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org>	 <1418390516.2470.46.camel@sipsolutions.net> <548AF047.9080404@openwrt.org> <1418392866.2470.49.camel@sipsolutions.net>
In-Reply-To: <1418392866.2470.49.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-12-12 15:01, Johannes Berg wrote:
> On Fri, 2014-12-12 at 14:40 +0100, Felix Fietkau wrote:
> 
>> > Then
>> > again what even sets vif->txq? Shouldn't those be per-AC? Do you really
>> > want to mix 'normal' and txq-TX?
>> Are we even using multiple ACs for packets that don't belong to a
>> particular sta? I thought normal mcast data frames only use non-QoS
>> frames. And yes, I'm currently mixing normal and txq-TX to prioritize
>> ctl/mgmt frames over other less important traffic.
> 
> Management (and maybe control) frames can have different priorities as
> well, this is only used for something with TDLS now I think though.
With my implementation, those would go through the normal tx codepath,
bypassing the software tx queues. Can you think of anything else that
would need per-AC vif queues?

- Felix
