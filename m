Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39271 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYJNWGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 18:06:18 -0400
Message-ID: <48F517C6.1040303@openwrt.org> (sfid-20081015_000623_624294_848437B3)
Date: Wed, 15 Oct 2008 00:05:58 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Martel <benm@symmetric.co.nz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211 fix regression introduced by "mac80211: free
 up 2 bytes in skb->cb"
References: <48F416A3.3060205@blacksapphire.com>	 <1223990364.10113.28.camel@johannes.berg>  <48F515D7.9030002@openwrt.org> <1224021602.3027.17.camel@johannes.berg>
In-Reply-To: <1224021602.3027.17.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2008-10-14 at 23:57 +0200, Felix Fietkau wrote:
>> The hw_key pointer is used (and obviously NULL) after skb->cb is
>> memset to 0. This patch grabs the iv_len before the memset call.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
> 
> Subject should be "rt2x00: " instead of "mac80211 ", but
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
Yeah, sorry about that. 
John: please fix that up when merging ;)

- Felix
