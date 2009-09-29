Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47113 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZI2S1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 14:27:36 -0400
Received: by fxm18 with SMTP id 18so4712992fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 11:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890909290200h4dbefddah131851675dc06097@mail.gmail.com>
References: <200909260457.21103.malte.gell@gmx.de> <4ABDE7AC.1090409@hauke-m.de>
	<200909291050.54388.malte.gell@gmx.de> <3ace41890909290200h4dbefddah131851675dc06097@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 29 Sep 2009 20:27:20 +0200
Message-ID: <69e28c910909291127x3be75be0r3ceef7367d05f9c3@mail.gmail.com>
Subject: Re: cannot compile compate-wirless snapshots
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Malte Gell <malte.gell@gmx.de>, Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 11:00 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Tue, Sep 29, 2009 at 9:50 AM, Malte Gell <malte.gell@gmx.de> wrote:
>>
>> Hauke Mehrtens <hauke@hauke-m.de> wrote
>>
>>
>>> Does this file exists in your installation?
>>> /lib/modules/`uname -r`/build/include/linux/tracepoint.h ?
>>
>> Yes, but, look:
>>
>> cd /usr/src/linux
>>
>> grep -i tracepoint .config
>>
>> # CONFIG_TRACEPOINTS is not set
>>
>> Do I need to set it to yes?
>>
>> Malte
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> No. You should not manually edit any kernel config file (the
> compat-wireless module should be built against a config matching your
> running kernel, not a massaged version of it) and what is in
> /usr/src/linux is irrelevant , because that is not your running
> kernel.
>
> The relevant config is probably /boot/config-`uname -r`, but, please
> do *not* modify it.
>

It should be in /proc/config.gz. (/boot/config-* is an Ubuntuism.)

> I already wrote - your best bet is simply deleting all the 'error
> redefintion' parts from net/compat-2.6.28.h, since your kernel tree is
> somewhere between 2.6.27 and 2.6.28 . (and also delete some part of
> net/compat-2.6.28.c when possible later linker error arises).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
