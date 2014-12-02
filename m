Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbaLBWh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 17:37:57 -0500
Date: Tue, 2 Dec 2014 23:37:49 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.19] NFC update
Message-ID: <20141202223749.GA31964@ribalta.ger.corp.intel.com> (sfid-20141202_233803_425227_CF9E0957)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the NFC pull request for 3.19.

With this one we get:

- NFC digital improvements for DEP support: Chaining, NACK and ATN
  support added.

- NCI improvements: Support for p2p target, SE IO operand addition,
  SE operands extensions to support proprietary implementations, and
  a few fixes.

- NFC HCI improvements: OPEN_PIPE and NOTIFY_ALL_CLEARED support,
  and SE IO operand addition.

- A bunch of minor improvements and fixes for STMicro st21nfcb and
  st21nfca

Thanks in advance for pulling that one in.


The following changes since commit 18ca43823f3ce111c6efb8cc90d9f35246527727:

  mwifiex: add Tx status support for ACTION frames (2014-11-25 14:09:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.19-1

for you to fetch changes up to e479ce479743984a5d4581749f9aaa9c3bfd65e4:

  NFC: NCI: Fix max length of General Bytes in ATR_RES (2014-12-02 22:59:28 +0100)

----------------------------------------------------------------
Axel Lin (1):
      NFC: llcp: Use list_for_each_entry in llcp_accept_poll

Christophe Ricard (25):
      NFC: st21nfca: Add of_st21nfca_i2c_match to MODULE_DEVICE_TABLE
      NFC: st21nfca: Remove gpio_irq field in static and dts configuration
      NFC: st21nfcb: Add of_st21nfcb_i2c_match to MODULE_DEVICE_TABLE
      NFC: st21nfcb: Remove gpio_irq field in static and dts configuration
      NFC: hci: Add se_io HCI operand
      NFC: nci: Fix sparse: symbol 'nci_get_prop_rf_protocol' was not declared.
      NFC: nci: Update nci_discover_se to run proprietary commands to discover all available secure element
      NFC: nci: Update nci_enable_se to run proprietary commands to enable a secure element
      NFC: nci: Update nci_disable_se to run proprietary commands to disable a secure element
      NFC: nci: Add se_io NCI operand
      NFC: st21nfca: Rework st21nfca_hci_event_received to route event to relevent gate.
      NFC: st21nfcb: Improve ndlc comment
      NFC: hci: Add open pipe command handler
      NFC: hci: Add support for NOTIFY_ALL_PIPE_CLEARED
      NFC: st21nfcb: Remove useless pr_info
      NFC: nci: Add status byte management in case of error.
      NFC: nci: Add management for NCI state for machine rf_deactivate_ntf
      NFC: nci: Add support for different NCI_DEACTIVATE_TYPE
      NFC: netlink: Add new netlink command NFC_CMD_ACTIVATE_TARGET
      NFC: Add se_io NFC operand
      NFC: hci: Add specific hci macro to not create a pipe
      NFC: st21nfca: Report error returned by functions instead of -ENODEV
      NFC: st21nfcb: Fix reported error
      NFC: Fix warning "warning: incorrect type in assignment"
      NFC: nci: Fix warning: cast to restricted __le16

Johannes Berg (1):
      NFC: Don't include linux/unaligned/access_ok.h

Julien Lefrique (10):
      NFC: NCI: Add passive Listen modes in discover request
      NFC: NCI: Enable NFC-DEP in Listen A and Listen F
      NFC: NCI: Handle Target mode activation
      NFC: NCI: Configure ATR_RES general bytes
      NFC: NCI: Implement Target mode send function
      NFC: NCI: Forward data received in Target mode to nfc core
      NFC: Fix a memory leak
      NFC: NCI: Handle Discovery deactivation type
      NFC: NCI: Signal deactivation in Target mode
      NFC: NCI: Fix max length of General Bytes in ATR_RES

Mark A. Greer (13):
      NFC: digital: Fix potential skb leaks in NFC-DEP code
      NFC: digital: Rearrange NFC-DEP DEP_REQ/DEP_RES Code
      NFC: digital: Ensure no DID in NFC-DEP responses
      NFC: digital: Add Target-mode NFC-DEP DID Support
      NFC: digital: Ensure no NAD byte in DEP_REQ and DEP_RES frames
      NFC: digital: Enforce NFC-DEP PNI sequencing
      NFC: digital: Implement NFC-DEP max payload lengths
      NFC: digital: Add NFC-DEP Send Chaining Support
      NFC: digital: Add NFC-DEP Receive Chaining Support
      NFC: digital: Add NFC-DEP Initiator-side NACK Support
      NFC: digital: Add NFC-DEP Target-side NACK Support
      NFC: digital: Add NFC-DEP Initiator-side ATN Support
      NFC: digital: Add NFC-DEP Target-side ATN Support

 drivers/nfc/pn544/i2c.c                |   2 +-
 drivers/nfc/st21nfca/i2c.c             |  41 +-
 drivers/nfc/st21nfca/st21nfca.c        |  32 +-
 drivers/nfc/st21nfca/st21nfca.h        |   2 -
 drivers/nfc/st21nfca/st21nfca_dep.c    |  47 +-
 drivers/nfc/st21nfca/st21nfca_dep.h    |   4 +-
 drivers/nfc/st21nfcb/i2c.c             |  39 +-
 drivers/nfc/st21nfcb/ndlc.c            |   2 +-
 include/linux/platform_data/st21nfca.h |   1 -
 include/linux/platform_data/st21nfcb.h |   1 -
 include/net/nfc/digital.h              |  13 +
 include/net/nfc/hci.h                  |   4 +
 include/net/nfc/nci.h                  |  37 +-
 include/net/nfc/nci_core.h             |   9 +
 include/net/nfc/nfc.h                  |   2 +
 include/uapi/linux/nfc.h               |  23 +-
 net/nfc/digital_dep.c                  | 834 ++++++++++++++++++++++++++++++---
 net/nfc/hci/command.c                  |   3 +
 net/nfc/hci/core.c                     |  56 +++
 net/nfc/llcp_commands.c                |   6 +-
 net/nfc/llcp_core.c                    |   5 +-
 net/nfc/llcp_sock.c                    |   6 +-
 net/nfc/nci/core.c                     | 150 +++++-
 net/nfc/nci/data.c                     |  24 +-
 net/nfc/nci/ntf.c                      | 152 ++++--
 net/nfc/netlink.c                      |  77 ++-
 26 files changed, 1328 insertions(+), 244 deletions(-)
