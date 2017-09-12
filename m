Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35770 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdILPtC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 11:49:02 -0400
Received: by mail-io0-f182.google.com with SMTP id g32so32205072ioj.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 08:49:02 -0700 (PDT)
To: Johannes Berg <johannes.berg@intel.com>,
        emmanuel.grumbach@intel.com,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: linuxwifi@intel.com, linux-wireless@vger.kernel.org
From: Jens Axboe <axboe@kernel.dk>
Subject: iwlwifi firmware load broken in current -git
Message-ID: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk> (sfid-20170912_174912_983962_D2E573A8)
Date: Tue, 12 Sep 2017 09:48:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have no wifi in current git (8fac2f96ab8), it simply fails with:

[    4.363481] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
[    4.363733] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
[    4.363744] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
[    4.368077] iwlwifi 0000:04:00.0: loaded firmware version 31.532993.0 op_mode iwlmvm
[    4.461753] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
[ ... ]
[    9.510570] iwlwifi 0000:04:00.0: Failed to load firmware chunk!             
[    9.513903] iwlwifi 0000:04:00.0: Could not load the [0] uCode section       
[    9.516201] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110           
[    9.530842] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110             

I get the same thing with -27 of the firmware:

[   60.990831] Intel(R) Wireless WiFi driver for Linux                          
[   60.990833] Copyright(c) 2003- 2015 Intel Corporation                        
[   60.991936] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
[   60.991941] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
[   60.991946] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
[   60.991957] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-31.ucode failed with error -2
[   60.991964] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-30.ucode failed with error -2
[   60.991969] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-29.ucode failed with error -2
[   60.991975] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
[   61.029852] iwlwifi 0000:04:00.0: loaded firmware version 27.541033.0 op_mode iwlmvm
[   61.043660] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
[   66.070135] iwlwifi 0000:04:00.0: Failed to load firmware chunk!             
[   66.070149] iwlwifi 0000:04:00.0: Could not load the [0] uCode section       
[   66.070165] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110           
[   66.083462] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110             

Things work fine in 4.13-rc7+, which was the last kernel I ran on my laptop.

-- 
Jens Axboe
