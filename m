Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36732 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751578AbXKOKMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 05:12:21 -0500
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Will Dyson <will.dyson@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Florian Lohoff <flo@rfc822.org>,
	Marcus Better <marcus@better.se>,
	linux-wireless@vger.kernel.org,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <8e6f94720711141840g7346f4eak577477d735b72f39@mail.gmail.com>
References: <20071111102315.GC10486@paradigm.rfc822.org>
	 <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com>
	 <20071113192330.GA19601@paradigm.rfc822.org> <fhedc4$5l9$1@ger.gmane.org>
	 <20071114153347.GA3512@paradigm.rfc822.org>
	 <8e6f94720711141057w463d55c4r2be74d0aa8d78918@mail.gmail.com>
	 <20071114211354.GD6226@tuxdriver.com>
	 <8e6f94720711141840g7346f4eak577477d735b72f39@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 11:11:58 +0100
Message-Id: <1195121518.28648.46.camel@localhost> (sfid-20071115_101224_047628_6461A2E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-11-14 at 21:40 -0500, Will Dyson wrote:
> On Nov 14, 2007 4:13 PM, John W. Linville <linville@tuxdriver.com> wrote:
> 
> > > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=d37cabfb5f60a3bb56585a74fd3f140ba2960fe0
> > >
> > > The patch is in the wireless-2.6/everything tree, but not Linus's tree.
> >
> > Most of the patch seems like a no-op, except this bit:
> >
> >         if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
> >                 __set_bit(ENTRY_TXD_BURST, &desc.flags);
> > -               if (is_rts_frame(frame_control))
> > +               if (is_rts_frame(frame_control)) {
> >                         __set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
> > +                       __set_bit(ENTRY_TXD_ACK, &desc.flags);
> > +               } else
> > +                       __clear_bit(ENTRY_TXD_ACK, &desc.flags);
> >                 if (control->rts_cts_rate)
> >                         tx_rate = control->rts_cts_rate;
> >         }
> >
> > Is this correct?  I'm not sure about the actual meaning of TXD_W0_ACK
> > (which keys off ENTRY_TXD_ACK)...
> 
> Adding Mattias (the patch's author), Ivo and the rt2x00 list to the CC.
> 
> TXD_W0_ACK seems to mean that the firmware should expect an ack for
> the packet represented by that tx descriptor. That is how it is being
> used (and looking at the vendor driver confirms it).

Correct.

> 
> The rest of the patch moves the logic for setting this bit (or not) to
> a central location, so that the interesting bit is not repeated in
> each chip-specific driver file.

Not quite. Thing is that we only have one ieee80211_tx_control
structure, which we received from mac80211 for the original frame. Some
parameters, e.g. the transmission queue are valid for both the
rts/cts-to-self frame and the data frame. So we use the same control
structure when setting up both frames. Before the patch, the driver
incorrectly assumed that the IEEE80211_TXCTL_NO_ACK flag determines
whether to expect an ACK, which is simply incorrect for rts/cts frames.

> 
> Although now that I really look at the patch, I wonder why the
> IEEE80211_TXCTL_NO_ACK bit is not already set correctly for RTS and
> CTS-to-self frames. It doesn't look like any other driver does this
> kind of calculation, so perhaps the problem solved by this patch is
> also present elsewhere?
> 

That depends on how the driver/hardware generates rts/cts-to-self
frames. One way to clean this up would be to change mac80211 to generate
a new tx control structure in ieee80211_ctstoself_get and
ieee80211_rts_get for the rts/cts-to-self frame. But IMHO that's just
adding overhead.

Mattias

