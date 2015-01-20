Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56448 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbATErb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 23:47:31 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21693.56960.568269.420520@gargle.gargle.HOWL> (sfid-20150120_054734_680798_29D508E3)
Date: Tue, 20 Jan 2015 10:20:08 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>
Subject: Re: [RFC 2/2] mac80211: support RX rate statistics
In-Reply-To: <1421661324.1965.16.camel@sipsolutions.net>
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
	<1421401708-8123-2-git-send-email-johannes@sipsolutions.net>
	<21689.49345.803049.938915@gargle.gargle.HOWL>
	<1421661324.1965.16.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Not right now - and there's practically no space left in the rate u16 to
> store it.
> 
> Eyal also commented that perhaps not just antennas but also
> STBC/LDPC/beamforming should be tracked.
> 
> We can achieve this by increasing the size of the rate field to u32, but
> then we also have far more combinations so probably need to increase the
> size of the buffer from 36 entries to more since otherwise we just end
> up sending the data out to userspace too frequently? Antennas for
> example could change frequently for single stream rates.
> 
> This capability right now is mostly intended for Android Lollipop's
> statistics requirements, where the rate only matters.

Ok.

> If others want to use it for more, I'm certainly not averse to adding
> it, but it'd also mean adding more userspace API (where it might be a
> bit strange to add "antennas" to the "rate" since that doesn't impact
> the actual rate?)

Having a well-defined API to export statistics seems useful, but
I guess that can be added later.

Sujith
