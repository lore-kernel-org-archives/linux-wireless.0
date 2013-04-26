Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:23984 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932096Ab3DZTMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 15:12:06 -0400
Message-ID: <22a4295e8ebbfab1bf23a591639ce442.squirrel@www.infidigm.net> (sfid-20130426_211210_532239_CB967D2B)
Date: Fri, 26 Apr 2013 15:55:22 -0400
Subject: mmc/sdio broken in 3.9.0-rc2?
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl sdio is working good in 3.7.0-rc7, but in 3.9.0-rc2, there are a
couple of seconds between each mmc queue and the ath6kl fails to load. I
have a real sdio on the pci bus (sdhci_pci module) - Thinkpad SL410.

// 3.7.0-rc7-custom-wl-ar6
[  196.354874] mmc0: queuing unknown CIS tuple 0x01 (3 bytes)
[  196.363612] mmc0: queuing unknown CIS tuple 0x1a (5 bytes)
[  196.367059] mmc0: queuing unknown CIS tuple 0x1b (8 bytes)
[  196.367709] mmc0: queuing unknown CIS tuple 0x14 (0 bytes)
[  196.372065] mmc0: queuing unknown CIS tuple 0x80 (1 bytes)
[  196.372278] mmc0: queuing unknown CIS tuple 0x81 (1 bytes)
[  196.372483] mmc0: queuing unknown CIS tuple 0x82 (1 bytes)
[  196.372563] mmc0: new SDIO card at address 0001
[  196.420427] ath6kl: temporary war to avoid sdio crc error
[  196.868594] ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144\x01 api 3

// 3.9.0-rc2-wl-ar6+
[   75.996139] mmc0: queuing unknown CIS tuple 0x01 (3 bytes)
[   78.296130] mmc0: queuing unknown CIS tuple 0x1a (5 bytes)
[   79.296086] mmc0: queuing unknown CIS tuple 0x1b (8 bytes)
[   79.496084] mmc0: queuing unknown CIS tuple 0x14 (0 bytes)
[   85.896171] mmc0: queuing unknown CIS tuple 0x80 (1 bytes)
[   86.196143] mmc0: queuing unknown CIS tuple 0x81 (1 bytes)
[   86.496134] mmc0: queuing unknown CIS tuple 0x82 (1 bytes)
[   86.596161] mmc0: new SDIO card at address 0001
[   92.396156] ath6kl: temporary war to avoid sdio crc error
[  186.296301] ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144\x01 api 3
[  186.296315] ath6kl: firmware supports:
sched-scan,sta-p2pdev-duplex,rsn-cap-override
[  186.296322] ath6kl: abi version mismatch: host(0x1), target(0x0)
[  186.496361] ath6kl: host has no rx buffers blocking receiver to prevent
overrun
[  186.896282] ath6kl: Failed to start hardware: -5
[  186.896400] ath6kl: Failed to init ath6kl core
[  186.896446] ath6kl_sdio: probe of mmc0:0001:1 failed with error -5

Jon





