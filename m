Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E342EEC4
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508909; cv=none; b=D6QxB05jsb/WlE7l2XY3OPnsXWQyNjHLJNsRsUGeQYxEWJPCgYKWzWst33NYXGnlyMcarnx9sbrhHikRq9dFaSauYWKs3L3K5D8CKPZlwy/ThfdqLCRfmdk4UV488l/iy1i8AgRODgArROlEejZNkE5D0beYLCJHc+IRPBHh3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508909; c=relaxed/simple;
	bh=r2YlwST5dlzlKH/jKK/JY2/Q9PwWtrElJeb8ZvvQIww=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m/esv5Ugj0yFXXSHJ+MHadEKKlIJibcohRM71jjZH+HDgo/0snfC9+IGJEpHOoLFSU5tfBRPtoH7+rHVUDU8ICSzXmWos9QTIWs3tLSptD4n9xnCIM2ajwafztjt2+z5SO4XZIG7Go1O5Vr7rBJyeaZxJ3/gmix0dfyBG1Hdh3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VhfSyLua; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OeGqtvis; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VhfSyLua";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OeGqtvis"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VBemwZ892310
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rgL7He1dkS7KydTH0CYvAIoix7JpwraSDJaSNfv3xbw=; b=VhfSyLuaThrby073
	C+GuUBMLQc563ZMF5pI7MK5yfmHjOu14z0/Z2Rdz+I/6YaW0ekjONOfWirwuILTT
	DurKVZjXS5JuUmabr1/P3pSZdfehAnIDEJnI6d9lQcsSRteZwwoiuV5CO6tULd3b
	dFa3gK5BBSBWYVws6c917TD0c2U5XhE6+Ar+QMpaVgsoIpZW+5egKeTs3sCyC8Uc
	lOHd6nAjgeEJNN7G899A1wubOE6/wrom8iPx+FgufZ/na3aQgBCM87eLryM0D5ft
	s54jwCZhyi+i7pP27BGNQ1TeYWsfuF87yRnXnxgPufpD/rhUujCYCLpzu2N2yPgn
	o1wKDw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru1x8rfn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:47 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso1038644a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785508907; x=1786113707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rgL7He1dkS7KydTH0CYvAIoix7JpwraSDJaSNfv3xbw=;
        b=OeGqtvisAl11m6mV87F/2X9wZYTU+/+JJfWArMPvVNb5Zs1joBcu4EPItUQFkOtZEA
         SnfDIdlWvn/s/PwH9ITP+IbziVt9jY5RYM33ts8rlugmxxds1jEs/T1k+8Nl8bkZRWn9
         Q7OSREInlaVd9kMclTbDcPNxQUmQP5d0bDxqR9JG9GCL2rG+W0o+e2HIyNNwAdAdN8El
         0Y/i86DTpJyp3bT0j+nkRlAxSdzd1QTazN9zGSUnawJwXXVNWOKE6KZ6KXfux4b23ITv
         ZLJBM3cqEc6r1OLflwApMlmnqo0czmWb2Vy9o/GFAQEb/bhfY5hR8ezuYYmYIMYTCTat
         jxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508907; x=1786113707;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rgL7He1dkS7KydTH0CYvAIoix7JpwraSDJaSNfv3xbw=;
        b=R7r/4ghDROs0sUVdZgiqDPjMY+MSoWDpJ3QpFxuBJuJvxn6Csp8t28vnt4qQEY/n5p
         0UG/ok0M5hBdbAr9txAY4C+6/Oh6Y9DfE6RC9b+aIFTjM0weDHN9PzXqYJJGx9PktYHS
         oatGaQGD0YIRr2aXCo/94ON2AgKkjkK5VAwQ3flTOhGTzYhy4iFnIlhOmmeiQfDqrzzg
         0jioabU68qiMD9a1SkQlv84kpa4hJ50ut+3YFHjQqfaH0efrKCTWxH3sDa/1Y7hlMd6E
         Qo88nur3t4sB6szTwst0lx8dysgE2BrmmLJxGeEP/RYB6AC+o9GER1c3/QOtEwgRp8mc
         fyvw==
X-Forwarded-Encrypted: i=1; AHgh+Rpiy0fey2uBESBr78k7KRyImZLmZdvizK8w8A5y6xiR8Z6hx6bbq1C484OwVMcwQCZHomOKhdJA4n61dMjg5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHGeUFXjadUSQsZ12n93u2jwVhcUqylforcRxgD5rh/F9EzNxG
	lswWHCDNLu9vgFHqq5jjcG5JDTkoG0zScoETEtXFgKGutzKhQmPkJDGxaPrwcx3fsDyOxTr0YSP
	+3aKlLlr69MvZliu2/vlWmXWoL9bNT/m0IjfAmD5Ii23q5cWy7CxD2KwYBrBhTljd7AYuHA==
