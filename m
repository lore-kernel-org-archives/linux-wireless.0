Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41881 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbZIAOiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 10:38:09 -0400
Date: Tue, 1 Sep 2009 17:37:22 +0300
From: Jouni Malinen <j@w1.fi>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, proski@gnu.org,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: Re: Ath5k and proprietary extensions
Message-ID: <20090901143722.GA22557@jm.kir.nu>
References: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 29, 2009 at 07:51:29AM +0300, Nick Kossifidis wrote:
> Since we started the discussion about ath5k and proprietary features i
> started a new thread to continue.

> a) X.R.: eXtended Range is a set of proprietary rates and some extra
> techniques (various hw tweaks etc) to enable long distance, low
> bandwidth links. This feature was never really supported on MadWiFi
> (some code for sta mode is there but i don't think anyone used it) and
> it's ugly (sends beacons on both 1Mbit and 250Kbit, has some sort of
> polling mechanism etc). We should remove XR stuff since we all agree
> that we won't support it + even if we want we don't have anything to
> work with anyway, 5/10MHz channels should be enough for long distance
> links. Just leave XR rate code definitions there for reference (in
> case we get any of these from the card -normally we shouldn't but it's
> good to know all hw rate code values).

Agreed, I see no place for this in neither ath5k (or ath9k for that
matter) nor mac80211 (please note that it does require changes that
would fit into the mac80211/hostapd areas in our design and neither of
those are going to accept these changes even if the driver were.. ;-).

> b) OFDM-only g settings for AR5211: AR5211 chips have support for
> draft-g (eg. no dynamic CCK/OFDM modulation, only OFDM). I don't know
> if we want to support it or not, removing the settings will save us
> some space and since it's a draft g implementation i don't think there
> are many compatible APs out there. Is there any possibility to support
> draft-g on mac80211/cfg80211 ? If not we can just drop it else it's
> just some extra data, no big deal.

I don't see why we would want to support this at this point. I don't
really think there is much use for this and I see no point in making
mac80211/cfg80211 more complex for such a corner case.

> c) Half/quarter rate channels (10/5MHz width) and turbo mode (double
> rate - 40MHz width): Hw can transmit with different channel width
> allowing us to operate on half, quarter or double rate (also called
> turbo mode). Half and quarter rates are straight forward (just
> re-program pll/clock and tweak various phy/rf settings) and most chips
> support it, turbo mode on the other hand has some extra parameters and
> is supported only on super ag enabled (non-lite) chips
> (5212,2414,5414,5424 etc). First we want to use it only on "middle"
> channels so that we don't get outside band boundaries when changing
> channel width, so we have to limit the available channels we can use
> (check out super ag white paper), second we have the opportunity to
> support both 20MHz and 40MHz at the same time by using "dynamic turbo"
> feature on hw so if we are an AP we can deal both with turbo-enabled
> clients and normal clients. I was thinking if we are going to have an
> API to set channel width to 10 and 5 MHz for half and quarter rate
> channels, we can use the same API to set channel width to 40MHz width
> for double rate channels on cards that support it and when we are on
> AP mode use the "dynamic turbo" stuff. We don't even have to call it
> turbo mode, it's just double rate + some tweaks.

I consider this c item to be three different cases:
(1) standard-defined 5/10 MHz width channels
(2) proprietary channel binding (static 40 MHz turbo)
(3) proprietary dynamic 20/40 MHz turbo

As far as (1) is concerned, I see some value in supporting it. However,
at this point I would probably not enable those channels by default
(i.e., I do not want to see them making scan take any more time than it
already does).

(3) is on a not-going-to-happen list as far as I'm concerned since it
requires changes both in mac80211 and hostapd, too, and good luck trying
to get this in there.. ;-)

(2) is somewhat of a corner case. It would probably be possible to
somehow support it as a driver specific hack. While I would personally
prefer not to see this, I would probably be fine with it being there as
long as these channels are not enabled by default (the same comment as
for 5/10 MHz channels and scan).

> d) Fast frames: Hw can tx/rx jumbo frames of 3kbytes+ so fast frame
> aggregation is a way to make use of that hw feature by sending 2
> frames together (for more infos check out super ag white paper). On
> FreeBSD fast frames aggregation is implemented on the protocol stack
> (net80211) so that any hw that can tx/rx such jumbo frames can use
> fast frame aggregation
> (http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/net80211/ieee80211_superg.c?rev=1.7;content-type=text%2Fx-cvsweb-markup;sortby=rev)
> but it still maintains atheros's format to be compatible with
> commercial Atheros APs. We have talked about this and it seems no one
> is willing to support fast frames aggregation so on ath5k we only use
> single tx/rx descriptors and there is no related code for handling
> multiple descriptors.

I don't see how this would get added to mac80211. If someone really
wants to spend time on this type of feature, I would suggest adding
support for A-MSDU aggregation (the TX side of it) into mac80211 and
making it usable with non-HT cases, too. That should result in something
quite similar to fast frames, but with a format that is actually defined
by IEEE. Sure, this would not be compatible with legacy Super A/G APs,
but could be used between two mac80211-based devices.

> e) Compression: Hw can do on-chip compression/decompression using
> standard Lempel Ziv algorithm per tx queue, MadWiFi implements this
> and uses a vendor IE to let others know that it supports this feature
> (same IE is used for all capabilities, fast frames, XR etc). I guess
> this can also work for other cards by doing compression/decompression
> on software since it's a standard algorithm (and i think kernel
> already has code for it) but it's way outside cfg80211/mac80211's
> scope. I think we can just use NL80211_CMD_TESTMODE to enable/disable
> this on all data queues and skip the IE stuff (user will have to
> enable it on both sides to make it work). There is no related code on
> ath5k for compression/decompression at the moment.

Even compression needs some negotiation support (i.e., mac80211/hostapd
are actually in scope) and there are some ugly corner cases showing up
issues with it.. I don't see much point in supporting this either.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
