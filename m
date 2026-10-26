Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052126;
	b=Z/1hbLJyHB2xgUS6caaqaF9SSyVQx5SA/MmTtqDHbSf8j4IQA5CA1edQryQBdByOImdk
	 WK8CoRR2+MhYnkKA5VRpF3T1VdKr1AKo9rc7L6XmfsikIUZ85F1Vk0+DSSrc9A5jLexol
	 veoiprZWpYiAwlrChyg/y1uexJavzND59LMSpcug3G5b5RXU/PX5oD9p3fTDGL8LlA1Hz
	 MvwdNMfMX9z85SgidS1HpVvgWGt3W+Gb2g/tSj4MBYVTEk/69DS9g0zmlkEnkH/sFL3g/
	 FynAaMIgohtB6IIOKEHI48vD5uBtGVx4LMDn2UtEkW2XUpLCQ2oATFEUFiJSTmbJA5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052126;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=t7GNxgbyH7Vy5LfOanxyNBKmwX51eVAcx3oxe3eX+ao=;
	b=qSQcf+ip2uK34oGzBik3kXMYaeJHk7FpURn6FQLZitkvFPTzifHgyxfSas0U8TJm0WhO
	 zCuhErMx8gY6OZhAMjnlmy+/2TeI/C5Qy1Gip+F49IWPkX3TM8gVSnCVJkwkWG+1uOdpa
	 XFlVZlGzTkK+503MjbCULh1gU7XjF1u57QEUtYise51T/4VU86kAqv8fx1hZX5K3hlqju
	 niPmRuKkhtotT6AlTPYE7P00fpb51ZTjbzNV73haaqeXX13J1SO467jZ2uw3raIUs6lrt
	 exRhgVK4+RJFZS94Eh5s1w4iBEGfgZWf4IeOKSFBmgbXoGyy+1RDAMwh8bSOqF3owgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nlulyMVQ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Fi50l3us;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266FD606A320
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 266FD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nlulyMVQ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Fi50l3us
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIoLIV4095848
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t7GNxgbyH7Vy5LfOanxyNBKmwX51eVAcx3oxe3eX+ao=; b=nlulyMVQHTEVrmSV
	zdd8xDRuqkBKu+ggy+rmi+SXyzpAWl1k/BtFMO+KafjSH7hv/RijqhW1Z+BqbFCj
	TYrAz4kR4sSVBih3LVBPEo+wOwdMFtFt83X0NKUt8uacKaKdXoHTV07S7v/VA9l1
	1iQSY7+AgktrwLCODtZOhPnU8qJ2IADDucORcsXYFFS5/MFkVOqbVVq17NDU2R9z
	coKAhZKLQUJAnji3eS4OU14l6FbVS72+QDf5DG/NH5ftxVVdHK4Lfidg4UXnjQBO
	4r82rFSEb6lWAq7TfbK57iTiR9kfkVug4YPIMF2b7Hp+2XebGGFHkh+pXInvbF+Z
	QeX/6w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hhvddc8f9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:02:04 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36998507c13so2749433eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793052124; x=1793656924; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t7GNxgbyH7Vy5LfOanxyNBKmwX51eVAcx3oxe3eX+ao=;
        b=Fi50l3usCVPPCuhX5x/VebLPOXiv1lJYTB9w9bczVnWUupsA8dsC1Rz+xA3Q5O8Ttu
         7m+oV6Jgg6hoW5gUupdUEp/XeOWPPqMSbhNcSUYLxk9S6StTpPzugNXWQAhdXQaI+gNn
         n2NEpsg9UW6OoN0pbDK6OuM0RGGPorEbNIqn9YtVv0SWX1zLdhjHikzrOOwErRwiuVYI
         ogiEFs9XqmxWIlp8990GO1e4AIu+C/iRprjFMBnnlDo/1hIKjo3wJw6XHpuuAKNKpdbP
         Qf8m+WvhA0aU67Hq5gPeymH5EOIuVrSIZGf+FaoDqYTKfSQcX3QwDajzU0u/mbHHGS54
         BC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052124; x=1793656924;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t7GNxgbyH7Vy5LfOanxyNBKmwX51eVAcx3oxe3eX+ao=;
        b=EtCYyejXixAzo1tN6MaHWWllX2nhoje24QWyLuVSkseqdRq7shj8VXRtJniQqXdR6e
         8+iXw0k96PRtKo5CvSi6Ea8IbAu34x4viHw9b7alW5qSiU0EAMZpMr9/k0uoTSdXjuhN
         0ww2DUKZqPVNmsoV9+27DK6+pjGUe5+2dNWVMl4qCgXT1oOZmalDRWASoLk2MhbmCEjq
         grrwy9K2Wt27CmMZBSozBPI6m9xtBnJfuMCZS+IfUGuheOYjqAQrwJlD/Qx1kIbL8Gee
         EqVOKavmek3hf2lro9B4IrjAEY6iH7/i56BTMe9irZ7XOhyX577QPtTPftS5A2uSEQRU
         hcKw==
X-Gm-Message-State: AFq9FYKJVNdKmXHx5CD6EnwWG6+7dxUREiwrBiFIfWce3ppnlHPNGmEM
	wq0L+TQsrI9rD+e3rt++vFzBH5oTzmjRcuMpN0FcGwAkx8WuCrvt6gE/0m5KsG50hSMF+3zqx5u
	OYDQ1jI1aBf/4FzwPthjHwzq+QiydldoknxrwIwwj46XyUZwCqObNR+14ofw5cyhN7OPRaclv9y
	hfAg==
