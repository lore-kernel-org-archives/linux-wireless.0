Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A4E255F2D
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043718; cv=none; b=lzy28sCa/ccvn2aIpEAS8PRh4HMX4GfE5m/7teWUH0hQpvOYt9YHCI37PVqs9SIm1HLJTIWpojJo89LOdvbqYNntIGo7wNGkEGItXf++bQCTv2tqjDXi1p7sCJhSmpaY8flEyzYKQK/i5V+RH6zETwLkktnFKubMiT1KiGB7teA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043718; c=relaxed/simple;
	bh=NoA0Zgx3pbuSCq7OsCJB1CQu2VNOv9I8yK7cUDPmq9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xlx3XJxIflCRwhEEGQJgXzmE/Y5sDeY8RLX5ux7fMWmFFkA0D+QcKdbDuqchorBpgstG2bzV37ueMg3j6ws7e7lNhyPLttlOuN9MmJjl2yrg6fq7dSnpIcZkRyu2BRJhY3uEnVRWS674/kOELcdnzvIBfkmITUmNrLj9ASiefLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NhLHR6MC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fnVqij5B; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NhLHR6MC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fnVqij5B"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F2CsDw841915
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=HVkyH5fBnno
	8rvF+QGON+Gu3ek/3SzX0muTsSYISQOE=; b=NhLHR6MCbb0mNC1wLub/2DsJD8t
	hOEip//8Geedm4GOf5AAb4Q/biI8yalrfoycj8nzAwDZDBbiPaJua60ipy6uMmab
	rWvVxU3j66+MYvB9BDivljk+rfpzGsNpEoTnhXx0C4cJtOClBHssRQZFMPiJDP+f
	5PvSPcT2IaOwq5CfYupuRxahQPGGszYaGwQlpt+0fMqB9v5MDLDxIF8uKX7IHl1u
	ksPcspjP1w7TxY6FxH6aUIMGfhXT2SsmDsJ/axxJfZ6Q39ClolE+UwnODkA71pwx
	DKFzLNzp32GJ+8Ws+gu2OVa9YMt/JHj/bJ0oUQKYhva61wKtvFpBvajSjJQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hae4wtcdg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:16 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so2499149a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043715; x=1792648515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HVkyH5fBnno8rvF+QGON+Gu3ek/3SzX0muTsSYISQOE=;
        b=fnVqij5BmsnCiH5gxroSNc+zvCkfOqYzh5JpyCEWmYJFymU3uCnOk0PVAhbMu9BJ8K
         NRNzYY+0DaPykqxxH7kxgDYIs/3h3PAmoqGPEuLmV6ZX42o0KG2N2duxeHCYbiMrv5pI
         4O7wOFPB60wlpiO2DrjV+EZSDXaziJK/aAUd6jp1n07p/92dTUT9cnQwZ0ohbXSiUzQB
         ZvH2hn27lxs0kptMQrpaNpB0dNvQ7+l+/irti0DXXOOnLJqmXuM+cnN5OFvlXiH0SXaj
         CSPGnyjl1BYD7fYQbiYXdMYc83M+gfLiZjSLxKn7bq5CEkbGFXT3xJJS0Q2GAbwJV3gl
         Ncsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043715; x=1792648515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HVkyH5fBnno8rvF+QGON+Gu3ek/3SzX0muTsSYISQOE=;
        b=0Tt696hXdG/iaLrDdFXrhh84T2u+tPgn8LWOjuIwkh5hMkBnUBMZK7ZUw3iq9/ZxAx
         4CSB6v/EtaMgxtn8yiHCGO5sK6x9Sr6PRUlQeaY8zxbQoD0ap0IBIwMehx1W/x/EcO2I
         5DBvkXQ3/HkD+fSFIN8xLX7drYZGOIOdKn3OlLhf2WAOmrMM/a/daPIQwWu+/+rmQ5IM
         8PljL13ZsEbOzKOrrQ7u/MfC9FgjlSZve0Ped5PHDhlbaGKvHm6zpLcbTM1M2YP4Abl9
         LxaKnBShwDVmLm6gleSaSwC3x+tMDY5lH8Q6641p+noq8H6bNfw0BmOfZVVqxXBNuir2
         Z+Aw==
