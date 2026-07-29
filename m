Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8411C5F1B
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345466; cv=none; b=lc+JTmu+/P/syuG/mF9UZhY/Ycj+Fr1AC1H4TIdxmb+87lFmzbO10qXoISzXHC3jilQHc9561lC9NcIoBZUyceht+IK8a09nT35a24OITZ8YLNfIqNfsOFmA+TkbDvbpe6HUa6N80R97KaSCaAbsujJOxyX8ygzlm4qx83AmmEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345466; c=relaxed/simple;
	bh=cNCoPAm076JZvME6q0oFlbFHLqm5jWQl+r0WGZ3nYnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u9eESh88Np11hw2yEl44ksp7QCIPqS4skos03i22t5XVoqaPfESXiLAOKTpZ5maMI+T9IiWPjBYV/FlT7ZaDq95iK8KV3Okci5AG4F0NGIk0ZdvPNteD9qoUnU9TGg/HZj+qSN5xpcTN1VpHb+Wrvv5oFVfS7qm9XxyRCeMYNX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NFUFNglx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gFtps1SU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NFUFNglx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gFtps1SU"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TFFvY92092748
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=wecc9XYEtzPaaAK3iaxwCXZmJUkkxuYPkwe
	dmjWuTHA=; b=NFUFNglxE5ytNLQXgiw++l+Oby5RXSzxpWUN+8gkXu35Q43sQNP
	TkJ1iwzT4JDhCe0kwYo72QT5uIuGX8aJtt9FxnfFSXPwugoJYsYIJEqRs9y+540M
	s69jrJAe3aJRbv1PdDwHPub2yNbKbDld3nQjuxWdMP0nq32pMKvqGVXdYGXtFynt
	YqVurC7ppJCmaJhdA3slH6G/mFoCUwGLvG64RvjWmVA35XmU++lpSNqqcqtMgSj6
	6cM8RLMDu/oaSiXStt8AYMEdW+Hahitc4VFGc+gN1jrc8nDBpaeV8FlSMztRPHJr
	LUixRP1T4sUWD8Ynstd4vF58dmhJVFEZZyw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqm0fgtbg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:17:43 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so1631646a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 10:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785345463; x=1785950263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wecc9XYEtzPaaAK3iaxwCXZmJUkkxuYPkwedmjWuTHA=;
        b=gFtps1SUJXVGmwj7Qz6+Irx3nPNmq65iEwdc0SuZVqVwPbv33BmBu9utGK880/YJoy
         gyP0LhkG0IssgCQa9NSkkbe8LPXojCTlxPYtHsRxe3iMdGrUeJOaqC+tsrlpxzyMuP5v
         Jw652Bw5cG2fuBdXZnpKJeMSwXPnDTnjddaiaoTtg9LddZ0VM3w/fIehnNmLf/rLS9b5
         9pu82fswYjVZ47BGE/A/bA59cPaBtBkpMOFDJuwnQNQ2fLUMxDvPDP0X0HExhVuKm7W8
         Gzn7VfKbNniKPBOdyHhIvCGsl1AOt67zrOPRba9LFgJ/fGxmZCcC+elGHJNr5eyqeSCM
         TKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785345463; x=1785950263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wecc9XYEtzPaaAK3iaxwCXZmJUkkxuYPkwedmjWuTHA=;
        b=rhHjcrB1Muxv/eZU4hqu2i04u9RnmNOWMWlb4fxiRJQZM8r+CdJv7/ZoXVXqAa272Z
         G+2YhiZYNgQtARyuZZ/7OlcM4wBSKOvLK6RH20jQdfYLMjsJODxsN02Q+iyNlq7g6PoU
         F1+jF0uuBeFbqfI7SXzFSca4xZhHssjAMHN2gt1NZTI4SKFpvKknaMhPSccXlGgkzTDL
         G1tZUfTzBXoWmJlouG7PCAEGjjxoxETNLdwtbscIpbWwfpZ9OVWrafIS8dYHP5Ih6ckO
         KdQD03MVFixyRdWeQTCbB/NyPGXum6x4rG6N07aVEhZMmPMDAS0234EJUwHBruEArqXL
         m3wQ==
X-Gm-Message-State: AOJu0Yz1nvy6NC31rhEXNNQCARaX+RXJoz1NcnEWpxf39eL1vQwWdbRu
	r4M07/iifZtlNHhZJ+HibwcmeJq8Xflms7X5ZVxXk3xJu35zlkL/9+NKduoIXJALPJkXUveO9cr
	nlzhsW9wMxQtcnL8vXxNTKAsXYtVfr/B9iX2EqwgfHWTiSCliayKgE9pTxmTXynodaChc2L/a+i
	SvPQ==
