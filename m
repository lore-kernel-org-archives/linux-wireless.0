Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33408 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcDZROO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 13:14:14 -0400
Received: by mail-pf0-f172.google.com with SMTP id 206so9266135pfu.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 10:14:14 -0700 (PDT)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Intel WiFi regression on linux-next
Date: Tue, 26 Apr 2016 10:14:11 -0700
Message-ID: <87d1pcthr0.fsf@gmail.com> (sfid-20160426_191419_153186_8ED9971D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

WiFi on my Acer Aspire 5739G is currently broken on linux-next.  I
bisected it to the following commit:

    commit 97f95c93c8ed5177371e75275f236513152fa308
    Author: Sara Sharon <sara.sharon@intel.com>
    Date:   Mon Mar 7 16:55:20 2016 +0200
    
        iwlwifi: remove support for fw older than -16.ucode

This issue was already reported here [1].  I'm just adding some more
hardware details (and am not subscribed to linux-wireless so I can't
reply over there).

It's failing with:

    iwlwifi 0000:05:00.0: enabling device (0000 -> 0002)
    iwlwifi 0000:05:00.0: can't disable ASPM; OS doesn't have ASPM control
    iwlwifi 0000:05:00.0: Driver unable to support your firmware API. Driver supports v5, firmware is v139658497.
    iwlwifi 0000:05:00.0: Direct firmware load for iwlwifi-5000-4.ucode failed with error -2
    iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
    iwlwifi 0000:05:00.0: Direct firmware load for iwlwifi-5000-3.ucode failed with error -2
    iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
    iwlwifi 0000:05:00.0: Driver unable to support your firmware API. Driver supports v5, firmware is v135791116.
    iwlwifi 0000:05:00.0: Driver unable to support your firmware API. Driver supports v5, firmware is v84148496.
    iwlwifi 0000:05:00.0: no suitable firmware found!

Here's some more info on my wireless chipset:

    05:00.0 Network controller: Intel Corporation WiFi Link 5100
            Subsystem: Intel Corporation WiFi Link 5100 AGN
            Flags: bus master, fast devsel, latency 0, IRQ 31
            Memory at c0400000 (64-bit, non-prefetchable) [size=8K]
            Capabilities: [c8] Power Management version 3
            Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
            Capabilities: [e0] Express Endpoint, MSI 00
            Capabilities: [100] Advanced Error Reporting
            Capabilities: [140] Device Serial Number 00-1e-65-ff-ff-80-25-f6
            Kernel driver in use: iwlwifi
            Kernel modules: iwlwifi

The laptop isn't _that_ old so I'm surprised the driver is ripping out
support for it...  Is there some other driver I should be using?


[1] https://www.mail-archive.com/linux-wireless@vger.kernel.org/msg22688.html


-- 
Mitch
