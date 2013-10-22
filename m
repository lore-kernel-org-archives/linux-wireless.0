Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53024 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374Ab3JVWZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:25:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/6] mwifiex: potential integer underflow and invalid mem access
Date: Tue, 22 Oct 2013 15:24:41 -0700
Message-ID: <1382480687-12720-1-git-send-email-bzhao@marvell.com> (sfid-20131023_002517_008018_CC27B971)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes potential integer underflow and invalid memory access issues reported by Dan Carpenter.

Amitkumar Karwar (5):
  mwifiex: replace u16 with __le16 in struct mwifiex_types_power_group
  mwifiex: fix invalid memory access in mwifiex_get_power_level()
  mwifiex: fix invalid memory access in mwifiex_ret_tx_rate_cfg()
  mwifiex: fix invalid memory access in mwifiex_update_autoindex_ies()
  mwifiex: improvements in mwifiex_ret_tx_power_cfg()

Dan Carpenter (1):
  mwifiex: potential integer underflow in mwifiex_ret_wmm_get_status()

 drivers/net/wireless/mwifiex/fw.h          |  4 +-
 drivers/net/wireless/mwifiex/ie.c          | 11 ++--
 drivers/net/wireless/mwifiex/sta_cmd.c     |  4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 81 +++++++++++++++---------------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  5 +-
 drivers/net/wireless/mwifiex/wmm.c         |  3 ++
 6 files changed, 58 insertions(+), 50 deletions(-)

-- 
1.8.2.3

