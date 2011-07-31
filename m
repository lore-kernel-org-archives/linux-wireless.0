Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38855 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1GaJcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 05:32:46 -0400
Received: by fxh19 with SMTP id 19so3590602fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 02:32:44 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
Date: Sun, 31 Jul 2011 11:30:31 +0200
Message-ID: <3126816.IYdQCPrujI@helmutmobil.site> (sfid-20110731_113250_987671_82043334)
In-Reply-To: <4E346396.9030707@01019freenet.de>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <20110730182810.GA2743@jm.kir.nu> <4E346396.9030707@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 30. Juli 2011, 22:03:34 schrieb Andreas Hartmann:
> Jouni Malinen schrieb:
> > On Fri, Jul 29, 2011 at 07:22:17PM +0200, Helmut Schaa wrote:
> >> Since EAPOL frames are normal data frames they are treated by the
> >> rate control algorithm as such. Thus it can happen that the rate
> >> control algorithm chooses an inappropriate rate (minstrel_ht uses
> >> MCS rates for example) for the 4-way handshake and under low signal
> >> conditions the handshake may time out.
> >> 
> >> To fix this issue always treat EAPOL frames the same as management 
> >> frames and send them with the lowest available rate.
> > 
> > I don't think that this should be applied for the reasons given (and 
> > alternative mechanisms proposed) in the discussion.
> 
> I tested it with AP (rt2860) (with STA rt3572sta) under load and
> couldn't see any improvement.

Because the patch never intended to tackle the problem you've reported :)

However, I've got some reports of clients timing out during the 4-way
handshake if they are "far" away from the AP while auth and assoc work
just fine.

Helmut
