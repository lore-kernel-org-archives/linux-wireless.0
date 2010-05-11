Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51769 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0EKSOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:14:51 -0400
Received: by pva18 with SMTP id 18so147014pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 11:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100511083900.28289.43864.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk> <20100511083900.28289.43864.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 11 May 2010 11:14:30 -0700
Message-ID: <AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 1:39 AM, Bruno Randolf <br1@einfach.org> wrote:

Subject should be for cfg80211, not mac80211. In fact can you submit
the mac80211 stuff in a separate secondary patch? Some more comments
below.

> Allow setting TX and RX antenna configuration via nl80211/cfg80211.

I think we should call this TX / RX chainmask given that with 802.11n
hardware this is what this is called.

> The antenna configuration is defined as a bitmap of allowed antennas. This
> bitmap is 8 bit at the moment, each bit representing one antenna.

If you use chainmask for this instead of 'antenna configuration' the
wording would be something like:

The chainmask is defined as a bitmap of chain configurations used for TX/RX. The
bitmap allows for configuring up to up to 4 chains for both TX and RX,
4 bits for each TX chain, 4 bits for each RX chain.

> If multiple
> antennas are selected, the driver may use diversity for receive and transmit.

For 802.11n this is called "selection diversity" but typically just
referred to as "diversity", for legacy this is called "antenna
diversity". It may be good to elaborate how selection diversity or
antenna diversity might be enabled, ie, will this be another command,
or what. I think for legacy another command makes sense, and it may be
possible for us to use the same command for enabling selection
diversity, I am not sure if we can fine tune the diversity algorithm
at this time, I will have to review this and get back to you.

> This allows for a simple, yet flexible configuration interface for antennas,
> while drivers may reject configurations they cannot support.

:) !

  Luis
