Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33135 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0HBJR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 05:17:27 -0400
Message-ID: <4C568D23.2000203@openwrt.org>
Date: Mon, 02 Aug 2010 11:17:23 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org> 	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com> 	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com> 	<4C5688F7.1070200@openwrt.org> <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com>
In-Reply-To: <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-08-02 11:10 AM, Luis R. Rodriguez wrote:
> On Mon, Aug 2, 2010 at 1:59 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-08-02 7:37 AM, Luis R. Rodriguez wrote:
>>> I'm not, the point I was trying to make is that solving this for
>>> legacy and that for 802.11n this needs more thought and work.
>> I need this for 802.11n as well, and I believe the API is good enough
>> for that.
> 
> Sure.
> 
>>>> as long as the API is flexible
>>>> enough i think it can be added later as 802.11n devices are going to accept
>>>> antenna configuration.
>>>
>>> If you want really flexible stuff without addressing serious
>>> considerations before introducing a new kernel API then use debugfs.
>> I'd like to see this in nl80211. Is there any specific concern left that
>> I haven't addressed already? If so, please point me at it...
> 
> The code that deals with not accepting changes unless we're not
> associated, and that also caches the old real hw config vs the
> modified one.
This is not really an API issue, this is more of an implementation
aspect. I think it's up to the driver to reject changes that it cannot
handle at the moment.
For legacy, changing settings is fine in any state (even with assoc).
For 802.11n, changes that affect the chainmask should be rejected while
the interface is up. That way we don't run into weird cached config vs
hw config issues, and also keep a sane state for the HT capabilities.

- Felix
