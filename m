Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52912 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaK0MIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:08:52 -0500
Subject: [PATCH v4 0/2] ath10k: device tree support
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <devicetree@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<toshik@chromium.org>
Date: Thu, 27 Nov 2014 14:08:47 +0200
Message-ID: <20141127120727.17546.61202.stgit@potku.adurom.net> (sfid-20141127_130904_714816_A211B43B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here's providing ath10k calibration data via device tree support which
Toshi and me have been working on. Please review.

Device tree maintainers: please review the bindings document
carefully, this is the first time I have written one.

v4:

* use correct devicetree mailing list address

v3:

* add a debug message to ath10k

* write bindings file

* use ar->dev.of_node instead of pci_device_to_OF_node()

v2:

* fixed a bug that returns an uninitialized value if the node is not
  found

---

Kalle Valo (1):
      dt: bindings: add ath10k wireless device

Toshi Kikuchi (1):
      ath10k: read calibration data from Device Tree


 .../bindings/net/wireless/qcom,ath10k.txt          |   30 +++++++++
 drivers/net/wireless/ath/ath10k/core.c             |   70 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h             |    3 +
 3 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt

