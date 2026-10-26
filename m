Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052122;
	b=4TFtN4yF8TEqa0BW9ld/rc2OaM/evJqe04UqEZAEYgOF5wC52gr69fwV5XkUnyTVqIMc
	 L6mgbBKnLHNFAMb8OHWnpFmNpsOVRGt/R7y87CRG+8Co25f50U6H5dXA71Awj4VaILlQ0
	 t1tYAD4S0YFlrI72Opsj/UAM3KGru7mq7ZrOXk385liS1xHA1RRPVkGXNTzJVOpbJw7K2
	 uL8PKUWH6yidZmE6B3UW+yvruptFq7mCZm64Vrcz56L1C0UZyhimBq8LwdcpGCWhoD0P+
	 zfZHFvlzZTUCOtPIdRSc5hxyX1FffQgkVdzUdsasD4WFyr9mNcd2U4L1lymYepdVDBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052122;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=b6x1IJStrlOrCI3vi0nsVyx9+73Wt6QBs6SXZvtKBhY=;
	b=m7M5UdS+8pXu77reK2tysNVRnqlXL3L2TZ7DHiEKETKbx25yUDJAF3pWpsf5rMgDYhUX
	 F2lm+8RkO784I1TJppWNh7uMBjukrxeeL3GFABFZVVptZwX4vj7Ow3tmv04gRImCj5Pk2
	 AgFTtuBLnxnwsH9RZwY9fxhMIqVbGpdaW91vfmzSlGTrzcNFwjtx9hiQVEQEFk0NLgZLX
	 ND/QYRuox0RznXD4L4eVcdHs4GZAQKDcY2c7zNJN/L/3oA7lMr4wX5WHAO9Y/hKHGWo24
	 oMdz/1AutoRgVvV9zWYRg61oIf+Kv8Vh8+gnzJs0RPRI15DyaVrO1PEhbuO+l/PpW8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Jgac6jl5;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MgJ4Xsjq;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AC3606A322
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84AC3606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Jgac6jl5;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MgJ4Xsjq
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIoZSK4131714
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b6x1IJStrlOrCI3vi0nsVyx9+73Wt6QBs6SXZvtKBhY=; b=Jgac6jl5zny6hx6F
	VxcULzScJn39Uqi4GE637+/ATcF7fRDsezoEkZRmlhlQMYL2YN7lS610IJVowTHD
	Rs/BkFidwqfrAnupV4B2MIm1lqjEPvMI1HsRIpApMOcEU2IkfYz138CHkS5Gz/Uq
	0P8GxbJkAhDvCYVrdOtKkhkLN3umkX+TbGir5ywpPaqJrO9hzhGI0BHJ4Mwa+Gmg
	2Dcz85r8VqK1oNswnumytf1DaIKB4EZ3IwOu3c49Ouez3QGCvGVMcqIColgVXX5I
	yvl6uQPVSOr48okL1i3i2oBPIcoJjNPFBJdY7MWuJMENd8pzLM74MtvxXEIBihoO
	zDuqgw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hj79xt152-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:00 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c5aef2a74so16447093eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793052120; x=1793656920; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b6x1IJStrlOrCI3vi0nsVyx9+73Wt6QBs6SXZvtKBhY=;
        b=MgJ4XsjqUpsg8IqO6rtIUb9Ijjil7XAwX5+CiUzmFE/Ay84Y8oLQBnk2n+GvonXCcy
         mJ1s9QG00ZOMPa8QovFpxcCv0twEkWj943PgtXyovGXS4N9IzHhNWrZbeIV+jFms3FBi
         2Dzh6rJkf/ES1oD5IFLHA3ryNyfC8y0YV3bqlSudTyhHEAOaoyWEViELGC6Hzaogkani
         RxcGx7DwRMJhayqDnP2htUBZ2SrAfHw3dp7oxPpY11Hyir+DOTJadOim4PiH72FWhrPM
         zEHmQZkWRvLrlOV/S0I3Qby5RAGdaeIFjX7yPNpcbyazAjqlu8lHe7eeWeLgEOSZRP66
         D7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052120; x=1793656920;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b6x1IJStrlOrCI3vi0nsVyx9+73Wt6QBs6SXZvtKBhY=;
        b=uEX/sKBmb2Cd3kTdKxr6YhePHJ3mMvZh4wKa+fwEWp3lwVoEC7oFb01Cfol/h2jTNT
         bj9PAEjO9ninAgvA6ZmKfkp5PVByN7hk0XEOzBxTP1LMWLGm+7Tnm8rz72Zj2d82TAtA
         mcUUzsqPsbgpCsG1S8/7BOkdV+/PlAMkNPPuYCdN4jUshtltraf20xBJF8q7hbpt3j8z
         KkP6bQBiswRL3vLDj7qt4rLwe9thpbVd7a8X/utkV3y6tAEG/iK+jfItruV1bOImf5Ua
         FnVdltCMaBdhdF4sffzdWJugBDCYFLzAS6bCZx1gru3A8bT5rG2HrzdErhTJUI7OH41K
         +eqQ==
