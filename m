Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02AA46F49C
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664145; cv=none; b=ndN8pJVTz+IFMPzx3AspacRAZk8iJZNZIwul007JQP8kwGTPgPKwZGbjsQtG90VfLuryzRwcfd3twZzma1fQzXInJm4U1sXsL1e+GQKKcwjLrhLhPfTEo+pQXgsmkglow/duHJiiUU5TY9htmPUwzHR265CpR19h5UT2qFULLuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664145; c=relaxed/simple;
	bh=YO2VVX1yQSjMUusw5wU3I1Wtkd/rxKSndocp84gGRzM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fYqC2PB46gGZCusj2jxk+A2z7bYmkPXal2wiCrCFFFBLcJZ6ibbqbfyXd5eda3y9v2/GHpNPzZxzJT9aT2bOoU6dkmVVwRDV1XHds8RnU+Xx0glk2MOohY9JrF8bSTO4lb2A/Jr7cHyaH74/mdsnZTvjrR5OKDqKxUYjsAn1vuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BRiwE78s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gKQ1tAzM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BRiwE78s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gKQ1tAzM"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LH2dgg2280226
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Lb8ztYm4xqlZZ0kex2S3OG/vVlZEneV88+4frBDQCA8=; b=BRiwE78sYIhHzNz5
	2f/vKiWU2OcTlw4c++cVuOotkK0tjBJDmvGIXjO5VP8mNvmy43xE95CWY3WyBFF+
	Ujiu8AmtYMcMBRLUADNhP/YlfeTyBBhmQ8TL/VJ6nIcEdIVveTvpKMAlj3AAOppM
	GTFPETOrhgfiBE0Uf0wmWgBhenql/2p0LXHytkz+9j4n16BvbZv6PBqp8fM6vNTC
	lggR8382JMKafMG/kcgKrrmzCUiJG+Vc2TtngAdiFHbKVUyjwD8qo7FbXZeXZCnJ
	Um5uUgtArhszp2DmtnfgNz8E8cKXl6+Q/rI0CEydZBwmlgjAqCTCiM9+RcGVW9Gj
	KDJZmw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6paasds-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:22 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c892143db7fso7256386a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 13:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784664142; x=1785268942; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lb8ztYm4xqlZZ0kex2S3OG/vVlZEneV88+4frBDQCA8=;
        b=gKQ1tAzMt+iaJXSSxOtFq9Y22GgFhd6yXAL7q5hAheT6h7WW6GdW1CjYeMKgp4a1Kb
         uRQHXp1axgSRpNQuZ/5E8GajsEqtzcNloSzWUyM27Wz4lgqJ/s/GDl8iIPLaL9Ee/zw5
         PEHnPSJDgkqUCHjfBk20KQXttIjT3hiVZW6LHktj820m7+GdfF2SFNj1sN6djN2PYR2a
         4JAn5xZ1Dn+7gn1LnpEiSJyvp+dgfGEtq/85Fv9/0pJRJ0Fsx80YA2ivDnzLfy1Rwh2c
         3DIrGFDK+eHXSqiJeIKhyhGkYum1BBeCHwCinRB327Ngk/HD8zzAkLMhJd1+istTJKTz
         hVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784664142; x=1785268942;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lb8ztYm4xqlZZ0kex2S3OG/vVlZEneV88+4frBDQCA8=;
        b=MuJ2GLPabzOsWOaTlyyryvHty3HGCjb9WaHRLvdXLdk6mFYIXUWUdfSlqMbklH01Uc
         ngp2KEjcpYd3j7GX915VX3KUZMtCWBt3Nn9jjMYVqdoTu91pTrWcwi6dvj5lzQv1XWm3
         hr1Va51Nkk0dzdjIQYC0PHdfE1xPZUT0nFv199nXjfnHNdUNQcdz8vi3PBfqRDPZZscF
         SF8kGDAz0BTaJ9f1MCMQjZ84qSvh9ftg6p/6IdCdpEtglv9328yy+ucp7tCg590J8Wkh
         vxXybQzwS+2nzXMv2Qf9XaxEZgMIIOJWhKpbbpcpus5ZjdW6h0bh3goLbnxJDci4mZ2a
         qfFA==
X-Forwarded-Encrypted: i=1; AHgh+RolGxOFr6lfbqP0iRdsXAEBZ2CUluQsppjl9dVid+ox2og/fVu8lDMQZ85IJYd9THicJBJcUNrbuQBABsuY0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLG3+BrXZrRSXPKcEG4cT0/OZaobvNjbS7R/VgbSUPPTrr5UA/
	/aOwvKmgzMbd7BbmdluS3jnAKgvwF8Qjo8cAMnKh+diBxwL9ZaxxYIRVazZm1Pw4Fm0VpDwPx0E
	IUzGq4c5HBYJPrW7vIy8PCO+09qLTx+xifLBuJGsZ0yI6ExDa/OL2hsvTyhvF7XVbCYnM3g==
