Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbeB0XVH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:07 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile.desu@gmail.com
Cc: kubakici@wp.pl, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        stephen.boyd@linaro.org, broonie@kernel.org,
        dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFT 0/7] firmware: enable caching of firmware for reboot optimization
Date: Tue, 27 Feb 2018 15:20:54 -0800
Message-Id: <20180227232101.20786-1-mcgrof@kernel.org> (sfid-20180228_002556_309539_33531051)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices have optimizations in place which enable devices to retain the
firmware on reboot. Some drivers check for this and if present on probe they
don't request the firmware. This can be an issue if the system suspends after
this given the firmware is still needed on resume. Since the request firmware
call was not issued no cache was done.

This series exposes a way for drivers to setup the cache, while also
doing some minor sanity checks. This series only contains the delta from
my last submission of patches for the firmware API for v4.17.

Cantabile, please give these patches a spin and let me know if it fixes
your reported issue. They depend on other pending patches I have in line
waiting to be merged so the easiest I thing I think is for you to test my
20180227-firmware-cache branch [0], based on Linus' tree. To get that
tree, cd into your Linus git tree and do:

git remote add mcgrof https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git
git checkout -b 20180227-firmware-cache mcgrof/20180227-firmware-cache

Please let me know if this resolves your issue and thanks for your report.

  Luis

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20180227-firmware-cache


Luis R. Rodriguez (7):
  rename: _request_firmware_load() fw_load_sysfs_fallback()
  firmware: fix checking for return values for fw_add_devm_name()
  firmware: make fw_add_devm_name() return 0 if cache present
  firmware: add helper to check to see if fw cache is setup
  firmware: ensure the firmware cache is not used on incompatible calls
  firmware: add request_firmware_cache() to help with cache on reboot
  mt7601u: use request_firmware_cache() to address cache on reboot

 .../driver-api/firmware/fallback-mechanisms.rst    |  2 +-
 .../driver-api/firmware/request_firmware.rst       | 14 +++++
 drivers/base/firmware_fallback.c                   |  4 +-
 drivers/base/firmware_loader.c                     | 61 ++++++++++++++++++++--
 drivers/net/wireless/mediatek/mt7601u/mcu.c        |  2 +-
 include/linux/firmware.h                           |  3 ++
 6 files changed, 77 insertions(+), 9 deletions(-)

-- 
2.16.2
