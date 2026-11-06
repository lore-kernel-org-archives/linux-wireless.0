Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952018;
	b=Suedqd0c3wUl0R3PUwoUakQzoLIqa7ru1F6NPz20SjG2F9A5QCJtpObRSvASecMRlIx8
	 fHVCbT0+JPhYpFfoBKz0tgB3p8wj5k6EADH+9BfwquEvs87k1pP7cdwEF6g5uc8b0Oyfu
	 us64zrLyS8FXjObmrmtIehjzzquhFLRIZEhM5WGPLibBIdL1VKR3IIRqWdGLOMQ17cMkG
	 1s+bMI4ZR7ftMMmM/lUorbkvcR1qyV2slUz7rOHylHrgtXUmLEYkpwWgF4UaU2+att+/N
	 ozUtWKaFoBYBC8ss10szXJ4+yKm8+u83g8P1yF5wcFnMgccU/W8IL2byqJLiYFoMgTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952018;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=;
	b=fbmrWK5g6+FubSKhuXvf72nPrvYYWKUrzo8Ip4wo4RRfueg2tdsnv0wH+Oa4n9zgSnKY
	 2tJ+UyDQrWBKQibAVU/mE9wzKeKRatd76RDYtSFOaS9673OTnBunMs4s1h7AE3JAbnOP5
	 6lUDKDlYmURRu7swBWh5l12M4SdajlGBniVHkEAO1sUNY68wnByHZAuwXn1IT9a+uKC/1
	 CqnJLm0tHEH5x9zcqQtr6uFnabztVcveJhhoCXxmLjLXO8EPeh2nCbfURAe4dt12vGcNI
	 D0jCeQvxUAMgigCcV6sxoYb8vmrbioWtNsQf2iJ/mZJUKPi8DARwiz5veo2KOK78s4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="LR1qLN/t";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S6MXPMKR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3091660A6F62
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3091660A6F62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LR1qLN/t;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S6MXPMKR
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RR3P3907026
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 08:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=; b=LR1qLN/tU73F3Gkq
	k8v0MxFRZ76oZ9NtwBSuhDPrkexkNtHP4sV4RroZ70A1inE6zZZkBZyc5FJpGEFL
	gJewIsCBx44zb7t7hOLuc6YYum1+fGxmjPg+xRyP1GOAsrApAOkl4Jv5KVB4NBKH
	r9LZ62OuSyAomAaJl7eZnKKwQ+CfxMbEDRWyYCrLB1D0LFGaauaebGVP6IT8d2aa
	EkNgiUoU1LGzgOZbOtAi4Og0R6hTa1ZFry1RAueNA+DvjyVjf60pTxNa/Fkhyglj
	mIc6bTmHMAH07XiY82sCm9LUgRnjk/sGJLUVErPdxR+R5pRcuNpztF+doFciDSGZ
	Vg6Esw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pasqn9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 08:00:16 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b0a528ca65so409685a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 00:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793952016; x=1794556816; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=;
        b=S6MXPMKRogvMDAAcuY8iw6udsD3b9dq+vaS0BXJTrYj1fX4T5cYJRFCbZOLYIDv0RR
         phfbHklklvsT+iEscjKxs4hNopksVtCb8u/jSZ1SEMg8z9dFEpKiscYQlqgwKuU9Kkjz
         RSaaTtHflppZj9jOPgllOtKsvWa5pNfMUZxQP9ZYIMxmimTD0yr2HGr9hXjrV6NI+oJm
         RcS6PENH69+2MqRZ9kjQGe/gz+VFh2UjkG3UdquUuxEsjEEG/jeHK3SoKOZtIo1Wc6Ki
         zCD21omiTtFHcKoGNPKpakkm/l1deaqYVdM91AxVPtS+4O8JZ6+H2yUVsQGc6l/WGrjA
         bSzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793952016; x=1794556816;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=;
        b=YYd05LwnleHi8D5OglEz0W/CR0h3TcV92X3RLMcfhxxe+tsLxsEFjJCdudKzlMbGEU
         eOB4Fy5CtG2GtwF0ZaROGfxaWxsYLlzCHz2nkkXVv/ql+F9JHa62UV3OgMM4vhdh/QaW
         n1EmgBrdTyiiQVq77+L9ramIFU67vt+SHEsiKMDun4+RM4ZpyNAPDqBlRsV8OV41TD2Z
         zHNAobD/xiPnIWVTcI9uQYEdz18tBaEKNdvV82B5yK8KycpA+tPv5bSRJc5UXFa52C53
         4Sl1vX/gzV2ogpxnUj9eRefW3OEOqnqjkcFSzpr6lsZ97wulnVGuZf9RW9/YbIGe92rf
         pTkA==
X-Gm-Message-State: APuU4Z8AO7XzeOLbePVDJ0bRGrKB6Li8uId5gIaARRwCSdSIu6hoj3io
	CqcNiOQN2S26dKqmd002YMSpbC1A+ZKCMKlpKeLAQtKU3aT//yA2U+lbtjXhRb77Fok+hVTj2Ua
	eQzAwpmKxQiulTmmHAB8GY/TfPyYTYS987gVzsKNk3ybZWMyCFhPxLGLjOVatNz0Q1DVM
