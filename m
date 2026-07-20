Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72533AFD00
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529824; cv=none; b=Fk6hO7OKGx4dIIX4xl0JeuzOXn33ofloT6OpZN+xJM64O4bglRMRGLyUX3NkV8lLuJJ6pQj5o3+vsI9t85IOE0Jun0dXKDYYU2w8rxD5njz6sJfRN9IJemRyP8QDJA5AQxLe3uvrGiRJOQUwzN7BVjtfDsAOyNF0K9XcvjdT6Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529824; c=relaxed/simple;
	bh=gAuC4zkk7XPgmt0x0ghBLSxFVZuQbI21SeQVlMc6fV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kAZ1B97T6MMoG2BGlKfukmVHP4HNbHZfoQ0hJ/i3dMBq2rEDf4vaolOSzDrc/wCVZj7iWX4Nze653sBSNmo8fxLVYm83JDRfSaR4nVkx0Sn/LhBJWC4cqW1JV//PMvtEukH1pBdMgrFUUxVazR2HLXGxY1lnXQeSmdTTepGR4kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S1RWYam7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e2oPRUyN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S1RWYam7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e2oPRUyN"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6Rr8s1263334
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aifJCenv1UQ5W+pu7DOQPFIw6v/9P9JnLq1j9kinOIE=; b=S1RWYam7TLFlME7d
	SL/KhYAJ3zzB7qL+bVkpwyrjnBgFyW/gfrW2bKgiCdp6oLYa+WNAiCDKL4e3Cl+7
	Mdm+tnIOhpbUO60sF6cyeVD1yhmcitqj3GOvRTmVv1vy/uZ+cfnbKVv/1Vx9KAOd
	zwj4JJlcvPCfzkjkstNhqEsUYvgwuntl4cvKDrusm2d05bvfSrwKEN+H4PyPo26S
	9QkHW726DNXHp1XwpViWXIhfSEe07BJGVKK69V+zSxRFWoQs0hlPTeaepwzdTfr+
	J7U3XI2wNYVayIcbiyu3Un4Vq2cav8abpHVTWAItiXHVhZsL8r4+siDeqc3fCas8
	ACkpAw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2nhms4v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:40 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84842381150so17346728b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529820; x=1785134620; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aifJCenv1UQ5W+pu7DOQPFIw6v/9P9JnLq1j9kinOIE=;
        b=e2oPRUyN5SUeNWlAsZb82yt5QfOER2uVq0tKXCAoToWZdD8Ipz4By29iPw/0jl/80D
         k/uIhtG2d0tf6by+cEgq9n8yhuCwkdJMOUrrypqf19ls0ejza2oSA/jbwsDbfN2ZOgik
         deL0wT7qrdq5dklm5PbGAsK7Yk0DBJMbCpXh59f0y8E7j1C5sxrJjy6pGEf+AZTeX48v
         3sGzJJPW/flv2f1/rnLlfEM0XpeybMuAvEMS4poCEgcfB+ebEEyS53lnredDGaV3G5S0
         OHvTQZcexBMAQVNP3DSCLdnLrnViXCDvtAt1vlcpcKhsfpYRKGl/wt2qXEORKyHqPrfY
         gBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529820; x=1785134620;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aifJCenv1UQ5W+pu7DOQPFIw6v/9P9JnLq1j9kinOIE=;
        b=Qf1IB13uekusFtvdptFfHoxtIIuBTqaaetzrNEV9rQghCDjFNOauZFmy7WBMH7PSRS
         q4iJCEzRaDtdPZ85nbTwG1FNd7M5yZhpGeg6gAybFbpzittSjZAHC1XEjkvcKdbidxPl
         hnvXrhXyxk4wDk7MDwqqiAAl+NvUeynpid/3OQfEWtgDG2h5SYBepllQwdennolBMAKI
         bpsL+CfQpwLfJGlP3w1k23yuWnb+FtfGwtYeSvwYZxm2pqLDj/Ai9+XnBFYgHdwMKoe5
         0E3sKfuvAp/zDuXCzp/Dx9q3mL6eLGgLtRSzuZIGf4XaW2+WMW8rP+8lpJKSfpazAqQz
         xFIQ==
