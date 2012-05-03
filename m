Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:44492 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752948Ab2ECHXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 00/18] mwifiex: add AP support
Date: Thu,  3 May 2012 00:22:22 -0700
Message-Id: <1336029760-22565-1-git-send-email-bzhao@marvell.com> (sfid-20120503_092320_498826_95B00732)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for micro-AP (uAP) mode to mwifiex driver.

Tested with hostapd devel v2. Simultaneous AP-STA functionality works fine.

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
  mwifiex: parse beacon, probe response and assoc response IEs from
    start_ap
  mwifiex: delete IEs when stop_ap

 drivers/net/wireless/mwifiex/Makefile      |    2 +
 drivers/net/wireless/mwifiex/cfg80211.c    |  485 +++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/cfg80211.h    |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c      |   21 ++-
 drivers/net/wireless/mwifiex/decl.h        |   13 +-
 drivers/net/wireless/mwifiex/fw.h          |  159 +++++++++-
 drivers/net/wireless/mwifiex/ie.c          |  447 +++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/init.c        |    1 +
 drivers/net/wireless/mwifiex/ioctl.h       |   32 ++
 drivers/net/wireless/mwifiex/join.c        |    4 +
 drivers/net/wireless/mwifiex/main.c        |   57 ++--
 drivers/net/wireless/mwifiex/main.h        |   27 ++-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   64 +++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    8 +
 drivers/net/wireless/mwifiex/sta_event.c   |   51 +++-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    9 +-
 drivers/net/wireless/mwifiex/uap_cmd.c     |  432 +++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c         |    4 +
 18 files changed, 1643 insertions(+), 175 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/ie.c
 create mode 100644 drivers/net/wireless/mwifiex/uap_cmd.c

