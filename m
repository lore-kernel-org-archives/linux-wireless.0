Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09886C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD8F12084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfDILnj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:43:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53807 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbfDILnj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:43:39 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hDpA6-0008Mb-48; Tue, 09 Apr 2019 11:43:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] brcmfmac: fix leak of mypkt on error return path
Date:   Tue,  9 Apr 2019 12:43:33 +0100
Message-Id: <20190409114333.24342-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently if the call to brcmf_sdiod_set_backplane_window fails then
then error return path leaks mypkt. Fix this by returning by a new
error path labelled 'out' that calls brcmu_pkt_buf_free_skb to free
mypkt.  Also remove redundant check on err before calling
brcmf_sdiod_skbuff_write.

Addresses-Coverity: ("Resource Leak")
Fixes: a7c3aa1509e2 ("brcmfmac: Remove brcmf_sdiod_addrprep()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Remove  redundant check on err before calling
brcmf_sdiod_skbuff_write, kudos to Dan Carpenter and Arend Van Spriel
for spotting this.

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index ec129864cc9c..60aede5abb4d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -628,15 +628,13 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
 	if (err)
-		return err;
+		goto out;
 
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	if (!err)
-		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr,
-					       mypkt);
-
+	err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr, mypkt);
+out:
 	brcmu_pkt_buf_free_skb(mypkt);
 
 	return err;
-- 
2.20.1

