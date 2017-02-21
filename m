Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33842 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdBUVrA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 16:47:00 -0500
Received: by mail-wm0-f50.google.com with SMTP id 196so31841229wmm.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 13:46:59 -0800 (PST)
Received: from ?IPv6:2a01:5c0:1a:21d1:d0f2:ed9a:2d47:e07e? ([2a01:5c0:1a:21d1:d0f2:ed9a:2d47:e07e])
        by smtp.googlemail.com with ESMTPSA id o70sm19034286wmi.26.2017.02.21.13.46.57
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Feb 2017 13:46:57 -0800 (PST)
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to suspend
 async: error -16)
To: linux-wireless@vger.kernel.org
Message-ID: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com> (sfid-20170221_224703_956817_094A0B1B)
Date: Tue, 21 Feb 2017 22:46:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear wireless experts, 

I have been trying to get basic WoWLAN to work with the following configuration:
- Intel Corporation Wireless 7260 (rev 73) with in-tree iwlwifi driver
- Kernel 4.10.0 (on Gentoo Linux)
- Very recent firmware version for the card and revision:
iwlwifi 0000:0a:00.0: loaded firmware version 17.459231.0 op_mode iwlmvm
iwlwifi 0000:0a:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144

I try to do:
$ iw phy phy0 wowlan enable magic-packet
$ iw phy phy0 wowlan show
WoWLAN is enabled:
 * wake up on magic packet

However, when trying to suspend to RAM ( echo mem > /sys/power/state ), I get:
[46656.403767] dpm_run_callback(): wiphy_suspend+0x0/0x97 [cfg80211] returns -16
[46656.403769] PM: Device phy0 failed to suspend async: error -16
[46656.967002] PM: Some devices failed to suspend, or early wake event detected

It also happens with more complex configurations (e.g. TCP connection WoWLAN mode). 

Only after:
$ iw phy phy0 wowlan disable
I can suspend normally again. 

I found an earlier report here:
https://bugzilla.kernel.org/show_bug.cgi?id=109591#c25
from somebody using kernel 4.6. 

Is this a known issue? Is WoWLAN supposed to work with this hardware (I guess it's quite wide-spread)? 

If possible, please ping me directly in replies, I am not subscribed to the list (but will try to check gmane regularly). 

Cheers and thanks for any support, 
	Oliver
