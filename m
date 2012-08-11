Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab2HKSVh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 14:21:37 -0400
Date: Sat, 11 Aug 2012 18:34:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb: WARN(x) in check_sdata_in_driver()
Message-ID: <20120811163406.GA10564@redhat.com> (sfid-20120811_202140_978762_01FDA5C9)
References: <CANq1E4RFGq2M7uSOMZLGuZYSa7E5g6RoWfyLDLtgAdsORD_qWg@mail.gmail.com>
 <20120810222746.GA19779@redhat.com>
 <CANq1E4RH5fHM5LPddD+A_w-G7k0=0scP0jpmqHnygX6Q9_Xecw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANq1E4RH5fHM5LPddD+A_w-G7k0=0scP0jpmqHnygX6Q9_Xecw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 11, 2012 at 03:47:55PM +0200, David Herrmann wrote:
> Hi Stanislaw
> 
> On Sat, Aug 11, 2012 at 12:27 AM, Stanislaw Gruszka <sgruszka@redhat.com>wrote:
> 
> > Hi
> >
> > On Sun, Jul 15, 2012 at 07:34:58PM +0200, David Herrmann wrote:
> > > I use an ASUStek WL-167g USB wlan adapter (quite old) using rt73usb.ko
> > > (Ralink). After resuming from suspend I get:
> > >
> > > [152743.736783] ------------[ cut here ]------------
> > > [152743.736798] WARNING: at net/mac80211/driver-ops.h:12
> > > ieee80211_send_deauth_disassoc+0x1a8/0x1b0()
> > > [152743.736801] Hardware name: N150P/N210P/N220P
> > > [152743.736804] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
> >
> > Does it still happen on 3.5.1 ?
> >
> 
> Thanks for asking. With 3.5.1 I get "phy0 -> rt2x00lib_request_firmware:
> Error - Failed to request Firmware."
> But:
> $ wc /lib/firmware/rt73.bin
>   5 44 2048 /lib/firmware/rt73.bin
> So I wonder were that comes from. udevd segfaults twice while hotplugging
> the device. And finally I get "link becomes ready" but I get ENODEV when
> starting wpa_supplicant. It all seems a bit weird and I have no idea how to
> debug this.
>
> I will try putting the firmware blob into the kernel binary.
Looks like some change broke udev, but how? Do you have the same thing with
3.5.0 ? Perhaps updating udev could help.

You do not use NetworkManager or similar only pure wpa_supplicant? That would
explain why I'm not seeing the problem on my setup. Could you provide me 
your wpa_supplicant.conf (after removing psk and ssid entries) ? 
What wpa_supplicant version you are using?

Thanks
Stanislaw
