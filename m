Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab0FULsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 07:48:50 -0400
Received: by bwz7 with SMTP id 7so903824bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 04:48:49 -0700 (PDT)
Message-ID: <4C1F51A3.5000407@gmail.com>
Date: Mon, 21 Jun 2010 13:48:51 +0200
From: Daniel Golle <daniel.golle@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org
Subject: [RFC] refactor ath9k_platform to sound sane for use in both ath9k
 and ath5k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm developing on OpenWrt to work with EEPROM-less ath5k mini-pci 
devices. This is needed to support the ar71xx-based Senao EAP7660D board 
which got two AR5413 modules soldered into its mini-pci slots. In the 
original Firmware, MAC addresses as well as calibration-data seems to be 
part of the firmware blob stored on the board flash.
See 
https://lists.openwrt.org/pipermail/openwrt-devel/2010-June/007366.html 
for the corresponding discussion on OpenWrt-devel.
Similarly to the way this happens for ath9k, I managed to get ath5k to 
use the MAC address and eeprom-data supplied by ath9k_platform_data.
Including ath9k_platform.h in ath5k-sources looks confusing as the name 
ath9k_platform suggests that the supplied ath9k_platform_info struct is 
specific to ath9k devices.
Consequently, I believe ath9k_platform.h should be renamed into 
ath_platform.h, the macro ATH9K_PLAT_EEP_MAX_WORDS into 
ATH_PLAT_EEP_MAX_WORDS and struct ath9k_platform_data should be 
refactored to be struct ath_platform_data.
Please let me know if you agree with this in theory; if yes, I'll start 
posting the patches to OpenWrt.

Cheers

Daniel