X-Gm-Gg: AR+sD10yy2/Up302yIzm/LNt83uFMQqf584nfC3XZHAtlx9JFNLn5HiVZW3KI5h/YTs
	ECtiWbGuO/tC3LygC5vMHwGhjxwD6jlSU/O4vIOTV6q2zXjAlTR1wF2Cj1QXpY4OEKfB5D9RBN5
	f0SPdoYrZVjwn8TWSQfKfXTdcXM4WvzYtsSRGYRzledSsC6NnJrSp91SEQ/7Czh4AGu/zOAKOgC
	zwL16sgUotqS7P0yOFUhGFN6+MZVCQT7yNsveGYZUUAFqM2L7+xrRNYuKZG/fPPPmegrluLP6zk
	2Zl2opvaIXakhq9VlHqftTpStmqM1p2grPkh174AAnZnmY5gUMGjFBVHdfEjWbGBKlHjZVK5DCM
	xfV/JcNhKAaz32WRjhlTioYqp7WRrZYy3d4RxD5pxHLIyDA0C2TOsqsQ=
X-Received: by 2002:a17:90b:2cc7:b0:38e:679f:3b3b with SMTP id 98e67ed59e1d1-38fbc4ddaf8mr179902a91.29.1785508906970;
        Fri, 31 Jul 2026 07:41:46 -0700 (PDT)
X-Received: by 2002:a17:90b:2cc7:b0:38e:679f:3b3b with SMTP id 98e67ed59e1d1-38fbc4ddaf8mr179859a91.29.1785508906431;
        Fri, 31 Jul 2026 07:41:46 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e04491dsm9622360eec.16.2026.07.31.07.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 07:41:45 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
References: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath11k: fix leak in
 ath11k_service_ready_ext_event()
Message-Id: <178550890564.2242004.10304721068858568392.b4-ty@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 07:41:45 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDExMiBTYWx0ZWRfX2upuMnPqv1oe
 iydztkcdLREK+OYhz3mpKM5yeHy9OQU5fPM+WDXT8lkmU76OGvSPhfN5+LUsyE8ysJAYDcKxwi3
 RtZSbUkxd+IYvQjf/EjX2bnk213FNcE=
X-Authority-Analysis: v=2.4 cv=GpByPE1C c=1 sm=1 tr=0 ts=6a6cb42b cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=o81EXbttbUaOcGQKceUA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDExMiBTYWx0ZWRfX4u45qo5f3fJT
 b+/LCIh5wy4DBfA0CM5/KXMoJye16kYs0Uh3qENeRYMcD2Zo4sipWzlDkOY1NJxQftD1Tb63jp8
 R6V+2Ok4RU5py/qPIJswOSMVkuXSBbFGdnd8H7HuPLaCS8+tdSlrS7W2LfULyjnITTX2Y9V69P9
 3sTY7Y5ItuKucYCW/9xu2yiSHdUiNMBPgR2xJPeTyPkZXrG8SliELnxaaHd/azWAEFCo2tYZbWi
 +Vz3bXhq2sGgp/cHgALIt8XI06Vbk8b+kuKmiQi+ce9UNxnDJP+NxDmS5+zwemKPFCeU1cq/3EM
 wyjNdOL5DunjL6owYhGcnnjRpJH3zvDOJ0wkGPWISeL/6hFf+Wfn4hlDDP/jJ/Ohag4XhZhWmhd
 6XoRT5nEzgm1nrIzUBrhHpHhru69DRwJXrR5F1JwKG12ZwwEDvUftJETFuUAq/lpN3UyfnoEmUj
 /Hk/J1cELFtQnnQ5qjQ==
X-Proofpoint-ORIG-GUID: x9M7ztMrWP_Rg-AQaRWRH6TuFxwdy-CS
X-Proofpoint-GUID: x9M7ztMrWP_Rg-AQaRWRH6TuFxwdy-CS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310112


On Mon, 27 Jul 2026 16:39:41 -0700, Jeff Johnson wrote:
> Currently, during ath11k_service_ready_ext_event() processing,
> svc_rdy_ext.mac_phy_caps can be allocated during TLV parsing. This is a
> temporary allocation that is freed on the success path, but not on the
> error path. If parsing succeeds far enough to allocate mac_phy_caps and
> then fails on a later TLV, the allocation leaks. So free the allocation
> on the error path.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: fix leak in ath11k_service_ready_ext_event()
      commit: 0293be2212d319d59589082461abf2a9b626cd1c

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

