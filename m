Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35953 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdKVNO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 08:14:26 -0500
Received: by mail-qk0-f172.google.com with SMTP id o6so16633852qkh.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Nov 2017 05:14:26 -0800 (PST)
Subject: Re: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
 Marvell ESPRESSOBin
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
References: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
 <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com>
 <7d8c7705-70ac-9a36-b5d2-23fcffcf6a29@gmail.com>
 <4dbd89bbcb0a4706bf3fe7b79025d95c@SC-EXCH02.marvell.com>
From: Ellie Reeves <ellierevves@gmail.com>
Message-ID: <6e26f5b1-10a7-b7fc-1518-f0d0f66a50e9@gmail.com> (sfid-20171122_141430_035414_F92E3CB9)
Date: Wed, 22 Nov 2017 08:14:12 -0500
MIME-Version: 1.0
In-Reply-To: <4dbd89bbcb0a4706bf3fe7b79025d95c@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
thanks for the quick answer. To answer Ganapathi's question, all I have 
to do in order to trigger the issue is to:

1. Upgrade kernel as usual.
2. Reboot and see the wifi going insane.

If I want to get it working properly I have to:

1. Downgrade kernel to 4.12.12.
2. Make sure initramfs and the uImage for u-boot have been generated for 
the 4.12.12 kernel again (my distrubution has a script that takes care 
of this).
3. Perform a "shutdown now". A simple soft reboot, and even pressing the 
reset button on the ESPRESSObin isn't enough to completely reset the 
state, if you reboot this way you will get the "fw is already running !" 
message and it will not work. You have to unplug and then replug the 
board. After that kernel 4.12.12 will boot and wifi will work.

Here is the dmesg output:

https://paste.xogium.me/view/4dc3bebd
-- 

Ellie Reeves
