Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A075633554F
	for <linux-wireless@vger.kernel.org>; Thu,  5 Mar 2026 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772726876; cv=none; b=C3hQzfc3mgpryn4PO/zc9B2Zo8qaYiWjUdg/IanV7j+c1RYS3hvZ+8Gq3z5aiCyXAv+qzC7auC0tItiDY21dYsnw03wIWCBk3msGqOLjxatM2EnDRwEgYStR49ixpDjIiPpjgUzliK8LPjAt1CzkiWaDvXnaQG0dm6fdYprbJEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772726876; c=relaxed/simple;
	bh=xVSlKlE3W/E151tTGKNBnl/Z19jAOr0BCk0PE+TbHxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=naoSCnDOAmDdHB2a7jFWI2uWAmD5jQfybohqXpx083tcTyDvzgAoMKTUMcxPtyyn0RaZgQmIxENjC/DoeBPWg3YlvjP+EnFG4FCCpN7H/xR0OeED9rfUJDC0WdIwWQZszKc9BfxSC4ojcElB4HNrcN5e4NWq7WP0P0WqgkFfbhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XPjNp1mJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U4q1+YWY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XPjNp1mJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U4q1+YWY"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625AG3tG1519082
	for <linux-wireless@vger.kernel.org>; Thu, 5 Mar 2026 16:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=CnctMvwlzm/
	o7EipdXW/ZjnlTfwOenuPFkUAEeIBpNI=; b=XPjNp1mJqexEShN8FgT7l9K1C2H
	oslWtqLQjSn1TKu2Jj5DmHXcJPBoaVf0j8WHrNq1/Jqcp4zbmBRROEe6yWOQkhTJ
	vdoOjBEXtXgylJQ2pJ3HLamWok4X62ygeiyJ/S78UVk5CBqxqUCiM6nd27in166y
	K5zjycovszjgIC+qSxcHMtl9b9k0smQnEIlv8KtFHTm/uoHkc6zHI5OFdOr4kDfw
	uyVOdSDTu6ErVVMDWV86p3L6osSQ5NeezXweE5ZSf3mOSdTXLxcWmZ1IfvM7/Ktv
	UisHAt8YMfIg33wXD8Ht7Mkow+MznTIF051lmxFP69stULstU0krFaQQ7GQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpuptkes9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2026 16:07:53 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae5031c6b1so42258345ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2026 08:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772726873; x=1773331673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnctMvwlzm/o7EipdXW/ZjnlTfwOenuPFkUAEeIBpNI=;
        b=U4q1+YWYJKse4a/NmFY07AK6rJ50LVwCA5rHecCpovAK7TJFjR4VCERyXlAelxUTOB
         Upqma0NxY1fA7PXKJOn25F9/Ta7QblO6zYyfTM/+8AOTFcIuxl1hln7DoCClggg6zwX7
         ye7hNtFSMMEPnnXKKx6vtbQa6LDdNq6l6i65/epVCCs4nZkWncR8z/4LKOJz5hC7hRCh
         cYTcD40y84V6lifmslvm7ypMsY/ssSn8Wr3YynZkOGE06oYo6Y0X/N68rPVxR+76BVE3
         CsFcDa8GRV8DoJS60+iv7kEy4peKvsGYA2rb+DFT0HimTHQx+6i5FbEu6bnQ88KDGXV0
         0VCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772726873; x=1773331673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CnctMvwlzm/o7EipdXW/ZjnlTfwOenuPFkUAEeIBpNI=;
        b=k5INEt2V1BToLzlnOD6wneKndL0O8aSJ8F6D/jntWemk97Whhvuc0RR9DW3YEA/dTy
         0o9hXWz6Vu/hm/uPm1t9Uk1CRFPy5S8ZqNchjYzkvlIVjtFqB9A196sCZsTWDEXp9tMi
         Ok0/OVBaRRK1vAN9j8M35B3DRsGzxCaTkgWi625IIlVKtRLzW8pJfZmO4V4kvtSFqIHk
         S9B3yCBJXuy5KW3GK49tGVxsqdbRFio81EJpbVTBHlJEDxPweTGlh0xXmSsrEVQB6EGA
         k30eIL6pl+uqiIiJhLOcsIF+BwCXwwxvPTP0xWjwx2NllB9EoY/gJPgF0irHOckSDo+e
         YTyQ==
X-Gm-Message-State: AOJu0Yw2SZ/MW7AF23CSoN33mtz+WrvhARYEmIyY4weB4N8kNoOMMqtS
	jST50AxzGCR9YD72o1biEWLHUjPfofx9vkkV0F1yD5o9GiyCYbnI2KjCpTttRUdAsW4133i4mdD
	V2ATr22t/fgQWqq5PAkdhOV8l0DSXM9zqSldTgwPbcLwZE0y55CwGLMbFr96ZcGxeaYC6
