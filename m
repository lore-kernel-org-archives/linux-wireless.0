Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:52236 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbFHMii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:38:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/4] brcmfmac: pcie fixes and debugfs cleanup
Date: Mon, 8 Jun 2015 14:38:31 +0200
Message-ID: <1433767115-8136-1-git-send-email-arend@broadcom.com> (sfid-20150608_143842_408746_46F31ABD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Summary of this series:

* fix module reload issue for PCIe.
* improving msgbuf protocol for PCIe devices.
* cleanup of the debugfs code.

This series is intended for v4.2 kernel and applies to the master
branch of the wireless-drivers-next repository.

Arend van Spriel (3):
  brcmfmac: remove chipinfo debugfs entry
  brcmfmac: remove watchdog reset from brcmf_pcie_buscoreprep()
  brcmfmac: use debugfs_create_devm_seqfile() helper function

Hante Meuleman (1):
  brcmfmac: Update msgbuf read pointer quicker.

 .../net/wireless/brcm80211/brcmfmac/commonring.c   | 19 ++++----
 .../net/wireless/brcm80211/brcmfmac/commonring.h   |  3 +-
 drivers/net/wireless/brcm80211/brcmfmac/debug.c    | 50 ++--------------------
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 12 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     | 16 +------
 5 files changed, 27 insertions(+), 73 deletions(-)

-- 
1.9.1

