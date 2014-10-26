Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64851 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaJZMAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2014 08:00:00 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so4687726lbg.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2014 04:59:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 26 Oct 2014 19:59:58 +0800
Message-ID: <CAFf6pmS5w5jDr6O_ut7k5P6xbd9q9q1+H4iucihO2E8rq5kGfQ@mail.gmail.com> (sfid-20141026_130005_366122_52F340E8)
Subject: p2p doesn't work at 5GHz by using mwifiex driver
From: QW <qiuyew@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I have a wifi/BT combo module with Marvell's SD8787 dual frequency
(2.4GHz and 5GHz) chipset on it.

When I try to build a p2p connection with other 5Ghz capable wireless
device (Nexus 4), the connection will never be built at 5GHz.
Same module I install on a linux-pc platform with kernel version
3.17.1 has no problem to build a 5G p2p connection.

The firmware I am using is from the Marvell git repo at
git://git.marvell.com/mwifiex-firmware.git
Using this latest commit:

commit 3f45b8c4cc1eb1d102bc3486b19677332dd215ab
Author: Avinash Patil <patila@marvell.com>
Date:   Fri Sep 12 21:05:15 2014 +0530

linux-firmware: update Marvell SD8787 firmware version p52

Version 14.66.35.p52
Note that this version doesn't support BT-AMP.
The image can be downloaded through either WLAN or Bluetooth.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>

With iw phy phy0 info, I can see that 5GHz frequency is listed. And I
can also use this module to connect a 5G wireless router without
problem.

The mwifiex driver is from kernel version 3.10.44, which is not
allowed to be upgraded to the latest kernel version. I cannot use
backports either, due to the 3.10 version.

Besides, there is an sdio error occurs very often when a p2p
connection is being built:

[20525.984188] mwifiex_sdio mmc0:0001:1: 2022598 : Tx timeout(#1),
bss_type-num = 2-0

then the p2p connection will be failed to be built with the error:

<3>P2P-GROUP-FORMATION-FAILURE
<3>P2P-GROUP-REMOVED wlan0 GO reason=FORMATION_FAILED

I don't know if this is related to the no-5GHz issue.

Any ideas? Thanks!

Cheers,
Qiuye
