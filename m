Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50933 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab0EKS02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:26:28 -0400
Received: by pxi5 with SMTP id 5so2397805pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 11:26:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273601969.20312.23.camel@jlt3.sipsolutions.net>
References: <20100511083121.28289.96180.stgit@tt-desk> <20100511083900.28289.43864.stgit@tt-desk>
	<AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
	<1273601969.20312.23.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 11 May 2010 11:26:07 -0700
Message-ID: <AANLkTikqxiIjmQw2e8ucu8whKVRETunF92dPfWu2391s@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
To: Johannes Berg <johannes@sipsolutions.net>, ic.felix@gmail.com
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-05-11 at 11:14 -0700, Luis R. Rodriguez wrote:
>
>> > Allow setting TX and RX antenna configuration via nl80211/cfg80211.
>>
>> I think we should call this TX / RX chainmask given that with 802.11n
>> hardware this is what this is called.
>
> Well, but even with 11n hw you might be able to select _antennas_ rather
> than chains. I'm convinced we'll need to differentiate that very
> closely, and 11g hw has only antenna, not chain, selection.

Heh you're right, you might have for example 3 antennas but only two
RX chains, for example. I still think it would be good for us to
figure out a way to bring these two notions together on a standard API
for both 11n and legacy, if possible.

  Luis
