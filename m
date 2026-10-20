Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792478246;
	b=YC2yodDDwH9w2xnpOXllVyt+5crwAlabpOYED71lCrpNflzXdgZ+z8P9yVqLQ9COHuaV
	 PBPnaP3FyWK0DPqK39/Ojmhs9qFlnB8BO9D21DnwX1dPeaKjoXy38qTldQqzgeFZlfsX3
	 8zFw1a2JCgwYk67Jci2NiU+1pC9uiK1oEcT/SoJ3k6RaI1H52t+U1yiNJ+N4EieAoAugs
	 483bUuOFE/l6l5whqZeLvvToZ7HFhVghbZ918ef/ETU3po9u7h85UyXNM2cHRULSopXJz
	 BMBCh8tOJu/B2/9/yG2TDPxaDu1iHwAw2Ch00VyjQsYcPjZZuOBX4IhCXf4IAzK8lcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478246;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Jysg3UmDk9FTjMu2P0SUUwTrEQM4YhK98PUt0MSaa74=;
	b=2E1sJpG+2fysN+S85jBpq/kNFIVsI4y4IIGG751OMx+j7nmAKVdQvFuI1lxPyxZkMKKk
	 e3JEQzg/vqxEQ5ixVH9bN87Td3iQ+U0NRy5YfFkRZ0Kfac/vQJ/vg5bbUqaRdvgie7JBU
	 1x3tbdyleN/B52kFg4ZzhVUp5msngGPdl1QvD232WuF0zoD9TBkYh9WZamC7sjio4H9l+
	 tmtbdBbs3FtSg90uQpD0vDYA0v+Sse3mVCI0jKjE1gNQW9ejDLFFivw1NatHdOR+ZN88r
	 SgIWSLkPCAOP+26oxbQPWjL69bOxlp7+dMuJ1yqF+dEwHLaHAZpq4j4wcmJs9CQIXgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bzviSe7p;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WuCxdHgK;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204B5606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 06:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 204B5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bzviSe7p;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WuCxdHgK
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K6a9ms869941
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 06:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Jysg3UmDk9FTjMu2P0SUUwTrEQM4YhK98PU
	t0MSaa74=; b=bzviSe7pmEptALkpPGd0lvM3NL1SvYkEoR9LZOf3CLzbO4GnM4T
	cmh9KgiK0L9bOYaef5BsVOM5uUC5Qo0ANL3sQwhySJhDJUO68KQ1KLQVsFu0hI1A
	9FosSglTEG0RMqaOrOyg/IFDqz6hVciXmyn1Fvksg/xku54cy7Lqb8KrbhxE/x7C
	7RVGHHyEA7nBPWyTD4UqkfkzBEXc8OtZaQ0o1HwwAYQhsgQEYGY2si0HmdtkAGeB
	RTr0tcm+znrcAgyeXh5whqRpXHfwGROuSHQB7aEp3KkWcv55WCPRNmZg6IQEQP+K
	0vCVjgoz/Jwqi/I3Ww15OIcATxLaT6N3ESQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5n1797-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 06:37:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3abb4c24125so1867346a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 23:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792478244; x=1793083044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jysg3UmDk9FTjMu2P0SUUwTrEQM4YhK98PUt0MSaa74=;
        b=WuCxdHgK13K/a0tNY2q3S83sojgaWXNj87q1+Zr1lqz3FJ+5FqE9lv5ME309LzYQSt
         JXfycJjwbB4ci8NzgwarrQqvmdQq38A2veYmJI3/6X6ZepjXB1IAWtijIatOsttZx+8/
         +LqmryvxBa4uoY5uS4YRedFdKuPKjQamLu92egfzeg3H0CBRSXkyDzSnqBo/KkJVgU+X
         BT9fZQfGgyuH6PIe7cxeXdVdQwO/gG5fodo12mA/Sn9Dc5WuhqhKzlsIohxKQM2Fu5LE
         meqPs3ka2+0DtxvUPC5uZ7lfazcgx4wZs54H30HKsRMtIUa7h8vSSxJJFuMswqAdzUEG
         kCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792478244; x=1793083044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jysg3UmDk9FTjMu2P0SUUwTrEQM4YhK98PUt0MSaa74=;
        b=Q1VCPQcXwWYABtzemRZCCj/6/rWrRfjyp81F7VIxBUUtjhJbPApsClun4TbfM0cNhr
         1i5y4lOkuKH6oJAkMqopRSkE7IyYLJ0DEEZBgh2685QevKZa3I7CeVxEAbGlmOSRz5b1
         9y64AEgqgL3zc0lr/VDtX8Qkrq/vNohyGw84I78VBSORtJ6pqN/f6ftv1Sv2vRtbg3pb
         pK1F+Vm/ZIFmyYPhj13Xlcy5cCA5G08OFuoUctVwKE6nkEPamEqnBtsUAeKUaqU4hJJL
         tQzwPNdUGKKIw+omjfTJileesZEJMeFiGWffx3khNdBZ781KA+ZiWUA6VsUUQvJ3ATLw
         6RZg==