X-Gm-Gg: AR+sD10OMNoS33JCJ6YKVkH44Aud3TYN6GTTkxsliQ9XWt1tvFXwJ4QBvuK9vkla89f
	Ef1MAcgQMmESCnk/4vvZjHB2jC+aRBY8zP6MHDLe/7RCK7wrgnvHlEpHcBDYvlmZ+Dbj+mc5X4Y
	TteeSR39NvN0YjwncredtuNEEbONswsbjd8vuiYZgiwyEvHUelqApBgmwVUETNcbv8+F1O+yhc0
	oa8VBK6yHamB3NQN/pu4I8KX7YdKFZ6/wNXM0QXi+IcEzR+20RqM6TJVe5j2nyzF77QLIZzLs5j
	WKALOHB7AmQW5Iig7KK+Bu0olXAHycz8X87iI65DuQ1Bt+TZkWoo9nIjdAOml0w3F+haEOI7ysC
	RTvto0IJp9kXrhLR+JDECQzO4wdXsuByx1cxBAlaliO83xYApd4mXEqOcGfMpYGK7ol6SgsQD4d
	Vtc3V40CC0nVSnwObPgr33pRYF
X-Received: by 2002:a17:90b:3c12:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-38f6a44b7a8mr8239864a91.14.1785345462580;
        Wed, 29 Jul 2026 10:17:42 -0700 (PDT)
X-Received: by 2002:a17:90b:3c12:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-38f6a44b7a8mr8239822a91.14.1785345462141;
        Wed, 29 Jul 2026 10:17:42 -0700 (PDT)
Received: from hu-rrajkuma-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm17606696c88.5.2026.07.29.10.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 10:17:41 -0700 (PDT)
From: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: fix encrypted EAPOL TX in encap offload mode
Date: Wed, 29 Jul 2026 22:47:32 +0530
Message-Id: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ctf2Oi_HTMsroots07iAFdDvmSP5mtds
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzNCBTYWx0ZWRfX8dV6ykPZXoni
 cShjCGE5fnd25DaZAb1L4KQU/JfoxFvVtAIYMSND7Qf6O0NUKlvEtHCYU0YHaeXPli2YQDXxXEY
 tIhZeK2qetox76+ij+U+pp28vhZQtByzP3znuzVzbVCBtNSncud+/Xvis/HlOF+rn+62rJq6Vhq
 +czcR4SUYm0I0i+hMI1fiIfyxVYzSbiB+xQxeqb2pu1yNoEdGxJ5EbbN7Aqq4xCZ8Uy2EGUFwiM
 ISrOBTrjvq7SAWuZsgPzF1MNgqOZxqF73m1sjx09xNiaoSMgJ1aGlCVyL/ucuErD1qlhsKxCZG9
 776GXj28Enec+FjdpiBjhVQ6QxZfzxKpIZ/sIcPJQRqM01xL1Ov6P9aV+xwp6VQH/XORPWfJlF/
 1sqKV5u3XBKApsja1CIx7bHg+dUrlRBNZEIE+7sqH4+lLETMqIKc3FPBa7ZC7VAQXC/xrawb8Tv
 EFJKAZreD8qN4PvfHAA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzNCBTYWx0ZWRfX+K6vEPuh/XdV
 yYX+xvzyiKw5RqwuEtYcVcHk2jEZYCHIitDnKtvr5d8M6+KKtSpDI3jJsZl1joLad6LC9lrSKmk
 gP5iTJlvwkuBXrtZ1SmFoMc8Kb9fk+0=
X-Authority-Analysis: v=2.4 cv=LvuiDHdc c=1 sm=1 tr=0 ts=6a6a35b7 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=8Q-BI5zzvDWikXiF7E0A:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: ctf2Oi_HTMsroots07iAFdDvmSP5mtds
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 clxscore=1011 impostorscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290134

When a vif operates with IEEE80211_OFFLOAD_ENCAP_ENABLED,
mac80211 delivers EAPOL frames to ath12k in native-WiFi format.

Unencrypted EAPOL frames used during the initial 4-way
handshake are already handled through the existing
is_diff_encap path. However, EAPOL frames transmitted during
GTK rekeying carry ATH12K_SKB_CIPHER_SET and continue through
the normal native-WiFi transmit path.

