Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62733E9C0E
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043711; cv=none; b=naHmCUb2ldjVHoKhF9+nPBDw99OVMrH6BzZoeFa/ci9RKV7hK3kcE2qGX/DQHydxXBlyfaJWqx8djteT274UR9jtTOW/4xFNGGJrWGOqSziJEXC4r9hlRlz7MMAzLLp54w4CpYCbla+qndlJN67mz1If0KpkBg2YxoXcg0Yo0Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043711; c=relaxed/simple;
	bh=I8Ld7Vyqgamh4lmI7ipqPAom282aTNrWwYsrYuUQB98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZwFY5Mcw3KjBUxqnye1mJvsYFhB1ZBCyzv2Z/JV13uEX742wxp7RFiTvBmJoGgSghwliqE6wg+ZOssVBGTRrjvE8qdxhTxCt9WYIEN9/unqrPdOlZaruINUMGJQ/aog2nz4tMBmK6FclvToZYy+iHXXVKrrEpIfOUqIPOaMMwmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nhXATKdF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XFTsDT3u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nhXATKdF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XFTsDT3u"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F1Alrh3468841
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=AThD4YDvNlB
	8ycW1hV8nkngdrHMa5usDRa+Wt1AVu8U=; b=nhXATKdFK4Jr7sQY/w3UdWIInrz
	fGOHmlSsmhXYiNbGJEIZOj/zOaRD9i5N6kqvyKvFhtKnQNtGUaQNrJwTSTgmUfcP
	iiVqXJQv/CuLe1YYj7nnlphynT9tGW/eCHJbMaA3lLlK5JpDMmKy1t1dYXZp0E1v
	biazwqdxQ7g/GH41XMIcCagJOKGln/cSkfRWZFwKHOMaCw1QgpEtqXq3KuWYqEqm
	uHbbToYx5JuiStg1pQxWazLl15KM5CxKnriPZIUSpAyOWJc5lyIHimjx+o3yZ1rW
	iT6J1+QLjtH1Mh5J1Vj/nO80wzDs71A0Uqwo76O3oUEKfblyswU1iZ5S/tg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hadd7am0d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:08 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac6795617aso1139580a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043708; x=1792648508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AThD4YDvNlB8ycW1hV8nkngdrHMa5usDRa+Wt1AVu8U=;
        b=XFTsDT3uepHfcx+Rh7ejGyBIX5sON1dPisOWtjlRAJSZdOFA1kNR/YCSOJUa+XCeCW
         PhYkX5Nej9QNKNWIpuJeN5Z1vnoCao7ScrQXOiUKjp3kxlmJtT8Bq3y7rFnAtMQ9Rk5n
         /0e0Dhg4NxKsmJ5nBLAHQuYnQorN0zijTkdCLAuaOBlU6gt1K5psYDm3V5080OQsBEZ5
         KuDpohJqpAfMyEpHanXLGUM4iAeumDVbBZ9R1K91HxAzJJIYxkdIoHc2V6DPOJY7q4Ab
         xllDQEJ/XylTrmlFuw8niBuXxC/z1kCKAdS+iYL1vUufrTAOm53a5YreCvFap71Nwdgr
         vW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043708; x=1792648508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AThD4YDvNlB8ycW1hV8nkngdrHMa5usDRa+Wt1AVu8U=;
        b=ypftPzsKr1XPxekce2uVhWpWHymTio/lgAXOWXzkgm/34iDJmswWliB/y9KmOo/8k8
         +BfPmuEUrH6cl+bGrqohHOwJTJBUokJUxdUQxqJg1lQ1WNOXr3iu1HoeY0KBdJoO2dBt
         +KEETkiJB0Nu5KtsniewU8/GJyzEHyt2wfTxvyDdxaucgCSczvBTpNG7Wk0eltb+oZkp
         ovRnPGcr2pYg1gx1w9M0GqfFR4nCttPndrgn1sq9RJXq2sHnaPnRIoWWFabSqjsdV4e6
         rVEXBEFbtkN9LxGadiNS0WfC5M28UG0YpemAAJqfRDmaNH7E13AOTxE/Qxv6VTvwrC7f
         U0aA==
X-Gm-Message-State: AFq9FYIIW8q9nr/Zorkj+jDFIuAg1fTNhR4LoC7ZEWwqj5ZyPyu7n2Ei
	ewQJf8WG3o14UARJ6bj3Y7FcWFYZjlztA0QwJSf73j6/NOfdsBEpZ1lxreJN7ccY6AxpjLnEFYj
	LYgthTsJvFSFhWfLFJSQ0po9lgFGX6eu7ZJkGdVgPCW7eCsks3nt+k9TOmWz6FcLBd9154w==
