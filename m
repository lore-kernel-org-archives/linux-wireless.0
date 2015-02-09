Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43349 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbbBIR5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 12:57:47 -0500
Received: by iecrp18 with SMTP id rp18so14000825iec.10
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 09:57:47 -0800 (PST)
MIME-Version: 1.0
From: Steeve Morin <steeve.morin@gmail.com>
Date: Mon, 9 Feb 2015 18:57:26 +0100
Message-ID: <CAEZVCP4bNmfnHH=Ksi6wMQoqdZGbprUH5X_VA41GRf9=h2MT1A@mail.gmail.com> (sfid-20150209_185750_650415_98363C61)
Subject: brcmfmac + AP6120 (brcm43362) doesn't connect to WPA2 AP (unprotected ok)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless,

I'm running brcmfmac from backports-3.19-rc1-1 on linux 3.10. running
on an arm Amlogic S805 (cortex-a5, arm7) board (CX-S859).

I had to apply multiple custom patches [1]:
- Make sure the wifi chip is on via custom GPIO [1]
- Remove a problematic piece of code related to power manager (will
look into it later) [1]
- Mix the mmc->max_blk_count on the host (would cause a BUG_ON
assertion later on) [2] [3]

After that, I am able to modprobe brcmfmac see wlan0.
The interface correctly scans for wifi aps, and I can connect to
unprotected ones.

It fails, however, to connect to WPA/WPA2 protected aps. I have
attached a debug log obtained with debug=0xffffff [4]
I don't see any errors in it though...

Would anyone of you guys have any idea why ?

Thanks a lot,

[1] https://gist.github.com/steeve/10a9a643476cea99abf4#file-backports-power-on-wifi-sdio-patch
[2] https://gist.github.com/steeve/10a9a643476cea99abf4#file-fix-block-size-patch
[3] https://github.com/codesnake/linux-amlogic/blob/master/drivers/amlogic/mmc/aml_sdio.c#L317
[4] https://gist.github.com/steeve/10a9a643476cea99abf4#file-003-dmesg-log
-- 
Steeve Morin
twitter.com/steeve
github.com/steeve
linkd.in/smorin
