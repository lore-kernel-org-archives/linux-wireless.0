Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29242 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2DTJNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 05:13:05 -0400
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, jouni@qca.qualcomm.com,
	Michael Liang <mliang@qca.qualcomm.com>
From: <mliang@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 0/1] ath9k: don't strip mic on non-encrypted frames in tkip mode
Date: Fri, 20 Apr 2012 17:11:56 +0800
Message-ID: <1334913117-4037-1-git-send-email-mliang@qca.qualcomm.com> (sfid-20120420_111311_399189_3B869DCD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Liang <mliang@qca.qualcomm.com>

Hi,

I found a bug in ath9k driver. It incorrectly stripped mic on non-encrypted frames
in tkip mode, so that in ap mode, QoS-data-null packets with powersave on/off were
dropped due to invalid packet length in mac80211, which causes ath9k softap can't
handle the peer station's powersave state transition correctly.

Please review the patch to fix this issue.

Michael Liang (1):
  ath9k: don't strip mic on non-encrypted frames in tkip

 drivers/net/wireless/ath/ath9k/recv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