X-Gm-Message-State: AOJu0YwU5jJ0JZYb2jfxPY0VtDya1afl9TOAJdbukp5RljnGzjOdWShs
	dWgwIg/c7ZDzjPLDmxBa537nuGoVaKxFh3CJtWVeYexlMzdMgYhpvlK2gRKlwRTTVKoS02ywzT2
	MPw5240PxXzpDOWjkgXyBMn605V4qiU3jg6NONlC35eZRfcY/Ftnj2E8/onC+swiOiJAelg==
X-Gm-Gg: AfdE7clQZhDvb9OAkaFFQUIoZaY/uqokJePW16FiQnCLmNADke91z1dPZJDFnz9P0io
	5rvAfFAsgFfrpsZU5HMdAlyEqkvmU0No2cxreb8Db4kY59bh0hryGjMXMINMyk64kRT0450xDO9
	acd5J0iTXBb1Uqauh6eCYf+ngS9yus+Qn/rsknt4NxWlXuH3ES7J7zmQelsLy/oz9CkSWEv3N/r
	4srHP/sJjdRQ+87kll9qll9Ve/Asj2RXWBF+GsALD37k3DV4brkll+56Tts+GXp++fdwKLuHvtE
	Cpm4pEcax+aDHDjBUVPk0+0AFMx3v6AbgdVQmJTNmi+k9kRfK0sfg8FOJBldx9dWS8alG64Chhp
	5CODjlUYsvrve5JcwC+sKpBkgFpAAlKT1xCKbR6KakDeD+LQ9k7bTOQ==
X-Received: by 2002:a05:6a00:2e2a:b0:847:95a6:eb74 with SMTP id d2e1a72fcca58-84c2930f035mr13158121b3a.23.1784529819833;
        Sun, 19 Jul 2026 23:43:39 -0700 (PDT)
X-Received: by 2002:a05:6a00:2e2a:b0:847:95a6:eb74 with SMTP id d2e1a72fcca58-84c2930f035mr13158104b3a.23.1784529819364;
        Sun, 19 Jul 2026 23:43:39 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:37 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:25 +0800
Subject: [PATCH ath-current v2 4/8] wifi: ath12k: add support for
 HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-4-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=Le0MLDfi c=1 sm=1 tr=0 ts=6a5dc39c cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=Z1Ge9yWUdzOQbrqXt3cA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: hhJES_FEz9_0g2ZuNq76hD1fDHbot-nz
X-Proofpoint-ORIG-GUID: hhJES_FEz9_0g2ZuNq76hD1fDHbot-nz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX/qKAolVoMqgL
 k2hgRuFrVHoKKZ6D2RyiV2f7galALDG33zXX6C30b/Hk+4/Y1J46TG4+a6j5h3NN/zBNNPb1T1O
 iW8jSpfvacLsPKFANZ1z+vekjskjFDCibgBqoKJycQVEVecx9AuQatsYGJUymALSg6DgvHsoUl5
 xqRCkFQTyqR9gh1qvLsX1WXT1mGW4puMS9gqGEBHQN9htgY2WnxupSdeBm8yFNxa8W0wj7ahg4b
 XQ/ZbHmK9S8CmBkC+e/eYZM76N/jCwT4jJ3FC+4qY025VtHK9m0zpuFjmW8MBYbl3P4OukSN+X8
 hsxYokwq0Nc8kLa+tgPmOGyCt22lASMQyrPe7FxRfCpWZPQnm+c90/dxLwhIvclsxodVAuK9F6T
 NDn0iknyBC8z0CLQwqs58wyE7V0iSnhJw1GikvV9n3wuwE9zKPBtXAYjHXse7VZdkxtptcTIZCC
 E4AjTAaH5cDSkZePPMg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX2bx2L1QmD38g
 qQY9X65APkwqzkgwIxYR7QVhiJFt8AU7xMKoJYyeEDPJaYNClswrLtri+kIJgTrIMF0gnqi+RCK
 s/T2r4fOLADxDaP7EeZfVLULny2aBWI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200072

Firmware on chips that allocate the MLD peer ID itself (WCN7850 and
QCC2072) reports the assignment back to the host through
HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP. The message carries the chosen
MLD peer id, the MLD MAC address etc.

