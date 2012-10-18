Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46075 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab2JRQIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 12:08:46 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so4262259bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2012 09:08:45 -0700 (PDT)
Message-ID: <50802984.6070203@gmail.com> (sfid-20121018_180852_697182_2E48BF58)
Date: Thu, 18 Oct 2012 18:08:36 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: mwifiex_sdio problem: firmware fails to be active in time
References: <507F4448.2040707@gmail.com> <477F20668A386D41ADCC57781B1F7043083B80E44A@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083B80E44A@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

thanks for your time.

On 18.10.2012 02:20, Bing Zhao wrote:
>> we're trying to get a SD8787 to play which is connected via SDIO to an
>> OMAP hsmmc (AM33xx hardware). This fails with the following message:
>>
>> # modprobe mwifiex_sdio
>> [   13.984779] [sched_delayed] sched: RT throttling activated
>> [   22.401700] mwifiex_sdio mmc0:0001:1: FW failed to be active in time
>>
>> The firmware sd8787_uapsta.bin was taken from the linux-firmware.git and
>> apparently is transferred successfully, but then consequently fails to
>> do start up. When compiled with CONFIG_MMC_CONFIG=y, tons of successful
>> messages are logged like this:
>>
>> [ 2607.867660] mmc0: starting CMD52 arg 00000a00 flags 00000195
>> [ 2607.867713] mmc0: req done (CMD52): 0: 00001000 00000000 00000000
>> 00000000
>> [ 2607.883273] mmc0: starting CMD52 arg 00000a00 flags 00000195
>> [ 2607.883327] mmc0: req done (CMD52): 0: 00001000 00000000 00000000
>> 00000000
>> [ 2607.898905] mmc0: starting CMD52 arg 00000a00 flags 00000195
> 
> It keeps reading Int_Pending (CCCR register 0x05). Perhaps you have interrupt storm here?
> Could you please check if your controller clears interrupt properly?

The reason for this issue was a different one: the 32KHz clock was not
running. I just learned that the firmware download will succeed
nevertheless, but the firmware won't start. Note to myself: make sure to
rule out any hardware issue before bordering developers :-/ But that
posting may be a help to someone with similar issues one day ...

>> The kernel we're based on is Linus' current merge tree (3.7-rc1), but
>> earlier version (3.6) have shown the same issue.
>>
>> Before we start digging into this, I want to ask whether there are any
>> common pitfalls we should be aware of and that could cause this?
> 
> You may want to get a newer firmware release from here:
> 
> http://git.marvell.com/?p=mwifiex-firmware.git;a=summary
> git://git.marvell.com/mwifiex-firmware.git

Note that contains the same firmware binary than the linux-firmware
repository.

>> Please let me know whether you need any further information.
> 
> It might be helpful if you post messages before this line:
> 
> [ 2607.867660] mmc0: starting CMD52 arg 00000a00 flags 00000195


Thanks again!

Daniel

