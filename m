Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D662C42DA34
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300777; cv=none; b=FYV4tOiHH5a3X5Ramg4NtB6PeePwrpMzxAUcuLayhogilq+SeCIZqtt3t9pvPUuBIzTxgqojf2c5E0vyLI44ZEhgIi/jss9eLfZGstCAAGGR9almOCgyfbErBQXvawBN0UIpTUIfZwbs6WZT75jjfrzJZlBwiHUeqCzeRRS7bq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300777; c=relaxed/simple;
	bh=NmcscSRue0b5O8lR1c7zZcATR3+EA+T20ZmQwoJhn+4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dWPbaQ5ph3qY4hmzyGwouAfHqc1i3aJBwvLQmmFPg7leZkO4CKj+VUMH8p5iDwi+AcTTVFwxK95kKCufdAriSzSsUcdKvSNnhaW72iAkVeex3fna+68pDCXu9p+UXSIcNoQK1iRghykwRmLv1svkV/S4mE+ktb+pPnnbjLhkgL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EmB5wkCD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d8/Q1dYj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EmB5wkCD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d8/Q1dYj"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE8FXK2123179
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b4aokX7aN3jOFRUMhyTul89eGRT67qFz9rejB6U1UuA=; b=EmB5wkCDVzoXhKjt
	PRAmI3mk9LJnPvA9fu3RF6L/KBS/6hjugDPUL31+NVf20c327kW5rBMpf/u9NhTR
	4GKYubSln9yknHPfrSlLYK0yDgdG0OFkrHzF/pM6epixuhn0yHkg8rGfFCn8aa7H
	8PFZpXVabyLI1YCNCOQtCIr0xk84xho0560hc3f6p5tBYf6AYGXCjXA+TRlY/vGS
	PXbJ+D4V48oCrH6Ii0nKYkhwqGiq39X1H+yHwFXA7hMNiogje6N45gMXtfINQLXr
	/7I+hDlr0A3rDJnyWgcx2EeRNdhu4b8vK9S7sxkzJgkM020u3nySooNLWFrvxXEF
	ctKIyg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffe0ut9bw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:14 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1504302a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300774; x=1784905574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4aokX7aN3jOFRUMhyTul89eGRT67qFz9rejB6U1UuA=;
        b=d8/Q1dYjiHlJB3ZCdaZfLWilWOYErSfRtk6vV/FopJtZHSrskgZBh1h98bFIkHsVCg
         6EALjkUBd4UppRGkt+8pV6HvtIDzZo24v35oKSqVuTKILIpF5Se0Szc30r5zWa332daP
         JdS7gITgnz6u6yqcUeIxXqH+g46do+hvZOi/OzYaWJizZIKFOsSLC0MznW+OxrNUz9ho
         XCM5XNHRLGb2T6bLQUv73eBmw3upwrpYHKU3itUPbVgmvsrMbItLAwmbnLHE12ftGDQx
         BZtKuPAGLvFQ9L0Ck67LCKE1aCSJ3IECrDyC5Q3spEocGILaEqZ8C9dT1n1QZLowGgfC
         ekdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300774; x=1784905574;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b4aokX7aN3jOFRUMhyTul89eGRT67qFz9rejB6U1UuA=;
        b=tTtc7SWJiRZ6TDk9KoqoJc/4jdI5U7kLS19DgTmlXaGjixTnPVAZSuqAHbnUkk+qlH
         yGqY7osy0qoy9uA8pltKlwtaf5V91m8dEflrCqLm/adiwAQWZK24ByZrs3byStjRegZl
         GZfrbTXq+tHt1evsty4jHSNgBZmEcm+sCyKIHRfBALZikeCYH2RfF9tAnP6lV3AnjiLw
         K00V74WpXuLi7QT3Lcqmv0VWQcoZqezDeuKH4MPc/r/zps8mJss4g6pFmPkSXHy4btg6
         Kc82DTPwXpwFdc7nOYNwOI2mpPY+OQSQUWb+JddNA2fKRolzH4K4/ezCD9HONSzslQtY
         E5qw==
X-Gm-Message-State: AOJu0YzGa0jGUz+uMng90zHrWstuuBIxJ+QyW2/KG8GxdMB+V/XAAfFY
	D0N9KvrnAX37zlzyJKicgS+m8WcKB9QBSkD7LubsCGlOXpe9zKtzgm6UtFXSltwDPOA0hOth6Gd
	1YjVUI2ygV9W9uHjfpZjp6v5Dt+2h+eJZZojHGdGXdvZX0vg2NLgmX0lWtRQGomuelmGSdg==
