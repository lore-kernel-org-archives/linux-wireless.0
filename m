Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49613 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0HBJKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 05:10:41 -0400
Received: by iwn7 with SMTP id 7so3982077iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 02:10:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5688F7.1070200@openwrt.org>
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org>
	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
	<4C5688F7.1070200@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Aug 2010 02:10:21 -0700
Message-ID: <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 2, 2010 at 1:59 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-08-02 7:37 AM, Luis R. Rodriguez wrote:
>> I'm not, the point I was trying to make is that solving this for
>> legacy and that for 802.11n this needs more thought and work.
> I need this for 802.11n as well, and I believe the API is good enough
> for that.

Sure.

>>> as long as the API is flexible
>>> enough i think it can be added later as 802.11n devices are going to accept
>>> antenna configuration.
>>
>> If you want really flexible stuff without addressing serious
>> considerations before introducing a new kernel API then use debugfs.
> I'd like to see this in nl80211. Is there any specific concern left that
> I haven't addressed already? If so, please point me at it...

The code that deals with not accepting changes unless we're not
associated, and that also caches the old real hw config vs the
modified one.

  Luis
