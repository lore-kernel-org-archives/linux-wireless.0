Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41437 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0FJF0X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:26:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 22:26:23 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19472.30680.855993.112084@gargle.gargle.HOWL>
Date: Thu, 10 Jun 2010 10:57:52 +0530
To: Yatharth <y@yatharthgupta.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: issues while attempting ath9k_htc to work with ubuntu 10.04, device
 TL-WN721N
In-Reply-To: <4C107563.3010709@yatharthgupta.com>
References: <4C107563.3010709@yatharthgupta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yatharth wrote:
> I am trying to install driver for the TP-LINK : TL-WN721N (Wi-Fi USB
> Device). If this is not the sort of issues this mailing list is for,
> please let me know.
> 
> This device should use the ath9k_htc driver
> 
> ./lsusb
> Bus 001 Device 003: ID 0cf3:9271 Atheros Communications, Inc.
> 
> I have followed the instruction from 
> http://linuxwireless.org/en/users/Download 
> <http://linuxwireless.org/en/users/Download> But they do not seem to 
> work for me
> 
> When I modprobe ath9k_htc
> 
> Ubu-VM:/lib/modules/2.6.32-22-generic/build$ sudo modprobe ath9k_htc
> 
> FATAL: Error inserting ath9k_htc
> (/lib/modules/2.6.32-22-generic/updates/drivers/net/wireless/ath/ath9k/ath9k_htc.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> 
> Here is the output of dmesg
> 
> 
> Ubu-VM:/lib/modules/2.6.32-22-generic/build$ dmesg | grep ath9k
> 
> [ 1926.917944] ath9k_htc: disagrees about version of symbol
> ath9k_hw_set_txpowerlimit
> [ 1926.917947] ath9k_htc: Unknown symbol ath9k_hw_set_txpowerlimit
> [ 1926.918248] ath9k_htc: disagrees about version of symbol
> ath9k_hw_reset_calvalid
> [ 1926.918250] ath9k_htc: Unknown symbol ath9k_hw_reset_calvalid
> [ 1926.918377] ath9k_htc: disagrees about version of symbol
> ath9k_hw_setcapability
> [ 1926.918379] ath9k_htc: Unknown symbol ath9k_hw_setcapability
> [ 1926.918603] ath9k_htc: disagrees about version of symbol
> ieee80211_free_hw
> [ 1926.918605] ath9k_htc: Unknown symbol ieee80211_free_hw
> [ 1926.918680] ath9k_htc: disagrees about version of symbol ath9k_hw_reset
> [ 1926.918682] ath9k_htc: Unknown symbol ath9k_hw_reset
> [ 1926.919176] ath9k_htc: disagrees about version of symbol
> ath9k_hw_setuptxqueue
> [ 1926.919179] ath9k_htc: Unknown symbol ath9k_hw_setuptxqueue
> [ 1926.919256] ath9k_htc: disagrees about version of symbol
> ath9k_hw_startpcureceive
> [ 1926.919257] ath9k_htc: Unknown symbol ath9k_hw_startpcureceive
> [ 1926.919352] ath9k_htc: Unknown symbol ath9k_cmn_key_delete
> [ 1926.919477] ath9k_htc: Unknown symbol ath9k_cmn_key_config
> [ 1926.919559] ath9k_htc: disagrees about version of symbol
> ath9k_hw_keyreset

You haven't unloaded the existing ath9k_hw module.

Do a 'sudo make install' in your compat directory, and
then 'sudo make unload'.

Check 'lsmod | grep ath'. If anything is still present, unload all of them,
along with mac80211, cfg80211. Then modprobe ath9k_htc.

Of course, you can just reboot after 'sudo make install' and things should work.

Sujith
