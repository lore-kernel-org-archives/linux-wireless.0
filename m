Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60749 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbZFJT2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 15:28:40 -0400
Date: Wed, 10 Jun 2009 22:28:25 +0300
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	=?utf-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
Message-ID: <20090610192825.GA23353@jm.kir.nu>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com> <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com> <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com> <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com> <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com> <1244619027.18481.55.camel@johannes.local> <20090610113158.GA2798@tuxdriver.com> <87ws7jsxqt.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ws7jsxqt.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 10:19:06PM +0300, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
> > I'm still a bit "on the fence" regarding this requirement for AP mode.
> > I think there is a reasonable body of users that would prefer a
> > not-quite-right AP mode over no AP mode at all.

> I understand your point, but the problems from this are so severe that
> it would just create a headache for everyone, both for the users and for
> us. Think of what kind of problems randomly loosing broadcast and
> multicast frames would create: random disconnects, not finding hosts
> from the local network etc. How would a normal user realise that this is
> because of broken power save support in the AP?
> 
> Also deliberately breaking 802.11 specification sounds very wrong to me.
> We can, and should, aim higher than that.

Well, breaking specifications may have to be done in some cases ;-), but
this particular feature is not really such a case. However, I do
understand the desire to be able to use some kind of AP mode even if it
is known to be broken for some cases.

I don't like the idea of making hostapd warn the user somehow, but could
probably live with something like AP mode being implemented in the
driver, but disabled by default. Only if the user were to use a module
parameter, say, broken_ap_mode=1, would the support for AP mode be
registered. As long as distros do not start adding this parameter by
default, this would force the user to become at least somehow informed
about the issues and make a conscious choice in enabling the mode.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
