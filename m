Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51576 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933890AbcIVNe4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 09:34:56 -0400
Message-ID: <57E3DDFE.20104@candelatech.com> (sfid-20160922_153459_524591_C2E784BD)
Date: Thu, 22 Sep 2016 06:34:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: bruce m beach <brucembeach@gmail.com>
CC: Oleksij Rempel <linux@rempel-privat.de>,
        linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc kernel driver regression affecting throughput
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com> <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de> <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com> <57E35BA9.7050207@candelatech.com> <CAArymC=VT+1E=-ug1yaVquW0jVvbFfZ0USzRcsRD62tSR-9FRA@mail.gmail.com>
In-Reply-To: <CAArymC=VT+1E=-ug1yaVquW0jVvbFfZ0USzRcsRD62tSR-9FRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/21/2016 09:53 PM, bruce m beach wrote:
> memory will be very tight. There is 160k or known ram and bits and pieces
> elsewhere. The rom is 24k (maximum). I currently am not to worried about
> it. (although I am watching it)
> bruce

Probably you know this...but check structs for memory holes, unused
fields (write only, for instance) and other wastes.
ath10k firmware was full of needless memory bloat in those areas.

Global pointers can be used in some cases to help, but mysteriously
seem to cause more instruction RAM in some cases.

Watch 'instruction ram' usage:  Changing code to use a bitfield may save
some BSS ram, but may easily use far more instruction ram than what you
saved with the bitfield.

Good luck!

Thanks,
Ben

>
> On 9/21/16, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 09/21/2016 08:34 PM, bruce m beach wrote:
>>
>>>>> i.e a lable that the code jumps to and nothing else. At this point I
>>>>> have
>>>>> added VendorCommand(), and a debugger via ep0. ( ep0 is a good choice
>>>>> since it is available a boot, no matter what) and over the next few
>>>>> months I am going to move ->all<- the rom code into ram starting with
>>>>> the USB subsystem.
>>
>> Have you investigated whether you have enough RAM to do this?
>>
>> I haven't looked at ath9k_htc, but in general, that type of architecture
>> is tight on RAM in my experience.
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
