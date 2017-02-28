Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp2.bon.at ([213.33.87.16]:47515 "EHLO bsmtp5.bon.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751670AbdB1JdQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 04:33:16 -0500
Received: from bsmtp7.bon.at (unknown [192.168.181.108])
        by bsmtp5.bon.at (Postfix) with ESMTPS id 3vXXzw3lHKz5vgK
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 10:18:04 +0100 (CET)
To: linux-wireless@vger.kernel.org
Cc: "Bernhard Miller (bernhard.miller@streamunlimited.com)"
        <bernhard.miller@streamunlimited.com>
From: "ondrej.topolsky@streamunlimited.com"
        <ondrej.topolsky@streamunlimited.com>
Subject: mwifiex on 8977 8897 beacon frames forwarding
Message-ID: <fdacd0ce-a4bc-c0a0-7d1d-24796052a8b0@streamunlimited.com> (sfid-20170228_103511_680053_C54AA23E)
Date: Tue, 28 Feb 2017 10:17:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is there any way how to properly get beacon frames from firmware? Not 
sure if anybody tried that or played with that.
CMD_802_11_RX_MGMT_INDICATION is not working as expected (details below 
the line)
and we do not want to use monitor mode for this.
Is there probably something undocumented?
Or is there any firmware for 8977 and 8897 which would forward the 
management frames?

I guess this is some "if statement" buried in the firmware which is 
black box for us

---

On  8977 the command CMD_802_11_RX_MGMT_INDICATION gets through 
successfully(tried various masks like 256 and others),
but the beacons are not coming from data path
(checking all packets, the best what we can get is probe request frames 
40 00).
However we can get them in monitor mode (but this is unusable solution 
for us).

On 8897 the situation is the same - the command gets through, but the 
beacons are not coming..
the monitor mode cannot be turned on because the command returns 2 - 
unsupported.

Any hints or ideas would be highly appreciated
Thanks and all the best,

Ondrej from Stream Unlimited.
