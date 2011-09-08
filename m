Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50159 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab1IHDY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 23:24:29 -0400
Received: by ewy4 with SMTP id 4so121908ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 20:24:27 -0700 (PDT)
Message-ID: <4E68353D.3010505@gmail.com> (sfid-20110908_052436_476646_856582A3)
Date: Thu, 08 Sep 2011 05:23:41 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: RTL8192SE and 802.11n problem
References: <4E67CE3F.8090405@gmail.com> <4E67CEA3.7020709@gmail.com> <4E682732.1040700@lwfinger.net> <4E682D68.1070408@lwfinger.net>
In-Reply-To: <4E682D68.1070408@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2011 04:50 AM, Larry Finger wrote:
> Stefan,
>
> I did finish the complete set of tests with my RTL8191SEvB Wireless
> LAN Controller [10ec:8172] (rev 10). The results for the tests are as
> follows:
>
> TCP_MAERTS:
>
> kernel 3.0.4:
>
> Results: TX: max 38.61, min 14.04. Mean 33.45(6.95)
>          RX: max 47.55, min 30.52. Mean 37.31(5.36)
>
> 3.1-rc4 - Mainline:
>
> Results: TX: max 57.70, min 42.90. Mean 52.79(3.92)
>          RX: max 68.77, min 47.29. Mean 60.38(5.28)
>
> 3.1-rc4 - wireless-testing:
>
> Results: TX: max 112.86, min 23.34. Mean 51.70(21.86)
>          RX: max 75.84, min 35.60. Mean 59.03(9.76)
>
> TCP_STREAM:
>
> Kernel 3.0.4:
>
> Results: TX: max 43.94, min 15.74. Mean 32.29(6.93)
>          RX: max 36.01, min 30.75. Mean 34.29(1.75)
>
> Kernel 3.1-rc4 from mainline:
>
> Results: TX: max 59.73, min 23.48. Mean 47.59(12.33)
>          RX: max 49.89, min 25.14. Mean 38.26(7.32)
>
> Kernel 3.1-rc4 from wireless-testing:
>
> Results: TX: max 62.39, min 57.27. Mean 60.69(1.62)
>          RX: max 53.00, min 23.95. Mean 43.17(8.56)
>
> TCP_SENDFILE:
>
> Kernel 3.0.4:
>
> Results: TX: max 30.06, min 20.21. Mean 28.36(2.87)
>          RX: max 38.28, min 29.56. Mean 34.36(2.79)
>
> Kernel 3.1-rc4 from mainline:
>
> Results: TX: max 70.25, min  2.64. Mean 42.59(18.30)
>          RX: max 44.85, min 33.12. Mean 40.83(4.04)
>
> Kernel 3.1-rc4 from wireless-testing:
>
> Results: TX: max 62.51, min 51.26. Mean 56.94(3.35)
>          RX: max 45.35, min 28.40. Mean 37.56(5.16)
>
> It seems that kernel 3.1-rc4 from mainline is quite a bit faster than
> 3.0.4, but I don't know why. The 3.1-rc4 driver from wireless-testing
> may be a bit quicker, but the difference is not that great.
>
> My next step will be to bisect the mainline tree to see if I can find
> a commit that has a big effect. Please open a bug at
> bugzilla.kernel.org on this issue, if you have not already done so,
> and send me the bug number.
>
> Larry
Before you continue down this path, I have to ask you something: do you
think the rate of my connection would increase if I stress it enough? By
this I mean: initially, it appears I have a (theoretical maximum)
bitrate of 54Mbps upon connecting to my AP; will the bitrate increase
when running something like netperf for long enough? If not, I'm not
sure you understood my problem. I don't mind the bitrate so much if it
weren't for the fact that I should be associating with my AP over an
802.11n link (since both my NIC and AP should be capable of this), which
I cannot. The AP itself (which can display a list of its wireless
clients including MAC addresses and link type) reports that I'm
connected over an 802.11g link.
I'd hate for you to put more time into this if we have indeed
misunderstood one another.

Anyway, I'm more than willing to try out the 3.1-rc4 mainline kernel if
that would be of any help. However, it will have to wait until tomorrow,
since it's pretty much the end of the night in my timezone, and I have a
busy day tomorrow. I'll also file a bug report tomorrow, if I haven't
heard back from you regarding our possible misunderstanding.
