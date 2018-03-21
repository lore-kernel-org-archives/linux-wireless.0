Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753761AbeCUWee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 18:34:34 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v4 0/3] firmware: add firmware_request_cache()
Date: Wed, 21 Mar 2018 15:34:27 -0700
Message-Id: <20180321223430.21388-1-mcgrof@kernel.org> (sfid-20180321_233552_495117_985584FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

Here are the last straggler patches to clean up what was left which you
requested and to add the new firmware_request_cache() call to fix a
corner case suspend issue.

The extra space character you found in earlier patches no longer needs
to be fixed as that assignement was replaced with a new line in later
patches which does not have the extra space in the assignment. The only
other straggler fix needed which you had pointed out was the debugfs typo.

The new API call was renamed as suggested to firmware_request_cache(),
with the API name first. I'll use a separate series to start addressing
the firmware API rename for the rest of the callers. That will take some
time as I'm running quite a bit of tests on those changes and I am going
to wait for 0-day to give me its blesssings.

Question, feedback, and specially rants are greatly appreciated.

  Luis

Luis R. Rodriguez (3):
  firmware: fix typo on pr_info_once() when ignore_sysfs_fallback is
    used
  firmware: add firmware_request_cache() to help with cache on reboot
  mt7601u: use firmware_request_cache() to address cache on reboot

 .../driver-api/firmware/request_firmware.rst       | 14 +++++++++++++
 drivers/base/firmware_loader/fallback.c            |  2 +-
 drivers/base/firmware_loader/main.c                | 24 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt7601u/mcu.c        |  2 +-
 include/linux/firmware.h                           |  3 +++
 5 files changed, 43 insertions(+), 2 deletions(-)

-- 
2.16.2
