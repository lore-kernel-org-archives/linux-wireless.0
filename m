Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8227AC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D9B218FF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Yxb6nr7F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394581AbfBNMoP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:15 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48268 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403890AbfBNMoO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:14 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id E866094A1E;
        Thu, 14 Feb 2019 04:44:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com E866094A1E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148251;
        bh=V0ur+Hj2f5UXUD7u79feyVgu7Fi9fo4cTaRTlNCXHdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yxb6nr7FNVfYGwV1tIPqh3+vPnH9NK5kq1iX2VpXGKyastW2DE475SYYG1WKDYgSm
         HjFmMytTSBFnItGjuyyX+jK+JQSpgjK21r5CcgM3JVrUMQz4nmcq+v9Mao5uX4f+iY
         ZVgs0HQ0VGydc1btzSZHPvqS345nzb8UK+WNKV0M=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 75D6281EBF;
        Thu, 14 Feb 2019 04:44:12 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 364AAB02AF0; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: assure SSID length from firmware is limited
Date:   Thu, 14 Feb 2019 13:43:47 +0100
Message-Id: <1550148232-4309-2-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The SSID length as received from firmware should not exceed
IEEE80211_MAX_SSID_LEN as that would result in heap overflow.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b5e291e..012275f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3507,6 +3507,8 @@ static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
 	}
 
 	netinfo = brcmf_get_netinfo_array(pfn_result);
+	if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+		netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(cfg->wowl.nd->ssid.ssid, netinfo->SSID, netinfo->SSID_len);
 	cfg->wowl.nd->ssid.ssid_len = netinfo->SSID_len;
 	cfg->wowl.nd->n_channels = 1;
-- 
1.9.1

