Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:37887 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXKBKCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 06:02:21 -0400
Message-ID: <472AF59A.4020302@openwrt.org> (sfid-20071102_100224_065608_44E92D44)
Date: Fri, 02 Nov 2007 11:02:02 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>	 <1193832985.12078.14.camel@johannes.berg>	 <8e8340660710311736k555474f3ifd7490b5f0f7b623@mail.gmail.com>	 (sfid-20071101_003628_984847_78170051) <1193997288.12078.39.camel@johannes.berg>
In-Reply-To: <1193997288.12078.39.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> Agreed about filename length. I would prefer not to make mesh
>> networking configurable, as STA, IBSS, etc modes aren't configurable
>> either. I prefer to avoid polluting the data path with ifdefs.
> 
> Ok, I'm not sure, it just seems like quite a bit of code especially when
> all the other features will be added, something people like the OpenWRT
> folks might not like. nbd?
Depends on how big it is. I think merging it without ifdefs is fine for
now. If it gets too big, we can make some ifdef patches later.

>> Mesh APs are not supported yet, but we plan to support them through a
>> different interface type (e.g.  ..._TYPE_MAP) or extending the AP
>> interface type. Mesh STAs and APs will share all the mesh-specific
>> stuff (peer link discovery, path discovery, etc) but they have little
>> in common in the data path, so I do not think it makes sense to use
>> the same interface type for both. Maybe I should rename ..IF_TYPE_MESH
>> to ..IF_TYPE_MESH_STA?
> 
> Probably. Come to think of it, how much mesh networking is actually done
> by the mesh AP? I guess we need to support this in hostapd rather than
> the kernel?
If we're forced to use hostapd for starting the mesh networking, then that
would probably be a bigger source of bloat than the mesh code itself :)

- Felix
