Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38375 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbcGWM3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2016 08:29:44 -0400
Received: by mail-wm0-f52.google.com with SMTP id o80so98417740wme.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2016 05:29:43 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
In-Reply-To: <CANXHH3kDVSiLwpKcYwdr4gqOZkgu9Djf=2e8kFpgZT2mT0AmZw@mail.gmail.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com> <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
 <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com>
 <1469033825.3004.8.camel@redhat.com> <1469033825.3004.8.camel@redhat.com>
 <CANXHH3minohF3z9bWc2NAghiU=w4DbsH1jU8iE8=v7H1pGdFcg@mail.gmail.com>
 <1469051432.3286.4.camel@redhat.com> <1469051432.3286.4.camel@redhat.com>
 <CANXHH3n0=dmV+2D9FeOoGuqDvKJHdpnOMdYH1Ecr3TACJ5FXYQ@mail.gmail.com>
 <1469115440.29944.1.camel@redhat.com> <CANXHH3kHFDkRUTMyOheFwpJasqOmtGrQ3dG7LP_L0CBN87Aagw@mail.gmail.com>
 <CANXHH3kwH_A-45D9ZsT3Afz3LxYW6Pgz06qBzfnK+jtcg8FiNg@mail.gmail.com>
 <1469133499.18298.8.camel@redhat.com> <1469133499.18298.8.camel@redhat.com>
 <etPan.579137d1.40bb3278.381a@chrisaw.com> <CANXHH3=852nV-4rjt8bO47Mbt02JNHNFGzytk3kiV1RQ39rLwg@mail.gmail.com>
 <435adbc6-9fa3-e9e3-9815-8cf4b62e5342@broadcom.com> <CANXHH3mn2U5X5n9OB6+uESDgeRt6r6WyGV5wT0=MQwvuvD870g@mail.gmail.com>
 <CANXHH3mn2U5X5n9OB6+uESDgeRt6r6WyGV5wT0=MQwvuvD870g@mail.gmail.com>
 <CANXHH3mOsN3-U=BS4fA6iax0ciwbSSywHAgOhHCNj8e7CPCyfQ@mail.gmail.com>
 <1469204186.15064.6.camel@redhat.com> <1469204186.15064.6.camel@redhat.com>
 <CANXHH3nvu7TC=x5RTR_WcgGkd2=_0h4BZrc_Nv74023nrc3P5w@mail.gmail.com>
 <CANXHH3kX-U_CRfBf+DVe7AMpU13fKGG5bRwgLhDqYuGOBF-HBw@mail.gmail.com>
 <CANXHH3nB3BujorAuYRweE=w+n=ESoJod2LFphRrxwXrXUrf_zw@mail.gmail.com>
 <CANXHH3mMnNL5i8SZfm_H-tQWe5tuPM+tMxHH7pgE8zmj5yvNuA@mail.gmail.com>
 <CANXHH3m2XEjkOfXGhtBUqCfu4Vix365fiRHzHL3DanoVzOsT3w@mail.gmail.com> <CANXHH3kDVSiLwpKcYwdr4gqOZkgu9Djf=2e8kFpgZT2mT0AmZw@mail.gmail.com>
MIME-Version: 1.0
Date: Sat, 23 Jul 2016 05:29:41 -0700
Message-ID: <CANXHH3nXBg9C+45rswD1ge-piH4Jz_XCaMULOMDgtfoTgKirzw@mail.gmail.com> (sfid-20160723_142952_811646_7F911BB9)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to follow up on this - I performed a minimal ubuntu server
install (16.04.1), commented out the crda udev rule (since that was
setting the weird country: 98 issue) and tried again and it still
didn’t work.

I did confirm that the md5 sums for the firmware included with Arch is
the exact same as the firmware included for Ubuntu 16.04.1 so there
was no difference there.

At this point I’m thinking it’s either:

- Some Ubuntu-specific udev rule breaking things or:
- A difference in the kernel config between Arch and Ubuntu

I think I’m going to forfeit for now and switch over to Arch - spent
several days on this already. If anyone has any other ideas on what
could be causing this please do let me know and I’ll follow up if I
experiment this with again.

Christopher Williamson




On 22 July 2016 at 22:47:15, Christopher Williamson
(home@chrisaw.com(mailto:home@chrisaw.com)) wrote:

