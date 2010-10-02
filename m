Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58984 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab0JBC44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 22:56:56 -0400
Received: by wyb28 with SMTP id 28so3545905wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 19:56:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010020452.24306.chunkeey@googlemail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
 <201010020226.08493.chunkeey@googlemail.com> <AANLkTinrbFLFN7PsVYpxGrnp0==FYVHGdbOBAXsKGWsv@mail.gmail.com>
 <201010020452.24306.chunkeey@googlemail.com>
From: Saqeb Akhter <saqeb.akhter@gmail.com>
Date: Fri, 1 Oct 2010 22:56:35 -0400
Message-ID: <AANLkTin2ycTicNim+ZiwNV3pWr7AQWPp432vJVLUL1k1@mail.gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nope I already noticed that 1.8.8.3 was available so to that step, I
am getting frequent disconnects though, it might have to do with
NetworkManager doing background scanning so going to try and it it to
stop doing that.

The NetGear driver on windows seems to ignore the WMM requirement
looks like. Either way that's what the problem was, going to see if i
can get this disconnect problem sorted out.

On Fri, Oct 1, 2010 at 10:52 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 02 October 2010 04:32:04 Saqeb Akhter wrote:
>> ------------------------------------------------------------
>> Client connecting to 192.168.10.52, TCP port 5001
>> TCP window size: 16.0 KByte (default)
>> ------------------------------------------------------------
>> [  3] local 192.168.10.60 port 50647 connected with 192.168.10.52 port 5001
>> [ ID] Interval       Transfer     Bandwidth
>> [  3]  0.0-10.0 sec  98.6 MBytes  82.6 Mbits/sec
>>
>> Seems to be doing a lot better now thanks :)
> Hm, I'm not too optimistic. After all, it took a long time to get to this
> point and even now the driver isn't "stable" yet (hence the EXPERIMENTAL
> flag).
>
>> I was not aware the WMM extensions were needed to get HT working.
> ;)
>
> I think 802.11n says somewhere, something like:
> "An HT STA is also a QoS STA"
>
> And QoS is enabled/setup by WMM.
>> I ended up upgrading my distro to 10.10 RC, and compiling the
>> compat-wireless u posted, and enable WMM extensions on my router.
>> Working considerably better :)
>
> One more thing: I've updated the firmware to 1.8.8.3
> http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary
> (In case you are still using the original 1.8.8.1)
>
> Best Regards,
>        Christian
>
