Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43748 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0JAWeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 18:34:31 -0400
Received: by wwj40 with SMTP id 40so1983494wwj.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 15:34:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimZYgDLLag+uGgdojrckZ5tgySC+UeyHCfee74J@mail.gmail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
 <AANLkTinpJ2qzR3D6Oe1WOS60sfRergfH548EMdB2m=_P@mail.gmail.com>
 <201010011636.58033.chunkeey@googlemail.com> <AANLkTimZYgDLLag+uGgdojrckZ5tgySC+UeyHCfee74J@mail.gmail.com>
From: Saqeb Akhter <saqeb.akhter@gmail.com>
Date: Fri, 1 Oct 2010 18:34:09 -0400
Message-ID: <AANLkTikrye+9ip1UUvwqH1-pY36DHzKRzadDQ1_RxN3F@mail.gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below is the out put from iperf on windows (about 3x faster).

Not sure what to do to get better throughput...is this considered a
bug or a lacking feature ?

It looks like its maxing out at 54MB/s on a 5Ghz AP, makes me wonder
if its using 802.11a, in lieu of 802.11n ?

-------------------------------------------------------------------------------
------------------------------------------------------------
Client connecting to 192.168.10.52, TCP port 5001
TCP window size: 63.0 KByte (default)
------------------------------------------------------------
[148] local 192.168.10.60 port 50087 connected with 192.168.10.52 port 5001
[ ID] Interval       Transfer     Bandwidth
[148]  0.0-10.0 sec  76.0 MBytes  63.7 Mbits/sec  (Windows 7)

-------------------------------------------------------------------------------
------------------------------------------------------------
Client connecting to 192.168.10.52, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.10.60 port 42587 connected with 192.168.10.52 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  25.5 MBytes  21.3 Mbits/sec (Ubuntu)

-------------------------------------------------------------------------------
sakhter@sakhter-laptop:~$ iw dev wlan2 link
Connected to 30:46:9a:10:49:f7 (on wlan2)
   SSID: sakhter-5g
   freq: 5200
   RX: 222040 bytes (949 packets)
   TX: 12082 bytes (77 packets)
   signal: -45 dBm
   tx bitrate: 54.0 MBit/s

> On Fri, Oct 1, 2010 at 10:36 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
>>
>> On Friday 01 October 2010 16:22:45 Saqeb Akhter wrote:
>> > Hey Guys,
>> >
>> > I just got around to compiling compat-wireless on ubuntu 10.04, to
>> > make use of the new carl9170 driver which is supposed to be able to
>> > handle 802.11n.
>> >
>> > My router is a wndr3700 running @ 5ghz on windows I'm able to get
>> > pretty good speeds. But on Ubuntu it does not seem to connect faster
>> > than 54MB/s, iwlist scan shows that 54Mb/s is the highest it can go.
>> sure, that's a limitation of iwlist. If you want to know the current
>> link speed (link speed as in "the last used tx rate", so if there's
>> no traffic then the rate is low) you should be using the "iw" utility:
>>
>> iw dev wlanX link
>>
>> Regards,
>>        Chr
>
>
