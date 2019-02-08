Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3134CC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 06:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D69B621916
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 06:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMePqczb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfBHGnF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 01:43:05 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46129 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfBHGnF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 01:43:05 -0500
Received: by mail-lj1-f196.google.com with SMTP id v15-v6so1988410ljh.13
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 22:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l5GLuIYs34Ydiwx+7Plh6B2jkE4j91UdbthfqEsuAMs=;
        b=kMePqczbp8i8uVX3+k1EB2TUMNCsye30G7YKPc6Ebsvy7qKlxVhq65RoidHDa8DhEn
         HAGKGGd8KykgC3UiXV9y0BkTZ6i3J05zXA62yH3ywFYAOLqY4aA1cuxB5mfQdBLbUMz0
         bgNj80shWdJvoDPf94c3yAVZB6Rr7YmafQJZMwTvXWFx5AWtZq7/lVAzTRBeO0HtjTWD
         ppJ4TiDIfz1mzqGrj4rqeFkU7nWcy8xr3C1R6vYYYz6e8BQsAIYI5kG+lFQCjQu2alxj
         b9Tqt7otXVCim3JFsi4uyUhgSzPG7Xk47LBnpGgSQ6zxQLBssk8rQEfegMHzoCUPAXUv
         IBYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l5GLuIYs34Ydiwx+7Plh6B2jkE4j91UdbthfqEsuAMs=;
        b=RCRTIFZD4TJjasAA7T9hmF6Bcwqc9Rx6+2zXNsUg8ueERUzrscfjO4dLxU0Hk6Vlp/
         gHwmiKjbSDXJ98evA27MMbAeupO+Z9zuT+dVQHtY4W5q9o0fjPG0K2/hiVOxIcb9tW7S
         lJUVf46z/epVucxr5y5p6l2dNcmhAGca3iXTdyxYLQimoPkSCjHE9o+KSt2q/ptDLSO9
         fGzfhnM9bSjohMBBJJglkpI3Klu3zGWUDv3ZRSPqxGuIjviurxozedjoiEBYX9IZquI+
         +jyBM3P2xqLd+grwR0Sjiz1xhPbdpNwMkCY1FBXvx/Ob7Q3O+DWh93j1X/+eIe0i6baE
         0H3g==
X-Gm-Message-State: AHQUAuZddNx24hBvlL2FGYE2hPModQrAm+QeNCjNjgHhmssxWKWnBloJ
        7RFp2LI0p1w5oVPnC5ZXN2o=
X-Google-Smtp-Source: AHgI3IbMaDgeuoatu/X4qCle3wHak7wJPiqhxfqUE+u5Y51C/B6a3JPtHchsO2rQss4LUlVgiwg1Zw==
X-Received: by 2002:a2e:21a9:: with SMTP id h41-v6mr12344062lji.103.1549608183012;
        Thu, 07 Feb 2019 22:43:03 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id z6sm186883lfa.87.2019.02.07.22.43.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 22:43:02 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2] brcmfmac: support monitor frames with the hardware/ucode header
Date:   Fri,  8 Feb 2019 07:42:30 +0100
Message-Id: <20190208064230.27775-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122110858.12993-1-zajec5@gmail.com>
References: <20190122110858.12993-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

So far there were two monitor frame formats:
1) 802.11 frames (with frame (sub)type & all addresses)
2) 802.11 frames with the radiotap header

Testing the latest FullMAC firmwares for 4366b1/4366c0 resulted in
discovering a new format being used. It seems (almost?) identical to the
one known from ucode used in SoftMAC devices which is most likely the
same codebase anyway.

While new firmwares will /announce/ radiotap header support using the
"rtap" fw capability string it seems no string was added for the new
ucode header format.

All above means that:
1) We need new format support when dealing with a received frame
2) A new feature bit & mapping quirks have to be added manually

As for now only an empty radiotap is being created. Adding support for
extracting some info (band, channel, signal, etc.) is planned for the
future.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Update commit message (only):
    1) Don't say the new firmwares were expected to provide radiotap
       frames. That was my misinterpretation of adding "rtap" string.
    2) List all monitor frame formats as it apparently got a bit
       confusing at this point (there are 3 different ones!).
