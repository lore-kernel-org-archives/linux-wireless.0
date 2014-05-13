Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.natecarlson.com ([74.117.236.15]:39801 "EHLO
	plesk.technicality.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932564AbaEMOPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 10:15:31 -0400
Date: Tue, 13 May 2014 09:15:25 -0500 (CDT)
From: Nate Carlson <linux-wireless@natecarlson.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] New firmware for Intel 7260 / 3160 - 22.212.9.0
In-Reply-To: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405130906520.29439@admin.chi.technicality.org> (sfid-20140513_161535_363282_0D66A7E9)
References: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 28 Apr 2014, Emmanuel Grumbach wrote:
> The firmwares are available at [1].
> I will send a pull request to linux-firmware.git soon.
>
> The new firmware's version number is 22.212.9.0:
>
> $ dmesg | grep loaded\ firmware
> loaded firmware version 22.212.9.0 op_mode iwlmvm
>
> [1] http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware

Hi,

I've just noticed that the firmware, as downloaded from both your git tree 
and from the wireless.kernel.org URL, reports that it is v23.214.9.0 --

$ dmesg | grep loaded\ firmware
[   16.628491] iwlwifi 0000:03:00.0: loaded firmware version 23.214.9.0 op_mode iwlmvm

md5sum of installed firmware when the driver was loaded and reported that:
$ md5sum /lib/firmware/iwlwifi-7260-9.ucode
1005c3b82879ecfa0d60544a78de7f92  /lib/firmware/iwlwifi-7260-9.ucode

md5sum of the firmware from 'iwlwifi-7260-ucode-22.212.9.0.tgz':
$ md5sum iwlwifi-7260-ucode-22.212.9.0/iwlwifi-7260-9.ucode
1005c3b82879ecfa0d60544a78de7f92  iwlwifi-7260-ucode-22.212.9.0/iwlwifi-7260-9.ucode

md5sum of the firmware in your git tree:
http://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-9.ucode?id=7a67dbf9c087ef64b3d3fc9ce448c2efdb2e365f
$ wget 'http://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-9.ucode?id=7a67dbf9c087ef64b3d3fc9ce448c2efdb2e365f' -O iwlwifi-7260-9.ucode ; md5sum iwlwifi-7260-9.ucode
<..>
2014-05-13 09:10:40 (985 KB/s) - `iwlwifi-7260-9.ucode' saved [678904/678904]
1005c3b82879ecfa0d60544a78de7f92  iwlwifi-7260-9.ucode

Looks like a user reported the same thing in a RedHat bugzilla post:
https://bugzilla.redhat.com/show_bug.cgi?id=1087717 -- see comment #8.

I'm running 3.15.0-rc5 (Ubuntu's 'mainline' build), but I doubt that has 
anything to do with how the firmware reports its version.  ;)

Is the version number just wrong, or is this actually not the firmware you 
intended to release?

Thanks!

-Nate
