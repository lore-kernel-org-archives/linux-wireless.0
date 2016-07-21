Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35306 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbcGUNCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 09:02:15 -0400
Received: by mail-wm0-f49.google.com with SMTP id f65so21236406wmi.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 06:02:14 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
In-Reply-To: <CANXHH3n0=dmV+2D9FeOoGuqDvKJHdpnOMdYH1Ecr3TACJ5FXYQ@mail.gmail.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com> <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
 <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com>
 <1469033825.3004.8.camel@redhat.com> <1469033825.3004.8.camel@redhat.com>
 <CANXHH3minohF3z9bWc2NAghiU=w4DbsH1jU8iE8=v7H1pGdFcg@mail.gmail.com>
 <1469051432.3286.4.camel@redhat.com> <1469051432.3286.4.camel@redhat.com> <CANXHH3n0=dmV+2D9FeOoGuqDvKJHdpnOMdYH1Ecr3TACJ5FXYQ@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 21 Jul 2016 09:02:13 -0400
Message-ID: <CANXHH3=C03Hwj9tnmd2ppnajr3kAsCL23Gzdb9xb-35CS2O8pQ@mail.gmail.com> (sfid-20160721_150218_831518_BC2A7EB5)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tried a few more things worth mentioning:

- Tried connecting with wpa_supplicant & dhclient only but sadly
wpa_supplicant still cannot seem to hold a connection to the base
station.

It looks like the relevant errors here may be:

ioctl[SIOCSIWENCODEEXT]: Invalid argument
wlan0: Trying to associate with a0:63:91:1e:ee:43
(SSID='shaunthesheep' freq=2457 MHz)
ioctl[SIOCSIWFREQ]: Device or resource busy
wlan0: Association request to the driver failed

- Tried NetworkManager again and also tried wicd - both have similar
problems. I expect since they both use wpa_supplicant the issue was
unlikely to not be there for either of these solutions but I figured
it was worth experimenting with.

- I also tried kernel 4.6.4 and noticed no difference there either so
it looks like the same issue is present in the latest stable kernel as
well as the latest longterm kernel (which Ubuntu uses for 16.04 LTS.)

Christopher Williamson


On 20 July 2016 at 23:16:41, Christopher Williamson
(home@chrisaw.com(mailto:home@chrisaw.com)) wrote:

>
> I used NetworkManager in the previous test.
>
> This time around I have used wpa_supplicant directly and get the following results:
>
> http://termbin.com/j8ea
>
> Thought I’d throw them on a pastebin since it’s over 700 lines.
>
> Christopher Williamson
>
>
>
>
> On 20 July 2016 at 22:50:34, Dan Williams (dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:
>
> > On Wed, 2016-07-20 at 13:06 -0700, Christopher Williamson wrote:
> > > Hi Dan,
> > >
> > > Ah - yeah I hadn’t thought it may be a kernel build option. I’ve now
> > > built that and dmesg is a much more lively place!
> > >
> > > I’ve provided output logs for both when the device is connected and
> > > when a connection attempt is made - hopefully this is useful.
> >
> >
> >
> > The card is scanning and only finds 'shaunthesheep' 20 seconds after
> > you "connect for the first time". The logs stop 3 seconds later. Are
> > you connecting with wicd or something else?
> >
> > Can you run wpa_supplicant with the "-dddtu" option so we can get debug
> > log output from it?
> >
> > Dan
