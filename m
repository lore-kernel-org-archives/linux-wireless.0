Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601542;
	b=cyUp4K1vz+D8+FdwQ3MbTF9O10QtgVu4O3h0T20xIKFszYzQ0TJk+4sLdtv9kFeQsA5c
	 KEoGcPxd+eIGu8WgWAcBwB0M+pA/zhV7DX5PhT3HLd7Vn7J5SZzLIAvtEFZ9xOnHqbufB
	 vhbRLrDfdC4h2We3ntoJvGXFukXnnGQCy9ouNsQ9kXGmkV3UAHrBcNBJjnjVhAXuH7R81
	 FjGua4WQnCjqeBCOK3gz4/z42WaA/eLObFDG1WBoSxWB+ejfuggte+7H62yLi237RTD7M
	 avRejnS8ZWOuwWyr7ymyO50P4Pjb8UNyxmw7oNnK+ApL+d4nwIEZLQftZD5VHkmU48Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601542;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=FZkud3UiFxyI+if5VP4Cl4Ikk8rGXzgRnA5iU5yHVK8=;
	b=OgA9rdaIceYbYtfTNZCUZ0QpE05zZIatOlr7fX4RB/N04ZlDJQ6HSfXW6Zuc3Nn+BELs
	 XRcCQ401VLv2kpp8GR/5/XlIZdVjCTHqkeouU58DJTs3D4lJh9dWJ2FKJuRULZmvL5EyK
	 M42FXBF+JO6FLX8N06trTwAWmBS3aXEDxN7a14h774NKHXt0yTOvofkoK8aghcXWPAWh4
	 y9EAI3c8EaLMOOA/gDfpDSdVJVD1sAtkbPVKSlR/5CWGkx667Tc3DXs64qHSP22eJhNZ4
	 NA1n4i7kzmr8TWzlW60CI7PK6SwQVKPU8ej0ELwkjXbqEXrTZ+NBbyM5sszs++EdfxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LqyDMNdJ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="iq8EI/sl";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67E6606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:39:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C67E6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LqyDMNdJ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iq8EI/sl
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A24DIBm2433742
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FZkud3UiFxyI+if5VP4Cl4Ikk8rGXzgRnA5iU5yHVK8=; b=LqyDMNdJrvL+mFOX
	c48fmaZ9KbhDpeT9kSfS/k/dhwYyoNjMZCAJ5MShX7sEoHJQv/zchuZ5yVnEurYv
	DTugfOrKatZK2mvvtfQ+Ra3N0xkGDI1jTHblRepha0x50Qpb0cs48HX6XYwdSnaI
	XayzFyFNT2jnYSIXpn3l5S/KU4zhEEzTLZh7/ql782vQYo2eBmNYBDPCxLg+H5qe
	0a06gLMO24rknrV7OCJ9gZLxgwv/4+wpptiZoCLrKHKRNa0w/A91Lq5E3sDQcPbL
	ebpO9+qRHwVhHXgFCKKFPtvWp2E/zecy7sPgYLwJD0zsu7UP931rA7zi06kzxwWq
	f7OKow==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpka60dhm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:39:00 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2eb361b86dcso15968475ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601540; x=1794206340; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FZkud3UiFxyI+if5VP4Cl4Ikk8rGXzgRnA5iU5yHVK8=;
        b=iq8EI/slo0iDXByTopfSD0TOPvyzZesvPArtSMCbmXMlktYG3wbiLTwwrvtcEO+8ws
         V1H61FFhjCIwvenH3pQtE9fgX48X1p27Z3Mtt7UZMAv8C2zxPqx0NBZCpT448X5xhI6u
         wUnyIoTv20LRp3FT10D5eXsuPXs/g7SUp10l9s3xBuxDkoWjoO/ToOxxIr/YQqWhJSfW
         Kofnncfg8fWGANTMmjIV8u/dvrs3jzgtsAmcirfR7nhDbafLEiXu8nRb+VDeYTnda6YN
         iGO4+THflRjptNxCDurQ/oqECFoBG8xvjg7FGYcoGc5i847VEHxxqvFGH1mC4ybxjlbj
         /sQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601540; x=1794206340;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FZkud3UiFxyI+if5VP4Cl4Ikk8rGXzgRnA5iU5yHVK8=;
        b=y0l1PXlNFXgxlB0y7WQOR666/CItsjp0vet9KDeXijI3C4nk+qaXHxGfZKpwcKGIYb
         B0xMJYlME6TlVzP3grq5Xvyc0cgqxux/iH/5eRpMffqJmnXI3/bLxaLQkjDO6r8zHZfn
         HquJdnY2qz4DcLoRYwLoUwaB8K9FY2nMwYxaC0VN2Esw0MszHaONgB7EJJV2BxhT3Jtc
         RjlWJA+Xl78tsJQWog1N3X1bNlnHCVgw7FZn+yiW0u14I84boaAi2CGBUecnG//J5m+6
         s+leP6/y6Y+9/bleBjaDC/iUT+5iFzT4c8h23iwMcnI3OJul/UF0E3lXQUaEkeu0w03q
         uDfA==
