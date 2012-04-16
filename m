Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44166 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2DPHGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 03:06:37 -0400
Received: by wibhj6 with SMTP id hj6so8351241wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 00:06:36 -0700 (PDT)
Date: Mon, 16 Apr 2012 09:06:09 +0200
From: Anisse Astier <anisse@astier.eu>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Subject: Re: RT5390 not working with rt2800pci
Message-ID: <20120416090609.6b257455@destiny.ordissimo> (sfid-20120416_090645_456911_D4CA7479)
In-Reply-To: <CAGRGNgVJjVC5ZWRXsrjraT17ivT=HAnnZnhczPfwOw2Za_vatA@mail.gmail.com>
References: <20120413142352.3b927516@destiny.ordissimo>
	<CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com>
	<CAGRGNgVdQgMoBNpJcPJuc608+exeVvpvrGRvvmEggf=GTmOkbg@mail.gmail.com>
	<CALUN=qK65XgtG5B-Da9o6oGaSF38TsN6NuNaK5=9-nQ+TMUvtg@mail.gmail.com>
	<CAGRGNgVJjVC5ZWRXsrjraT17ivT=HAnnZnhczPfwOw2Za_vatA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 16 Apr 2012 16:22:36 +1000, Julian Calaby <julian.calaby@gmail.com> wrote :

> Hi Anisse,
> 
> On Mon, Apr 16, 2012 at 15:57, Anisse Astier <anisse@astier.eu> wrote:
> > On Mon, Apr 16, 2012 at 1:38 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> >> Hi Anisse,
> >>
> >> On Mon, Apr 16, 2012 at 03:33, Anisse Astier <anisse@astier.eu> wrote:
> >>> On Fri, Apr 13, 2012 at 2:23 PM, Anisse Astier <anisse@astier.eu> wrote:
> >>> Why some cards work and others don't is a mystery.
> >>
> >> Not really, old cards generally work, current cards that have been out
> >> for a little while generally work, and bleeding edge,
> >> just-released-yesterday cards tend not to.
> > What I meant is that in the set of RT5390RL cards, some work, some
> > don't, consistently, and I cannot find any difference between them.
> 
> Sorry, I misinterpreted what you meant.
> 
> So, to clarify, am I right in saying that you have:
>  - "RT5390R" cards, PCI revision 0502 which all work
It's marked "RT5390L" (not R) and has revision 0502. And in the code it's
referred as REV_RT5390F (yes it's different).

>  - "RT5390RL" cards, PCI revision 1502 which work
Correct.
>  - "RT5390RL" cards, PCI revision 1502 which don't work with the
> symptoms described above.
Correct, except revisions are *not* visible in PCI revision. These are only
visible in driver output when debug is enabled, with this printf:
        INFO(rt2x00dev,
             "Chipset detected - rt: %04x, rf: %04x, rev: %04x.\n",
             rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);

Which gets it by reading register MAC_CSR0_REVISION .

> 
> Ok, so let's look at this a bit closer: the "iw info" diff you
> provided before makes me think that there is some form of regulatory
> setting difference between the working and non-working cards. I would
> guess that this would be visible in the dmesg output, could you boot
> with a working card, save the dmesg, then boot with a non-working
> card, save the dmesg, diff them and reply with that diff? I'm guessing
> that there would be some lines in there about CRDA or regulatory which
> would be different.
I don't think this is related, but I'll try to provide the two dmesg,
with today's wireless-next.
This might be polluted by the fact that the "working" card succeded in
connecting(on channel 6), which then changed the regulatory domain. I'll
try to get unpolluted results.

> 
> Also, what channel is your AP on and what region of the world are you
> in? (I'm guessing Europe from your email address, but which country
> specifically)
I'm in France, but using another wireless card, I can scan APs on
channels 1,2,3,6,8,10,11,13.


Regards,

Anisse
