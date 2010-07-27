Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0Gs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 02:48:29 -0400
Subject: Re: ath9k: /proc/net/wireless always shows status of 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C4E1C0B.9040608@candelatech.com>
References: <4C4DE6B5.5080307@candelatech.com>
	 <4C4E0580.3060404@candelatech.com>
	 <AANLkTi=qJXCxtMZcEm3VQT1s7ioJsdhj2kJzkgGSf3ND@mail.gmail.com>
	 <4C4E1784.3030702@candelatech.com>
	 <AANLkTimnZ9pSfVLsEPgiDPyc=_eUnyLj89RHCC6rsaX8@mail.gmail.com>
	 <4C4E1C0B.9040608@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 08:48:23 +0200
Message-ID: <1280213303.19098.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 16:36 -0700, Ben Greear wrote:

> > You can use nl28011 and register for netlink multicast messages which
> > broadcast device state changes like the ones you mentioned. These come
> > in on iw via event.c, see print_event() and see the case statements
> > for NL80211_CMD_ASSOCIATE, NL80211_CMD_DEAUTHENTICATE,
> > NL80211_CMD_DISASSOCIATE, etc, you even get reason codes parsed for
> > you too.
> 
> Ahhh, that is the kind of thing I'm looking for.  I'll check out that
> code in detail tomorrow.

Keep in mind though that not all drivers can give you the difference
between AUTH and ASSOC, and will ONLY report "CONNECTED" events. This is
those drivers that do roaming and all that in firmware rather than in
mac80211. Therefore, generally speaking, you cannot get the states
you're after.

johannes

