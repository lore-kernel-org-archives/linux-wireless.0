Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:52072 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936Ab3ADFWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 00:22:37 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/5] mwifiex_pcie enhancement for 3.9
Date: Thu,  3 Jan 2013 21:21:27 -0800
Message-Id: <1357276892-32759-1-git-send-email-bzhao@marvell.com> (sfid-20130104_062241_233502_6A8E5DB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of mwifiex_pcie enhancement patches are intended for 3.9.

Avinash Patil (5):
  mwifiex: access interrupt status only while holding lock
  mwifiex: add init_fw_port handler for PCIe interface
  mwifiex: use pci_alloc/free_consistent APIs for PCIe
  mwifiex: flush TX ring for PCIe after disconnect or bss stop
  mwifiex: use map/unmap APIs in TX and RX to reduce memcpy

 drivers/net/wireless/mwifiex/11n_aggr.c |    6 +-
 drivers/net/wireless/mwifiex/init.c     |    6 +
 drivers/net/wireless/mwifiex/main.h     |    2 +
 drivers/net/wireless/mwifiex/pcie.c     |  654 +++++++++++++++++++++----------
 drivers/net/wireless/mwifiex/pcie.h     |   33 ++-
 drivers/net/wireless/mwifiex/sta_cmd.c  |   10 +-
 drivers/net/wireless/mwifiex/txrx.c     |    6 +-
 drivers/net/wireless/mwifiex/util.h     |    8 +-
 drivers/net/wireless/mwifiex/wmm.c      |    8 +-
 9 files changed, 511 insertions(+), 222 deletions(-)

