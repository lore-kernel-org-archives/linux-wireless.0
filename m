Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55509 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3FCC6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 22:58:38 -0400
Received: by mail-pd0-f169.google.com with SMTP id y11so4967890pdj.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Jun 2013 19:58:38 -0700 (PDT)
Received: from empty.site ([101.118.159.240])
        by mx.google.com with ESMTPSA id fp2sm56915454pbb.36.2013.06.02.19.58.35
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 02 Jun 2013 19:58:37 -0700 (PDT)
Message-ID: <51AC0657.9090009@googlemail.com> (sfid-20130603_045915_156281_12D136E4)
Date: Mon, 03 Jun 2013 12:58:31 +1000
From: Gordian Klein <gordian.klein@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Wireless LED always on
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

i have a Sony Vaio SVS1511V9EB with an Intel(R) Centrino(R) Advanced-N
6235 AGN wireless card. The card is working fine, but the wireless LED
on my laptop is always on. No matter if i disable the wifi device via
NetworkManager or "rfkill block all". I set the iwlwifi led_mode
parameter to 1 (and to 2 for testing), but this didnt do anything to the
LED, it was constantly on. Id like it to be off when the wifi device is
disabled.
This is a log of dmesg:

# dmesg | grep iwl[    3.955915] iwlwifi 0000:02:00.0: irq 46 for MSI/MSI-X
[    3.965170] iwlwifi 0000:02:00.0: loaded firmware version 18.168.6.1
[    3.972206] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    3.972211] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[    3.972213] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    3.972216] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    3.972218] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[    3.972221] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6235 AGN, REV=0xB0
[    3.972302] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    3.992851] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.977782] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    4.985059] iwlwifi 0000:02:00.0: Radio type=0x2-0x1-0x0
[    5.359698] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    5.366473] iwlwifi 0000:02:00.0: Radio type=0x2-0x1-0x0

I verified the led_mode parameter is set correctly with :

# cat /sys/module/iwlwifi/parameters/led_mode
1

I am running openSuse 12.2 x64 with Kernel 3.9.3-10.g06ad9d8-desktop.

Thanks for any hint.

Gordian

