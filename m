Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EDF240611
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974067; cv=none; b=jKTu6GTkETrmngwvXjRDUqw2lx734wk0MSS5F3T/21uLuQugvZURWrMe1kGoQyo1vVGU0AtWy0rVnWNugUEgPM1tY5pqp37gp0CYMHSUJeSHyRt9BkP5PDlmOq1SlMpOuW5Xr8BbZC1TsuMxq66mM3FfyL5Vs2NQqDM3/vaJL8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974067; c=relaxed/simple;
	bh=7QHwKEa0btykXDub5SNgTnpLwjVO+ZENBWWOgayOjJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G0y5ukXlbPsGfifWTmVZHw6+/na8ebnd5mhBdeQTCMeC/aJDV0QDD1Hi/Ihp5aiPcL/QtYPkBovcCYKeDPokyJAC4nOUE1CLhxkiEMIt/bW0jSFYKfVfzUX91xSYuo2FIYNbMeHiX70TTh0NsrmzbSGjAJrk082svpexiIVJuPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=flITILjT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d3WSRSE8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="flITILjT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d3WSRSE8"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E66G3U3366064
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=8CwRSpQthC3
	VW4hHG/pCRdpXq2vlHArXzPFuLy34jkg=; b=flITILjTox8Zx+pafnS3SAHpMJl
	5C4CHfptYe9qNP8nvbc/DCD+OM7z6a9Y/LhwcLn77eVDDTdFjjtuqnBTuLqOGSb3
	t+iFEmBs4vKJ06n7vDIAyTgqe2j5zwFFyrn9AuUsjpAPpMJesI79VQczAEWo0DlD
	bvofA/5hS1OUBMgFAIeis2bqhOeK0l8MkcQjLpiwDMZZhHj/ervqwM2qv+KHcNk7
	M03rxJFuwh7gj7J3joma8OYxWcKS7OfvSRBpN/J+aRChBPB56Nk8uBrA8AXeWiNp
	HfOjUT447Cio77ci9mqsUsXn/53ZQFHpJA6ZW0NQk2qo3hYE+uSCpyVEY+g==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha46213th-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:24 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35a4d2e39acso3108885eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974064; x=1792578864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8CwRSpQthC3VW4hHG/pCRdpXq2vlHArXzPFuLy34jkg=;
        b=d3WSRSE8lWQDtCpra12Vex8hsV5878kMnrFP6S3tzIvf0NzDd5kFTKAWB2Dg4XMQci
         tK+/T/P4xtFeBQ4U9VKJzk+MKWotmrOKhkSFy8rMFBx/5+13k96f6l9MSRrxu8Kjh9dK
         zvgcw/35kR+lDgBQH5aT73zbTTqAluhGRQgxZpVnqURM628qRstmwZI9TmaWLxFrcQIX
         esC4YENlFO6mHTOL3mKwytqxwOpl7F3daxz90Mtsd0qZjlZTwUV02NN7QNDXnS6yKsyT
         EiOzmTsVFUuloJ0ctB0a2S/VRyKHSob1vjUleV4495TD7/IovdvA9C/hELYytChd392X
         ZEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974064; x=1792578864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8CwRSpQthC3VW4hHG/pCRdpXq2vlHArXzPFuLy34jkg=;
        b=O7HQvU9SRIOtnrIp3eYyDSZDwcgmZhn5HHGVTp2WHZ87iv+RFJcqcGTj7GXw0e4lY0
         R8feaxUCBvyNmvtHO2gIiHXwF7lDp9XrOlt0gl9/oD0LnzknwM/wt1FkEWuiUNFFs3hn
         dtIfyqYIaDTLS0qfShNpGzefhfVtWw9NFjl0W5D9AUp0VOQu5irREC8saUmaqoVBoa0Q
         nJxbPKc/sZnzFhUkGh6YC9Tq58e1bITAJvGkrZ4+N0pp2rCXve6d6f+k1GguJU+YfKHZ
         A9FhRJD63XFvN45O9gJLpU5ldB0YDZDGlzW8i1st2m8sR9GIO5jJAh9bHZhkgq5JNLer
         Z4uQ==
X-Gm-Message-State: AFq9FYLrnzHeiWR88liLVjFf+2KpRLRiEatWGARYt/O2WxD8bs1BEKVs
	Zn/CquCMt/F49dSpoPmqx4/I34JSbZwuRe6OOyJh51u1EQjldAk8Gfi6dbEkA9ihilmVjTfT/kg
	G7Filzoj8Dn5nppyiOXeDNr5dp9yPgp4Ja1pyWFMxBNmfOv+R06TqWl+SlfHiLCMQZxRDLQ==
