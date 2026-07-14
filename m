Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5564D3D6487
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052491; cv=none; b=dMaBf0aPNBPDVtq8NY266Xb+vQfVhhn7BIhsJ2IthA/CmQn8ZM61sc/V2yeUCUVaKIuFyccAon8wRVVoq9oGhFHeV4mUWVt0vhxYJqSkN3Hu7jDCQ9NWAOwjzvhqFLcQUMQXyyIHaVhGMUzoGJTb9XaTfVlbPoFWsCP7mFdfpe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052491; c=relaxed/simple;
	bh=jOL4uNDE1NQhSN6Gjt0+8fruV5fJ4c6RnLEXilhrPdE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ipQ37Pp9qK2RVyoPDzsZSITlnILAFy8M3pbg29oj02yiFCe6UDFrWEeB7W8PCFe/L37XjaDmN/Tq6KbcswgAE1VMsBegAVvXRsehIda7VaGUcSigusBTp76pGKAPBIJGwSPotm5eCclQocJW2CLjuDklqnsxIQorKLIOOnO8jL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jtZgxNsD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RBpe0AUu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jtZgxNsD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RBpe0AUu"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66EG71Br1004096
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 18:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h+blgakAhsfKCNclx6cZEtzfMJEN4zUflrr2P/mTzQI=; b=jtZgxNsDcLnKP/Gu
	8ByGwxt6dyT6TqE0GpB6A0n7JAjVm6cijxoju4DVKMjoru6u9rkZHpqA4rlZ/h97
	qOX7BMxVBhwilsgs3ztvPA1ku98ysig/NBSXcSJbKblCjdB4smfxksalv3CwAHpO
	KYb/fVK152LMK4RcT4WHIBlpPbR60UCDUNfkEdI1+TSftaHUVKPzFh45B75ZnJXt
	n6hTLXA61rEaa1qpT5Xlio/Z6pCMoqs+Fce1/+SvPtYCk8cp+HrG1NALzKY57PSd
	XHMbmz8xwdvwaaP9u+vajyCLTIWk/UlOmrywSElaSMX837r4P0HzMEwv38k0Ex/6
	6GoxrQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fdnnr193g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 18:08:09 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8eec6acbe21so105839866d6.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784052488; x=1784657288; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h+blgakAhsfKCNclx6cZEtzfMJEN4zUflrr2P/mTzQI=;
        b=RBpe0AUuWXug0AOX85qJBExmseKxG/hMVhxQsBAcldZl/5Xvq1dDHpqrsng9i1XzxV
         Q0ImO44odjUkEHgmQ6vV6R2DlKxmhGRc7N4PsTpWtxGfkWyUTwdX2axEYMUG2q/5nK5L
         +R7tdGzYfbw20XBh4CdRDU03YDtv2ju6Wc08eSGnfvD3il9nhsKk2WMLlJxIAdOGDu3F
         +uMGqJ/Id+zlo50hXo2eKTIRdY7ap2eO+2i/a/O8QIiSsdQ1h84i6h2pmUriXEymt3fp
         0xLwYBZSRLTlugb4AguJvMcXLS1U4sNgsKodN4iK8vas4XeY+FG+WsuPmmG0iu8xVvJ+
         z2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784052488; x=1784657288;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h+blgakAhsfKCNclx6cZEtzfMJEN4zUflrr2P/mTzQI=;
        b=BuTnyagajlxvTRWaYqrQxj4zoDkcRP3p41RyWncm5jFtqr81lgNlXUylI7v1bZelAG
         UycHTLLiuYrh1ehriGQbByZ/qUHCfFEyxAY/Q3d1ikdbvi0OugREgCraYmNkAWVcaoKS
         SS37/RX7JO00063cASw9BrWg6adDzHeV2v1mKVe4Xn3CB+VIshmKEkuZ1PLYGuaxFt/3
         lnIUJGwqzyb0iezrEm8KflEghqeUTICChiFqw6CANmPCSg0h8I3GSUTPJLk2f0guGZeK
         MwJmJr9AttXLnhxe4Am8fqy0TmkmuCkmGNWAme7IaOGWKlR/USkjFOmQFZr3aqQkyQKT
         vKVA==
X-Gm-Message-State: AOJu0Yytjg4ncwTlGvDiP2FGpuTpH2rHK+2uKwhX0UYKbtEobRc/I6KB
	0JvXphv5RUUpqOtnc9HgfQmOiuXSUqARjTRA4lkvzOVKmlu1AvoQC6nygYa5j065/71neAO2uay
	O7RXcxtNWh20amUcqzD/WzRYLjoR5wqqcX/FiivK0/K9MBuoTLcfc0yG02bkGEvJ/IoV9LmxcDg
	q11w==
