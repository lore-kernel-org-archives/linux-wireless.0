Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40361 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaKIKqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 05:46:44 -0500
Message-ID: <545F4611.3010207@broadcom.com> (sfid-20141109_114835_601788_9368F95A)
Date: Sun, 9 Nov 2014 11:46:41 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	<frankyl@broadcom.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: brcmfmac not working on ECS LIVA
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
In-Reply-To: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/14 21:39, Felipe Contreras wrote:
> Hi,
>
> I just got an ECS LIVA and I haven't been able to get the wireless
> working. First I got the error that the brcmfmac43241b4-sdio.txt file
> was missing. I got the file from the ECS's beta drivers [1], but it's
> still not working.
>
> brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init
> done for chip 4324 rev 5 pmurev 17
> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul 17 2013
> 07:36:07 version 6.10.197.71 (r412987) FWID 01-882d2634
> brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
> brcmfmac: brcmf_add_if: ignore IF event
>
> WPA association/authentication failed for interface 'wlan0'
>
> I also tried a nvram file that is stored in EFI variables, but it
> didn't work either.
>
> Some things seem to work some times, but not the whole association.
>
> This is a 3.17.2 kernel.
>
> Any ideas?

Hi Felipe,

The ideas may come to us with a bit more trace information. The logging 
above is the usual stuff so no problem indication there.

I looked at the nvram file from [1]. At the end there are some entries 
about OOB wakeup, ie. starting with 'sd_'. You may remove those, but 
giving the logging it would not be the first thing to do.

Could you share the nvram obtained from EFI? Also please create a kernel 
log with debug=0xd416.

Regards,
Arend

> [1] http://www.ecs.com.tw/LIVA/support.html
>

