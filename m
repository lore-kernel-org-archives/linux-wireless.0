Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BF851DAF0
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898209; cv=none; b=S7vFVCJkt84zXkeA3mHTiYIMPGmV+6czoo/EdMeqY/c4tdXQeDkFSEH6ynnIYc/kdAla9KBpV7zGo7Ftp+9PnGTBh3bS8NEhz1GotZ/J4KbZXPDeC+X7BBzU1zlr4P/1ieXEBAUGe0a5xKnoDJ8gxmH6ZgeG8P2aoqrdQlQJ7a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898209; c=relaxed/simple;
	bh=CBHrOjtosL4C3j20I+KTOfSXneyHt1K7dtephsuuY6E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YBIRUy6hnu1T0Bu1ZLCGbMySUnriwmXAn0ALDrDQGssxpiz4Y0JI4QUil/mU2lkYZvHAdPIipstlYakMSaqoT6AHg0QttNsGvL7dAURlQGUCJG2YqITG1uD7esecP29cAt7ziyc5EQ1PBNmkesMZjVu+1B1gWYQw/e1Defptcoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=coGzJh7V; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K1OYGK73; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="coGzJh7V";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K1OYGK73"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D9ssSK174333
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=p9ShrRG5zS8l+PwwehzQXg
	IOF7eyLATLXxjmQkLn458=; b=coGzJh7VyRjliMXmDiCyBWXe0fFuMJNDPZhFJ9
	pTtmUXjhfp2Aa5tfUKKq2ypJdJqa9+7yZ8//uBbDrXC7n2mf26C5JuuNsK0+tOsO
	ZUMEc7a5QaNTkZHTT6/iql48NLAmmfdf7LePSH4rBRiqovANRAfsso9iuiaSHKD/
	RiQ/KnYbESrVzO6kj8jjIy5dd1DanjRXaZy4j8aorV9tYoUQAOIicVIZjthQxFET
	ZGdazM8MKyLO2ltOaDgBSu0JUddWIOvIMVdU0tz2dqr0hGzcszNO2Z/5/8MFQLZe
	zNDJTPl34Ny8rGDhrjUtLsMHEifQrS7KrQKF+tXBujrPTGow==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9daqt7ky-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:30:06 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93cb98809caso533086585a.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 06:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791898205; x=1792503005; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=p9ShrRG5zS8l+PwwehzQXgIOF7eyLATLXxjmQkLn458=;
        b=K1OYGK730vhUbrnUgJDVH7+N4RAZ/14vnohU2ktMUlSt8BYqgfJRB27pB/m1FrMfcd
         EF9KuhW4pRnG+0DjULXCy1pC8pKwwm0+yf9VddQk9I+Dsc4rtZscSh28Q9Ct4rKlTCug
         vc/sC0JU5oZG9hdGUEQYry6Q+53hAYhzXZQZMZh8nhvjMie45DvLURdzhBt7Dn1xbD9f
         ujS5zN/Zftc2cJTAkYKYL41+hx3B4teHZnGWdEePgK5z1g1a/CKywIVQBL5YAmvU02oW
         zReXFFh/4lClRWe/2llwRU6xnThWgNVCCfxMLMdapSr+4/knkIsfbF8Y5tbZ+iW57U4/
         zmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791898205; x=1792503005;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=p9ShrRG5zS8l+PwwehzQXgIOF7eyLATLXxjmQkLn458=;
        b=Fgm6+KmGjxFsqRibyquEWPdJ3oeZkZ7ZC7IMUje3zTxpJ6OD3zI+aGPunQ47imsH/E
         IBlIJBv/wFfIkpKDY18oVLtDD3z3J979ryh/9qk/ZRhZhJ5VQ3o6rJbCGQ2iE91ls4B2
         noAPrzD/Y6NO5zNLoJ1yuqijk6HFWi4jkWEdYX4HJVs+vDgomg17FcI9/R2xWjDuHB5o
         K9bq0Ba5gMjLpmt4z5rfCBIsRA0S/ofC8gkl0OsCEcUItlBwfPNR/ooF5XeN3vvOD7ni
         oJggrWaPL3ADsFmKzOORw8C5HE8LT0yJPb4x6xIGpfXeFdfUwQY98bRxtPGykbMiBtPS
         LBbg==
