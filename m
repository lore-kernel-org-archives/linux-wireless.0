Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753150AbZKQQ6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:58:51 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Piotr Findeisen <piotr.findeisen@gmail.com>
Subject: Re: unsupported TL-WN422G (0cf3:1006)
Date: Tue, 17 Nov 2009 17:58:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <4B02CD95.2010805@gmail.com>
In-Reply-To: <4B02CD95.2010805@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200911171758.53596.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tuesday 17 November 2009, Piotr Findeisen wrote:
> Hi!
> 
> I've bought TP-LINK WN422G USB wireless card with Zydas chipset (as
> stated by the seller) in the hope it will be supported by zd1211rw
> driver (listed here [1]), but it seems it's not.
> I've tried to find help on linuxforums.org <http://linuxforums.org> [2]
> — the only open option is to use ndiswrapper, which (a) is reported not
> to work earlier in the thread and (b) is the last option for me to
> consider. Search in linux-wireless's archives yielded only a result [3]
> with a patch included in my kernel (Ubuntu-2.6.31-14.48).
> 
> My card's vendor:product id is 0cf3:1006 (different that the one listed
> [1] for WN422G).
[...]

If you take a look at the vendor's windows driver for TP-LINK WN422G *v2*,
it becomes obvious that the device does not use the ZyDAS zd1211/ Atheros 
5007UG cipset, but has switched to the new Atheros AR9271 chipset (which 
technically is a 150 MBit/s 802.11n "lite" chipset family) instead.

%ATHER.DeviceDesc.9271% = ATHER_DEV_9271.ndi,     USB\VID_0CF3&PID_9271
%ATHER.DeviceDesc.7010% = ATHER_DEV_7010.ndi,     USB\VID_0CF3&PID_7010
%ATHER.DeviceDesc.1006% = ATHER_DEV_1006.ndi,     USB\VID_0CF3&PID_1006

At this moment a new driver called ath9k_htc is under (early) development:
	http://wireless.kernel.org/en/users/Drivers/ath9k_htc

Regards
	Stefan Lippers-Hollmann
