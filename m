Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36222 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933973AbcIVDet (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 23:34:49 -0400
Received: by mail-oi0-f53.google.com with SMTP id t83so83762985oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 20:34:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de>
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
 <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de>
From: bruce m beach <brucembeach@gmail.com>
Date: Wed, 21 Sep 2016 20:34:47 -0700
Message-ID: <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com> (sfid-20160922_053505_063154_38466DA8)
Subject: Re: ath9k_htc kernel driver regression affecting throughput
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> We recently updated FW to GCC 6.2 which can detect more problems. So it
> will be probably interesting for you to pick this patch out.

Yes I saw the message by Adrian Chadd and tried tried to git clone the link
he gave but that clearly wasn't what was to be done. Is there a patch that I
need to apply to the firmware? I do have a local copy.

On 9/20/16, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 21.09.2016 um 05:43 schrieb bruce m beach:
>> Oleksij
>>
>> I looked at
>> https://unix.stackexchange.com/questions/122050/
>>       send-traffic-to-self-over-physical-network-on-ubuntu
>>
>> It appearred to too complicated but
>>
>> https://unix.stackexchange.com/questions/122050/
>>         send-traffic-to-self-over-physical-network-on-ubuntu
>> with:
>>     # Create a network namespace and move one of interfaces into it:
>>       ip netns add test2
>>       ip link set wlan0 netns test2
>>     # Start a shell in the new namespace:
>>        ip netns exec test2 bash
>>     # Then proceed as if you had two machines. When finished exit the
>> shell and
>>     # delete the namespace:
>>        ip netns del test2
>> Certainly looks interesting but after I got a
>>  RTNETLINK answers: Invalid argument
>> I lost interest. My heart isn't in it. I'm still working on the firmware.
>> I
>> have started a new tree (tree #3) that consists of a userland firmware
>> uploader
>> and until recently the following firmware:
>>
>> app_start( void ) {}
>>
>> i.e a lable that the code jumps to and nothing else. At this point I have
>> added VendorCommand(), and a debugger via ep0. ( ep0 is a good choice
>> since it is available a boot, no matter what) and over the next few
>> months I am going to move ->all<- the rom code into ram starting with
>> the USB subsystem.
>>
>> Bruce
>>
>
>
> Wow, this sounds interesting :)
> We recently updated FW to GCC 6.2 which can detect more problems. So it
> will be probably interesting for you to pick this patch out.
>
> --
> Regards,
> Oleksij
>
>
