Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53163 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbbHTUGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 16:06:14 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
Date: Thu, 20 Aug 2015 22:06:02 +0200
Message-ID: <1440101168-2252-1-git-send-email-arend@broadcom.com> (sfid-20150820_220618_265139_8C3EE4D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series comprises of following changes:
- support NVRAM loading for bcm47xx platform.
- revise announced interface combinations and validate against it.
- new debugfs entry for msgbuf protocol layer used with PCIe devices.
- PCIe fix for handling queue overflow.
- support more firmware events (for bcm4339 firmware).

The series is intended for v4.3 kernel and applies to the master branch
of the wireless-drivers-next repository. Removed patch from this series
that reportedly has issue on OpenWrt platform.

Arend van Spriel (3):
  brcmfmac: correct interface combination info
  brcmfmac: make use of cfg80211_check_combinations()
  brcmfmac: bump highest event number for 4339 firmware

Franky Lin (2):
  brcmfmac: add debugfs entry for msgbuf statistics
  brcmfmac: block the correct flowring when backup queue overflow

Hante Meuleman (1):
  brcmfmac: Add support for host platform NVRAM loading.

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 195 ++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |  39 +++--
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  56 ++++++
 5 files changed, 247 insertions(+), 63 deletions(-)

-- 
1.9.1