X-Forwarded-Encrypted: i=1; AKwUvByFxHcQMrO1mIuKRoEVZVx9QdCQDOATHRHBYAIcGMEhhN4fVJvOME8srZCnB1nKnRzLp6DGyfM7bHqlemEwRQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL/M+wwqpMFHmjeZI84xSWku3BrEmk4htQpKCV/cMzbQbZQ0r1h
	1TwMQZLDtE5WfzMgMx57aJgK36kU+oSRRnAaxvJauv//sVW/48kY4cjzypWWrSFwRsNgE1fklaV
	2qaecnCYWsKyWap0Mr1LbF/iZAXMmkPhG/zpejNbVuZZWnLXW6LN4db8Q8J+Olw3FB3CwJA==
X-Gm-Gg: AYBFou1jBEL7z2GdT6U+LDRYabycquJS/KOffIxqAGA4Xcl3I+V9N9YPKD8MGaoFGD5
	og13V6BPxRBGoMf05inlsu0lpUCKL+VGWjD37ge3nW3uU6Gja2qydTvfeRh/byNvj0IoDJEKBL+
	oAojZ8vPAjWUDqKEAM+LFP0C4ZWZph1G4B3GCiDRNcoLMy3LDnbYqem2BOKTsnYeftS065jfaK0
	VME9EUF4saEYTTsLpzcpgV041b9XllUF6R//HpimpijNYYJWgbM4cO06wx4HOuHnY5PTf0d/kz2
	g+as6XX1sFb5oijMYNpCP2gj+984KDhAfMuNJodH/I7/e+n3arh6uSWGBVkqyF3bDE5jAd1OKSI
	MQf+ImKeMKvqjmg==
X-Received: by 2002:a05:620a:6cc3:b0:93e:f4f4:346 with SMTP id af79cd13be357-93ef4f405e9mr434851785a.39.1791898204439;
        Tue, 13 Oct 2026 06:30:04 -0700 (PDT)
X-Received: by 2002:a05:620a:6cc3:b0:93e:f4f4:346 with SMTP id af79cd13be357-93ef4f405e9mr434843585a.39.1791898203625;
        Tue, 13 Oct 2026 06:30:03 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de09693c7sm6386843f8f.4.2026.10.13.06.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 06:30:02 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 15:29:41 +0200
Subject: [PATCH ath-current] wifi: ath12k: fix decap of MSDUs spanning
 multiple RX buffers
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-ath12k-fix-descap-multiple-rx-buf-v1-1-5f3a10c4d8b7@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQrCMBBFr1Jm7UASaVGvIi7SZGIHawyTRAqld
 3dw+eC//3aoJEwVbsMOQl+u/MkK9jRAWHx+EnJUBmfcZI09o2+LdS9MvGGkGnzBd18bl5VQNpx
 7wjRe5itNZoyOQH+KkK7/jTuojqGLUG7wOI4fJ4+Du4AAAAA=
X-Change-ID: 20261013-ath12k-fix-descap-multiple-rx-buf-f58b9e605d2e
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 6zZjarNrQetQO2LyCwdp7Slv4TuxuNnE
X-Authority-Analysis: v=2.4 cv=FZuiV5+6 c=1 sm=1 tr=0 ts=6ace325e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=30pSA2KbGxZrRlviRsUA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA1MyBTYWx0ZWRfX9sepYVbbea4P
 wNli+zrm+7dR4Dl+qagBtYSfAsACOCMtRsaXJtG6vaftDDfD0xBKQDxdWO8B2IE3Ng4oGwLCVji
 e1MtI6hQcPTRoDATGvuWoKfv/1g1PRY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA1MyBTYWx0ZWRfX/ss7/7ALB5z8
 s+sgGe2QhZjgHADmdT9oLRKHDxmcz32KBQOv9bZ+bShElxixnmDDB0o/Yzd+4GLd9OI0gIiupBR
 RRzuM+em4Xk1d68m6PImRyecbGQETkCdMoNS25NCbfUMpfTv01gjqARvaFUUOporx+C1cwELFtU
 GlpDiug8ei51Fb3tjjVsyyxqSvICNF4tTANbsp5k5hhygvlexLUNbKwnF2BMsB1lHRxyJ7slSa/
 AkVx6xXQttqJK99e/yrEj9al3enXXizNLSVVHRBih7hI2ovdcVj9xc69NXEHnaSDX7ZSqiHJuin
 39OP9Xp3qUEI+eNScGEAHPOpIuYd2BLUuUfY6rmwyuhKU5wAEXUGnkihBoDH3kfOQ95H25zrvV1
 P5h12CFt6tZG5geKniPPEqY6qdJE6x5dJ2zZJutqAZl1p190ImY02FbGVUJDdCuyBy+7Mj3HpRT
 5ZIvZlT+24VC6xy1ZTg==
