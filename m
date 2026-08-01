Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F152C35E1CE
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599743; cv=none; b=e/Aaha0lCt06qxNMfDvGp7rXyLazuCxPIT6c7aJXyjF3d74RFDy/jI5Fwxu32RlBWPIeBYWUw4Gowp7Xq/uufMeVMC7h7F85cqDY655JByxqZPp2XzzQymTCSOwFVcG7LY/t5rL68OrUludevWl9AF1cyXHqOPwhkgriVoo94Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599743; c=relaxed/simple;
	bh=GHW1SWGXfxNV2GljA9870cYjzsJnvb0/h/U8sZUMS+g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QMFwXgjNmg8B1ycouUC1b+Je1qkXo1+57G9kxY7YvqG9p62oWusgzPBi4KwrlQjJ1nO2L95rXvV8XSdvtyjYgSAU1Hlhr+O+OKICORsUji0c8q1/JYRnLP63HnUbfGR4mvJn2K2ugTutGY6q2pUhC2ScfBffPxBi/ZhKYN1vIZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BhZBOEZX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Rkff+pJ0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BhZBOEZX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Rkff+pJ0"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671FafHd3612485
	for <linux-wireless@vger.kernel.org>; Sat, 1 Aug 2026 15:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rPSSCCoRmWeCr6uxglKQN7w7FivASbpOfeHhqqwjudc=; b=BhZBOEZXa2iNYMTL
	loDAIq0rUNwvWC9KBaANuPCKKMJjwof0XKEBKDgzB7vYIqh5XXw4tjXV0ukuKPcG
	/cZ9g8gaAsIrKpjHlAINL7rWvwDFAxS8Wy4Nnp1lAYpnBDpkm8EHj+fX5ChH75I6
	dGpqOKNyfHQiHjrmIiCSCS/Ia3t3N++I11s4McTwXYsUPkh8vkC7qLcw582EwbOs
	jtfR1wzTiCpKQNWjXgv/l7bdsTXI4pAFqhs0tAKyLPSNVsLafu0FiS5+RpvZNEY1
	bsTU2ham7igqOniqpjBOlDNAxNblLf1TPw9zzSOdbb9Oaiv41etoP/3JYr4NPWiB
	iORV3A==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8q518fe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 15:55:40 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso2469572a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 08:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785599736; x=1786204536; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rPSSCCoRmWeCr6uxglKQN7w7FivASbpOfeHhqqwjudc=;
        b=Rkff+pJ0bSkAdaG/FcKENvwfJ5Qme3PwcemYPqQsb8h0muBxPgx2Sarhc8UukemdEk
         fT24gCi29iKStgFTmKenMxytSd8R//oNmlWC1K1gaOr7yPhbQR6bIeR4SnEvteHzsLal
         d6R8m3j3qqZhhC9y1390DTZ1J9FKgSFIr+MRlrq4DzPBeNCIi7HvOJ7LwUlCTaHTpvOS
         XDHg00HNC+rNxhZFLa3ocHZME4Uv3TnTo7I4eJEtdCPnXM+PZEfPWXAvAkQE1sFs6N88
         r6f8NzLWIB4yRniU8OTrHPrPVhf/cDpmxIW/a3zQL0QFMNDzhm4JUL65J9rJ2J4uYVNT
         uukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599736; x=1786204536;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPSSCCoRmWeCr6uxglKQN7w7FivASbpOfeHhqqwjudc=;
        b=YonRK2hWvFlFqc7h3Df+8D6joKyFtTEmMt0N3f/XCmb5c/AxQ4+5GXe7jdE0isf4YM
         uS/F1mRcTmHV7pT3SLCa7T9iihobgZiDesuklENwKmOD0xLvNQPKuQSdX6+rH4N/Dbb5
         MaNhbYtMi2KTDZ6FetSREpRLcmKgnl3IVcnRQH/IP8cdM5cyNmQ76XEoSWDrIsCurZwD
         bOymoYrilZQKth9domfFVgnamjsBORagAFrFePZMLcEWx0+Z9YSfjLgCV2QtkiPg5SXW
         Uh5Cs9jxS0+dwOAtXQCRBwG54IFZnyIq0+Aph21fVKour6OHrRA5Xx1OP9K7i6OhyRkv
         rocw==
X-Gm-Message-State: AOJu0YyuUXc6Oi2POu3Daht4dg3UWcH8s/tAkxePjB8EgxLc7I56mg0y
	JfgpnUtK9UTiQ+8BAlL4lR7vpS1JfjzpQTyPPj2lh9vGYuPb73aXx8JMfvPA+Ri2hDnVgbd0ofH
	HDARdLhqOwVTyAq2IvT1sbkwLKx6gzbmyZZ1+Ayh3uNhep0jPyYU15KiCXZWxhg/QDdJWXjtiag
	5g+w==
