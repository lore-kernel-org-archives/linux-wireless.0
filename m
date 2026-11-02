Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601544;
	b=aGdcHTdtnC17QeQeo72s1ylNQR/SMPtTszZ+4JyHnrkePhbtP+vZHxH8+hE8VFUlz4Ci
	 zo9N5qGIhixy40E2LkU5pmjuuW4nLh6dpr5F6pf0pIFoLRJ8HNKwgaXfs/rimxVkb03QT
	 EbNELYOBkmwkaovjfy9HliTJv0j2IhTS012Kq8v9RMxU4LL5axxOstlpe9zO5lxf7bWLk
	 n3f//XGL2V5HUGCsDMrwdqqkZfbyR4c9oICDpGTf8vThjGxruXQs2D4v8Z+249Bc78EJr
	 fImSQKF4Kw16bBtX8wsme87w7qxQKpF1+lWq3d8Epl/O6PTVpnb0IIfsuOC2qWVXC0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601544;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XipYPlgLEWzVCTMCmQlUGdyQWvwcpjxbalStCmOPiu4=;
	b=mPnIp1M1Q9VFmfXjoT/UXw89OqJPRoMemU1ZuZ2wleGUZtVlGFRwvYNKQU0XqlPKT4kj
	 D7tpHpEUZuYYcEYWF2jzCSdafRelfrnYTikpM8noQN0CmiavOvxOn5rB58kHaFRzXtpg6
	 /MJ2MypHp/8tlS0JQXIIsrRjbEsgfYldaz1nCyjFDjbkjfAsbEq9R30kAaU4Sx6LT+lqe
	 NgeBputwiGVB0xuZtX6ja4S84v9s0NmVLspN3jtikJcfmdIafqGztHqEFioD4bMI2UQ8Y
	 WKianL5CpMMAr/KaBbfp8myG6SiN3cF1Aj7upTn5UGpvweTVm5mPTMMxJb6i/kU9Q0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Nhn4QyER;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PNtN1E6j;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21449606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:39:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21449606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Nhn4QyER;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PNtN1E6j
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vFci3348781
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XipYPlgLEWzVCTMCmQlUGdyQWvwcpjxbalStCmOPiu4=; b=Nhn4QyERbz5Kg11S
	BVsk3zlVQQzWyBr1xDITgVwR+bnW9CCykcSRuwoDE8jn7gYuo9EMJnpqOnnqhSPp
	/KvCSfEuvMjJrYnCDbQtwnwqiwW79FXYEqh/Dk9FoGq6glt6s80A9nSneppSrUQh
	bEvTHh+wg6YjcddgdIdBODhBjjbWzMhaLTmm2+r0SLZ17C4iyLh2fFjV7eihmy2r
	v/gmcC92KL5trNvKzQ4YCxX1OD/JhOxyJErvY8FYMF6w4PZp/ol3AyiOviXhlivx
	NhTWnxmHZey94TmgrYZejiVPhN+ME0Gt3TEKUnX3aQ9G5ELARM/BvAiACXf9ZhBp
	dJYTqg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7wxnj10-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:39:03 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd8b299b05fso2233900a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601542; x=1794206342; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XipYPlgLEWzVCTMCmQlUGdyQWvwcpjxbalStCmOPiu4=;
        b=PNtN1E6jXSRmv00/99FTAj3+qWKGmyPF0RAKPcoyb3W7fXC85Tmkupz/nd23FvwO84
         R2ztvtHnXd06dWnyTJ14XdFdccJnHASwXEu/8vXSatSVGSJW0CKKJ/g8Q2hZJuqGHCux
         fXE21nEyV0n2fEz+si427S68R0L++1w8TKUJum12Y5jCGLztIjaPfOlXzu+LRS3gJSQw
         ptOtP5hCjkQBcLv6d+qDASNivpalHc35p8LbFKqW+Zu6LNcl0SaLUSWnpgLyIRki58ul
         SURNHO7bxL3itSEuq8ME3byKkzNe0QbXR4v5LOrK5I7Mm7Ny4rKqKWjAymrxp/IerJfV
         AuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601542; x=1794206342;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XipYPlgLEWzVCTMCmQlUGdyQWvwcpjxbalStCmOPiu4=;
        b=Xo7RwiweIXXtE5hFRFQDGksLmJ79y6c3XsFb4435xeoRLdxBRSN4uUn+CUg6VFMDZR
         0mbbhSGypMDPz+V8SrgwKagDtfwy8vHviuqDCZwscLqzpoCnOBsSiZi5E6h7y/vkE4n+
         cJ7zrhpVkL7RE1Fgim7YETtbkpnLNNKyY3hi89e4PLUg243J5Npz/bvsv23saw2m9EnS
         2oZWwo+81TNzTP5rk0bXiV37K8Icwc6VXvvjmI9EO5TtZyCyLrYwhDpRS4izcDOFg7W1
         Oloq8R/vEgNTPppB1z5GsfkbF9jg01Iejo2aiul+doqWhD3vBTFOylit31bzl1V6dALg
         JF3g==
