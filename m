Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:41294 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdLMKqZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 05:46:25 -0500
Received: by mail-it0-f41.google.com with SMTP id x28so3359557ita.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Dec 2017 02:46:24 -0800 (PST)
Subject: Re: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
 Marvell ESPRESSOBin
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
References: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
 <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com>
 <7d8c7705-70ac-9a36-b5d2-23fcffcf6a29@gmail.com>
 <4dbd89bbcb0a4706bf3fe7b79025d95c@SC-EXCH02.marvell.com>
 <6e26f5b1-10a7-b7fc-1518-f0d0f66a50e9@gmail.com>
 <44a8b2b8-d798-0e5d-0da1-c2bea52463bc@gmail.com>
 <0c5acf38-d634-12b6-9f0d-0ae8c6535558@gmail.com>
 <8341b7bb8ccb4137b8143f4a312ab83f@SC-EXCH02.marvell.com>
From: Ellie Reeves <ellierevves@gmail.com>
Message-ID: <5674a188-8922-26cd-2c9a-9705b9919634@gmail.com> (sfid-20171213_114639_644397_ECC8A028)
Date: Wed, 13 Dec 2017 05:46:08 -0500
MIME-Version: 1.0
In-Reply-To: <8341b7bb8ccb4137b8143f4a312ab83f@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
here is the firmware dump... It looks more like a binary blob to me, but 
I guess there are some tools to inspect it:
https://cloud.xogium.me/s/wDf9bOWZU3cngw8/download

(dirrect link). As for the dmesg output, the first logs I posted were 
exactly this, all kernel messages filtered from journald, and nothing 
serious seems to have changed. I will redo it as soon as I have a chance 
and post it. I cannot use dmesg because there are so much info generated 
the buffer is incomplete, hence the use of journalctl -b -k. Doesn't 
really help that the poor board is having a load average of 5 while 
doing this, but I will try to capture a new debug log.

Hope this helps

-------- Message original --------
> Hi Ellie
>
>> -----Original Message-----
>> From: Ellie Reeves [mailto:ellierevves@gmail.com]
>> Sent: Friday, December 01, 2017 9:07 PM
>> To: Ganapathi Bhat
>> Cc: linux-wireless@vger.kernel.org; amitkarwar@gmail.com; Nishant
>> Sarmukadam; Xinming Hu
>> Subject: Re: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
>> Marvell ESPRESSOBin
>>
>> Hi,
>> just a short message to mention I booted the 4.14 kernel and grabbed what
>> was in /sys/class/devcoredump/devcd1/data into a file. I'm not sure if it
>> could be useful, but did it anyways... Let me know if it's useful and I'll post
>> the binary somewhere.
>> Thanks
> You can share that.  Additionally, can you share the dmesg logs with extensive log level.
> You can use below command to set the same:
> echo    0xffffffff      >       /sys/kernel/debug/mwifiex/mlan0/debug_mask
>> -------- Message original --------
>>> Hi again,
>>> I tried the few patch that made it to this list without any real
>>> success... I suppose the issue isn't that easy to reproduce on your
>>> side so... Shall I try a git bisect, building only that module and see
>>> if I can narrow it down a bit ? I'm no expert with git or git bisect
>>> for that matter, but I'm guessing building the module will be less
>>> time consuming than building the entire kernel... Unless you want me
>>> to do something else to help in debugging. I want to help as much as I
>>> can to solve this, heh, even despite me annoying my father because his
>>> wifi access point goes poof. :) Thanks,
>>>
>> --
>> Ellie Reeves

-- 
Ellie Reeves
