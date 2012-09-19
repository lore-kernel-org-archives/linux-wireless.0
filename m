Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3065 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/13] brcmfmac: scheduled scan support and cleanup work
Date: Wed, 19 Sep 2012 22:21:05 +0200
Message-ID: <1348086078-19183-1-git-send-email-arend@broadcom.com> (sfid-20120919_222552_264839_B1C27570)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series consist of new scheduled scan feature which can be used
through nl80211 netlink api. For SDIO receive path is reworked and the
USB driver it is now able to support multiple devices in the system. Other
patches are relatively small.

This series are intended for 3.7 and applies to wireless-next repository.
It depends on the series "brcmfmac: sdio dpc restructuring and cleanup"
sent on Sep 13, 2012 identified by:

Message-ID: <1347563526-12513-1-git-send-email-arend@broadcom.com>

Arend van Spriel (5):
  brcmfmac: fix sparse warnings in e-scan related code
  brcmfmac: extend brcmf_term_iscan() to abort e-scan
  brcmfmac: introduce scheduled scan support
  brcmfmac: change struct brcmf_cfg80211_priv comments to kernel-doc
  brcmfmac: get rid of void pointer in struct brcmf_cfg80211_priv

Franky Lin (1):
  brcmfmac: streamline SDIO read frame routine

Hante Meuleman (6):
  brcmfmac: fix debug printout of event data.
  brcmfmac: store usb fw images in local linked list.
  brcmfmac: remove unused function.
  brcmfmac: fix bug in determining phy bands.
  brcmfmac: remove unused usb bmac model code.
  brcmfmac: clear control lock on usb error.

Piotr Haber (1):
  brcmsmac: don't start device when RfKill is engaged

 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   13 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  621 ++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   84 +--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  408 +++++++++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  202 +++++--
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    5 +-
 7 files changed, 796 insertions(+), 539 deletions(-)

-- 
1.7.9.5


