Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36785 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932704AbdDZSFR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 14:05:17 -0400
Received: by mail-wm0-f44.google.com with SMTP id u65so58023805wmu.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 11:05:16 -0700 (PDT)
Subject: Fwd: Question on drivers using skb_unclone
References: <CAE_XsMJ=TAqgL767Agp0SjQCdSZ57pdh5KMkJ7Y-4V0XoSSa9Q@mail.gmail.com>
To: Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d76d6468-e5c3-4bd8-d746-b9c1fdd6e29e@broadcom.com> (sfid-20170426_200534_173604_C6F35FB8)
Date: Wed, 26 Apr 2017 20:05:14 +0200
MIME-Version: 1.0
In-Reply-To: <CAE_XsMJ=TAqgL767Agp0SjQCdSZ57pdh5KMkJ7Y-4V0XoSSa9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

Here the email which hopefully provides enough context.

Regards,
Arend

-------- Forwarded Message --------
Subject: 	Question on drivers using skb_unclone
Date: 	Fri, 14 Apr 2017 10:03:01 +0100
From: 	James Hughes <james.hughes@raspberrypi.org>
To: 	netdev@vger.kernel.org
CC: 	UNGLinuxDriver@microchip.com, brcm80211-dev-list.pdl@broadcom.com



Netdevs,

We have recently got to the bottom of an issue which we have been
encountering on a Raspberry Pi being used as an access point, and we
need a bit of advice on the correct way of fixing the issue.

The set up is a Raspberry Pi 3 running hostapd on its inbuilt wireless
adaptor (Brcm43438 ), bridged to the built in ethernet adaptor
(smsc9514). Using the standard drivers for these devices as of 4.9
(looking at 4.11, no changes noted that would affect the issue).

We were encountering an error in the Brcm Wireless driver that after
investigation was a skb_buff being corrupted by an action in the smsc
Ethernet driver. Further digging shows that the bridge was cloning an
incoming skb from the Ethernet, then sending it out to both the Ethernet
and wlan ports. This mean that both the Ethernet driver and the wireless
driver were looking at the same physical data, and one or both were
altering that data in different way (varied headers) , which mean that
headers were corrupted. This was only happening on broadcast packets.

We can fix the issue by, in the drivers, by using skb_unclone in
appropriate places in the driver.

So now to the questions. Is adding the unclone to the drivers the
correct way of dealing with this issue? Examining other drivers shows
that unclone is not particularly common, presumably in many cases, where
the driver does not alter the skb, it doesn't matter. However, in any
case where a driver may add header information to the skb (as is the
case with the Brcm wireless driver), when the incoming skb has been
cloned, the results must surely be undetermined unless an unclone is
performed.

Or, is the bridging code making a mistake by cloning the skb and passing
it to multiple recipients.


Thanks

James Hughes
Raspberry Pi
