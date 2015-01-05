Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44926 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAEQVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 11:21:44 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so27803308wgh.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 08:21:43 -0800 (PST)
Received: from [192.168.1.2] (host-85-201-211-254.dynamic.voo.be. [85.201.211.254])
        by mx.google.com with ESMTPSA id h8sm10460216wiy.17.2015.01.05.08.13.49
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Jan 2015 08:13:49 -0800 (PST)
Message-ID: <54AAB83B.5070005@gmail.com> (sfid-20150105_172147_488522_552545BC)
Date: Mon, 05 Jan 2015 17:13:47 +0100
From: =?UTF-8?B?RnJhbsOnb2lzIFZhbGVuZHVj?= <francoisvalenduc@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Kernel crash while copying big files since kernel 3.18
References: <54AA3953.20603@gmail.com>
In-Reply-To: <54AA3953.20603@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 05/01/15 08:12, François Valenduc a écrit :
> Hello everybody,
>
> Since kernel 3.18, I encounter a kernel crash each time when I copy a
> big file (around 12 Gb) from an external USB drive to the harddrive of
> my laptop.
> I tried a bisection between kernels 3.17 and 3.18 and I was surprised to
> find that this has to do with the driver of the wireless card
> (rtl8188ee). However, I don't have problems if I copy the file while the
> rtl8188 module is not loaded. Unfortunately, the results of git-bisect
> are not totally conclusive because the kernel crash during boot when the
> wireless connection is established. Here are the last steps of the
> bisection:
>
> # bad: [c151aed6aa146e9587590051aba9da68b9370f9b] rtlwifi: rtl8188ee:
> Update driver to match Realtek release of 06282014
> git bisect bad c151aed6aa146e9587590051aba9da68b9370f9b
> # good: [fd09ff958777cf583d7541f180991c0fc50bd2f7] rtlwifi: Remove extra
> workqueue for enter/leave power state
> git bisect good fd09ff958777cf583d7541f180991c0fc50bd2f7
> # skip: [9afa2e44f4d8f9d031f815c32bb8f225f0f6746b] rtlwifi: Modify
> base.{c,h} for new drivers
> git bisect skip 9afa2e44f4d8f9d031f815c32bb8f225f0f6746b
> # skip: [3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd] rtlwifi: Modify
> cam.{c,h} and efuse.{c,h} for new drivers
> git bisect skip 3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd
> # skip: [f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8] rtlwifi: Modify
> core.c for new drivers
> git bisect skip f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8
> # skip: [d3feae41a3473a0f7b431d6af4e092865d586e52] rtlwifi: Update
> power-save routines for 062814 driver
> git bisect skip d3feae41a3473a0f7b431d6af4e092865d586e52
> # skip: [38506ecefab911785d5e1aa5889f6eeb462e0954] rtlwifi: rtl_pci:
> Start modification for new drivers
> git bisect skip 38506ecefab911785d5e1aa5889f6eeb462e0954
> # skip: [f3a97e93814aeac3f13e857a0071726acc9bd626] rtlwifi: Finish
> modifying core routines for new drivers
> git bisect skip f3a97e93814aeac3f13e857a0071726acc9bd626
> # only skipped commits left to test
> # possible first bad commit: [c151aed6aa146e9587590051aba9da68b9370f9b]
> rtlwifi: rtl8188ee: Update driver to match Realtek release of 06282014
> # possible first bad commit: [f3a97e93814aeac3f13e857a0071726acc9bd626]
> rtlwifi: Finish modifying core routines for new drivers
> # possible first bad commit: [d3feae41a3473a0f7b431d6af4e092865d586e52]
> rtlwifi: Update power-save routines for 062814 driver
> # possible first bad commit: [3c67b8f9f3b5bb1207c9bb198e5ef04ff56921dd]
> rtlwifi: Modify cam.{c,h} and efuse.{c,h} for new drivers
> # possible first bad commit: [9afa2e44f4d8f9d031f815c32bb8f225f0f6746b]
> rtlwifi: Modify base.{c,h} for new drivers
> # possible first bad commit: [f7953b2ad66cc5fc66e13d5c0a40e61b45cdfca8]
> rtlwifi: Modify core.c for new drivers
> # possible first bad commit: [38506ecefab911785d5e1aa5889f6eeb462e0954]
> rtlwifi: rtl_pci: Start modification for new drivers
>
> Can somebody explain what's happening ? I do the copy via Dolphin in KDE
> and the screen becomes black and the computer becomes totally
> unresponsive. So, I don't have access to the logs to see the trace of
> the problem.
>
> Thanks in advance for your help,
>
> François Valenduc
>
> PS: please use "cc" to answer because I don't have a subscription to the
> mailing list.
I should add that the problem doesn't occur if I use "cp" to copy the
file. However, it also occurs if the file is copied via rsync.

François Valenduc
