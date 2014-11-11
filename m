Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:57337 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaKKTNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 14:13:49 -0500
Received: by mail-ob0-f175.google.com with SMTP id gq1so7982081obb.34
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 11:13:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54625F10.2010907@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
	<CAMP44s1NiYrFkN=DQcyGiJyW+JvCGvRVzcEBGLtvGyhfWs17kQ@mail.gmail.com>
	<5461EE3B.8040301@broadcom.com>
	<CAMP44s10T_mxqLigrPf_Ox4jej--87QmjG7cNjT8o_qyU2HXjg@mail.gmail.com>
	<546256E3.1080606@broadcom.com>
	<CAMP44s3r7DS6eR4pDqesv1JeiWsC-j75QGdGJk=PBX208sUJ1g@mail.gmail.com>
	<54625F10.2010907@broadcom.com>
Date: Tue, 11 Nov 2014 13:13:48 -0600
Message-ID: <CAMP44s2wL9W+_r5tarewjrorh83oSLZuJjoCeB9mqCJWadGmog@mail.gmail.com> (sfid-20141111_201352_968721_FBDB4C0B)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2014 at 1:10 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 11/11/14 19:49, Felipe Contreras wrote:
>>
>> On Tue, Nov 11, 2014 at 12:35 PM, Arend van Spriel<arend@broadcom.com>
>> wrote:
>>>
>>> On 11-11-14 19:32, Felipe Contreras wrote:
>>>>
>>>> On Tue, Nov 11, 2014 at 5:08 AM, Arend van Spriel<arend@broadcom.com>
>>>> wrote:
>>>>>
>>>>> On 10-11-14 21:48, Felipe Contreras wrote:
>>>>
>>>>
>>>>>> /etc/modprobe.d/brcmfmac.conf
>>>>>> options brcmfmac debug=0xd416
>>>>>>
>>>>>> I see nothing extra in the debug log... Am I doing something wrong?
>>>>>
>>>>>
>>>>> Not sure. You can verify and set the log level through sysfs, ie.:
>>>>>
>>>>> $ cat /sys/module/brcmfmac/parameters/debug
>>>>
>>>>
>>>> 54294
>>>>
>>>> I guess ArchLinux's kernel is missing some configuration option needed
>>>> for the debugging.
>>>
>>>
>>> Can you boot the kernel with 'debug ignore_loglevel' on the kernel
>>> command line.
>>
>>
>> Yes. I see more systemd messages, nothing extra from brcmfmac.
>
>
> Ok. Probably brcmfmac was not built with CONFIG_BRCMDBG. Can you checkout
> kernel config.

That's right; it's not set. I will enable it and rebuild.

-- 
Felipe Contreras