X-Gm-Message-State: APuU4Z+/eAd3tqE02StqaX8xRI+/FDnUarmaNBROklIZZGqkGTDjbAx2
	Ls1m0tkA8DSIyH9hSjUjxtEIDtwQLlKW0+5MxNIT6uOmbwWsIAXbFSpFRm0Wc1+nhAy28ZEG8gY
	VwNKtGcyEebzn17sgYxvRMe4H7KrBB7wLVrPEPPg9oPBmAMoZCK8QJtF8QR1SK92cae177MIWMY
	NY6o9i
X-Gm-Gg: AYBFou0luPChQAuc119lEVDO6CzQi2Dvg9dQOyTte9WotH65kqZGfWiADOPOiDE0Jcg
	ZnAUQ7+UrPzcEeQARi6g2+lDZy63J0iwDQ1m8VPi1GfI+0A7JopfXzFXbd0JPLxqsG9+2nbT9BL
	PQ+eMAqzahacXJP1kbPJisuHH1CIqQPgNgMoHf4MB9UWzTqEfsYcnZFdRB2h9evK2YjMQtQV/Lg
	Br9FC5ObGK2GhNSZo6MA90m7SRGD2PvwBGTjaFNOrd2mjh0mzDoMK0ADXmHe7EtA37mOUKsTrZp
	sGvf+mEyakkRQ9JnlaMifxfwtSa9jECvp7mTkscgSImIb4koLo32BtXL4nYTH+G2mEbVOUA0H1V
	bX4tzgS0TqESc948Widb7vuDcnf2UbcEEwgaGwoZlxHLqt9m5LTQ6oniCb2m/9FKw5TZ4DombVQ
	euoD93nMwY1IElG1w5mitbYd4yG7KE
X-Received: by 2002:a17:90b:268d:b0:3a5:147a:3b63 with SMTP id 98e67ed59e1d1-3ae895a5bdemr6953228a91.8.1793601541410;
        Sun, 01 Nov 2026 22:39:01 -0800 (PST)
X-Received: by 2002:a17:90b:268d:b0:3a5:147a:3b63 with SMTP id 98e67ed59e1d1-3ae895a5bdemr6953220a91.8.1793601540889;
        Sun, 01 Nov 2026 22:39:00 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:39:00 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:17 +0800
Subject: [PATCH ath-next v4 08/11] wifi: ath12k: allocate logical link id
 on host when firmware does not report it
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
Message-Id: <20261102-ath12k-logical-link-id-v4-8-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: ZiMKLpD8-4pMD8n3-pxm8aFhpsEMxTSl
X-Proofpoint-ORIG-GUID: ZiMKLpD8-4pMD8n3-pxm8aFhpsEMxTSl
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXxmfBsi0v1ixr
 Qi4X9iyOpgttwKra5xOktawM8TVi3+LW8D9skDPLlYqGFpN+aKeto+rznpdLPSCfJJiZoQbwOwz
 WP08VERFGpgbvWrb7YeZMiU6mb8Qdas=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXwCoJyF7Jbr1f
 vuXs5gaPOwzqoqYwaBdxtJaNwcS/cAn5gkY48Sr27+Q0RU3OOtXgO2VyyyGswrVcYgo2yV2ABMy
 plbOT1ZayMZx3pBI0aNillo9DezBKE33wsz/Sbw73oI+fDEnA+//e/fHyBHqJ6/7FDCJp7pz8tY
 clEVHZm3DZcPp6ORmOSSSWnQMt+tFBA/crJiOxDHTPJYE0RrHdI7ptBuZKv6Rx77nnIYv0ykgHr
 sd31arh5WkHImkK+cDFD/dtIwltZPNKGT/HLkoF1wW6+iAN61y6umP9KNja0rmMEklJugQQXpoC
 LpfPs5Ma3h9K0SnbW7/kDsXtAfvuNutsMOPvk+yXUbZ3HVL571xJtD0ycq/QRmIJlyjprweYxgl
 Gcs7niONBqFEcjsIjWZpGCplSMuYkBsDYX3bT2x+oHyZTl64OzUD3cZCpIkbGgFfWWdZG1wd5+g
 rdx1dt9QpI+4uw8J4RQ==
