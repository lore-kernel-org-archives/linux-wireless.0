Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A553EC07E85
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 18:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D885A20834
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 18:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-ipv6.be header.i=@linux-ipv6.be header.b="mUzzh2F9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D885A20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-ipv6.be
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbeLDSgh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 13:36:37 -0500
Received: from mail.tintel.eu ([54.36.12.13]:43218 "EHLO mail.tintel.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbeLDSgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 13:36:21 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 02320424DC05;
        Tue,  4 Dec 2018 19:36:16 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id id-0i2DcdDEq; Tue,  4 Dec 2018 19:36:15 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 7B80C424DBF7;
        Tue,  4 Dec 2018 19:36:15 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 7B80C424DBF7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1543948575;
        bh=WPMz1xRRBUBDJgmKVJH9vBAR9RfEsz/RgfnQQckQplo=;
        h=From:To:Date:Message-Id;
        b=mUzzh2F9K34VhC3aReNxcmImbwK5oeZ44y18hR0QAHZly4uvsjrzoK1nIrihUxj8g
         ws55viOcnaH8c60K9v2ClkrmXrvwKcQzlBgB9gW7SjI+BAzDovjHwxuoyVf2Fxbp3l
         YGFlRMzA4ILJGYZXZqXVOwI54fdB6FL6yXCizVcM=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id WlbivLNgCPCw; Tue,  4 Dec 2018 19:36:15 +0100 (CET)
Received: from taz.sof.bg.adlevio.net (unknown [IPv6:2001:67c:21bc:24::286])
        by mail.tintel.eu (Postfix) with SMTP id EC44E42334BB;
        Tue,  4 Dec 2018 19:36:12 +0100 (CET)
Received: (nullmailer pid 32312 invoked by uid 1000);
        Tue, 04 Dec 2018 18:29:05 -0000
From:   Stijn Tintel <stijn@linux-ipv6.be>
To:     linux-wireless@vger.kernel.org
Cc:     arend.vanspriel@broadcom.com, Stable <stable@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: [PATCH wireless-drivers] brcmfmac: fix roamoff=1 modparam
Date:   Tue,  4 Dec 2018 20:29:05 +0200
Message-Id: <20181204182905.32267-1-stijn@linux-ipv6.be>
X-Mailer: git-send-email 2.18.1
X-Rspamd-Queue-Id: EC44E42334BB
X-Spamd-Result: default: False [7.67 / 15.00];
         ARC_NA(0.00)[];
         R_SPF_FAIL(1.00)[-all];
         RDNS_NONE(1.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[linux-ipv6.be];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         NEURAL_SPAM_SHORT(1.92)[0.959,0];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.00)[];
         IP_SCORE(0.25)[ipnet: 2001:67c:21bc::/48(0.69), asn: 200533(0.46), country: BG(0.08)];
         ASN(0.00)[asn:200533, ipnet:2001:67c:21bc::/48, country:BG];
         HFILTER_HOSTNAME_UNKNOWN(2.50)[];
         GREYLIST(0.00)[pass,body];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: musltoo
X-Spam: Yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When the update_connect_param callback is set, nl80211 expects the flag
WIPHY_FLAG_SUPPORTS_FW_ROAM to be set as well. However, this flag is
only set when modparam roamoff=0, while the callback is set
unconditionally. Since commit 7f9a3e150ec7 this causes a warning in
wiphy_register, which breaks brcmfmac.

Disable the update_connect_param callback when roamoff=0 to fix this.

Fixes: 7f9a3e150ec7 ("nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS")
Cc: Stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 11 +++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.h   |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c   |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7f0a5bade70a..c0e3ae7bf2ae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5196,10 +5196,17 @@ static struct cfg80211_ops brcmf_cfg80211_ops = {
 	.del_pmk = brcmf_cfg80211_del_pmk,
 };
 
-struct cfg80211_ops *brcmf_cfg80211_get_ops(void)
+struct cfg80211_ops *brcmf_cfg80211_get_ops(struct brcmf_mp_device *settings)
 {
-	return kmemdup(&brcmf_cfg80211_ops, sizeof(brcmf_cfg80211_ops),
+	struct cfg80211_ops *ops;
+
+	ops = kmemdup(&brcmf_cfg80211_ops, sizeof(brcmf_cfg80211_ops),
 		       GFP_KERNEL);
+
+	if (ops && settings->roamoff)
+		ops->update_connect_params = NULL;
+
+	return ops;
 }
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index a4aec0004e4f..9a6287f084a9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -404,7 +404,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
-struct cfg80211_ops *brcmf_cfg80211_get_ops(void);
+struct cfg80211_ops *brcmf_cfg80211_get_ops(struct brcmf_mp_device *settings);
 enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp);
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b1f702faff4f..860a4372cb56 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1130,7 +1130,7 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	ops = brcmf_cfg80211_get_ops();
+	ops = brcmf_cfg80211_get_ops(settings);
 	if (!ops)
 		return -ENOMEM;
 
-- 
2.18.1

