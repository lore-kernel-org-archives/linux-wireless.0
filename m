Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:32893 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3HBQFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 12:05:06 -0400
Received: by mail-vb0-f41.google.com with SMTP id g17so782819vbg.14
        for <linux-wireless@vger.kernel.org>; Fri, 02 Aug 2013 09:05:04 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 Aug 2013 09:04:44 -0700
Message-ID: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com> (sfid-20130802_180537_048640_76E35D89)
Subject: Slow firmware timeouts again (Re: [3.11 regression?] iwlwifi firmware
 takes two minutes to load)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
	systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[cc: linux-kernel, linux-hotplug, and systemd-devel.  This is 3.11-rc3+]

On Fri, Aug 2, 2013 at 12:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2013-08-01 at 21:38 -0700, Andy Lutomirski wrote:
>> At boot, I get:
>> [   12.537108] iwlwifi 0000:03:00.0: irq 51 for MSI/MSI-X
>> ...
>> [  132.676781] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1
>> build 25532 op_mode iwldvm
>>
>> This sounds familiar, but wasn't it fixed awhile ago?
>
> It wasn't exactly fixed and it's really more of a userspace problem - we
> probably request firmware version 8, and then it takes 30 seconds to
> time out for each of 8,7,6,5, after which the next request for 4 is
> successful.

Why's it requesting those firmwares?  They don't seem to exist on
intellinuxwireless.org.

I have:

CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y


>
> I don't know why your userspace isn't behaving differently though.
>
> johannes
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
