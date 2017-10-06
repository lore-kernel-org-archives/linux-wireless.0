Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:55270 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdJFWTA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 18:19:00 -0400
Received: by mail-io0-f179.google.com with SMTP id h66so17247360ioh.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Oct 2017 15:18:59 -0700 (PDT)
Received: from [10.73.41.175] ([65.154.145.130])
        by smtp.gmail.com with ESMTPSA id m192sm1369266itm.26.2017.10.06.15.18.58
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Oct 2017 15:18:58 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Dennis Millard <dennis@tealdrones.com>
Subject: Restricting BCM4354 to 802.11b only
Message-ID: <820714b7-e1de-33eb-2437-d2539608e50c@tealdrones.com> (sfid-20171007_001903_721896_7A5674DB)
Date: Fri, 6 Oct 2017 16:18:57 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm developing on an nVidia TX1 SOM which has an integrated BCM4354 
chipset which is a fullmac DSIO 11ac chip. The SOM is running Ubuntu 
16.04 Linux (64-bit ARM)

I have an application where I need long range with low bandwidth 
requirements.  It seems that 802.11b has the best receive sensitivity, 
and I need to reduce latency caused by modulation switching (i.e. 802.11 
b, g, n etc).  I'm looking for a way to configure the BCM43 chipset to 
lock in to 802.11b mode only, so I want to disable 802.11g and 802.11n 
modes.

I've seen references on google to the Broadcom WLAN client utility, or 
"wl", but it's not freely available anywhere.

I'm capable of making kernel driver modifications if necessary, but I 
don't have the required information to do this.  Cypress has bought the 
Broadcom line, and some support person from Cypress suggested the following:

"For your query, we have different IOV and IOCTL calls for doing so. 
There is a IOV_NMODE (set to 0 disable 802.11n mode) and ioctl WLC_GMODE 
(set to 0 to disable 802.11g mode) . You need to make these calls during 
the system initialization phase to use 802.11b only mode."

I don't see any references to the WLC_GMODE ioctl in the brcfmac driver 
source, so I haven't been able to make that ioctl call in my code.


Does anyone have any advice on how to do this?  Thanks.

    -Dennis