X-Forwarded-Encrypted: i=1; AKwUvByMmBUb3BmkBtSo7eOSmPvrAIDxO1WXL6qhSLNwnhC6E6+GHqXelwyIcPElCNY+d1QzkA667zT+DyoWR/59EQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLlxgcGcTSuDAVDNMG4bqBJEb5ZcY2FXxxUtYwidu9ImL6FUUew
	AhOoZwjq9bWd4yLXEhhgKu0G24X7kvg8NeB5/lI2VrSp75jm1KaUomTA+iAGiQBxYzKZs+xdzYz
	Fjv/z8pcdxXMITjvQp5s3QGsm0sR4tKR4u/el/OSuobZevY1r+vz3/ku187ReZQ2jakiWcFkp7k
	nEsg==
X-Gm-Gg: AYBFou1MQj7rkeqg1dKx8dFsutfne6K2WqP3s/96JzOjPV3hI51NjQV00pBAcQ7iWWf
	IVKax7gd/wTMVJ4RvBoHf2WBeKvhC1EPzktFCWNyPV6CAtpG1i6HIn/MyBGuk8xZOIwSVtTxJWG
	cSBHaiN2kFu0bTi0gdL5Hvn2JkIz2L/qBdg9nVBgUF9vbSI2B0dW/H+IdaK80DKunE0yNiNU0Jo
	jejVGknDnQJVuqVzlrgd+qChYojOZd2nYwHRpyZS+K48LksnVV9bzZaTVyit9AJ7A1R/oORCI33
	zBqjlQIF4u+GXT1fm7IXNKZMMkaHEYcu6UGLXTaAF7Bzck3T4zHJVivrrBJyu5W1C/VFErOXXod
	/veQRuBvpOdCk0hEVofNX2Ffg7fQan7shG6d9+J4gOwWgeD92WFw2SQ==
X-Received: by 2002:a05:693c:638f:20b0:36a:eea:df88 with SMTP id 5a478bee46e88-36a0eeae085mr1359727eec.19.1793052119864;
        Mon, 26 Oct 2026 15:01:59 -0700 (PDT)
X-Received: by 2002:a05:693c:638f:20b0:36a:eea:df88 with SMTP id 5a478bee46e88-36a0eeae085mr1359691eec.19.1793052119045;
        Mon, 26 Oct 2026 15:01:59 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a03bea5d4sm8443486eec.6.2026.10.26.15.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:01:58 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
References: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
Subject: Re: [PATCH ath-current] wifi: ath12k: Fix failure to create
 ath12k_dp_peer on MLO reconnect
Message-Id: <179305211811.3326479.14875064682698836541.b4-ty@b4>
Date: Mon, 26 Oct 2026 15:01:58 -0700
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
X-Mailer: b4 0.16.0
X-Proofpoint-ORIG-GUID: Avus2DwgEwuNSteYcANP9BSKDn0ut318
X-Proofpoint-GUID: Avus2DwgEwuNSteYcANP9BSKDn0ut318
X-Authority-Analysis: v=2.4 cv=FPyOVOos c=1 sm=1 tr=0 ts=6adfcdd8 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=RqEOnMJ171x9OPMy2F4A:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX/iA80nbEpvB3
 BCJv2q8lWfrmRkq6RTw+nTWo0XuEnCEvmnF9k8Ncsfwval3VqtMn+gYaB6pmhVqMWQnzyQQNPWb
 Yzzdij7yeDwas4xoH4WrAHO93z2uf6Z8wnGWtBbrhBhLkHorli4FnHs8YhiXW1G8jaAWkTUVBnJ
 OJv8OiKluQf+pOiLDnh6WvenueEv8KrawW5FXYuhmUveASlPJqveSsdhhhuFTuN14ePpWNm6A5V
 toCWJD8ffFGgcgtOa/JZRcspVBuDBGrnzj1UoAsrafPcCZsq4mUU03/FlVFcqc/5sFSOh4ina6u
 qamQX58EkE0ICCCxQOD3NtOYIxKVb7eNhVhSPPUKlJSnli6mPS0H65ZZgahuANob6UjJKIeTpbF
 3VBbNQukB8/ovjjFIEN0EC9gE+1O9zzQFVEQpCfW0VjBTz42fO4UPUc3+sZkbWAxYDXVaUvO1pw
 469Lf0OR+Is58d09Vig==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfXwsF0HrCZ+1dW
 eHT2hUeO4SqIFbt0LGqYytpmD1JIvsPeOI0CUZ0o295auSIdsB1ttOO4/Wcao1805E5HzcVT9HP
 AZgMGW+fRbMYLYZ+uAPUZopwLXBeLKQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260087


On Tue, 15 Sep 2026 16:00:53 +0800, Miaoqing Pan wrote:
> In ath12k_mac_op_sta_state(), when transitioning an MLO station from
> IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
> succeeds, on is_sta_assoc_link verification failure, it takes the
> 'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
> the dp_peers_list.
> 
> On the next connection attempt, ath12k_dp_peer_create() finds the stale
> entry and returns -EEXIST (-17):
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Fix failure to create ath12k_dp_peer on MLO reconnect
      commit: 8b6b871332b5078342b3f809d35da7e68f6f9c9a

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

