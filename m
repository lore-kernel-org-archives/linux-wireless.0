Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47042 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRHjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 02:39:54 -0500
Received: by qyk2 with SMTP id 2so673392qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 23:39:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE13842932BE@SJEXCHCCR01.corp.ad.broadcom.com>
References: <20101116200420.GA10793@kroah.com>
	<1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
	<20101117211035.GA2442@kroah.com>
	<AANLkTi=p_iH32zads+9RwQGY+m7JK+FTmhBTth_x9ouK@mail.gmail.com>
	<20101117221127.GB3851@suse.de>
	<7A94256FD72B884D9E7C55586C3CBCEE13842932BE@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Thu, 18 Nov 2010 09:39:54 +0200
Message-ID: <AANLkTinqTCv3b4vVncvjBQGo_ZoBD1-5ppqX0Rw9VQWL@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 12:32 AM, Brett Rudley <brudley@broadcom.com> wrote:
> I'm not familiar with the fullmac code so I am getting someone from fullmac team to answer...hang on just a little.
>
> In the meantime Mike, does the driver still work with all your patches?

I was never able to connect to an access point with the hardware I
have and the brcmfmac driver. However, there's no change in the driver
behavior with all my patches.

cm-t35:~# modprobe brcmfmac firmware_path=4329/BCM43x9-FW.bin
nvram_path=4329/nvram.txt
[   93.952331] brcmfmac: module is from the staging directory, the
quality is unknown, you have been warned.
[   94.033081] F1 signature read @0x18000000=0x9934329
[   94.039520] _sb_scan: scan bus 0x18000000 assume 1 cores
[   94.049743] _sb_scan: scan bus 0x18010000 assume 4 cores
[   94.057952] _sb_scan: found 4 cores on bus 0x18010000
[   94.063049] _sb_scan: found 5 cores on bus 0x18000000
[   94.075927] Buscore id/type/rev 6/0x829/1
[   94.082244] No SDIO Drive strength init done for chip 4329 rev 3 pmurev 6
[   94.096252] DHD: dongle ram size is set to 294912(orig 294912)
[   94.653472] dhdsdio_write_vars: Download/Upload/Compare of NVRAM ok.
[   94.752532] Firmware version = wl0: Jun 29 2009 17:26:41 version 4.218.97.0
[   94.993255] eth1: Broadcom Dongle Host Driver
[   94.998474]
[   94.998474] Dongle Host Driver, version 4.218.248.5
[   94.998504] Compiled in  on Nov 18 2010 at 08:52:38


> Thanks
> Brett
>
>> -----Original Message-----
>> From: Greg KH [mailto:gregkh@suse.de]
>> Sent: Wednesday, November 17, 2010 2:11 PM
>> To: Mike Rapoport
>> Cc: Greg KH; Brett Rudley; Henry Ptasinski; Dowan Kim; linux-
>> wireless@vger.kernel.org
>> Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
>> controller binding
>>
>> On Thu, Nov 18, 2010 at 12:00:16AM +0200, Mike Rapoport wrote:
>> > On Wed, Nov 17, 2010 at 11:10 PM, Greg KH <greg@kroah.com> wrote:
>> > > On Wed, Nov 17, 2010 at 09:58:46AM +0200, Mike Rapoport wrote:
>> > >> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
>> > >> ---
>> > >>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ----------
>> -----------
>> > >>  1 files changed, 0 insertions(+), 229 deletions(-)
>> > >
>> > > Wait, is this really ok code to be removing from the driver?
>> > >
>> > > Brett and Henry, any objections to this?
>> > >
>> > > Mike, why do you think this is ok to remove?  Is it because no one is
>> > > ever calling this even for both types of config for this driver?
>> >
>> > There's a lot of code in the brcmfmac part of the driver that tries to
>> > re-implement SDIO stack. In particular, the code removed by this patch
>> > registers a pci_driver for SDIO controller and then the brcmfmac
>> > driver accesses the WiFi device attached to that SDIO controller by
>> > means of custom re-implementation of SDHC.
>>
>> Ok, so even with this patch, it will still work properly in the SDIO
>> mode?
>>
>> Have you been able to test this?
>>
>> Brett, Henry, I would like to get your ack on this before applying it.
>>
>> thanks,
>>
>> greg k-h
>
>
>



-- 
    Sincerely Yours,
        Mike.
