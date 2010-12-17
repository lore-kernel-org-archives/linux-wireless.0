Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:19374 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0LQKgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 05:36:50 -0500
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271
 drivers
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Elvis Dowson <elvis.dowson@mac.com>
Cc: Arik Nemtsov <arik@wizery.com>, panduranga <x0125717@ti.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
In-Reply-To: <397FC41E-7F1D-4AA8-9D09-6121BB0169E7@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com>
	 <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
	 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>
	 <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
	 <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com>
	 <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
	 <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com>
	 <AANLkTikvk+AqKRr1VbKv9pSHicy7PAGu8GkdeZuvYwFh@mail.gmail.com>
	 <397FC41E-7F1D-4AA8-9D09-6121BB0169E7@mac.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 12:38:43 +0200
Message-ID: <1292582324.18083.7.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Elvis,

On Fri, 2010-12-17 at 14:25 +0400, ext Elvis Dowson wrote:
> Hi Arik,
> 
> On Dec 17, 2010, at 2:12 PM, Arik Nemtsov wrote:
> > 
> > The firmware file should be called wl1271-fw.bin and the nvs file
> > should be called wl1271-nvs.bin. Both should reside in /etc/firmware
> > (if you're running a standard linux).
> 
> I got the files from this git repo 
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
> 
> and copied them over to /etc/firmware
> 
> /etc/firmware# ls -l
> total 276
> -r--r--r-- 1 root root 271712 Dec 17  2010 wl1271-fw.bin
> -rw-rw-r-- 1 root root    912 Dec 17  2010 wl1271-nvs.bin
> 
> But I still get a error saying the the nvs file could not be found:
> 
> [   63.852264] wl1271: ERROR could not get nvs file: -2
> [   63.906250] wl1271: loaded
> [   63.909271] wl1271: initialized

You need to start udevd.  The driver gets the firmware via udev.


-- 
Cheers,
Luca.

