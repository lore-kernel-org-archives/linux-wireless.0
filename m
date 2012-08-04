Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog036.obsmtp.com ([74.125.150.110]:43704 "EHLO
	na6sys009bog036.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab2HDB1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:27:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/16] mwifiex: patches for 3.7
Date: Fri,  3 Aug 2012 18:05:58 -0700
Message-Id: <1344042374-6892-1-git-send-email-bzhao@marvell.com> (sfid-20120804_035551_383697_698E5B15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1st patch series intended for 3.7:

01~03: fix A-MSDU subframe buffer overwitten issue (Yogesh Ashok Powar)
04:    fix RxPD issue for big endian platforms (Amitkumar Karwar)
05~06: enhance scan logic while tx traffic is ongoing (Amitkumar Karwar)
07~13: add 11n support & STA-STA forwarding for AP mode (Avinash Patil)
14~16: support AES_CMAC (Ying Luo)

---
Amitkumar Karwar (3):
  mwifiex: do le_to_cpu conversion for Rx packet header elements
  mwifiex: update max_chan_per_scan correctly for SSID scan
  mwifiex: improve scan delay logic during Tx traffic

Avinash Patil (7):
  mwifiex: update 11n status as per start_ap IE
  mwifiex: separate file for handling AP events
  mwifiex: create list for associated stations in AP mode
  mwifiex: improve uAP RX handling
  mwifiex: support RX AMSDU aggregation for uAP
  mwifiex: add 11n Block Ack support for uAP
  mwifiex: cleanup TX/RX BA tables for uAP

Ying Luo (3):
  mwifiex: rename wapi_rxpn to pn
  mwifiex: pass key_params pointer in mwifiex_set_encode
  mwifiex: add AES_CMAC support in key_material cmd

Yogesh Ashok Powar (3):
  mwifiex: copy MSDU subframes correctly
  mwifiex: remove extra padding to AMSDU
  mwifiex: correction in MSDU padding logic

 drivers/net/wireless/mwifiex/11n.c           |   26 +++
 drivers/net/wireless/mwifiex/11n.h           |   15 ++
 drivers/net/wireless/mwifiex/11n_aggr.c      |   14 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   66 +++++-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    5 +
 drivers/net/wireless/mwifiex/Makefile        |    2 +
 drivers/net/wireless/mwifiex/cfg80211.c      |   17 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |    5 +-
 drivers/net/wireless/mwifiex/decl.h          |    3 +
 drivers/net/wireless/mwifiex/fw.h            |   42 ++++-
 drivers/net/wireless/mwifiex/init.c          |  107 ++++++----
 drivers/net/wireless/mwifiex/ioctl.h         |    5 +-
 drivers/net/wireless/mwifiex/main.c          |    3 +
 drivers/net/wireless/mwifiex/main.h          |   38 +++-
 drivers/net/wireless/mwifiex/scan.c          |    2 +
 drivers/net/wireless/mwifiex/sta_cmd.c       |   55 ++++-
 drivers/net/wireless/mwifiex/sta_event.c     |   49 +-----
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   12 +-
 drivers/net/wireless/mwifiex/sta_rx.c        |   38 ++--
 drivers/net/wireless/mwifiex/txrx.c          |    5 +
 drivers/net/wireless/mwifiex/uap_cmd.c       |    1 +
 drivers/net/wireless/mwifiex/uap_event.c     |  291 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/uap_txrx.c      |  255 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c           |   59 +++++-
 24 files changed, 948 insertions(+), 167 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/uap_event.c
 create mode 100644 drivers/net/wireless/mwifiex/uap_txrx.c

