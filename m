Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbcIXPZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 11:25:22 -0400
Date: Sat, 24 Sep 2016 17:25:18 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
Message-ID: <20160924172518.55787ec7@endymion> (sfid-20160924_172527_521705_A892CAFE)
In-Reply-To: <6feb0feb-eb53-8b6b-4c50-e6ace0cc854a@lwfinger.net>
References: <20160922115116.149c599c@endymion>
        <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
        <20160923141618.1fcfd809@endymion>
        <6feb0feb-eb53-8b6b-4c50-e6ace0cc854a@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Fri, 23 Sep 2016 13:10:28 -0500, Larry Finger wrote:
> As the RTL8192CE does not support WOWLAN, the correct response is to ignore that 
> call. Clearly, it has nothing to do with your network drops. One thing you might 
> do is add the appropriate file in /etc/modprobe.d/ so that the module is loaded 
> with the "ips=0" option to see if power save is messing up.

OK, we have just added the option, I'll let you know if it makes a
difference.

There are other messages logged, by the way. I did not mention them
before because they don't look like errors and "switch case not
processed" was my prime suspect, but maybe they would be useful to you:

wlp3s0: AP 94:a7:b7:xx:xx:xx changed bandwidth, new config is 2427 MHz, width 2 (2437/0 MHz)
wlp3s0: AP 94:a7:b7:xx:xx:xx changed bandwidth, new config is 2427 MHz, width 1 (2427/0 MHz)
wlp3s0: AP 94:a7:b7:xx:xx:xx changed bandwidth, new config is 2427 MHz, width 2 (2437/0 MHz)

It oscillates between both values. There doesn't seem to be a
correlation with the failures. The timing doesn't appear to be fully
random, for example these are the timestamps for this morning:

[Sat. sept. 24 09:17:16 2016]
[Sat. sept. 24 09:32:11 2016]
[Sat. sept. 24 10:27:15 2016]
[Sat. sept. 24 10:52:11 2016]
[Sat. sept. 24 12:07:16 2016]
[Sat. sept. 24 12:44:22 2016]

15 minutes, 55 minutes, 25 minutes, 75 minutes... Looks like something
is checking adjusting the configuration every 5 minutes? Last one
doesn't follow the pattern though (37 minutes.)

> I am in the process of fixing all the instances where the log entry for the 
> default case does not output the switch variable. With these patches, I will 
> also handle the HAL_DEF_WOWLAN case.

Great, thanks.

> I'm sorry about my original comments regarding patching the kernel. I sent that 
> E-mail before I even read your name and address. As a long-time openSUSE user, I 
> certainly recognize your name and your abilities.

No worry :-)

-- 
Jean Delvare
SUSE L3 Support
