Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40514 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab3CPBri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 21:47:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Marco Cesarano <marco@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9 0/3] mwifiex: patchset to fix cmd timeout on XO-4
Date: Fri, 15 Mar 2013 18:47:04 -0700
Message-ID: <1363398427-30392-1-git-send-email-bzhao@marvell.com> (sfid-20130316_024742_555061_B4DF7B73)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes command timeout issue reproduced on XO-4
with SD8787 during driver load/unload tests.

The cmd_pending leak will be addressed separately.

Amitkumar Karwar (1):
  mwifiex: fix race when queuing commands

Bing Zhao (2):
  mwifiex: skip pending commands after function shutdown
  mwifiex: cancel cmd timer and free curr_cmd in shutdown process

 drivers/net/wireless/mwifiex/cmdevt.c    |   22 ++++++++++++++++------
 drivers/net/wireless/mwifiex/init.c      |    8 ++++++++
 drivers/net/wireless/mwifiex/main.h      |    4 ++--
 drivers/net/wireless/mwifiex/scan.c      |    8 ++++----
 drivers/net/wireless/mwifiex/sta_ioctl.c |   10 ++--------
 5 files changed, 32 insertions(+), 20 deletions(-)

