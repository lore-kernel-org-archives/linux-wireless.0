Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:10122 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXKOTby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 14:31:54 -0500
Received: by fk-out-0910.google.com with SMTP id z23so635708fkz
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 11:31:52 -0800 (PST)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Date: Thu, 15 Nov 2007 20:58:39 +0100
Cc: Will Dyson <will.dyson@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Florian Lohoff <flo@rfc822.org>,
	Marcus Better <marcus@better.se>,
	linux-wireless@vger.kernel.org,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>
References: <20071111102315.GC10486@paradigm.rfc822.org> <8e6f94720711141840g7346f4eak577477d735b72f39@mail.gmail.com> <1195121518.28648.46.camel@localhost>
In-Reply-To: <1195121518.28648.46.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711152058.40520.IvDoorn@gmail.com> (sfid-20071115_193200_321716_8577C3FF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 November 2007, Mattias Nissler wrote:
> 
> On Wed, 2007-11-14 at 21:40 -0500, Will Dyson wrote:
> > On Nov 14, 2007 4:13 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > 
> > > > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=d37cabfb5f60a3bb56585a74fd3f140ba2960fe0
> > > >
> > > > The patch is in the wireless-2.6/everything tree, but not Linus's tree.
> > >
> > > Most of the patch seems like a no-op, except this bit:
> > >
> > >         if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
> > >                 __set_bit(ENTRY_TXD_BURST, &desc.flags);
> > > -               if (is_rts_frame(frame_control))
> > > +               if (is_rts_frame(frame_control)) {
> > >                         __set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
> > > +                       __set_bit(ENTRY_TXD_ACK, &desc.flags);
> > > +               } else
> > > +                       __clear_bit(ENTRY_TXD_ACK, &desc.flags);
> > >                 if (control->rts_cts_rate)
> > >                         tx_rate = control->rts_cts_rate;
> > >         }
> > >
> > > Is this correct?  I'm not sure about the actual meaning of TXD_W0_ACK
> > > (which keys off ENTRY_TXD_ACK)...
> > 
> > Adding Mattias (the patch's author), Ivo and the rt2x00 list to the CC.
> > 
> > TXD_W0_ACK seems to mean that the firmware should expect an ack for
> > the packet represented by that tx descriptor. That is how it is being
> > used (and looking at the vendor driver confirms it).
> 
> Correct.
> 
> > 
> > The rest of the patch moves the logic for setting this bit (or not) to
> > a central location, so that the interesting bit is not repeated in
> > each chip-specific driver file.
> 
> Not quite. Thing is that we only have one ieee80211_tx_control
> structure, which we received from mac80211 for the original frame. Some
> parameters, e.g. the transmission queue are valid for both the
> rts/cts-to-self frame and the data frame. So we use the same control
> structure when setting up both frames. Before the patch, the driver
> incorrectly assumed that the IEEE80211_TXCTL_NO_ACK flag determines
> whether to expect an ACK, which is simply incorrect for rts/cts frames.

Perhaps we should test if clearing the ENTRY_TXD_ACK unconditionally
for cts and rts frames would help. (patch located at the bottom).
In fact I wonder if clearing that flag would fix the rt61pci to run txdone
for all frames (opposed to skipping an occasional entry).

> > Although now that I really look at the patch, I wonder why the
> > IEEE80211_TXCTL_NO_ACK bit is not already set correctly for RTS and
> > CTS-to-self frames. It doesn't look like any other driver does this
> > kind of calculation, so perhaps the problem solved by this patch is
> > also present elsewhere?
> > 
> 
> That depends on how the driver/hardware generates rts/cts-to-self
> frames. One way to clean this up would be to change mac80211 to generate
> a new tx control structure in ieee80211_ctstoself_get and
> ieee80211_rts_get for the rts/cts-to-self frame. But IMHO that's just
> adding overhead.

Agreed, we should use the same tx_control structure, and just check what flags
apply to rts and cts frames.

Ivo

---

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3ab1fb9..2e3e822 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -639,11 +639,11 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &desc.flags);
-		if (is_rts_frame(frame_control)) {
+		__clear_bit(ENTRY_TXD_ACK, &desc.flags);
+
+		if (is_rts_frame(frame_control))
 			__set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
-			__set_bit(ENTRY_TXD_ACK, &desc.flags);
-		} else
-			__clear_bit(ENTRY_TXD_ACK, &desc.flags);
+
 		if (control->rts_cts_rate)
 			tx_rate = control->rts_cts_rate;
 	}


