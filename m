Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:46759 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab3GIJeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 05:34:23 -0400
Message-ID: <51DBD904.6020007@inov.pt> (sfid-20130709_113425_788377_398B8DC9)
Date: Tue, 09 Jul 2013 10:33:56 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>  <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>  <51DB4195.8090103@inov.pt>  <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com> <1373360959.21065.183.camel@cumari.coelho.fi>
In-Reply-To: <1373360959.21065.183.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First of all, thanks Arik and Luca for your help.

On 09-07-2013 10:09, Luciano Coelho wrote:
>>> wlcore: Beacon loss detected. roles:0xff
>> This one is possibly a FW version issue. I'd give it a go with the
>> latest FW in TI's git:
>> https://github.com/TI-OpenLink/ti-utils/tree/master/hw/firmware
> More specifically, try the hw/firmware/wl127x-fw-4-sr.bin and the
> hw/firmware/wl127x-fw-4-mr.bin (if you're using multirole).  Note that
> you need to rename them to wl127x-fw-5-sr.bin and wl127x-fw-5-mr.bin,
> respectively.
>
> What we have in the linux-firmware git at the moment are versions
> 6.3.10.0.133 (singlerole) and 6.5.7.0.42 (multirole).  The new ones in
> TI's github repo are 6.3.10.0.136 and 6.5.7.0.46.
>
> If the new firmwares solve your problem, please let me know and I'll
> push them to the linux-firmware git repo.

Just to clarify. I was using the latest firmware files from 
linux-firmware and the driver picks the file wl127x-fw-5-sr.bin which is 
Rev 6.3.10.0.133. So are you saying that I should install the 
wl127x-fw-4-sr.bin from TI's github repo named as wl127x-fw-5-sr.bin and 
give it a try?

>
>>> To use the driver in the Luca's tree I need to do some work to adapt my
>>> platform to the latest kernel version, what I would like to avoid  for now.
>>> Is there any set of patches to put  the driver in vanilla kernel 3.9 in a
>>> more stable condition?
>> Well 3.9 is pretty new, so the difference is not that big. A simple
>> cherry pick of all patches done on <root>/drivers/wireless/ti/ would
>> do the trick.
>>
>> Or you could always used compat-wireless, or in it's new name "driver
>> backports":
>> https://backports.wiki.kernel.org/index.php/Main_Page
> I'd really recommend cherry-picking just what is needed.  It should be
> very few patches.

I was doing that in this precise moment...

> And every time you find a new patch that fixes some
> real issue you're seeing, let me know and I'll send to stable.

OK.

José Gonçalves
