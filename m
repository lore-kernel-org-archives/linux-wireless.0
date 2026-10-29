Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793240352;
	b=PP9iMcq0UXLcoqPhuV9tBni1aScQsI4cp3NbQkf69JDdipKKkxn6MTtPo+/T+LoOVaLq
	 QzYTddJM0fUJHkWEnJMhHj3+AvH3brVSOQGnzzrbBEMhqrnUt+ANMWql9ZYVjGozNfwge
	 fwt89d8oBg31fnEIU6WWSI4YOU9jjKAu09S0BcEjL9vZ0RSvVkzL2cdhAC+J8d9pQPD1j
	 i8pKKdAR5etXejVxyj7j5kw3dXcRYgt/ebrHkPVLB8umOYFNK1sZ+2C0juckmLk8tRtzb
	 OLuJhJ/LQhfgFriU90JL5r3HAUQpYT/nTG76mwN+dWaGUReuBs0ZdtjHMDRRVep52Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240352;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=vZAdjot7kyn4ieMPLUMNEq4Jit4LKlTnRhG4vJxE5P8=;
	b=czWhAlSOcZQLQGl/OAmCQjw7f5LpNqlB4cUrTlsxijVZRZgtAlTGvtlS0BrxC+SAd5Ok
	 vmffCsiI7OrVTcTugnX0TYnKfq3uHPx9i1O4RLHIdSi0ZcvxW+RgHrFT9TXZZCOXWpLgx
	 F4egT5sMO4Fa8gAYCIIm4TBMyw14OZ/nuTnipOTmfuApYHOEPC1M3rwW+seedZDkNh3ko
	 0vg2lu5CATmnepI4v/Hi40Bd1s3jXrY6eqY+VpiVSk6V/TCl7tzJAIkBn4XOO+/tHc8jc
	 VU5fj2x4XuGg+IegVYfSMC+QNOO52yIv6q86s1+mgdWbCitmFk/mOYH6eRHSsfxn0Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XLwUyt+r;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="aYKPa/5O";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D694606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 02:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D694606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XLwUyt+r;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aYKPa/5O
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T1jNm82827626
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 02:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=vZAdjot7kyn4ieMPLUMNEq
	4Jit4LKlTnRhG4vJxE5P8=; b=XLwUyt+r96ctxW9+/lYHeJhVHOvxyWSy5xYcGC
	81o6cYN1/R2XaGdBIELXXl32hz5QwHDYJRShKhhmMJO5tAgNGFzxQkzUlbP+LlMc
	e1F0en38f5XcgY6A4vKD82kjpqwhRzywHcAbYm+R6WguGLPJ8S/rFFETA6s+EF5z
	cgmZVOTXlGhRyds8Vlv+UYKE+9hJfNMTbqjl6pwZk3HXWOx3Tuv5l7otRV2RsBcP
	5mrHEJp2QMwsi23TUEstRxAwHrwus8WajoN5D+cWlLa1A/XHvJwOuRlEIIhhgx2i
	SSSVJXdyy1V68qZfw/W1YzZ2N+OhHbQVnOhlAl9Fljb5SnoA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkpgpsf0k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 02:19:10 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e93f67358eso15484375ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 19:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793240350; x=1793845150; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vZAdjot7kyn4ieMPLUMNEq4Jit4LKlTnRhG4vJxE5P8=;
        b=aYKPa/5OFPyznbLIBLGEDtJxntE6AQyWgN1r1YyiwPlx6fdrNHWg/KNlfj0+O5t+nn
         n5lnsUxUExgAE+jqJ/yMNN9hJ7jyPVsUDT0pteHefwM/OvWKn6TIRxtT4oha3lZuRCzx
         w74Nw/ZzfcfBOdl0V3DyLiWZmAkeAnJZRkiv3byUMoRT8oOaXL+u1W9VWwIxMLcFCU11
         mFlXc10dlk1M/4mIxN4gzkJp1ZkCd+ghM72ibB8RqIzIqOZuyz4LOz00zKcWFzgIRQM5
         KE/8MAo44Y1WtSbBw6AFKuyCz8Anq6zW0I5HknAms7DWiZ0z7nf2Rg2BwYQzvJwnz3aR
         xnbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793240350; x=1793845150;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vZAdjot7kyn4ieMPLUMNEq4Jit4LKlTnRhG4vJxE5P8=;
        b=n+rYxog/Dt8AKd4zb2UBUOdkSQ+7MFTNZdrMBSj7Onxvy6hOWIzlkWd4TT9OXvJwVl
         hsCWnrTl6Km0NfT5nSyI9a6pekePSOIafqthuie0s2TW5H9ut8Vte7AEmLjxAUjAwXKr
         XSsKz81bW7UBACZ6SfacKkGYQhMn36cyWyHf5uwkGHV5VoBrV8eTO5Sd1M7ShMx9NaHu
         gl7Xay0+vZMiOSVjxaSjLNbGgm6NI2p6xdwdIDiX/iTQ+N7yFt5o6k73Na4PFftXhq5/
         EjBptiAiiX0Zb9DP4fBHmEaFz3b94v4wctIUpSQM9NCpREGmUdohIz6eUzcI8Ohh3FKN
         fsGw==
