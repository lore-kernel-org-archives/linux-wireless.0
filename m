Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaQuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:50:32 -0500
Message-ID: <1359651044.8415.96.camel@jlt4.sipsolutions.net> (sfid-20130131_175047_367218_C87B1FBF)
Subject: Re: [PATCHv7 0/3] Add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 31 Jan 2013 17:50:44 +0100
In-Reply-To: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 13:21 +0100, Simon Wunderlich wrote:

> Right now, channels at least on my machine have the NO IBSS and PASSIVE SCAN
> flags set, which prevents reg_can_beacon from returning true, even if we do
> have radar support. This is due to my reg database setting these flags for
> country code 00, and this is still kept when changing the country code to
> something else (DE in my case). How should we proceed with this? Shouldn't
> these flags be removed when selecting a country code?

I don't think any country sets that, you may be running into that whole
"regdb intersect" thing ... FWIW the flags are set for 00 since for
world roaming we don't know if we're in a country that even allows
transmission on that AP.

> The channel states are now implemented in cfg80211. Shall we inform userspace
> about channel changes? If yes, how should we do that? We could add channel states
> to the channel list, and give "channel list changed" events to userspace as it
> happens now, or define a new kind of event ("channel-available-again-event").
> Suggestions welcome. :)

You already inform it of the changes by the radar event, but it would
probably also be good to export the state as part of the channel list
that you get with things like "iw list".

johannes

