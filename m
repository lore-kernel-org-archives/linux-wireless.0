Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44981 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab3H2MH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 08:07:57 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 0/2] add per-VDEV FW statistics
Date: Thu, 29 Aug 2013 14:07:38 +0200
Message-ID: <1377778061-22331-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130829_140800_712011_A64BA2FA)
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

V3:
* rebase
* fix sparse endianness warnings

Bartosz Markowski (2):
  ath10k: update wal_dbg_tx_stats structure with missing parameter.
  ath10k: implement per-VDEV FW statistics

 drivers/net/wireless/ath/ath10k/core.h  |   27 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   78 ++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.c   |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.h   |   90 ++++++++++++++++++++++++++-----
 4 files changed, 173 insertions(+), 26 deletions(-)

-- 
1.7.10

