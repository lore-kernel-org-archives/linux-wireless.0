Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYHDPlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 11:41:19 -0400
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080802192704.GB24253@khazad-dum.debian.net>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 11:42:45 -0400
Message-Id: <1217864565.3139.17.camel@localhost.localdomain> (sfid-20080804_174122_252106_93B87F3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-08-02 at 16:27 -0300, Henrique de Moraes Holschuh wrote:
> Hi Johannes!
> 
> On Sat, 02 Aug 2008, Johannes Berg wrote:
> 
> > On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
> > > Currently, rfkill would stand in the way of properly supporting wireless
> > > devices that are capable of waking the system up from sleep or hibernation
> > > when they receive a special wireless message.
> > > 
> > > Since rfkill attempts to soft-block any transmitters during class suspend,
> > 
> > why does it interfere with suspend anyway?
> 
> The class makes sure that all transmitters are blocked on suspend.  You'd
> have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
> conserve power.

rfkill shouldn't be touching stuff during suspend.

In the OLPC libertas case, the radio may remain _ON_ during suspend,
because the OLPC machines are expected to suspend/resume many times per
second, and the radio must continue to participate in the mesh during
that time.  The only case where the radio gets blocked is when the user
requests it or when regulations require it.

Suspend != block, and tying suspend and rfkill together really is a
policy decision.  Thus, I don't agree that rfkill should block radios on
suspend.

Dan

