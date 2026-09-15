Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4574A3822A3
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 08:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789459311; cv=none; b=ibjdtAkSl4GiNPPK7LFQhp1LjBBy81g9R6LHDMvFAciFmYNyMjoNHbtYMj2dMm+MtwKmWXVBSWcfvzUFRMTPS3CfoCkwQ4yBopm2lKenRtIsuP/ubelS3pRDPxKtJaMb0q7k6qZ5MQSEE7Zxxdg0OKEoiaZg+HVsBlvi5f3tcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789459311; c=relaxed/simple;
	bh=axkgfLly45euzCFhfRH5nps3GPcmIBsA55nYNTFGg8E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q+dSmluJ+5YsRdLWrg46ZFIurxXMSO97YoHwSPFvbCvrhf7RNRDsCMtmWx30ADqVIe+hi3e2TK6qd6VsW0gbG35I8ROsdqHAajtWlUbvBjVQHXLfOMwX3rqH5zJnvhrjpFZRlLkoCm44dEexDtznjwYQl36S/BaPFj/u+UP9cs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RlvxotWO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GT08QZ0m; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RlvxotWO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GT08QZ0m"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F6Yrfs4048580
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 08:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=oa6Q/1/UwGnZVW8dCztoYeJ9PNBU4QT7E+k
	pBF0tFpo=; b=RlvxotWOOPfbWaRAe7We+XLV/vySKZlt/Yb6HuaV356x08piRM5
	rPsWdPt4SL9LIbvBe+Cm+EbP7FgzXXT8E57d1Nxw9gqYcyUL1foWKAuYmifSotg0
	cUIUmaQijfxEKXz0HkL7uIaVn+otwCdtywpyq176XTnnOCV19fPoeIKREqBU8sE/
	aJYx7s2p17CU9/OgGeZqbvO1MD+9b4kcea5l7vFyNpW81wAoPHpttmNckTWJ9inl
	kglU37ZIHuyLjGiFzaVVmbhkvWcUt2AFa8aKIaIyH9n8wlk8eyr7ugb3CA/r/jOd
	PZGtIqgTC9zzO2+iSNugFMSFFowifFzsN2Q==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpyea0qbb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 08:01:49 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso7787818a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 01:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789459309; x=1790064109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oa6Q/1/UwGnZVW8dCztoYeJ9PNBU4QT7E+kpBF0tFpo=;
        b=GT08QZ0mHdYg5hRGp8VdderFfI9w92nCs9VzDnItIlwuOGN7ix3DnZwAQZAmiXB/B/
         0rpINfApPyb73YMEL8xrDOlozgaB9DJjF1rXNitgmVZ0tdTR1kLF6DGklnkaTdd6wfFK
         rmJNBYWUps1GuAD8pNltatbpe3skgNDkywg72F+tR789EheHXJAjKj+pIzyx3VWCInEk
         4ilt7ok7rVjB4PnmFZL38qkgPy7YWmnw/sEAyxEudnVEbWUm6YNBVYRLRoRxBWSmmCll
         47yBuyqlITXve1Z9rBXGIHkGRIxlc9NpR5Axhd+s3MxzGxsjkHQ2xER/rLlh554bhNtF
         Juvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459309; x=1790064109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oa6Q/1/UwGnZVW8dCztoYeJ9PNBU4QT7E+kpBF0tFpo=;
        b=NPf/uMJ3VEuTk0TyGtqsNF+7NWxHYwQyK775BZXV7nj2taOhnPOIwv7PDssInuxkNL
         Ep6KNuJiPVdbEHF3I41u16fFnfFoOr2jEMpwCrowGjIY2l+HdJ86STaoRMoriN48kzjV
         qyvIWMHRYuTXIw/qWuViCKQNdPDDMJVGP5Ef95rhofmK4vMIORA5EWHFoalxKNSjfvqn
         fJywSJixLB8EX6q07+O6jTMJBL5yP1GaIQWol3YTpYh46O0EnuWm8jvlVAegzcQNk21i
         YWqHHT93I15siT7tQgjp8jdvd/RZrjHCtpsTJ/j1m/leIvK8OhzgLIqH2DbLiMdhEGZA
         mP9g==
X-Forwarded-Encrypted: i=1; AKwUvBxPNOdysGfNSGVcp9k2bcAYba3aqtXze0RuL+4Km8jXz5nk6IkebCm3zWErMkHnP/MNekMuvyOOJABfiKxasw==@vger.kernel.org
X-Gm-Message-State: AFuF++kcA9nDyh1LK4kAAoNroJ49a6AOKEjrwMyLAYMpoGlaLbq92DGw
	eeQGV1Biij+vrvQlBIR6MtETVGd6+ChhtpW72Xcss8gafmyeBpimSMI1zleNU/mXYKfe7Phh0pz
	0JwNAydB1CguEWDbOPVjsidPMh3BX0iiZp4ykhO72HceoKzaVOIz8MwIoIvVqnTVH5OZ4zg==
