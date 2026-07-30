Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D9734AB1D
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785373522; cv=none; b=CKzr2EnxMxMspFfvwV7V2apKakwWhLvipYAY00G7TznswRlefFbl59O5mLZnbArZI+W8qFftYnug+HQ9C8x+clEeN7dcALBsRcv8gmTUryGPM/elZjn4dbXyjx/vgMU829433kcmnGlt5XVDTKVlxCndT8s79mD0FOy3Dmx/H6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785373522; c=relaxed/simple;
	bh=G26oBuLWBXTguVs1cjBDadH3KIV/Cq3VPwqIvFRppTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n/YQbGHnQLH9m7YCFWOVIw+g/SfS1lPzSCrjLszwhqn0rKUjyQE/wL3HLCMPugPLE3Un9K7Fq0mZR3I70zaxuW/qUd7vYIKCUCezyuFE/9gyVBHBvLZgKzOLJnPZfJb80sR88PzuXI9KasIJNWMUaFJ2chFQXWsT4opkhvKVIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G8aZRNGa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UHI+mY89; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G8aZRNGa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UHI+mY89"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U0un5f3709579
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Hru35mpumEb
	kOLf7h02q3Nl02jlJ/9pefcv0jtM38wk=; b=G8aZRNGaf7yQm8jK6VNifzlUbCH
	VEQw5yKfkBonyTfiH5RX8F2nplDfIjkWwiiydqPLvZAjfJciBvceugVVeccTX0f2
	XRFic0g5lbXsCtEYEmZhtp36V2U4cfbepZVEFoON8vOKFwabHXCbXUwrwwQBhbOW
	o7FNBjP0RW1MRee0lGXHoGB8n8MpKJkeBuEdKhP8K25Xl716f3b7nt114xNju32e
	8K3Ivv2SSgRmWfmWzsyVZEqUmJx7pnPMgB5X/wezQnj6M+cdmoUBszOyEDjziVSQ
	QkPxbD8fAGXfcr1VTpsVnkJXh6in9K5UC2avDHXDUm0O7fbBKX3CLcwKaSQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqvh380qs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:20 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso342795b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785373519; x=1785978319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hru35mpumEbkOLf7h02q3Nl02jlJ/9pefcv0jtM38wk=;
        b=UHI+mY898DoMmqlcH9qZ11cogmE+87WYlf29CX6lXAxy7AzusV+Kihz366gDiguLTA
         BUde9mqnekGLFnjo+qm4jtr0sEh4/Db8kEFDzktBCMXMFXnWkPuAW9h1NYLbtNzBwwpb
         2ORkbDlXj+AGIiJqZPuKmfmBK/hOfH79N4xv13GE2HZ3bY0DfLwMOB6F5MyScxUPTQv/
         UYw1HM+kAuA4sJkm/7lUydE5aVwl9eniFvJ5KJ8L5jBZFLd3e2yEp50IcwbCJHL+IB6m
         4wGla68vHAvzCA5ay+BzwPVsM7Bd6LjFhP0xKhHE3KSEzbGWivMfuMnnhISQt6ifw/1Z
         KN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785373519; x=1785978319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hru35mpumEbkOLf7h02q3Nl02jlJ/9pefcv0jtM38wk=;
        b=aSQ4eypIzy/K2FckkT2v522acL+3jOOB8Qcx0z1LDlB5luXSEyq5irOlL6B8VzYJx5
         LzCTVL3/JblKp3IbVTcY0x/yHKpizq00Cr06HvKEs+haYroL8Yfg6Ba/O0bPb8ZvMoPH
         jq6vUGd1AUX7T14aOj78B8n+NbZ5Wbv2cO3vqEMUPccPeYOXh/IVP/CM8z3237Ux+gzW
         VEeUK9xYUC/AIAKeb+2LAbudIG9XPfJd8lKNwmv3ySVGdRFYwJsA/7BvPNXopz0g2aS+
         2Y4amAUfIMPRK/rVk3XBT0oAIUI0l1W5b2xhAK6T+CaR0WhsuKgxQR0StO4Q0kd8acG3
         BLyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/d/peZpAqj5RlPiyq8vlkxenRnJFDyDbsfmlXGsr3NrtgBHO3xrRDBAanX3BbienlHOWVy0QxgLJL3S2Rzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCYaux4z9FeX2CQb9Z56BGZrZJ8gWCeyPH60iSCJtad6sgvlg6
	mEhwZQcFdq/TnXAkvBP0zCalBlGNiJNmodtIwQ0E7OOBR9wFx8m3ftx19jjNrEwU9P8CCGbBcOq
	ZVVUddu30zXLZYc2RVqP9boctBbB0J1o+mIGH0RMKS205MGmTNGBTZd73zrrVivokAjOrSw==
