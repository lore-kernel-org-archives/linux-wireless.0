Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38125 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeDRKFM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 06:05:12 -0400
Received: by mail-pg0-f67.google.com with SMTP id b5so633190pgv.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 03:05:11 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RESEND][PATCH 0/4] Few NFC fixes from android-4.14 tree
Date: Wed, 18 Apr 2018 15:35:00 +0530
Message-Id: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org> (sfid-20180418_120652_489279_7B363653)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Resending few NFC fixes I picked up from android-4.14 tree[1]
for review and comments. They seem reasonable upstream candidates.
My last attempt was not timed properly and it got lost between
Christmas-New Year break and then Meltdown-Spectre happened.

Also like to point out that I have not feature tested these patches
at all. Only made small cosmetic changes to the original patches
(removed Android-only tag and internal bug ID) and build tested for
arm/arm64 defconfigs, before posting them here for review.

Really appreciate any comments or feedback on how to take it forward.

Regards,
Amit Pundir
[1] https://android.googlesource.com/kernel/common/+log/android-4.14

Suren Baghdasaryan (4):
  NFC: st21nfca: Fix out of bounds kernel access when handling ATR_REQ
  NFC: st21nfca: Fix memory OOB and leak issues in connectivity events
    handler
  NFC: Fix possible memory corruption when handling SHDLC I-Frame
    commands
  NFC: fdp: Fix possible buffer overflow in WCS4000 NFC driver

 drivers/nfc/fdp/i2c.c      | 10 ++++++++++
 drivers/nfc/st21nfca/dep.c |  3 ++-
 drivers/nfc/st21nfca/se.c  | 18 ++++++++++++++----
 net/nfc/hci/core.c         | 10 ++++++++++
 4 files changed, 36 insertions(+), 5 deletions(-)

-- 
2.7.4
