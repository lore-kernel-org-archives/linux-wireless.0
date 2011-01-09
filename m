Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1AIUdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 15:33:55 -0500
Received: by fxm20 with SMTP id 20so18292694fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 12:33:54 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
Date: Sun, 9 Jan 2011 21:33:37 +0100
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
References: <20110104234745.25309.72030.stgit@fate.lan> <201101062246.38932.chunkeey@googlemail.com> <20110109174656.86162gssuhct8hog@hayate.sektori.org>
In-Reply-To: <20110109174656.86162gssuhct8hog@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101092133.37610.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 January 2011 16:46:56 Jussi Kivilinna wrote:
> Quoting Christian Lamparter <chunkeey@googlemail.com>:
> > On Wednesday 05 January 2011 00:49:10 Jussi Kivilinna wrote:
> >> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c  
> >> b/drivers/net/wireless/zd1211rw/zd_mac.c
> >> index aace010..a3c7e8f 100644
> >> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> >> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> >> @@ -958,16 +958,46 @@ static int zd_op_config(struct ieee80211_hw  
> >> *hw, u32 changed)
> >>  	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
> >>  }
> >>
> >> +static void zd_beacon_done(struct zd_mac *mac)
> >> +{
> >
> > this is an interesting one...
> >
> > Since zd_beacon_done also uploads the next beacon so long in advance,
> > there could be an equally long race between the outdated state of the
> > next beacon's DTIM broadcast traffic indicator (802.11-2007 7.3.2.6)
> > which -in your case- was uploaded almost a beacon interval ago and
> > the xmit of ieee80211_get_buffered_bc *now*.
> >
> > The dtim bc/mc bit might be not set, when a mc/bc arrived after the
> > beacon was uploaded, but before the "beacon done event" from the
> > hardware. So, dozing stations don't expect the broadcast traffic
> > and of course, they might miss it completely.
> >
> > It's probably better to fix this in mac80211 (see the attached hack).
> 
> Ok, should I add this to my patchset?
well, difficult to say. As far as I can say, it should be correct for "your
case". But, on the other hand: what about solutions that can't buffer
mc/bc frames (and needs to call ieee80211_get_buffered_bc), however the
firmware is clever enough to maintain a beacon internally (so they
won't call ieee80211_beacon_get and only relies on set_tim)?

Sure, it's just a unlikely corner case... In fact, I didn't check if
that's even possible, but it does sound reasonable to some extend. 

> > In fact, you could just as well drop "[09/17] zd1211rw: implement
> > seq_num for IEEE80211_TX_CTL_ASSIGN_SEQ"... unless of course, I'm
> > an idiot and there is a really clever way around these issues.
> 
> Oh well, I should have checked this more closely before doing that  
> patch. HW is assigning seq-numbers already and that patch is not needed.

heh, p54's fw can assign sequence numbers as well, but there's a txdesc flag
to control the counter, so the firmware does not mess with the sequence control
of QoS-Data frames. I hope zd1211* has one too.

Regards,
	Chr
