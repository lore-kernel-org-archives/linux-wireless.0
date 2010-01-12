Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44241 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0ALDDO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 22:03:14 -0500
Message-ID: <4B4BE661.5050506@openwrt.org>
Date: Tue, 12 Jan 2010 04:02:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211: fix queue selection for data frames on monitor interfaces
References: <4B4ABB54.7030600@openwrt.org> <43e72e891001110803x6ecd3dc4m267dd809d640a522@mail.gmail.com>
In-Reply-To: <43e72e891001110803x6ecd3dc4m267dd809d640a522@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-11 5:03 PM, Luis R. Rodriguez wrote:
> On Sun, Jan 10, 2010 at 9:47 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> When ieee80211_monitor_select_queue encounters data frames, it selects
>> the WMM AC based on skb->priority and assumes that skb->priority
>> contains a valid 802.1d tag. However this assumption is incorrect, since
>> ieee80211_select_queue has not been called at this point.
>> If skb->priority > 7, an array overrun occurs, which could lead to
>> invalid values, resulting in crashes in the tx path.
>> Fix this by setting skb->priority based on the 802.11 header for QoS
>> frames and using the default AC for all non-QoS frames.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Its unclear whether or not this is a stable fix. It fixes a crash but
> does this depend on a patch added recently which is not in stable yet?
It depends on the pile of tx queue fixes, and the crash doesn't exist
without those.

- Felix
