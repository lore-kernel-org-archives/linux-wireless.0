Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35325 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbeC2EeA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 00:34:00 -0400
MIME-Version: 1.0
From: YIN Wei <yinwei168@gmail.com>
Date: Thu, 29 Mar 2018 12:33:59 +0800
Message-ID: <CAFxU49nekm=8riJyqypGjZ2Hj8HfH5Z2aKfDdZm9UQuM6tfahQ@mail.gmail.com> (sfid-20180329_063410_248493_43A24346)
Subject: how to disable DIFS and Backoff in 802.11 ath9k or ath5k driver
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear All,

I am a researcher on 802.11 network security. I am doing a project
where the first two stations are communicating and the third station
tries to inject an forged 802.11 ACK if the last data frame is lost.
The ACK must be arrived to the data sender before the ACK timer
expires. Therefore the third station should not wait for a DIFS and a
random backoff to send out the ACK.
I am using ath9k driver, I found two functions
ath9k_hw_set_sifs_time() and ath9k_hw_setslottime() in the Hw.c file
in the ath9k directory, which set the SIFS and  backoff slot time in
the registers.. I search all the ath9k files and found no register is
for setting the DIFS. but the DIFS is can be calculated by DIFS = SIFS
+ 2 * Slot Time.  Therefore I thought the wireless chips should
calculate DIFS this way.  I used to believe that I solved the problem
by just setting the two registers.  However,when I capture the raw
frames using the airdump-ng ( an aircrack-ng module) and found that it
takes more than 80 microseconds to appear after the data, which is
much longer than the ACK timer out. The ACK timeout is usually 30
microseconds. So  the third station is forced by me to send out a
forged ACK at around 25 microsecond.

Can any one tell me whether I am doing the right way to make the third
station not follow the 802.11 backoff. any suggestion would be much
appreciated. Thank you.

Regards,
Wei
