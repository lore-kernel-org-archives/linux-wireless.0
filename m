Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33834 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdBNTlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 14:41:02 -0500
Received: by mail-it0-f66.google.com with SMTP id r141so6770230ita.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 11:41:02 -0800 (PST)
MIME-Version: 1.0
From: Gucea Doru <gucea.doru@gmail.com>
Date: Tue, 14 Feb 2017 21:41:00 +0200
Message-ID: <CANfLQrbhbn9UavS1sDDhp9wZyoNQN5MdGzXhKywLJApJ8MTwWQ@mail.gmail.com> (sfid-20170214_204105_748439_8335424D)
Subject: Power Save for Multi-VIF
To: linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw@lists.infradead.org
Cc: Andra Paraschiv <andra.paraschiv7@gmail.com>,
        Costin Raiciu <costin.raiciu@cs.pub.ro>,
        Dragos N <dragos.niculescu@cs.pub.ro>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, everyone

I try to design a Power Save Algorithm in the case of a mobile client
that has multiple virtual interfaces [1] and is connected to multiple
Access Points simultaneously. My implementation is for the Atheros
AR9271 WiFi chip.

The biggest challenge in implementing this algorithm is waking up the
WiFi chip for RX traffic. E.g.: the WiFi chip is in the sleep state
and it has to wake up in order to receive beacons from all the APs
that the client is connected to.

Reading the AR9271 datasheet [2] I noticed that the chip is equipped
with hardware timers for waking up the hardware. The registers for
programming these hardware timers are MAC_PCU_SLP1 and MAC_PCU_SLP2.
After the registers have been programmed, the RTC_FORCE_WAKE bit has
to be cleared in order to allow the card to enter sleep mode (at least
this is how is done in the existing implementation for the single VIF
scenario).

I used the logic above for programming the hardware to wake up for
beacons from multiple APs. I used a power device for measuring the
energy consumption and it seems that the WiFi card wakes up
periodically to receive beacons from multiple APs. The problem is that
after a time, out of nowhere, the WiFi card refuses to enter sleep
mode and stays just in the awake state, although the logic for
programming the hardware timers does not change.

Could someone give more details about the FORCE_WAKE signal and what
is the relation between this signal and the MAC and RTC layers? I
believe that the problem comes from here. The AR9271 datasheet just
references this signal (page 106) but it offers no details about it.

[1] https://github.com/doru91/linux-stable/wiki/Two-Interfaces-Power-Save
[2] https://wikidevi.com/wiki/Atheros_AR9271
[3] http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath9k/hw.c?v=4.9#L2068

Regards,
Doru