X-Gm-Gg: ATEYQzzfgsKenuPcojYQmXmSy+m6UNLxENcWRp2SqRpSppxYAuvtUfg0H72K8+cJ0Y4
	dQuODNy4Eo6eF3QsWaNVxFY3EtHK1agCQKCWlpNCJoJSAqzTFaWxT6/Ibz/ScKgiFLBWIlHawAg
	zQQmzVxsTEfbyPfaVWESYzQ34GUu+Ii/iBb+xP0SECZoaeStXpZcHFCKR2nsQxZlMc6jFvzj0Xx
	bJMviKx2zpoKzrO4gA2tD51B+/9BcektG3qtWzN5+VCZY204Qioe+0Po/5dQZVA4yICPZfao5lF
	qTzy2XoJHIlSYglzumSW+pVpdSV3VhISvqRXVrywodZz8zolfixvL2guobR97EN42uL1nW6qcrr
	7zHwFIMuxU0on9UyElOVd/rITFUvgqfRbWzVO1iuKCc3OCGcUbYYaWek=
X-Received: by 2002:a17:903:37ce:b0:2ae:8077:b1c1 with SMTP id d9443c01a7336-2ae8077b4c7mr103425ad.30.1772726872983;
        Thu, 05 Mar 2026 08:07:52 -0800 (PST)
X-Received: by 2002:a17:903:37ce:b0:2ae:8077:b1c1 with SMTP id d9443c01a7336-2ae8077b4c7mr103135ad.30.1772726872315;
        Thu, 05 Mar 2026 08:07:52 -0800 (PST)
Received: from hu-peddolla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae489c3626sm133773575ad.8.2026.03.05.08.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:07:51 -0800 (PST)
From: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com
Subject: [PATCH wireless-next v3 02/15] wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down
Date: Thu,  5 Mar 2026 21:36:59 +0530
Message-Id: <20260305160712.1263829-3-peddolla.reddy@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260305160712.1263829-1-peddolla.reddy@oss.qualcomm.com>
References: <20260305160712.1263829-1-peddolla.reddy@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEzMCBTYWx0ZWRfX2ArgwH3jUD8I
 itxgW6dq5rM9E/w6YlwPOUubPH7CiRZ3uCvJgMYJCtx2ybX3aT9AjCrsOzKSgYOmSSB1NP450XU
 cPlRaqotSoGOyxt3Aoag7bXLNhL6Azy5nvUedzaMKID+fwPPOLAYq3zQbnoNlYmncCrsI5uLLvv
 JboeseTTtSwNC7g/yOZaPsWAKopV6O2KwNHtCnnRUjoq7TJSVMKgytlm/dyz5COn3A45WR/gGwM
 HXdLysQGNjq4g/uiBDc/R7/kGo6E5qnPpecnBzGXrgu8MOB2ahCQEFEjNUG3CnBVBCfncA7Ic2l
 +RtO07oEbCPmESVSF43Q9nEHVvdem9WAgrpeWXSmbmp8sjKIq1+eqpBWWBz01WJ1GRSblbwzn4e
 XykJhiiKEB1UMdzaMuM3iX1tVMkOf0jphLV6K2DP7hnqBDmcYvUuKU/3jBdHlHCH/5K6u1RDHWa
 ZknhDIrndQzM56nbrTQ==
X-Proofpoint-ORIG-GUID: hqh8yxT3h4xhgydGdhZplZNjkNcbQ2zU
X-Authority-Analysis: v=2.4 cv=Ddsaa/tW c=1 sm=1 tr=0 ts=69a9aa59 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=b3a8TREfGNtq1x0cxikA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: hqh8yxT3h4xhgydGdhZplZNjkNcbQ2zU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050130

When the nl80211 socket that originated a PMSR request is
closed, cfg80211_release_pmsr() sets the request's nl_portid
to zero and schedules pmsr_free_wk to process the abort
asynchronously. If the interface is concurrently torn down
before that work runs, cfg80211_pmsr_wdev_down() calls
cfg80211_pmsr_process_abort() directly. However, the already-
scheduled pmsr_free_wk work item remains pending and may run
after the interface has been removed from the driver. This
could cause the driver's abort_pmsr callback to operate on a
torn-down interface, leading to undefined behavior and
potential crashes.

Cancel pmsr_free_wk synchronously in cfg80211_pmsr_wdev_down()
before calling cfg80211_pmsr_process_abort(). This ensures any
pending or in-progress work is drained before interface teardown
proceeds, preventing the work from invoking the driver abort
callback after the interface is gone.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
---
 net/wireless/pmsr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index b875b61c0b48..c2977a37add2 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -658,6 +658,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
+	cancel_work_sync(&wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
-- 
2.34.1

