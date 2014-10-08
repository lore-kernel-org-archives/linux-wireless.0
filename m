Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.adetelgroup.com ([94.247.26.71]:55859 "EHLO
	smtp.adetelgroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbaJHNrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 09:47:13 -0400
Received: from hbg-pa74.hmc-pa.adm (unknown [10.210.21.3])
	by smtp.adetelgroup.com (Postfix) with ESMTP id 9A94843293
	for <linux-wireless@vger.kernel.org>; Wed,  8 Oct 2014 15:37:20 +0200 (CEST)
Date: Wed, 8 Oct 2014 15:37:16 +0200 (CEST)
From: CHAUMETTE Hubert <hchaumette@adeneo-embedded.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <51562649.4716655.1412775436836.JavaMail.zimbra@adeneo-embedded.com> (sfid-20141008_154721_955441_5D05AB0A)
In-Reply-To: <873295702.4716275.1412775389466.JavaMail.zimbra@adeneo-embedded.com>
Subject: wl1271 driver on Linux 3.10 for SabreSD
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I need to activate the wl12xx driver (from drivers/net/wireless/ti/) on a (Android) Linux 3.10.31 kernel on an i.MX6Q SabreSD board. The wl1271 is to communicate with the board through an SDIO interface (SD2 on the board).

I have built the driver modules (cfg80211 and mac80211; wlcore, wlcore_sdio and wl12xx), and insmod'ed them. They are listed by lsmod :
wlcore_sdio 3820 0 - Live 0x00000000
wl12xx 51103 0 - Live 0x00000000
wlcore 161008 1 wl12xx, Live 0x00000000
mac80211 253798 2 wl12xx,wlcore, Live 0x00000000
cfg80211 201451 2 wlcore,mac80211, Live 0x00000000

dmesg shows only a message from cfg80211 (no errors for other modules, when insmod'ed in the right order) :
cfg80211: Calling CRDA to update world regulatory domain

1) Can I use /sys/modules/{wlcore,wlcore_sdio,wl12xx}/ to test it ?
2) The board uses the device tree to enumerate platform devices. To correctly activate the driver, do I need to add it to the board DT (and a binding to the driver) ?
3) The driver is supposed to use a firmware (according to http://wireless.kernel.org/en/users/Drivers/wl12xx), how do I know whether it found it (no kernel log message) (I've put the firmware in /system/etc/firmware/) ?

Thanks in advance.
Regards,

Hubert
