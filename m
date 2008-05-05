Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:33577 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbYEEPRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 11:17:34 -0400
Received: by ug-out-1314.google.com with SMTP id h2so75168ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 08:17:33 -0700 (PDT)
To: linville@tuxdriver.com
Subject: Please pull 'upstream' branch of rt2x00
Date: Mon, 5 May 2008 17:23:11 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805051723.12127.IvDoorn@gmail.com> (sfid-20080505_171653_222379_503FB97D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are 3 patches for rt2x00, they are all intended for 2.6.26 since
they fix serious bugs. Patch 1 should prevent problems as reported by
Johannes Berg regarding skb->truesize by removing the only pskb_expand_head()
call in rt2x00 (and use a already existing buffer instead).

Patches 2 and 3 fix problems when DMA allocation fails, that usually doesn't happen,
hence the reason these problems have gone unnoticed for so long. :S

Ivo

---
The following changes since commit 0bacadffc86bcba2fdf2b989afc286a8184664a0:
  Ivo van Doorn (1):
        rt2x00: Fix quality/activity led handling

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Gertjan van Wingerde (1):
      rt2x00: Clean up error handling of PCI queue DMA allocation.

Ivo van Doorn (2):
      rt2x00: Don't use pskb_expand_head()
      rt2x00: Fix broken recover-on-error path

 drivers/net/wireless/rt2x00/rt2x00dev.c |   11 ++++-------
 drivers/net/wireless/rt2x00/rt2x00pci.c |    5 +++--
 drivers/net/wireless/rt2x00/rt61pci.c   |   31 +++++++++++--------------------
 3 files changed, 18 insertions(+), 29 deletions(-)