X-Proofpoint-ORIG-GUID: 6zZjarNrQetQO2LyCwdp7Slv4TuxuNnE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130053

When a MSDU is split across multiple RX buffers, the msdu_end TLV is
populated only in the last buffer. Since commit e8a1e49c6328
("wifi: ath12k: Add new infra for the rx path"), the RX info
extraction in ath12k_hal_extract_rx_desc_data_*() helpers runs before
the MSDU is coalesced, so the msdu_end-derived fields (decap_type,
mesh_ctrl_present, is_from_ds, is_to_ds, is_mcbc, is_decrypted, sgi,
rate_mcs, bw, phy_meta_data, pkt_type, nss, checksum flags and
err_bitmap) were read from the first buffer, where that TLV is not
valid.

As a result decap_type was reported as DP_RX_DECAP_TYPE_RAW and the
frame was handed to mac80211 with a raw 802.11 header instead of being
converted to an ethernet frame, breaking reception of any frame larger
than the single RX buffer.

Fix it by parsing the msdu_end fields from the last buffer (ldesc) in
ath12k_hal_extract_rx_desc_data_{wcn7850,qcn9274,qcc2072}(), keeping the
mpdu_start fields (enctype, seq_no, peer_id, tid, addr2) on the first
buffer (rx_desc). For single-buffer MSDUs rx_desc and ldesc point to the
same descriptor so the behavior is unchanged.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: e8a1e49c6328 ("wifi: ath12k: Add new infra for the rx path")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    | 30 ++++++++++----------
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    | 32 +++++++++++-----------
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    | 30 ++++++++++----------
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
index 7cf00fda996f..7ea7559e882c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
@@ -402,32 +402,32 @@ static void ath12k_hal_extract_rx_desc_data_qcc2072(struct hal_rx_desc_data *rx_
 	rx_desc_data->is_last_msdu = ath12k_hal_rx_desc_get_last_msdu_qcc2072(ldesc);
 	rx_desc_data->l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_qcc2072(ldesc);
 	rx_desc_data->enctype = ath12k_hal_rx_desc_get_encrypt_type_qcc2072(rx_desc);
-	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcc2072(rx_desc);
+	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcc2072(ldesc);
 	rx_desc_data->mesh_ctrl_present =
-				ath12k_hal_rx_desc_get_mesh_ctl_qcc2072(rx_desc);
+				ath12k_hal_rx_desc_get_mesh_ctl_qcc2072(ldesc);
 	rx_desc_data->seq_ctl_valid =
 				ath12k_hal_rx_desc_get_mpdu_seq_ctl_vld_qcc2072(rx_desc);
 	rx_desc_data->fc_valid = ath12k_hal_rx_desc_get_mpdu_fc_valid_qcc2072(rx_desc);
 	rx_desc_data->seq_no = ath12k_hal_rx_desc_get_mpdu_start_seq_no_qcc2072(rx_desc);
 	rx_desc_data->msdu_len = ath12k_hal_rx_desc_get_msdu_len_qcc2072(ldesc);
-	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcc2072(rx_desc);
-	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcc2072(rx_desc);
-	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcc2072(rx_desc);
-	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcc2072(rx_desc);
-	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcc2072(rx_desc);
-	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcc2072(rx_desc);
-	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcc2072(rx_desc);
-	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcc2072(rx_desc));
+	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcc2072(ldesc);
+	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcc2072(ldesc);
+	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcc2072(ldesc);
+	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcc2072(ldesc);
+	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcc2072(ldesc);
+	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcc2072(ldesc);
+	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcc2072(ldesc);
+	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcc2072(ldesc));
 	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_qcc2072(rx_desc);
 	rx_desc_data->peer_id = ath12k_hal_rx_desc_get_mpdu_peer_id_qcc2072(rx_desc);
 	rx_desc_data->addr2_present = ath12k_hal_rx_desc_mac_addr2_valid_qcc2072(rx_desc);
 	rx_desc_data->addr2 = ath12k_hal_rx_desc_mpdu_start_addr2_qcc2072(rx_desc);
