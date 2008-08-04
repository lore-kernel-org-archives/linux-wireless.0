Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42477 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYHDWa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 18:30:59 -0400
Date: Mon, 4 Aug 2008 19:30:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080804223052.GG24927@khazad-dum.debian.net> (sfid-20080805_003103_480045_E6999123)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1217864565.3139.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217864565.3139.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 04 Aug 2008, Dan Williams wrote:
> On Sat, 2008-08-02 at 16:27 -0300, Henrique de Moraes Holschuh wrote:
> > On Sat, 02 Aug 2008, Johannes Berg wrote:
> > > On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
> > > > Currently, rfkill would stand in the way of properly supporting wireless
> > > > devices that are capable of waking the system up from sleep or hibernation
> > > > when they receive a special wireless message.
> > > > 
> > > > Since rfkill attempts to soft-block any transmitters during class suspend,
> > > 
> > > why does it interfere with suspend anyway?
> > 
> > The class makes sure that all transmitters are blocked on suspend.  You'd
> > have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
> > conserve power.
> 
> rfkill shouldn't be touching stuff during suspend.

rfkill shouldn't *need* to touch stuff during suspend.  But for that to be
true, all drivers using rfkill need to properly suspend in the first place.

And that's more than just drivers/net/wireless.

> In the OLPC libertas case, the radio may remain _ON_ during suspend,
> because the OLPC machines are expected to suspend/resume many times per
> second, and the radio must continue to participate in the mesh during
> that time.  The only case where the radio gets blocked is when the user
> requests it or when regulations require it.

Yes.  And the fact that rfkill stood in the way of doing that is a bug.
However, even my first try of a patch would already allow libertas to
declare it doesn't want rfkill to bother it on suspend.

It is very clear some drivers don't want rfkill to block radios on suspend.
Really.  So far, libertas and iwl* are on my list of "don't want" or "don't
need".  From what I can see, PCI-based rt2xxx is also "don't need".  And I
can assume everything in drivers/misc is "don't need" without too much risk
of being wrong.

But the OPPOSITE is not clear at all to me.  I don't know whether the other
users of rfkill need a radio block on suspend or not.  Unless someone can
look over *all* in-tree users of linux/rfkill.h and state that none of them
need it because all of them DO shutdown their devices on suspend, I will
have to ask the maintainers of every single one about it before I ask a
patch to be merged.  I already looked, and I don't know enough to have a
definitive answer by myself.

> Suspend != block, and tying suspend and rfkill together really is a
> policy decision.  Thus, I don't agree that rfkill should block radios on
> suspend.

If some drivers out there are relying on it to, we need to know that before
we remove it completely.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
