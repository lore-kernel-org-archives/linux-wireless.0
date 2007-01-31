Return-path: <wireless-bounces@tuxdriver.com>
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.251])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V3C1pU004245
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 22:12:27 -0500
Received: by an-out-0708.google.com with SMTP id c38so44963ana
	for <wireless@lists.tuxdriver.org>;
	Tue, 30 Jan 2007 19:11:59 -0800 (PST)
Message-ID: <9e4733910701301911p6c687565h65bce1aedf7e13a3@mail.gmail.com>
Date: Tue, 30 Jan 2007 22:11:58 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jouni Malinen" <jkmaline@cc.hut.fi>
Subject: Re: SIOCGIWRANGE and dscape
In-Reply-To: <20070131025234.GB7061@jm.kir.nu>
MIME-Version: 1.0
References: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
	<200701302012.23302.flamingice@sourmilk.net>
	<20070131025234.GB7061@jm.kir.nu>
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

On 1/30/07, Jouni Malinen <jkmaline@cc.hut.fi> wrote:
> On Tue, Jan 30, 2007 at 08:12:19PM -0500, Michael Wu wrote:
>
> > Fixing up giwrange is currently on my d80211 blockers todo list since it is
> > part of fixing wireless statistics reporting in d80211. Helper functions for
> > filling the channel lists is also somewhere on the todo list, though it isn't
> > on the blocker list. The driver currently has no way to indicate what
> > regulatory domain the hardware has stored in eeprom, and d80211 just assumes
> > FCC. (after all, d80211 isn't merge ready yet ;) Yes, basic driver regulatory
> > domain support is on my blocker todo list.
>
> The simple workaround for client mode is indeed just assuming one
> regulatory domain, but the original design of the Devicescape stack was
> to use a user space component (hostapd in case of AP mode) to populate
> the allowed channel information based on what the low-level driver
> claims to support as far as channels are concerned and what is
> configured for regulatory domain (in hostapd configuration).

It seems like regulatory domain for an AP has to be controlled from
user space. What about the simple case of someone with a US laptop
that flies to Japan and runs hostap. Getting the value from the eeprom
won't work in this case. If this is the case then the drivers just
need to report up every channel they can handle.

I have several APs. The Netgear ones let me set the region from their
web interface. To change my travel router from Dlink you need to
download different firmware images (like anyone is going to do that
for a business trip).

Managed mode doesn't need to know the regulatory domain, right? It
picks it up from the AP.

AdHoc would need to know the regulatory domain.


>
> > Listing rates and channels in giwrange should be easy - find the current mode,
> > and iterate through the list of channels and rates in there. Ignore any
> > channels which are not enabled. Count up all the enabled channels and stick
> > it in num_channels and num_frequency.
>
> Yes, all the needed information for this particular part should already
> be in net/d80211 and there is no need for low-level driver changes for
> this. The separate question is on how the channel flags should be set
> based on the current location of the device.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> _______________________________________________
> wireless mailing list
> wireless@lists.tuxdriver.org
> http://lists.tuxdriver.org/mailman/listinfo/wireless
>


-- 
Jon Smirl
jonsmirl@gmail.com
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
