Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60334 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab1IHCuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 22:50:20 -0400
Received: by gya6 with SMTP id 6so277758gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 19:50:19 -0700 (PDT)
Message-ID: <4E682D68.1070408@lwfinger.net> (sfid-20110908_045024_139311_5CCD1244)
Date: Wed, 07 Sep 2011 21:50:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: RTL8192SE and 802.11n problem
References: <4E67CE3F.8090405@gmail.com> <4E67CEA3.7020709@gmail.com> <4E682732.1040700@lwfinger.net>
In-Reply-To: <4E682732.1040700@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan,

I did finish the complete set of tests with my RTL8191SEvB Wireless LAN 
Controller [10ec:8172] (rev 10). The results for the tests are as follows:

TCP_MAERTS:

kernel 3.0.4:

Results: TX: max 38.61, min 14.04. Mean 33.45(6.95)
          RX: max 47.55, min 30.52. Mean 37.31(5.36)

3.1-rc4 - Mainline:

Results: TX: max 57.70, min 42.90. Mean 52.79(3.92)
          RX: max 68.77, min 47.29. Mean 60.38(5.28)

3.1-rc4 - wireless-testing:

Results: TX: max 112.86, min 23.34. Mean 51.70(21.86)
          RX: max 75.84, min 35.60. Mean 59.03(9.76)

TCP_STREAM:

Kernel 3.0.4:

Results: TX: max 43.94, min 15.74. Mean 32.29(6.93)
          RX: max 36.01, min 30.75. Mean 34.29(1.75)

Kernel 3.1-rc4 from mainline:

Results: TX: max 59.73, min 23.48. Mean 47.59(12.33)
          RX: max 49.89, min 25.14. Mean 38.26(7.32)

Kernel 3.1-rc4 from wireless-testing:

Results: TX: max 62.39, min 57.27. Mean 60.69(1.62)
          RX: max 53.00, min 23.95. Mean 43.17(8.56)

TCP_SENDFILE:

Kernel 3.0.4:

Results: TX: max 30.06, min 20.21. Mean 28.36(2.87)
          RX: max 38.28, min 29.56. Mean 34.36(2.79)

Kernel 3.1-rc4 from mainline:

Results: TX: max 70.25, min  2.64. Mean 42.59(18.30)
          RX: max 44.85, min 33.12. Mean 40.83(4.04)

Kernel 3.1-rc4 from wireless-testing:

Results: TX: max 62.51, min 51.26. Mean 56.94(3.35)
          RX: max 45.35, min 28.40. Mean 37.56(5.16)

It seems that kernel 3.1-rc4 from mainline is quite a bit faster than 3.0.4, but 
I don't know why. The 3.1-rc4 driver from wireless-testing may be a bit quicker, 
but the difference is not that great.

My next step will be to bisect the mainline tree to see if I can find a commit 
that has a big effect. Please open a bug at bugzilla.kernel.org on this issue, 
if you have not already done so, and send me the bug number.

Larry
