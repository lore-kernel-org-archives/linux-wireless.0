Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:50556 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753178Ab2F2Da4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:30:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/6] mwifiex: improvements for AP mode
Date: Thu, 28 Jun 2012 20:30:24 -0700
Message-Id: <1340940630-27172-1-git-send-email-bzhao@marvell.com> (sfid-20120629_053101_039387_8EA14489)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches improve/cleanup IE parsing code, add change_beacon
handler, and add support for WPS IE handling.

---
Avinash Patil (6):
  mwifiex: pass cfg80211_beacon_data to mwifiex_set_mgmt_ie()
  mwifiex: separate IE parsing for Head/Tail IEs and beacon_ies etc
  mwifiex: overwrite earlier IE buffers for new set IE request
  mwifiex: add change_beacon cfg80211 handler
  mwifiex: advertise WPS probe response offload support to cfg80211
  mwifiex: parse WPS IEs from beacon_data

 drivers/net/wireless/mwifiex/cfg80211.c |   36 ++++++-
 drivers/net/wireless/mwifiex/ie.c       |  185 ++++++++++++++++---------------
 drivers/net/wireless/mwifiex/main.h     |    2 +-
 3 files changed, 131 insertions(+), 92 deletions(-)

