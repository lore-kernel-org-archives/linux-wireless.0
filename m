Return-Path: <SRS0=Pq/w=BU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55BBC433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A2012080C
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597087279;
	bh=5jqvCiKRJBHM6wCakwUncmndmrLuQZ6BD/yNkVWmES0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1geD+5Gra3RU5qC5Tp5vWRa/76THIq/Ig4WcOtOg2+P9WeYCceKx2AgevLSr6EvRZ
	 dB1iiVGbhDsoTwRnL9qNbsGJpB9tzmH8+Ii8Z2EuNZZoDWl892m9W0zlhFKbkXodu5
	 syghpaY1Ru1iRx5WChdw33YUm6aNDkWFHpKA2HsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgHJTNa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Aug 2020 15:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgHJTN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Aug 2020 15:13:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A72A222B49;
        Mon, 10 Aug 2020 19:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086808;
        bh=5jqvCiKRJBHM6wCakwUncmndmrLuQZ6BD/yNkVWmES0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehsegRjcBae06qdg0bdN9aKL8O1EhCe2V0u4S/H+i6oyYQHPy0CQJiyQz2xIVn75J
         5xpsGJmftM1ObmKFvMiTZ2P8ACfJRdF+iF5rcBk+DvjAUfWGSnkvJlVMAwo5BbGctJ
         G/5p3m9e8q9uUtPkGmgaphwIDfxVnpxFtj9J1tXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/31] brcmfmac: To fix Bss Info flag definition Bug
Date:   Mon, 10 Aug 2020 15:12:48 -0400
Message-Id: <20200810191259.3794858-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191259.3794858-1-sashal@kernel.org>
References: <20200810191259.3794858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>

[ Upstream commit fa3266541b13f390eb35bdbc38ff4a03368be004 ]

Bss info flag definition need to be fixed from 0x2 to 0x4
This flag is for rssi info received on channel.
All Firmware branches defined as 0x4 and this is bug in brcmfmac.

Signed-off-by: Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200604071835.3842-6-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index d5bb81e887624..9d2367133c7c6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -30,7 +30,7 @@
 #define BRCMF_ARP_OL_PEER_AUTO_REPLY	0x00000008
 
 #define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
-#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0002
+#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0004
 
 #define BRCMF_STA_BRCM			0x00000001	/* Running a Broadcom driver */
 #define BRCMF_STA_WME			0x00000002	/* WMM association */
-- 
2.25.1

