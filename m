Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2970 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2JVRgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/14] brcmfmac: implementation of firmware interface
 layer
Date: Mon, 22 Oct 2012 10:36:13 -0700
Message-ID: <1350927387-25608-1-git-send-email-frankyl@broadcom.com> (sfid-20121022_193644_039784_15DBBE03)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains patches for abstracting a firmware interface layer for
dcmd and iovar handling. Also there are some code clean up works. It intends
for 3.8. 

Arend van Spriel (7):
  brcmfmac: extend struct brcmf_if with bssidx field
  brcmfmac: rework driver initialization in brcmf_bus_start()
  brcmfmac: use bssidx from struct brcmf_if for bsscfg specific
    commands
  brcmfmac: add function converting ieee80211_channel to chanspec
  brcmfmac: use struct brcmf_if as interface object for fwil functions
  brcmfmac: change parameter list for send_key_to_dongle()
  brcmfmac: remove brcmf_find_bssidx() function

Franky Lin (1):
  brcmfmac: streamline header parse code of sdio glom read

Hante Meuleman (6):
  brcmfmac: refactor firmware interface layer.
  brcmfmac: remove unused iswl variable.
  brcmfmac: change testmode command to use new firmware interface layer
  brcmfmac: remove redundant function brcmf_c_mkiovar_bsscfg
  brcmfmac: clean usb download code.
  brcmfmac: use fwil for default configuration setup.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   64 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   29 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  454 +++++--------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    3 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  162 +----
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  174 ++----
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |  337 ++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   39 ++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   41 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  675 +++++++-------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 +-
 15 files changed, 918 insertions(+), 1078 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil.h

-- 
1.7.6


