Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490B83D967F
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 19:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462188; cv=none; b=CyIyebC7/EtRBc/KF8xLHtJfM2g+a7+SDdE1yMRKy1IUmVorqU+RZrIY6RRIJaWnkNrRPzyakqNE/Tb6adnoc3unkrgcrA11VvTpbPGw0W+NhqT6Z6FselDw6/YbUmVOC5Q8u7kFyZrFG7tMweAdd1T7vjQ4QxjofSoZxrSZByI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462188; c=relaxed/simple;
	bh=XT/qGuH5ajK6geTMTnhbyJi3t8XJB4xQfx54BBU65p4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UEJm2m3vxrMIbRC8Ium3z4ER+xWl+AknRNkqyslFEN7BcgMiF2dGTAq9rC3UQ/5vQNUopLesB8+GOcDgcs7g2XCABtlYK62sHEmPInaTvwHWp5kuuQnmjF5sUX1oJ2EXHrvGPtj9JsEQMCn+qyGeC2u9lLPq5CeT/I2S5BDz4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZKo1RqrH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZkdI/DA7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZKo1RqrH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZkdI/DA7"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G365J2088746
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 19:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	otnhIM+6XCfAc1zPwSGd8LxiWb9OVU0zzutrB2IfRWM=; b=ZKo1RqrHvRChrokh
	ZV70+7AQ098MKKNJ7fgDITflBLw8XrtkZFNv5g1dNmsP3ZWI9mCem4MBlFAUgxAR
	58JDMKa7WGsJuUZlRZtCGEk4noSjddILxBHMa2TYsZTfKwXqPpDJDLYB5mq1trAn
	jQY8oDcv+ldmUU7/yMKmk0YdpbVHbtdCNx5XNQa+JgWgy9Ug5FpXWyMBK12hQ7bG
	hZK8SlZwZ7HlJY4zXJSGMf24dttNS91wwc838zMb0/QHx2wtakMogwZ1jlSa7Snk
	0j368iebO6l4ACxE9NfYgTmDp8ipJH4t/sxHMvQ55WgHyTUETEtZOoN9txRzdeiY
	MNLOoQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gf9b19scy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:02:55 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3968dfff779so198177a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 12:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788462175; x=1789066975; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=otnhIM+6XCfAc1zPwSGd8LxiWb9OVU0zzutrB2IfRWM=;
        b=ZkdI/DA7R+8h3OkfZMc19J19asfLwdZOqwnHhGu74gb02dHQsc66zN+6wy67mzPSfy
         3EmJLi8her2tN/EO6lrh3JjbsprkI0mX3iP10GibzRgbXzzv6O23M0HfRWx8nE/SBoOO
         I/WIicnByv4AgAmRUidxR3q3e8k3wMr5Ur0JRRkE2EMM8jO45c5IbvtfxYeJCJowyOgL
         wax1aVtDzlDXN+Jhh2UagbwxCNy6FPy8Cbo276SCBkx5HOLl5KFrDN/O6y9zvG96B4h3
         Z8Z88paEPBL8QRfwPXLz8kDjmO+LOVb736ZQfMR6lHjPQrKyf5gCrFoDuXkzIHci2GGk
         1Mgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462175; x=1789066975;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=otnhIM+6XCfAc1zPwSGd8LxiWb9OVU0zzutrB2IfRWM=;
        b=bogrVfSf/lV8XNf4RYTDPoCF2iKX4Go9iG6Ckiaj2QnuXBtr+f/z0C4HigyvbISPaj
         d3q8UrLCN77S00marbEoPwRRil0sNfGDVU1FYgJFSBDR7+45pMGYZLKFlJ5Rm5v+w40g
         +QmisANvrFXeQMG06u/Ezp/k+p1PGZP0Jel3SicwQvx7h3BU1iibVbxA3qkJB0oE5ax6
         oQxPtujzGoiUO7Wh4W+PnoK1245iQeYrnw9Z5yAb9ss/5A4pFwMTtLssKkaorbqvMq7k
         suGqHVOW6eDsWkwCksSKveMOM5LRRRIyr42VSPflGIiTZTBUdr9LEiTUNf4QanZ6Bx8X
         CU3w==
X-Forwarded-Encrypted: i=1; AKwUvBxCoh8zX52uBG6ZudX6ENNapYCtc1U7DlcI0S52HdkrpLKQr0ABd68teVzI2nQDM/UqfKnBY/c3/yknX6V4iA==@vger.kernel.org
X-Gm-Message-State: AFuF++kvvyOZgk0OAugFzZ5i3cYhmwY7zw/Y3lyU/osaX7UXcZaoeF34
	MlsEnFaocTRSJuK2751C+EBf/r+AhTE1k6lqrFWrkGccaIcQ5ZgCIeI+cZ9SVyXBLYc3gLn6F8a
	O7jndWR0yGfBer7QnX6+u+giM1CWo/bbfNENopxhbbDacMADBw6aC7zaH9RmC6e4DAVEOc9KCmP
	O2/g==