X-Gm-Gg: AYBFou227Yl/9IQNYBoR2kiQz31Xal75hbLattJwllWGwOQPr/osV6OSR1alf2F+f/P
	IX6tQnV41f4rgythFYEO87Vw0RY9xRHH+gZ/IPXpsR0/ysNHGdJriC6X8nVMGPBtqKnRkxa9Zk6
	YFSZBLEBYqYs4brhsW0i4PL5X7+/QS1VEl8Atl4E+dpNTA9Ijm3pBWpxfSNV7ATFLVBNy9BLMjY
	6J1QRkvkmMpb3p5DUJdZbwnvryq/OEbj7Jm2TIkE9LUHZ7CfdFLaBKATC28NIQoJj2F8hV1PyuF
	vrM3CtXvlWLdENcuVbLn5jBJPe/JxV14G3vuwHaxr/b2Nn56U4f8/NCwRq6W2yxHPs+zmWm9LIQ
	b8PiDngF3QGOntVUp4zbAfzyxC3fjRTGmjfB8t6c74NgJpEIXH7Xk5l3DbLQWy2bAiZ1R4aLHMl
	elqQYO3RZQmvnq
X-Received: by 2002:a17:90b:1d4f:b0:3a8:7242:e8d3 with SMTP id 98e67ed59e1d1-3ab3a2910f6mr15133490a91.7.1792043707930;
        Wed, 14 Oct 2026 22:55:07 -0700 (PDT)
X-Received: by 2002:a17:90b:1d4f:b0:3a8:7242:e8d3 with SMTP id 98e67ed59e1d1-3ab3a2910f6mr15133471a91.7.1792043707347;
        Wed, 14 Oct 2026 22:55:07 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:55:06 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 5/7] wifi: mac80211: track QoS Management station state
Date: Thu, 15 Oct 2026 11:24:39 +0530
Message-Id: <20261015055441.680588-6-aishwarya.r@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=BaVNQbt2 c=1 sm=1 tr=0 ts=6ad06abc cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=JzGhbOYYILsv2X2EDKgA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: by5fNxt_eaLk5DwdAWrImJuJcMemov0b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX7xgJLkBXN+kw
 RHwHanrAW1M0nCSgoiLgNun4FeJcjX+yTQ7dzMB/qMH4eJ2REd3268Q8MHhr8FaXGuU6f+FDq6v
 qALhkGo6UqzPmqQVIoXpfrjI1NoAsH1RqiISz9Voa8LQJqCppCjVOMIXeX37bLjVeLg4YnEYq8R
 CPt9WjJO99xvDH7kXbHILdN3DG7jwLlHGObMkkzlxVVdcESN0CQsQWD/rJjkGmsGF1BG+qJFw1M
 7DwWMvnOIkKRXn+/i/3pXT3H+1KJVf0xbL7/CLpvFdCWmJop+tZKBWv8lJ2ijW3dUrK/fGeWzOo
 dva40as7+GVnp5+LZYCSLEM0lNu2z6Tem5L09sliEKB5Xd0n7AA38eSvZkvhDf3vEB+DZG7Iqo+
 L2taNEKSeJcndFmoIMa2XfEkIgVsx22hUIRzNEMqI5o/pmHzuw+i3IzrKYycnoyN2mtc77pCCDO
 YHim+FNQNfLzbokbqVw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfXzPzD9OEadeef
 J92bmkRlYjHJWLCINpaV3bO0XJmNIYX7OjPuBfBx1V4akzuZMOoDmZzJFOjzxlk2VihK5AktW2X
 fWGk/D0c2cF2/Y+joBn4APUJKpu3uZg=
X-Proofpoint-ORIG-GUID: by5fNxt_eaLk5DwdAWrImJuJcMemov0b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150023

Store accepted SCS and MSCS configuration in an RCU-published
per-station object. TX and RX paths read this state without taking the
wiphy lock, so replacing the object and freeing the old version is
deferred until after an RCU grace period.

The state is updated after successful driver processing.
The QoS Characteristics element is specified in 9.4.2.326,
IEEE Std 802.11be-2024.