X-Gm-Message-State: AFq9FYLGAaCKh6djm+IO5hbrXf/2nDWDyVjLH44VqfuEo23tCJCvxB9M
	Jwvo8KQc04a/kM9Io9Kkxl9d7XvHo0TvT+NboEE2NWuQuMxawaoCf88EwsAWBOGXDwuhrOkWj9U
	5bPR5q//xnohZFFABz7CwfMyLflTsEt24+jdK7xJVMz3RF6PGM8K55bJc08tCTmeEg6ex/il3bA
	yqdg==
X-Gm-Gg: AYBFou1ofhdFbTT6jMc3+YjeJ8HpKg2UuojW2w1ZReXyXT62280Yq8aEIdF/cTNVIW6
	rWzK8bbACiGNNc3F2U4niZ/E2f+TLXySXwrCBh47zxyxfrmW06rifo3vm2yNK/lHpVEQyLLLlbz
	9kMwCWo36RuGCsUvr3Wbg5VUDSLmX4UJkqka62JzpljPZ3kofuIRghxLpH9nSbGdmslMJmrAS/B
	+3i8l0EOVHduqcicwQsPEJET+VpB8auPCgaFNo/diwl06aHu9WmBuAQWROZaVocutsuMDXQao3B
	pRec7bvCOlrd5OxKgJUwTYxUq1Rq1dfsMR+qQ5btk0mf5mYTGNi2gS2X9SACaG4jMLWXfsS0Jnb
	zwr9FZs9Rh2zmx23Yx+1iDObJJOvLDYhOyDHUA7LQCULZhm6BEbIePiUdTbCsXWkpqefc0M8YsC
	FeFgogRQzbGYKS7QQQFyRfxakyCmf0Ag==
X-Received: by 2002:a17:902:da85:b0:2e5:6158:b9c1 with SMTP id d9443c01a7336-2eb00468987mr37161365ad.47.1793240349604;
        Wed, 28 Oct 2026 19:19:09 -0700 (PDT)
X-Received: by 2002:a17:902:da85:b0:2e5:6158:b9c1 with SMTP id d9443c01a7336-2eb00468987mr37161195ad.47.1793240348983;
        Wed, 28 Oct 2026 19:19:08 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eaf77e70d5sm20571665ad.75.2026.10.28.19.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 19:19:08 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 10:18:42 +0800
Subject: [PATCH ath-current] wifi: ath12k: don't advertise EHT-MCS15 to
 firmware unless we support it
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-ath12k-mcs15-v1-1-3bcfab101f00@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAGt4moC/33NTQ6CMBAF4KuQWVvClGLRlfcwLkp/pFFabaHRE
 O5u0zVxM8nLvPlmhaiD1RHO1QpBJxutdzngoQI5CnfXxKqcgTb0iA1tiZhHpA8yyYgd6bEfWtF
 x1mML+eQVtLGfwl0hN4lcQtBuhltejjbOPnzLq4Slsq8mJEi4FFpwFMwwevEx1u9FPKWfpjqP4
 iX6z6DZGAbDlFL8ZBq2Y2zb9gOaWB0eAAEAAA==
