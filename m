Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34701 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbbETDnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 23:43:50 -0400
Received: by qctt3 with SMTP id t3so17762880qct.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 20:43:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0rRqbks5LDiUjekTEjXV5nQoc1iSr4PhWd0cek7AnWQQ@mail.gmail.com>
References: <CALWn1pu8U1o=J=j8Uunf7-hLNZV2Pv2mxJx11O_psZArij-qNw@mail.gmail.com>
	<CANUX_P3XPLvLhYy7pb9_LXjEynfNjgzhbW3zFYfxVCjcjGNczw@mail.gmail.com>
	<CALWn1pt-neiJhrQcEES4cktcfyL0+c2B=GUAh8+Xo0L06VmsfA@mail.gmail.com>
	<CANUX_P0rRqbks5LDiUjekTEjXV5nQoc1iSr4PhWd0cek7AnWQQ@mail.gmail.com>
Date: Wed, 20 May 2015 11:43:49 +0800
Message-ID: <CALx5=V891GJAH499qLV+RiJPg3vftt5yrp_rdKyOyn+1aidtpw@mail.gmail.com> (sfid-20150520_054353_851168_DE7405F6)
Subject: Re: Failed to capture data packets using Monitor mode with Intel 7260
 card. (Under Ubuntu 14.04)
From: Matt Chen <mattsled@gmail.com>
To: darklight wu <darklightwu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

probably you need to disable your NetworkManager and wpa_supplicant.
Then switch/change your mode to monitor. Make sure the command "iw
[interface_name] info" shows you the type is monitor.

2015-05-20 1:41 GMT+08:00 Emmanuel Grumbach <egrumbach@gmail.com>:
> On Tue, May 19, 2015 at 7:44 PM, darklight wu <darklightwu@gmail.com> wrote:
>> On Mon, May 18, 2015 at 3:26 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> On Mon, May 18, 2015 at 10:01 AM, darklight wu <darklightwu@gmail.com> wrote:
>>>> Hi, All:
>>>>
>>>> I configured the Wifi Monitor mode with Intel 7260 card under
>>>> Ubuntu14.04 and then used Wireshark to capture packets from air. But I
>>>> could only get management/control packets but no data packets. I tried
>>>> different channels and also with HT20 or HT40+/-.
>>>>
>>>> The commands I used were:
>>>>
>>>> iw dev wlan0 interface add mon0 type monitor
>>>> iw dev wlan0 del  //I googled and was told I needed to delete the
>>>> wlan0 first. Or else I got device busy (-16) error
>>>> ifconfig mon0 up
>>>> iw dev mon0 set channel 1
>>>>
>>>> I also tried to use other ways like "airmon-ng start wlan0". All the
>>>> observations were same, no data packets. It's weird! Anyone has a
>>>> clue?
>>>>
>>>
>>> This is weird. But I recommend to add power_scheme=1 as a module
>>> parameter to iwlmvm. Since iwlmvm is loaded automatically, you'll need
>>> to add that to /etc/modprobe.d/iwlwifi.conf.
>>> 14.04 ships 3.13 and I remember we had issues with monitor mode at
>>> that time. You may want to try a newer kernel.
>>
>> I tried again today with "power_scheme=1" and also booted with Ubuntu
>> 15.04. Both still failed to work in monitor mode. And with Ubuntu
>> 15.04, I event could not configure the nic to work on monitor mode.
>> The same commands at least can set the monitor mode under 14.04.
>> Meanwhile, I just want to clarify, the nic could capture data packets
>> to/from itself but could not capture others that were not belongs to
>> it. My co-worker tried on another machine with Ubuntu 14.04, he was
>> also failed.
>>
>> Any tricks here?
>
> You must not have any interface besides the monitor interface. I bet
> you still have the wpa_supplicant running and this is why you only
> have a virtual monitor interface that catches the packet from your
> managed interface only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
