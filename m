Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DAF31327A
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232079; cv=none; b=T/SihATeYrwX9ruyWVgyX2VohBtOx79DYpqDOMEsiDtfkx/CXYIcAclWiGttT27pp+8aDr1KDamYH+N29AJmbkKUdFFLyGuV9W0nkPbDegn5TQvgxSJ8RmADfHP3ziUEa590zG7P/CjTNqZQAGTp8dfsGdYyabL2Flt8HNkhoLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232079; c=relaxed/simple;
	bh=PXmayX6SLlISaI74BAPJjH1szjzOD1jxzWaFRM6W5yQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OfsEZn0dRRKykIsfvprYG1yxuvu1FotZbB8njEuNl9QLBauvGgwK4RGoEELIEiYMFBFmV8Kl3zxe+2Ss1VYiZFduuWlByVyaEwmtRaA1ExiO6O+kmWju5oKer+C38QeVQYrGrVIO1Qt3gkA0I8SbB2bTW8A0ORZMxU4YCORR8+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CSLtmaBA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JJwFB9RI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CSLtmaBA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JJwFB9RI"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJpVt73629050
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=kF7bftFdsC+xfi4UYuj1Yc
	L+KJ3C8xM49atujae26nI=; b=CSLtmaBAOhNcuJBhNk1osU0Bq323mMk4H6tqm7
	Ro3WcqkIvG6nfgFSOsqB4cVG7M/9+Zf8U5D64dUNhTy33VlXjPO6ZERwv1df0OoD
	hlfoo/jWBqYEct7OMPWECeVCGLHmvUAk4mKstBthz4MfYfS46ZSh3+lCTT7mFc5B
	kdeUHEnbND0tYGXz3PYiC9zd2VXpz1v/n2epMVeFam/xqUHCnr4xxpQ2D+uGYQJe
	4TgOZ5Mwi3ZtdEXnYtzhNiof0YqY3r2XhV632Rb0ggVxNwnjBni7V4WPPnHYAry8
	Mp7tMMQtArpi1IFijf+sLCeNbqQnS77u/6znO3dPb9MvTjxw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fevkv2skh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:01:15 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c88aab7c1fcso16602018a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 13:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784232075; x=1784836875; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kF7bftFdsC+xfi4UYuj1YcL+KJ3C8xM49atujae26nI=;
        b=JJwFB9RI5AnzKPqIKd3RooqPecdpwOaXlM4FleGSCr07j5vABuLam4cZ/cEas+3cI3
         n2D/ZKLDle1+xieAJt80/oIE9mATkSnjUCUeyIl1M9pTSCiikgNkQUEmyGTJJTzfQfkP
         Nkt+SjKwVDhI8WNhnQNIfZJsh7RWLyXI9hm2yaeUFptYffDwUlFd+isVgzVt2Mjdf4vF
         eJ+xLOs3mQt2mK7KHnUCZ/XIs4fLmsRDqxDw/iK1B497CRtSZsJ3iBLJVvCEmxkDhBp8
         EkIWKfxG7urlTD0eC6NhTd8ytrs1NEh78nVMSPLoWU2IJC1wE3Pdvtg34C01l2+T+zCC
         3teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232075; x=1784836875;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kF7bftFdsC+xfi4UYuj1YcL+KJ3C8xM49atujae26nI=;
        b=cn9KXRZdalDKOeWEp2Ycz56Mlvi55BpqjCto6amabPdk0rY14UsOa23dez425xp9Jr
         xcBYetGgoufk+QomOMi17Qi+YamnXtOjS5xyzUzHKlEBpWNW8Kv05AuZOscxX//8HRKz
         JNOMJh1Xgqi0nI/qDjniJ/MaQohUTJS3KeEmZy0DUkvd8AESTdJu0bWlpfsDZRS2AdID
         gG4szTieyOQogWR2O5xxUuo8mR/+s+UG/d+de5JTDjC65LAhroVfx6gCrq26T981mb7+
         4lNM9Xad8diqwXOvukR0UcNNnqH6Dr7inG+V86gbXkMOFouc+Hhk6u9OWModB2UyJHn3
         D/Bg==
X-Gm-Message-State: AOJu0YzZkXbXMKc1dtv2Igs2MCACwD0AtplOIpquET/5vXMbXkk0L6DS
	jYhuqDPtZ6mRF9+gV0KsKwED4+8KF5w0nwr8QhOgD7dIyRlkH87JBTK7fWDgJqWAI5o9kO/Sp5V
	MPr2Lv0wY+cVtJ4oincqEgTiFqTjbSrd7ZHbMzZEnG8WXdJ2EzXzv3TRETLOQ+EYzpY6aLQ==
X-Gm-Gg: AfdE7cleCwoy1jxValKiPMJyQLarA2JqKu9R6YSENAOitYI8ajrTp0hNuR4caU9LunQ
	GwlD2rvlHctgIPP1hLqnfquyA9+4tkpaexgGXFwdiLQlNnULqNmw3K923LqEweknYAeFnV9ZkQh
	Olh/60NLwgQE9Dteawr/4mLTKNFdu9aM/3PwfvBoUlXYgXMzTJUMgkZyQ7KnFS3OB7T1pijNgg9
	Rn/mVVdCbDY4LqWWgvCcXG4VogIbdM4UCYLUXM+yz18gdGXt/P6G0xbwAGwr4vLC8EdX+RNxMVr
	eCzFyQeu8eMyqhyY1BGZEHGkiI35ue1VDBZ0EIbvtKDlKivjyvKJgWD2xzboBf+pDoPdFssCzhn
	bLbZL6npC4N2bNswYwamMXQ2XssR95PFbiwYHVVuYdDhW34w4rPeaFO4=
