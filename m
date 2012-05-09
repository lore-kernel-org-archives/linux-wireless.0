Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:40711 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756303Ab2EIBch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:32:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 00/18] mwifiex: add AP support
Date: Tue,  8 May 2012 18:30:12 -0700
Message-Id: <1336527030-2045-1-git-send-email-bzhao@marvell.com> (sfid-20120509_033242_007910_901D36CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for micro-AP (uAP) mode to mwifiex driver.
Tested with hostapd devel v2. Simultaneous AP-STA functionality works fine.

PATCH 09/18 depends on patch "mwifiex: fix coding style issue in"
 mwifiex_deauthenticate" submitted previously.

PATCH v2 series changes:

1) 17/18: make use of cfg80211_find_ie() to parse RSN IE from beacon.tail
   (Thanks to Johannes Berg)
2) 17/18 & 18/18: revamped IE parsing logic to remove mask field from
   set_mgmt_ie/del_mgmt_ie
3) 02, 03, 07, 08, 14, 15: minor readability changes

Thanks,
Bing

---
Avinash Patil (18):
  mwifiex: allocate space for one more mwifiex_private structure
  mwifiex: handle station specific commands on STA interface only
  mwifiex: support for creation of AP interface
  mwifiex: multi-interface support for mwifiex
  mwifiex: save adapter pointer in wiphy_priv
  mwifiex: append peer mac address TLV in key material command to
    firmware
  mwifiex: add bss start and bss stop commands for AP
  mwifiex: add AP command sys_config and set channel
  mwifiex: stop BSS in deauthentication handling
  mwifiex: handle interface type changes correctly
  mwifiex: common set_wiphy_params cfg80211 handler for AP and STA
    interface
  mwifiex: add cfg80211 start_ap and stop_ap handlers
  mwifiex: add AP event handling framework
  mwifiex: add WPA2 support for AP
  mwifiex: rearrange AP sys configure code
  mwifiex: add custom IE framework
  mwifiex: retrieve IEs from cfg80211_beacon_data and send to firmware
  mwifiex: delete IEs when stop_ap

 drivers/net/wireless/mwifiex/Makefile      |    2 +
 drivers/net/wireless/mwifiex/cfg80211.c    |  479 ++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/cfg80211.h    |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c      |   21 ++-
 drivers/net/wireless/mwifiex/decl.h        |   13 +-
 drivers/net/wireless/mwifiex/fw.h          |  159 +++++++++-
 drivers/net/wireless/mwifiex/ie.c          |  396 +++++++++++++++++++++++
 drivers/net/wireless/mwifiex/init.c        |    1 +
 drivers/net/wireless/mwifiex/ioctl.h       |   32 ++
 drivers/net/wireless/mwifiex/join.c        |    4 +
 drivers/net/wireless/mwifiex/main.c        |   57 ++--
 drivers/net/wireless/mwifiex/main.h        |   26 ++-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   69 +++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    8 +
 drivers/net/wireless/mwifiex/sta_event.c   |   51 +++-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    9 +-
 drivers/net/wireless/mwifiex/uap_cmd.c     |  432 +++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c         |    4 +
 18 files changed, 1588 insertions(+), 177 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/ie.c
 create mode 100644 drivers/net/wireless/mwifiex/uap_cmd.c

