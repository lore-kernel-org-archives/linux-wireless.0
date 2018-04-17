Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42950 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753049AbeDQMHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 08:07:13 -0400
From: pillair@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 0/4] Support for STA idle mode power save(IMPS)
Date: Tue, 17 Apr 2018 17:36:57 +0530
Message-Id: <1523966821-21903-1-git-send-email-pillair@codeaurora.org> (sfid-20180417_140719_038134_82602F52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@codeaurora.org>

Enable STA idle mode power save(IMPS) for WCN3990 TLV target.

In-order to support STA idle mode ps direct access to CE registers are
protected via 2 mechanism. As target can power collapse based on idle
inactivity and any target register access during that state can lead to
un-clocked access.

2) Caching SRRI/DRRI in DDR.

WN3990 has a shadow block in HW which is always on domain and allows HOST/APPS
access irrespective of power state of the target(Common subsystem(includes CE block)
might be down due to idle/inactivity).
Any operation on the shadow registers are directly reflected back in the actual
CE registers( SRWI/DRWI) once common subsystem gets up.
The shadow registers configuration is supplied via QMI message.

WC3990 has 24 shadow registers and mapping of shadow register(0-23) to CE registers(0-12)
is as following.

               -----------------------------------------------------------
               Shadow Register      |     CE   |    src/dst write index
               -----------------------------------------------------------
                              0            |     0    |           src
                              3            |     3    |           src
                              4            |     4    |           src
                              5            |     5    |           src
                              7            |     7    |           src
                              13           |     1    |           dst
                              14           |     2    |           dst
                              19           |     7    |           dst
                              20           |     8    |           dst
                              21           |     9    |           dst
                              22           |     10   |           dst
                              23           |     11   |           dst


1) Caching SRWI/SRWI in HW shadow block.

Since shadow block allows only WRITE access, for read access(SRRI/DRRI) driver allocates
region in DDR(12CE*half WORD) which is being configured in CE UPD control register.
CE SRRI/DRRI are restored and replayed on the configured region(DDR) on each update.
HOST/APPS reads SRRI/DRRI from the DDR to make the access independent of target power state.


Changes in v2:
	- Disabled the shadow_reg_support and rri_on_ddr hw params for QCA988X_HW_2_0_VERSION
	- Fixed checkpatch warnings

Govind Singh (2):
  ath10k: Enable SRRI/DRRI support on ddr for WCN3990
  ath10k: Enable sta idle power save

Rakesh Pillai (2):
  ath10k: Add hw params for shadow register support
  ath10k: Add support for shadow register for WNC3990

 drivers/net/wireless/ath/ath10k/ce.c   | 245 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/ce.h   |  14 ++
 drivers/net/wireless/ath/ath10k/core.c |  28 ++++
 drivers/net/wireless/ath/ath10k/hw.c   |   9 +-
 drivers/net/wireless/ath/ath10k/hw.h   |  17 ++-
 drivers/net/wireless/ath/ath10k/mac.c  |   7 +
 drivers/net/wireless/ath/ath10k/snoc.c |   3 +
 7 files changed, 312 insertions(+), 11 deletions(-)

-- 
2.14.1