---
 .../broadcom/brcm80211/brcmfmac/core.c        | 55 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/feature.c     |  4 ++
 .../broadcom/brcm80211/brcmfmac/feature.h     |  4 +-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 860a4372cb56..e772c0845638 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -43,6 +43,36 @@
 
 #define BRCMF_BSSIDX_INVALID			-1
 
+#define	RXS_PBPRES				BIT(2)
+
+#define	D11_PHY_HDR_LEN				6
+
+struct d11rxhdr_le {
+	__le16 RxFrameSize;
+	u16 PAD;
+	__le16 PhyRxStatus_0;
+	__le16 PhyRxStatus_1;
+	__le16 PhyRxStatus_2;
+	__le16 PhyRxStatus_3;
+	__le16 PhyRxStatus_4;
+	__le16 PhyRxStatus_5;
+	__le16 RxStatus1;
+	__le16 RxStatus2;
+	__le16 RxTSFTime;
+	__le16 RxChan;
+	u8 unknown[12];
+} __packed;
+
+struct wlc_d11rxhdr {
+	struct d11rxhdr_le rxhdr;
+	__le32 tsf_l;
+	s8 rssi;
+	s8 rxpwr0;
+	s8 rxpwr1;
+	s8 do_rssi_ma;
+	s8 rxpwr[4];
+} __packed;
+
 char *brcmf_ifname(struct brcmf_if *ifp)
 {
 	if (!ifp)
@@ -409,6 +439,31 @@ void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_RADIOTAP)) {
 		/* Do nothing */
+	} else if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR)) {
+		struct wlc_d11rxhdr *wlc_rxhdr = (struct wlc_d11rxhdr *)skb->data;
+		struct ieee80211_radiotap_header *radiotap;
+		unsigned int offset;
+		u16 RxStatus1;
+
+		RxStatus1 = le16_to_cpu(wlc_rxhdr->rxhdr.RxStatus1);
+
+		offset = sizeof(struct wlc_d11rxhdr);
+		/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU
+		 * subframes
+		 */
+		if (RxStatus1 & RXS_PBPRES)
+			offset += 2;
+		offset += D11_PHY_HDR_LEN;
+
+		skb_pull(skb, offset);
+
+		/* TODO: use RX header to fill some radiotap data */
+		radiotap = skb_push(skb, sizeof(*radiotap));
+		memset(radiotap, 0, sizeof(*radiotap));
+		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
+
+		/* TODO: 4 bytes with receive status? */
+		skb->len -= 4;
 	} else {
 		struct ieee80211_radiotap_header *radiotap;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 4c5a3995dc35..b91b7ecbfedf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -103,6 +103,10 @@ static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
 	{ "01-6cb8e269", BIT(BRCMF_FEAT_MONITOR) },
 	/* brcmfmac4366b-pcie.bin from linux-firmware.git commit 52442afee990 */
 	{ "01-c47a91a4", BIT(BRCMF_FEAT_MONITOR) },
+	/* brcmfmac4366b-pcie.bin from linux-firmware.git commit 211de1679a68 */
+	{ "01-801fb449", BIT(BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR) },
+	/* brcmfmac4366c-pcie.bin from linux-firmware.git commit 211de1679a68 */
+	{ "01-d2cbb8fd", BIT(BRCMF_FEAT_MONITOR_FMT_HW_RX_HDR) },
 };
 
 static void brcmf_feat_firmware_overrides(struct brcmf_pub *drv)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 0b4974df353a..5e88a7f16ad2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -35,6 +35,7 @@
  * FWSUP: Firmware supplicant.
  * MONITOR: firmware can pass monitor packets to host.
  * MONITOR_FMT_RADIOTAP: firmware provides monitor packets with radiotap header
+ * MONITOR_FMT_HW_RX_HDR: firmware provides monitor packets with hw/ucode header
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -52,7 +53,8 @@
 	BRCMF_FEAT_DEF(GSCAN) \
 	BRCMF_FEAT_DEF(FWSUP) \
 	BRCMF_FEAT_DEF(MONITOR) \
-	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP)
+	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP) \
+	BRCMF_FEAT_DEF(MONITOR_FMT_HW_RX_HDR)
 
 /*
  * Quirks:
-- 
2.20.1

