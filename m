Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:37200 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0ELBwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 21:52:19 -0400
Received: by pxi5 with SMTP id 5so2613055pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 18:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005121039.32882.br1@einfach.org>
References: <20100511083121.28289.96180.stgit@tt-desk> <20100511083900.28289.43864.stgit@tt-desk>
	<AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
	<201005121039.32882.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 11 May 2010 18:51:59 -0700
Message-ID: <AANLkTimOcEyrhJ6JZPM3JtZitPZxV5zD1yqVzjArtzxf@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 6:39 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Wednesday 12 May 2010 03:14:30 Luis R. Rodriguez wrote:
>> Subject should be for cfg80211, not mac80211. In fact can you submit
>> the mac80211 stuff in a separate secondary patch? Some more comments
>> below.
>
> ok.
>
>> I think we should call this TX / RX chainmask given that with 802.11n
>> hardware this is what this is called.
>
> from the following discussion, i'll stick with antenna...
>
>> > The antenna configuration is defined as a bitmap of allowed antennas.
>> > This bitmap is 8 bit at the moment, each bit representing one antenna.
>>
>> If you use chainmask for this instead of 'antenna configuration' the
>> wording would be something like:
>>
>> The chainmask is defined as a bitmap of chain configurations used for
>> TX/RX. The bitmap allows for configuring up to up to 4 chains for both TX
>> and RX, 4 bits for each TX chain, 4 bits for each RX chain.
>
> actually we have 8 bit for TX and 8 bit for RX.
>
>> > If multiple
>> > antennas are selected, the driver may use diversity for receive and
>> > transmit.
>>
>> For 802.11n this is called "selection diversity" but typically just
>> referred to as "diversity", for legacy this is called "antenna
>> diversity". It may be good to elaborate how selection diversity or
>> antenna diversity might be enabled, ie, will this be another command,
>> or what. I think for legacy another command makes sense, and it may be
>> possible for us to use the same command for enabling selection
>> diversity, I am not sure if we can fine tune the diversity algorithm
>> at this time, I will have to review this and get back to you.
>
> my idea was that if multiple antennas are selected in the bitmap this means
> that "antenna diversity" will be enabled. for RX this is clear. for TX this is
> a bit ambigous: it could mean "send on both antennas", which i believe is
> impossible on legacy hardware, so it means "let HW diversity choose TX
> antenna". for 802.11n - i think the TX part is different, because multiple TX
> chains will mean "send on multiple antennas". but otherwise can't we think of
> it as some form of advanced antenna diversity?

802.11n has chains but is also allows two antennas to be assigned to
one chain and the hardware then would do something equivalent to
legacy as with antenna diversity for one chain but it is called
"selection diversity" for 802.11n.

> of course there are more possibillities of antenna configurations which cannot
> be configured with this api - like the "multiple sector antennas + RTS/CTS on
> omni" configuration of ath5k, but i don't think these are very common.

Yeah I was reminded of these setups today as well, but as you note it
is rare and the defaults should typically work on those.

> the most important use case, imho, is to limit the antennas to one fixed
> antenna, if we know only one antenna is connected. this might well apply for
> 802.11n too, no?

802.11n does allow for 1 stream devices with a 1x1 TX/RX chain setup
but the hardware *can* have two antennas like your typical legacy
device with diversity enabled. This is the case for AR9285, for
example.

 Luis