X-Gm-Gg: AYBFou3/n/tS09SDOXp/dGDADEQrVTTMsn+1pQOrP8300HFFSmQRZ8IcvP7pKtRtF0G
	LSmRiNUaozxBqBYCi0GWQUI1JXPkM79i5ky8ccpt2LZ/MQOyKJI6OICkqn075lGNKaQBe/u4hNc
	DkndD8IWE6ynVOC9W+OEn///eqhjeXqlf0bk2NoyTyUX4Hq1RE2IwLuWJA9YoSz7+qfAvYy1lct
	APYtj7n2rDPM8JYJZ9L3w2PM53Np71cQuR9SP8Pu4B0UKhnnrklDQvKklG0V1BbP69JklhfJEoK
	BIxr0U4FnDEfI6kbcDn8SryqbzTl7UR0SG7FGpotWsYa+m0jXaLmxjPh7btazk3nRFHXI3c+QAi
	u8TKIwKAGFMCRrT3/NRmTcG+0o+Gd5tHdbGPb2xMB00AkgKGJN9bSXY1ZMkY=
X-Received: by 2002:a17:90b:390f:b0:398:c315:fa6f with SMTP id 98e67ed59e1d1-39dec079f10mr11760373a91.14.1789459308471;
        Tue, 15 Sep 2026 01:01:48 -0700 (PDT)
X-Received: by 2002:a17:90b:390f:b0:398:c315:fa6f with SMTP id 98e67ed59e1d1-39dec079f10mr11760327a91.14.1789459307987;
        Tue, 15 Sep 2026 01:01:47 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfb8bd783sm1496368a91.1.2026.09.15.01.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:01:47 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current] wifi: ath12k: Fix failure to create ath12k_dp_peer on MLO reconnect
Date: Tue, 15 Sep 2026 16:00:53 +0800
Message-Id: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: I_ebp-lqb4qMvNYpVoRZHX5VOKJfnvsa
X-Authority-Analysis: v=2.4 cv=cehHPXDM c=1 sm=1 tr=0 ts=6aa8fb6d cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=TNMgkEEFFvq8IQPbtLIA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: I_ebp-lqb4qMvNYpVoRZHX5VOKJfnvsa
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDExNCBTYWx0ZWRfX21f//Brq9ggH
 tp3IGHMsycqOD1E2QYotKUINNCJzL/3/tsZJPhlcVvVugbUl0r8cW6wKtSwNbREhVgf6LyYlKnB
 eXqAHllF4Qzx34syj3Y+zXd1OZt3mWw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDExNCBTYWx0ZWRfX9QZg1/JcF/hj
 ZSqDyZh22BzcyaXGlEaU4gxiE+p/xlj2qm6gQKdRjMSmoyxgtxiLHSr1C8kbvRGU0Mx0mkG49Ze
 OR6/fXwwQM8rUID60Aegj4w60t2RlT9vthyAWNQXeV/3OgGOxNzlrevpVvWu7xQL6+9xNWU7rRE
 51pxKCCwZOb6kvOsn3j16Mxcqdx2b0oJBPTKpJCzdEFfANDLb4CDbAMSYe8xv9WIP8fUi2IuiLS
 qD0Dq1WLk3dRxz/T8+VrM99XS9L5VJUfcL+LcAK5iUpVI5sdtj5u3f3vjPLoF8bCgQLYxqiChV/
 OZGO26mJDGaBk+4Ou00yhMycNQ3f2dtr/CUbgByMCts8nB3SsNo5c1jPcr0tIbO/SgdcoYzGmLo
 8D+IjjZ1WWXR4bvEgFiIh9/XgG+Xpjj/JCNd+adP7Ms/iI+1CyUCgjQ5J89rrHUcZezIWJzFbF6
 Gvlrrb1DJqiRN3Cr4cA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_02,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150114

In ath12k_mac_op_sta_state(), when transitioning an MLO station from
IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
succeeds, on is_sta_assoc_link verification failure, it takes the
'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
the dp_peers_list.

On the next connection attempt, ath12k_dp_peer_create() finds the stale
entry and returns -EEXIST (-17):

    wlP4p1s0: failed to insert STA entry for the AP (error -17)

Fix it by changing 'goto exit' to 'goto free_unassign_link'.

Also, there is another error path in ath12k_mac_op_sta_state() that
jumps to peer_delete after ath12k_mac_assign_link_sta() succeeds, without
undoing the assignment through ath12k_mac_free_unassign_link_sta().
As a result, the link RCU pointer remains assigned and a stale bit is
left in ahsta->links_map, which can trigger the same -EEXIST failure
on subsequent reconnect attempts. Fix this by redirecting that error
path to free_unassign_link instead.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 0cd46d1f36ce ("wifi: ath12k: identify assoc link vif in station mode")
Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d4116ba0da08..57861003c15b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7845,7 +7845,7 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 				ath12k_hw_warn(ah, "failed to verify assoc link setting with link id %u\n",
 					       link_id);
 				ret = -EINVAL;
-				goto exit;
+				goto free_unassign_link;
 			}
 
 			arsta->is_assoc_link = true;
@@ -7903,7 +7903,7 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 
 			if (old_state == IEEE80211_STA_NOTEXIST &&
 			    new_state == IEEE80211_STA_NONE)
-				goto peer_delete;
+				goto free_unassign_link;
 			else
 				goto exit;
 		}
@@ -7943,6 +7943,8 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	ret = 0;
 	goto exit;
 
+free_unassign_link:
+	ath12k_mac_free_unassign_link_sta(ah, ahsta, link_id);
 peer_delete:
 	ath12k_dp_peer_delete(&ah->dp_hw, sta->addr, sta);
 ml_peer_id_clear:

base-commit: 91b552fe898e2c46edb363390211fac47b329308
-- 
2.34.1

