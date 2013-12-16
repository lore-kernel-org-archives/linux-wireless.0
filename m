Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f46.google.com ([209.85.128.46]:56775 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPKDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 05:03:49 -0500
Received: by mail-qe0-f46.google.com with SMTP id a11so3682275qen.33
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 02:03:48 -0800 (PST)
MIME-Version: 1.0
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Dec 2013 21:03:28 +1100
Message-ID: <CAGRGNgXdwkbAxbEojrj=doRF=fsEUajjojjR4SOmyOgaRMJP_w@mail.gmail.com> (sfid-20131216_110353_207322_6262ABF9)
Subject: Poor throughput with Intel Wireless-N 2230 on Debian's 3.11 kernel
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I recently built a home theatre PC with a Mini-ITX motherboard with an
Intel Wireless-N 2230 on board. I'm running up-to-date Debian Testing
(Wheezy) on it with the default 3.11 kernel.

I'm having issues streaming "low" bitrate video (well below 1Mbit/sec)
over our otherwise quiet wireless network.

iw dev wlan0 link reports a signal level of ~-60dBm, my access point
claims a slightly lower signal level.

My wireless network is run off a cheap ath9k router with 3 antennae.

I believe that this particular part is at fault as my laptop, which
has an Ultimate-N 5300 with 2 antennae, can stream the same files
without issue when placed next to the HTPC; and the network has
sufficient bandwidth to stream similar files to four devices
simultaneously.

I'm well aware that I should update to the latest wireless-testing (or
install an equivalent backport release) before filing official bug
reports, however I want to know if there have been any improvements
since 3.11 which would benefit the 'N 2230.

Also, are there any new firmware versions which may improve this
situation? - I'm using version 18.168.6.1 as distributed by Debian.

Relevant dmesg snippet:

[    1.320728] iwlwifi 0000:03:00.0: enabling device (0000 -> 0002)
[    1.320850] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
[    1.324627] iwlwifi 0000:03:00.0: firmware: agent loaded
iwlwifi-2030-6.ucode into memory
[    1.324925] iwlwifi 0000:03:00.0: loaded firmware version
18.168.6.1 op_mode iwldvm
[    1.338637] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    1.338641] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    1.338643] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    1.338645] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[    1.338647] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
Wireless-N 2230 BGN, REV=0xC8
[    1.338702] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    1.361414] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    3.384827] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    3.392503] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
[    3.632396] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    3.640063] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
