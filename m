Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:55352 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764272AbYCSUKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 16:10:45 -0400
Date: Wed, 19 Mar 2008 22:10:04 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
Message-ID: <20080319201004.GC5308@jm.kir.nu> (sfid-20080319_201130_188680_339221DC)
References: <1205781593.16475.20.camel@johannes.berg> <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com> <1205784255.16475.33.camel@johannes.berg> <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com> <20080318080435.GA5308@jm.kir.nu> <1205831880.16475.43.camel@johannes.berg> <20080318102344.GG5308@jm.kir.nu> <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com> <20080319173922.GB5308@jm.kir.nu> <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 08:41:22PM +0200, Tomas Winkler wrote:

> So how do you call WEP key that is used for both unicast and broadcast
> i.e the old WEP key.

The IEEE 802.11 name for this would be "default key". IEEE 802.1X (or
well, RFC 3580 is the authoritative specification for this) calls it
"broadcast (default key)". Please note that this is not really a key
that is always used both for unicast and broadcast. If there is a
key-mapping key (unicast/individual) for the matching
transmitter/receiver addresses, that key will be used instead. The "old
WEP key" way of using only statically configured default keys just does
not set the key-mapping key and because of that, the default key ends up
being used for all frames (or well, one of the possible four default
keys).

> What mac80211 currently does it's attach it to broadcast address. If
> there is a group key re keying you don't know whether also unicast key
> have to be overridden or not since you don't know if this is a
> 'static/global; key or  dynamic group key

I haven't looked at what the current implementation does, but as far as
WEXT and SIOCSIWENCODEEXT is concerned, IW_ENCODE_EXT_GROUP_KEY flag
should be used to select which key is being configured. There is no
difference between "static/global" and "dynamic group" keys. The only
difference is between default and key-mapping (individual) keys.

Sure, the terminology here can be quite confusing, but as far as I can
tell, that IW_ENCODE_EXT_GROUP_KEY flag is all that is needed to
distinguish which key is being configured and configuring a single key
should not automatically change another one (even if the key index is
same which could, at least in theory, happen with key index 0 that can
be used both with default and key-mapping keys).

-- 
Jouni Malinen                                            PGP id EFC895FA
