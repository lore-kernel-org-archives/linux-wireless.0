Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36166 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbeHJVmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 17:42:25 -0400
Received: by mail-it0-f50.google.com with SMTP id p81-v6so4115992itp.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2018 12:11:16 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Fri, 10 Aug 2018 21:11:05 +0200
Message-ID: <CAJVZm6cZ5yF+PjiMMnVmcu0MhOmaMFWV2E9EaK3=k4ogo3Lj6Q@mail.gmail.com> (sfid-20180810_211120_041707_C2190EF1)
Subject: mwl8k: Expand non-DFS 5G channels (linux master commit 4628257)
To: linux-wireless@vger.kernel.org
Cc: waveletboy@gmail.com, kvalo@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all
I have backported the commit above on the 4.14.x kernel used by
Openwrt 18.06.x image family.
I planned to use it with my kirkwood based router, linksys ea4500,
which use mwl8k to control two radio, 2.4Ghz and 5Ghz, based on
88W8366 (see: https://wiki.openwrt.org/toh/linksys/ea4500)
I built the image and loaded it on my routers (actually I have two ea4500)
Unfortunately only the old 4 ch shows as supported.
My question is if the modification should be enough to unlock higher
non DFS channels, or if I require some other patches, or maybe new
firmware.
In case suggestions to troubleshoot the problem are appreciated
Bye

Following the "iw list" output for the 5Ghz radio

Wiphy phy1
        max # scan SSIDs: 4
        max scan IEs length: 2261 bytes
        max # sched scan SSIDs: 0
        max # match sets: 0
        max # scan plans: 1
        max scan plan interval: -1
        max scan plan iterations: 0
        Retry short limit: 7
        Retry long limit: 4
        Coverage class: 0 (up to 0m)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
        Band 2:
                Capabilities: 0xffe
                        HT20/HT40
                        SM Power Save disabled
                        RX Greenfield
                        RX HT20 SGI
                        RX HT40 SGI
                        TX STBC
                        RX STBC 3-streams
                        HT Delayed Block Ack
                        Max AMSDU length: 7935 bytes
                        No DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: No restriction (0x00)
                HT TX/RX MCS rate indexes supported: 0-23, 32
                Frequencies:
                        * 5180 MHz [36] (20.0 dBm)
                        * 5200 MHz [40] (20.0 dBm)
                        * 5220 MHz [44] (20.0 dBm)
                        * 5240 MHz [48] (20.0 dBm)
        valid interface combinations:
                 * #{ AP } <= 8, #{ managed } <= 1,
                   total <= 8, #channels <= 1
        HT Capability overrides:
                 * MCS: ff ff ff ff ff ff ff ff ff ff
                 * maximum A-MSDU length
                 * supported channel width
                 * short GI for 40 MHz
                 * max A-MPDU length exponent
                 * min MPDU start spacing
