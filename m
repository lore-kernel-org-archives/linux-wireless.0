Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3243 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3HTOA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:00:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/12] brcmsmac: bcm4313 iPA support
Date: Tue, 20 Aug 2013 16:00:34 +0200
Message-ID: <1377007246-9957-1-git-send-email-arend@broadcom.com> (sfid-20130820_160110_360663_44B12A2B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series replaces the patch "brcmsmac: support 4313iPA" with
Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com>.
That patch has been split up and other review comments from Jonas
Gorski have been taken into account.

The series is intended for v3.12 and applies to the master
branch of the wireless-next repository.

Arend van Spriel (12):
  brcmsmac: cosmetic change in phy_lcn.c
  brcmsmac: change pa_gain for bcm4313 iPA
  brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
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


