Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55465 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZH2Ev3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 00:51:29 -0400
Received: by ewy2 with SMTP id 2so2667967ewy.17
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 21:51:29 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 29 Aug 2009 07:51:29 +0300
Message-ID: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
Subject: Ath5k and proprietary extensions
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, proski@gnu.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we started the discussion about ath5k and proprietary features i
started a new thread to continue.

So this is what we have...

a) X.R.: eXtended Range is a set of proprietary rates and some extra
techniques (various hw tweaks etc) to enable long distance, low
bandwidth links. This feature was never really supported on MadWiFi
(some code for sta mode is there but i don't think anyone used it) and
it's ugly (sends beacons on both 1Mbit and 250Kbit, has some sort of
polling mechanism etc). We should remove XR stuff since we all agree
that we won't support it + even if we want we don't have anything to
work with anyway, 5/10MHz channels should be enough for long distance
links. Just leave XR rate code definitions there for reference (in
case we get any of these from the card -normally we shouldn't but it's
good to know all hw rate code values).

b) OFDM-only g settings for AR5211: AR5211 chips have support for
draft-g (eg. no dynamic CCK/OFDM modulation, only OFDM). I don't know
if we want to support it or not, removing the settings will save us
some space and since it's a draft g implementation i don't think there
are many compatible APs out there. Is there any possibility to support
draft-g on mac80211/cfg80211 ? If not we can just drop it else it's
just some extra data, no big deal.

c) Half/quarter rate channels (10/5MHz width) and turbo mode (double
rate - 40MHz width): Hw can transmit with different channel width
allowing us to operate on half, quarter or double rate (also called
turbo mode). Half and quarter rates are straight forward (just
re-program pll/clock and tweak various phy/rf settings) and most chips
support it, turbo mode on the other hand has some extra parameters and
is supported only on super ag enabled (non-lite) chips
(5212,2414,5414,5424 etc). First we want to use it only on "middle"
channels so that we don't get outside band boundaries when changing
channel width, so we have to limit the available channels we can use
(check out super ag white paper), second we have the opportunity to
support both 20MHz and 40MHz at the same time by using "dynamic turbo"
feature on hw so if we are an AP we can deal both with turbo-enabled
clients and normal clients. I was thinking if we are going to have an
API to set channel width to 10 and 5 MHz for half and quarter rate
channels, we can use the same API to set channel width to 40MHz width
for double rate channels on cards that support it and when we are on
AP mode use the "dynamic turbo" stuff. We don't even have to call it
turbo mode, it's just double rate + some tweaks.

Most code is there for half/quarter and (static) turbo operation, we
just have to deal with pll programming, clock settings etc. Question
is how do we use it, NL80211_CMD_TESTMODE is an option i guess and in
case no one else thinks that we could use a channel width API (or
extend what we have) for setting 5/10/40MHz width through cfg80211, we
can just stick to NL80211_CMD_TESTMODE.

d) Fast frames: Hw can tx/rx jumbo frames of 3kbytes+ so fast frame
aggregation is a way to make use of that hw feature by sending 2
frames together (for more infos check out super ag white paper). On
FreeBSD fast frames aggregation is implemented on the protocol stack
(net80211) so that any hw that can tx/rx such jumbo frames can use
fast frame aggregation
(http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/net80211/ieee80211_superg.c?rev=1.7;content-type=text%2Fx-cvsweb-markup;sortby=rev)
but it still maintains atheros's format to be compatible with
commercial Atheros APs. We have talked about this and it seems no one
is willing to support fast frames aggregation so on ath5k we only use
single tx/rx descriptors and there is no related code for handling
multiple descriptors.

e) Compression: Hw can do on-chip compression/decompression using
standard Lempel Ziv algorithm per tx queue, MadWiFi implements this
and uses a vendor IE to let others know that it supports this feature
(same IE is used for all capabilities, fast frames, XR etc). I guess
this can also work for other cards by doing compression/decompression
on software since it's a standard algorithm (and i think kernel
already has code for it) but it's way outside cfg80211/mac80211's
scope. I think we can just use NL80211_CMD_TESTMODE to enable/disable
this on all data queues and skip the IE stuff (user will have to
enable it on both sides to make it work). There is no related code on
ath5k for compression/decompression at the moment.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