X-Gm-Message-State: APuU4Z/tBraAVeNjGiuhmfqCVMrkST0EUvJDlhpFE8qQo9FDqqk3KKAS
	cyf8xOX+BrrbV0loPpGO/YXaOJfW43fe8HAkWGuZ8mruGOgMp+NU5OO21yHxtqu4Kbe++TDIyxB
	pfjn5DcP4umF0OerNYjTEpd6PPihU9nnHHRb9CWyfi5QLaOUwE1fCQeqxWhJD+/ycZYfTlsIvLO
	AhKw==
X-Gm-Gg: AYBFou20MWdeZtOXesYeN6Pq2G0Vqyja8gewsptry8XJZ/Mwc2viewTUb9gteev7pnT
	AFo1gp+vjG2sEo5Z4LDmD4XjXhag670ZZyvNopkhedUT7y/J/aGj9dpMxD1It/EBcNcvlyx6E4u
	F4MwRT1mzqfvVRGd8k34PpRQHquOi/XgdZqqQu6FPmTN7oUdHFz9Oh/QFlTEQkuevhhPWaQPLZv
	Eb+XF7CF1paR3O1rY1AVUzsLG8Rbnu9FwoeceC5DB5iplMqRvZYEdQVw7M7zjPSOfqJgVZS9blU
	xyLdJCs8KpclT5Stpwa5cDq1oquZsvMjfyHOcrYmlk85q70tl0ozx+Xo/or1GaRI3Lmc+zM2dCI
	Hw7eziLJFPQ2l7xocb12Z6CoJp6UWXH2C2kyHHKXdzahu5OSCYT9XGc8Abe8ZsQhATEWpx1IOeE
	iuEK7iAqFN1543QzmvFCMNbzubVMMY
X-Received: by 2002:a17:90b:2d04:b0:3a7:82ef:bcdd with SMTP id 98e67ed59e1d1-3ae898392c2mr7471852a91.41.1793601539703;
        Sun, 01 Nov 2026 22:38:59 -0800 (PST)
X-Received: by 2002:a17:90b:2d04:b0:3a7:82ef:bcdd with SMTP id 98e67ed59e1d1-3ae898392c2mr7471839a91.41.1793601539133;
        Sun, 01 Nov 2026 22:38:59 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:58 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:16 +0800
Subject: [PATCH ath-next v4 07/11] wifi: ath12k: add support for
 HTT_T2H_MSG_TYPE_PEER_EXTENDED event
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
Message-Id: <20261102-ath12k-logical-link-id-v4-7-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: iv8whUstEb_RVPOweszxhTgQ7apt8nT7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX5lIWPowIJ2ZO
 GsncQSCzbJOhl/BQZ5FYX0p+c3v0pSs8AEOO+yKfbLSuiXasXbWcnW8zjDBKygluvrJav520+oI
 3xyPW1W6SSlS2JvcU/D3BX9os03TZaw=
X-Authority-Analysis: v=2.4 cv=ZbyIpcVA c=1 sm=1 tr=0 ts=6ae83004 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=FAGSEp2nAAAA:8 a=EBqVsfUuMMxUAKVxpnoA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=Lh16BCjgaU6qELXH5G7V:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXw7zEgTIGRkWd
 Z2AxVpsj4YgzLOFV3Oc3IBbnq/1s5wbZsVgGd3epb20P0GRUd1BbEfLJLSNy51eBLfRKglOwm3h
 CRNy0uWqOUOjLUvPXrJnoB7KECQUaVqQ/ErRaiWWyFmQ2ubJvu2HQ7u7dMeYiKo2OjVuqWS6MjJ
 TxS/TasKXdNaYmvWTNnFdcG7Ges4HMa9CP0Bwry3Ux/6W5uZt5qBYFpWWDInS6/7LzYG9UTlbfi
 2/Ke+C/QRe00zXxC08SX0CiQSk40cmXde1mO9gwugbUehB984MJrXAAcwh7XcWZYv0QIOY9wBNK
 zHeG6xAYUbdKyfLksAP8zMXdS0FnlBMAPaLS9O4tVOaC/js2XEfSLnEgDJUmCR/Op+1WDglhGzb
 m7jMrn8Bi2gdLHkt69lyHWG1GgI1+9NkjfmSuxs+yeJ7j29YOjSmXAgs/0G4B4Ya+fS5KlHtsMo
 brTvJAJMmTHS4a8oW8w==
