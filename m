Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BC53947B5
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976667; cv=none; b=ta/oTpjh9bNe7k9uP17GpPJn0Uw4mkwr6P2HaunIQxGaUAOANqiBZQrLNbMB44R8r2jUQ0rFJOdFGGEKDdyP+uWo224HzvA89Bcuxtbv/Yset9olronzBuTV054SD55oSTjQDnifGE6E2DuC5r7p0DeiOTVLoY6In+PX7LZdUW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976667; c=relaxed/simple;
	bh=X20evuPhBrJC+OG8yxbBvKZ3NaL8TNIuAH80FsqEqVw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dQAy9fDebXZg7j4UbW1Ufmc+4s0u7gVtjitKQehfB9BaDmQhYKaqTb1HZk9UsT/vmjw0D/znGjV+D75OrcmoLi4mD1W9mfWfOUPPHykjQmSP/IXlBlcby0Np3UoWNmO/pA1xo4vYzumJrSsIgrRgQyG+VEJsyTvX2dseTzKsOR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=POpwW0y1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DTieft2z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="POpwW0y1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DTieft2z"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H7ZlP2065287
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	F5lixX1Alyq/0zdhWcJ9wc/nl03/G/Kw2uZA3TA+6b4=; b=POpwW0y1EESu7+75
	dNf3deop60NNEJTqmlFEvI2f5AbOdtUVm9mUJc2LgvbN6Tpwc8sCzFGiKTwYDW9k
	l0lBIBXb+yN8aK4njZjiBLgJM5ofjPPRML+v6NLrHF5ZzdNr34PWrjuw4gU3s0ZZ
	iELwemRDSb/MaXpJX/IW86dYdbSi/J5672zBbQn0dC5r2mhq9RjzKLZAQG37H+eV
	rG4vLKr8kFyyQ2lzV4+r+Idv8arH8ndjWmoJQnZpzQvqzvoIA5EEFgKW6XOrn3y3
	ZI1jU6Bg3AsVCTySSeFNqyG82AwyDH/RERUcJ3tTL7kDFoDzEVFnHsg+7KUMeCq4
	37iEIg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk78x1p31-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:44 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ce7dff6253so1046065ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976664; x=1789581464; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F5lixX1Alyq/0zdhWcJ9wc/nl03/G/Kw2uZA3TA+6b4=;
        b=DTieft2zFLhTy+si3bXzA6ttIvGOHy7QxflUCU+0Lt7xnBTGju2qCQveGUQVeCV2iQ
         mlxX1WZtNjzm822hIGHZAODx2OZ8B9ncnBi62slWfdLPkYyGINHxGxg/TWsFRycQDa6g
         +P5XbhxuzmJ3S3VhIBvAmygemwT/h6iZpeTqPiAkh73C96VTtIcAgHlfDPE5PBWvpcsB
         cGuULzM/I2DPlzpLWrNG7JXgqPFaDGjcjHnQ3v6wOFETT29pD0vY44i9MUp0PDT6pWMH
         dmRMgOM/K3LfLSKcQ/m9nL99ikE6J87ONctbJC4T/wMSQ9xhsLyctHo2asnGXaTs0Sgv
         DaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976664; x=1789581464;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F5lixX1Alyq/0zdhWcJ9wc/nl03/G/Kw2uZA3TA+6b4=;
        b=J+Wa9kW9jBkZDmlkVQqU9PLKA+zdESf/JmJLU5I7sinbVgyg+9xKlBWWq/hJSckZQg
         NR/Xr/u2nSYJVdo2piFwcM4ChYQxNw7fZTi2b60QHuFyR8y+mfrSLu1LSm2ksXSqxJe1
         XwrlQs+zoQ9OJn/eQ2+gDaWJhW7EfvAKf8jg3WL2Jgk1bDrdezluEGIl1RSQ+CJVDTeL
         7uZ5YjMEIotOk34WKKAr+qhJx39S9yGir08EQto70QLrlRQ/2HXbXrgyH/iAu97JmJMh
         P5z/Ln3pZEnqXS5DaNY2eWW5JNg6nKiAsQ3YsWftXkvLjutjJFyayvVsnJRV25cxpjnu
         uOCQ==
X-Forwarded-Encrypted: i=1; AKwUvBytP7ccWM1YrLP1A588Q45BvWS/55Y9M5WGgRIwCdf+bDAXgiQ9UZn99aLt08+Rob2kVnKuE+69swKM11O3ZQ==@vger.kernel.org
X-Gm-Message-State: AFuF++l2YLButT4DFc6p0dlav29M4aUxz2hJIx7mAMan0DGNwf+YmLki
	eT8x5VGnJ2Bopo7FIDmAh5xO26R2UHe3szI0z1/KN6dXYTlnFbxU4VzlctuZIY1x9xzwu3fEv/w
	iMPkjCpVcDzPV39nberzEvyuPhRiHTvrCozN9cZfT4tKOwP0f5ReoAkLpeLUhbwzc8FeP4fqWb5
	ai3Q==
