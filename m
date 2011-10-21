Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2844 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1JUNze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/17] fix mac80211 callback in brcmsmac and brcmfmac
 refactor
Date: Fri, 21 Oct 2011 15:55:02 +0200
Message-ID: <1319205319-16891-1-git-send-email-arend@broadcom.com> (sfid-20111021_161149_258924_F9DCE4D0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg commented on our use of the start/stop callbacks in brcmsmac
and we changed those callbacks. In rfkill testing it revealed a problem which
has been fixed in this series as well.

The brcmfmac driver had some restructuring in preparation of USB support
for new devices.

This patch series applies to the wireless-testing repository and depends on the
series posted on Oct 18, 2011 with message id:

Message-ID: <1318939391-19495-1-git-send-email-arend@broadcom.com> 

Arend van Spriel (3):
  brcm80211: smac: rename buffer endianess conversion functions
  brcm80211: smac: use sk_buff list for handling frames in receive path
  brcm80211: smac: change buffer endianess convert function interface

Franky Lin (5):
  brcm80211: fmac: allow wd timer to be disabled when bus down
  brcm80211: fmac: use brcmf_del_if for all net devices
  brcm80211: fmac: use brcmf_add_if for all net devices
  brcm80211: fmac: store brcmf_if in net device private data
  brcm80211: fmac: remove state from brcmf_if in fullmac

Roland Vossen (9):
  brcm80211: smac: removed MPC related code
  brcm80211: smac: removed MPC related variables
  brcm80211: smac: removed down-on-watchdog MPC functionality
  brcm80211: smac: removed down-on-rf-kill functionality
  brcm80211: smac: bugfix for tx mute in brcms_b_init()
  brcm80211: smac: fixed inconsistency in transmit mute
  brcm80211: smac: modified Mac80211 callback interface
  brcm80211: smac: mute transmit on ops_start
  brcm80211: smac: changed check to confirm STA only support

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    5 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    5 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  301 +++++++-------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |   38 ++-
 drivers/net/wireless/brcm80211/brcmsmac/dma.h      |    3 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  100 +++----
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  219 ++------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   11 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |   33 +--
 drivers/net/wireless/brcm80211/include/defs.h      |    1 -
 13 files changed, 232 insertions(+), 504 deletions(-)

-- 
1.7.4.1