X-Gm-Gg: AR+sD12xUEuFrT/BtzBYR640osPzBHti/v1nXXvlIB2hCrabFsPfNT5K4OARBlZU1yC
	bu8qkGjl19fUN5gdsN7X36zZsXv/m4XIUk9/t3u7OoDAks0Lf5HcUkDNcgJEXaO6BG0cgRa9CWp
	y1BjGXkTH9xFV6B7JMvYGjD1nRvQDwqyqtlEGql8jgkZM9qEtYOYkRLxgIwZlSUwYBkVtdY/cIR
	aD1iM9s2ckDVJ89UANrKcsv/cfXtgiOabxL7r6yr6UeGZ19wuqXBv0G2IpkdQn7Z/SmvmV+qaNV
	G7ttkJlMBTzvXlHhLZpMDBfYadvhLy8hLIB66A8qKdY8DKP+XUDRJKvSVKIk+xbRuXne4IXNlV5
	J1hKN0EaRerZlcQZUw/vN3+DSgIM/Ge8LorJbVt+2fJotGfURGxoaVUXdkq4=
X-Received: by 2002:a05:6a00:748c:b0:848:3576:3204 with SMTP id d2e1a72fcca58-84ebdf47d90mr157928b3a.34.1785373519076;
        Wed, 29 Jul 2026 18:05:19 -0700 (PDT)
X-Received: by 2002:a05:6a00:748c:b0:848:3576:3204 with SMTP id d2e1a72fcca58-84ebdf47d90mr157896b3a.34.1785373518582;
        Wed, 29 Jul 2026 18:05:18 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23120sm2168563b3a.11.2026.07.29.18.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 18:05:18 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current 3/3] wifi: ath11k: unregister PM notifier on QMI init failure path
Date: Thu, 30 Jul 2026 09:05:05 +0800
Message-Id: <20260730010505.143458-4-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
References: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAwMyBTYWx0ZWRfX0VfBm5+oHiee
 Smk7LOtyQosTtjPQkPsXQQQexUxYe4jGx8YYvFvD0jOo4dqoETM3IZ4MKdKZeyxPK8JaMAD2TMF
 kHJpkfO0SPsv4dZtkDQcsokEJUW41/E=
X-Proofpoint-ORIG-GUID: vj8ydXtZQwaCIIpHIikSeZs-V65leBUx
X-Proofpoint-GUID: vj8ydXtZQwaCIIpHIikSeZs-V65leBUx
X-Authority-Analysis: v=2.4 cv=batbluPB c=1 sm=1 tr=0 ts=6a6aa350 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=FJAr2BPrIL5JYYbaf3kA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAwMyBTYWx0ZWRfX67Xq6Kl8Y7A8
 rdhUVMDjDU6rOT2dmEQKdYrgP++QoRcOGyBcWFuacqHQE4jjPin80C9rMJUwpU2dyyRMGsXF2nQ
 QIedrVIwRUMJpqYqiaWwY5ish4ee5CbbrMn+2GIYpNsx+24l5EACWtm4wZ532/0oIo/cPJkVd4W
 bGoWT8PtRxv4qL8zrGhetSeL3YrCWf7LuqWKWj0qRQmRPeOVKT762+IKbfV5+RJ9S9JFl+aH5ac
 u36E1b8P1Wt1ZEaksWwtwRBqspDqZJXUUIVwQdrEBc3nHspMOyfCLvSAdW3CLOPErDUZx6jaZek
 MqlyfDtB1ojm6s1dcSia67caFTpMi8msx0aIrC/xeRWBL1u4/fPv/i4zEDQskotd3ypFLOBJDdm
 /uR/YDXucTvhbgKH17syLQMJF5a5rfq5ZMfn70/a6PHwn0q75YqZdQXyY2yNv8NBLnuFwxsgdUN
 WzqKsVE2zsYEQFny6Yg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300003

ath11k_core_init() registers a PM notifier before the QMI server
becomes available. If the QMI server never arrives, the device remove()
path can take the early-exit path introduced for QMI initialization
failures, skipping ath11k_core_deinit().

As a result, the PM notifier remains registered after the ath11k base
object has been freed. A subsequent suspend or resume event may invoke
the stale notifier and trigger a use-after-free.

Fix this by explicitly unregistering the PM notifier in the QMI failure
cleanup path before releasing ath11k resources.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 32d93b51bc7e ("wifi: ath11k: choose default PM policy for hibernation")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 7f5f5c8d7c56..bdb8c99f10fa 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1272,6 +1272,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
+		ath11k_core_pm_notifier_unregister(ab);
 		goto qmi_fail;
 	}
 
-- 
2.34.1

