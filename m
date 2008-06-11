Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYFKMHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 08:07:11 -0400
Message-ID: <90792e191e13c5c2955689833ca3118a.squirrel@secure.sipsolutions.net>
In-Reply-To: <20080611065719.GB7377@jm.kir.nu>
References: <20080610105058.GA6961@jm.kir.nu>
    <1213096575.3668.6.camel@johannes.berg>
    <20080610123007.GB1571@tuxdriver.com>
    <1213103469.3668.13.camel@johannes.berg>
    <20080610152418.GD13267@tuxdriver.com>
    <20080610183722.GA7377@jm.kir.nu>
    <1213124444.3668.48.camel@johannes.berg>
    <20080611065719.GB7377@jm.kir.nu>
Date: Wed, 11 Jun 2008 14:07:01 +0200 (CEST)
Subject: Re: [PATCH RFC] mac80211_hwsim
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Jouni Malinen" <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> That sounds better. net/wireless.h was bit confusing on this part since
> it has the "filled by the core" notice only for
> IEEE80211_RATE_MANDATORY_* flags, not for IEEE80211_RATE_ERP_G. Looks
> like this should be added to the ERP flag, too.

good point.

> OK, I'll remove it. With the current bands this seems to be fine, but
> how would that work with 10 MHz and 5 MHz channels? I haven't verified,
> but I would assume they could use same center frequency with 20 MHz
> channels..

Yeah... that isn't really supported yet.

> Hmm.. Aren't the channel and rate structures being modified by
> mac80211/wireless code? Sharing the same global data area for all radios
> might not be desired if there will be different "hw" capabilities as far
> as supported channels/rates/bands are concerned. In addition, the static
> data structures were marked 'const' which would at least be somewhat
> confusing if the data ends up changing.

They're only modified all the same, so it's fine to share unless you have
different capabilities. Yeah, you should removed the const then.

johannes

