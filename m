Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65429 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0CSQtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 12:49:35 -0400
Received: by gyg8 with SMTP id 8so1634353gyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 09:49:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1268978712.2446.1757.camel@rchatre-DESK>
References: <f39b508c1003170613g5a8754a2kc9e15075c16f499b@mail.gmail.com>
	 <1268978712.2446.1757.camel@rchatre-DESK>
Date: Fri, 19 Mar 2010 11:49:34 -0500
Message-ID: <f39b508c1003190949m91f4070i4d8d19929f8d6787@mail.gmail.com>
Subject: Re:
From: Vasil Lalov <vasil.lalov@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinett,

Thanks for responding to this. I also noticed other things. It seems
that this Microcode SW error occurs because the wifi card is
overheating. When used in n-mode and there is a large file transfer,
the temperature of the card rises to over 62C. Soon after this, the
microcode error occurs and the card gets disassociated.

Doing more research on the power vs temperature problem, I discovered
that other users are seeing this as well. Some have solved their
problem by enabling the power management for the wifi card by issuing

iwconfig wlan0 power on

Others, completely disabled the power management and forced a fixed,
lower power level by issuing

 echo 8 > /sys/bus/pci/drivers/iwlagn/0000\:06\:00.0/power_level

Also, what I have noticed is that if I have my laptop very very close
to the Access Point (1-3 feet) then this error is more likely to
happen. If I move the laptop further away, say more than 15-20 feet,
this error stops occurring so frequently.

Unfortunately, I cannot upgrade to 2.6.33 kernel as it is currently
not available for my distribution and I am reluctant to recompile my
own kernel.

Vasil

===
Vasil Lalov
Sr. Systems Manager
Chicago Public Library


On Fri, Mar 19, 2010 at 1:05 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Wed, 2010-03-17 at 06:13 -0700, Vasil Lalov wrote:
>
>> The error messages in dmesg:
>>
>> iwlagn 0000:0c:00.0: Microcode SW error detected.  Restarting 0x2000000.
>> [40595.037808] iwlagn 0000:0c:00.0: Start IWL Error Log Dump:
>> [40595.037814] iwlagn 0000:0c:00.0: Status: 0x000212E4, count: 5
>> [40595.037945] iwlagn 0000:0c:00.0: Desc
>> Time       data1      data2      line
>> [40595.037954] iwlagn 0000:0c:00.0: NMI_INTERRUPT_WDG            (#04)
>> 3570070946 0x00000002 0x07030000 3664
>
> [...]
>
>> [40595.101312] iwlagn 0000:0c:00.0: Stopping AGG while state not ON or starting
>> [40595.101318] iwlagn 0000:0c:00.0: queue number out of range: 0, must
>> be 10 to 19
>> [40595.101340] iwlagn 0000:0c:00.0: Stopping AGG while state not ON or starting
>> [40595.101343] iwlagn 0000:0c:00.0: queue number out of range: 0, must
>> be 10 to 19
>
> This looks similar to https://bugzilla.kernel.org/show_bug.cgi?id=15374
> - could you please update your kernel to 2.6.33 and try the patches
> attached to that bug report?
>
> Reinette
>
>
>