X-Authority-Analysis: v=2.4 cv=JLquIMKb c=1 sm=1 tr=0 ts=6ae83007 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=2FDiJZU-w7-vk6pY0YkA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

For devices that do not support hw_link_id (WCN7850/QCC2072), the driver
link id used to index ath12k_dp_peer::link_id_map is the logical link id.
When the firmware advertises WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT it
reports this id in the PEER_EXTENDED HTT event, and the host waits for
that event to fill link_id_map.

However some old firmwares don't advertise it, and no such event is sent.
In that case allocate the logical link id on the host, mirroring the
firmware scheme: pick the lowest free slot from a per peer bitmap
(ath12k_dp_peer::free_slot_map) at peer assoc, after the peer assoc
command has been sent. This matches the firmware, which allocates the id
while handling the peer assoc command.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_cmn.h  |  3 ++
 drivers/net/wireless/ath/ath12k/dp_peer.c | 49 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp_peer.h |  8 +++++
 drivers/net/wireless/ath/ath12k/mac.c     | 52 ++++++++++++++++++++++++++-----
 4 files changed, 104 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_cmn.h b/drivers/net/wireless/ath/ath12k/dp_cmn.h
index e17f044ff812..88abe90767eb 100644
--- a/drivers/net/wireless/ath/ath12k/dp_cmn.h
+++ b/drivers/net/wireless/ath/ath12k/dp_cmn.h
@@ -9,6 +9,7 @@
 #include "cmn_defs.h"
 
 struct ath12k_hw_group;
