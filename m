Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60578 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbbASJz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 04:55:26 -0500
Message-ID: <1421661324.1965.16.camel@sipsolutions.net> (sfid-20150119_105550_049569_80ABB568)
Subject: Re: [RFC 2/2] mac80211: support RX rate statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>
Date: Mon, 19 Jan 2015 10:55:24 +0100
In-Reply-To: <21689.49345.803049.938915@gargle.gargle.HOWL>
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
	 <1421401708-8123-2-git-send-email-johannes@sipsolutions.net>
	 <21689.49345.803049.938915@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-01-17 at 07:24 +0530, Sujith Manoharan wrote:

> We were doing simple RX statistics collection inside ath9k
> (CONFIG_ATH9K_STATION_STATISTICS), which can be removed once this goes
> in. Is there any way a driver can pass custom data, like per-frame
> antenna details ?

Not right now - and there's practically no space left in the rate u16 to
store it.

Eyal also commented that perhaps not just antennas but also
STBC/LDPC/beamforming should be tracked.

We can achieve this by increasing the size of the rate field to u32, but
then we also have far more combinations so probably need to increase the
size of the buffer from 36 entries to more since otherwise we just end
up sending the data out to userspace too frequently? Antennas for
example could change frequently for single stream rates.

This capability right now is mostly intended for Android Lollipop's
statistics requirements, where the rate only matters.

If others want to use it for more, I'm certainly not averse to adding
it, but it'd also mean adding more userspace API (where it might be a
bit strange to add "antennas" to the "rate" since that doesn't impact
the actual rate?)

johannes

