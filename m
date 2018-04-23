Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:45719 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932306AbeDWUMP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 16:12:15 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 0/9] Loading optional firmware v4
Date: Mon, 23 Apr 2018 16:11:56 -0400
Message-Id: <20180423201205.20533-1-andresx7@gmail.com> (sfid-20180423_221218_763684_8C9BB62B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Everyone,

This is a trimmed down version of v3 that contains the changes for which we
have agreement. Changes that raised concern are being shifted to a followup
series, mainly changes to the async firmware API.

Inline feedback I received in these patches has also been addressed, thanks
everyone that chimed in.

I'll be following up with some proposals for the async API. Hopefully we can
end up with something that is not "the least bad" option.

This series can be found in the for-luis-v4 branch of:
https://github.com/lostgoat/linux.git

Andres Rodriguez (9):
  firmware: some documentation fixes
  firmware: wrap FW_OPT_* into an enum
  firmware: add kernel-doc for enum fw_opt
  firmware: use () to terminate kernel-doc function names
  firmware: add function to load firmware without warnings v5
  firmware: print firmware name on fallback path
  firmware: use rename fw_sysfs_fallback to use the firmware_ prefix
  ath10k: use request_firmware_nowarn to load firmware
  ath10k: re-enable the firmware fallback mechanism for testmode

 .../driver-api/firmware/request_firmware.rst       | 21 +++++----
 drivers/base/firmware_loader/fallback.c            | 30 ++++++------
 drivers/base/firmware_loader/fallback.h            | 12 +++--
 drivers/base/firmware_loader/firmware.h            | 38 +++++++++++----
 drivers/base/firmware_loader/main.c                | 54 ++++++++++++++++------
 drivers/net/wireless/ath/ath10k/core.c             |  2 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |  2 +-
 include/linux/firmware.h                           |  2 +
 8 files changed, 108 insertions(+), 53 deletions(-)

-- 
2.14.1