Retire replaced state through RCU and release remaining state
when the station is removed.

Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 net/mac80211/mlme.c     | 150 +++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.c |   7 ++
 net/mac80211/sta_info.h |  21 ++++++
 3 files changed, 177 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e476c6b9cb14..2d853cd1c18a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -12037,12 +12037,119 @@ void ieee80211_sta_rx_queued_frame(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static void
+ieee80211_qos_mgmt_update_scs(struct ieee80211_sta_qos *qos,
+			      struct cfg80211_qm_req_data *qm_req,
+			      struct cfg80211_qm_resp_data *qm_resp)
+{
+	u8 tid;
+	int i;
+
+	if (qm_req->qm_type != NL80211_QM_TYPE_SCS)
+		return;
+
+	for (i = 0; i < qm_req->num_qm_desc; i++) {
+		struct cfg80211_qm_req_desc_data *qm_req_desc =
+			&qm_req->qm_req_desc[i];
+		struct cfg80211_qm_resp_desc_data *qm_resp_desc =
+			&qm_resp->qm_resp_desc[i];
+
+		if (qm_resp_desc->qm_id != qm_req_desc->qm_id ||
+		    qm_resp_desc->status != NL80211_QM_STATUS_SUCCESS)
+			continue;
+
+		switch (qm_req_desc->request_type) {
+		case NL80211_QM_REMOVE_REQ:
+			clear_bit(qm_req_desc->qm_id, qos->active_scs_id);
+			break;
+		case NL80211_QM_ADD_REQ:
+		case NL80211_QM_CHANGE_REQ:
+			/*
+			 * For legacy SCS the TID is derived from the UP
+			 * field of the first TCLAS element (11.25.2, IEEE
+			 * Std 802.11-2024). For 802.11be SCS the TID is
+			 * taken from the QoS
+			 * Characteristics element (9.4.2.326, IEEE Std
+			 * 802.11be-2024).
+			 */
+			if (qm_req_desc->is_qos_present)
+				tid = qm_req_desc->qos_attr.tid;
+			else if (qm_req_desc->num_tclas_elements > 0)
+				tid = qm_req_desc->tclas[0].up;
+			else
+				continue;
+
+			if (tid >= IEEE80211_QOS_MGMT_MAX_TID)
+				continue;
+
+			qos->scs_id_tid_mapping[qm_req_desc->qm_id] = tid;
+			set_bit(qm_req_desc->qm_id, qos->active_scs_id);
+			break;
+		default:
+			break;
+		}
+	}
+
+	qos->scs_enabled =
+		!bitmap_empty(qos->active_scs_id,
+			      IEEE80211_QOS_MGMT_MAX_SCS_ID + 1);
+}
+
+static void
+ieee80211_qos_mgmt_update_mscs(struct ieee80211_sta_qos *qos,
+			       struct cfg80211_qm_req_data *qm_req,
+			       struct cfg80211_qm_resp_data *qm_resp)
+{
+	struct cfg80211_qm_req_desc_data *qm_req_desc;
+	struct cfg80211_qm_resp_desc_data *qm_resp_desc;
+
+	qm_req_desc = &qm_req->qm_req_desc[0];
+	qm_resp_desc = &qm_resp->qm_resp_desc[0];
+
+	if (qm_resp_desc->qm_id != qm_req_desc->qm_id ||
+	    qm_resp_desc->status != NL80211_QM_STATUS_SUCCESS)
+		return;
+
+	switch (qm_req_desc->request_type) {
+	case NL80211_QM_ADD_REQ:
+	case NL80211_QM_CHANGE_REQ:
+		qos->mscs_user_priority_bitmap =
+			qm_req_desc->user_priority_bitmap;
+		qos->mscs_user_priority_limit =
+			qm_req_desc->user_priority_limit;
+		qos->mscs_enabled = true;
+		break;
+	case NL80211_QM_REMOVE_REQ:
+		qos->mscs_user_priority_bitmap = 0;
+		qos->mscs_user_priority_limit = 0;
+		qos->mscs_enabled = false;
+		break;
+	default:
+		break;
+	}
+}
+
+static bool
+ieee80211_qos_mgmt_has_qos_char(struct cfg80211_qm_req_data *qm_req)
+{
+	unsigned int i;
+
+	for (i = 0; i < qm_req->num_qm_desc; i++) {
+		if (qm_req->qm_req_desc[i].is_qos_present)
+			return true;
+	}
+	return false;
+}
+
 int ieee80211_qos_mgmt_cfg(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_qm_req_data *qm_req,
 			   struct cfg80211_qm_resp_data *qm_resp)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sta_qos_rcu *new_qos = NULL;
+	struct ieee80211_sta_qos_rcu *old_qos;
 	struct sta_info *sta;
+	int ret;
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EOPNOTSUPP;
@@ -12051,5 +12158,46 @@ int ieee80211_qos_mgmt_cfg(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return -ENOENT;
 
-	return drv_qos_mgmt_cfg(sdata, local, &sta->sta, qm_req, qm_resp);
+	if (qm_req->qm_type == NL80211_QM_TYPE_SCS ||
+	    qm_req->qm_type == NL80211_QM_TYPE_MSCS) {
+		new_qos = kzalloc_obj(*new_qos);
+		if (!new_qos)
+			return -ENOMEM;
+
+		old_qos = rcu_dereference_protected(sta->qos,
+						    lockdep_is_held(&local->hw.wiphy->mtx));
+		if (old_qos)
+			new_qos->data = old_qos->data;
+	}
+
+	/*
+	 * SCS descriptors carrying a QoS Characteristics element
+	 * (9.4.2.326, IEEE Std 802.11be-2024) require hardware-specific
+	 * scheduling support; forward the request to the driver.  Legacy
+	 * SCS and MSCS are handled in mac80211.
+	 */
+	if (ieee80211_qos_mgmt_has_qos_char(qm_req)) {
+		ret = drv_qos_mgmt_cfg(sdata, local, &sta->sta,
+				       qm_req, qm_resp);
+		if (ret) {
+			kfree(new_qos);
+			return ret;
+		}
+	}
+
+	if (!new_qos)
+		return 0;
+
+	if (qm_req->qm_type == NL80211_QM_TYPE_SCS)
+		ieee80211_qos_mgmt_update_scs(&new_qos->data, qm_req,
+					      qm_resp);
+	else
+		ieee80211_qos_mgmt_update_mscs(&new_qos->data, qm_req,
+					       qm_resp);
+	old_qos = rcu_replace_pointer(sta->qos, new_qos,
+				      lockdep_is_held(&local->hw.wiphy->mtx));
+	if (old_qos)
+		kfree_rcu(old_qos, rcu_head);
+
+	return 0;
 }
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5c95ffee257d..e714b719e2f1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -467,8 +467,15 @@ static void sta_remove_link(struct sta_info *sta, unsigned int link_id,
  */
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
+	struct ieee80211_sta_qos_rcu *qos;
 	int i;
 
+	lockdep_assert_wiphy(local->hw.wiphy);
+	qos = rcu_replace_pointer(sta->qos, NULL,
+				  lockdep_is_held(&local->hw.wiphy->mtx));
+	if (qos)
+		kfree_rcu(qos, rcu_head);
+
 	for (i = 0; i < ARRAY_SIZE(sta->link); i++) {
 		struct link_sta_info *link_sta;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8942541375b2..68acd8fdc671 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -16,10 +16,29 @@
 #include <linux/average.h>
 #include <linux/bitfield.h>
 #include <linux/etherdevice.h>
+#include <linux/rcupdate.h>
 #include <linux/rhashtable.h>
 #include <linux/u64_stats_sync.h>
 #include "key.h"
 
+/* SCS IDs are in the range 1-255; zero is reserved. */
+#define IEEE80211_QOS_MGMT_MAX_SCS_ID	255
+#define IEEE80211_QOS_MGMT_MAX_TID	8
+
+struct ieee80211_sta_qos {
+	bool scs_enabled;
+	bool mscs_enabled;
+	DECLARE_BITMAP(active_scs_id, IEEE80211_QOS_MGMT_MAX_SCS_ID + 1);
+	u8 scs_id_tid_mapping[IEEE80211_QOS_MGMT_MAX_SCS_ID + 1];
+	u8 mscs_user_priority_bitmap;
+	u8 mscs_user_priority_limit;
+};
+
+struct ieee80211_sta_qos_rcu {
+	struct rcu_head rcu_head;
+	struct ieee80211_sta_qos data;
+};
+
 /**
  * enum ieee80211_sta_info_flags - Stations flags
  *
@@ -657,6 +676,7 @@ struct ieee80211_sta_removed_link_stats {
  * @rate_ctrl_priv: rate control private per-STA pointer
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
+ * @qos: RCU-published QoS Management state
  * @drv_deliver_wk: used for delivering frames after driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
  * @_flags: STA flags, see &enum ieee80211_sta_info_flags, do not use directly
@@ -728,6 +748,7 @@ struct sta_info {
 	void *rate_ctrl_priv;
 	spinlock_t rate_ctrl_lock;
 	spinlock_t lock;
+	struct ieee80211_sta_qos_rcu __rcu *qos;
 
 	struct ieee80211_fast_tx __rcu *fast_tx;
 	struct ieee80211_fast_rx __rcu *fast_rx;
-- 
2.34.1

