Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:52464 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab3H1Ll2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 07:41:28 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2 0/2] add per-VDEV FW statistics
Date: Wed, 28 Aug 2013 13:41:17 +0200
Message-ID: <1377690079-18645-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130828_134131_833874_A0BA420B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW 1.0.0.716 brings per-VDEV statistics. This patch-set implements
debugfs mechanism to fetch those. There's still few more fileds we
can read from the FW stats event, which are not covered here.

Changes:

V2:
* introduce wmi_peer_stats_common struct
* fetch and print peer RX rates
* break up wmi_peer_stats_common update into separate patch

Bartosz Markowski (2):
  ath10k: update wal_dbg_tx_stats structure with missing parameter.
  ath10k: implement per-VDEV FW statistics

 drivers/net/wireless/ath/ath10k/core.h  |   22 ++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   81 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.c   |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.h   |   90 ++++++++++++++++++++++++++-----
 4 files changed, 170 insertions(+), 27 deletions(-)

-- 
1.7.10

