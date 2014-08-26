Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:45776 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaHZPTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 11:19:33 -0400
Received: by mail-la0-f47.google.com with SMTP id mc6so14943275lab.6
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2014 08:19:32 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: David Madsen <david.madsen@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8192su driver compatibility with a rtl8188su device
Date: Tue, 26 Aug 2014 17:19:28 +0200
Message-ID: <2918019.CXq3d6nCM0@debian64> (sfid-20140826_171938_111754_997C1E83)
In-Reply-To: <CALoNvyuUxX7Wv+nRnPDW_PdO3BsJbTfrF-MU7uoNuUbAXrbZnA@mail.gmail.com>
References: <CALoNvyuUxX7Wv+nRnPDW_PdO3BsJbTfrF-MU7uoNuUbAXrbZnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday, August 25, 2014 06:08:14 PM David Madsen wrote:
> I came across the in-development rtl8192su source tree on github while
> looking for a driver for a small Trendnet 802.11bgn device I have.
> The chipset in use is an rtl8188su with usbid 0bda:8171. I was able
> to compile and load the driver against a standard 3.16.1 kernel with
> what looks to be a reasonably accurate capability listing for the
> wireless phy along with a standard dev instance.
The capability listings are enabled since it wouldn't be possible
to test the devices capability otherwise. Even though the caps
are present/set they are by no means implemented. [see README.md]

> The firmware is found correctly (I created a link from the
> rtl8712u.bin to rtl8192sufw.bin).
The rtl8192su.git comes with two sets of firmware (for two different 
driver architectures).

The rtl8712u firmware is much more integrated and can performs several
high-level procedures (high-level for firmware) like scanning, link setup
(auth, assoc, reassoc, deassoc, deauth), link monitoring, rate control,
crypto, erp, beacon generation, etc... with little to no help from the
driver. This firmware is used by the (staging) rtl8712u, v2.6.6.0.20120405
and (abandoned) r92su driver.

the rtl8192su* firmware can't do any of those. The driver +
mac80211-stack has to perform the all the necessary procedures
(starting from the phy/rf setup). This firmware is used by rtl8192su,
AR-7284WnAB, windows and mac osx drivers.

> [...]
> 
> It appears that the firmware writes into the device are timing out or
> failing in some fashion which leaves the device uninitialized, and
> eventually returns the error. 
The rtl8712u firmware doesn't allow the driver to write into
the phy/bb registers in the same way the rtl8192su firmware
does (and vice versa). That said, it should be possible to
check if the firmware image is the right now. A good place to
add it would be in rtl8192su/sw.c's rtl_fw_cb(). It should be
enough to check if the first word (fw_hdr->signature) matches
0x8192 (in little endian) to determine whenever it is the 
correct firmware or not.

> Is the rtl8188su expected to work with the driver currently or is
> support there still a work in progress?
No, the rtl8192su driver is not ready for anything useful. Sure, with
the correct firmware it can scan, connect, send and receive data just
fine... But only *for a random amount of time*.

The abandoned r92su driver is much better in this regard. However it
suffers from firmware problems. One big problem is that the sequence
counter is increased for every frame [tx fragmentation doesn't work
since only the fragment count should be increased in this case].
Another big issue is that the rate control algorithm falls back to
1MBit/s and stays there. 

> I was able to use the existing rtl8712 driver from the staging tree
> to get the device working, but it uses the old wireless extensions and
> doesn't appear to support a monitor mode, which was the initial goal
> of getting this device working.
The monitor mode of the rtl8712/r92su driver is limited by the firmware
too. For example it is not possible to set the channel bandwidth to 40MHz.
If that is not a problem and you don't need injection, you can try to get
the abandoned r92su driver to work. It uses cfg80211 (not the old wireless
extension) and has support for the monitor mode.

> In summary I've got a few questions.  Is this chipset expected to be
> functional with the driver at this time?
No.

> If not I would be interested in helping out with porting/testing/debugging
> to aid in getting the chipset functional.
That would be: figuring out why the device dies after a random amount of time.
This could be caused by a missing watchdog check or the firmware detected a
problem and needs a reset. I think this will probably require someone taking
USB traffic dumps from both the mac os x or windows driver and check what they
do differently. [Not very trivial]

[Note: rtl8192su shares a lot of code with rtl8192se (this is the pcie-version)
The pcie-version doesn't have the problem either.]

> Lastly, is monitor mode expected to work with the driver/chipset or are there
> lower layer filters in place that would keep the driver and upper layers 
> from seeing all the frames from the phy?
The frame filters are fully configurable for this device in monitor mode.
For the r92su driver this is controlled by the r92su_hw_mac_set_rx_filter
function in r92su/hw.c.

Regards
Christian
