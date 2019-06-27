Return-Path: <SRS0=XE1e=U2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52EEC48BD9
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B692084B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561596593;
	bh=+wsvP3Sq5vBZ057Yb9y8toEVymdBvVtmGhlYf27lnik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GL7Z0tj6m8xop5NYwpN4s78p8RuZaS0k05OOCV48sGmJZF+darJ84dfIK5b3gxDU8
	 EtIL5omlXqhD6AEwlA8wnhUwRvsSEFE8Z8LvLPfur+4nFg6bg1+Mvvq4faFdszaTyP
	 9vIChcNQBrC36LuBDanBAzFzB+GoGvRqjVnE2OVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfF0Ag7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Jun 2019 20:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbfF0Ag5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jun 2019 20:36:57 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E10217F4;
        Thu, 27 Jun 2019 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595816;
        bh=+wsvP3Sq5vBZ057Yb9y8toEVymdBvVtmGhlYf27lnik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0yLVMZX+rNhN7MlM2gKRMSR2zVsFyGRn4ZGKCFxraOuOJTBy/WUkatUU6cvmteif
         AGbiJNQp2QKqDV9P+0RV1c4BDdbebzIzJ7To3aTC0TVVTSrSu8FrbMUK9pkAH1lCVY
         L9zixyXARUNP5LiOwwJOkeEaI/wCb7JPbxj0MD+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, huangwen <huangwen@venustech.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/60] mwifiex: Fix possible buffer overflows at parsing bss descriptor
Date:   Wed, 26 Jun 2019 20:35:28 -0400
Message-Id: <20190627003616.20767-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 13ec7f10b87f5fc04c4ccbd491c94c7980236a74 ]

mwifiex_update_bss_desc_with_ie() calls memcpy() unconditionally in
a couple places without checking the destination size.  Since the
source is given from user-space, this may trigger a heap buffer
overflow.

Fix it by putting the length check before performing memcpy().

This fix addresses CVE-2019-3846.

Reported-by: huangwen <huangwen@venustech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 8e483b0bc3b1..ddf985fb93ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1247,6 +1247,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:
+			if (element_len > IEEE80211_MAX_SSID_LEN)
+				return -EINVAL;
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
@@ -1256,6 +1258,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_SUPP_RATES:
+			if (element_len > MWIFIEX_SUPPORTED_RATES)
+				return -EINVAL;
 			memcpy(bss_entry->data_rates, current_ptr + 2,
 			       element_len);
 			memcpy(bss_entry->supported_rates, current_ptr + 2,
-- 
2.20.1

