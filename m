Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986253EBF20
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300772; cv=none; b=jckq+R1iPNHZh9Lv2DKACNg7pKgFpEAwiISiEWZ1Mqfwyg7lKHHGkHXuYuaQdFgOmzvmfinHIw3/NFJVBJb48B2amCDaiCuzJh3woq8SzO1lsQjzuU6we8ktSJJYJR+Rv7f2IlaTTJLcmeT8SmMGIVx5yvPSaMwLHm1loLYcVA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300772; c=relaxed/simple;
	bh=bvynA8b028yRG+wVJbAmkB+7yRjTXpJsU7DTR5uR+CY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UH+iYiQFmygjMloC9Px5vAKrV+5RmWPNIcpNaYktMAVSm5o8FnFSlqkRtFSpLm3LDD93azGpm4Ajn+KHCDvc+jAOk7+u76TGY8brW/eA6BDRtOri+XRor/p7M+QxHqUftcUo1VnNZaEjhUEMXC7GU/Ffgk2M+3J4avLUUDXe800=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lxhJAgZV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X9bJwoiu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lxhJAgZV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X9bJwoiu"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE9RHe2125393
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sJcL3N561TAVp2yc7eeHH+8jSCw9USDs3Feimog58g0=; b=lxhJAgZVsx6vF3b9
	Cd63YcX8OJkdPXnmzo4gHD12TJKtWe2AsG0cfULa+paG0RYu4E74hpcTFUclj/8a
	IchjLwC+1LT7Z/4qLXvyLe45J6MoC6fdbb6c/4LsO8ZZnBWFG+xMg/KNbG9AqiQP
	yq2/Kl22Lr7TA4ly81k/Ga+Oc7RYQI3jBlekrjeqwO6a077EICjyN2+2t/P06fEI
	gHD2VV0t10MUTj2SVSeSmltpyZ4gi8K/eY6p3/PG5I1VcUHvRBxFeG1NhTOEXiBu
	b/3Yw9L5mwe3oyDUvMZCxcf7vFnaljbv9VC7Kde5PX5gsE64ao3yS5/nKw6YENgK
	DHRLlQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffe0ut9ay-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:09 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so11094177a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300768; x=1784905568; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sJcL3N561TAVp2yc7eeHH+8jSCw9USDs3Feimog58g0=;
        b=X9bJwoiutX47yrdKOewv45uCt0a60aOu6UAuZpjkVaS0SwMTinvzZlfAI1XVPaJdfH
         l1reCGNV+toGPn+m2cmjg7PO8l7sLyQrhymTDAsZZ+WRrCPWHFANojtIaYypap6Cyl4+
         NEzNlfFjUQBRV5KOMdod3GGgZLGwmhKboX/WhkF5djzLx1JJ2rQvlz5c5ODplfCOJ8Gb
         di2sAE1sHjNOZa38hzTwvWGa9goJ2dNglb1nO6mLNEOTB+4HK9vs+eqRaIvoEn/1P6pC
         +wUtR/U9Tx3qaITREJkSl2Crn6tzIhbrZODlUBxQJ54zeLuZcr4L5/oSj7JNoXrMNwHy
         9qMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300768; x=1784905568;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sJcL3N561TAVp2yc7eeHH+8jSCw9USDs3Feimog58g0=;
        b=jS06cdcE+8f3z6WUYaZebcan4gw9o9hg8Mo8c+bcE+uk9Wu8DDiS2b1idSO8qnD1z1
         ZYsZUJFYMS84v4OT3RfhzoaAglymWvaDszF9rUnrPq+gx4AwM8hK5JC6yV3fiUZVNLpz
         u2BZxtWHlyCNZVCRZlGW/IjFACssaGtdSbDfmkYUyYEvlvzZRGm0P2J30JU7yyAbKnF2
         2B1exw2cI7UVUpLwaUlpH6FSytw9bT+je4qUUXE7G5v/jEqhL6mQgmiM5wRl1pKv6FEF
         /5Nu47Q2RlA75JQ7VWOZoL09hrE6zQh/CQKFv3i5a83YweEFeAYHDY67P/2B4cKPU+kJ
         2/9w==
X-Gm-Message-State: AOJu0YzGoyGBFFvA9Ae8MdypVo1nA3fqnhMxXrEUR+RtDS69FihWqc9z
	OJD0RNjsPZ1Dg4FuR8pXDfZ7mtG8Pl7IvhZTFKTTqjerg0Y0MysVGxmV1NHzAmIj3X70m83owXg
	PvQQScPxsEzB+G0yyHoh9KdaTCajYfoFpoP5SyWwQHGgXfob5+602662XJPlqFLGsDxLO4j+N35
	CAtg==
