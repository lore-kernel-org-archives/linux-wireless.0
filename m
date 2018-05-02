Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41777 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeEBRsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 13:48:15 -0400
Received: by mail-pg0-f68.google.com with SMTP id m21-v6so11156740pgv.8
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2018 10:48:15 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH v2 0/3] Few NFC fixes from android-4.14 tree
Date: Wed,  2 May 2018 23:18:05 +0530
Message-Id: <1525283288-7027-1-git-send-email-amit.pundir@linaro.org> (sfid-20180502_195037_497208_2878E504)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Submitting v2 of NFC fixes I picked up from android-4.14 tree[1]
for review and comments.

Again like to point out that I have not feature tested these patches
at all. Only made small cosmetic changes to the original patches
(removed Android-only tag and internal bug ID) and build tested for
arm, before posting them here for review.

Really appreciate any comments or feedback on how to take it forward.

Changes since v1:
* Dropped "NFC: st21nfca: Fix memory OOB and leak issues in connectivity
  events handler" patch for now. I'm yet to verify if the additional
  aid_len and params_len checks for buffer size are really required, and
  I didn't want to hold up this patch series for one patch alone.
* Dropped redundant __func__ use dev_dbg() in "NFC: fdp: Fix possible
  buffer overflow in WCS4000 NFC driver" patch.

Also drivers/nfc/fdp/ is full of __func__ parameter usage in dev_dbg(),
so submitting a new patch separately to clean that up.

Regards,
Amit Pundir
[1] https://android.googlesource.com/kernel/common/+log/android-4.14

Suren Baghdasaryan (3):
  NFC: st21nfca: Fix out of bounds kernel access when handling ATR_REQ
  NFC: Fix possible memory corruption when handling SHDLC I-Frame
    commands
  NFC: fdp: Fix possible buffer overflow in WCS4000 NFC driver

 drivers/nfc/fdp/fdp.c      | 22 +++++++++++-----------
 drivers/nfc/fdp/i2c.c      | 29 ++++++++++++++++++-----------
 drivers/nfc/st21nfca/dep.c |  3 ++-
 net/nfc/hci/core.c         | 10 ++++++++++
 4 files changed, 41 insertions(+), 23 deletions(-)

-- 
2.7.4
