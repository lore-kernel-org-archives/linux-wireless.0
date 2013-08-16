Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frankvm.xs4all.nl ([83.163.248.189]:45072 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754775Ab3HPMlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 08:41:15 -0400
Date: Fri, 16 Aug 2013 14:30:44 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: iwlwifi (Centrino Ultimate-N 6300) broken for kernels > 3.7
Message-ID: <20130816123043.GA5814@janus> (sfid-20130816_144119_256670_DE361AD4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 3.7.9 iwlwifi for the Intel Centrino Ultimate-N 6300 works. On
3.8.latest, 3.9.latest and 3.10.latest it doesn't. Symptom: NetworkManager
keeps on asking for a password.

/var/log/messages:

Aug 16 11:48:33 pcfvm kernel: [  110.025291] wlan1: authenticate with 00:23:4e:33:8b:7d
Aug 16 11:48:33 pcfvm NetworkManager[1196]: <info> (wlan1): supplicant connection state:  disconnected -> associating
Aug 16 11:48:33 pcfvm kernel: [  110.036263] wlan1: send auth to 00:23:4e:33:8b:7d (try 1/3)
Aug 16 11:48:33 pcfvm gnome-keyring-daemon[2053]: couldn't allocate secure memory to keep passwords and or keys from being written 
Aug 16 11:48:33 pcfvm kernel: [  110.061782] wlan1: send auth to 00:23:4e:33:8b:7d (try 2/3)
Aug 16 11:48:33 pcfvm kernel: [  110.087120] wlan1: send auth to 00:23:4e:33:8b:7d (try 3/3)
Aug 16 11:48:33 pcfvm kernel: [  110.106771] wlan1: authentication with 00:23:4e:33:8b:7d timed out
Aug 16 11:48:53 pcfvm NetworkManager[1196]: <info> (wlan1): supplicant connection state:  associating -> disconnected
Aug 16 11:48:53 pcfvm NetworkManager[1196]: <info> (wlan1): supplicant connection state:  disconnected -> scanning
Aug 16 11:48:56 pcfvm NetworkManager[1196]: <info> (wlan1): supplicant connection state:  scanning -> associating
Aug 16 11:48:56 pcfvm kernel: [  132.643461] wlan1: authenticate with 00:23:4e:33:8b:7d
Aug 16 11:48:56 pcfvm kernel: [  132.658207] wlan1: send auth to 00:23:4e:33:8b:7d (try 1/3)
Aug 16 11:48:56 pcfvm kernel: [  132.685211] wlan1: send auth to 00:23:4e:33:8b:7d (try 2/3)
Aug 16 11:48:56 pcfvm kernel: [  132.709573] wlan1: send auth to 00:23:4e:33:8b:7d (try 3/3)
Aug 16 11:48:56 pcfvm kernel: [  132.733577] wlan1: authentication with 00:23:4e:33:8b:7d timed out

An ath9k card in the same laptop works with kernel 3.10.7.


kernel startup messages differ slightly:

kernel: [...] Linux version 3.7.9 (works)
kernel: [...] cfg80211: Calling CRDA to update world regulatory domain
kernel: [...] Intel(R) Wireless WiFi driver for Linux, in-tree:
kernel: [...] Copyright(c) 2003-2012 Intel Corporation
kernel: [...] iwlwifi 0000:04:00.0: pci_resource_len = 0x00002000
kernel: [...] iwlwifi 0000:04:00.0: pci_resource_base = faab0000
kernel: [...] iwlwifi 0000:04:00.0: HW Revision ID = 0x35
kernel: [...] cfg80211: World regulatory domain updated:
kernel: [...] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [...] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [...] iwlwifi 0000:04:00.0: loaded firmware version 9.221.4.1 build 25532
kernel: [...] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
kernel: [...] iwldvm: Copyright(c) 2003-2012 Intel Corporation
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUG disabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_P2P disabled
kernel: [...] iwlwifi 0000:04:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
kernel: [...] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
kernel: [...] iwlwifi 0000:04:00.0: device EEPROM VER=0x436, CALIB=0x6
kernel: [...] iwlwifi 0000:04:00.0: Device SKU: 0x1F0
kernel: [...] iwlwifi 0000:04:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
kernel: [...] cfg80211: Calling CRDA for country: NL
kernel: [...] cfg80211: Regulatory domain changed to country: NL
kernel: [...] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [...] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [...] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [...] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [...] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

kernel: [...] Linux version 3.8.13 (iwlwifi doesn't work)
kernel: [...] cfg80211: Calling CRDA to update world regulatory domain
kernel: [...] Intel(R) Wireless WiFi driver for Linux, in-tree:
kernel: [...] Copyright(c) 2003-2012 Intel Corporation
kernel: [...] cfg80211: World regulatory domain updated:
kernel: [...] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [...] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [...] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [...] iwlwifi 0000:04:00.0: loaded firmware version 9.221.4.1 build 25532
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUG disabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
kernel: [...] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_P2P disabled
kernel: [...] iwlwifi 0000:04:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
kernel: [...] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
kernel: [...] cfg80211: Calling CRDA for country: NL
kernel: [...] cfg80211: Regulatory domain changed to country: NL
kernel: [...] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [...] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [...] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [...] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [...] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

I don't see any EEPROM/antenna messages. "rfkill list" confirms there are no blocks.


-- 
Frank
