Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.248.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805357;
	b=sz16tvrTRmRkz1/ULl1fAzMpvxLFymHIfWiQy6A+6XLz+zSIBRO/sxKQq+u7FiESUWe9
	 tXQ4U69qr+v/QvytsJKJpCQCyvpd3vFTB4n1URXaF7ClMCR/0B9po4djonHB7ZRWPxh3y
	 +KlRv5/DxKUbaJA9VJ+9Hxuk9ToQz1DKZvoafutDRXO9aZZWJb4OQKBmtMLvKgJ0EW0Ro
	 +4H8kT1rd4UD0zYtPNwdXTD9KRrG5hXqyNtNltVjA9CUTLg0MA2xG6LjVfFJllQ7J2mV8
	 WOclwMF1ZOvcdY7kGRrgHiNAX/kAC+xazNh8Ah9QbKH9w2tkYWGIvM3s7SxKz2BlsrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805357;
	h=DMARC-Filter:From:DKIM-Signature:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tr7Z60WjLoXLrxIMS9C1ZyJG8YJwnDZLJ0lakerpC4U=;
	b=wiGXadRO5OA+1m402xd3Nqnj4XTQGok0KkZIUibCazLY4IJEPFSzWL75xv2Csd7u3URT
	 8ClQPtfBC9j1R281xo8R/mC29LaCaYeqGR0a6/UqZwoXcPkSr4+elTa9jp4mBeojjcj5t
	 Nf/AgDXny+sMVBqxxFu/ke/+bQVXl7zMwVwqd3KpMKT9HmhjbHyDMVDzkBOUC8rF8KuID
	 n9wmUIrTrkkz/bvb1imhHwfW++UNlfu0mEYXLUUeSVRP8wQYF5b1Naf4K2GZql86kCYsN
	 SVXrG8QCGd7kOPH3fuVH0cqOh63rYnjLIxYgi8xNEpjBt2NTx+jtMV3JTestRm26U6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=deq.rocks;
	spf=none smtp.mailfrom=deq.rocks;
	dkim=pass header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=QjgrMQy9;
	arc=none smtp.remote-ip=91.216.248.207
Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CA9606D801;
	Wed,  4 Nov 2026 15:15:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77CA9606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=QjgrMQy9
From: Andre Eikmeyer <dev@deq.rocks>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1793805354;
	bh=q8b/GJFJ2queRI9j7K8BKwl4WwD+8kW3jyDJd8kkN+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjgrMQy9x7SZQNehVanrl5Y2bCW6eHJfGAcXpo6eKuvzy4YFTRjMWspiShZEN/jyA
	 Ott0d6GXhW5J+sBkxbUB4T6tJrBe4G533gIAMSzfb8d/adqZfRyihohw/N45dD8g9J
	 tzdwcNlL18ZbiDV9JjNmBv+930kI4pOQ0Uxde1bAp1h7cyrh+npfIvrxIeysTCO4jP
	 sfjVkBH9T8iIs47aZHwqGNXHwU3TevKc3ZcMVBXQLklSwDalKCzTcsk4mEU7bNhdVD
	 fkZbToMJT1upXK+LRq6RRQ8DxwGwdwypM7Y7hjA6ZyPgXdUEia1OBCUytpH1zJ7qPq
	 SIMwuCUjzjXbQ==
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>,
	Yossef Osman <Yossef.Osman@proton.me>,
	Aditya Garg <aditya.garg@linux.dev>
Subject: [PATCH 3/7] wifi: brcmfmac: detect AWDL support of the firmware
Date: Wed,  4 Nov 2026 16:15:43 +0100
Message-ID: <20261104151547.70333-4-dev@deq.rocks>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104151547.70333-1-dev@deq.rocks>
References: <20261104151547.70333-1-dev@deq.rocks>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Apple firmware of the BCM4364 and BCM4377 runs Apple Wireless
Direct Link (AWDL) itself and announces it with "awdl" in its
capabilities. Add the feature flag for it.

