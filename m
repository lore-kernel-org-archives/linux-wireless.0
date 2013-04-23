Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4044 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab3DWKzq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 06:55:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/5] brcmfmac: new functionality and fixes
Date: Tue, 23 Apr 2013 12:53:10 +0200
Message-ID: <1366714395-13416-1-git-send-email-arend@broadcom.com> (sfid-20130423_125548_909053_A6105DEF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This small series contains patches adding support of the new
critical protocol API in cfg80211. Another new driver feature
is an enhancement to firmware-signalling called credit borrowing.

Other changes are fixes for firmware-signalling feature. One
of these patches addresses the issue reported by Wei Yongjun,
but solved differrent from the patch that he proposed.

Arend van Spriel (4):
  brcmfmac: allow scanning to be suppressed in the driver
  brcmfmac: flush queue upon MACDESC_DEL firmware signal
  brcmfmac: correct error handling in brcmf_fws_init()
  brcmfmac: add credit borrowing mechanism

Piotr Haber (1):
  brcmfmac: support critical protocol API for DHCP

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c   |  498 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.h   |   29 ++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  128 ++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   56 +++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    6 +-
 7 files changed, 704 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/btcoex.h

-- 
1.7.10.4