X-Gm-Message-State: AFq9FYLTnTJRY4vyjucpr1oLcKjdRx+Ti1vfBJ33ccqRBJ+1gF+t63EC
	TbSfOyhJW5zvIksdyA3llA1eq/5FdZxWb61BMxu55cXRsd/QhCOSZ2RShwEdN28wuEvaRMNSOXv
	36nl/Y67YMlV55ltU+gMWYVpzoq+ggKtONuXJlTz3Lvvk1Y23LICGHFHgCGE5XL6sGtzKEZyMTM
	cs5g==
X-Gm-Gg: AYBFou24YG/cZqdWd47pH1iK1+s8zfu+QqgXbMQwMDtqL2jhKnt4lPyH73aeKW+o6RR
	F0nJ7IvNxz8urmup7by7ayav/ZnSyUkSJWvwTBEHFpxOvw1eLcUbV6SDsbUZm1necNeJpgxPDsr
	uSvVy5XDusyIRMFKfOvKGHZ3Hms0POJowdtxEKhfFhOK+ML47B73KkizIFtHMg4vnwIiCZIywbQ
	0aR++HB0GdghvMBCvJPRhXS8ZrGOM65dSUWtYyZohxuJiUBPYXn0BYY7DkKdaVl2ryAz2hTKnHE
	jzS52ocCUW45mz787/wNdFU9GCe6lccDruUKPkfFXBe9CS9wiLzrySmJeNhEM8XxS5M257Mwhdv
	BCFxma0eIsM1Zdi8+I87OzWUOKRUF4/BaaVpSpOug1x+iySKzHJzb3ADtYYAwbIcpDYjnV8ANk3
	upgzUOq9MBVwwx
X-Received: by 2002:a17:90b:3b41:b0:3ac:9f24:44df with SMTP id 98e67ed59e1d1-3ac9f24469dmr752586a91.2.1792043715099;
        Wed, 14 Oct 2026 22:55:15 -0700 (PDT)
X-Received: by 2002:a17:90b:3b41:b0:3ac:9f24:44df with SMTP id 98e67ed59e1d1-3ac9f24469dmr752561a91.2.1792043714598;
        Wed, 14 Oct 2026 22:55:14 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:55:14 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 7/7] wifi: mac80211: add MSCS packet classification
Date: Thu, 15 Oct 2026 11:24:41 +0530
Message-Id: <20261015055441.680588-8-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
References: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX+8Ypu+jkpfLH
 srm6WWiCyeSqbeP6l54tlP1mh+H8rnIF1Z6l4IGTvha+ohYDjBp9Ab8kNi8snWbqIhNExUfHuyS
 rt2FfBgvNkgqlXaP/5CVLpbojukue34=
X-Proofpoint-ORIG-GUID: dk5QJLeWgZX4uEJnhcWKU28a9Qn2QwrC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX3AgE3cD8nPBE
 Vt7+y5rWXcQBH+zXNnng9XQ8JkDf6ucUdjKUv2mdeE05CBrucP0UKKu6pvLMLb+mOYJhGIjoRNl
 2iSpUKMRnQOG3o115YeXv5bhIBPHiRyCuStIPVUFKeQdevMzxtMmchZrxd6RoH7Cqj0OYM5xIhT
 KnAgec1XiFIth1csfKlawLUg3+oZpwgyyZ302jzmFXEANs+sMNQww6qR0gvWPuVGrSX1XfcGDSo
 8SxCtGFwumOUDguWG5xGSOhZT8XKgpaCmYMUbt8hQdDZvVeSdNDbg/IXwJ3JNLTMrQj03la5T8+
 8ZYQ2bFv5CgJeGrEfzVWRK6PZfdr3voc8eSq4+TZm5C6oORrM/XjtDUKLYTFCA7oMAQK1oUArYd
 Hb0D8Bkk4Lx2sOQHvib/aIyWpqLx44Qu7ZdVdiANnD6kFPJw4tjn6CqfsfWmh1yjb4CubKQTNA1
 qBatKyyR6+u30ywXugg==
X-Authority-Analysis: v=2.4 cv=E8BYNqdl c=1 sm=1 tr=0 ts=6ad06ac4 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=5lvf6Gdja_tK7i9YIxMA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: dk5QJLeWgZX4uEJnhcWKU28a9Qn2QwrC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150023

Use the negotiated MSCS configuration to classify uplink traffic and
enforce the configured user priority limit during transmit queue
selection for AP-forwarded packets.

For packets received from an associated non-AP STA, the RX path checks
the received user priority against the negotiated MSCS user-priority
bitmap. When a match is found, mac80211 records an MSCS tag together
with the received user priority in skb->mark.