>
> Hi all,
>
> So I decided to have another fiddle with this and managed to get the WiFi working perfectly first time on an ArchLinux LiveCD so it looks like this issue is Ubuntu specific.
>
> I’m going to copy the firmware files and check if they’re responsible and work my way through the various differences but at least I know this device can work properly on the Linux 4.6.3 (which the livecd is based on.)
>
> I’ll follow up if and when I find out what the cause of the problem was.
>
> Christopher Williamson
>
>
>
>
> On 22 July 2016 at 22:42:50, Christopher Williamson (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
>
> > Hi all,
> >
> > So I decided to have another fiddle with this and managed to get the WiFi working perfectly first time on an ArchLinux LiveCD so it looks like this issue is Ubuntu specific.
> >
> > I’m going to copy the firmware files and check if they’re responsible and work my way through the various differences but at least I know this device can work properly on the Linux 4.6.3 (which the livecd is based on.)
> >
> > I’ll follow up if and when I find out what the cause of the problem was.
> > Christopher Williamson
> > www.chrisaw.com(http://www.chrisaw.com)
> >
> >
> >
> >
> > On 22 July 2016 at 18:17:20, Christopher Williamson (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
> >
> > > I haven’t managed to get connected to a WPA network either so it looks like open only at the moment but I fear that may just have been a fluke.
> > >
> > > A big problem I’m facing is that editing /etc/default/crda to REGDOMAIN=GB wasn’t enough to set the wifi regulation mode to GB and I have to set it manually. This sometimes works and sometimes reports the following:
> > >
> > > country 98: DFS-UNSET
> > > (2402 - 2472 @ 40), (N/A, 20), (N/A)
> > > (2457 - 2472 @ 15), (N/A, 20), (N/A), NO-IR
> > > (5170 - 5250 @ 80), (N/A, 17), (N/A), NO-IR
> > > (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, NO-IR
> > > (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
> > > (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
> > > (57240 - 63720 @ 2160), (N/A, 0), (N/A)
> > >
> > > At best this is simply an annoyance but at worst I’m thinking this may be responsible for the issues I’m seeing.
> > >
> > > Is there anywhere else I can force this to be set to GB?
> > >
> > > Christopher Williamson
> > >
> > >
> > > On 22 July 2016 at 17:54:40, Christopher Williamson (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
> > >
> > > > Disregard - I have actually managed to get this to connect to a open network!
> > > >
> > > > # iw reg set GB
> > > > # iw reg get
> > > > country GB: DFS-ETSI
> > > > (2402 - 2482 @ 40), (N/A, 20), (N/A)
> > > > (5170 - 5250 @ 80), (N/A, 20), (N/A)
> > > > (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS
> > > > (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS
> > > > (57000 - 66000 @ 2160), (N/A, 40), (N/A)
> > > > # iwconfig wlan0 essid "shaunthesheep-guest”
> > > > # dhclient wlan0
> > > >
> > > > It’s good to have some progress - so it looks like the issue preventing the previous connection was the iw reg not being set properly (or possibly just wpa_supplicant borking the connection in some way. I stopped that this time around. I’ll try wpa1 now and report back.
> > > >
> > > >
> > > > Christopher Williamson
> > > >
> > > >
> > > >
> > > > On 22 July 2016 at 17:39:50, Christopher Williamson (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
> > > >
> > > > >
> > > > > Ok so I created a guest wifi network without any encryption enabled at all and the client still refuses to connect.
> > > > >
> > > > > Again, the connection is made perfectly using the USB dongle I have but not the built in libertas sd8686 chipset.
> > > > >
> > > > > I do currently use pfSense as a firewall box behind my wireless router (acting as an AP) and can see that no DHCP request is making it to the pfSense box. I believe you are right in the point about the firmware being the problem here.
> > > > >
> > > > > I should also confirm - the firmware in use is the latest from the linux-firmware Ubuntu 16.04 package. I did read around the net about being having various issues with various firmware sources and not others but despite trying firmware linked directly from Marvell I seem to always get one of two issues:
> > > > >
> > > > > 1.) I am unable to connect and keep getting asked for passphrases, or:
> > > > > 2.) The system completely freezes up (with the v8 firmwares I tried)
> > > > >
> > > > > I’m not really sure what else to try at this point.
> > > > > Christopher Williamson
> > > > >
> > > > >
> > > > >
> > > > > On 22 July 2016 at 17:24:52, Christopher Williamson (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
> > > > >
> > > > > >
> > > > > > Hi Dan,
> > > > > >
> > > > > > I will check out the WPA2 vs WPA vs open wireless thing in a few mins.
> > > > > >
> > > > > > For now though - the iwlist scan results for both a USB device and the
> > > > > > libertas device:
> > > > > >
> > > > > > USB: http://termbin.com/hdwl
> > > > > > Libertas: http://termbin.com/jxh7
> > > > > >
> > > > > > Will follow up shortly with WPA and Open network configs.
> > > > > >
> > > > > > Christopher Williamson
> > > > > >
> > > > > >
> > > > > >
> > > > > > On 22 July 2016 at 17:16:29, Dan Williams (dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:
> > > > > >
> > > > > > > Hi Dan,
> > > > > > >
> > > > > > > I will check out the WPA2 vs WPA vs open wireless thing in a few mins.
> > > > > > >
> > > > > > > For now though - the iwlist scan results for both a USB device and the
> > > > > > > libertas device:
> > > > > > >
> > > > > > > USB: http://termbin.com/hdwl
> > > > > > > Libertas: http://termbin.com/jxh7
> > > > > > >
> > > > > > > Will follow up shortly with WPA and Open network configs.
> > > > > > >
> > > > > > > *Christopher Williamson*
