Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:50143 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab0AUVjj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 16:39:39 -0500
Message-ID: <4B58C997.2060904@irobot.com>
Date: Thu, 21 Jan 2010 13:39:35 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com> 	<4B5897C8.2080006@irobot.com> <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com> 	<4B58B432.5050200@irobot.com> <43e72e891001211217t17ffed80i2d5bc6f923b56210@mail.gmail.com> <4B58C622.2090004@irobot.com>
In-Reply-To: <4B58C622.2090004@irobot.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I see what's going on now.  The openembedded recipe I'm working with 
didn't copy the udev stuff.

Adam Wozniak wrote:
> Luis R. Rodriguez wrote:
>> BTW Haukes posted a fix for the compile build against ARM. Try that.
>> That patch applies to compat.git but you should be able to mangle it
>> to apply to compat-wireless easily too.
>>   
> That worked, thank you.
>> OK so it failed here, you may want to try to debug udev stuff now
>> then, what distribution do you have? Where are your udev rules put?
>> Where is the original udev rule for firmware for your box?
>>
>> You can debug udev stuff by using 'udevadm monitor'
>>   
> I'm using openembedded.  Rules are in /etc/udev/rules.d
> It contains a file 50-udev-default.rules with a line:
>
> SUBSYSTEM=="firmware", ACTION=="add", RUN+="firmware.sh"
>
> If I copy & paste and change the SUBSYSTEM to "compat_firmware" things 
> seem to load ok.
>
> --Adam
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