+struct ath12k_dp_link_peer;
 
 /*
  * ML Peer IDs start from 8192, assuming max SLO clients count 1536,
@@ -97,6 +98,8 @@ void ath12k_dp_cmn_hw_group_assign(struct ath12k_dp *dp,
 int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 			       u8 vdev_id, struct ieee80211_sta *sta, u8 *addr,
 			       u8 link_id, u32 hw_link_id);
+int ath12k_dp_peer_alloc_logical_link_id(struct ath12k_dp *dp,
+					 struct ath12k_dp_link_peer *peer);
 void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 				  u8 vdev_id, u8 *addr, u32 hw_link_id);
 void
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index 1e84b9b817f3..ee3cdd7ca460 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -513,6 +513,7 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	dp_peer->sec_type = HAL_ENCRYPT_TYPE_OPEN;
 	dp_peer->sec_type_grp = HAL_ENCRYPT_TYPE_OPEN;
 	dp_peer->ucast_ra_only = params->ucast_ra_only;
+	dp_peer->free_slot_map = U16_MAX;
 
 	spin_lock_bh(&dp_hw->peer_lock);
 
@@ -562,6 +563,49 @@ void ath12k_dp_peer_delete(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	kfree(dp_peer);
 }
 
+int ath12k_dp_peer_alloc_logical_link_id(struct ath12k_dp *dp,
+					 struct ath12k_dp_link_peer *peer)
+{
+	struct ath12k_dp_peer *dp_peer = peer->dp_peer;
+	u8 slot;
+
+	lockdep_assert_held(&dp->dp_lock);
+
+	if (dp->hw_params->support_hw_link_id)
+		return 0;
+
+	if (test_bit(WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT,
+		     dp->ab->wmi_ab.svc_map))
+		return 0;
+
+	slot = __ffs(dp_peer->free_slot_map);
+	if (slot >= ARRAY_SIZE(dp_peer->link_id_map))
+		return -ENOSPC;
+
+	dp_peer->free_slot_map &= ~BIT(slot);
+	peer->drv_link_id = slot;
+	dp_peer->link_id_map[slot] = peer->link_id;
+
+	return 0;
+}
+
+static void ath12k_dp_peer_free_logical_link_id(struct ath12k_dp *dp,
+						struct ath12k_dp_link_peer *peer)
+{
+	struct ath12k_dp_peer *dp_peer = peer->dp_peer;
+
+	lockdep_assert_held(&dp->dp_lock);
+
+	if (dp->hw_params->support_hw_link_id)
+		return;
+
+	if (test_bit(WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT,
+		     dp->ab->wmi_ab.svc_map))
+		return;
+
+	dp_peer->free_slot_map |= BIT(peer->drv_link_id);
+}
+
 int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 			       u8 vdev_id, struct ieee80211_sta *sta, u8 *addr,
 			       u8 link_id, u32 hw_link_id)
@@ -603,7 +647,8 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 	/*
 	 * Only devices that use hw_link_id can map it to the IEEE80211
 	 * link id here. Devices that do not support hw_link_id fill
-	 * link_id_map later from the PEER_EXTENDED HTT event.
+	 * link_id_map later, either from the PEER_EXTENDED HTT event or
+	 * from the logical link id allocated at peer assoc.
 	 */
 	if (dp->hw_params->support_hw_link_id) {
 		peer->drv_link_id = hw_link_id;
@@ -678,6 +723,8 @@ void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_
 	dp_peer = peer->dp_peer;
 	dp_peer->link_id_map[peer->drv_link_id] = 0;
 
+	ath12k_dp_peer_free_logical_link_id(dp, peer);
+
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
 	rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index ea36947d1707..c2d060de88ea 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -145,6 +145,14 @@ struct ath12k_dp_peer {
 	 * WCN7850/QCC2072.
 	 */
 	u8 link_id_map[ATH12K_GROUP_MAX_RADIO];
+	/*
+	 * Tracks which link_id_map slots are free for devices that do not
+	 * support hw_link_id and do not report per-link stats. A set bit
+	 * means the slot is free. Mirrors the firmware logical link id
+	 * allocation: the lowest free slot is assigned at peer assoc and
+	 * released when the link peer is removed.
+	 */
+	u16 free_slot_map;
 
 	u16 sec_type_grp;
 	u16 sec_type;
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 1e539388c003..01c048046290 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3881,14 +3881,52 @@ static int ath12k_mac_peer_assoc(struct ath12k *ar,
 	}
 
 	if (!ar->ab->hw_params->support_hw_link_id &&
-	    test_bit(WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT,
-		     ar->ab->wmi_ab.svc_map) &&
 	    peer_arg->ml.enabled &&
-	    peer_arg->is_assoc &&
-	    !wait_for_completion_timeout(&ar->peer_ext_event_done, 1 * HZ)) {
-		ath12k_warn(ar->ab, "failed to get peer extended event for %pM vdev %u\n",
-			    peer_arg->peer_mac, peer_arg->vdev_id);
-		return -ETIMEDOUT;
+	    peer_arg->is_assoc) {
+		const u8 *addr = peer_arg->peer_mac;
+		u32 vdev_id = peer_arg->vdev_id;
+
+		if (test_bit(WMI_TLV_SERVICE_PER_LINK_STATS_SUPPORT,
+			     ar->ab->wmi_ab.svc_map)) {
+			/*
+			 * The firmware reports the logical link id of this peer
+			 * in the PEER_EXTENDED event, which fills link_id_map.
+			 * Wait for it before returning.
+			 */
+			if (!wait_for_completion_timeout(&ar->peer_ext_event_done,
+							 1 * HZ)) {
+				ath12k_warn(ar->ab,
+					    "failed to get peer extended event for %pM vdev %u\n",
+					    addr, vdev_id);
+				return -ETIMEDOUT;
+			}
+		} else {
+			/*
+			 * The firmware does not report the logical link id, so
+			 * allocate it on the host by mirroring the firmware
+			 * scheme: assign the lowest free slot.
+			 */
+			struct ath12k_dp *dp = ath12k_ab_to_dp(ar->ab);
+			struct ath12k_dp_link_peer *peer;
+
+			guard(spinlock_bh)(&dp->dp_lock);
+
+			peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, vdev_id,
+									 addr);
+			if (!peer) {
+				ath12k_warn(ar->ab, "failed to find dp_link_peer with mac %pM vdev %u\n",
+					    addr, vdev_id);
+				return -ENOENT;
+			}
+
+			ret = ath12k_dp_peer_alloc_logical_link_id(dp, peer);
+			if (ret) {
+				ath12k_warn(ar->ab,
+					    "failed to allocate logical link id for %pM: %d\n",
+					    addr, ret);
+				return ret;
+			}
+		}
 	}
 
 	/*

-- 
2.25.1

