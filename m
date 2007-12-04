Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41835 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751701AbXLDUtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 15:49:39 -0500
From: Holger Schurig <holgerschurig@gmx.de>
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Date: Tue, 4 Dec 2007 21:50:11 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <1196622331.7472.4.camel@localhost> <20071204110135.1835a57e@morte> <1196790047.7472.5.camel@localhost>
In-Reply-To: <1196790047.7472.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712042150.12050.holgerschurig@gmx.de> (sfid-20071204_204946_473353_1E0EC42F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> but if we want to make some parameters available for everybody, we
> cannot rely on module parameters, i.e. when mac80211 is compiled int
> the kernel.

It doesn't matter if a something is compiled as a module or if this 
something is part of a monolithic kernel. The "something" will still 
get it's /sys/module/SOMETHING/ directory and if it happens to have 
parameters, a /sys/module/SOMETHING/parameters/ directory.

# lsmod
Module                  Size  Used by
ide_scsi               11848  0
usb_storage            54400  0
cx24110                 6084  1
dvb_bt8xx              13892  0
dvb_core               72444  1 dvb_bt8xx
bt878                   8488  1 dvb_bt8xx
bttv                  163508  2 dvb_bt8xx,bt878
ir_common              30148  1 bttv
compat_ioctl32           960  1 bttv
i2c_algo_bit            5380  1 bttv
videobuf_dma_sg        10884  1 bttv
videobuf_core          13956  2 bttv,videobuf_dma_sg
btcx_risc               3848  1 bttv
tveeprom               13968  1 bttv
videodev               25792  1 bttv
v4l2_common            15168  2 bttv,videodev
v4l1_compat            13508  2 bttv,videodev
# ls /sys/module/
8250/       compat_ioctl32/  i8042/      mtrr/      snd/           
v4l2_common/
acpi/       cx24110/         ide_cd/     printk/    snd_intel8x0/  
videobuf_core/
atkbd/      drm/             ide_scsi/   psmouse/   snd_pcm_oss/   
videobuf_dma_sg/
bt878/      dvb_bt8xx/       ir_common/  rcupdate/  tcp_cubic/     
videodev/
btcx_risc/  dvb_core/        keyboard/   scsi_mod/  tveeprom/      vt/
bttv/       ehci_hcd/        libusual/   sg/        usb_storage/
cdrom/      hid/             loop/       sis5595/   usbcore/
cn/         i2c_algo_bit/    mousedev/   sis900/    v4l1_compat/

But don't do it for rate control. Maybe you want to have on wlan0 a 
different rate control than on wlan1. And 
a /sys/module/SOMETHING/parameters/ exported variables are 
module-global.