X-Change-ID: 20261023-ath12k-mcs15-818b3a574813
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Vladimir Petrzhikovskii <vladimir@dfb.sh>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAwOCBTYWx0ZWRfX4r+lxfKBIz3F
 qLQ48Iy4pEJtcjss0Hafeg9Lvp9cJA0M/VzNgB1t3Q92KP4wx+v7rrxgxlR1nZGoKrJ3Ol8Z+aF
 ZhfS/TBLV1sDKBsj+BFVO1GROxEeGaEz33k2oA8vBAWFdAxmmKjJom4ZKeSkVnhqdaV2Yt4yZlY
 uRrvJLREwecA1ZLgGaJZELuFWPbFdYkq0GP7afRt31lruLGYgP944WYQh+VU+lZ8+ZFDlj4/4zo
 2aKjGguZfQ/gcaDzRmDsPFr2U23G7TZJ+SviViNr1AJvaycbnCuzy7sHsqOjLWr2lYE2QR3XMAO
 aC/vjIlvWXlIQYcVZRNjQmVB34+S27MVP6Ug8Pjz/kbS4H522+nM+PMc8aob2d5WfijWkqMhzUY
 fKLgHmdLqTEl2sJkkfX9l3YXXcOllwivF80KFUNSQ2SPNoHWAsaZjxhqdijOgUBiQMe+QIvl38K
 FIhMNS802muF5Dgpa2w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAwOCBTYWx0ZWRfX9X/h2Uv9l9Oj
 pe3aftLAz2ULJEojFMIrdKwP/DM/bW2JZlcoHTOb+vaQKnEaDlOKAEcJF2gIsht+yEKKg6YZLqW
 yJLlLF3HnyrAWKTBTsMS8UuctYpnjRw=
X-Proofpoint-ORIG-GUID: TGnrCCI9LBfb1TPPkrO8XTZggIMOLwYD
X-Proofpoint-GUID: TGnrCCI9LBfb1TPPkrO8XTZggIMOLwYD
X-Authority-Analysis: v=2.4 cv=T4oZ3PKQ c=1 sm=1 tr=0 ts=6ae2ad1e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=JOAUSjMvcfAEtdXySEUA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290008

ath12k_peer_assoc_h_eht() copies the peer's EHT PHY capabilities into
the WMI peer assoc command as is, including the EHT-MCS15 support bits.
Firmware rate control enables EHT-MCS15 for TX whenever those bits are
set, without checking whether the local PHY supports MCS15.

Currently WCN7850 firmware does not support EHT-MCS15 for TX and does
not advertise it in its own EHT PHY capabilities. When connected to an
AP that advertises MCS15 support, rate control may still select
EHT-MCS15, and every PPDU at that rate is aborted by the PHY before it
goes on the air. TX then stops for minutes while the association stays
up, and frames sit in the queue until the firmware releases them as aged.

Keep only the peer's MCS15 support bits that we also support ourselves
to fix it. Chips that support MCS15 are not affected.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 17bbb8aa74fd ("wifi: ath12k: prepare EHT peer assoc parameters")
Reported-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222136
Tested-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..8f37ec6af6d3 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3366,6 +3366,7 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 	u32 *rx_mcs, *tx_mcs;
 	u16 *eht_mcs_mask;
 	u8 max_nss = 0;
+	u8 mcs15;
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -3416,6 +3417,16 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 	memcpy(arg->peer_eht_cap_phy, eht_cap->eht_cap_elem.phy_cap_info,
 	       sizeof(eht_cap->eht_cap_elem.phy_cap_info));
 
+	/*
+	 * Firmware rate control enables EHT-MCS15 based only on the peer's
+	 * MCS15 support bits, so keep only the ones we support ourselves.
+	 */
+	mcs15 = u8_get_bits(eht_cap->eht_cap_elem.phy_cap_info[6] &
+			    own_eht_cap->eht_cap_elem.phy_cap_info[6],
+			    IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
+	u8p_replace_bits(&((u8 *)arg->peer_eht_cap_phy)[6], mcs15,
+			 IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
+
 	rx_mcs = arg->peer_eht_rx_mcs_set;
 	tx_mcs = arg->peer_eht_tx_mcs_set;
 

---
base-commit: fab2e70afb13485ea4b198b204af33dd15b8132c
change-id: 20261023-ath12k-mcs15-818b3a574813

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

