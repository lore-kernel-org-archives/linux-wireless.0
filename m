Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752795AbcKNKRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 05:17:05 -0500
Date: Mon, 14 Nov 2016 11:15:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20161114101544.GA13943@redhat.com> (sfid-20161114_111727_911777_BE00A73A)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
 <20160616115315.GB21199@redhat.com>
 <20160623120952.GA11157@redhat.com>
 <20160811090113.GA27059@redhat.com>
 <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com>
 <20160811122917.GB27059@redhat.com>
 <fc70c75bfcab4e0e932274034b5b4493@SC-EXCH04.marvell.com>
 <20160812081342.GA15538@redhat.com>
 <20160825150626.GA9256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160825150626.GA9256@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2016 at 05:06:26PM +0200, Stanislaw Gruszka wrote:
> On Fri, Aug 12, 2016 at 10:13:43AM +0200, Stanislaw Gruszka wrote:
> > On Fri, Aug 12, 2016 at 07:17:38AM +0000, Amitkumar Karwar wrote:
> > > The problem looks strange. The patch just splits mwifiex_check_fw_status() and increases poll count. It should not have any side-effects.
> > > Our code used to check winner status before this patch also.
> > 
> > Ok, I misread the patch. Anyway checking "winner status" seems
> > does not work well on some condition and prevent loading firmware
> > into device.
> 
> I debug this a bit more on latest wireless-testing-next tree + 3 patches
> I just posted and debug_mask=0x700000ff.
> 
> On broken system, we do not download FW to device when system is
> rebooted, due to PCI-E is not the winner. However if system is
> powered OFF and then powered ON, we do FW downloading. Hence
> download the new FW into device does not make it work as was
> my theory.
> 
> In attachments are full dmesgs of good/bad and reboot/power-off-on
> cases.
> 
> The difference is that on broken system FW (or HW) do not create
> new USB Bluetooth device (1286:2046) and do not report
> FIRMWARE_READY_PCIE. Additionally on reboot case there are errors
> from USB xhci.

It was discovered that not working device require pcie8897_uapsta.bin 
firmware from ubuntu package to work:
https://launchpad.net/~snappy-dev/+archive/ubuntu/snappy-devices/+sourcepub/5936055/+listing-archive-extra

Device initialize like this then:

[   15.374630] mwifiex_pcie 0000:02:00.0: info: FW download over, size 689624 bytes
[   16.101214] mwifiex_pcie 0000:02:00.0: WLAN FW is active
[   16.242825] mwifiex_pcie 0000:02:00.0: info: MWIFIEX VERSION: mwifiex 1.0 (15.150.13.p21) 
[   16.251231] mwifiex_pcie 0000:02:00.0: driver_version = mwifiex 1.0 (15.150.13.p21) 

I'm not sure where ubuntu get this 15.150.13.p21 version of firmware as
it seems it's not present nor in upstream linux-firmware repo not in
http://git.marvell.com/?p=mwifiex-firmware.git;a=summary

Anyway could you modify firmware to support this device or modify
driver to load 15.150.13.p21 if required and push this F/W image
upstream ?

Thanks
Stanislaw
 
