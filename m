Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39907 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbHPGzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 02:55:53 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 0/7] brcmfmac: nvram loading and code rework
Date: Sun, 16 Aug 2015 08:55:32 +0200
Message-ID: <1439708139-7527-1-git-send-email-arend@broadcom.com> (sfid-20150816_085609_376528_D1417DF4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series comprises of following changes:
- support NVRAM loading for bcm47xx platform.
- revise announced interface combinations and validate against it.
- new debugfs entry for msgbuf protocol layer used with PCIe devices.
- couple of PCIe fixes.
- support more firmware events (for bcm4339 firmware).

The series is intended for v4.3 kernel and applies to the master branch
of the wireless-drivers-next repository.

Arend van Spriel (3):
  brcmfmac: correct interface combination info
  brcmfmac: make use of cfg80211_check_combinations()
  brcmfmac: bump highest event number for 4339 firmware

Franky Lin (2):
  brcmfmac: add debugfs entry for msgbuf statistics
  brcmfmac: block the correct flowring when backup queue overflow

Hante Meuleman (2):
  brcmfmac: Add support for host platform NVRAM loading.
  brcmfmac: Increase nr of supported flowrings.

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 195 ++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |  40 +++--
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  48 ++---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |  20 +--
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  67 ++++++-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h   |   2 +-
 7 files changed, 289 insertions(+), 93 deletions(-)

-- 
1.9.1