X-Gm-Gg: AfdE7cmsopBpSGfgL7uSJEc1nWGaIiIUiwNqC999AJDC65RgUOMFyTNTf8HS8hkjmSE
	zp7FmSmaBxesdfXr6ZAlpBqWL+yWHt4ZPvz9YOYz/2laAvtHq41Ss/CoLkTnk3Wx9rYacZQfb3r
	8GVprYt8ulLaAp97qto0NVy7RdES8UVcoyyyNy7vZ7WyhaE6t2dp/403H/X3BP1O2Jjj/R320VZ
	bDqOfjz33EP3o5Nowsn5+q+qdbfev/CeP8B+snOUnxeUxnRRrZkFydV6vgSdxu5noLcdzPBTZ7a
	1/PC+GeQXBBi3wLQIABT8CeeFl1VMTx3NIKHuWChWd0ksT9SaCLOoV8z64mWku1kHYKoSS3EIoS
	OcIQECQ+ZJueQ36QXlybPGNSYVDYMxsFEP2UDconQaFl61K5kKpp0Xo4A2H46NaG8aQ==
X-Received: by 2002:a05:620a:284c:b0:92e:7f13:1489 with SMTP id af79cd13be357-92ef2b4b8c4mr1476786385a.10.1784052488527;
        Tue, 14 Jul 2026 11:08:08 -0700 (PDT)
X-Received: by 2002:a05:620a:284c:b0:92e:7f13:1489 with SMTP id af79cd13be357-92ef2b4b8c4mr1476781285a.10.1784052488090;
        Tue, 14 Jul 2026 11:08:08 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930759c63fbsm465448885a.22.2026.07.14.11.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:08:07 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260710053534.879233-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260710053534.879233-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: update IPQ5332 BDF address
 offset
Message-Id: <178405248657.4102418.408455253026492644.b4-ty@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 11:08:06 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDE4OCBTYWx0ZWRfX7FIoOypMexRP
 e8CStC93JEQwet6+1XvqF7wLijbOlwNN0Umhp5m0c2rfR+LHV/JeH4rTdroKw9j8Fz11zsaUcBi
 cLjplzAldUQdqHCov5Oacn2nOliryz0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDE4OCBTYWx0ZWRfXw7MqRIzSM3m+
 Qe/yfT/bV2whhA3JjirWaPbD/IxW/wYNweQJSx9EyGvthd/fYtUds0cHj7ZjV91D8/odbJcaSYR
 gYmquzZilMlIpIx4z9vrDuHNAavSrBSwTBWQjHl+LYf3tBgtw3mXl1csuR+VQLZn0H5PKw+OiGw
 VFITczS4itktXov8+Tv0yW7+K5ypWe9EAJojGB77tCAZ38o0WJCkYKHAPfMAj1EOCDJW9xczxli
 SsHymQ03+ky2kLvHHJRL7cJyh/sFj6wPftJ1sqN2zG97ZqSgNBN5TmzlILQ3PFq9c8wUavVc9P0
 62FmMrnOlb7OVbIH0aiJI47zxyh+3sckaawMlfQMkTEbJvA3pYMbbTtLuc6VhTntjMv5B0WSeEu
 yZyqNIdx4CBn7ht5U6t/Xt2BoVHLEezx0SkDXhhDmk7uVjuiTZLT781PQhGF2l9ILmyOjcyzZC5
 /FrxGcHhLeuObaJGE2g==
X-Proofpoint-ORIG-GUID: 0_80Qp6E411YtAlVRbxbDtl7OLyot2Mw
X-Authority-Analysis: v=2.4 cv=NfPWEWD4 c=1 sm=1 tr=0 ts=6a567b09 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=XavOMYws26oirl0MwwMA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: 0_80Qp6E411YtAlVRbxbDtl7OLyot2Mw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_04,2026-07-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015 spamscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140188


On Fri, 10 Jul 2026 11:05:34 +0530, Aaradhana Sahu wrote:
> In the ath12k driver, the BDF_MEM_REGION_TYPE address is derived by
> adding a fixed bdf_addr_offset to the WCSS Q6 region base address.
> 
> The current offset (0xC00000) works only when the Q6 region contains
> the IPQ5332 ucode alone. On some IPQ5332 platform variants, additional
> devices share the same WCSS Q6 processor and place their firmware
> ucode in the same Q6 region. This results in multiple ucode sections
> within the region, and the existing offset can cause the BDF memory
> region to overlap with firmware read-only sections, which can lead to
> firmware crash and driver boot failure.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: update IPQ5332 BDF address offset
      commit: 7bbce23531417dfbf9a2c1a38f31010a1afdfc91

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