X-Gm-Message-State: AFq9FYL2kRgN68s1TTaxi2DXx/CXcwheJQNVykRomjc/pHy1TkW5r4Td
	ycruu4TLBi/C2Rxb3cNdvnRfBa2RZm0hLSpcSvV78gl2PMobyKM2VBDSuptbWHgLVA3PCkTZQzT
	wftXps0QayIozA+A8SLVIR0rMX9pAt00e8SolgFurkQWM5iyuaqQbam8elsA5MZTOJsd2EQ==
X-Gm-Gg: AYBFou0ohhVB43TlPzT9qHuUNPaVArJEErdxZj0Ke89C+s2plPqEfVK0y2V4ewerKWR
	I1ugjnnIQyFSsqpLAqRl6zcARAnRRTYtopnFw4nvddmBwhtHykrrfV53YJk0V2LcD0+cYAxoSS/
	IIcif3CvntQ9s8PBKtpSPx6FnRknn40BxPQeSKSzAHzBIr2KmcqRd7IRjNmDJ/jaGuYv2ZJjGP5
	Jz0whEzTVaQjZMa0ICxE/PLIHLj2OsRumkgaljenqEq3ZyyiQW6CyLOIcEB9Ve1U9n1rm4nEYoX
	p0kzaQ5VpxGe4jmN6Z3x+6XRB5LDi+WCY/fxvx+c3AEzh/NTFPaWS2F81pYF0tugQRkXUn4TGM1
	/gnsr/ol7hT7KQGKFPgEQuVIvc2eWBXUGABur5tTk9FAEPZAQI/JLc39x51GhiQU=
X-Received: by 2002:a17:90b:4b92:b0:3ac:4e18:238c with SMTP id 98e67ed59e1d1-3acef52acdbmr8657023a91.49.1792478243769;
        Mon, 19 Oct 2026 23:37:23 -0700 (PDT)
X-Received: by 2002:a17:90b:4b92:b0:3ac:4e18:238c with SMTP id 98e67ed59e1d1-3acef52acdbmr8656997a91.49.1792478243126;
        Mon, 19 Oct 2026 23:37:23 -0700 (PDT)
Received: from hangtian-z2-2004.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6549eea48sm4770140a12.19.2026.10.19.23.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 23:37:22 -0700 (PDT)
From: Hangtian Zhu <hangtian.zhu@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: keep ML mgmt tx on active link
Date: Tue, 20 Oct 2026 14:37:19 +0800
Message-Id: <20261020063719.3486519-1-hangtian.zhu@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
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
X-Proofpoint-GUID: -KVCRIMduV_-YNCE0j7VKwodbO3QVE_t
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAyNiBTYWx0ZWRfX+4vcl3tk+iZW
 jLD6QmOUhWsjmqRZ1rLB6tEhMfdBKcubwzQmBXjbSf4MA49eYAZ5/xI4yBeMb2lcHbSlF59tEu/
 RPWRdZJh+T/bGTKWGsm6ZAv6IpBm0gs=