X-Gm-Gg: AR+sD101rv0TH57WaGS7g2mE3LTUz0Ws32CrfgxfKNB8iPg6u2zKp1Js/ew/mPgEu1a
	dYYyMLvBK7uyxzACMLt2Fggb+nW087S9YzvyZ0zDIC5h0jrmpsmrJV+G5+zfhazVcMK1YzXYwb9
	swVSlxUBOYOGorx+5zYOAa7rg/fPc8ygzK3uKeC4Cslm5y9Kon76VIpIGo9bnzPluIanpfCbxWU
	JRbLGlk1ARniX1Ps5B46hcEUCFUZHFwdQQtovdQr0aB4psXqNjqo/fIbaR6t68Jbc56FRviummp
	erpvOf7FEpzn+A7fQRg95FODvG+F3sx+x/7k2FtS0Wkp88ylQOk5WVCRCgg3sJppmBgu8DLS5/5
	sP/I24numNyJ2gCPdmTiP/1YWbljLyOWOHwsAmwOV+/rU5h1MYFoh1DU=
X-Received: by 2002:a05:6300:512:10b0:3c3:daa2:2b7 with SMTP id adf61e73a8af0-3c3daa202e2mr10287557637.44.1784664141516;
        Tue, 21 Jul 2026 13:02:21 -0700 (PDT)
X-Received: by 2002:a05:6300:512:10b0:3c3:daa2:2b7 with SMTP id adf61e73a8af0-3c3daa202e2mr10287517637.44.1784664141057;
        Tue, 21 Jul 2026 13:02:21 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc1b99esm1574958eec.3.2026.07.21.13.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:02:20 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Matthew Leach <matthew.leach@collabora.com>
Cc: Kalle Valo <kvalo@kernel.org>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Sriram R <quic_srirrama@quicinc.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Nicolas Escande <nico.escande@gmail.com>,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>
In-Reply-To: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
References: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
Subject: Re: [PATCH v3] wifi: ath12k: fix survey indexing across bands
Message-Id: <178466414007.1747165.17084648998286616462.b4-ty@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 13:02:20 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: fsN5TJx79uaF9KyggMKZBYwrsfn9Ujxu
X-Proofpoint-ORIG-GUID: fsN5TJx79uaF9KyggMKZBYwrsfn9Ujxu
X-Authority-Analysis: v=2.4 cv=eYYNubEH c=1 sm=1 tr=0 ts=6a5fd04e cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=hD0QNefKyflHWApe_3EA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfX2EAVXGaHETab
 GacmPRmJsZeN0zYYXR9JoDErDbDlOcnmI01h4bscIHbHKASLo/rkyPQgJJBqHouzeYO2ltFOHPr
 /FBRMfZXFXtJibn9u4Q6CzMKOVMxgm9oAtX0BDW6nyLJkrGWIfuyseARyJQn0Z7TIrKC6qx3AcV
 mZAOl4CCh5aki6MZX5naWy5kO1k/wTFpRNbZj7B5PmPGBpQH5i6h93Wed0+bxjkDM/kEDtn8ivZ
 YhQ/qwGwqsRDRtiFjBBFqjlU7LegrbHDXKAIRnfu+e8thi8Y05vsB6F0Yjbn9Omwei/K6EcKHQ3
 ldJkKO6vAk2qpMiMCm0F24LKgNMj1jFmhoBx3KdhQnavTfp449ZOQ8tLYzY2KK0kDihTBTxRnn3
 gPnTqpAcyUOcCO7zwKamD10Ul8Ji9dzQtrf6XXGbPTh20gUiAiX9znxLxeIYNdC1hhKMr74+pR4
 0aFtfyFwedpn2Yl93SQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfX5bR4lg0vpgOH
 Coy3zBbVhdWu9fRv589r8JNvTw9uX8EyE76kKmW7jj48Gm2rH0SS8z/937EBCXbk26rdQQ9AszM
 Co2HXm1hSEsBGl+Jctw9vDDKWfDHXnI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210208


On Fri, 03 Jul 2026 16:56:02 +0100, Matthew Leach wrote:
> When running 'iw dev wlan0 survey dump' the values for the channel busy
> time have the same sequence across bands. This is caused by indexing
> into the ath12k survey array using a band-local index rather than the
> global index passed by mac80211. This results in surveys for 5 GHz and 6
> GHz channels returning values from 2.4 GHz slots, making the survey
> unusable on those bands. Further, there are redundant survey slots for
> multi-radio/single-phy instances.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix survey indexing across bands
      commit: 6cee0214da2f9214d85a87eb6300bf7e23038bb1

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

