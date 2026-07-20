Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C883B0AD0
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529818; cv=none; b=M3s83RoUUx21zrGPup9CPkO4uLvO66PvISkDpwyyqiEYTvoeYt6x0eKRsBDUDjIa5YYtuCa8EQkDOidA9yE4aa56V7bMlLMhTcMBUI8mSLF7+Q7GuO4Z9iG1lFZfMXVDXDxNGVvzpiPe4Hb3lPlpLmqfPMNqkQrIR1bTj6bnYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529818; c=relaxed/simple;
	bh=TeZaYIoVp+JA3pXQ2eLqBzhtk+TLvNQeHVX627eTnNQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZsWef/br7mE76FNwUhKLO9F/pU2tDGw2yQl7PO5IeEx4gmZXmt/PLEXrY60xTPcpFfiiBFnj9D3yk9oGeorz/IwUeRfSoDtR7y69FlXtM8Q9oxus7Bnxpr0Vz4VTHSjBogN09X39e063ZbiptmC4bg/R1evMbqo/KGAY6521pso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aDeEFhlv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ccp6Kj4y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aDeEFhlv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ccp6Kj4y"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6ROZr2771258
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MHqVBdkvTS9RGcZbYw3ny3/a6eyNFEqIY0DGCMDX0qc=; b=aDeEFhlvYTzVAgIV
	BaFeNpXf7krTTaQvgyPEGa3tOxY22zB6B9Yv5PXquBu+iA7t0OPpyUkKiyaJP/EE
	daprQU2iRGNgWhlVLOAzviToR8nkHk88TS4S+018qsowRfQICCC+zPC2TM9pYAUk
	T9+w9FdlttD08/siPe7u+grSMhB6fLPQvPyYSpr2nufuftnZ7SoFf6o+WN8WVkzv
	HWKtIaJRakw6mOZZ9E3gHNJDV8VJ3fJr8PjYFBsCPsH5rgHVdbVfGYmsV1fLF04t
	Fm6ZctZzlf6U8hiS03PBH8dlmRcs9/w5rGk5tT0xjsBPQ9yBiCVM2xwam+GNIjRT
	eI2LSw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2aavs8y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:34 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84a67b16217so9327773b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529814; x=1785134614; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MHqVBdkvTS9RGcZbYw3ny3/a6eyNFEqIY0DGCMDX0qc=;
        b=ccp6Kj4y+KWmlVBgwMa8lKImZsBS+y33e4jsdPhQ3xtNUjxSNgFM1FC73L65t2u9Y+
         Si17HlxNGH9sb30xkcw7foMa8QvJTQJFi+O4RSuG0gzBU5p9J3+5KoMUiypzz0xXbhys
         9L8de9NMyt2U6NXDJgXVWHUmlRgJOLRVL/6CF5/2E++A3JHLybBJghXFPQwAapZZb56s
         k//SAApDUa/oAEQxGlndLPDNkTuLi9p2WWE4ewdwTz6dSuATluZgy5lEMolv5exUcm/d
         YULMUZMX22D8TXO0UYupTHS8I20wka72zBw5sONxefkU+rQ/n8P++JL8XdMBQWwNXxAO
         CwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529814; x=1785134614;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MHqVBdkvTS9RGcZbYw3ny3/a6eyNFEqIY0DGCMDX0qc=;
        b=UeTqcHM0df8G6xGzHvwUzDpGhtFwO7JB7LkIr/zUHiTG5xkr717osI2zFJzymqwfpu
         O00og5peOyJtk95u/eW+BxaS0QHvw5yMakP4IpIwgTuMhHqjkZXWOUGmUJerL84zNk8q
         ZzavDbY6/9az05AG6pgmqou8PsaC1SRCXMeR4iQztdwZS/UnDJ+TbrL6gmijh15A2iqX
         JBiAbuhVcvw9FCC9Nlj+Uh887+ZolfZAwbcH5GGQqcgLqXcJnRACUP4qRTrVJV8QyP8m
         l3J2pU/lOk5+lfY6tBRZRZFklgfEyfUoaO4RhfqeCQdHbgjhb34/QL7Hd00wvEZT98yw
         ehAA==
X-Gm-Message-State: AOJu0YyGtD5E+wwRsHG8SExgSEfzKZ59f+6LQsk60jXg7pBx3d6RGvmo
	TQI2msGOxxFln78lpqqcGyp+Pwn45SEigGPB3jB8C6GYy7cqImhG9aPM0zLB865dfGm44bYsSOF
	k4hcwhd7j1W8rn5p0F0icio7j/9Zj7cNXPwwsfrPVtZbcXm8kWp+cbxMp33gKCiqKRTKPxA==
