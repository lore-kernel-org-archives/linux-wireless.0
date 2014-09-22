Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12146 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaIVT4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 15:56:33 -0400
Date: Mon, 22 Sep 2014 21:55:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.17] NFC fixes
Message-ID: <20140922195553.GC4235@zurbaran> (sfid-20140922_215636_850950_A41DA7B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Hopefully not too late for a handful of NFC fixes:

- 2 potential build failures for ST21NFCA and ST21NFCB, triggered by a
  depmod dependenyc cycle.
- One potential buffer overflow in the microread driver.

The following changes since commit 1bd3fa7b8c9b2936c16c6e6452f9cc991c405872:

  Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2014-09-04 13:12:02 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.17-1

for you to fetch changes up to 300c627fbc52aa5b2117ca267907ab8d7b990ead:

  NFC: st21nfca: Fix potential depmod dependency cycle (2014-09-07 23:45:53 +0200)

----------------------------------------------------------------
Christophe Ricard (2):
      NFC: st21nfcb: Fix depmod dependency cycle
      NFC: st21nfca: Fix potential depmod dependency cycle

Dan Carpenter (1):
      NFC: microread: Potential overflows in microread_target_discovered()

 drivers/nfc/microread/microread.c | 16 ++++++++++++----
 drivers/nfc/st21nfca/Makefile     |  5 +++--
 drivers/nfc/st21nfcb/Makefile     |  5 +++--
 3 files changed, 18 insertions(+), 8 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
