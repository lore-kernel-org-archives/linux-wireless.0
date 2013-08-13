Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2881 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab3HMUEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"Jonas Gorski" <jogo@openwrt.org>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT 00/13] brcmsmac: bcm4313 iPA related patches
Date: Tue, 13 Aug 2013 22:03:27 +0200
Message-ID: <1376424220-10765-1-git-send-email-arend@broadcom.com> (sfid-20130813_220450_916368_82A05B6A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series replaces the patch "[PATCH 12/12] brcmsmac: support 4313iPA"
with Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com>.

It has been split up into individual patches. Please test this series
especially if you had issues with the original commit b6fc28a that was
reverted.

Cc: Jonas Gorski <jogo@openwrt.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>

Arend van Spriel (13):
  brcmsmac: cosmetic change in phy_lcn.c
  brcmsmac: change pa_gain for bcm4313 iPA
  brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
  brcmsmac: add switch control table for BCM4313 iPA BT-combo cards
  brcmsmac: add debug info message providing phy and radio info
  brcmsmac: update transmit gain table for lcn phy
  brcmsmac: change lcnphy receive i/q calibration routine
  brcmsmac: fix TSSI idle estimation
  brcmsmac: avoid calling set_txpwr_by_index() twice
  brcmsmac: rework switch control table init including iPA BT-combo
  brcmsmac: correct phy registers for TSSI-based power control
  brcmsmac: reinitialize TSSI power control upon channel switch
  brcmsmac: add support for BCM4313 iPA variant

 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  397 +++++++++++--------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  405 +++++++++++---------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |    1 +
 4 files changed, 475 insertions(+), 332 deletions(-)

-- 
1.7.10.4


