Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44002 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2DPKMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 06:12:07 -0400
Received: by eekc41 with SMTP id c41so1240917eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 03:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120416104012.6b735928@destiny.ordissimo>
References: <20120413142352.3b927516@destiny.ordissimo> <CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com>
 <CAGRGNgVdQgMoBNpJcPJuc608+exeVvpvrGRvvmEggf=GTmOkbg@mail.gmail.com>
 <CALUN=qK65XgtG5B-Da9o6oGaSF38TsN6NuNaK5=9-nQ+TMUvtg@mail.gmail.com>
 <CAGRGNgVJjVC5ZWRXsrjraT17ivT=HAnnZnhczPfwOw2Za_vatA@mail.gmail.com>
 <20120416090609.6b257455@destiny.ordissimo> <20120416104012.6b735928@destiny.ordissimo>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Apr 2012 20:11:45 +1000
Message-ID: <CAGRGNgUiUN-pVW0s5CiNevMQBTMT-fgDE=4B4aNJNfv6oTMoGw@mail.gmail.com> (sfid-20120416_121213_031016_7AA241D5)
Subject: Re: RT5390 not working with rt2800pci
To: Anisse Astier <anisse@astier.eu>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anisse

On Mon, Apr 16, 2012 at 18:40, Anisse Astier <anisse@astier.eu> wrote:
> On Mon, 16 Apr 2012 09:06:09 +0200, Anisse Astier <anisse@astier.eu> wrote :
>
>> On Mon, 16 Apr 2012 16:22:36 +1000, Julian Calaby <julian.calaby@gmail.com> wrote :
>>
>> > Hi Anisse,
>> >
>> > On Mon, Apr 16, 2012 at 15:57, Anisse Astier <anisse@astier.eu> wrote:
>> > > On Mon, Apr 16, 2012 at 1:38 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> > >> Hi Anisse,
>> > >>
>> > >> On Mon, Apr 16, 2012 at 03:33, Anisse Astier <anisse@astier.eu> wrote:
>> > >>> On Fri, Apr 13, 2012 at 2:23 PM, Anisse Astier <anisse@astier.eu> wrote:
>> > >>> Why some cards work and others don't is a mystery.
>> > >>
>> > >> Not really, old cards generally work, current cards that have been out
>> > >> for a little while generally work, and bleeding edge,
>> > >> just-released-yesterday cards tend not to.
>> > > What I meant is that in the set of RT5390RL cards, some work, some
>> > > don't, consistently, and I cannot find any difference between them.
>> >
>> > Sorry, I misinterpreted what you meant.
>> >
>> > So, to clarify, am I right in saying that you have:
>> >  - "RT5390R" cards, PCI revision 0502 which all work
>> It's marked "RT5390L" (not R) and has revision 0502. And in the code it's
>> referred as REV_RT5390F (yes it's different).

I don't think it really matters either way - and as you said before,
they're irrelevant to this particular issue.

>> >  - "RT5390RL" cards, PCI revision 1502 which work
>> Correct.
>> >  - "RT5390RL" cards, PCI revision 1502 which don't work with the
>> > symptoms described above.
>> Correct, except revisions are *not* visible in PCI revision. These are only
>> visible in driver output when debug is enabled, with this printf:
>>         INFO(rt2x00dev,
>>              "Chipset detected - rt: %04x, rf: %04x, rev: %04x.\n",
>>              rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
>>
>> Which gets it by reading register MAC_CSR0_REVISION .

I must have picked up the "PCI" bit when you mentioned they were PCI
cards elsewhere, either way, as far as the driver, etc. is concerned,
they're identical.

>> > Ok, so let's look at this a bit closer: the "iw info" diff you
>> > provided before makes me think that there is some form of regulatory
>> > setting difference between the working and non-working cards. I would
>> > guess that this would be visible in the dmesg output, could you boot
>> > with a working card, save the dmesg, then boot with a non-working
>> > card, save the dmesg, diff them and reply with that diff? I'm guessing
>> > that there would be some lines in there about CRDA or regulatory which
>> > would be different.
>> I don't think this is related, but I'll try to provide the two dmesg,
>> with today's wireless-next.
> Full dmesgs are in attachment. I booted both machines with module
> rt2800pci blacklisted, and then loaded it manually with modprobe, so the
> interesting parts should be at the end.

Thanks for the dmesgs, however it's kinda annoying that there's no
real differences between them.

>> This might be polluted by the fact that the "working" card succeded in
>> connecting(on channel 6), which then changed the regulatory domain. I'll
>> try to get unpolluted results.

You shouldn't be having any regulatory issues connecting to an AP on
channel 6. In general, it's channels above 11 (I think) that are
occasionally masked by different regulatory settings.

> Almost. The cause was that passive scanning brought a beacon on channel
> 13, and this beacon caused regulatory domain change:
>
> --- 1604-dmesg-NOWORKI-truncated        2012-04-16 10:26:03.000000000 +0200
> +++ 1604-dmesg-WORKI-truncated  2012-04-16 10:26:04.000000000 +0200
> @@ -45,4 +45,6 @@
>  phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
>  phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
>  ADDRCONF(NETDEV_UP): wlan0: link is not ready
> +cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
> +cfg80211: Pending regulatory request, waiting for it to be processed...
>  EXT3-fs (sda5): using internal journal

Not quite, it seems that CRDA never got sent the request, which is
odd, however this is on the working card so it doesn't explain the
non-working ones.

>> > Also, what channel is your AP on and what region of the world are you
>> > in? (I'm guessing Europe from your email address, but which country
>> > specifically)
>> I'm in France, but using another wireless card, I can scan APs on
>> channels 1,2,3,6,8,10,11,13.

That sounds right.

I'm at a loss to explain it any further, which is annoying. At this
point, I'm guessing that there's some subtle hardware difference, or
something like that. It could be something as complicated as incorrect
or broken components, or something as simple as a dry solder join on
the antenna connection.

Where did you get the cards?

Does anyone else who's more knowledgeable than me have any idea what's
happening here?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
