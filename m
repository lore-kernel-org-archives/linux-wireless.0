Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC23C67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED2C20870
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:20:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EED2C20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=i2se.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbeLLTUv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 14:20:51 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:38431 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbeLLTUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 14:20:51 -0500
Received: from localhost.localdomain ([37.4.249.153]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1Mc0Er-1hA3Vb4AhT-00dXcG; Wed, 12 Dec 2018 20:20:29 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH] brcmfmac: Fix access point mode
Date:   Wed, 12 Dec 2018 20:20:06 +0100
Message-Id: <1544642406-24272-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:JAQVqIbbMb7gPILbRL9K5eaMp40i2ymKakTliG2b0Sf/QWtem36
 xTShK26LIhWocm3rmCg7MsvV0JrhVxsRZYjGw1TW4EmP0+WZFxVKN0oE2fdc4doJXwm7Nnm
 H0/3aPP1eKmb+djZ7XKYL9VtkfhqqZ23XxYwux54kUAcDUBwoSSJb7iPPytbKMGDxPhzKQt
 G4YFcn3bbhndDhFzWNcig==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1fs8gZrIaxc=:ed3+rHU5b2jOMgn/XM2Gtf
 Ecl/EVNcmxAHTA6O5vX9dfpUSbxKt+f29vamP225qAr/w3VWP6/VrTHRFcsnaxxuD644Uxc5g
 iCdCv0AUP7FhpY3mMtq0bKGKo1fVX2MTnbNUfdEQriYl/goAEqsD+tgt/2oJotbw+4tkyArTB
 fo3ZevJtFuitDQeoR4XxYVk6pH1J1u230f+4RHaZn0R+hXgjnRvth/kv3bAfduJVGBcPL1qc1
 UCiGX/N+VIok0Ws6viF3+CCeBW2pbA8hcbM3T+qCDlAtRkDo5SJtdX+OK9y+xuPHL/jBawZlw
 4RPqD18WeBJ2CT7tYKS5mky7KwD3lUm+IFecftGRA15eIW5BF1T/wqn8l/Z8BmW/1VobqubZV
 L4m2uP5PmnnkO1ow0sgyuzd+PSecwrgmPESh7poA2BjpNaiCu9LFU+YaUF159z2gklSKeaNpx
 raQp1DC9+/I8UwUCguzwSi2m6VV/7WvCPcRqALJRsPc0t011k46zISpwJndBSlV9d6uefiOY0
 IrbtXrr7yOZmxJ3QujPzr1PhyWINSt0XRmFKaV6pJrNrFCl+p1UIUdJEYMSj2nhmKkiDTGuC7
 yw2aMGNNhKJsHa3uyBjQqkwbVhSob0EzDSY3b4yqg6nDrcOVm2eJyy/VS/hJId0X8XraiiFLp
 Tn44VJhAQkKhNHM2xiv9UehRw3+KnjHPf+8nqdfn9vxz6dRWJ/bI/vKCx/eDuSBpmR9vVSL0G
 /HEgJALi4t4q6TRTB672za0zaW92iUmF1BKCzw5LomT27PeJKOA26GYlxbg=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since commit 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
the Raspberry Pi 3 A+ (BCM43455) isn't able to operate in AP mode with
hostapd (device_ap_sme=1 use_monitor=0):

brcmfmac: brcmf_cfg80211_stop_ap: setting AP mode failed -52

So add the missing mgmt_stypes for AP mode to fix this.

Fixes: 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7f0a5ba..05bd818 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6309,6 +6309,16 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 		.tx = 0xffff,
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4) |
+		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+		      BIT(IEEE80211_STYPE_ACTION >> 4)
 	}
 };
 
-- 
2.7.4

