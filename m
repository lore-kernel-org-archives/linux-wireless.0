Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57080 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbeGXLFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:31 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 00/11] NFC: A bunch of cleanups for st95hf
Date: Tue, 24 Jul 2018 11:59:30 +0200
Message-Id: <20180724095941.25777-1-daniel@zonque.org> (sfid-20180724_120136_439030_1EB25147)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v3 of a series of patches for the ST95HF driver.

Patch #1 reverts a change that I have submitted earlier and which is
sitting in nfc-next already. Given that the tree hasn't been sent out
for being merged yet, it could also still be removed with rebasing, in
which case #1 is not necessary of course.

The changes are all rather simple and are explained in their individual
commit logs.

Note that this series builds upon the patch titled "nfc: st95hf: remove
redundant pointers 'dev' and 'nfcddev'" that Colin posted the other day.


Thanks,
Daniel

Changelog:

v1 → v2:

 * Improved commit logs, identical patch content.


v2 → v3:

 * Added another patch titled "NFC: st95hf: ignore spurious interrupts"


Daniel Mack (11):
  Revert "NFC: st95hf: drop illegal kfree_skb()"
  NFC: st95hf: drop nfcdev_free
  NFC: st95hf: drop illegal kfree_skb() in IRQ handler
  NFC: st95hf: remove logging from spi functions
  NFC: st95hf: remove exchange_lock
  NFC: st95hf: move skb allocation to ISR
  NFC: st95hf: ignore spurious interrupts
  NFC: st95hf: re-order command defines
  NFC: st95hf: unify sync/async flags
  NFC: st95hf: two small style nits
  NFC: st95hf: add of match table

 drivers/nfc/st95hf/core.c | 154 ++++++++++++++------------------------
 drivers/nfc/st95hf/spi.c  |  31 +++-----
 drivers/nfc/st95hf/spi.h  |   8 +-
 3 files changed, 66 insertions(+), 127 deletions(-)

-- 
2.17.1
