Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48884 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbAEHMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 02:12:33 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so3525160wiv.4
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2015 23:12:32 -0800 (PST)
Received: from [192.168.1.2] (host-85-201-211-254.dynamic.voo.be. [85.201.211.254])
        by mx.google.com with ESMTPSA id b10sm8742280wiw.9.2015.01.04.23.12.31
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Jan 2015 23:12:31 -0800 (PST)
Message-ID: <54AA3953.20603@gmail.com> (sfid-20150105_081236_617625_1F141B56)
Date: Mon, 05 Jan 2015 08:12:19 +0100
From: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francoisvalenduc@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Kernel crash while copying big files since kernel 3.18
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

Since kernel 3.18, I encounter a kernel crash each time when I copy a
big file (around 12 Gb) from an external USB drive to the harddrive of
my laptop.
I tried a bisection between kernels 3.17 and 3.18 and I was surprised to
find that this has to do with the driver of the wireless card
(rtl8188ee). However, I don't have problems if I copy the file while the
rtl8188 module is not loaded. Unfortunately, the results of git-bisect
are not totally conclusive because the kernel crash during boot when the
wireless connection is established. Here are the last steps of the
bisection:

# bad: [c151aed6aa146e9587590051aba9da68b9370f9b] rtlwifi: rtl8188ee:
Update driver to match Realtek release of 06282014
git bisect bad c151aed6aa146e9587590051aba9da68b9370f9b
# good: [fd09ff958777cf583d7541f180991c0fc50bd2f7] rtlwifi: Remove extra
workqueue for enter/leave power state
git bisect good fd09ff958777cf583d7541f180991c0fc50bd2f7
# skip: [9afa2e44f4d8f9d031f815c32bb8f225f0f6746b] rtlwifi: Modify
base.{c,h} for new drivers
git bisect skip 9afa2e44f4d8f9d031f815c32bb8f225f0f6746b
# skip: [3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd] rtlwifi: Modify
cam.{c,h} and efuse.{c,h} for new drivers
git bisect skip 3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd
# skip: [f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8] rtlwifi: Modify
core.c for new drivers
git bisect skip f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8
# skip: [d3feae41a3473a0f7b431d6af4e092865d586e52] rtlwifi: Update
power-save routines for 062814 driver
git bisect skip d3feae41a3473a0f7b431d6af4e092865d586e52
# skip: [38506ecefab911785d5e1aa5889f6eeb462e0954] rtlwifi: rtl_pci:
Start modification for new drivers
git bisect skip 38506ecefab911785d5e1aa5889f6eeb462e0954
# skip: [f3a97e93814aeac3f13e857a0071726acc9bd626] rtlwifi: Finish
modifying core routines for new drivers
git bisect skip f3a97e93814aeac3f13e857a0071726acc9bd626
# only skipped commits left to test
# possible first bad commit: [c151aed6aa146e9587590051aba9da68b9370f9b]
rtlwifi: rtl8188ee: Update driver to match Realtek release of 06282014
# possible first bad commit: [f3a97e93814aeac3f13e857a0071726acc9bd626]
rtlwifi: Finish modifying core routines for new drivers
# possible first bad commit: [d3feae41a3473a0f7b431d6af4e092865d586e52]
rtlwifi: Update power-save routines for 062814 driver
# possible first bad commit: [3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd]
rtlwifi: Modify cam.{c,h} and efuse.{c,h} for new drivers
# possible first bad commit: [9afa2e44f4d8f9d031f815c32bb8f225f0f6746b]
rtlwifi: Modify base.{c,h} for new drivers
# possible first bad commit: [f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8]
rtlwifi: Modify core.c for new drivers
# possible first bad commit: [38506ecefab911785d5e1aa5889f6eeb462e0954]
rtlwifi: rtl_pci: Start modification for new drivers

Can somebody explain what's happening ? I do the copy via Dolphin in KDE
and the screen becomes black and the computer becomes totally
unresponsive. So, I don't have access to the logs to see the trace of
the problem.

Thanks in advance for your help,

François Valenduc

PS: please use "cc" to answer because I don't have a subscription to the
mailing list.