X-Proofpoint-GUID: iv8whUstEb_RVPOweszxhTgQ7apt8nT7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020026

WCN7850/QCC2072 hardware/firmware report only the logical link id to
identify the link on which a packet is received. The host, however,
needs the IEEE80211 link id. So a mapping between them needs to
be established.

Add support for the HTT_T2H_MSG_TYPE_PEER_EXTENDED event, which reports
the logical link id for a given link peer. Find the link peer and
populate ath12k_dp_peer::link_id_map, mapping the logical link id to the
IEEE80211 link id. This map is later used in the data path to derive the
IEEE80211 link id.

The firmware sends this event after each peer assoc, but only when it
advertises WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT. On such devices, block
in ath12k_mac_peer_assoc() until the event arrives. The event arrives
before the MLO_RX_PEER_MAP event, so wait for it first.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c    |  1 +
 drivers/net/wireless/ath/ath12k/core.h    |  1 +
 drivers/net/wireless/ath/ath12k/dp_htt.c  | 17 ++++++++
 drivers/net/wireless/ath/ath12k/dp_htt.h  | 15 +++++++
 drivers/net/wireless/ath/ath12k/dp_peer.c | 66 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp_peer.h |  3 ++
 drivers/net/wireless/ath/ath12k/mac.c     | 13 ++++++
 drivers/net/wireless/ath/ath12k/wmi.h     |  1 +
 8 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 353fb9c5a69d..1bd26e82a6ec 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1562,6 +1562,7 @@ static void ath12k_core_pre_reconfigure_recovery(struct ath12k_base *ab)
 			complete_all(&ar->scan.completed);
 			complete(&ar->scan.on_channel);
 			complete(&ar->peer_assoc_done);
