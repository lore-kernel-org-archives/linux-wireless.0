Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:33943 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756957AbdCTSHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 14:07:40 -0400
Received: by mail-ot0-f176.google.com with SMTP id o24so137277342otb.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 11:07:39 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Mon, 20 Mar 2017 19:00:26 +0100
Message-ID: <CAHdg3xbK-_gUAs=nnPYtgQmBCSu-VfR2GNgaYaPqd3qSh1wuwg@mail.gmail.com> (sfid-20170320_191029_928301_0C3340EA)
Subject: ath10k monitor mode issue
To: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have an issue to collect tx/rx bitrates using ath10k.
I want to collect Tx/RX statistics on a mesh network using
compexWLE900VX Wi-Fi miniPCIe adapters chipset QCA9884 (QCA988X) with
ath10k firmware firmware-5.bin_10.2.4.70.59-2.

The OS is Ubuntu 14.04 kernel 3.14.48 backports 4.4.2.

I'm able to build the mesh without any problem and I already have read
that ath10k firmware doesn't provide correct TX/RX information.
Using "iw <iunterface> station dump" I can see the tx bitrate stuck on
6Mbps and the rx giving unreliable information about MCS, NSS, bitrate
etc.
I tried using iw version 3.4, 3.6 and 4.9.

I really need to retrieve these info, and I tried also sniffing the
airtraffic with another ath10k interface. According to
https://wireless.wiki.kernel.org/en/users/drivers/ath10k/monitor I
should see the right radiotap headers, since they are not in the
knowing issue list.
But I had the same bad results.

I tried also using an ath9k wifi card.
Each mesh link is set on 80MHz channel bandwidth, therefore I'm not
able to capture the data traffic with the ath9k that doesn't support
80MHz.

I'm able to sniff the traffic and see the radiotap header only using
my laptop with an iwlwifi 11ac card.

Do you know if there is a way to obtain reliable TX/RX information
from the firmware, or if there is a way to sniff the radiotap header
on an 80MHz channel using an ath9k interface?

Thank you in advance for any hint!

My best regards

Matteo
