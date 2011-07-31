Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39712 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1GaJ3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 05:29:03 -0400
Received: by fxh19 with SMTP id 19so3588961fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 02:29:01 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
Date: Sun, 31 Jul 2011 11:26:51 +0200
Message-ID: <1512659.Djma8rlNlO@helmutmobil.site> (sfid-20110731_112949_743930_5BF606DC)
In-Reply-To: <20110730182810.GA2743@jm.kir.nu>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com> <20110730182810.GA2743@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 30. Juli 2011, 21:28:10 schrieb Jouni Malinen:
> On Fri, Jul 29, 2011 at 07:22:17PM +0200, Helmut Schaa wrote:
> > Since EAPOL frames are normal data frames they are treated by the rate
> > control algorithm as such. Thus it can happen that the rate control
> > algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
> > example) for the 4-way handshake and under low signal conditions the
> > handshake may time out.
> > 
> > To fix this issue always treat EAPOL frames the same as management
> > frames and send them with the lowest available rate.
> 
> I don't think that this should be applied for the reasons given (and
> alternative mechanisms proposed) in the discussion.

Agreed, I'll do some more tests with Felix suggestion to prevent minstrel_ht
from rate sampling on EAPOL frames.

John, please drop this one.

Thanks,
Helmut
