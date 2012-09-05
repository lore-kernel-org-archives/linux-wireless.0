Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:57456 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab2IEHMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 03:12:01 -0400
Date: Wed, 5 Sep 2012 10:11:22 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
Message-ID: <20120905071122.GA3629@w1.fi> (sfid-20120905_091206_498957_9D498B2A)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
 <20120904102204.GA2541@w1.fi>
 <CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
 <CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
 <1346758521.3737.28.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346758521.3737.28.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2012 at 01:35:21PM +0200, Johannes Berg wrote:
> I would guess that hardware *decryption* is faulty, maybe only one
> action frame needs to be correct and so if one of them is nohwcrypt=1 it
> still works?

Yes, I was assuming that receiving robust unicast management frames
would fail with ath5k. This is exactly the reason why I adding
IEEE80211_HW_MFP_CAPABLE conditionally in ath9k only for the hardware
revisions that support the new CCMP rules.

It should be possible to work around this if someone really cares, but
that require the driver to re-encrypt the incorrectly decrypted frame
(i.e., using the pre-802.11w rules on CCMP exactly in the way the
hardware did it) and then pass that end result for masc80211 to decrypt
it correctly. I considered doing that for a while, but did not find
enough justification to work with that.

-- 
Jouni Malinen                                            PGP id EFC895FA