X-Gm-Gg: AfdE7ck5b+VS4wHGhFUvxGaOk7awGIEKyS2M3sWt6nrXEjf8VsWToq1tX7oDuYMXrh/
	j1iDBJsuS4VJXwzdMVLeXqE4Qfu5OHhaaHx+pLzpW/dFJxBJAGzeg2wIKpX9iVg5twE/zltAElI
	6ctzeg6XM+FUm6sOSwoJntHcjfo2TzTLMGQc9dTM7s8HbHU4nQYjrGcLdE3Q9V4i7Uz0M+sLxuG
	MFd/pHQiBwEstuEGWAXZXHOxhBqbdFCInx8N+J3aDVjiYeyWLqI7cy68OdGnCpJK6KghHygVYsd
	+cVRPYOa/ZFNDpjtir4FMopsc2NC6eWAF8cAHIFxi5/UsZVN0jzevgijgmGBprt2juolTrUl4ta
	JQn9REeg8Qm60C8VCJfoApxD2fLL8Df9RrNHNzvIWOUPXQ6/z8aRnFfY=
X-Received: by 2002:a17:90b:2e4f:b0:38d:eaed:4adb with SMTP id 98e67ed59e1d1-38e3d2ae565mr8756278a91.20.1784300773474;
        Fri, 17 Jul 2026 08:06:13 -0700 (PDT)
X-Received: by 2002:a17:90b:2e4f:b0:38d:eaed:4adb with SMTP id 98e67ed59e1d1-38e3d2ae565mr8756209a91.20.1784300772867;
        Fri, 17 Jul 2026 08:06:12 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:11 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
        Masi Osmani <mas-i@hotmail.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
In-Reply-To: <AM7PPF5613FA0B662B9909BAEB554565F499444A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
References: <cover.1773277728.git.mas-i@hotmail.de>
 <AM7PPF5613FA0B662B9909BAEB554565F499444A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
Subject: Re: (subset) [PATCH 01/10] carl9170: mac80211: enable Short Guard
 Interval for 20 MHz
Message-Id: <178430077133.128359.16789469923498706346.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:11 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=deWwG3Xe c=1 sm=1 tr=0 ts=6a5a44e6 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=xxHlNlU5RHNHJygbFF4A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX0iwgza43DeNR
 L8r2X+/tJgbIF5B6JKkYojEZgd9OHIyMm0tk6W3TfamsHgXl+S2XmN4HAr83UvQg6DVOjoB72r6
 nnnQgnS40uj02Zx8Af69IG/MQgEl4xkUM/a4UgYP/HN1TAAfn6/aABvsyqV35jePK1+oGHSOz4P
 XgTq6JyRofbnNBo54zYB+gKD5KVD76pbWshsXzp75qG5i6lgAaUegYVwN0NVBjoKifWLxSztwCp
 JFTe0rHOhZXBdGLsUr1XZSQMrEzElevnEf5xZDbeKVooXLTGrq53IoYXS+HSILv/EgZXY7iV4+k
 NfZO+NG4nKZC3oFEqwPr2zqVTmrSToIQ4xw7oTFOpRNZhjsaENuY2b9qio8diKE1HmfADyCqUqE
 pGWvsfrxQnl2iJiAczKJiSzL9peQY8+1RKIAOUYlBcf48o4pnt7w0q4w3/xUsnaNkATdQQ4RRt1
 NSPDL37cmx1Ka33gMBg==
X-Proofpoint-ORIG-GUID: gkMjcciAttQD85O_ZPrTK8_5iRgFEm8y
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX/y2H0/0DKxFc
 xK3sDYBDKnUwC1bIVN4P7lWNmNGUDP1jooeKDqN2oCm4n2boi4J36sf8cYUqz0BKsZsD/th5BJ2
 bIbtNLV8arYHhRW+1358DNHvWmZcfPM=
X-Proofpoint-GUID: gkMjcciAttQD85O_ZPrTK8_5iRgFEm8y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Thu, 12 Mar 2026 11:37:56 +0100, Masi Osmani wrote:
> The AR9170 hardware supports Short Guard Interval (400ns) for both
> 20 MHz and 40 MHz channel widths.  SGI_40 was already advertised in
> the HT capabilities, but SGI_20 was missing.  This reduces the OFDM
> symbol duration from 800ns to 400ns on 20 MHz channels, increasing
> the maximum PHY rate from 130 Mbps to 144.4 Mbps (MCS 15, 2SS).
> 
> ath9k (the PCI sibling for the same AR9xxx chipset family) has
> always advertised both SGI_20 and SGI_40.
> 
> [...]

Applied, thanks!

[03/10] carl9170: mac80211: document spatial multiplexing power save handler
        commit: 031e27f95761fa3e14de4af53939a6694be1ab0a
[05/10] carl9170: rx: track PHY errors via debugfs
        commit: b2de486100b0cf7b770a2ab46e9a1c4b2b8f3fd8

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

