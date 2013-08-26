Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43300 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab3HZLsx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 07:48:53 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 0/3] ath10k: initial per-VDEV FW statistics implementation
Date: Mon, 26 Aug 2013 13:33:31 +0200
Message-ID: <1377516815-12660-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130826_134857_042488_CE92CF90)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW 1.0.0.716 brings per-VDEV statistics. This patch-set implements
debugfs mechanism to fetch those. There's still few more fileds we
can read from the FW stats event, which are not covered here.

Please note there's an ABI change in wmi_peer_stats structure, hence
the PEER statistics will be corrupted if used with older firmware
(e.g. 1.0.0.636)

Bartosz Markowski (3):
  ath10k: update wmi_request_stats_cmd structure
  ath10k: update wal_dbg_tx_stats structure
  ath10k: implement per-VDEV FW statistics

 drivers/net/wireless/ath/ath10k/core.h  |   18 +++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   42 ++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h   |   67 ++++++++++++++++++++++++++-----
 3 files changed, 113 insertions(+), 14 deletions(-)

-- 
1.7.10