X-Gm-Gg: AYBFou2BAwEowhLbo+aGa9AylKPNZDJImCBf9oK5aelrZ2kaajd2E0Szvh06pFCj2KK
	2sYrDKFbmj67fEeI6lyMQ/8LeAT09gJm7nnz5zJu62+MBCfER3nmkSNXA5HuqhJi5g8oHRTkLtb
	at8wuANAhfqvaRMbn4VkrwTseGqlXcyipHmrJSawjcenXu2zZkxyyPRspolyCJn6qxFr71O8CUi
	VaqkzWhD86120D07VbatL1bDvf/k6OkRd1GMV9ZFLJYOhAoFUiHHRHeNovAfMj7Kx4JIgppznVv
	zRv5HXgsq1LGgIkUIQk6d/pnifJyLT4gK7ETVSRq7ouMeHDHflgYOYOFQF06lcCKKfy7S39DQBN
	61HBNlnIxUvMKDCORKssS0B/oNHTtkzB57nNFYWYc/Lvf2dSLDSGGTw==
X-Received: by 2002:a05:693c:42ce:b0:369:f0ac:fe06 with SMTP id 5a478bee46e88-369f0ad02demr10405394eec.6.1793052123490;
        Mon, 26 Oct 2026 15:02:03 -0700 (PDT)
X-Received: by 2002:a05:693c:42ce:b0:369:f0ac:fe06 with SMTP id 5a478bee46e88-369f0ad02demr10405356eec.6.1793052122667;
        Mon, 26 Oct 2026 15:02:02 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a03bea5d4sm8443486eec.6.2026.10.26.15.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:01:59 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Mehmet Fide <mehmet.fide@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        mehmet.fide@screeningeagle.com
In-Reply-To: <20261005072209.4101009-1-mehmet.fide@gmail.com>
References: <20261005072209.4101009-1-mehmet.fide@gmail.com>
Subject: Re: [PATCH ath-current 0/2] wifi: ath9k_htc: start ANI for an AP
 interface at the right time
Message-Id: <179305211921.3326479.12394237462076417931.b4-ty@b4>
Date: Mon, 26 Oct 2026 15:01:59 -0700
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
X-Proofpoint-ORIG-GUID: cL3TnmntxhkT8v1M2JhN7GEv8VMs0kzy
X-Proofpoint-GUID: cL3TnmntxhkT8v1M2JhN7GEv8VMs0kzy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX7bJZe4BDj3kn
 IAntaa6QiSRMZ4jNOnrFqEEiV8BvjO5LfWqTGAMGzIK6WxdR6RVCaAv11ksaVsOK7kkZ4fn3zku
 nG8fNu7L6Dg44sF0tA7mkU/cHPcO4MSZkvtr0NRNnUdOJ+sIPpuhtDRSqcbTZrebn2nJHIzqbvL
 Q/oouMJSbjNkIU43axtnhBC+yqgNy/zDsV5yxcBWHDe6DfIYvSwnK39HokS+HlfGWi784FAczbs
 +sWUXY744Oaj4TGk4yGjXpamwBK7K5+jqVSY0EYhAaCkVJ10+4kmUe+qiT3Pty5eaJW7SgeBXd+
 6biZ2wSbhelxUsrZ7m3x8VIS9Sl4hX5SqNUXD7LZJ/7dqFCBa2iA9jyZVT+Rcdb/m969e2MjGl0
 ymfFfO6BbmJX7qXJNO+RoFQKGWO3WkV1g1OA20XSatFcUdHPNnJ2pf8xLyYy03lgBkwvIoCols9
 OkHGugiPUo6H+PAmrzw==
X-Authority-Analysis: v=2.4 cv=N8+8hG9B c=1 sm=1 tr=0 ts=6adfcddc cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=anw-P6zLAAAA:8 a=EUspDBNiAAAA:8 a=5QJDrcrzCqXBdyyA0DsA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=7_zPmhNiJtJTypZd5sO0:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX8bmdmmF+2xdP
 Kix1dfVBjtiFEm6iTETvw9j6VolmVp9/K9YtLSsXVRNAoIJJ1G5pAZnsXkXe6vgqd3FUkXPQcBU
 eMdJhU4WHHWtalWhmuRKOMKh7Ab5P1g=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260087


On Mon, 05 Oct 2026 09:22:07 +0200, Mehmet Fide wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> ath9k_htc starts ANI for an AP interface in add_interface, before a
> channel and the calibration data exist. When the bring-up stalls
> between add_interface and the first channel configuration, the first
> ANI tick dereferences a NULL ah->caldata and the device does not
> recover. Patch 1 removes that start. Patch 2 starts ANI once the
> interface beacons, which is where ath9k_htc_vif_reconfig() already
> re-arms it after a channel change; without it ANI and the periodic
> calibration never ran during a normal AP start.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath9k_htc: do not start ANI before the first channel is set
      commit: 86210ad4ddf1aedcaa45bde16d829fc27aa7c5c9
[2/2] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
      commit: 9f0fe5ad0c9af369400bb87143bc936ebb741391

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

