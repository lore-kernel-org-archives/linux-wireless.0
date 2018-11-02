Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D392AC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 16:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C20B2081B
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 16:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C20B2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbeKCB0j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 21:26:39 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:34937 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeKCB0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 21:26:39 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mt6wz-1fPxAL0Dlp-00tVHY; Fri, 02 Nov 2018 17:18:36 +0100
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mt6wz-1fPxAL0Dlp-00tVHY; Fri, 02 Nov 2018 17:18:36 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Yingying Tang <yintang@qti.qualcomm.com>,
        Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: avoid -Wmaybe-uninitialized warning
Date:   Fri,  2 Nov 2018 17:17:19 +0100
Message-Id: <20181102161833.2956376-1-arnd@arndb.de>
X-Mailer: git-send-email 2.18.0
X-Provags-ID: V03:K1:Q9JgcmppWO9yqO7kbS8UMQNFWZHdXHVgc53eT2yOWLmMEalFhd1
 +ckutaHxDinzSaPgjzF5OdRyOxxHzv61eflsGfMsTGLNQvwNNNuKi7mIrUcMjBeRXgrrbNV
 O0pYcFN9ZsgtYGsABV+3MZJceKtPzTFcNXT2dBYiAD5MbEkGnDtPj6W8SEFT/uqCcRAEJp2
 IvsVdJcuEjflOiuqVXKrw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:rjgWZt7H4m0=:7PUscBi6x4yMQlBzhWV27+
 FKg9BrL3fkVweEqhZ1NA+HOTRaEcMWI9xGi1PqcP0LewGfVPtsdzBVa4cVjIhmW7rkq3t/deH
 5lspnsQXHLkfo13aSLjMLAdubShFhxFAWPXKHo+pOv9C4TyyAE8mKkhI5CUjKqAyp4wCV5GA+
 QY844YC8bIGpmjUrH9ZL0pdNxAmEC/V71icz2Z/rU/fCNCUK4mU1LxZqvDXGlovI8+yWyI4AF
 9FiBhVyrcdAJQL/oW/UBAznSistC7xRnj/Zu3WCs5rGXI791pjgYodtU2nE33W+th8L1Hb/z7
 QQtPYq+NAkHcSlG0n/Q6jmFLg964+Lhnba63tgdSYk3BOyDQWj4lG98dEfOzPOPg3gEdBOja2
 VVNir98BP9gAvI67xEpp/nmEyP8z75MThhG/0dXWSqd9bhiTD2pvBpEtV5ElKwVvh1OGukcZB
 CwygaP0IaygQn4//cXdAM/15I8Ymcv+K1ser07JnafyBbHem9hZ0PdNZw033yTycJF+9Ew3R1
 ZudBuZiSWgHacGqKD71J+V13JQSXqvNOi6eahYFqezhoAwMXpAapxbvRhxfy5bsTbz+Atn8cc
 08AgKkdF9/sZDZcnE+vAnXWKhp43HdOXiWwix4DFrr+7Q/zPYBuAicloG58UEIQcxivpoM4Y+
 WnvWPO82Y88EhscwfWypcpi7mFpg86GaPFNq+lRDH3b77wrcBVGrKNVyxoeIZoAqcyfc=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In some configurations the inlining in gcc is suboptimal, causing
a false-positive warning:

drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_mac_init_rd':
drivers/net/wireless/ath/ath10k/mac.c:8374:39: error: 'rd' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  ar->ath_common.regulatory.current_rd = rd;

If we initialize the output of ath10k_mac_get_wrdd_regulatory()
before returning, this problem goes away.

Fixes: 209b2a68de76 ("ath10k: add platform regulatory domain support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a1c2801ded10..0d5fde28ee44 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8321,6 +8321,8 @@ static int ath10k_mac_get_wrdd_regulatory(struct ath10k *ar, u16 *rd)
 	u32 alpha2_code;
 	char alpha2[3];
 
+	*rd = ar->hw_eeprom_rd;
+
 	root_handle = ACPI_HANDLE(&pdev->dev);
 	if (!root_handle)
 		return -EOPNOTSUPP;
@@ -8365,11 +8367,9 @@ static int ath10k_mac_init_rd(struct ath10k *ar)
 	u16 rd;
 
 	ret = ath10k_mac_get_wrdd_regulatory(ar, &rd);
-	if (ret) {
+	if (ret)
 		ath10k_dbg(ar, ATH10K_DBG_BOOT,
 			   "fallback to eeprom programmed regulatory settings\n");
-		rd = ar->hw_eeprom_rd;
-	}
 
 	ar->ath_common.regulatory.current_rd = rd;
 	return 0;
-- 
2.18.0