X-Gm-Gg: AYBFou3I8dflpWRefZJd7qh3wzjMqR/whPsAZFJm2qBpFNLaUcEtk0Uy7zYLU5iVd53
	tRcmrBYERj1M5eyztgjlzOJoMgyfJJJ5pUhEHhlp8H68bszZKNNsGaWN5jPFMvq/ah6TG2/oiZB
	E6JREHxYRoynFpKHnVL9IoIh+NSOJMEICEXsl0m7mO4ZklTNjcYLXodH4Q7tDJT+pA8T6ZsMJx3
	RHDjn/uYQva/7SyIRQ0KzU0Uk5zSD4RUSprXT5cDuhECq7F25tMh8/IduwUpOTeigVjfBGpXN5L
	KqF2uYp2jA9b0VKIrKr3WEdGitZ1qWVFOP1uLVnr8N5S8CqwOgEM+N/xEjzEvDsYUszun58rTBM
	FgYyi/G1kFAxzHp+0gHz7Qu97XR0EtJdZKrSrgXK589s7x8zRaK1K2TQ=
X-Received: by 2002:a17:90a:d445:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-39d77962e7emr439398a91.9.1788976664172;
        Wed, 09 Sep 2026 10:57:44 -0700 (PDT)
X-Received: by 2002:a17:90a:d445:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-39d77962e7emr439349a91.9.1788976663575;
        Wed, 09 Sep 2026 10:57:43 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:40 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Kamil Bienkiewicz <perceivalpercy@gmail.com>
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260828005126.1685832-1-perceivalpercy@gmail.com>
References: <20260828005126.1685832-1-perceivalpercy@gmail.com>
Subject: Re: [PATCH v3] wifi: ath12k: advertise AP_VLAN interface mode for
 IPQ5332
Message-Id: <178897666026.2048605.8140168520113839058.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: 3utBSQ-t_k3f1C6_Hp5zS8W3EUPN51NX
X-Proofpoint-GUID: 3utBSQ-t_k3f1C6_Hp5zS8W3EUPN51NX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXygAstWXzzm/g
 8/jcPX6eqLn8diMvGDqymp/BqF7T1ho7cPUV5vwqfQVAf5MwDReh5bjuM/L8WRMIi9ZWV1gCeDj
 o34JrHTnQDapkgCyFYfEdnLf2Abrgh4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX/IlIwXqmQEft
 hA2dYveN0jSRKCWZDqTl2UnEJ5SfnDaqgYwLI+5L4gGr8rgoT4c8EgM98aHNGleojrzx04h9sDN
 FyAQ6jdpYwBC33l6SRj0+3LGLENbrIF8PC8ZGNKicuZTDHc+EpLNtsfYTCaSlXbkajqqHM6GMPn
 e4mQp9u9FkUBccefivspqllBezD5woORzo9m/YICsFF1JA+/ZfDObAFRMZBxQnE5AuDhzXV6d84
 x1h2G5XblFUkg6uPL7NmRBLwQIdSNbOv0N5EYG/jCbZUVJP//+8h6gInuQiV4leO4r/ozrLLkge
 BK4jPdfrcQvPNBpEMeVTeJLPkDwbWFF1t1omXYavaccdRlt7yt/q4wh3epGtzxaYkciVSL+Z+HD
 Xqf+VRCI00KR9jd7R5dERLso89cHYKZg9K0CIaMp2XSmaUiL9cGNw/Ket1fUfhD0UfNdIbszIe1
 1goxCjfEfVA4TuZJp9A==
X-Authority-Analysis: v=2.4 cv=SvWgLvO0 c=1 sm=1 tr=0 ts=6aa19e18 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=se3CdF6FxZ-kOEWZ8NQA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609090200


On Fri, 28 Aug 2026 02:51:26 +0200, Kamil Bienkiewicz wrote:
> Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
> IPQ5332 entry does not. ath12k sets SW_CRYPTO_CONTROL, so mac80211 does
> not add the mode on the driver's behalf either -- ieee80211_alloc_hw_nm()
> only does that for drivers that leave SW_CRYPTO_CONTROL clear, leaving
> the declaration to drivers that can transmit software-encrypted frames.
> 
> AP/VLAN is therefore absent from the wiphy, and creating an AP_VLAN
> interface without NL80211_ATTR_4ADDR is rejected by
> cfg80211_iftype_allowed():
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332
      commit: 6a0832c986f14518645714be87724f13e9d59a95

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

