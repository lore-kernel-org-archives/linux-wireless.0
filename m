Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34743 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751953AbdEDHki (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 03:40:38 -0400
Received: by mail-it0-f66.google.com with SMTP id c26so752212itd.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 00:40:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJVZm6cEir9BGnhU7xyUmQvGUYxaRyKtQtNY8d_nfzwnnyusEQ@mail.gmail.com>
References: <CAJVZm6cEir9BGnhU7xyUmQvGUYxaRyKtQtNY8d_nfzwnnyusEQ@mail.gmail.com>
From: Menion <menion@gmail.com>
Date: Thu, 4 May 2017 09:40:17 +0200
Message-ID: <CAJVZm6dn3oux1D1t9+fiEJzhBhi=cSvozn=XFVVvE9TBZFPMSA@mail.gmail.com> (sfid-20170504_094136_784593_CDCDF849)
Subject: Fwd: mwl8k driver issue: frequent disconnect with Android phone
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello
Actually I was trying to workaround the below problem using WPA2-EAP.
But the PEAP-mschapv2 doesn't work with mwl8k driver on 5Ghz radio
My setup include two different Cisco/Linksys EA4500 running LEDE
17.01.1 and one TPLink WDR3600 with ath9x radios
The EA4500 chipset is Marvell 88W8366 v48.
Well with both 5Ghz radio of my two EA4500 the PEAP MSCHAPV2
authentication fails at the certificates exchange
This is the log I see in freeradius 2

Wed May 3 21:17:26 2017 : Debug: Going to the next request
Wed May 3 21:17:26 2017 : Debug: Waking up in 4.9 seconds.
Wed May 3 21:17:31 2017 : Info: Cleaning up request 34 ID 41 with timestamp +574
Wed May 3 21:17:31 2017 : Info: Cleaning up request 35 ID 42 with timestamp +574
Wed May 3 21:17:31 2017 : Info: Cleaning up request 36 ID 43 with timestamp +574
Wed May 3 21:17:31 2017 : Debug: WARNING:
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Wed May 3 21:17:31 2017 : Debug: WARNING: !! EAP session for state
0xd1f19d03d34c849e did not finish!
Wed May 3 21:17:31 2017 : Debug: WARNING: !! Please read
http://wiki.freeradius.org/guide/Certificate_Compatibility
Wed May 3 21:17:31 2017 : Debug: WARNING:
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Wed May 3 21:17:31 2017 : Info: Ready to process requests.

On hostapd size the logs say that the radius response is received but
the next stage never arrives.
Using the same freeradius 2 I can get PEAP working with the 2.4Ghz
radio with no issue and most important with both 2.4Ghz and 5Ghz radio
on wdr3600, that run the same LEDE release (same kernel) and the same
userland app, so it seems that the problem is really in the
interaction between the mwl8k driver, 5Ghz radio and hostapd and
freeradius.
The problem is shared by two android device (one 7.0.1 and one 6.1)
and and iPhone 7.
Can anyone follow me on the troubleshooting?
Bye

---------- Forwarded message ----------
From: Menion <menion@gmail.com>
Date: 2017-04-30 9:51 GMT+02:00
Subject: mwl8k driver issue: frequent disconnect with Android phone
To: linux-wireless@vger.kernel.org


Hi all
I would like to recall to attention an issue that various user are
observing running mwl8k driver together with android clients
Relevant information can be found here:

https://dev.openwrt.org/ticket/21284
http://www.spinics.net/lists/linux-wireless/msg151171.html

Unfortunately I don't have other information to add, logs on my sistem
which is a kirkwood router running kernel 4.4.x with Lede are
identical to the ones already provided.
I can add that the problem seems to get worst depending on the
bandwidth usage (higher is worst).
And I can confirm that apparently only android clients are affected,
in the sense that here I have also iPhones and some IP WebCam that
work rock stable with the same router.
Also both 5Ghz and 2.5Ghz radio are affected
Userland seems to have no influence, I have tried wpad and hostapd,
both show the problem
Let me know how can I help
Bye
