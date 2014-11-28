Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:61332 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaK1QlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 11:41:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Catalin Iacob <iacobcatalin@gmail.com>
Subject: [PATCH 0/3 for 3.18] rtlwifi: rtl8192ce: Patches to fix the regression reported in Bug #88951
Date: Fri, 28 Nov 2014 10:41:13 -0600
Message-Id: <1417192876-12101-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141128_174145_973550_1002BA07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These three patches are needed to fix a regression in kernel 3.18 that is
reported in Bug #88951. I hate to be the guy with the last-minute fixes;
however, this regression reminded me of the children's game called Whack-a-mole.
Whenever I thought that I had found the problem, the bug popped up elsewhere.
Finally I am coinfident that I have fixed the problem.

Fortunately, the patches are all fairly small, and they are self-contained within
a single driver. There are unlikely to be any unfavorable side effects.

If it is not possible to get these patches into 3.18, then mark them to be
backported to stable (3.18 only). That way they will be available in 3.18.1.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Catalin Iacob <iacobcatalin@gmail.com>
Tested-by: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>
---

Larry Finger (3):
  rtlwifi: rtl8192ce: Fix editing error that causes silent memory
    corruption
  rtlwifi: rtl8192ce: Fix kernel crashes due to missing callback entry
  rtlwifi: rtl8192ce: Fix missing interrupt ready flag

 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |  3 ++-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |  3 +++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c | 24 ++++++++++++++++++++----
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |  2 ++
 4 files changed, 27 insertions(+), 5 deletions(-)

-- 
2.1.2

