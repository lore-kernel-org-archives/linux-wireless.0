Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49788 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZKWPly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 10:41:54 -0500
Received: by pwi3 with SMTP id 3so3487339pwi.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 07:42:00 -0800 (PST)
Message-ID: <4B0AAD44.2090908@lwfinger.net>
Date: Mon, 23 Nov 2009 09:41:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
References: <200911192224.29491.mb@bu3sch.de> <4B0A137B.7050604@lwfinger.net> <200911231149.38494.mb@bu3sch.de> <5A2C6B7F-5617-49AA-B22A-A5574D6CD9FA@ing.unibs.it>
In-Reply-To: <5A2C6B7F-5617-49AA-B22A-A5574D6CD9FA@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2009 05:00 AM, Francesco Gringoli wrote:
> 
> so you can observe this behavior at your site. Do you mind describing
> the exact configuration? Maybe this time I can reproduce this behavior,
> as I tried everything to make it happen. I also asked Larry one of his
> boards and put it into several PCs but had no chance to reproduce the
> crash. Could you please also report the neighboring stations, the AP you
> are connected and so on.

As Michael said, I was the one that reported the behavior. My card was a BCM4318
in a Cardbus format running V5.2 of the openfwwf. The AP is a Linksys WRT54G V5
running standard firmware v1.02.6. A list of nearby AP's with channels and
strengths are as follows:

          Cell 01 - Address: 00:14:BF:85:49:FA
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=70/70  Signal level=-6 dBm
                    Encryption key:on  (WPA2)
                    ESSID:"lwfdjf_rad"
          Cell 02 - Address: 00:1B:11:5C:B0:83
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=25/70  Signal level=-85 dBm
                    Encryption key:on   (WEP)
                    ESSID:"Browns"
          Cell 03 - Address: 00:1A:70:46:BA:B1
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=42/70  Signal level=-68 dBm
                    Encryption key:on    (WEP)
                    ESSID:"Larry with space"
          Cell 04 - Address: 00:23:69:81:B7:D9
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=34/70  Signal level=-76 dBm
                    Encryption key:on    (WEP)
                    ESSID:"Hoover"
          Cell 05 - Address: 00:14:BF:0C:7E:14
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=28/70  Signal level=-82 dBm
                    Encryption key:on     (WPA)
                    ESSID:"linksys"
          Cell 06 - Address: 00:22:6B:78:18:7D
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=26/70  Signal level=-84 dBm
                    Encryption key:on     (WPA)
                    ESSID:"Go Away"

I was connected to the AP in Cell 01. The test was my usual with a repeating
tcpperf run in one terminal and a flood ping to the same server in a second.
Please let me know if I missed any useful information.

This condition may take a long time to show up. For instance, my latest test ran
for 25 hours before failure. All other tests have failed much more quickly, but
one never knows. I have not seen this failure with standard firmware.

Larry

Larry





