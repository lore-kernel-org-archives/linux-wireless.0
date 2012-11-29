Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2232 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2K2Q0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 11:26:14 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: Bug: ethtool do not report firmware-version for wireless interfaces
Date: Thu, 29 Nov 2012 18:26:10 +0200
Message-ID: <2513186.dDx8zPJNjI@lx-vladimir> (sfid-20121129_172618_039972_5EB855B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found that ethtool interface get corrupted somehow.

With recent linux-wireless kernel, I see that

ethtool -i

do not report firmware-version, that used to be present some time ago.
I tested with ath9k. With wired interfaces it still works:

$ ethtool -i wlan0
driver: ath9k
version: 
firmware-version: 
bus-info: 0000:04:00.0
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

$ ethtool -i eth0
driver: e1000e
version: 2.1.4-k
firmware-version: 0.13-3
bus-info: 0000:00:19.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no

It looks strange - even if driver do not fill wdev->fw_version,
ethtool handler substitute string "N/A":

	if (wdev->wiphy->fw_version[0])
		strncpy(info->fw_version, wdev->wiphy->fw_version,
			sizeof(info->fw_version));
	else
		strncpy(info->fw_version, "N/A", sizeof(info->fw_version));

