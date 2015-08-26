Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39621 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbHZUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/12] brcmfmac: multiple interface rework and cleanup
Date: Wed, 26 Aug 2015 22:14:52 +0200
Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com> (sfid-20150826_223108_446512_9260FC1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains the following:
* rework code dealing with multiple interfaces.
* allow logging firmware console using debug level.
* fix crash in error path when probe fails.
* fix memory leak in free net devices.
* minor code cleanup.

The patch series is intended for v4.3 and applies to the master
branch of the wireless-drivers-next repository.

Arend van Spriel (12):
  brcmfmac: consolidate ifp lookup in driver core
  brcmfmac: make brcmf_proto_hdrpull() return struct brcmf_if instance
  brcmfmac: change parameters for brcmf_remove_interface()
  brcmfmac: only call brcmf_cfg80211_detach() when attach was successful
  brcmfmac: correct detection of p2pdev interface event
  brcmfmac: use brcmf_get_ifp() to map ifidx to struct brcmf_if instance
  brcmfmac: pass struct brcmf_if instance in brcmf_txfinalize()
  brcmfmac: add mapping for interface index to bsscfg index
  brcmfmac: add dedicated debug level for firmware console logging
  brcmfmac: remove ifidx parameter from brcmf_fws_txstatus_suppressed()
  brcmfmac: change prototype for brcmf_fws_hdrpull()
  brcmfmac: introduce brcmf_net_detach() function

 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     | 28 +++----
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c   |  4 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  7 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 92 ++++++++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     | 10 +--
 drivers/net/wireless/brcm80211/brcmfmac/debug.h    |  3 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     | 19 +++--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 57 +++++++-------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |  3 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 18 ++---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  7 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    | 18 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     |  5 +-
 16 files changed, 155 insertions(+), 122 deletions(-)

-- 
1.9.1

