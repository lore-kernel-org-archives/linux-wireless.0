Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907671;
	b=1we8EJSOtyJE5GbrXREj8W+VBfQ/HCfB3FBWlHE77P8ImqOItBssZRI/XmySbB9//qE1
	 YNJg8n4005VfnlIWSMg2+Tjddl9b2Y+lg7R7tk65e/qAagLGYRfTI9mEn8dHRSMtcOhZ7
	 zNsaRh/rNMyzCO4h4C9RxKa2WoBtF98ZvWr050ocUzaRu7SOSF5zXOh67XJDa0DszAct5
	 SnMk1BaP7rouMy4zIYgq+mGymq4FtlzN/Zm0iPg0GkD2QKvSkqK8q6zzILEChe+/OtYhg
	 QAAUVIvV/AeUnsta5O+KnO7YK1ridig01HZJyQ1rqVCpwIatvTPlr52N71mw1Imxs+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907671;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=;
	b=LFtApTjc1JLnOoJngbTSD//DROjaDfPwVkKY65PEk7f5wAzvhL1ywGaAwMcoFTSnKb4x
	 S+cSFoGW+wSZeiHT0eynf+G/dXaGT1HQgMp2KUpIsV+mcr32kZlAjfLJt05+xZqfAcXxO
	 Q+X8VvPRPeu8sIPQNpb94FvIEPTcVlEGIv1ieu4obqu+Qf9wUgD7VxQy89mYGImOSoDEO
	 wcMBse/k5e5CONToAp7tSDrJRVkv+Ii1B3wN4/Tgnu4zlWeMtSnVg/J+bp8zBOX7J8C4a
	 Yam98n4UbvfXrfjvBi7Zw19d+7JgT4R6kVZsR4qfNgj0g88EjaRIUoeK8npWOmjzELw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="hM1BE/e3";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Pt83JV3p;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC99608523A
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:41:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DC99608523A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hM1BE/e3;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Pt83JV3p
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5JLEh5751780
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=; b=hM1BE/e3nJb1yPVm
	gltpwBnCPer+CUKLxXhP/1o/+7CqKER9WtxwhJ7tOpdIJXhsmgOA8DTsrLFH3Jqw
	uvOak5QUr1xgMI+8u3YqjeFgoKOxcSPf9dqQMIwqr4xYj8YBDfK9nQpldLBP3mDY
	Bb+iv+OHqNArPPEpmiErzcld4R9hv00wFLTrw/XwRFFCz6dz1vjzfi9bMJpOKV8z
	R1j9Kt4EHNGZrH4g74HCjX/Xx/tcm4r8ckAxmtdVQje0OKsCzyIUJW+PSir3pKWx
	/q2ozo1g9R7hbGb66OZhIsnyWtuSPXd1I5H0VjSrmRUNU1+2hmxqYJTMxmGPHY1i
	WQjdhQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hryvp82hx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:41:10 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36f479b9819so361443eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907670; x=1794512470; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=;
        b=Pt83JV3pI6AdVVEfM5SLN5hEzQEJwEIUhxSnztn25scVC4ZNFpHtdFQVBQDmkaF/S9
         S4coHp7xWffzuk7F26amEt6A3uGQi9KvVVlO4R+ja1v+STLLY6+ElgQ6RxzxFZmB3m3r
         BGyG8V2vV385g0POU+WbJLPxT4BDc8eHeY0OKq2Ti58KfoUrPso5H2oEKhtgtwhP4+2L
         25YaaNrNzRVaW4cXxmijEdLeIUQR+QcC1jW9ymX3Q+SmQVJe/1oILM3oa3JWClfYw26N
         avIQLTn+5n+rCtfKJZGpxx2e0wK5C9xFXU/MJGRibgwAWk9Ig8hopgXoDKIGVqZoyjB8
         5w8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907670; x=1794512470;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ht8qswRASt6Dpn6fB59EfVd1NELAZcR/5Got491fMHo=;
        b=gHoKeSCiSnFACF511C3KTgQ8m/bGnuYF0QGBQf36HFLWMQlzL3dNi5cRTxP8h56f5q
         bqmrGyF+oNWtv1Ud4zKYj5ycrv9mLv/Pgu9W/4xEI5C0DmO16ecSgB2ZPObA2CENClnR
         Ia0UtezePmbYSsOpHRlUtQ6KC/8mnwW+7fOiGXmY5vYir9/l0dBUESAe4M/mBClt1LiN
         asqILeAPTEzyxIkcNwdi8m8brARWH0lBsYc+maB2dAgbtNfYDzclDH3opAAjRdh2G1f6
         V6l8HY3HT3f2eY9u7ueymYBxdZTa/jhfeUQq3/5tsFedkROJx87oOqpq0weJ83xSBs13
         Rovw==
