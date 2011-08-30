Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1H3GWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:22:37 -0400
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <gregkh@suse.de>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
In-Reply-To: <20110830042802.GA15320@suse.de> (sfid-20110830_063540_059569_2C362D1D)
References: <20110707002034.GA17885@broadcom.com>
	 <20110824222801.GA5280@broadcom.com>
	 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	 <20110827143513.GN3775@shale.localdomain> <20110827145003.GA9405@suse.de>
	 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
	 <20110827152144.GA10126@suse.de> <20110830014257.GI15771@broadcom.com>
	 <20110830042802.GA15320@suse.de> (sfid-20110830_063540_059569_2C362D1D)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 08:22:29 +0200
Message-ID: <1314685349.4011.17.camel@jlt3.sipsolutions.net> (sfid-20110830_082240_758452_AD904FA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 21:28 -0700, Greg KH wrote:

> > We understand the level of effort that it's taken for b43 to get as far as it
> > has, and was implemented without access to proprietary information, and it has
> > been impossible to support advanced chip features. We appreciate the difficulty
> > of your task and respect your accomplishments tremendously! 
> 
> Then why not try to help out here?
> 
> All other wireless companies have realized that this is the best way
> forward over time.  Remember, b43 was here first, you need to play nice
> with those developers.

Well, truth be told, b43 was there first for older chipsets, and I
played a major role in it existing back then. For the latest generation
chips that are supported by the staging driver, that driver was there
earlier and reverse engineering was ongoing even though code existed and
could have been used. That code may not have been as clean, but the
algorithms etc. are probably more tweaked & tuned to the chips.

> You really need to work with the b43 developers here.

I definitely agree with this. However, given the architectural
differences in the device/ucode combination, I don't think support can
be added to b43 easily.

> Why can't you just do the small changes needed to the b43 driver to add
> the missing functionality based on the fact that you know how the
> hardware works?

I don't think it would be small changes. Let me explain.

What we can hope for is sharing of PHY/Radio code between b43 and
brcmsmac. I'm sure this can be done in some way -- the PHY/Radio code
should be taken from Broadcom's driver most likely, the code in b43
isn't maintained by anyone with access to Si documentation & testing.
Some form of abstraction layer exists in both drivers, but they're
obviously not compatible at this point -- I believe this could be
solved.

However, on a higher level (MAC level) I believe that the drivers are
quite different. There are a bunch of MAC features like multi-MAC
support and probably soon P2P that b43 cannot support across the board
due to the version of the uCode it is tied to, especially on older
devices where such uCode never existed. New features, like P2P, will
likely only be supported by new uCode on new devices -- I don't see
Broadcom backporting & testing their new uCode, in most cases it
probably won't even be possible due to device restrictions (*).

As a result, I believe that attempting to share the MAC level code
between b43 and brcmsmac will lead to a maintenance disaster, b43 would
essentially be fragmented into lots of little code paths that depend on
the uCode API in use. I don't think that's worth it -- we split
b43/b43legacy for precisely that reason before.

I'm not saying we should merge brcmsmac as is, but I do think attempting
to push everything into b43 is bound to lead to lots of issues that we
all don't want to see. Code sharing should be possible on some level,
but at other levels it is fairly likely that code sharing would just
lead to bigger problems down the road.

johannes

(*) keep in mind that older devices only support 4k ucode instructions
and very little memory!