X-Gm-Gg: AfdE7ckjsKH7z5ipnlu/W7kxstqSd/I62Bx/t6V9zgFIHqhtyqwEO8/C037Y1O4vvgG
	KAC/1Dn6RfdB+DLPpJPzbk6m0A4cqvx3Qc+zSYkgO3mmx+P8RKGUJjr3WjQJFbU3zQkoK3Gdvle
	/4c4vQyPpOIxi9CGbgosra9b3mNvLp+oVRF2NqnsRfT+QaunJokvK22oKSn8t5oiuaG/DUiRPNL
	nIchwKlhl3JpsssOpEipdZs4R1+f+eVunJSp8CmdX06HS4R5D0ao/obmtXW6rV8D0CHAOlCOBYs
	8BP0biAo01NLh6XYpvGJO//w15s7Xwh5mUg0Icma5P7q5ZRYANN+Fe8+Ri9pv5EPBTyg5eCUVow
	Mm4a817LtwI+9UvlLnawgr67arceMC8SaNXt10FdC53BjHucxrakVE2E=
X-Received: by 2002:a17:90b:2e0b:b0:389:8f6c:4d58 with SMTP id 98e67ed59e1d1-38e4b54c1d9mr3463126a91.34.1784300768105;
        Fri, 17 Jul 2026 08:06:08 -0700 (PDT)
X-Received: by 2002:a17:90b:2e0b:b0:389:8f6c:4d58 with SMTP id 98e67ed59e1d1-38e4b54c1d9mr3463097a91.34.1784300767715;
        Fri, 17 Jul 2026 08:06:07 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:07 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Alexander Wilhelm <alexander.wilhelm@westermo.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260703-fix-channel-list-copy-v2-1-372c39306d79@westermo.com>
References: <20260703-fix-channel-list-copy-v2-1-372c39306d79@westermo.com>
Subject: Re: [PATCH v2] wifi: ath12k: fix scan command endianness on big
 endian
Message-Id: <178430076679.128359.14484292801513582946.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:06 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=deWwG3Xe c=1 sm=1 tr=0 ts=6a5a44e1 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=eT-IiUoY1iDqEzW4f9EA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX8L1e8D6pDyaS
 mxMeQQ9rjb4lf6oqLpT/fyBKTGU7gk/D21tFc1fWW7BzmUVZfwJvMzt0y1NAVq6QWy8p6fdJOXl
 2QsgVvHzP+TcOTvDRsquVnnbSSWaFPMlZA5HDMuSiEOXPRqA64eXCy0E/XHMoYvCj5qXO10N3S/
 Sbw1EBkLVGEG8v3EoSmzqNHdog49ErfA2FM8vco1I7VauTnIr1J8R6RrPA1eiR1cPM0qKmb/+Xl
 A+pccfGyGULxyuPah4F1qOR/EHldSvNFlx1jN5LMZudv5c+pAGAwJJLfT6r0Pgh8oVXydK1NSKD
 eXW14A3y91enFmRQ+6dT06saLWtwRw3B7LOB7ar+UuFyVpjn9R1w6KlxlzklomB7bmDwl0RVAGG
 9ADzkqVC4LGqPLD29w6qzsxY2WjgJCbLGqTywHCBhZ1sDISaE+nCMNzLI0GDLoG4oD11b0y0RIg
 1mJLUE3aOXIC1Do4ojA==
X-Proofpoint-ORIG-GUID: k8ny0zUDNLe7UQFqX-1ryG-AonAUkjAF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX/VqMQVtPa09H
 po9N9BHHZ8yCQizTNRg1ppKoaLTfFZqH1b+Qn3rJ/9nDhmlJnr8sBw+KMZiXUbIngwme6+4nCDa
 MmLeolDXaZ/81Q3Ti3eMGvqBCfNd9HQ=
X-Proofpoint-GUID: k8ny0zUDNLe7UQFqX-1ryG-AonAUkjAF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Fri, 03 Jul 2026 09:35:38 +0200, Alexander Wilhelm wrote:
> ath12k_wmi_scan_req_arg stores scan parameters in CPU-native byte order,
> while ath12k_wmi_send_scan_start_cmd() writes them into a WMI command
> buffer whose contents must be in little-endian format. The existing code
> copies the channel list and writes s_ssid and hint_bssid related values to
> the command buffer without endian conversion. As a result, scan requests
> contain invalid parameters on big-endian systems and fail.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix scan command endianness on big endian
      commit: 8e3d6b596453c518a7ebdef2c785550c5e291dc0

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

