Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:57466 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab2IEIEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 04:04:22 -0400
Date: Wed, 5 Sep 2012 11:03:36 +0300
From: Jouni Malinen <j@w1.fi>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
Message-ID: <20120905080336.GA4747@w1.fi> (sfid-20120905_100433_535928_9FB5DFEA)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
 <20120904102204.GA2541@w1.fi>
 <CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
 <CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
 <1346758521.3737.28.camel@jlt4.sipsolutions.net>
 <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
 <20120905071653.GB3629@w1.fi>
 <CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 03:31:08PM +0800, Yeoh Chun-Yeow wrote:
> I am based on the authsae source code for secured mesh setup which can
> be found at:
> https://github.com/cozybit/authsae/blob/master/linux/meshd-nl80211.c

It looks like this particular implementation is hardcoded to use MFP..

> > Any pointers to the specific standard clause(s) that say that?
> I have not gone through the standard on this.

.. while the standard does not actually have such requirement as far as
I can tell. I have nothing against adding support for MFP in general,
but just wanted to understand where this assumed requirement came from.

So yes, if you want to enable support for MFP, you cannot do it unless
the driver is able to handle both CCMP and BIP protection for robust
management frames. In case of ath5k, I would assume there are two
options:
- only enable MFP if software encryption is used for all frames (i.e.,
  no hwaccel even for data frames)
- implement workaround to re-encrypt(incorrectly) received robust
  unicast management frames if hwaccel for CCMP was configured for the
  transmitting STA (this is to undo the incorrect decryption done by the
  hardware) and then pass the encrypted frame to mac80211 for software
  decryption; with this option, you could advertise MFP support even
  with CCMP hwaccel enabled

-- 
Jouni Malinen                                            PGP id EFC895FA
