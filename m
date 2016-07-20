Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34983 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcGTJxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 05:53:34 -0400
Received: by mail-wm0-f53.google.com with SMTP id f65so168522289wmi.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 02:53:34 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
In-Reply-To: <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com> <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 20 Jul 2016 02:53:32 -0700
Message-ID: <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com> (sfid-20160720_115339_344568_48126C33)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just following up from my previous email:

I am actually setting the reg domain using: iw reg set GB (copy/pasted
the IN from elsewhere - oops!)

As for progress, however, I have tried the following:

- setting the debug level to 0xfffffff. This still produces no
additional output even with 8 set in printk.

- removing the v9 firmware - same result as before - system fully locks up.

- disabling ipv6 - gets rid of IPv6 interface not up warning but
that’s not causing any problems and this didn’t make any difference.

It doesn’t seem to matter what I try at the moment - all attempts to
connect result in the system crashing which I guess is better than it
just asking me for a password over and over - it looks like it is
attempting association at this point which is good but I don’t know
why the box is crashing out and dmesg -w doesn’t show any additional
output before the freeze.

If anyone has any more ideas I would be more than happy to try them!
Thanks for the help so far Dan!

Christopher Williamson

On 19 July 2016 at 18:41:34, Christopher Williamson
(home@chrisaw.com(mailto:home@chrisaw.com)) wrote:

> So I’ve now disabled IPv6 and have set the GB (Great Britain) regulation code using:
>
> iw reg set IN
>
> Now when I try to connect to the network using wicd the system seems to crash - I guess at least it’s doing something more than just asking for the password again like it did with NetworkManager but so far no further progress on getting this working properly.
>
> Christopher Williamson
>
>
>
> On 19 July 2016 at 18:03:16, Christopher Williamson (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
>
> > Absolutely!
> >
> > With the debug logging enabled I got the following:
> >
> > Connecting the device initially with debug enabled:
> >
> > [ 205.302685] libertas_sdio: Libertas SDIO driver
> > [ 205.302698] libertas_sdio: Copyright Pierre Ossman
> > [ 205.503465] cfg80211: World regulatory domain updated:
> > [ 205.503478] cfg80211: DFS Master region: unset
> > [ 205.503483] cfg80211: (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> > [ 205.503492] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> > [ 205.503499] cfg80211: (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> > [ 205.503505] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> > [ 205.503513] cfg80211: (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
> > [ 205.503522] cfg80211: (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
> > [ 205.503529] cfg80211: (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> > [ 205.503535] cfg80211: (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> > [ 205.503542] cfg80211: (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> > [ 212.249171] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
> > [ 212.324898] mmc1: new SDIO card at address 0001
> > [ 212.921672] libertas_sdio mmc1:0001:1 (unnamed net_device) (uninitialized): 00:02:78:69:49:94, fw 9.70.20p0, cap 0x00000303
> > [ 212.925774] libertas_sdio mmc1:0001:1 (unnamed net_device) (uninitialized): PREP_CMD: command 0x00a3 failed: 2
> > [ 212.936190] libertas_sdio mmc1:0001:1 wlan0: Marvell WLAN 802.11 adapter
> > [ 213.053612] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >
> >
> > Strangely when I attempt to connect to the WiFi network I’m using the only error I get is:
> >
> > [ 338.076632] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >
> > I was expecting more output and am guessing I’ve missed something here.
> >
> > Christopher Williamson
> >
> > On 19 July 2016 at 17:38:35, Dan Williams (dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:
> >
> > > On Tue, 2016-07-19 at 12:06 -0400, Christopher Williamson wrote:
> > > > Hi everyone!
> > > >
> > > > I’ve just got myself a Viliv N5 and am trying to get the integrated
> > > > Wifi chipset working on it.
> > > >
> > > > I am able to see networks around me but any attempts to connect them
> > > > appear to time out and fail.
> > > >
> > > > I have filed a linux kernel bug related to this issue:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=135421goo
> > > >
> > > > I figured here may be a good place to ask about it and hopefully to
> > > > get to the bottom of why it happens and how I can help to fix it.
> > > >
> > > > Happy to provide any information which may be helpful! :)
> > >
> > > Can you reload the driver stack:
> > >
> > > rmmod libertas_sdio
> > > rmmod libertas
> > > modprobe libertas libertas_debug=0x251e7ff
> > > modprobe libertas_sdio
> > >
> > > and then reproduce the issue? The debug info should dump to 'dmesg'
> > > and may tell us what's going on.
> > >
> > > Dan
