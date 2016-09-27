Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36432 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbcI0JDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 05:03:38 -0400
Received: by mail-wm0-f43.google.com with SMTP id w84so163455310wmg.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 02:03:37 -0700 (PDT)
MIME-Version: 1.0
From: Gucea Doru <gucea.doru@gmail.com>
Date: Tue, 27 Sep 2016 12:03:35 +0300
Message-ID: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com> (sfid-20160927_110342_566189_5C6A5F0D)
Subject: bcmdhd: Strange Power Save messages
To: Arend van Spriel <arend@broadcom.com>
Cc: Andra Paraschiv <andra.paraschiv7@gmail.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am analyzing the Power Save algorithm used on a pair of Nexus 5
devices. The devices use the bcmdhd Broadcom driver and are Wi-Fi
Direct connected.

My test is very simple: I send ping packets from the P2P client
towards the P2P GO. Before sending a ping packet the P2P client enters
PS mode (it sends a Null frame with the PWR MGT bit set). A few
miliseconds later, the P2P client sends the ping request message. Once
the ping request is ACKed the P2P client exits the PS mode (it sends a
Null frame with the PWR MGT bit unset) and the P2P GO decides to send
him the ping reply.

What is the decision triggering the exit from the PS mode immediately
after the ping request? I am asking this because 802.11 PS legacy
specifies that the client should wait for a beacon with TIM set in
order to wake up: in my case, there is no beacon between the ping
request message and the Null frame that announces the exit from the PS
mode.

For reference, the Wireshark trace can be found at [1].
SSID: DIRECT-35-Android_Intel
WPA pass: JYdrhZp3

[1] https://drive.google.com/file/d/0B5SBH08PU_ChQk95LWpzekh3VU0/view?usp=sharing

Thank you,
Doru
