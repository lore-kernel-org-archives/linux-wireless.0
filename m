Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61734 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbCFL2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 06:28:47 -0500
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Subject: [PATCH V3 2/2] ath10k: Enable encryption of ADDBA request in PMF configuration
Date: Fri, 6 Mar 2015 16:57:50 +0530
Message-ID: <1425641270-4059-2-git-send-email-sjegadee@qti.qualcomm.com> (sfid-20150306_122851_957872_17E46263)
In-Reply-To: <1425641270-4059-1-git-send-email-sjegadee@qti.qualcomm.com>
References: <1425641270-4059-1-git-send-email-sjegadee@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In HT mode, firmware is not encrypting ADDBA request as PMF
configuration is not set in peer flags during association.

Set peer flags for MFP enabled station in ath10k driver.

This change depends on mac80211 patch "[PATCH] mac80211: send
station PMF configuration to driver".

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0c69687..83baed7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1759,6 +1759,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);

+	if (sta->mfp)
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_pmf;
+
 	return 0;
 }

--
1.9.1