-	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcc2072(rx_desc);
+	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcc2072(ldesc);
 	rx_desc_data->msdu_done = ath12k_hal_rx_h_msdu_done_qcc2072(ldesc);
-	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcc2072(rx_desc);
-	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcc2072(rx_desc);
-	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcc2072(rx_desc);
-	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcc2072(rx_desc);
+	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcc2072(ldesc);
+	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcc2072(ldesc);
+	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcc2072(ldesc);
+	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcc2072(ldesc);
 }
 
 static int ath12k_hal_srng_create_config_qcc2072(struct ath12k_hal *hal)
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
index 052b59265af8..355cf50d2785 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
@@ -922,32 +922,32 @@ void ath12k_hal_extract_rx_desc_data_qcn9274(struct hal_rx_desc_data *rx_desc_da
 	rx_desc_data->is_last_msdu = ath12k_hal_rx_desc_get_last_msdu_qcn9274(ldesc);
 	rx_desc_data->l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_qcn9274(ldesc);
 	rx_desc_data->enctype = ath12k_hal_rx_desc_get_encrypt_type_qcn9274(rx_desc);
-	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcn9274(rx_desc);
+	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_qcn9274(ldesc);
 	rx_desc_data->mesh_ctrl_present =
-		ath12k_hal_rx_desc_get_mesh_ctl_qcn9274(rx_desc);
+		ath12k_hal_rx_desc_get_mesh_ctl_qcn9274(ldesc);
 	rx_desc_data->seq_ctl_valid =
 		ath12k_hal_rx_desc_get_mpdu_seq_ctl_vld_qcn9274(rx_desc);
 	rx_desc_data->fc_valid = ath12k_hal_rx_desc_get_mpdu_fc_valid_qcn9274(rx_desc);
-	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcn9274(rx_desc);
-	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcn9274(rx_desc);
+	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_qcn9274(ldesc);
+	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_qcn9274(ldesc);
 	rx_desc_data->seq_no = ath12k_hal_rx_desc_get_mpdu_start_seq_no_qcn9274(rx_desc);
 	rx_desc_data->msdu_len = ath12k_hal_rx_desc_get_msdu_len_qcn9274(ldesc);
-	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcn9274(rx_desc);
-	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcn9274(rx_desc);
-	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcn9274(rx_desc);
-	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcn9274(rx_desc);
-	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcn9274(rx_desc);
-	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcn9274(rx_desc));
-	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_qcn9274(rx_desc);
+	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_qcn9274(ldesc);
+	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_qcn9274(ldesc);
+	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_qcn9274(ldesc);
+	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_qcn9274(ldesc);
+	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_qcn9274(ldesc);
+	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_qcn9274(ldesc));
+	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_qcn9274(ldesc);
 	rx_desc_data->peer_id = ath12k_hal_rx_desc_get_mpdu_peer_id_qcn9274(rx_desc);
 	rx_desc_data->addr2_present = ath12k_hal_rx_desc_mac_addr2_valid_qcn9274(rx_desc);
 	rx_desc_data->addr2 = ath12k_hal_rx_desc_mpdu_start_addr2_qcn9274(rx_desc);
-	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcn9274(rx_desc);
+	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_qcn9274(ldesc);
 	rx_desc_data->msdu_done = ath12k_hal_rx_h_msdu_done_qcn9274(ldesc);
