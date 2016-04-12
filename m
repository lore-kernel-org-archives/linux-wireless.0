Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp13.openmailbox.org ([62.4.1.47]:33610 "EHLO
	smtp13.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbcDLBxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 21:53:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 12 Apr 2016 01:53:34 +0000
From: Gustav Frederiksen <lkml2017@openmailbox.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Revert regression in ath9k on AR9281
In-Reply-To: <570BF557.40705@rempel-privat.de>
References: <998e52a27823047910627da08e917c06@openmailbox.org>
 <CAGRGNgVtD8PS7BePJ=RTbxOOYjqE39kChuhZxtOUO-S9Y95p6w@mail.gmail.com>
 <6567cc33c0ca681364c6510a7797c459@openmailbox.org>
 <570BF557.40705@rempel-privat.de>
Message-ID: <120e427452ad7e93f17828e8bba4b043@openmailbox.org> (sfid-20160412_035351_125567_4444E51C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-11 19:04, Oleksij Rempel wrote:
> Hi Gustav,
> 
> thank you for your work.
> Can you please test attached patch.
> 


Hi Oleksij,

this report isn't much, on the other hand you were very quick to come up 
with a patch, well done.
The patch does work as expected. Laptop seems to enjoy its new zero'd 
bitmasks.

Thanks a lot for fixing this.

Regards,
Gustav Frederiksen

---

root@laptop:~# uname -a
Linux ubuntu 4.6.0-rc3-patched #3 SMP Tue Apr 12 01:18:11 UTC 2016 
x86_64 x86_64 x86_64 GNU/Linux


root@laptop:~# wget "http://proof.ovh.net/files/1Gio.dat" -O /dev/null
--2016-04-12 01:24:52--  http://proof.ovh.net/files/1Gio.dat
Resolving proof.ovh.net (proof.ovh.net)... 188.165.12.106, 
2001:41d0:2:876a::1
Connecting to proof.ovh.net (proof.ovh.net)|188.165.12.106|:80... 
connected.
HTTP request sent, awaiting response... 200 OK
Length: 1073741824 (1.0G) [application/octet-stream]
Saving to: '/dev/null'

10% [======>                                                             
        ] 111 327 650 8,27MB/s  eta 1m 55s ^C


root@laptop:~# iw dev wlan0 link
Connected to a4:c7:**:**:**:** (on wlan0)
         SSID: TEST_AP
         freq: 2462
         RX: 305637484 bytes (204447 packets)
         TX: 5724698 bytes (59216 packets)
         signal: -53 dBm
         tx bitrate: 65.0 MBit/s MCS 7

         bss flags:      short-preamble short-slot-time
         dtim period:    1
         beacon int:     400

---

