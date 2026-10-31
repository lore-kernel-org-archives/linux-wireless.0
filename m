Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430626;
	b=BiGi3u/IIgPLkvYHQNZeXL9D/gdFHBdskVECjW00RCwbElchKID6spaXUPojqTOgeycy
	 B1l5Qlylcx5AnYhL+OPv5Ia5KIeEFY3k2pe4MBwp9IIkuw0/heNScU5ZC6NARM75VYZZZ
	 3NbuLhIJ9cOb0RufT5+hIzbJaTWmpfKdifKORLoKRRr6YWcNjiWIO/9S0V71zDUkZ5Cux
	 8bPNybELHbkftlj/pkYtqfjlCuOHKpnFFqUD7rX3Foeopqic/U5PKoUwu2Kko6K08guSX
	 RBesXjUtvWuPZR7wXTwJkPOiplva3wwa6Cv46PInZrzVDFvcbrMt0wV0KxT4uJWDr2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ad2ia27EnAVG08wFvfZ7zlOUesKclGmPX+4LQPOn1N4=;
	b=wvdReLUKejNTELSKnXMXXbiv1lQn4ssFvfRar999QeFRkcXi/Dj+9oMTKpRsgmYXe1Qi
	 STomv2g7BxETszabUtWwS2smceuItgcHOnTxYLFPMvl3eDI1OKH+m5z67IcmulqmY65te
	 toICt5BkR58UubK8GA0KKWqrRu/MLRyVw5FrMhaYB66svDmMsjyZwDeb7QbvaAtwdMTcj
	 u8P1IojxTDjxBWemvewmRDdsC68kZZCTIDXR0j+XwST+vQ1v0e4iqL3Tlo21D00xet83q
	 6Xjhcz1rVKHtDR0vPS2AKBYMxTg+a4NlwBkC2lqt+oVTPINd80LsUd/V6kibrr6dmJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0E1HLUVN;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2038B606A31F
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2038B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0E1HLUVN
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae702d28c4so691733a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430625; x=1794035425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ad2ia27EnAVG08wFvfZ7zlOUesKclGmPX+4LQPOn1N4=;
        b=0E1HLUVN0wv3+o8ksP6Syby/QUd70/Oe4xjviWzhA/fd9IMNC6F9cgAqBsnIM8mbRu
         bn0spiTE4/5QHHRkaO2joPGM9+pUgkRmcUVJifFTUKfnRmFubB1B9f19n1IwR4IKqE5G
         6QxMsrAk7ArYB/QORoSlsehVYIkL0cyU+F7pjaFBq9bKuItIViI/nSHfM1OkeYlx8ZJz
         Me79KWh+boobkyqhTz5lWKGrQAPzYHEVXOJqP4vGvKDNIj/mrysl9nCS1Zb+CpsnLAyo
         YoJdcOhipYkYL91C1CJOrQ2SZimpHp3fYkR/94i22h//fNtIN4lCGZ4RUfYT5LDwB7DJ
         P9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430625; x=1794035425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ad2ia27EnAVG08wFvfZ7zlOUesKclGmPX+4LQPOn1N4=;
        b=2URgpSEu998hD+nShMRiShZM5Ur/K4/j289GikEi5dD5sDLkkYvYQmAvKmbAwPT1oD
         q/PYAwU2GtdBBxxiD6MR0Pz17wfnQfaToOVf7ZY32ixO3dAaK95YtRK3W/5S1+K1lNSU
         Yu0U0+WfAVtRs6/TitnN9C4rEDuU1Z+Wc+I0Q/BlZF2tA4jSExHgoTt4kVZXkUFz56LC
         GQait7es3L/ifG3EdB2PPKM7EZG93vnWFrcxYgpnw8izg6u4enXV0FQkrTa+zuqFFMKG
         UX3zyzF7nzwCRv/SPNXgE/j9ne4p4b/g0uE6UybYJbxNMdusukSBT43FEjZLy7NvECxe
         znPQ==
X-Gm-Message-State: AFq9FYJJhHRvwl7BAuRBP8f5l4h/XhnIoqZBTTMaLV1BOdc87c1TbbwB
	TkFH2JiVLOoinwpEboE8ncOSHzzCqpPH617xQX+4KJd3Pzu/qPZxVbOL
X-Gm-Gg: AYBFou1EwePSugFLRXqXAZsJ6LrcO5TowjMwo5NhlmGxWQVreyKRJA9byutmJZCjeJ+
	+tnzoFN6t61j1oYr27nnPibmZ8n5lI2q/ExTDTZBCMUfRmMi51IImEexTt0O2QL8Lbw8NrKKQnp
	XxSKortpRLa4UrdXlhtj0LhSkBkTe4KHC0jBRYtmgdMz+bbX3f9/ohgi7MSTquP+ggmWAJ7Lnf4
	pE5/U8dyX6ncvQSI/WNmU8vV3vpJ8m042S83tHwd0suf/IjSaa1Qh6Jk0hWABwJgllw2eIZIN71
	9fNx5EUlHyFch3aMLdCFa+DiOtH7OPTvRmp7a0/ukqGwSso7ANG+56LWC+dqGKihody5qOeCNij
	M0TPIK8oBy/Ax4WKbDlnp/RKx+1/LiBUrhga6IqwuelwTRh6UzCfj2bkndJiGLdBtno1Z0K0xCw
	mP+rPzJFO2iI9OVtL7SvO1E7EpKF6mhPfYvLDIAsV5dvxqg5xAbdan1WUx5Nm6QtbRaqwm3ay/k
	FiHXgr/P88x1eJRJmWNf7ALTkkw2n3CU5qcJ2cCSWYxDJBN4tlMGb8LAUCTP36pgd0cWgpAAG75
	+Ap6MDGU7MpkW46oGM3aUIihb49O2dtdDZzZWCVda+AhqtBYRBwWKHGSlo5Tz7H1UXUFgVzlXpF
	V5R3MRQ==
X-Received: by 2002:a17:90b:51cf:b0:3ab:de4:7fa5 with SMTP id 98e67ed59e1d1-3ae898394c0mr3544591a91.56.1793430625556;
        Sat, 31 Oct 2026 00:10:25 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:25 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2 3/7] wifi: rtw88: correctly expose beamformee capabilities
Date: Sat, 31 Oct 2026 15:09:43 +0800
Message-ID: <20261031070950.425176-4-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261031070950.425176-1-hjf3108@gmail.com>
References: <20261031070950.425176-1-hjf3108@gmail.com>
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

From: Jie Feng <hjf3108@gmail.com>

Make MU and SU capability flags each depend on the chip declared
maximum instead of setting both flags together.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index f7d7b66844862ff01533b8b640ed35738169673d..0a1b5575b729981b34e0fa9c37a4f8380987afa4 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1605,6 +1605,7 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
 static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
 			     struct ieee80211_sta_vht_cap *vht_cap)
 {
+	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	u16 mcs_map = 0;
 	__le16 highest;
@@ -1623,10 +1624,13 @@ static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
 		       0;
 	if (rtwdev->hal.rf_path_num > 1)
 		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
-	vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
-			IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
-	vht_cap->cap |= (rtwdev->hal.bfee_sts_cap <<
-			IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
+	if (rtw_bf_support && chip->bfer_su_max_num) {
+		vht_cap->cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+		vht_cap->cap |= rtwdev->hal.bfee_sts_cap <<
+				IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+	}
+	if (rtw_bf_support && chip->bfer_mu_max_num)
+		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
 
 	if (rtw_chip_has_rx_ldpc(rtwdev))
 		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
-- 
2.55.0

