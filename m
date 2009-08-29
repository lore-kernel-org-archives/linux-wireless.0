Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34421 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZH2HTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 03:19:00 -0400
Message-ID: <4A98D65B.9060103@free.fr>
Date: Sat, 29 Aug 2009 09:18:51 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com
Subject: Re: [ath5k-devel] Ath5k and proprietary extensions
References: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
In-Reply-To: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Nick Kossifidis a écrit :
> Since we started the discussion about ath5k and proprietary
> features i started a new thread to continue.
>
> So this is what we have...
>
> a) X.R.: eXtended Range is a set of proprietary rates and some
> extra techniques (various hw tweaks etc) to enable long distance,
> low bandwidth links. This feature was never really supported on
> MadWiFi (some code for sta mode is there but i don't think anyone
> used it) and it's ugly (sends beacons on both 1Mbit and 250Kbit,
> has some sort of polling mechanism etc). We should remove XR stuff
> since we all agree that we won't support it + even if we want we
> don't have anything to work with anyway, 5/10MHz channels should be
> enough for long distance links. Just leave XR rate code definitions
> there for reference (in case we get any of these from the card
> -normally we shouldn't but it's good to know all hw rate code
> values).
I have been working on XR (in madwifi) for some time with no result. I
would appreciate to be able to test it in ath5k.
>
> b) OFDM-only g settings for AR5211: AR5211 chips have support for
> draft-g (eg. no dynamic CCK/OFDM modulation, only OFDM). I don't
> know if we want to support it or not, removing the settings will
> save us some space and since it's a draft g implementation i don't
> think there are many compatible APs out there. Is there any
> possibility to support draft-g on mac80211/cfg80211 ? If not we can
> just drop it else it's just some extra data, no big deal.
>
> c) Half/quarter rate channels (10/5MHz width) and turbo mode
> (double rate - 40MHz width): Hw can transmit with different channel
> width allowing us to operate on half, quarter or double rate (also
> called turbo mode). Half and quarter rates are straight forward
> (just re-program pll/clock and tweak various phy/rf settings) and
> most chips support it, turbo mode on the other hand has some extra
> parameters and is supported only on super ag enabled (non-lite)
> chips (5212,2414,5414,5424 etc). First we want to use it only on
> "middle" channels so that we don't get outside band boundaries when
> changing channel width, so we have to limit the available channels
> we can use (check out super ag white paper), second we have the
> opportunity to support both 20MHz and 40MHz at the same time by
> using "dynamic turbo" feature on hw so if we are an AP we can deal
> both with turbo-enabled clients and normal clients. I was thinking
> if we are going to have an API to set channel width to 10 and 5 MHz
> for half and quarter rate channels, we can use the same API to set
> channel width to 40MHz width for double rate channels on cards that
> support it and when we are on AP mode use the "dynamic turbo"
> stuff. We don't even have to call it turbo mode, it's just double
> rate + some tweaks.
>
> Most code is there for half/quarter and (static) turbo operation,
> we just have to deal with pll programming, clock settings etc.
> Question is how do we use it, NL80211_CMD_TESTMODE is an option i
> guess and in case no one else thinks that we could use a channel
> width API (or extend what we have) for setting 5/10/40MHz width
> through cfg80211, we can just stick to NL80211_CMD_TESTMODE.
5/10 MHz channels are defined in 802.11-2007, so it must be part of
mac80211 and supported by ath5k if the HW support it. For 40 MHz, as
far as the mac80211 API is concerned, we could treat it like HT40,
even it's clearly a proprietary extension.
>
> d) Fast frames: Hw can tx/rx jumbo frames of 3kbytes+ so fast frame
>  aggregation is a way to make use of that hw feature by sending 2
> frames together (for more infos check out super ag white paper). On
>  FreeBSD fast frames aggregation is implemented on the protocol
> stack (net80211) so that any hw that can tx/rx such jumbo frames
> can use fast frame aggregation
> (http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/net80211/ieee80211_superg.c?rev=1.7;content-type=text%2Fx-cvsweb-markup;sortby=rev)
>  but it still maintains atheros's format to be compatible with
> commercial Atheros APs. We have talked about this and it seems no
> one is willing to support fast frames aggregation so on ath5k we
> only use single tx/rx descriptors and there is no related code for
> handling multiple descriptors.
>
> e) Compression: Hw can do on-chip compression/decompression using
> standard Lempel Ziv algorithm per tx queue, MadWiFi implements this
>  and uses a vendor IE to let others know that it supports this
> feature (same IE is used for all capabilities, fast frames, XR
> etc). I guess this can also work for other cards by doing
> compression/decompression on software since it's a standard
> algorithm (and i think kernel already has code for it) but it's way
> outside cfg80211/mac80211's scope. I think we can just use
> NL80211_CMD_TESTMODE to enable/disable this on all data queues and
> skip the IE stuff (user will have to enable it on both sides to
> make it work). There is no related code on ath5k for
> compression/decompression at the moment.
>
>
>
My whole feeling is that an operating system, be it GNU/Linux,
Windows(tm), *bsd or whatever is here to bring all the HW features to
the user. So if users are interested by any of the above features, be
it proprietary or not, we need to find a way to allow their
implementation in ath5k. Some of those implementations would need
mac80211 changes, so we need to decide if we want a proper mac80211
support for all those features (proprietary or not) or if mac80211
only wants to support standard features (which seems fair) and find
another way to support proprietary features.

Regards,
Benoit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqY1lYACgkQOR6EySwP7oJTZACfUO8m4OXls+5yVLMbnn/oax0E
vTcAoO9NJ5Wdtr3gNEALF0sPk4RxNj7c
=5Srl
-----END PGP SIGNATURE-----

