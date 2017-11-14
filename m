Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50175 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754798AbdKNOEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 09:04:37 -0500
MIME-Version: 1.0
Message-ID: <trinity-e7299e0d-f03e-486c-acdd-f84e9b6d3a32-1510668275455@3c-app-gmx-bs68> (sfid-20171114_150442_363648_FDAD9A47)
From: "Porto Rio" <porto.rio@gmx.net>
To: linux-wireless@vger.kernel.org
Subject: mwifiex: how to restrict txpower per channel and regulatory region?
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Nov 2017 15:04:35 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All

For (worldwide) regulatory compliance / WiFi certification I need to restrict/limit the txpower dependent on channels and regulatory region code. At the moment I can restrict it generally via e.g. "iw dev mlan0 set txpower fixed 800". Furthermore I can specify the allowed channels/frequencies with wireless-regdb and crda. Is there some similar way to limit the txpower?

I am using mwifiex (of LTS kernel 4.4 at the moment) on the ARM platform with Marvell chip 88W8897.

There is some Marvell-specific way (specify txpwrlimit_cfg.conf, convert it to txpower_XX.bin file and put this into /lib/firmware/mrvl dir) which seems to work only with the reference driver published in Marvell's Extranet but not with the (open source) mwifiex driver which I want to use. Is this right? 
I was asking myself if there is some (more general) Linux way to accomplish this with the open source driver(s), although the txpower limits are dependent on specific hardware parameters (cable loss, antenna gain).

Thanks and best regards,
Matthias
