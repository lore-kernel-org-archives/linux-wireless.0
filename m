Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34325 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbGMOSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 10:18:39 -0400
Received: by wibud3 with SMTP id ud3so31133197wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 07:18:38 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jul 2015 23:18:38 +0900
Message-ID: <CANnKGXifAbn3oDYd99O6Hxo=yM9dGQmKJVuOC7FpVR7Utyp=0w@mail.gmail.com> (sfid-20150713_161842_655220_97488A20)
Subject: A bug about multicast power save transmitting
From: Gyujin Lee <gjlee@mwnl.snu.ac.kr>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Firstly, I want to apologize for any mistakes I make this mail.
This is the first mail I have posted

My WiFi chipset:
Qualcomm Atheros AR9380/HB112

Device driver: ath9k (backports-4.1-rc1-1)


In power save multicast transmission, I want to increase the number of
transmitted multicast packets at a time.
So, I extend the max_duration of "ath_tx_cabq" function in the file
/drivers/net/wireless/ath/ath9k/xmit.c

void ath_tx_cabq{
...
line 2437      sc->cur_chan->beacon.dtim_period / ATH_BCBUF
              => sc->cur_chan->beacon.dtim_period
     // Eliminate ATH_BCBUF
...
}

Then, multicast packets can be transmitted over one beacon interval.
(DTIM interval is not zero)

In this case, some of next multicast packets are transmitted before
next DTIM beacon.
(If multicast transmission ends in a beacon interval, all of next
multicast packets are transmitted after next DTIM beacon)

For example, if PHY rate for multicast transmission is 6Mb/s, 3
multicast packets are transmitted before DTIM beacon and other packets
are transmitted after DTIM beacon.


Is this phenomenon an error of this chipset?

Can I fix this error via modifying device driver?


Thank you.

Regards,
Gyujin Lee

--
