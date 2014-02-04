Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61859 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbaBDAkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 19:40:10 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/30] mwifiex updates for 3.15
Date: Mon, 3 Feb 2014 16:39:56 -0800
Message-ID: <1391474396-7913-1-git-send-email-bzhao@marvell.com> (sfid-20140204_014022_759711_B519EEA2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes updates for 11ac cleanups, PCIe improvements
and TDLS support.


Aaron Durbin (2):
  mwifiex: balance dma map/unmap sizes
  mwifiex: don't leak DMA command skbuffs

Amitkumar Karwar (7):
  mwifiex: change beacon parameter structure
  mwifiex: separate out response buffer parsing code
  mwifiex: separate out next scan command queueing logic
  mwifiex: implement extended scan feature
  mwifiex: update beamforming capability field for HT
  mwifiex: advertise correct beamforming information for VHT
  mwifiex: cleanup in mwifiex_fill_cap_info()

Avinash Patil (17):
  mwifiex: handle AMPDU supported check for AP interface
  mwifiex: make tos_to_tid_inv part of mwifiex_private structure
  mwifiex: move station list functions to common code
  mwifiex: add tdls_mgmt handler support
  mwifiex: parse TDLS action frames during RX
  mwifiex: add cfg80211 tdls_oper handler support
  mwifiex: add cfg80211 add_station handler support
  mwifiex: add cfg80211 change_station handler support
  mwifiex: provision for holding and restoring packets during TDLS setup
  mwifiex: tdls related handling for data packets addressed to TDLS peer
  mwifiex: AMPDU support for TDLS link
  mwifiex: pass ieee80211_vht_cap to mwifiex_fill_vht_cap_tlv
  mwifiex: add VHT support for TDLS
  mwifiex: separate BA params for TDLS link if 11ac is supported
  mwifiex: disable all TDLS link during disconnection
  mwifiex: parse API version from FW
  mwifiex: add key material v2 support

Bing Zhao (4):
  mwifiex: make use of IEEE80211_VHT_MCS_NOT_SUPPORTED
  mwifiex: make 11ac mcs rate tables global and const
  mwifiex: improve readability in 11ac mcsmap to maxrate conversion
  mwifiex: remove unsupported code in 11ac

 drivers/net/wireless/mwifiex/11ac.c          |  192 +++--
 drivers/net/wireless/mwifiex/11ac.h          |    2 +
 drivers/net/wireless/mwifiex/11n.c           |   51 +-
 drivers/net/wireless/mwifiex/11n.h           |   44 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   27 +-
 drivers/net/wireless/mwifiex/Makefile        |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c      |  176 ++++-
 drivers/net/wireless/mwifiex/cfp.c           |  203 +++--
 drivers/net/wireless/mwifiex/cmdevt.c        |   54 +-
 drivers/net/wireless/mwifiex/decl.h          |   23 +
 drivers/net/wireless/mwifiex/fw.h            |  181 ++++-
 drivers/net/wireless/mwifiex/init.c          |    5 +
 drivers/net/wireless/mwifiex/ioctl.h         |   22 +-
 drivers/net/wireless/mwifiex/join.c          |   14 +-
 drivers/net/wireless/mwifiex/main.h          |   88 ++-
 drivers/net/wireless/mwifiex/pcie.c          |  138 ++--
 drivers/net/wireless/mwifiex/scan.c          |  598 ++++++++++-----
 drivers/net/wireless/mwifiex/sta_cmd.c       |  373 ++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |  112 ++-
 drivers/net/wireless/mwifiex/sta_event.c     |   12 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   38 +-
 drivers/net/wireless/mwifiex/sta_rx.c        |   13 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |    3 +
 drivers/net/wireless/mwifiex/tdls.c          | 1043 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c     |  118 ---
 drivers/net/wireless/mwifiex/util.c          |  114 +++
 drivers/net/wireless/mwifiex/util.h          |   20 +-
 drivers/net/wireless/mwifiex/wmm.c           |   96 ++-
 drivers/net/wireless/mwifiex/wmm.h           |   18 +
 29 files changed, 3110 insertions(+), 669 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/tdls.c

-- 
1.8.2.3

