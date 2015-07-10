Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43332 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbbGJSbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 14:31:21 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: nvram loading and code rework
Date: Fri, 10 Jul 2015 20:31:04 +0200
Message-ID: <1436553071-32423-1-git-send-email-arend@broadcom.com> (sfid-20150710_203125_004056_688FCACA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series comprises of following changes:
- support NVRAM loading for bcm47xx platform.
- revise announced interface combinations and validate against it.
- new debugfs entry for msgbuf protocol layer used with PCIe devices.
- couple of PCIe fixes.
- rework dealing with interface instances.

The series is intended for v4.3 kernel and applies to the master branch
of the wireless-drivers-next repository. The first patch has been compile
tested against 4.2-rc1 as it relies on change introduced in last merge
window. Assuming wireless-drivers-next/master will move to 4.2-rc1 before
applying this series.

Arend van Spriel (3):
  brcmfmac: correct interface combination info
  brcmfmac: make use of cfg80211_check_combinations()
  brcmfmac: consolidate ifp lookup in driver core

Franky Lin (2):
  brcmfmac: add debugfs entry for msgbuf statistics
  brcmfmac: block the correct flowring when backup queue overflow

Hante Meuleman (2):
  brcmfmac: Add support for host platform NVRAM loading.
  brcmfmac: Increase nr of supported flowrings.

 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  25 ++-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 195 ++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  19 ++
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |  43 +++--
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  48 ++---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |  20 +--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  79 +++++++--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h   |   2 +-
 9 files changed, 317 insertions(+), 116 deletions(-)

-- 
1.9.1

