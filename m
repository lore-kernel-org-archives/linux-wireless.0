Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36122 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbcDEJ5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:57:04 -0400
Received: by mail-wm0-f52.google.com with SMTP id 127so18541391wmu.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 02:57:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Apr 2016 12:57:01 +0300
Message-ID: <CANfLQrYTqUQGoj+Xr1XrKJrh8oaBB+qt8YeFwo0EyhbC-RpnNg@mail.gmail.com> (sfid-20160405_115709_978820_18E22EA5)
Subject: iwlwifi monitor mode: No data frame captured on 5 Ghz
From: Gucea Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Cc: Doru Gucea <doru.gucea@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am trying to capture packets that are exchanged between an AP and a
smartphone on the 5Ghz frequency. For generating traffic, I upload UDP
traffic from a laptop PC towards the smartphone using iperf.

The problem is that I can see _only_ the control frames like RTS/CTS,
Block ACK, while the data packets are not captured. I uploaded the
Wireshark capture files at [1] (located inside the folders whose name
starts with 5Ghz).

If I use the 2.4 frequency, all the frames are captured. I also
uploaded the Wireshark packet traces for 2.4Ghz at [1] (located inside
the folders whose name starts with 2.4 Ghz).

Is this a known bug or am I doing something wrong?

Additional details:
Wi-Fi card:  iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless N 7260, REV=0x144
Firmware version: iwlwifi 0000:04:00.0: loaded firmware version
25.228.9.0 op_mode iwlmvm
Traffic encryption: WPA & WPA2 Personal
Setting up the card in wireless mode:
ip link set dev wlan0 down
iw wlan0 set type monitor
ip link set dev wlan0 up
iw wlan0 set freq 5240

[1] https://drive.google.com/open?id=0B5SBH08PU_Chek9rOHY0VkxFRUE

Thank you, Doru