Firmware encryption requires RAW frames with cipher-specific IV and ICV
fields correctly provisioned in the skb. Passing encrypted EAPOL frames
in native-WiFi format results in incorrect IV provisioning, leading to
an invalid ICV and frame drop.

Fix this by detecting the EAPOL frames that need HW encryption and
converting them to firmware-encrypted RAW frames before transmission.
Reserve IV space after the MAC header, append ICV space at the tail,
select the appropriate firmware encryption type and request
firmware-side encryption.

Introduce ath12k_dp_tx_crypto_iv_len() and ath12k_dp_tx_crypto_icv_len()
helpers in the TX path to obtain cipher-specific IV and ICV lengths.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1

Fixes: d29591d5b52e ("wifi: ath12k: Advertise encapsulation/decapsulation offload support to mac80211")
Signed-off-by: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c       | 46 +++++++++++++
 drivers/net/wireless/ath/ath12k/dp_tx.h       |  2 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 64 ++++++++++++++++++-
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index c10da6195c9c..9644f9ef2c74 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -82,6 +82,52 @@ enum hal_encrypt_type ath12k_dp_tx_get_encrypt_type(u32 cipher)
 }
 EXPORT_SYMBOL(ath12k_dp_tx_get_encrypt_type);
 
+u8 ath12k_dp_tx_crypto_iv_len(enum hal_encrypt_type enc_type)
+{
+	switch (enc_type) {
+	case HAL_ENCRYPT_TYPE_TKIP_NO_MIC:
+	case HAL_ENCRYPT_TYPE_TKIP_MIC:
+		return IEEE80211_TKIP_IV_LEN;
+	case HAL_ENCRYPT_TYPE_CCMP_128:
+		return IEEE80211_CCMP_HDR_LEN;
+	case HAL_ENCRYPT_TYPE_CCMP_256:
+		return IEEE80211_CCMP_256_HDR_LEN;
+	case HAL_ENCRYPT_TYPE_GCMP_128:
+	case HAL_ENCRYPT_TYPE_AES_GCMP_256:
+		return IEEE80211_GCMP_HDR_LEN;
+	case HAL_ENCRYPT_TYPE_WEP_40:
+	case HAL_ENCRYPT_TYPE_WEP_104:
+	case HAL_ENCRYPT_TYPE_WEP_128:
+		return IEEE80211_WEP_IV_LEN;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL(ath12k_dp_tx_crypto_iv_len);
+
+u8 ath12k_dp_tx_crypto_icv_len(enum hal_encrypt_type enc_type)
+{
+	switch (enc_type) {
+	case HAL_ENCRYPT_TYPE_CCMP_128:
+		return IEEE80211_CCMP_MIC_LEN;
+	case HAL_ENCRYPT_TYPE_CCMP_256:
+		return IEEE80211_CCMP_256_MIC_LEN;
+	case HAL_ENCRYPT_TYPE_GCMP_128:
+	case HAL_ENCRYPT_TYPE_AES_GCMP_256:
+		return IEEE80211_GCMP_MIC_LEN;
+	case HAL_ENCRYPT_TYPE_TKIP_NO_MIC:
+	case HAL_ENCRYPT_TYPE_TKIP_MIC:
+		return IEEE80211_TKIP_ICV_LEN;
+	case HAL_ENCRYPT_TYPE_WEP_40:
+	case HAL_ENCRYPT_TYPE_WEP_104:
+	case HAL_ENCRYPT_TYPE_WEP_128:
+		return IEEE80211_WEP_ICV_LEN;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL(ath12k_dp_tx_crypto_icv_len);
+
 void ath12k_dp_tx_release_txbuf(struct ath12k_dp *dp,
 				struct ath12k_tx_desc_info *tx_desc,
 				u8 pool_id)
diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.h b/drivers/net/wireless/ath/ath12k/dp_tx.h
index 7cef20540179..1af79af2ada2 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.h
@@ -19,6 +19,8 @@ enum hal_tcl_encap_type
 ath12k_dp_tx_get_encap_type(struct ath12k_base *ab, struct sk_buff *skb);
 void ath12k_dp_tx_encap_nwifi(struct sk_buff *skb);
 u8 ath12k_dp_tx_get_tid(struct sk_buff *skb);
+u8 ath12k_dp_tx_crypto_iv_len(enum hal_encrypt_type enc_type);
+u8 ath12k_dp_tx_crypto_icv_len(enum hal_encrypt_type enc_type);
 void *ath12k_dp_metadata_align_skb(struct sk_buff *skb, u8 tail_len);
 int ath12k_dp_tx_align_payload(struct ath12k_dp *dp, struct sk_buff **pskb);
 void ath12k_dp_tx_release_txbuf(struct ath12k_dp *dp,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de44553..306ab98d28dc 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -13,6 +13,49 @@
 #include "hal.h"
 #include "hal_tx.h"
 
+/*
+ * Convert an encrypted EAPOL frame from native-WiFi format to
+ * the layout expected by the firmware RAW encrypt pipeline:
+ *
+ *   [802.11 hdr][IV (zeroed)][LLC/SNAP][EAPOL payload][ICV (zeroed)]
+ *
+ * mac80211 delivers the frame as [802.11 hdr][LLC/SNAP][EAPOL payload].
+ * The MAC header length is read from the unmodified skb and is safe because
+ * ieee80211_hdrlen() only inspects the 2-byte frame_control field.
+ * pskb_expand_head() is used to grow both head (for the IV) and tail
+ * (for the ICV) in a single call and allocation.
+ */
+static int
+ath12k_wifi7_dp_tx_encap_eapol(struct sk_buff *skb,
+			       struct hal_tx_info *ti,
+			       struct ath12k_skb_cb *skb_cb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	enum hal_encrypt_type enc_type =
+				ath12k_dp_tx_get_encrypt_type(skb_cb->cipher);
+	u16 mac_hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	u8 iv_len = ath12k_dp_tx_crypto_iv_len(enc_type);
+	u8 icv_len = ath12k_dp_tx_crypto_icv_len(enc_type);
+
+	if (pskb_expand_head(skb, iv_len, icv_len, GFP_ATOMIC))
+		return -ENOMEM;
+
+	if (iv_len) {
+		skb_push(skb, iv_len);
+		memmove(skb->data, skb->data + iv_len, mac_hdr_len);
+		memset(skb->data + mac_hdr_len, 0, iv_len);
+	}
+
+	if (icv_len)
+		memset(skb_put(skb, icv_len), 0, icv_len);
+
+	ti->flags0 |= u32_encode_bits(1, HAL_TCL_DATA_CMD_INFO2_TO_FW);
+	ti->encap_type = HAL_TCL_ENCAP_TYPE_RAW;
+	ti->encrypt_type = enc_type;
+
+	return 0;
+}
+
 static void
 ath12k_wifi7_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
 				       struct hal_tx_msdu_ext_desc *tcl_ext_cmd,
@@ -91,6 +134,7 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	u32 iova_mask = dp->hw_params->iova_mask;
 	bool is_diff_encap = false;
 	bool is_null_frame = false;
+	bool eapol_encap_done = false;
 
 	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
 		return -ESHUTDOWN;
@@ -211,9 +255,27 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	case HAL_TCL_ENCAP_TYPE_NATIVE_WIFI:
 		is_null_frame = ieee80211_is_nullfunc(hdr->frame_control);
 		if (ahvif->vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED) {
-			if (skb->protocol == cpu_to_be16(ETH_P_PAE) || is_null_frame)
+			if ((skb->protocol == cpu_to_be16(ETH_P_PAE) &&
+			     !(skb_cb->flags & ATH12K_SKB_CIPHER_SET)) || is_null_frame)
 				is_diff_encap = true;
 
+			if (skb->protocol == cpu_to_be16(ETH_P_PAE) &&
+			    (skb_cb->flags & ATH12K_SKB_CIPHER_SET)) {
+				if (!eapol_encap_done) {
+					ret = ath12k_wifi7_dp_tx_encap_eapol(skb, &ti,
+									     skb_cb);
+					if (ret)
+						goto fail_remove_tx_buf;
+					hdr = (void *)skb->data;
+					eapol_encap_done = true;
+				} else {
+					ti.flags0 |= u32_encode_bits(1,
+							HAL_TCL_DATA_CMD_INFO2_TO_FW);
+					ti.encap_type = HAL_TCL_ENCAP_TYPE_RAW;
+					ti.encrypt_type =
+						ath12k_dp_tx_get_encrypt_type(skb_cb->cipher);
+				}
+			}
 			/* Firmware expects msdu ext descriptor for nwifi/raw packets
 			 * received in ETH mode. Without this, observed tx fail for
 			 * Multicast packets in ETH mode.

base-commit: ca27e3c2284a7a43ba390ed5ce0d68b3c869c0ce
-- 
2.34.1