An AWDL interface is created with interface_create version 3 and
interface type 2. The host gives the MAC address, the interface index
and the BSSID, which the flags 0x2, 0x8 and 0x10 select. Add the
definitions for the interface type and the two new flags.

The BCM4350 firmware 7.35.180.133 lists "awdl" as well and answers
every interface_create, including the version query, with
BCME_UNSUPPORTED. Keep the flag only when the firmware reports
interface_create version 3.

Tested-by: Yossef Osman <Yossef.Osman@proton.me>
Tested-by: Aditya Garg <aditya.garg@linux.dev>
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
---
 .../broadcom/brcm80211/brcmfmac/feature.c     | 26 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/feature.h     |  3 ++-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  3 +++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index b324eb53a69..e7d5bc79c08 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -47,6 +47,7 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
 	{ BRCMF_FEAT_SAE_EXT, "sae_ext" },
 	{ BRCMF_FEAT_FBT, "fbt" },
 	{ BRCMF_FEAT_OKC, "okc" },
+	{ BRCMF_FEAT_AWDL, "awdl" },
 };
 
 #ifdef DEBUG
@@ -294,6 +295,29 @@ static int brcmf_feat_fwcap_debugfs_read(struct seq_file *seq, void *data)
 	return 0;
 }
 
+/**
+ * brcmf_feat_awdl_check() - keep AWDL only with interface_create version 3.
+ *
+ * @ifp: interface to query.
+ *
+ * The AWDL interface is created with interface_create version 3. The
+ * BCM4350 firmware 7.35.180.133 lists "awdl" but answers every
+ * interface_create with BCME_UNSUPPORTED.
+ */
+static void brcmf_feat_awdl_check(struct brcmf_if *ifp)
+{
+	u32 ver = 0;
+	s32 err;
+
+	err = brcmf_fil_bsscfg_int_query(ifp, "interface_create", &ver);
+	if (!err && ver == WL_INTERFACE_CREATE_VER_3)
+		return;
+
+	brcmf_dbg(INFO, "disabling AWDL, interface_create version %u (%d)\n",
+		  ver, err);
+	ifp->drvr->feat_flags &= ~BIT(BRCMF_FEAT_AWDL);
+}
+
 void brcmf_feat_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
@@ -303,6 +327,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	s32 err;
 
 	brcmf_feat_firmware_capabilities(ifp);
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_AWDL))
+		brcmf_feat_awdl_check(ifp);
 	memset(&gscan_cfg, 0, sizeof(gscan_cfg));
 	if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID &&
 	    drvr->bus_if->chip != BRCM_CC_4345_CHIP_ID &&
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 8165a286b63..0d98d4d7122 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -61,7 +61,8 @@
 	BRCMF_FEAT_DEF(PMKID_V3) \
 	BRCMF_FEAT_DEF(SAE_EXT) \
 	BRCMF_FEAT_DEF(FBT) \
-	BRCMF_FEAT_DEF(OKC)
+	BRCMF_FEAT_DEF(OKC) \
+	BRCMF_FEAT_DEF(AWDL)
 
 /*
  * Quirks:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 6f13e10b16d..8d1532edbad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -1244,9 +1244,12 @@ struct brcmf_mkeep_alive_pkt_le {
 
 #define WL_INTERFACE_MAC_DONT_USE	0x0
 #define WL_INTERFACE_MAC_USE		0x2
+#define WL_INTERFACE_IF_INDEX_USE	0x8
+#define WL_INTERFACE_BSSID_USE		0x10
 
 #define WL_INTERFACE_CREATE_STA		0x0
 #define WL_INTERFACE_CREATE_AP		0x1
+#define WL_INTERFACE_CREATE_AWDL	0x2
 
 struct wl_interface_create_v1 {
 	u16	ver;			/* structure version */
