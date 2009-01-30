Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:25863 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZA3OBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 09:01:45 -0500
Received: by yx-out-2324.google.com with SMTP id 8so171559yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 06:01:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e27b78a40901300446y294504d5kd7acaa6c5a26edd@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <45e8e6c40901231106t481c823ag3bbac67d8205ef7a@mail.gmail.com>
	 <e27b78a40901240804m1acd3a83o7bf6d01f81ec3397@mail.gmail.com>
	 <45e8e6c40901240956g68a5364tdbacc1e49410c9cc@mail.gmail.com>
	 <e27b78a40901260625w53acd646xeb5a9ca85555c74d@mail.gmail.com>
	 <e27b78a40901260956w4e69d33s7db60defc026c8d7@mail.gmail.com>
	 <45e8e6c40901280954l42bbe788y8723141d673bb7b3@mail.gmail.com>
	 <e27b78a40901300446y294504d5kd7acaa6c5a26edd@mail.gmail.com>
Date: Fri, 30 Jan 2009 14:01:43 +0000
Message-ID: <e27b78a40901300601p35d68125kfc3a10a7d7db0900@mail.gmail.com> (sfid-20090130_150148_131851_401545A8)
Subject: Re: Crashing on ping?
From: Keir <keirlawson@gmail.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could you send me the .config you are using? Just so i can make sure
my kernel is exactly the same?

Cheers

Keir

2009/1/30 Keir <keirlawson@gmail.com>:
> I did the following in my serial console:
>
> root@kyp:/home/keir/Desktop/iw-0.9.6# echo 8 > /proc/sys/kernel/printk
> root@kyp:/home/keir/Desktop/iw-0.9.6# ping -I mesh0 10.0.0.2
> PING 10.0.0.2 (10.0.0.2) from 10.0.0.3 mesh0: 56(84) bytes of data.
> 64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=2.67 ms
> 64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.550 ms
> 64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=0.445 ms
> 64 bytes from 10.0.0.2: icmp_seq=4 ttl=64 time=6.28 ms
> 64 bytes from 10.0.0.2: icmp_seq=5 ttl=64 time=2.19 ms
>
> At which point the console freezes with no further output.
>
> Any ideas?
>
> Cheers
>
> Keir
>
> 2009/1/28 Andrey Yurovsky <andrey@cozybit.com>
>>
>> Hi Keir.  If the system really crashes, you should have some output.
>> Can you please set:
>>
>> echo 8 > /proc/sys/kernel/printk
>>
>> ...and use your serial console and try to reproduce this?  Thanks,
>>
>>  -Andrey
>>
>> On Mon, Jan 26, 2009 at 9:56 AM, Keir <keirlawson@gmail.com> wrote:
>> > Right, managed to set up a serial terminal, ran cat /proc/kmsg, but
>> > still no output of interest (just mesh plink stuff leading up to the
>> > connection being established), what should I do next?
>> >
>> > Cheers
>> >
>> > Keir
>> >
>> > 2009/1/26 Keir <keirlawson@gmail.com>:
>> >> "sudo cat /proc/kmsg > log" doesnt produce anything of interest.
>> >>
>> >> Will look into the serial console thing, never done it before.
>> >>
>> >> Keir
>> >>
>> >> 2009/1/24 Andrey Yurovsky <andrey@cozybit.com>:
>> >>> Can you post logs of the crash (dmesg output)?  You may need to
>> >>> connect a serial console to the PC in question to get them if the
>> >>> machine is really hard-locking, otherwise see if you can capture the
>> >>> output of dmesg
>> >>>
>> >>> On Sat, Jan 24, 2009 at 8:04 AM, Keir <keirlawson@gmail.com> wrote:
>> >>>> Tried that commit, still no luck :( It consistently freezes up on
>> >>>> ping, though sometimes it's the machine doing the pining, and other
>> >>>> times it's the machine being pinged.  Wondering what I can do to help
>> >>>> debug this?
>> >>>>
>> >>>> Keir
>> >>>>
>> >>>> 2009/1/23 Andrey Yurovsky <andrey@cozybit.com>:
>> >>>>> Hi Keir.  Incidentally, we're using ath5k mesh right now at commit
>> >>>>> 93bd2ac7301b0879821e584991f82de372d62bf6 (that's just after the
>> >>>>> 2.6.29-rc1 tag but before -rc2) an things work fine.  I haven't had a
>> >>>>> chance to try head of wireless-testing this week.
>> >>>>>
>> >>>>>  -Andrey
>> >>>>>
>> >>>>> On Fri, Jan 23, 2009 at 8:03 AM, Keir <keirlawson@gmail.com> wrote:
>> >>>>>> I just pulled the latest wireless-testing kernel, however, much like
>> >>>>>> the previous wireless-testing kernel I was working on, when attempting
>> >>>>>> to ping one node from another on a mesh, using ath5k, the node
>> >>>>>> attempting to ping completely freezes after about 7 pings are
>> >>>>>> (succesfully) sent.  Anyone have any idea what is going wrong here?
>> >>>>>>
>> >>>>>> Cheers
>> >>>>>>
>> >>>>>> Keir
>> >>>>>> --
>> >>>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> >>>>>> the body of a message to majordomo@vger.kernel.org
>> >>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>>>>>
>> >>>>>
>> >>>>
>> >>>
>> >>
>> >
>
