Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38271 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaLDRhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 12:37:23 -0500
From: "Oh, Peter" <poh@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] ath10k: NF calibration period debugfs file
Date: Thu, 4 Dec 2014 17:37:01 +0000
Message-ID: <1240abdd13da409ab749b4e720e300fd@NASANEXM01B.na.qualcomm.com> (sfid-20141204_183727_225991_3D8D50A4)
References: <20141202110443.14817.85639.stgit@potku.adurom.net>
In-Reply-To: <20141202110443.14817.85639.stgit@potku.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That sounds good to me.

Thanks,
Peter

-----Original Message-----
From: ath10k [mailto:ath10k-bounces@lists.infradead.org] On Behalf Of Kalle Valo
Sent: Tuesday, December 02, 2014 3:07 AM
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] ath10k: NF calibration period debugfs file

Hi,

here are some changes I made to Peter's NF calibdation period patches. Please review.

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


_______________________________________________
ath10k mailing list
ath10k@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/ath10k
