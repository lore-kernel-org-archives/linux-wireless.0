Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4482 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/12] brcmfmac: adding virtual interface support
Date: Mon, 22 Oct 2012 13:55:29 -0700
Message-ID: <1350939341-17687-1-git-send-email-frankyl@broadcom.com> (sfid-20121022_225611_022233_5264C2EC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches from Arend adding virtual interface support to fullmac for p2p.

This series depends on the series "brcmfmac: implementation of firmware
interface layer" posted earlier today with message-id:
Message-ID: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>

Thanks

Arend van Spriel (12):
  brcmfmac: introduce brcmf_cfg80211_vif structure
  brcmfmac: store profile information per virtual interface
  brcmfmac: use vif struct to check_sys_up() function
  brcmfmac: separate connection status from scanning status
  brcmfmac: remove debugfs functionality from wl_cfg80211.c
  brcmfmac: cleanup brcmf_cfg80211_profile structure
  brcmfmac: remove unused enumeration wl_prof_list
  brcmfmac: rename check_sys_up() to check_vif_up()
  brcmfmac: use memset when setting a broadcast mac address
  brcmfmac: add virtual interface support in brcmf_cfg80211_suspend()
  brcmfmac: remove unnecessary macro usage in brcmf_cfg80211_resume()
  brcmfmac: store IEs per virtual interface

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    5 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  618 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  141 +++--
 3 files changed, 417 insertions(+), 347 deletions(-)

-- 
1.7.9.5


