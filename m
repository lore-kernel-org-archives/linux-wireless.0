Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35408 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdCEG2w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Mar 2017 01:28:52 -0500
Received: by mail-io0-f194.google.com with SMTP id f103so10776249ioi.2
        for <linux-wireless@vger.kernel.org>; Sat, 04 Mar 2017 22:28:51 -0800 (PST)
MIME-Version: 1.0
From: GaoQiang <forgaoqiang@gmail.com>
Date: Sun, 5 Mar 2017 14:28:30 +0800
Message-ID: <CAFnTB9zLT7HCFqiMW=672o0+mmUK39G6wiv-e9q_aDJkvpAbTQ@mail.gmail.com> (sfid-20170305_072902_995714_4B578288)
Subject: atheros superchannel can not work in ap mode
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros 802.11 wifi chip can support superchannel.I can success use
2576mhz in monitor mode. I have success inject and catch packets from
mikrotik which support superchannel too.

But when use hostapd in ap mode. ath9k debug report:

 ath: phy0: Enabled BB Watchdog timeout (85 ms)
 ath: phy0: missed 1 consecutive beacons
 ath: phy0: missed 2 consecutive beacons
 ath: phy0: missed 3 consecutive beacons
 ath: phy0: missed 4 consecutive beacons
 ath: phy0: missed 5 consecutive beacons
 ath: phy0: missed 7 consecutive beacons
 ath: phy0: missed 8 consecutive beacons
 ath: phy0: beacon is officially stuck

The log comes from function:

void ath9k_beacon_tasklet(unsigned long data)

and then will call ath_reset.

I think freq is right in ar9003_hw_set_channel although i can not find
register description in the datasheet.

My chip is ar9330 macRev 1. In atheros datasheet, i cannot find wlan
related register. ar9330 is  AR9003 hardware familiy chip in ar9003_hw.c.