-	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcn9274(rx_desc);
-	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcn9274(rx_desc);
-	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcn9274(rx_desc);
-	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcn9274(rx_desc);
+	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_qcn9274(ldesc);
+	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_qcn9274(ldesc);
+	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_qcn9274(ldesc);
+	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_qcn9274(ldesc);
 }
 
 static u16 ath12k_hal_reo_status_dec_tlv_hdr_qcn9274(void *tlv, void **desc)
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
index 61be8443e46e..abe982faeb2b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
@@ -604,32 +604,32 @@ void ath12k_hal_extract_rx_desc_data_wcn7850(struct hal_rx_desc_data *rx_desc_da
 	rx_desc_data->is_last_msdu = ath12k_hal_rx_desc_get_last_msdu_wcn7850(ldesc);
 	rx_desc_data->l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_wcn7850(ldesc);
 	rx_desc_data->enctype = ath12k_hal_rx_desc_get_encrypt_type_wcn7850(rx_desc);
-	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_wcn7850(rx_desc);
+	rx_desc_data->decap_type = ath12k_hal_rx_desc_get_decap_type_wcn7850(ldesc);
 	rx_desc_data->mesh_ctrl_present =
-		ath12k_hal_rx_desc_get_mesh_ctl_wcn7850(rx_desc);
+		ath12k_hal_rx_desc_get_mesh_ctl_wcn7850(ldesc);
 	rx_desc_data->seq_ctl_valid =
 		ath12k_hal_rx_desc_get_mpdu_seq_ctl_vld_wcn7850(rx_desc);
 	rx_desc_data->fc_valid = ath12k_hal_rx_desc_get_mpdu_fc_valid_wcn7850(rx_desc);
 	rx_desc_data->seq_no = ath12k_hal_rx_desc_get_mpdu_start_seq_no_wcn7850(rx_desc);
 	rx_desc_data->msdu_len = ath12k_hal_rx_desc_get_msdu_len_wcn7850(ldesc);
-	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_wcn7850(rx_desc);
-	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_wcn7850(rx_desc);
-	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_wcn7850(rx_desc);
-	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_wcn7850(rx_desc);
-	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_wcn7850(rx_desc);
-	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_wcn7850(rx_desc);
-	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_wcn7850(rx_desc);
-	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_wcn7850(rx_desc));
+	rx_desc_data->sgi = ath12k_hal_rx_desc_get_msdu_sgi_wcn7850(ldesc);
+	rx_desc_data->is_from_ds = ath12k_wifi7_hal_rx_h_from_ds_wcn7850(ldesc);
+	rx_desc_data->is_to_ds = ath12k_wifi7_hal_rx_h_to_ds_wcn7850(ldesc);
+	rx_desc_data->rate_mcs = ath12k_hal_rx_desc_get_msdu_rate_mcs_wcn7850(ldesc);
+	rx_desc_data->bw = ath12k_hal_rx_desc_get_msdu_rx_bw_wcn7850(ldesc);
+	rx_desc_data->phy_meta_data = ath12k_hal_rx_desc_get_msdu_freq_wcn7850(ldesc);
+	rx_desc_data->pkt_type = ath12k_hal_rx_desc_get_msdu_pkt_type_wcn7850(ldesc);
+	rx_desc_data->nss = hweight8(ath12k_hal_rx_desc_get_msdu_nss_wcn7850(ldesc));
 	rx_desc_data->tid = ath12k_hal_rx_desc_get_mpdu_tid_wcn7850(rx_desc);
 	rx_desc_data->peer_id = ath12k_hal_rx_desc_get_mpdu_peer_id_wcn7850(rx_desc);
 	rx_desc_data->addr2_present = ath12k_hal_rx_desc_mac_addr2_valid_wcn7850(rx_desc);
 	rx_desc_data->addr2 = ath12k_hal_rx_desc_mpdu_start_addr2_wcn7850(rx_desc);
-	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_wcn7850(rx_desc);
+	rx_desc_data->is_mcbc = ath12k_hal_rx_desc_is_da_mcbc_wcn7850(ldesc);
 	rx_desc_data->msdu_done = ath12k_hal_rx_h_msdu_done_wcn7850(ldesc);
-	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_wcn7850(rx_desc);
-	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_wcn7850(rx_desc);
-	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_wcn7850(rx_desc);
-	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_wcn7850(rx_desc);
+	rx_desc_data->l4_csum_fail = ath12k_hal_rx_h_l4_cksum_fail_wcn7850(ldesc);
+	rx_desc_data->ip_csum_fail = ath12k_hal_rx_h_ip_cksum_fail_wcn7850(ldesc);
+	rx_desc_data->is_decrypted = ath12k_hal_rx_h_is_decrypted_wcn7850(ldesc);
+	rx_desc_data->err_bitmap = ath12k_hal_rx_h_mpdu_err_wcn7850(ldesc);
 }
 
 int ath12k_hal_srng_create_config_wcn7850(struct ath12k_hal *hal)

---
base-commit: 08a3f02fea636e97a7422d1512f76dacdb5b0887
change-id: 20261013-ath12k-fix-descap-multiple-rx-buf-f58b9e605d2e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

