Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38882 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbYFWNEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 09:04:08 -0400
Date: Mon, 23 Jun 2008 10:04:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Subject: Re: Rfkill on ifconfig up.
Message-ID: <20080623130401.GA3416@khazad-dum.debian.net> (sfid-20080623_150414_580797_2BA6507E)
References: <1ba2fa240806221609p1b0cd641g2304d0812b61ecb3@mail.gmail.com> <20080623050514.GA9926@khazad-dum.debian.net> <1ba2fa240806230302x11c0ed0dn6210c8fe745fdf6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240806230302x11c0ed0dn6210c8fe745fdf6d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Jun 2008, Tomas Winkler wrote:
> On Mon, Jun 23, 2008 at 8:05 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Mon, 23 Jun 2008, Tomas Winkler wrote:
> >> Little RF KILL design question from user space perspective.
> >> What should be desired return value of ifconfig up when HW rfkill is
> >> on (radio is off).
> >
> > This isn't really about rfkill, its design doesn't call for any particular
> > behaviour.  IMHO we should go with the principle of least suprise, and also
> > more convenience for the user.
> 
> No, this is about ifconfig up
> 
> > In the end, it will depend on the capabilities of the hardware, I suppose.
> > Assuming the hardware CAN bring its interface up without going bonkers
> > because the transmitter is not transmitting anything, that's exactly what it
> > should do IMO.
> >
> > What it must never do is to unblock the transmiter because of a ifconfig up
> > :-)
> >
> >> rfkill on (radio off)
> >> ifconfig wlan0 up
> >> rfkill off (radio on)
> >>
> >> Will it be ok for these sequence to require additional ifconfig up to
> >> make driver to work, providing the first ifconfig up failed?
> >
> > It would be nice if it didn't fail the first ifconfig, and therefore needed
> > nothing special to work other than a rfkill unblock.
> 
> Everything is doable just 'would be nice'  is not good reason enough :)

Here's another one, then.  Most current WiFi cards do the "would be
nice" above, so we can just mandate it as the preferred way to go about
it.

Really, this IS about the hardware and driver capabilities.  rfkill is
not supposed to bring interfaces down, if that's another way to look at
your question.  But if it has to, it *is* entitled to do it.  In fact,
if it has to in order to shutdown a transmitter, it is entitled to
hotunplug and cut the power feed to the wireless device.

WiFi usually doesn't down interfaces.  At least on ThinkPads, Bluetooth
and WWAN do hotunplugging (which not only downs the interface, it
deletes the interface altogether), and I hear that is a common approach
for Bluetooth.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
