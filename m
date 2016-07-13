Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from walmailout02.yourhostingaccount.com ([65.254.253.157]:48623
	"EHLO walmailout02.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbcGMP2X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 11:28:23 -0400
Received: from mailscan05.yourhostingaccount.com ([10.1.15.5] helo=walmailscan05.yourhostingaccount.com)
	by walmailout02.yourhostingaccount.com with esmtp (Exim)
	id 1bNLVV-0004L5-2W
	for linux-wireless@vger.kernel.org; Wed, 13 Jul 2016 10:51:25 -0400
Received: from [10.114.3.31] (helo=walimpout11)
	by walmailscan05.yourhostingaccount.com with esmtp (Exim)
	id 1bNLVU-00051W-UA
	for linux-wireless@vger.kernel.org; Wed, 13 Jul 2016 10:51:24 -0400
From: "Michael Eskowitz" <MichaelE@inventeksys.com>
To: =?utf-8?Q?'Rafa=C5=82_Mi=C5=82ecki'?= <zajec5@gmail.com>
Cc: "'Arend Van Spriel'" <arend.vanspriel@broadcom.com>,
	<linux-wireless@vger.kernel.org>
References: <002601d1d305$183c3070$48b49150$@inventeksys.com> <6d12bb3e-a01d-34c7-c1a9-b1952a84f99e@broadcom.com> <001201d1dc72$0675f030$1361d090$@inventeksys.com> <CACna6rzU91CRGmgPtAgEhdqwpSGSs0i-C3qL7OiB8soHk8vq8Q@mail.gmail.com>
In-Reply-To: <CACna6rzU91CRGmgPtAgEhdqwpSGSs0i-C3qL7OiB8soHk8vq8Q@mail.gmail.com>
Subject: RE: building brcmfmac driver for iMX6 Ultralite platform
Date: Wed, 13 Jul 2016 10:51:17 -0400
Message-ID: <001c01d1dd16$04fd1950$0ef74bf0$@inventeksys.com> (sfid-20160713_173353_440406_113B7DD1)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Arend,
>
>What about my reply? ;)

Sorry.  No offense intended.  I clearly need to not treat this as email.  I'll figure out the protocol soon enough.

>
>
>> That is news to me.  I was under the impression that bcmdhd was 
>> Broadcom's proprietary (closed source) Linux driver and brcmfmac was 
>> the open source Linux driver.
>
>Don't top post. It's hard to say what you're replying to. bcmdhd is also open source (not sure what license), just not mainline.
>
>
>> Either way, I am now running
>>
>>         insmod  brcmutil.ko
>>         insmod  brcmfmac.ko
>>
>> I receive no errors and no kernel messages.
>>
>> When I insert the 43341 module into the SDIO slot nothing happens.  
>> I'm guessing that the version of the brcmfmac driver that I built does 
>> not support that chip.
>
>Is is detected by the system? If so, what ID does it use?
>

The system recognizes that an mmc card has been inserted.  The driver doesn't see the module, however.  Looking at the page

	https://wireless.wiki.kernel.org/en/users/drivers/brcm80211

suggests that I simply need to move to a newer Linux kernel as I am using 3.14.38.  NXP recently posted a 4.1.15 install so I will try getting the 43341 module up and running with that.

>
>> When I insert the 43362 module into the SDIO slot I receive the 
>> following errors
>>
>>         mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>>         mmc0: new high speed SDIO card at address 0001
>>         brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  
>> 7 2012
>> 18:27:16 version 5.90.225 FWID 01-d8fe14bd
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>         brcmfmac: brcmf_add_if: ignore IF event
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_construct_reginfo: channel 1: f=2412 bw=0
>> sb=-1998840228
>>         brcmfmac: brcmf_construct_reginfo: channel 2: f=2417 bw=0
>> sb=-1998840228
>>
>> and suddenly ifconfig shows the interface wlan0.  The interface looks 
>> to be valid as it is displaying a MAC from our address range.
>>
>> Although the interface wlan0 is present I am not able to use wl 
>> commands to scan for networks.  wl reports "wl driver adapter not 
>> found" for all command arguments.  If I run the command
>>
>>         iwlist  wlan0  scan
>>
>> I'm told that the interface does not support scanning.  If I run 
>> wpa_cli and then the commands scan and scanresults I don't see any networks. 
>
>"wl" user space tool uses wlioctl, proprietary protocol, brcmfmac doesn't support it.
>
>iwlist uses wext protocol, legacy one.
>
>Please use nl80211 based tools, e.g. "iw".

I was able to scan with iw and join a WPA2 protected network using wpa_supplicant.  It would appear that I have the 43362 up and running with the brcmfmac driver.  I will try the other Linux install for the 43341.

Thank you all for all your help.  It is much appreciated.  :-)

-Mike



