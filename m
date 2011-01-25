Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:49873 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab1AYJlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 04:41:46 -0500
Date: Tue, 25 Jan 2011 11:41:30 +0200
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
Message-ID: <20110125094130.GA25962@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <20110124094433.GA5487@jm.kir.nu>
 <AANLkTimYZN5438DOGNOE9Ltny5M-qg-K1ShFKToRMyuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimYZN5438DOGNOE9Ltny5M-qg-K1ShFKToRMyuw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 11:16:43PM +0200, Arik Nemtsov wrote:
> The SSID-as-attr not used for the probe-resp template. It is used by
> FW to filter out which probe-reqs should be responded to when
> operating with a hidden SSID.

OK, that would be useful to mention in nl80211.h comments and
cfg80211.h, too, I'd guess.

> The wl12xx FW updates the timestamp and DA. I mentioned in the
> documentation of ieee80211_proberesp_get (and various other parts)
> that the DA should be set manually and that this should be used as a
> template (which also implies timestamp should be set). If some part is
> unclear can you point out a specific patch?

DA should be pretty obvious. Timestamp is something that I hope is clear
for whoever is implementing a driver, but it could be mentioned
somewhere.

> For WPS (without p2p), it appears the probe-resp doesn't depend on the
> probe-req (in hostapd code).

This is the case for WPS 1.0, but the protocol update in WSC 2.0 does
introduce a dependency.

> Perhaps we can start with these AP-mode only patches and expand the
> functionality when it is needed for p2p?

I'm fine with them if there is a capability flag that allows user space
to know that the driver does not use user space -based Probe Request
processing. With that, hostapd/wpa_supplicant can disable functionality
like multi-SSID support, WPS 2.0, P2P until we get more complete
capability information on what devices that process Probe Request frames
internally can do.

> Note that the current patch doesn't remove existing functionality - a
> driver/FW operating in p2p mode can simply choose not to use the
> template and just pass probe-requests up.

Until now, I've been assuming that nl80211-based interface means that
Probe Request frames are handled in user space. Since this set of
patches makes it very obvious that that will not be the case, I do want
to be able to figure that out in user space easily. All it really takes
is to add a capability flag indicating whether user space -based Probe
Request processing is used or not.

-- 
Jouni Malinen                                            PGP id EFC895FA