X-Received: by 2002:a05:6a21:7a8b:b0:3bc:5284:4859 with SMTP id adf61e73a8af0-3c356f78c6dmr13719900637.13.1784232074638;
        Thu, 16 Jul 2026 13:01:14 -0700 (PDT)
X-Received: by 2002:a05:6a21:7a8b:b0:3bc:5284:4859 with SMTP id adf61e73a8af0-3c356f78c6dmr13719857637.13.1784232074126;
        Thu, 16 Jul 2026 13:01:14 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6c10dcsm16283000eec.23.2026.07.16.13.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 13:01:13 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 13:01:11 -0700
Subject: [PATCH ath-next] wifi: ath12k: Avoid buffer overread in
 ath12k_wmi_op_rx()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAIY4WWoC/43NTQ7CIBAF4KsY1tIw9Ad05T2MaQhMLdGWChVrm
 t5dwtpFN5O8vLxvVhLQWwzkfFiJx2iDdWMKcDwQ3avxjtSalAlnvGECKqrmHvij/Qy2dVPrF+o
 ieo/KUA1lJTpQogRG0n7y2Nkl21eSZnTEZSa31PQ2zM5/89MIud/hR6BApdQGa65A1nhxIRSvt
 3pqNwxFOhmPfDfIE9iI2jAuECSc/oDbtv0AqgkowiQBAAA=
X-Change-ID: 20260714-ath12k_wmi_op_rx-overread-c1347f1a7310
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIwNCBTYWx0ZWRfX7yiIXGnim0Og
 KaTkWxKlhkOjR7h9PtrY7gNo/awzYZIhRxkCkQIay+Mu+eSXpBeNyUxCID+WfKiEF3884tgD+jN
 /Qso6IbyF4Tyj0KXUewKUy6ftxzIQBTROD1aTS8NfOIiVTWoNskrYAfU1ks3uC1cSHGH1KTwdZU
 /8XxnQJbuIjMXuo5Iyhk6U0oUHo5FfldkZDEBQ+eXq/MXxIGAdGr7Nj+GW68IZJlgBWpIteeoJh
 06JUsPdqXQSSpiPQJHMY66fvdzVSbRMVw7T7kcnaHZaMf9WTsYD+z2cYS5U8wq8x9SHl9bYORGo
 ZyDxdbJE3PYi8sxEO4WeJ/MVlxFbSdS4iJhD2WcVr3yOxcj7deceex56ouuXKvUergkamG2Mdau
 lVCnbqNzZRxBni/BmeRiJ0TL2vuriuLbvm5WnBkfbRU8eMUkU0Uic3ridwzrX7kNA5WaySc/f/I
 oSSLCtOImrxGwyNmXNg==
X-Authority-Analysis: v=2.4 cv=WrEb99fv c=1 sm=1 tr=0 ts=6a59388b cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=xBO1L-jcD7jxJNTJFskA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: sDxU4QUlRo9sykeBvP1tbAAz6h8NF184
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIwNCBTYWx0ZWRfX4A+dZ+MIGRj2
 +I9mkanvVKXw5QwXbHfBf9+0WaCOkrSR3TqsneunviqkUhIG6QIX4/IspvunhY7O4FGg3mIgh62
 ZOF7aTEM3S5hH89yPUka+ZV3X3F8CCY=
X-Proofpoint-ORIG-GUID: sDxU4QUlRo9sykeBvP1tbAAz6h8NF184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160204

Currently, in ath12k_wmi_op_rx(), the firmware buffer is read without
first verifying that the buffer has enough data to hold a header. This
could result in a buffer overread.

Update the logic to verify the buffer contains at least enough data to
hold a wmi_cmd_hdr before reading from the buffer.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index ad739bffcf88..28b4dd397271 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -10280,12 +10280,12 @@ static void ath12k_wmi_op_rx(struct ath12k_base *ab, struct sk_buff *skb)
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_tlv_event_id id;
 
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = le32_get_bits(cmd_hdr->cmd_id, WMI_CMD_HDR_CMD_ID);
-
-	if (!skb_pull(skb, sizeof(struct wmi_cmd_hdr)))
+	cmd_hdr = skb_pull_data(skb, sizeof(*cmd_hdr));
+	if (!cmd_hdr)
 		goto out;
 
+	id = le32_get_bits(cmd_hdr->cmd_id, WMI_CMD_HDR_CMD_ID);
+
 	switch (id) {
 		/* Process all the WMI events here */
 	case WMI_SERVICE_READY_EVENTID:

---
base-commit: 0ceb105245b5e57f803bdc0e79dc077fc06ff384
change-id: 20260714-ath12k_wmi_op_rx-overread-c1347f1a7310

