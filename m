Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33131 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2DWE1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 00:27:04 -0400
Received: by qcro28 with SMTP id o28so6685483qcr.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 21:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204201959.56495.chunkeey@googlemail.com>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
	<201204201959.56495.chunkeey@googlemail.com>
Date: Mon, 23 Apr 2012 06:27:03 +0200
Message-ID: <CAFED-jkFtT2agUpymwWN-srTVH+wkh7bbkgkxQg9e4vy+q-Xvw@mail.gmail.com> (sfid-20120423_062709_111941_72F1C6FE)
Subject: Re: carl9170 - monitor mode TP drop
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 kwietnia 2012 19:59 u¿ytkownik Christian Lamparter
<chunkeey@googlemail.com> napisa³:
> On Friday 20 April 2012 09:41:15 Janusz Dziedzic wrote:
>> Hello,
>>
>> I am using newest compat-wireless + newest-firmware.
>> Next I setup monitor mode + channel and run wireshark - I do that to
>> record TCP flow on the channel.
>>
>> Before that I had TCP throughput about 30Mbit/s and after run
>> wireshark I see TP drop - about 3Mbit/s (after setting monitor mode).
>> This TP is between AP and other STA on the same channel.
>>
>> Should I set/check something more to not see this TP drop?
>
> Well, I don't know how you exactly setup the mode. But If
> the monitor interface is set to PROMISC, then it's likely
> that the hardware will be set into a special "sniffer"
> operation mode. This mode is great if you are interested in
> frames with bad PLCPs and FCS but it is not so great for
> throughput because the rx filter won't filter anymore and
> the tons of garbage that usually is dropped early on gets
> passed to the host and on it's way it competes for FIFO
> resources with the data.
>
> (One more thing: Isn't it possible to get the TCP flow,
> from the "ethernet" (as ifconfig calls it) interface of
> the wlan device as well?)
>

This is a scenario:
AP <--> STA1 (channel 6)
STA2 == carl_monitor (channel 6)

This is what I can see on STA1:
# iperf -c 192.168.254.1 -t 100 -i 5
------------------------------------------------------------
Client connecting to 192.168.254.1, TCP port 5001
TCP window size:  512 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.181 port 46048 connected with 192.168.254.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  17.4 MBytes  29.2 Mbits/sec
[  3]  5.0-10.0 sec  19.6 MBytes  32.9 Mbits/sec
[  3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
[  3] 15.0-20.0 sec  19.8 MBytes  33.1 Mbits/sec
[  3] 20.0-25.0 sec  19.8 MBytes  33.1 Mbits/sec
[  3] 25.0-30.0 sec  19.8 MBytes  33.1 Mbits/sec
[  3] 30.0-35.0 sec  19.6 MBytes  32.9 Mbits/sec
[  3] 35.0-40.0 sec  18.1 MBytes  30.4 Mbits/sec

=====> here I setup carl monitor on second PC, like this:
=====> iw dev wlan0 set type monitor
=====> iw dev wlan0 set freq 2437
=====> ifconfig wlan0 up

[  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
[  3] 45.0-50.0 sec  2.50 MBytes  4.19 Mbits/sec
[  3] 50.0-55.0 sec  3.00 MBytes  5.03 Mbits/sec

Seems I don't even need to start wireshark here ... and see this TP drop.


BR
Janusz