X-Gm-Gg: AYBFou1koKz/ke4gCu5y2BSIIXxHAH1t5F/DKZFv99OuNVH6+ACSacWscPLzz4wyor8
	GZobCSnPKzSV7vJQZx0ttU+xohw+XF1Jbf0FnduT3MBXkMPvZg3xLmoy90cEvEGEcFysHIeIvju
	GFubJnFQOv+hXx0ZbVEjcQM9rWJUXFjApdtOaovq18DeKulZnXzrQ4be2JV2YU02PqFYx2qJNGV
	7q4L8N3mkEYUJ+xzNuXb7E9JZCSE3PTSzoo9xguS2ZGm9Qxq7Q2cBeK+BBxu7EaGXSWWo/D7E0k
	3phNx43jLXn9fd9c7nohxkEp6kewx/DldImYBOV5gUTLb5q4/xZBnAchid/161ouyQ1Pg4FF+J2
	WKZ6AxMiUb6lZkjWfqUUcjgyw35kqgrRa0/F8
X-Received: by 2002:a05:7301:140b:b0:352:4f11:8118 with SMTP id 5a478bee46e88-3537e08c6camr21659732eec.40.1791974063801;
        Wed, 14 Oct 2026 03:34:23 -0700 (PDT)
X-Received: by 2002:a05:7301:140b:b0:352:4f11:8118 with SMTP id 5a478bee46e88-3537e08c6camr21659699eec.40.1791974063090;
        Wed, 14 Oct 2026 03:34:23 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:22 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 01/15] wifi: nl80211: reject NAN add-function when Discovery Engine is in userspace
Date: Wed, 14 Oct 2026 16:03:45 +0530
Message-Id: <20261014103359.1508345-2-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 5MWtBStmLGfvp4voEWVgpaMJol1r4R7e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX/xPIO4J/MhFV
 tWqDR77NglLG1Ft72Wa7QZUUKmY7EkFHw5gJZIhAMHSopB5BSh5u8JDbBnEuh9lsML5UW0ebaRB
 HmfQldVso+Fx1qIckxaU/oZMkiuClLQECsj8hOOQiofggsZkl/f/CLsn9xucCtAhp75KDz9f/tP
 E9X/7e5aMpchElwOs/H8Rzxlmbs/x4k8Zo6Jx697d8SCjZ0XcS2mc/fLJ5Iqj04kxWmyr2FAPlC
 AInpy5Hk9ZloO7SxrHUrgU1SXmn4mVkMnh7uynxt0aje+gstD1zVCPwLzSKcJqf8MiDOidU+het
 QW2DFx8rzI9G6mdATLtUs0Vq5ns16UVMDBt3hSBTUfCHtoZtUanSaVN+JZo0kd/oMomUALuWttZ
 8xs+9ntDR5bJRGrR7ZR2g+7DIMCwwDiCZT5j7+ksGQejm9BLqr5QwbkqW40C9KPvNYP1H+WW93V
 h4gVeKWDEc5EDSxyGTg==
X-Authority-Analysis: v=2.4 cv=ErZHPicA c=1 sm=1 tr=0 ts=6acf5ab0 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=ooLRZxgLdDP5yNw24dUA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfXxb+90L6hKmBd
 zxyC4orcan2X1L/5+fXjV+rsXzm2CgzQvwh7E6VRexhCm2NEgFhkCMT2ZdcXUdYREgBZVbrzw2m
 jE5Fr7sxsMNMYJ1gYZwKJFRXfKnhuh0=
X-Proofpoint-GUID: 5MWtBStmLGfvp4voEWVgpaMJol1r4R7e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140041

If the driver advertises WIPHY_NAN_FLAGS_USERSPACE_DE, the NAN Discovery
Engine is not offloaded to the driver. Reject the request to add a NAN
function in cfg80211.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..77b75367de27 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17383,6 +17383,12 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (!wdev_running(wdev))
 		return -ENOTCONN;
 
+	if (wdev->wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_USERSPACE_DE) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NAN Discovery Engine is in userspace");
+		return -EOPNOTSUPP;
+	}
+
 	if (!info->attrs[NL80211_ATTR_NAN_FUNC])
 		return -EINVAL;
 
-- 
2.34.1