X-Gm-Gg: AfdE7ckqC78qsHFNDGiVPHBwGRBIp0JBW7a+gygIDzqrnUJsQbwy/7q0KSEg1ay0awk
	uR4r1u/nl+Cv9bKgY0moVo/oJbj1WNzacjOpG9h4x8ctUWnuomU6YYawg/i/F9uskyYJ3idaGil
	AjrLkhc69H4ZxHCv3y4AcJh0CPBMnOEFbmbDwTmT54Ot6B0p8MJFImwZx8D0UTh0GI2leF4e49N
	Xa35IF9wVe14kqGq5NCS14ObsgnyHVWrzxlTWnNi//GfS6jU+OQZzESiRsDf2/wLH6YsRDkb7B/
	yFFchN4NGYKOu5S78MQUk73ax221mKi0eTncJRxE5ZuCWoYN9WMLNyfsEQPWRM8eTBwtUsqg9Fo
	OWZ9k04gVxpjNzroFfcDbqCuSx0cvsToXF6TfvppZVB7glHvFJVRbxw==
X-Received: by 2002:aa7:88c1:0:b0:847:8b1d:230d with SMTP id d2e1a72fcca58-84c2923d612mr13078986b3a.3.1784529813792;
        Sun, 19 Jul 2026 23:43:33 -0700 (PDT)
X-Received: by 2002:aa7:88c1:0:b0:847:8b1d:230d with SMTP id d2e1a72fcca58-84c2923d612mr13078971b3a.3.1784529813302;
        Sun, 19 Jul 2026 23:43:33 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:31 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:23 +0800
Subject: [PATCH ath-current v2 2/8] wifi: ath12k: factor out peer assoc
 send-and-wait into a helper
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-2-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: DGQObkB46Zcfi-BUSWvYy7Civ9ALwe6s
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX+D+32aYC56bF
 fUx1UnoMGwXYtGIwRhCWFs9n6eMfxwQx8V3HX2nfeIiHW+F5Ss80rFjTTVuyCsu/OIBtZuLdPmR
 pdCo5PRaTQb2es4udYd2DDpOWfuv4Q8=
X-Authority-Analysis: v=2.4 cv=b9aCJNGx c=1 sm=1 tr=0 ts=6a5dc396 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=pIzPn9nKbmV5hhrGKQQA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: DGQObkB46Zcfi-BUSWvYy7Civ9ALwe6s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX3wkMuxj+sHtM
 hCUnGF4XFhh7JjLejR4yo6gP+wtUzdOsX9DqK5m2PmPHfC1Z7G+JbX1OT8xjtJm2pJw8zq6ZPxF
 2ewGNO6B2HCpEPnHLB+UrqLfFB6V+cZlzVx5HLOq6zpDVMopxP0c1cMMiB7OKUWUVsDjG2nvF4M
 JTm6IaJVMHSxveZ6JyYYyo5ND8DtIjofYVzRB8IfWZdDnUtCg4X/pTITKfkX919jIR05xYcWmri
 y3b9zg4VNEGb2/gDztZx0BkFV6BAI1+mEFj58uis7eWdCLh5aQGEdiaGNVxWhZoZHfbz867JOaK
 HqieRTfTnWp7pscbpnzKGcJAjH0GNZhIiYZyuDwXdL1nKlwZ6i4GsMPx2HHwUP0L0vot5ZCF1O+
 FAVjXikiTtRnLNNfX3kmIxYS06PaGv/ktu/egje1/e/KSMW/TiwnFjZ9MrsaX6wR7QkhQ6k1E92
 LGvIYihioC+k4cQwzqw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200072

ath12k_bss_assoc(), ath12k_mac_station_assoc() and
ath12k_sta_rc_update_wk() all open-code the same sequence: reinit the
peer_assoc_done completion, send the peer assoc WMI command, then wait
for the firmware confirmation event. The reinit_completion() was buried
in ath12k_peer_assoc_prepare(), far from the wait_for_completion_timeout()
that consumes it, making the reinit/send/wait sequence hard to follow,
and the three open-coded copies are easy to get out of sync.

Move the sequence into a new helper ath12k_mac_peer_assoc() and call it
from all three sites. The reinit, send and wait now live together so the
completion's lifecycle is easy to read.

