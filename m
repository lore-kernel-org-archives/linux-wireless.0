Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57399 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaBWUm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 15:42:56 -0500
Received: by mail-oa0-f45.google.com with SMTP id i11so6654815oag.32
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 12:42:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <530A53E5.6000301@gmail.com>
References: <CAC45b7kjErBZ=bZEnbsmdbXkEowQRtkkoN-obSxpn3cRLrCvwQ@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB303D6FFEB@HASMSX103.ger.corp.intel.com>
	<CAC45b7ma=+QY1_woBPC44UkBeiWOG+iUNrScJ0gJ9qVfirNGsw@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB303D7004C@HASMSX103.ger.corp.intel.com>
	<530A53E5.6000301@gmail.com>
Date: Sun, 23 Feb 2014 12:42:55 -0800
Message-ID: <CAC45b7nRAhU=2aBAHKQmNdjCC4WZOBsQUa1XCyRZ+aFoTA0BAA@mail.gmail.com> (sfid-20140223_214302_327444_28CB196C)
Subject: Re: [Ilw] RX laggy/choppy/stuck without TX on Intel Wireless 7260
 with iwlwifi
From: Stephen Kent <smkent@smkent.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 23, 2014 at 12:02 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>
>
>
> On 02/23/2014 09:02 AM, Grumbach, Emmanuel wrote:
> >>
> >> On Sat, Feb 22, 2014 at 10:18 PM, Grumbach, Emmanuel
> >> <emmanuel.grumbach@intel.com> wrote:
> >>>>
> >>>> (Resending as plain text)
> >>>>
> >>>> I have a strange issue with my Intel Wireless 7260 adapter on my Dell XPS
> >> 13
> >>>> (Haswell). It seems that packets are received but aren't processed by the
> >>>> kernel or something until more packets are transmitted. The net effect is
> >>>> that the laptop's wireless seems somewhat choppy. I can demonstrate
> >> this
> >>>> by running something in a remote ssh session that generates periodic
> >>>> output, and that output doesn't appear until I generate more outgoing
> >>>> traffic. It's hard to describe it beyond that, but I took a screen capture
> >> which
> >>>> demonstrates this very well:
> >>>> http://www.youtube.com/watch?v=4RMURSMszmc
> >>>>
> >>>> lspci shows the wireless card as: 02:00.0 Network controller: Intel
> >> Corporation
> >>>> Wireless 7260 (rev 6b) uname -a: Linux dalek 3.11.0-12-generic #19-
> >> Ubuntu
> >>>> SMP Wed Oct 9 16:20:46UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> >>>>
> >>>> I googled this without success. I can gather diagnostic information if you
> >> send
> >>>> me instructions, I'm just not sure where to start or what to look for. Is this
> >> a
> >>>> bug in the driver? Maybe in the card microcode itself? Has anyone else
> >>>> reported this issue? It seems very strange.
> >>>> Any help is appreciated.
> >>>
> >>> Can you please send the output of dmesg?
> >>> Tracing output can help too - but let's start with dmesg output.
> >>>
> >>
> >> My full dmesg output is here: http://smkent.net/stuff/dmesg-dalek-
> >> 20140222
> >>
> >
> > Your dmesg looks healthy
> >
> >> Here's some selected output. I'm not sure if it's useful.
> >>
> >> smkent@dalek Desktop $ grep -ie iwl -e 80211 dmesg-dalek-20140222
> >> [    3.968070] cfg80211: Calling CRDA to update world regulatory domain
> >> [    3.976500] iwlwifi 0000:02:00.0: can't disable ASPM; OS doesn't
> >> have ASPM control
> >> [    3.976585] iwlwifi 0000:02:00.0: irq 59 for MSI/MSI-X
> >> [    4.115345] iwlwifi 0000:02:00.0: loaded firmware version 22.1.7.0
> >> op_mode iwlmvm
> >> [    4.157435] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
> >> Wireless AC 7260, REV=0x144
> >> [    4.157523] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> >> [    4.157691] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> >> [    4.269377] cfg80211: World regulatory domain updated:
> >> [    4.269383] cfg80211:   (start_freq - end_freq @ bandwidth),
> >> (max_antenna_gain, max_eirp)
> >> [    4.269387] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [    4.269390] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [    4.269393] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [    4.269396] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [    4.269399] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [    4.379283] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> >> [    4.709497] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> >> [    4.709671] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> >> [ 9676.817175] cfg80211: Calling CRDA to update world regulatory domain
> >> [ 9676.823809] cfg80211: World regulatory domain updated:
> >> [ 9676.823820] cfg80211:   (start_freq - end_freq @ bandwidth),
> >> (max_antenna_gain, max_eirp)
> >> [ 9676.823827] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [ 9676.823834] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [ 9676.823840] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [ 9676.823846] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [ 9676.823851] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
> >> (300 mBi, 2000 mBm)
> >> [ 9680.014722] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> >> [ 9680.014890] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> >>
> >> I haven't taken a kernel trace before but I'm happy to do so if you
> >> can point me toward some instructions.
> >>
> >
> > as root:
> > trace-cmd record -e iwlwifi -e iwlwifi_msg.
> >
> > Reproduce the bug while it's running. Stop with Ctrl+C when the bug reproduced.
> > This will produce a trace.dat file which you can compress and send over email.
> >
>
> Could you please try to reproduce with power save disabled?
>
> options iwlmvm power_scheme=1
>
> Thanks.


Huh, interesting. When I set that option the problem seems to go away.
I flipped back and forth between power_scheme=1 and power_scheme=2 in
iwlmvm (modinfo says 2 is the default), and the problem didn't
reproduce when power_scheme=1. I assume my battery life will suffer if
I permanently set power_scheme=1? :-)

Should I take a new trace or gather any other information?

I won't be my computer all day but I'll be able to respond / collect
any needed info intermittently.

Thanks,

Stephen