+			complete(&ar->peer_ext_event_done);
 			ath12k_peer_delete_wait_flush(ar);
 			complete(&ar->install_key_done);
 			complete(&ar->vdev_setup_done);
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index f1929997a35a..478b51ea1f7c 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -682,6 +682,7 @@ struct ath12k {
 	u8 radio_idx;
 
 	struct completion peer_assoc_done;
+	struct completion peer_ext_event_done;
 	struct list_head peer_delete_waits;
 
 	int install_key_status;
diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.c b/drivers/net/wireless/ath/ath12k/dp_htt.c
index 72069640bd38..25c1f915defd 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.c
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.c
@@ -627,6 +627,7 @@ void ath12k_dp_htt_htc_t2h_msg_handler(struct ath12k_base *ab,
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct htt_resp_msg *resp = (struct htt_resp_msg *)skb->data;
 	enum htt_t2h_msg_type type;
+	u8 logical_link_id, valid;
 	u16 peer_id;
 	u8 vdev_id;
 	u8 mac_addr[ETH_ALEN];
@@ -708,6 +709,22 @@ void ath12k_dp_htt_htc_t2h_msg_handler(struct ath12k_base *ab,
 	case HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP:
 		ath12k_dp_htt_mlo_peer_map_handler(ab, skb);
 		break;
+	case HTT_T2H_MSG_TYPE_PEER_EXTENDED:
+		peer_id = le32_get_bits(resp->peer_extended_ev.info,
+					HTT_T2H_PEER_EXT_INFO_PEER_ID);
+		vdev_id = le32_get_bits(resp->peer_extended_ev.info,
+					HTT_T2H_PEER_EXT_INFO_VDEV_ID);
+		peer_mac_h16 = le32_get_bits(resp->peer_extended_ev.info1,
+					     HTT_T2H_PEER_EXT_INFO1_MAC_ADDR_H16);
+		ath12k_dp_get_mac_addr(le32_to_cpu(resp->peer_extended_ev.mac_addr_l32),
+				       peer_mac_h16, mac_addr);
+		logical_link_id = le32_get_bits(resp->peer_extended_ev.info1,
+						HTT_T2H_PEER_EXT_INFO1_LOGICAL_LINK_ID);
+		valid = le32_get_bits(resp->peer_extended_ev.info1,
+				      HTT_T2H_PEER_EXT_INFO1_LOGICAL_LINK_ID_VALID);
+		ath12k_dp_link_peer_extended_event(ab, vdev_id, peer_id, mac_addr,
+						   logical_link_id, valid);
+		break;
 	default:
 		ath12k_dbg(ab, ATH12K_DBG_DP_HTT, "dp_htt event %d not handled\n",
 			   type);
diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.h b/drivers/net/wireless/ath/ath12k/dp_htt.h
index 2db7fb27c036..1d192bde0c29 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.h
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.h
@@ -933,6 +933,7 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP = 0x29,
 	HTT_T2H_MSG_TYPE_PEER_MAP3	= 0x2b,
 	HTT_T2H_MSG_TYPE_VDEV_TXRX_STATS_PERIODIC_IND = 0x2c,
+	HTT_T2H_MSG_TYPE_PEER_EXTENDED	= 0x39,
 };
 
 #define HTT_TARGET_VERSION_MAJOR 3
@@ -985,12 +986,26 @@ struct htt_t2h_mlo_peer_map_event {
 	__le32 reserved[5];
 } __packed;
 
+#define HTT_T2H_PEER_EXT_INFO_PEER_ID		GENMASK(23, 8)
+#define HTT_T2H_PEER_EXT_INFO_VDEV_ID		GENMASK(31, 24)
+#define HTT_T2H_PEER_EXT_INFO1_MAC_ADDR_H16	GENMASK(15, 0)
+#define HTT_T2H_PEER_EXT_INFO1_LOGICAL_LINK_ID	GENMASK(18, 16)
+#define HTT_T2H_PEER_EXT_INFO1_LOGICAL_LINK_ID_VALID	BIT(19)
+
+struct htt_t2h_peer_extended_event {
+	__le32 info;
+	__le32 mac_addr_l32;
+	__le32 info1;
+	__le32 info2;
+} __packed;
+
 struct htt_resp_msg {
 	union {
 		struct htt_t2h_version_conf_msg version_msg;
 		struct htt_t2h_peer_map_event peer_map_ev;
 		struct htt_t2h_peer_unmap_event peer_unmap_ev;
 		struct htt_t2h_mlo_peer_map_event mlo_peer_map_ev;
+		struct htt_t2h_peer_extended_event peer_extended_ev;
 	};
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index f73dad49e42b..1e84b9b817f3 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -8,6 +8,7 @@
 #include "dp_peer.h"
 #include "debug.h"
 #include "debugfs.h"
+#include "mac.h"
 
 void ath12k_dp_link_peer_free(struct ath12k_dp_link_peer *peer)
 {
@@ -195,6 +196,60 @@ void ath12k_dp_link_peer_map_event(struct ath12k_base *ab, u8 vdev_id, u16 peer_
 	spin_unlock_bh(&dp->dp_lock);
 }
 
+void ath12k_dp_link_peer_extended_event(struct ath12k_base *ab, u8 vdev_id,
+					u16 peer_id, u8 *mac_addr,
+					u8 logical_link_id, u8 valid)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp_link_peer *peer;
+	struct ath12k_dp_peer *dp_peer;
+	struct ath12k *ar;
+
+	if (!valid || logical_link_id >= ATH12K_GROUP_MAX_RADIO) {
+		ath12k_warn(ab, "invalid logical link id %u valid %u\n",
+			    logical_link_id, valid);
+		goto exit;
+	}
+
+	spin_lock_bh(&dp->dp_lock);
+
+	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, vdev_id, mac_addr);
+	if (!peer) {
+		ath12k_warn(ab, "failed to find link peer with vdev id %u addr %pM\n",
+			    vdev_id, mac_addr);
+		goto unlock;
+	}
+
+	if (peer->peer_id != peer_id) {
+		ath12k_warn(ab, "link peer id mismatch, expected %u got %u\n",
+			    peer->peer_id, peer_id);
+		goto unlock;
+	}
+
+	dp_peer = peer->dp_peer;
+
+	peer->drv_link_id = logical_link_id;
+	dp_peer->link_id_map[peer->drv_link_id] = peer->link_id;
+
+	ath12k_dbg(ab, ATH12K_DBG_DP_HTT,
+		   "htt peer extended vdev %d peer %pM id %d logical_link_id %u link_id %u\n",
+		   vdev_id, mac_addr, peer_id, logical_link_id, peer->link_id);
+
+unlock:
+	spin_unlock_bh(&dp->dp_lock);
+
+exit:
+	rcu_read_lock();
+
+	ar = ath12k_mac_get_ar_by_vdev_id(ab, vdev_id);
+	if (ar)
+		complete(&ar->peer_ext_event_done);
+	else
+		ath12k_warn(ab, "failed to get ar with vdev id %u\n", vdev_id);
+
+	rcu_read_unlock();
+}
+
 static int ath12k_dp_link_peer_rhash_addr_tbl_init(struct ath12k_dp *dp)
 {
 	struct ath12k_base *ab = dp->ab;
@@ -544,9 +599,16 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 		dp_peer->peer_id = peer->peer_id;
 
 	peer->dp_peer = dp_peer;
-	peer->drv_link_id = hw_link_id;
 
-	dp_peer->link_id_map[peer->drv_link_id] = link_id;
+	/*
+	 * Only devices that use hw_link_id can map it to the IEEE80211
+	 * link id here. Devices that do not support hw_link_id fill
+	 * link_id_map later from the PEER_EXTENDED HTT event.
+	 */
+	if (dp->hw_params->support_hw_link_id) {
+		peer->drv_link_id = hw_link_id;
+		dp_peer->link_id_map[peer->drv_link_id] = link_id;
+	}
 
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index d2752b35ba0f..ea36947d1707 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -122,6 +122,9 @@ struct ath12k_dp_link_peer {
 void ath12k_dp_link_peer_unmap_event(struct ath12k_base *ab, u16 peer_id);
 void ath12k_dp_link_peer_map_event(struct ath12k_base *ab, u8 vdev_id, u16 peer_id,
 				   u8 *mac_addr, u16 ast_hash, u16 hw_peer_id);
+void ath12k_dp_link_peer_extended_event(struct ath12k_base *ab, u8 vdev_id,
+					u16 peer_id, u8 *mac_addr,
+					u8 logical_link_id, u8 valid);
 
 struct ath12k_dp_peer {
 	struct list_head list;
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 87c52ddfe279..1e539388c003 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3864,6 +3864,7 @@ static int ath12k_mac_peer_assoc(struct ath12k *ar,
 	int ret;
 
 	reinit_completion(&ar->peer_assoc_done);
+	reinit_completion(&ar->peer_ext_event_done);
 	reinit_completion(&ah->peer_ml_id_done);
 
 	ret = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
@@ -3879,6 +3880,17 @@ static int ath12k_mac_peer_assoc(struct ath12k *ar,
 		return -ETIMEDOUT;
 	}
 
+	if (!ar->ab->hw_params->support_hw_link_id &&
+	    test_bit(WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT,
+		     ar->ab->wmi_ab.svc_map) &&
+	    peer_arg->ml.enabled &&
+	    peer_arg->is_assoc &&
+	    !wait_for_completion_timeout(&ar->peer_ext_event_done, 1 * HZ)) {
+		ath12k_warn(ar->ab, "failed to get peer extended event for %pM vdev %u\n",
+			    peer_arg->peer_mac, peer_arg->vdev_id);
+		return -ETIMEDOUT;
+	}
+
 	/*
 	 * For devices where the firmware allocates the MLD peer ID, the host
 	 * learns the real ID only from the MLO_RX_PEER_MAP HTT event, which is
@@ -15203,6 +15215,7 @@ static void ath12k_mac_setup(struct ath12k *ar)
 	init_completion(&ar->vdev_setup_done);
 	init_completion(&ar->vdev_delete_done);
 	init_completion(&ar->peer_assoc_done);
+	init_completion(&ar->peer_ext_event_done);
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->bss_survey_done);
 	init_completion(&ar->scan.started);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 5d0afbf0bd0c..94c5def03137 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -2278,6 +2278,7 @@ enum wmi_tlv_service {
 	WMI_TLV_SERVICE_WMSK_COMPACTION_RX_TLVS = 361,
 
 	WMI_TLV_SERVICE_PEER_METADATA_V1A_V1B_SUPPORT = 365,
+	WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT = 380,
 	WMI_TLV_SERVICE_THERM_THROT_POUT_REDUCTION = 410,
 	WMI_TLV_SERVICE_WDS_NULL_FRAME_SUPPORT = 421,
 	WMI_TLV_SERVICE_IS_TARGET_IPA = 425,

-- 
2.25.1