While at it, ath12k_sta_rc_update_wk() previously warned but still
waited the full timeout when the peer assoc command failed to send. Now
a send failure returns immediately and skips the pointless 1 second
wait, matching the other two callers.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 59 +++++++++++++++++------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index b7eba8ea981b..3e3b06e15f80 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3594,8 +3594,6 @@ static void ath12k_peer_assoc_prepare(struct ath12k *ar,
 
 	memset(arg, 0, sizeof(*arg));
 
-	reinit_completion(&ar->peer_assoc_done);
-
 	arg->peer_new_assoc = !reassoc;
 	ath12k_peer_assoc_h_basic(ar, arvif, arsta, arg);
 	ath12k_peer_assoc_h_crypto(ar, arvif, arsta, arg);
@@ -3835,6 +3833,29 @@ static u32 ath12k_mac_ieee80211_sta_bw_to_wmi(struct ath12k *ar,
 	return bw;
 }
 
+static int ath12k_mac_peer_assoc(struct ath12k *ar,
+				 struct ath12k_wmi_peer_assoc_arg *peer_arg)
+{
+	int ret;
+
+	reinit_completion(&ar->peer_assoc_done);
+
+	ret = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
+	if (ret) {
+		ath12k_warn(ar->ab, "failed to run peer assoc for %pM vdev %i: %d\n",
+			    peer_arg->peer_mac, peer_arg->vdev_id, ret);
+		return ret;
+	}
+
+	if (!wait_for_completion_timeout(&ar->peer_assoc_done, 1 * HZ)) {
+		ath12k_warn(ar->ab, "failed to get peer assoc conf event for %pM vdev %i\n",
+			    peer_arg->peer_mac, peer_arg->vdev_id);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static void ath12k_bss_assoc(struct ath12k *ar,
 			     struct ath12k_link_vif *arvif,
 			     struct ieee80211_bss_conf *bss_conf)
@@ -3915,18 +3936,10 @@ static void ath12k_bss_assoc(struct ath12k *ar,
 	}
 
 	peer_arg->is_assoc = true;
-	ret = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
-	if (ret) {
-		ath12k_warn(ar->ab, "failed to run peer assoc for %pM vdev %i: %d\n",
-			    bss_conf->bssid, arvif->vdev_id, ret);
-		return;
-	}
 
-	if (!wait_for_completion_timeout(&ar->peer_assoc_done, 1 * HZ)) {
-		ath12k_warn(ar->ab, "failed to get peer assoc conf event for %pM vdev %i\n",
-			    bss_conf->bssid, arvif->vdev_id);
+	ret = ath12k_mac_peer_assoc(ar, peer_arg);
+	if (ret)
 		return;
-	}
 
 	ret = ath12k_setup_peer_smps(ar, arvif, bss_conf->bssid,
 				     &link_sta->ht_cap, &link_sta->he_6ghz_capa);
@@ -6480,18 +6493,10 @@ static int ath12k_mac_station_assoc(struct ath12k *ar,
 	}
 
 	peer_arg->is_assoc = true;
-	ret = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
-	if (ret) {
-		ath12k_warn(ar->ab, "failed to run peer assoc for STA %pM vdev %i: %d\n",
-			    arsta->addr, arvif->vdev_id, ret);
-		return ret;
-	}
 
-	if (!wait_for_completion_timeout(&ar->peer_assoc_done, 1 * HZ)) {
-		ath12k_warn(ar->ab, "failed to get peer assoc conf event for %pM vdev %i\n",
-			    arsta->addr, arvif->vdev_id);
-		return -ETIMEDOUT;
-	}
+	ret = ath12k_mac_peer_assoc(ar, peer_arg);
+	if (ret)
+		return ret;
 
 	num_vht_rates = ath12k_mac_bitrate_mask_num_vht_rates(ar, band, mask);
 	num_he_rates = ath12k_mac_bitrate_mask_num_he_rates(ar, band, mask);
@@ -6840,14 +6845,8 @@ static void ath12k_sta_rc_update_wk(struct wiphy *wiphy, struct wiphy_work *wk)
 						  peer_arg, true);
 
 			peer_arg->is_assoc = false;
-			err = ath12k_wmi_send_peer_assoc_cmd(ar, peer_arg);
-			if (err)
-				ath12k_warn(ar->ab, "failed to run peer assoc for STA %pM vdev %i: %d\n",
-					    arsta->addr, arvif->vdev_id, err);
 
-			if (!wait_for_completion_timeout(&ar->peer_assoc_done, 1 * HZ))
-				ath12k_warn(ar->ab, "failed to get peer assoc conf event for %pM vdev %i\n",
-					    arsta->addr, arvif->vdev_id);
+			ath12k_mac_peer_assoc(ar, peer_arg);
 		}
 	}
 }

-- 
2.25.1

