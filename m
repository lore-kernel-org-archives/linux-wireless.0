Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41448 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1G3U3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 16:29:42 -0400
Received: by fxh19 with SMTP id 19so3312142fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 13:29:40 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
Date: Sat, 30 Jul 2011 22:32:27 +0200
Cc: Jouni Malinen <j@w1.fi>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <20110730182810.GA2743@jm.kir.nu> <4E346396.9030707@01019freenet.de>
In-Reply-To: <4E346396.9030707@01019freenet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107302232.28582.chunkeey@googlemail.com> (sfid-20110730_222947_357737_C8A93A43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 30 July 2011 22:03:34 Andreas Hartmann wrote:
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
> couldn't see any improvement. The first PTK-rekeying didn't work as
> usual. Or should it be applied to STA?

might be a shot into the dark. But who's assigning a proper frame sequence
to each eapol? Hostapd certainly can't because it doesn't know what's the
current sequence at the moment... and mac80211 won't assign one because
the frame is injected by a monitor interface. So when the receiver gets the
EAPOL it might drops it because the empty sequence might be not in the
BA window anymore. Does this sound reasonable, or did I miss something?

Regards,
	Chr  