X-Proofpoint-ORIG-GUID: -KVCRIMduV_-YNCE0j7VKwodbO3QVE_t
X-Authority-Analysis: v=2.4 cv=A5z5rKWG c=1 sm=1 tr=0 ts=6ad70c24 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=bOrBbOSleF1CZgbF08wA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAyNiBTYWx0ZWRfXwA/Yc87xrgTe
 XCxQTiIsnY4f3BRDdkuI4ghz02Yi9gVixYFudksDyaXjpmoE6lRPWleBTE1aMn5MH1QH1NvXxuB
 olaK3b98bw1rDwoF62Pv21/wvJWwcWs67ztRHhZ0ymCBcIq67kQhe14YuNkgQRzfSaxaxyLZIKc
 XYZmwrwaPmTUxBGvqa9nbg4AHQt9cQpysyeftLkEF0Xj1zKhjfYgZMbZ9nyFyhIwgksHq9VvYDg
 ex+3XedzKvKlEnv1ovSe0LAQriFruBqFJJtj3Sp4R2/4ZSbaT0PLOfunwIecB4IQHPdGTt8AGmY
 PAPaLkE2m+PIw2Lj2t4fviDEvsi7AW1UMnj+YtYB5sCpyDFJSQTLh0NjWxovBnjKr/UKLz1opJO
 aOppS2Z5Cp3SWA19eBFW25Q56i+o/jrsVkCbfB84gWlxomREX4wc+HC+a36vpSkxYcTJ81diQID
 sJoYjP4Vb/CmSnVg9Ww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200026

Currently ath12k_mac_get_tx_link() may select an inactive link for ML
management frame transmission. This happens when mac80211 passes
IEEE80211_LINK_UNSPECIFIED and the resolved deflink is inactive.

As a result, ML management frames such as deauthentication are sent on
an inactive link and Tx fails (the frame gets dropped).

Fix this by reselecting the Tx link only when the requested link is
IEEE80211_LINK_UNSPECIFIED and the resolved deflink is inactive.
Start from vif->active_links as the candidate set and prefer
links that are both active on the vif and valid for the peer
(sta->valid_links). If that intersection is empty, fall back to
vif->active_links. Use __ffs() to pick deterministically from the
candidate set.

If mac80211 explicitly requests a link, keep that link and do not remap
management Tx to another link.

This change is limited to ML management frames. Data frames, HW-encap
frames, and non-MLO paths are unchanged.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Hangtian Zhu <hangtian.zhu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 28 +++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..14cffba3e354 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9600,6 +9600,7 @@ u8 ath12k_mac_get_tx_link(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
 	struct ieee80211_link_sta *link_sta;
 	struct ieee80211_bss_conf *bss_conf;
 	struct ath12k_sta *ahsta;
+	bool req_unspecified_link = (link == IEEE80211_LINK_UNSPECIFIED);
 
 	/* Use the link id passed or the default vif link */
 	if (!sta) {
@@ -9645,6 +9646,33 @@ u8 ath12k_mac_get_tx_link(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
 	if (!ieee80211_is_mgmt(hdr->frame_control))
 		return link;
 
+	/*
+	 * Keep ML management Tx on an active link only when mac80211 did
+	 * not request a specific link and the selected link is inactive.
+	 */
+	if (req_unspecified_link && !(vif->active_links & BIT(link))) {
+		unsigned long tx_links = vif->active_links;
+		unsigned long peer_tx_links;
+
+		if (!tx_links)
+			goto out_keep_link;
+
+		peer_tx_links = tx_links & sta->valid_links;
+
+		/*
+		 * Prefer links that are both active on the vif and valid for
+		 * this MLO peer. If no overlap exists, fall back to vif
+		 * active links.
+		 */
+		if (peer_tx_links)
+			tx_links = peer_tx_links;
+		else
+			WARN_ON_ONCE(1);
+
+		link = __ffs(tx_links);
+	}
+
+out_keep_link:
 	/* Perform address conversion for ML STA Tx */
 	bss_conf = rcu_dereference(vif->link_conf[link]);
 	link_sta = rcu_dereference(sta->link[link]);

base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
-- 
2.25.1

