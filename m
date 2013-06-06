Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4841 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab3FFLSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/22] brcmfmac: firmware-signalling fixes and cleanup
Date: Thu, 6 Jun 2013 13:17:45 +0200
Message-ID: <1370517487-14395-1-git-send-email-arend@broadcom.com> (sfid-20130606_131852_029907_E1A2FE32)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is intended for v3.11 and resolves a number of issues observed
testing firmware-signalling feature with power-save stations and P2P scenarios
as well as several patches for code cleanup.

The series applies to the master branch of the wireless-next repository.

Arend van Spriel (11):
  brcmfmac: allow firmware-signal tlv to be longer than specified
  brcmfmac: remove fifo bitfield from brcmf_skbuff_cb::if_flags
  brcmfmac: rework credit pickup to assure consistent handling
  brcmfmac: explicitly indicate sk_buff is sent upon request credit
  brcmfmac: reducing debug logging in firmware-signalling code
  brcmfmac: Sent TIM information in case of data available.
  brcmfmac: fix send_pkts statistic counter in firmware-signalling
  brcmfmac: use credit mechanism for BC/MC if support by firmware
  brcmfmac: add trace event for capturing BDC header
  brcmfmac: increment hard_header_len instead of overriding
  brcmfmac: add debugfs statistics for firmware-signalling

Hante Meuleman (11):
  brcmfmac: Take bus flowcontrol at credit mgmt into account.
  brcmfmac: On bus flow control use fw signalling or netif.
  brcmfmac: For FW signalling it is necessary to track gen bit.
  brcmfmac: Correct creditmap when credit borrowing is active.
  brcmfmac: Find correct MAC descriptor in case of TDLS.
  brcmfmac: fix invalid ifp lookup in firmware-signalling
  brcmfmac: Accept only first creditmap event.
  brcmfmac: Signalling header push and pull on logic places.
  brcmfmac: Fix endless loop when brcmf_fws_commit_skb fails.
  brcmfmac: Simplify counting transit count.
  brcmfmac: Always use fifo_credits, also for requested credits.

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   18 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    6 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   23 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  730 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   21 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    8 +
 11 files changed, 436 insertions(+), 381 deletions(-)

-- 
1.7.10.4


