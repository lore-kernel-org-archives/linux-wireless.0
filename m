Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:64138 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbZDFTQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 15:16:15 -0400
Received: by fg-out-1718.google.com with SMTP id 16so283541fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 12:16:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8ccc1dbe0904061150w18d38193v772492e480f0aa15@mail.gmail.com>
References: <8ccc1dbe0904061150w18d38193v772492e480f0aa15@mail.gmail.com>
Date: Mon, 6 Apr 2009 20:16:12 +0100
Message-ID: <8ccc1dbe0904061216m1e31aaf4j53b0c067b9e19999@mail.gmail.com> (sfid-20090406_211619_319160_C92D8338)
Subject: iwlagn preventing hibernation with TuxOnIce
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think I've found a bug. Either it's iwlagn or it's TuxOnIce, I'll
try here first. Whenever my wlan0 interfaces is up, TuxOnIce causes a
kernel panic when it's 'writing kernel and process information', after
a while I get a backtrace (?) about something with sda (my SSD). I was
first using iwlagn from 2.6.29 but I just installed
compat-wireless-2009-04-06 and it made no difference.

Hardware being used:
Dell Inspiron 1520

iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2009 Intel Corporation
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: setting latency timer to 64
iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:0c:00.0: irq 29 for MSI/MSI-X
phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-4965-2.ucode
iwlagn 0000:0c:00.0: loaded firmware version 228.57.2.23
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX

Vanilla 2.6.29.1 kernel with TuxOnIce patch, fs for / is ext4, using
the deadline scheduler. Kernel configuration at [1]. dmesg at [2].

Is there any way you could help me debug this? Thanks,

Mathias


[1] http://rafb.net/p/qWvmzl19.html
[2] http://rafb.net/p/3c2Nuw14.html
