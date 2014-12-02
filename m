Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48279 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaLBLGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 06:06:48 -0500
Subject: [PATCH v2 0/2] ath10k: NF calibration period debugfs file
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 2 Dec 2014 13:06:31 +0200
Message-ID: <20141202110443.14817.85639.stgit@potku.adurom.net> (sfid-20141202_120654_068002_7DB8D96C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are some changes I made to Peter's NF calibdation period patches. Please
review.

v2:

* add _MAX define

* support firmware restart

* set cal_period in wmi_tlv_pdev_param_map

* simplify ar->state check

* rename debugfs file to nf_cal_period to not confuse with cal_data
  file (which is about calibration data)

* WMI_10X_PDEV_PEER_STA_PS_STATECHG_ENABLE -> WMI_10X_PDEV_PARAM_PEER_STA_PS_STATECHG_ENABLE

---

Peter Oh (2):
      ath10k: add new pdev parameters for fw 10.2
      ath10k: add new wmi interface of NF cal period


 drivers/net/wireless/ath/ath10k/core.h    |    1 
 drivers/net/wireless/ath/ath10k/debug.c   |   80 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 
 drivers/net/wireless/ath/ath10k/wmi.c     |    2 +
 drivers/net/wireless/ath/ath10k/wmi.h     |    7 +++
 5 files changed, 91 insertions(+)

