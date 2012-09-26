Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:40611 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2IZD2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:28:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/15] mwifiex: p2p support
Date: Tue, 25 Sep 2012 20:23:30 -0700
Message-Id: <1348629825-12001-1-git-send-email-bzhao@marvell.com> (sfid-20120926_052837_046021_A6FEDA9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds basic support for p2p.
P2P group/dynamic interface is not supported yet.

Kevin Gan (1):
  mwifiex: add inactivity deauth support for ap

Stone Piao (14):
  mwifiex: fix coding style issue
  mwifiex: implement cfg80211 mgmt_tx handler
  mwifiex: advertise mgmt_stype to cfg80211
  mwifiex: implement cfg80211 mgmt_frame_register handler
  mwifiex: report received management frames to cfg80211
  mwifiex: implement remain_on_channel and cancel_remain_on_channel
  mwifiex: process remain on channel expired event
  mwifiex: append each IE into a seperate IE buffer
  mwifiex: send firmware initialization commands synchronously
  mwifiex: add P2P interface
  mwifiex: add support for P2P client in interface type change
  mwifiex: add support for P2P GO in interface type change
  mwifiex: parse P2P IEs from beacon_data
  mwifiex: set txpd when send a mgmt frame for AP and GO mode

 drivers/net/wireless/mwifiex/cfg80211.c    |  386 ++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/decl.h        |    6 +-
 drivers/net/wireless/mwifiex/fw.h          |   43 +++
 drivers/net/wireless/mwifiex/ie.c          |   86 ++++---
 drivers/net/wireless/mwifiex/init.c        |   14 +-
 drivers/net/wireless/mwifiex/ioctl.h       |    2 +
 drivers/net/wireless/mwifiex/main.c        |   41 ++-
 drivers/net/wireless/mwifiex/main.h        |   35 +++
 drivers/net/wireless/mwifiex/sta_cmd.c     |   92 +++++---
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   39 +++
 drivers/net/wireless/mwifiex/sta_event.c   |   12 +
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   59 +++++
 drivers/net/wireless/mwifiex/sta_rx.c      |    6 +
 drivers/net/wireless/mwifiex/sta_tx.c      |   12 +-
 drivers/net/wireless/mwifiex/uap_cmd.c     |   22 ++
 drivers/net/wireless/mwifiex/uap_txrx.c    |   15 +
 drivers/net/wireless/mwifiex/util.c        |   40 +++
 drivers/net/wireless/mwifiex/wmm.c         |    9 +-
 18 files changed, 821 insertions(+), 98 deletions(-)

