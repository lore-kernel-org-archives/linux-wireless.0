Return-Path: <SRS0=5LI1=BA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE3C433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 11:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5774B20717
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 11:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgGULXQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:23:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgGULXQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jul 2020 07:23:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 80547B008;
        Tue, 21 Jul 2020 11:23:21 +0000 (UTC)
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     linux-kernel@vger.kernel.org
Cc:     kvalo@codeaurora.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH v2] brcmfmac: Set timeout value when configuring power save
Date:   Tue, 21 Jul 2020 13:23:02 +0200
Message-Id: <20200721112302.22718-1-nsaenzjulienne@suse.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Set the timeout value as per cfg80211's set_power_mgmt() request. If the
requested value value is left undefined we set it to 2 seconds, the
maximum supported value.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
---

Changes since v1:
 - Use min_t()

 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5d99771c3f64..ab0da2ff982e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -84,6 +84,8 @@
 
 #define BRCMF_ND_INFO_TIMEOUT		msecs_to_jiffies(2000)
 
+#define BRCMF_PS_MAX_TIMEOUT_MS		2000
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -2942,6 +2944,12 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 		else
 			bphy_err(drvr, "error (%d)\n", err);
 	}
+
+	err = brcmf_fil_iovar_int_set(ifp, "pm2_sleep_ret",
+				min_t(u32, timeout, BRCMF_PS_MAX_TIMEOUT_MS));
+	if (err)
+		bphy_err(drvr, "Unable to set pm timeout, (%d)\n", err);
+
 done:
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
-- 
2.27.0