X-Gm-Gg: AYBFou1eQ+gVlEE3KtymaAI/LFPQv1TOgpYKyzPBx2WK0MoWUQz5OtWmrVGuS2sXLqu
	If0mfDCdCJdtI5kKsRnHzmJSfWPl4FWuBK/Olh1OIkwkhJ0Tez7qUZdHYIzwzwVe13Geqdrlizn
	MQV50YK7O5f1GeuAh6ecwMrHHTJmwmdGHEHP5/9+P2991TZr2jyOOoR4yDD2+ICiSdLECOk3kkl
	f/nWfs5/munaRSDGVgNInKlaHqbjtEugwVJIBLgouiarvC8OMQLRRkztpcLS46MsqG6FJWUWj1Q
	n8HDD3Kuxy/be2BEfa2AyTaVJ53ZrgXfD2b8UvvtRNzOURICMgyCEip5SThg+eah0j3730Bp1Er
	E0kT4GcfG8VDg0XjRpEmroeupe+h6SauflNi0AiPGURa8d9Ioa81bSWg=
X-Received: by 2002:a17:90b:4c4e:b0:38e:a52e:a3c9 with SMTP id 98e67ed59e1d1-39b07fe9dd8mr8558861a91.8.1788462175055;
        Thu, 03 Sep 2026 12:02:55 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4e:b0:38e:a52e:a3c9 with SMTP id 98e67ed59e1d1-39b07fe9dd8mr8558773a91.8.1788462174324;
        Thu, 03 Sep 2026 12:02:54 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm1230164c88.11.2026.09.03.12.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:02:53 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
References: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
Subject: Re: [PATCH ath-current v2 0/3] wifi: ath11k: fix QRTR readiness
 related WLAN initialization failures
Message-Id: <178846217281.824911.2908930479578290631.b4-ty@oss.qualcomm.com>
Date: Thu, 03 Sep 2026 12:02:52 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: IfrCiCrJv5xd2584ngus4rrCZegkCAbh
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfXw/QaYOFVKZTw
 HWw7lzIQGDKGFSD1h2PJYaqbiomDYu91toVeXDKtzMCgugcTUWrWKHqpAPoz9xjUpc7rLVN30tc
 YUxZM7zBLedh8bzRTaNfiVB0ubS+dhc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX+1OIo20oD0fs
 sVq7dnw/iXytujM00/Xz2zTurxrbKBQkp2cV5MZ5AYhpBlKdobWkWrmGIa/yM3i0+eRWyafrio4
 8IwuGmXw5e36S5vBik8xxIYWTc780XLRNFRRy3FI4s52HukJqSrdb/k3/pYPccbhvgKHbm5JQHR
 W/dzFK2h02Z4GZ0YGqSA+LDZlg6lZXypdPhsueThz5+1b50V+SHWEfRvpCb5TeNgHL4JP95omYB
 RAWAVLEjv84UJyvktE5KU16NwGIO1JV792VVucpjYnJ203Jw3knqmrwBy3nACMGeTiUqkcd84No
 cvt7yC3TOh1nXTSyqMr2TW6pzGQTqekIil1TXfp94OCyDmLxTh3AUtB6O0NwiRBd3Uq3hT5ujR6
 6yl5jF2IhNitiZgq/rqjb2YUVF04FLdzeZ8WyuECMcTGJMGZrH3yU5NARMsu5c0rQZP1TYybpIk
 lH1bLrUCRN3qDV9a3cg==
X-Authority-Analysis: v=2.4 cv=NNTlPU6g c=1 sm=1 tr=0 ts=6a99c45f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=w-KnMKhEo8LdWayTJ-wA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: IfrCiCrJv5xd2584ngus4rrCZegkCAbh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030166


On Thu, 06 Aug 2026 18:13:28 +0800, Miaoqing Pan wrote:
> On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
> during boot. If QMI messages never arrive, WLAN initialization can stall,
> leaving firmware running but no wireless interface created.
> 
> It also hardens the cleanup path to avoid crashes when deinitializing
> partially initialized devices after QMI setup failures.
> 
> [...]

Applied, thanks!

[1/3] wifi: ath11k: fix sporadic WLAN initialization failures
      commit: 32ec8488d75d122768b1977501bcb5ec799230c4
[2/3] wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
      commit: 1a7bcf5324c8e2de6512eca5b028b6b283181d3f
[3/3] wifi: ath11k: unregister PM notifier on QMI init failure path
      commit: 1d8e73163ef933624341075f576e2f36ef9133f7

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