The received user priority can be associated with a connection by
copying skb->mark to the conntrack mark using nftables. Since the
conntrack entry is shared by both directions of the connection, the
stored metadata can later be restored into skb->mark for corresponding
downlink packets. When such a packet is forwarded to mac80211,
ieee80211_select_queue() consumes the metadata from skb->mark, applies
the negotiated MSCS user-priority limit, updates skb->priority, and
normal queue selection maps it to the transmit TID.

Intra-BSS forwarding requires per-station peer isolation to ensure the
MSCS mark is preserved at transmit queue selection.

Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 net/mac80211/rx.c  | 29 +++++++++++++++++++++++++++++
 net/mac80211/wme.c | 23 +++++++++++++++++------
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ecee9348c70d..930de5b412c5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1003,6 +1003,31 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 	rx->skb->priority = (tid > 7) ? 0 : tid;
 }
 
+static void ieee80211_qos_mgmt_mscs_set_mark(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sta_qos_rcu *qos;
+	u8 tid;
+
+	if (!rx->sta ||
+	    (rx->sdata->vif.type != NL80211_IFTYPE_AP &&
+	     rx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
+	    rx->seqno_idx >= IEEE80211_QOS_MGMT_MAX_TID)
+		return;
+
+	tid = rx->skb->priority;
+
+	qos = rcu_dereference(rx->sta->qos);
+	if (!qos || !qos->data.mscs_enabled ||
+	    !(BIT(tid) & qos->data.mscs_user_priority_bitmap))
+		return;
+
+	rx->skb->mark = u32_replace_bits(rx->skb->mark,
+					 IEEE80211_QOS_MGMT_MSCS_TAG,
+					 IEEE80211_QOS_MGMT_TAG_MASK);
+	rx->skb->mark = u32_replace_bits(rx->skb->mark, tid,
+					 IEEE80211_QOS_MGMT_ID_MASK);
+}
+
 /**
  * DOC: Packet alignment
  *
@@ -3333,6 +3358,9 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 
 	rx->skb->dev = dev;
 
+	if (!port_control)
+		ieee80211_qos_mgmt_mscs_set_mark(rx);
+
 	if (!ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS) &&
 	    local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
 	    !is_multicast_ether_addr(
@@ -4996,6 +5024,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 	stats->packets++;
 
 	skb->dev = fast_rx->dev;
+	ieee80211_qos_mgmt_mscs_set_mark(rx);
 
 	dev_sw_netstats_rx_add(fast_rx->dev, skb->len);
 
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4d1bad27a8d6..feca08f28185 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -126,10 +126,11 @@ ieee80211_qos_mgmt_set_priority(struct sta_info *sta, struct sk_buff *skb)
 
 	qos_tag = u32_get_bits(skb->mark, IEEE80211_QOS_MGMT_TAG_MASK);
 	qos_id = u32_get_bits(skb->mark, IEEE80211_QOS_MGMT_ID_MASK);
-	if (qos_tag != IEEE80211_QOS_MGMT_SCS_TAG)
+	if (qos_tag != IEEE80211_QOS_MGMT_SCS_TAG &&
+	    qos_tag != IEEE80211_QOS_MGMT_MSCS_TAG)
 		return;
 
-	if (!qos_id)
+	if (qos_tag == IEEE80211_QOS_MGMT_SCS_TAG && !qos_id)
 		return;
 
 	guard(rcu)();
@@ -138,11 +139,21 @@ ieee80211_qos_mgmt_set_priority(struct sta_info *sta, struct sk_buff *skb)
 	if (!qos)
 		return;
 
-	if (!qos->data.scs_enabled ||
-	    !test_bit(qos_id, qos->data.active_scs_id))
-		return;
+	if (qos_tag == IEEE80211_QOS_MGMT_SCS_TAG) {
+		if (!qos->data.scs_enabled ||
+		    !test_bit(qos_id, qos->data.active_scs_id))
+			return;
+
+		tid = qos->data.scs_id_tid_mapping[qos_id];
+	} else {
+		if (!qos->data.mscs_enabled ||
+		    qos_id >= IEEE80211_QOS_MGMT_MAX_TID ||
+		    !(qos->data.mscs_user_priority_bitmap & BIT(qos_id)))
+			return;
 
-	tid = qos->data.scs_id_tid_mapping[qos_id];
+		tid = min_t(u8, qos_id,
+			    qos->data.mscs_user_priority_limit);
+	}
 
 	if (tid < IEEE80211_QOS_MGMT_MAX_TID)
 		skb->priority = tid;
-- 
2.34.1

