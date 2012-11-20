Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab2KTAmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 19:42:13 -0500
Date: Tue, 20 Nov 2012 01:42:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.8] NFC pull request
Message-ID: <20121120004210.GA15237@sortiz-mobl> (sfid-20121120_014218_713039_8A398B52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the 2nd NFC pull request for 3.8.

With this one we have:

- A few HCI improvements in preparation for an upcoming HCI chipset support.
- A pn544 code cleanup after the old driver was removed.
- An LLCP improvement for notifying user space when one peer stops ACKing I
  frames.

Thanks in advance for pulling those in.

The following changes since commit ac46ba4384d2c44c56702d0da591696045fba682:

  ath9k: Fix BTCOEX debugfs file usage (2012-11-19 10:45:40 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-next-3.8-2

for you to fetch changes up to be02b6b624005d47c388f799ce23714136430217:

  NFC: Queue a copy of the transmitted LLCP skb (2012-11-19 23:57:01 +0100)

----------------------------------------------------------------
Eric Lapuyade (5):
      NFC: Fix hci_connect_gate() when a pre-opened pipe is passed
      NFC: Ignore err when chip doesn't implement HW/SW info registers
      NFC: Dot not dispatch HCI event received on unopened pipe
      NFC: Export nfc_hci_result_to_errno as it can be needed by HCI drivers
      NFC: Export nfc_hci_sak_to_protocol()

Marcel Holtmann (3):
      NFC: Remove unused details from pn544.h header file
      NFC: Move pn544.h to linux/platform_data/
      MAINTAINERS: Add reference to pn544.h platform data header

Samuel Ortiz (3):
      NFC: Copy user space buffer when sending UI frames
      NFC: Stop sending LLCP frames when tx queues are getting too deep
      NFC: Queue a copy of the transmitted LLCP skb

 MAINTAINERS                         |    1 +
 drivers/nfc/pn544/i2c.c             |    2 +-
 include/linux/nfc/pn544.h           |  104 -----------------------------------
 include/linux/platform_data/pn544.h |   44 +++++++++++++++
 include/net/nfc/hci.h               |    3 +
 net/nfc/hci/command.c               |    4 +-
 net/nfc/hci/core.c                  |   25 ++++++---
 net/nfc/llcp/commands.c             |   32 ++++++++++-
 net/nfc/llcp/llcp.c                 |   17 ++++--
 9 files changed, 112 insertions(+), 120 deletions(-)
 delete mode 100644 include/linux/nfc/pn544.h
 create mode 100644 include/linux/platform_data/pn544.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
