Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.176.135]:42282 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab3KCNCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 08:02:03 -0500
Received: from smtp20.mail.ru (smtp20.mail.ru [94.100.176.173])
	by fallback7.mail.ru (mPOP.Fallback_MX) with ESMTP id 6676DEA730CC
	for <linux-wireless@vger.kernel.org>; Sun,  3 Nov 2013 17:01:41 +0400 (MSK)
Received: from [37.204.187.134] (port=39174 helo=[192.168.1.108])
	by smtp20.mail.ru with esmtpa (envelope-from <fenixk19@mail.ru>)
	id 1VcxIt-0006Gp-Pk
	for linux-wireless@vger.kernel.org; Sun, 03 Nov 2013 17:01:19 +0400
Message-ID: <5276491F.20207@mail.ru> (sfid-20131103_140223_405106_5D1CCB44)
Date: Sun, 03 Nov 2013 17:01:19 +0400
From: Alexander Varnin <fenixk19@mail.ru>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mwifiex_sdio on chromebook
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.
I am trying to debug the issue with incorrect initialization of WiFi
chip on Samsung ARM Chromebook. And I search for assistance. I have
posted my investigation results on launchpad.net (bug #1247512). Here is
copy:

Marvell SDIO WiFi chip doesn't get initialized correctly on Chromebook.
After some research I have managed to find that when Linux is doing
initialization, it tries setting clock and power to SDIO controller for
that chip. It is trying frequences hardcoded in
linux/drivers/mmc/core/core.c: 400000, 300000, 200000, 100000 Hz.
Opposed to that, chrome os kernel tries other frequences: 784314Hz and
50000000Hz. The last is staying as working frequency. I don't know, if
it is matter for card what frequency does the host tries to gate.

When mainline kernel runs mmc_attach_sdio function it should get correct
answer from card and so process card as SDIO. However it fails with
timeout in that function.

I wonder if this depends on firmware loading. I see, that chrome os 3.4
kernel requires firmware. And mainline is probably simply doesn't load
it by default. Currently, I don't know how to check it and how to
configure kernel to load firmware for mwifiex_sdio.

I am ready to do further research, but I need some assistance.

Is there any manual on marvell chip?


