Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63107 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759746Ab3ICIVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:21:35 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v4 0/2] add per-VDEV FW statistics
Date: Tue, 3 Sep 2013 10:21:19 +0200
Message-ID: <1378196481-13983-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130903_102145_086853_8347F634)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW 1.0.0.716 brings per-VDEV statistics. This patch-set implements
debugfs mechanism to fetch them. There's still few more fileds we
can read from the FW stats event, which are not covered here.
Let's bring them in the future.

Changes:

V2:
* introduce wmi_peer_stats_common struct
* fetch and print peer RX rates
* break up wmi_peer_stats_common update into separate patch

V3:
* rebase
* fix sparse endianness warnings

V4:
* rebase
* document the wal_dbg_tx_stats changes
* refactor wmi_peer_stats_common/v1/v2 handling

Bartosz Markowski (2):
  ath10k: update wal_dbg_tx_stats structure with missing parameter.
  ath10k: implement per-VDEV FW statistics

 drivers/net/wireless/ath/ath10k/core.h  |   27 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   70 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.c   |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.h   |   90 ++++++++++++++++++++++++++-----
 4 files changed, 170 insertions(+), 21 deletions(-)

-- 
1.7.10