X-Gm-Message-State: APuU4Z9N1+ZiynoJPSH3Q45GCtf6n5WI+WuYWgZE+RXKyh1zbVv3hUhO
	lHdVHhv2zoP34E6V2hntZso4XZ0oVrifx2jRJqRxepio+svttChw038Hbmv9dnW2PBLUdzv/pOV
	GJzEBaRbJ/ZeaV64j72MR/3sR9+i8U0uGMFX+OBXSa2MWFV/quNCC89Zylz3jgpowUp/2PkmpsF
	F6
X-Gm-Gg: AYBFou17MhyR7luLCwhl5PAP79/KYaoCTSWbzyI0vyUkd7+xgscJyPu0ARkxS5oSEj8
	/PnGsf+q6vjOc8QB72+SO21j1vfG6fSXSUJ4DgMabBBdaJp6VGyQOwdS3m/HqxwwaeNh+/Cr1CT
	WeHasNe48qWBiypE76fmD+FOO+HvX5r0HNoaespa1nbq2sPCs35OmhmX64jOjs23hUZTl6mDx5L
	vjp75QTm9GqE5/juJy4JHADTky2MqHMshuTE5z/Kzf6eXRqT4dcgUMxWj51jMh8vUQDeyNS0gZ6
	cG+IJrzEZAgiL471SGuAQLP7UzVUPD6BdCG31AERHEeaR+ZnK9c004bPMSIkwz9h0UYQDJl51XK
	K/RazohU7VQEswnxKeVLMC8CuMX4mE7sMek1QYo+XF/A85N+NrWEjmnptsjfBKNFmjkkC6Z+kVx
	TXG2HOGC58YGGRvh5+KY/2S6PeXx3QcIvD17uIDtcbrW2RyTB0qI/g4CwT2hdZKpHiKjBIKA==
X-Received: by 2002:a05:7300:ae81:b0:36c:a390:8907 with SMTP id 5a478bee46e88-36f7611e32cmr181309eec.21.1793907669623;
        Thu, 05 Nov 2026 11:41:09 -0800 (PST)
X-Received: by 2002:a05:7300:ae81:b0:36c:a390:8907 with SMTP id 5a478bee46e88-36f7611e32cmr181260eec.21.1793907669049;
        Thu, 05 Nov 2026 11:41:09 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:41:08 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:56 +0530
Subject: [PATCH wireless-next v3 21/21] wifi: mac80211: define API to
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
Message-Id: <20261106-smd-v3-21-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=Ib4Symqa c=1 sm=1 tr=0 ts=6aecdbd6 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=nYjsN70XfsUJIUWl-YQA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: J-W9hV8M3mXfue4FK0_Q5TyidLFKvujO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX7RFx/SPW4zR5
 sfDPNlKaIOSCYSGZk/mj7OSzieOp/PR9V8WnMIdrPjsbRMpGDHXutvRlgecyeGcSEHoHmwbKh0n
 U4hel60tpQ72TPSsKOlPRKOG/E4nXeaNqEpmG8hKLlBm41EIDZc52ePMkBV/yJbYY8ygyaXkfUd
 OocBdnMNadOGwKqkOyTNqZJjQytRQ5gWJfLYJcS1fnJ7pGY60XGKHomILbBXne4qxQdqdvfDv26
 X/+MuSK8XPS1SXPlnIETnAJdOB5OdkSbYXF2mufVkYsg3thvxIVukgiWejfJSB4tFS3OiRMsGWm
 F88TcEi20Du4POKfmyszcicRiKEeFNFWQq0ycBz/nNEcyqy8aS1F3843zdAYhXtAXlfuq+XKjjw
 qgvBfKT6X9Yb25rBE16vhpNdXjLeWVkwEAUEaphhUOLJdrrdGDuwihlEi08oSDEYKlIIcno9SRn
 hIsi6iBvTi+pKqdlVwA==
X-Proofpoint-ORIG-GUID: J-W9hV8M3mXfue4FK0_Q5TyidLFKvujO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX4n2WXS/hxRmL
 SotZTOFcBBO50PKivRqRkeNGCTzZiLbnMHQndHRY/WdWBdpk1qxyYE9TozcVTGvxrAWLwVqVnyU
 xHxEeCpNan5o2WKMXqv56aOfxlMCxtc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

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