X-Gm-Gg: AR+sD12ei4bneqILTAL7nxfY85xgd9EZmUr/qMLifI9hRgq3dHuJ9tO8SZXYkYQwF4t
	pyvJW26uO75wFEMvOHfZRBnknmg1wV2oy7GOdX42BrJKsvBjGn1i6rDOKY7oSddb3gLU19F/Vpx
	G+LTDiCjwKtSb3cMUQDCGYH6GH9Z2wuRsUL6NgcQSasH7KJu1C2sOMKvkAVGKM+fe9FppHJXaCQ
	kpA7Sv7DnKsoQyS2AQdPu12j5NOkyAO64C6Egb1aOg/iw8+6yeCTgvGWqtP044jnX+Sf4MDt/Bp
	0k/O+aPaQdYyLXnmmiee4RrsDWANjyxiQujGUhavc7x7zg7m4SRvQK7eMrqx9wTyXsRELHevJ4B
	PXlDlH5Ba6ZSpDQg1fPLFumTrmnFIOcoLQvvsHbtnxjDmb4mOXHmq0JA=
X-Received: by 2002:a17:90b:1c86:b0:38e:9e9d:9209 with SMTP id 98e67ed59e1d1-38fbc4431cfmr3533279a91.17.1785599736295;
        Sat, 01 Aug 2026 08:55:36 -0700 (PDT)
X-Received: by 2002:a17:90b:1c86:b0:38e:9e9d:9209 with SMTP id 98e67ed59e1d1-38fbc4431cfmr3533259a91.17.1785599735824;
        Sat, 01 Aug 2026 08:55:35 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e5b0sm17110636eec.1.2026.08.01.08.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:55:34 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath10k@lists.infradead.org, Linghui Wu <linghui.wu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
References: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath10k: filter non-UTF testmode events
Message-Id: <178559973458.3865089.3131178536876006419.b4-ty@oss.qualcomm.com>
Date: Sat, 01 Aug 2026 08:55:34 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDEyOCBTYWx0ZWRfX0/xMkuKmlR6/
 gxOSuIzYzNOlk9OBTCQwj6Zzw7VpxaQWVPh0oZ0zdjAdtF2r3UDakXxVW9z5SJxF4fNbeIh5PV3
 oXgCFztvcqZg7yJiBSDFfydrlEbwvGw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDEyOCBTYWx0ZWRfXzPBaO+n9oAkm
 hTcbwFALFOR6bza3YNK9cHkZtWSBvS2EzajbaIk5KnQ27NGUn+uDbX1zW0tIP4Gfl5x+a71L+IS
 jv2moVoKzjlpPh5QHaaMiGYZisG8UN8BW6NRj6A6ppyOamb8jHiftofGUkKxN2NL4j7LLYO6n6s
 Wyhu9BdbunkZWRHUqNY1YHxNLmOFK6iiT4A2rj1QXr4k7wMOeVnPb7h4wCapGpEPhjbR6EcEwHH
 fRfmBez/YILX+kufBx36ZHI4jbF4MYt6AaxiccASuodx07tgPnZS0fsbiMj8Lgk1oZnlXJcMsDL
 VwxLSh7CpBw4AnZ93eVfQkShpbazL0UYQXQhvMMxTb+XRhp3Mhn4m1t7mWHVigOqf6QoEBIBip7
 rIB/gsMAaBCJBqqcIET7FIWriXOQLAGYtLtymZFFyhk8LqiIIMcsb+u6COpYp3DSBp1eCdOl72A
 lUNN9ytgzTKy9QwKP6g==
X-Proofpoint-GUID: rMKHWV8qzX5pYI2485j2G2VShjCDg84R
X-Authority-Analysis: v=2.4 cv=IYC3n2qa c=1 sm=1 tr=0 ts=6a6e16fc cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=J8ee_osQro5uhysJbSQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: rMKHWV8qzX5pYI2485j2G2VShjCDg84R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608010128


On Thu, 30 Jul 2026 08:02:26 +0530, Linghui Wu wrote:
> When UTF monitor is enabled, ath10k forwards WMI events to nl80211
> testmode. Non-UTF events can therefore be delivered to userspace and
> confuse FTM tools which expect only UTF responses.
> 
> Only forward known UTF event IDs from WMI event namespaces that route
> events through ath10k_tm_event_wmi(), and drop other WMI events while UTF
> monitor is active. READY events are still handled by the normal WMI
> receive path.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath10k: filter non-UTF testmode events
      commit: 35a3da9fe1b212a9012952a04f383b8dc3708dd7

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

