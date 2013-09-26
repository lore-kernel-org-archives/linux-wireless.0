Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44680 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3IZPrc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:32 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 00/13] ath10k: dual-firmware support (MAIN and 10.X)
Date: Thu, 26 Sep 2013 17:47:04 +0200
Message-ID: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174735_781825_AF8883F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The major changes covered by this work:
* dynamic WMI structures
* WMI cmd/event definitions from 10.x FW track
* memory host chunks feature
* management frames path over WMI for 10.x
* WMI RX events handling for MAIN and 10.X split
* target config split (LARGE AP feature for 10.x)
* scan start sctructure split
* dynamic VDEV and PDEV parameters structures

Changes in v2:
(review comments from Kalle and Michal):
* WMI cmd, pdev and vdev params names trimmed
* ath10k_wmi_cmd_init() exposed only
* few 'if' statements simplifications
* 10.x mgmt frames over WMI - 'BUG: scheduling while atomic' fixed

Changes in v3:
* print cmd_id when warning about unsupported WMI command
* remove excessive empty line

Bartosz Markowski (13):
  ath10k: introduce dynamic WMI structures
  ath10k: add wmi_10x_<cmd/event> definitions
  ath10k: warn if give WMI command is not supported
  ath10k: implement WMI events handling frame for both firmwares
  ath10k: split ath10k_wmi_service_ready_event_rx
  ath10k: drop the fw versioning sanity check
  ath10k: implement host memory chunks
  ath10k: bring back the WMI path for mgmt frames
  ath10k: split wmi_cmd_init path
  ath10k: add TARGET values for 10.x firmware
  ath10k: introduce dynamic vdev parameters
  ath10k: introduce dynamic pdev parameters
  ath10k: handle FW API differences for scan structures

 drivers/net/wireless/ath/ath10k/core.c   |   28 +-
 drivers/net/wireless/ath/ath10k/core.h   |   28 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 +-
 drivers/net/wireless/ath/ath10k/hw.h     |   37 +-
 drivers/net/wireless/ath/ath10k/mac.c    |  133 +++-
 drivers/net/wireless/ath/ath10k/mac.h    |    2 +
 drivers/net/wireless/ath/ath10k/wmi.c    | 1085 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h    |  968 +++++++++++++++++++++++++-
 8 files changed, 2158 insertions(+), 127 deletions(-)

-- 
1.7.10

