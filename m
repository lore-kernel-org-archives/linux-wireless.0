Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12809 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbaKYOoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:23 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/5] mwifiex updates
Date: Tue, 25 Nov 2014 06:43:01 -0800
Message-ID: <1416926586-19286-1-git-send-email-akarwar@marvell.com> (sfid-20141125_154431_621674_FB155EE8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset includes couple of fixes, delay work queue logic
removal for USB interface and Tx status support work.

Amitkumar Karwar (5):
  mwifiex: fix sparse warning
  mwifiex: fix scan problem on big endian platforms
  mwifiex: skip delay main work logic for USB interface.
  mwifiex: add Tx status support for EAPOL packets
  mwifiex: add Tx status support for ACTION frames

 drivers/net/wireless/mwifiex/cfg80211.c  | 16 ++++++--
 drivers/net/wireless/mwifiex/decl.h      |  4 ++
 drivers/net/wireless/mwifiex/fw.h        | 17 ++++++--
 drivers/net/wireless/mwifiex/init.c      |  3 ++
 drivers/net/wireless/mwifiex/main.c      | 68 +++++++++++++++++++++++++++++---
 drivers/net/wireless/mwifiex/main.h      | 11 ++++++
 drivers/net/wireless/mwifiex/scan.c      |  2 +-
 drivers/net/wireless/mwifiex/sta_event.c |  5 +++
 drivers/net/wireless/mwifiex/sta_tx.c    |  6 +++
 drivers/net/wireless/mwifiex/txrx.c      | 31 +++++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c |  4 ++
 drivers/net/wireless/mwifiex/uap_txrx.c  |  8 +++-
 drivers/net/wireless/mwifiex/util.c      |  2 +-
 drivers/net/wireless/mwifiex/wmm.c       | 10 +++++
 14 files changed, 172 insertions(+), 15 deletions(-)

-- 
1.8.1.4