Add the message type, the on-the-wire struct, the field masks and a
handler that parses them out. The host-side state update (publishing the
dp peer into ath12k_dp_hw::dp_peers[], propagating the ID to
ath12k_dp_link_peer::ml_id and ath12k_sta::ml_peer_id) is added in a
follow-up patch;

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_htt.c | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/dp_htt.h | 12 ++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.c b/drivers/net/wireless/ath/ath12k/dp_htt.c
index 52e10059c6d5..150b190f9c7f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.c
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.c
@@ -575,6 +575,33 @@ static void ath12k_htt_mlo_offset_event_handler(struct ath12k_base *ab,
 	rcu_read_unlock();
 }
 
+static void ath12k_dp_htt_mlo_peer_map_handler(struct ath12k_base *ab,
+					       struct sk_buff *skb)
+{
+	struct htt_resp_msg *resp = (struct htt_resp_msg *)skb->data;
+	struct htt_t2h_mlo_peer_map_event *ev = &resp->mlo_peer_map_ev;
+	u16 raw_peer_id, peer_id, addr_h16;
+	u8 peer_addr[ETH_ALEN];
+
+	if (skb->len < sizeof(*ev)) {
+		ath12k_warn(ab, "unexpected htt mlo peer map event len %u\n",
+			    skb->len);
+		return;
+	}
+
+	raw_peer_id = le32_get_bits(ev->info0,
+				    HTT_T2H_MLO_PEER_MAP_INFO0_MLO_PEER_ID);
+	peer_id = raw_peer_id | ATH12K_PEER_ML_ID_VALID;
+
+	addr_h16 = le32_get_bits(ev->info1,
+				 HTT_T2H_MLO_PEER_MAP_INFO1_MAC_ADDR_H16);
+	ath12k_dp_get_mac_addr(le32_to_cpu(ev->mac_addr_l32), addr_h16,
+			       peer_addr);
+
+	ath12k_dbg(ab, ATH12K_DBG_DP_HTT, "htt mlo peer map peer %pM id %u\n",
+		   peer_addr, peer_id);
+}
+
 void ath12k_dp_htt_htc_t2h_msg_handler(struct ath12k_base *ab,
 				       struct sk_buff *skb)
 {
@@ -659,6 +686,9 @@ void ath12k_dp_htt_htc_t2h_msg_handler(struct ath12k_base *ab,
 	case HTT_T2H_MSG_TYPE_MLO_TIMESTAMP_OFFSET_IND:
 		ath12k_htt_mlo_offset_event_handler(ab, skb);
 		break;
+	case HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP:
+		ath12k_dp_htt_mlo_peer_map_handler(ab, skb);
+		break;
 	default:
 		ath12k_dbg(ab, ATH12K_DBG_DP_HTT, "dp_htt event %d not handled\n",
 			   type);
diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.h b/drivers/net/wireless/ath/ath12k/dp_htt.h
index 987689f11cda..2db7fb27c036 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.h
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.h
@@ -930,6 +930,7 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_EXT_STATS_CONF = 0x1c,
 	HTT_T2H_MSG_TYPE_BKPRESSURE_EVENT_IND = 0x24,
 	HTT_T2H_MSG_TYPE_MLO_TIMESTAMP_OFFSET_IND = 0x28,
+	HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP = 0x29,
 	HTT_T2H_MSG_TYPE_PEER_MAP3	= 0x2b,
 	HTT_T2H_MSG_TYPE_VDEV_TXRX_STATS_PERIODIC_IND = 0x2c,
 };
@@ -974,11 +975,22 @@ struct htt_t2h_peer_unmap_event {
 	__le32 info1;
 } __packed;
 
+#define HTT_T2H_MLO_PEER_MAP_INFO0_MLO_PEER_ID		GENMASK(23, 8)
+#define HTT_T2H_MLO_PEER_MAP_INFO1_MAC_ADDR_H16		GENMASK(15, 0)
+
+struct htt_t2h_mlo_peer_map_event {
+	__le32 info0;
+	__le32 mac_addr_l32;
+	__le32 info1;
+	__le32 reserved[5];
+} __packed;
+
 struct htt_resp_msg {
 	union {
 		struct htt_t2h_version_conf_msg version_msg;
 		struct htt_t2h_peer_map_event peer_map_ev;
 		struct htt_t2h_peer_unmap_event peer_unmap_ev;
+		struct htt_t2h_mlo_peer_map_event mlo_peer_map_ev;
 	};
 } __packed;
 

-- 
2.25.1

