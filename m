Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34651 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753534AbcKUPv5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 10:51:57 -0500
Date: Mon, 21 Nov 2016 16:51:53 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: wl1251 & mac address & calibration data
Message-ID: <20161121155153.GM13735@pali> (sfid-20161121_165230_017164_7F2FBA71)
References: <201611111820.52072@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201611111820.52072@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 November 2016 18:20:50 Pali Rohár wrote:
> Hi! I will open discussion about mac address and calibration data for 
> wl1251 wireless chip again...
> 
> Problem: Mac address & calibration data for wl1251 chip on Nokia N900 
> are stored on second nand partition (mtd1) in special proprietary format 
> which is used only for Nokia N900 (probably on N8x0 and N9 too). 
> Wireless driver wl1251.ko cannot work without mac address and 
> calibration data.
> 
> Absence of mac address cause that driver generates random mac address at 
> every kernel boot which has couple of problems (unstable identifier of 
> wireless device due to udev permanent storage rules; unpredictable 
> behaviour for dhcp mac address assignment, mac address filtering, ...).
> 
> Currently there is no way to set (permanent) mac address for network 
> interface from userspace. And it does not make sense to implement in 
> linux kernel large parser for proprietary format of second nand 
> partition where is mac address stored only for one device -- Nokia N900.
> 
> Driver wl1251.ko loads calibration data via request_firmware() for file 
> wl1251-nvs.bin. There are some "example" calibration file in linux-
> firmware repository, but it is not suitable for normal usage as real 
> calibration data are per-device specific.
> 
> So questions are:
> 
> 1) How to set mac address from userspace for that wl1251 interface? In 
> userspace I can write parser for that proprietary format of nand 
> partition and extract mac address from it

Proposed solutions for 1)

* Introduce new IOCL for setting that permanent mac address from
  userspace. Currently we have IOCL for get request

* Use request_firmware() (with flag from 2)) to ask for mac address from
  userspace. This is already used by wl12xx driver (as mac address is
  part of calibration data firmware file)

* Allow to set mac address via sysfs file, e.g.
  /sys/class/ieee80211/phy0/macaddress

> 2) How to send calibration data to wl1251 driver? Those are again stored 
> in proprietary format and I can write userspace parser for it.

Proposed solution for 2)

Introduce new flag for request_firmware(), so it first try to use
userspace helper for loading firmware file with possibility to fallback
to direct VFS access.


So... what do you think about it?

-- 
Pali Rohár
pali.rohar@gmail.com
