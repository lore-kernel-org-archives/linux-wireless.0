Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.marcant.net ([217.14.160.186]:38777 "EHLO
	mail2.marcant.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaF0JPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 05:15:12 -0400
Received: from localhost (mcontrol3.marcant.net [217.14.168.56])
	by localhost (Postfix) with ESMTP id C62A54ACB40
	for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 10:44:36 +0200 (CEST)
Received: from mail2.marcant.net ([127.0.0.1])
 by localhost (mail2.marcant.net [127.0.0.1]) (amavisd-maia, port 10030)
 with ESMTP id 12136-05 for <linux-wireless@vger.kernel.org>;
 Fri, 27 Jun 2014 10:44:32 +0200 (CEST)
Received: from admins.marcant.net (eth2.rossini.bi.marcant.net [217.14.160.189])
	by mail2.marcant.net (Postfix) with ESMTP id A16D74ACC51
	for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 10:44:32 +0200 (CEST)
Received: from [192.168.191.144] (varus [192.168.191.144])
	by admins.marcant.net (Postfix) with ESMTP id 893F396E
	for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 10:44:32 +0200 (CEST)
Message-ID: <53AD2EEE.4040704@marcant.net> (sfid-20140627_111516_502367_90D54F91)
Date: Fri, 27 Jun 2014 10:44:30 +0200
From: =?ISO-8859-1?Q?Andr=E9_Valentin?= <avalentin@marcant.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath10k OTP loading issues
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I got problems initializing my ath10k PCI card in my Zyxel NBG 6716. It worked until some weeks, now, the driver does not load. I debugged a bit and this is what I got:
Fri Jun 27 08:03:42 2014 kern.info kernel: [62908.290000] ath10k_pci 0000:01:00.0: BAR 0: assigned [mem 0x12000000-0x121fffff 64bit]
Fri Jun 27 08:03:43 2014 kern.info kernel: [62908.610000] ath10k: pci irq legacy irq_mode 0 reset_mode 0
Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.620000] ath10k: boot upload otp to 0x1234 len 6917
Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.780000] ath10k: otp calibration failed: 2
Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.790000] ath10k: failed to run otp: -22
Fri Jun 27 08:03:43 2014 kern.err kernel: [62908.790000] ath10k: could not init core (-22)
Fri Jun 27 08:03:43 2014 kern.err kernel: [62909.060000] ath10k: could not probe fw (-22)
Fri Jun 27 08:03:43 2014 kern.err kernel: [62909.060000] ath10k: failed to register driver core: -22
Fri Jun 27 08:03:43 2014 kern.warn kernel: [62909.060000] ath10k_pci: probe of 0000:01:00.0 failed with error -22


If I remove OTP loading the card initializes fine, but I think I will not have a good performance. So bad idea.
Currently I use compat-wireless-2014-05-22, with some patches form openwrt.
The firmware-2.bin has been checked, it is the same as offered here:
https://github.com/kvalo/ath10k-firmware

Perhaps somebody has a hint for me?

Kind regards,

André

