Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37469 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaKKLIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 06:08:46 -0500
Message-ID: <5461EE3B.8040301@broadcom.com> (sfid-20141111_120850_136772_07020786)
Date: Tue, 11 Nov 2014 12:08:43 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: brcmfmac not working on ECS LIVA
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>	<545F4611.3010207@broadcom.com> <CAMP44s1NiYrFkN=DQcyGiJyW+JvCGvRVzcEBGLtvGyhfWs17kQ@mail.gmail.com>
In-Reply-To: <CAMP44s1NiYrFkN=DQcyGiJyW+JvCGvRVzcEBGLtvGyhfWs17kQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-11-14 21:48, Felipe Contreras wrote:
> Hi,
> 
> On Sun, Nov 9, 2014 at 4:46 AM, Arend van Spriel <arend@broadcom.com> wrote:
> 
>> The ideas may come to us with a bit more trace information. The logging
>> above is the usual stuff so no problem indication there.
>>
>> I looked at the nvram file from [1]. At the end there are some entries about
>> OOB wakeup, ie. starting with 'sd_'. You may remove those, but giving the
>> logging it would not be the first thing to do.
> 
> I removed the sd_ lines, it didn't help.
> 
>> Could you share the nvram obtained from EFI? Also please create a kernel log
>> with debug=0xd416.
> 
> Sure, the nvram file is here:
> 
> http://pastie.org/9710358
> 
> I tried adding this file:
> 
> /etc/modprobe.d/brcmfmac.conf
> options brcmfmac debug=0xd416
> 
> I see nothing extra in the debug log... Am I doing something wrong?

Not sure. You can verify and set the log level through sysfs, ie.:

$ cat /sys/module/brcmfmac/parameters/debug

To set it:

$ echo 0xd416 > /sys/module/brcmfmac/parameters/debug

Regards,
Arend
