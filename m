Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37224 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab2JFDVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 23:21:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 0/4] mwifiex: fix scan and reason code issues
Date: Fri,  5 Oct 2012 20:21:39 -0700
Message-Id: <1349493703-1169-1-git-send-email-bzhao@marvell.com> (sfid-20121006_052202_699652_92AA7512)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series fixes a scan problem where driver is not returning
error code to cfg80211 in scan handler.

It also makes sure that the correct reason code is reported to
cfg80211 upon de-authentication or association failure.

Amitkumar Karwar (3):
  mwifiex: reset scan_processing flag in failure cases
  mwifiex: update cfg80211 with correct reason code when association
    fails
  mwifiex: update cfg80211 with correct reason code when connection is
    lost

Bing Zhao (1):
  mwifiex: return -EBUSY if scan request cannot be honored

 drivers/net/wireless/mwifiex/cfg80211.c    |   27 +++++++++++++++----
 drivers/net/wireless/mwifiex/join.c        |    6 +++-
 drivers/net/wireless/mwifiex/main.h        |    2 +-
 drivers/net/wireless/mwifiex/scan.c        |   38 +++++++++++++++------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    4 +-
 drivers/net/wireless/mwifiex/sta_event.c   |   31 ++++++++++++++--------
 6 files changed, 69 insertions(+), 39 deletions(-)

