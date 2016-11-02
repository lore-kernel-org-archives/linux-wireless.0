Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35062 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754324AbcKBO2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:28:00 -0400
Received: by mail-oi0-f47.google.com with SMTP id x4so18451490oix.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2016 07:27:59 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Wed, 2 Nov 2016 15:27:58 +0100
Message-ID: <CAHdg3xa1uOuBoncz5YwLRmC-HWMsuVmNkWoPB=0tWavcpWNkgQ@mail.gmail.com> (sfid-20161102_152803_373525_879FEE3C)
Subject: ath10k and compex WLE600V5-27
To: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I'm using two WiFi module Compex WLE600V5-27
http://www.compex.com.sg/product/wle600v5-27/
capable of 2x2 MIMO on two boards (Gateworks ventana 5410) using ath10k drivers.
The chipset is the Qualcomm-Atheros QCA9882 but I didn't find a
firmware for this chipset, so I'm using the QCA988X.
Everithing worked fine until I tried to plug 2 antennas in both cards
in order to make some data-rate tests. Even if there are two antennas
plugged in, there aren't any changes in the data-rate measured between
using one or two antennas. Sniffing the channel I sow that the Number
of STBC streams is 1 and iw list shows that only 1 spatial stream is
supported (but the card is capable of managing 2 spatial streams):

Wiphy phy0
    Band 1:
        Capabilities: 0x19e3
            RX LDPC
            HT20/HT40
            Static SM Power Save
            RX HT20 SGI
            RX HT40 SGI
            TX STBC
            RX STBC 1-stream
            Max AMSDU length: 7935 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
        Frequencies:
            * 5180 MHz [36] (17.0 dBm)
            * 5200 MHz [40] (17.0 dBm)
...

    Available Antennas: TX 0x3 RX 0x3
    Configured Antennas: TX 0x3 RX 0x3
    Supported interface modes:
         * managed
         * AP
         * AP/VLAN
         * monitor
         * mesh point


I tried the tests both on channel 48 HT40- and 149 HT40+.
The RSSI measured with iw station dump lays around -40dBm

Is it an issue related to the firmware in use?
Or maybe there aren't the right conditions to have MIMO working?

Thanks in advence
All the best

Matteo
