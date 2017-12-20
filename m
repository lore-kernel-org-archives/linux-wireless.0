Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:45582 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756207AbdLTTvb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 14:51:31 -0500
Received: by mail-pl0-f67.google.com with SMTP id o2so9611959plk.12
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 11:51:31 -0800 (PST)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 0/4] Few NFC changes from experimental/android-4.14 tree
Date: Thu, 21 Dec 2017 01:21:20 +0530
Message-Id: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org> (sfid-20171220_205251_260277_C4FE0EB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I ran into following NFC fixes in experimental/android-4.14 tree[1]
and they seem like reasonable upstream candidates. So posting them
here for review and comments.

Also like to point out that I have not feature tested these patches
at all. Only made a couple of small tweaks to the patches (removed
Android-only tag and internal bug ID) and build tested for arm/arm64
defconfigs, before posting them on the mailing list as is.

Really appreciate any concerns or feedback.

Regards,
Amit Pundir
[1] https://android.googlesource.com/kernel/common/+log/experimental/android-4.14


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