X-Gm-Gg: AYBFou1yxsnHL7lXu86DHDWq4qUME+8udppy+jYRvG3WKZ6u7/1BvtNgCgNTlaQUnlO
	WK1nOBRfh/qZEZizaNPcuuiGWado0KAauhjFcQLrvSZ71D1vvv3vRas9vVL0D86krg4TqhaBSLS
	yQShfSY5NEHpbqSIpXf6g0YhxWcs0UnozNcN7QYoPU/w1gB+/Ue/obiVXI1eceF0wh/G7ZIcGnl
	2ltIZdiQ59MzBFLbyOZvWnZZ1ywpFLUgdcDsZCADqjRMAsKPErrBnZ4zQTX/mEYqFC6hny0h4eU
	gecfn0et8sZNpqbRivekBGvMbr8ideWo+cD7orB9xnvWsgYn+QLZCymkIBcAk5MtBdb9OMqEij3
	PwZxkJIGuDy00TZcvhpt3PhKzGuY595eFxCM4Ex41DRHH5YxhSuz40EHDrmP5Aw1EsRqnUReLaa
	SVxdzg59CaBoNxLwpv2tt1o/guBTPYiRnOvCJysKNTlzVWGdcB3v2w2BqVM3GzU/iSxdnO72s=
X-Received: by 2002:a17:90b:384f:b0:3ab:9c73:12f with SMTP id 98e67ed59e1d1-3b0db6ed91cmr1591297a91.24.1793952015306;
        Fri, 06 Nov 2026 00:00:15 -0800 (PST)
X-Received: by 2002:a17:90b:384f:b0:3ab:9c73:12f with SMTP id 98e67ed59e1d1-3b0db6ed91cmr1591257a91.24.1793952014658;
        Fri, 06 Nov 2026 00:00:14 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.06.00.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:00:14 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:58 +0530
Subject: [PATCH wireless-next v4 21/21] wifi: mac80211: define API to
 invoke SMD Drain Completion event
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
Message-Id: <20261106-smd-v4-21-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX2/T+yv0fAmAF
 W+ig8vDccTJ5t/+WlGljPoq2hmHqpeD2TKgrqkOIqqv4BwN/bQaYGpyx/umjNdwZDlWbZYgF97b
 sFvO/s5i7Dw2iZ+s8IPHoO7kWd3UDQ0UL5dT6ruR0i18mZmyarQYkRPN0ttWEpccDdCD3ToT1m6
 lfAHH0SgUNiZzZIFpdZUaX9KONGJL0kGTMZReuI3XPg3xNEuDkUDm+NlQ6ShPCNXrbKMGiSOGTa
 Tk6CvKJoRG3XzbCGwOGefluJkBRcNz+knBqn6Hkm0kwbTq2uoj/UcOrSklwuT5zEShkUwLnccrQ
 OMMEkhx+IE8LxMy0iuBLPc7+vj07ib7kxVRM6CWDmH4g5BV6z/myyFrPmusdvEW5sQzHConNe/g
 yu29rvxcWMJIc3hYEnBb0tnAPapboR8+7fGHByV8Sr9ZafdS9GqkYbvRwcJDIJBFNJ3uwH/or8U
 Ac0+oCYLRZq5i4RVbxA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX+WECN+psVHyv
 iShkdLhOjhN7RWMVjjuRCiaeIHRpwLX4FvH9qHYuC4Xzjx8sG4kgGsibrbBXI2mARfRz5+8QmLl
 Rivd/41U1fMAOwZKs/rlLsn8CE992uo=
X-Proofpoint-GUID: DPHKTMOhNTcZQNvHq4cLN42hfhN4mmjP
X-Authority-Analysis: v=2.4 cv=P4ivFSAu c=1 sm=1 tr=0 ts=6aed8910 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=nYjsN70XfsUJIUWl-YQA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: DPHKTMOhNTcZQNvHq4cLN42hfhN4mmjP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060031

To indicate userspace the early termination of the DL draining period,
define an API for drivers to invoke the SMD Drain Completion event. This
API makes sure that the non-AP MLD is already in the DL Drain sub-state
(4c) in the first place to being able to terminate it.

Suggested-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h | 16 ++++++++++++++++
 net/mac80211/cfg.c     | 18 ++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d78b7e897230..7dc7d1a7a1f8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -8331,4 +8331,20 @@ int ieee80211_encrypt_tx_skb(struct sk_buff *skb);
 void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
 				const u8 *sta_addr,
 				struct cfg80211_smd_transition_info *st_info);
+
+/**
+ * ieee80211_notify_smd_drain_completion - notify downlink drain completion for
+ *	an SMD station.
+ * @vif: virtual interface
+ * @station: non-AP MLD object
+ *
+ * The start of DL draining will have moved the station to SMD sub-state
+ * %IEEE80211_STA_SMD_DRAIN. Hence, drain completion is valid only if the
+ * station is already in this state. Should be called under wiphy_lock.
+ *
+ * Return: 0 if success, -EINVAL otherwise
+ */
+int ieee80211_notify_smd_drain_completion(struct ieee80211_vif *vif,
+					  struct ieee80211_sta *station);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 26ebbc27dac0..0aafc7ac771c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6423,6 +6423,24 @@ void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_get_smd_ctx_done);
 
+int ieee80211_notify_smd_drain_completion(struct ieee80211_vif *vif,
+					  struct ieee80211_sta *station)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct sta_info *sta = container_of(station, struct sta_info, sta);
+
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	/* doesn't make sense to terminate if we are not draining already */
+	if (sta->smd_state != IEEE80211_STA_SMD_DRAIN)
+		return -EINVAL;
+
+	cfg80211_notify_smd_drain_completion(&sdata->wdev, sta->addr);
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_notify_smd_drain_completion);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,

-- 
2.34.1

