Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517893D6CCE
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462179; cv=none; b=UxavKbY1ded04R6n6l1WPsF769ttKjxcAgPvXpq3vkTvAqV/q7Q/m9+i/Gqpe+SFXYh4fcjakxrkdT8SnqURhuXZOOlyk2l6CQ+E5NB3yiZdwUzze0cyRJsBwU/d/mWX5kFqw01xviBGa8rlPwRJihRzgWzwH6XnHSmTdt0Tar4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462179; c=relaxed/simple;
	bh=gsd4KWtCsBvu5WSWvwFSKMFeW2aHCI2LbDE3Kp+Sbkw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RF8zbATdiUKjlQKSjFQUlm0sUfxAYsfzY+eQ+Srzvas5r3TUWxskfCHTPdb1sU2UcWTxXaU+DVn9L+xzjahKFdWnarRD1bz+GeZq1eC9LTnCUiMFDid4LGg/V+S9h5cBieccTytspGL0Q6KlVAOjrsfxIlJh4Ub/T5X62uRvlhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NmSHvHWY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iVlDitc4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NmSHvHWY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iVlDitc4"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G3cc4820113
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 19:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1eeL7lzBwTDAvHtt/OIh+AAbkDGWXDc+4IzQjWdsxnw=; b=NmSHvHWYB+vCIRfW
	Zh65/AzBrKTVGmUnXZ0E7b4vX0XXmNjcU7yHgvLRsItKGN7J4EycM1Qi18XhTmwX
	8n4bUhNML1Npv4Pu4ngNLHatq5rZquFG82M19rKf13LOOGyjYNK/opFfLeSnPvxj
	p4VfdYpug6yD0TLqZazxqWT+K+JoEmolnvmHaINFfcilvJHp5Pn3DA2mAu0jg4Hi
	X9zm7qBK9HVLFvOJUQ/zYvpFmEYVlpkCE2MZKLXe5GbcPC5tYfTgaA/EnTACCHr8
	KU6+XEgWW0fvE/5XGPSL030wC4fbbbVokPmDIPU9YQoSwLDOPSmePryUQmxEZQc7
	6Gb6fQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gf82ka4b5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:02:41 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398e1fafe17so183758a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 12:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788462160; x=1789066960; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1eeL7lzBwTDAvHtt/OIh+AAbkDGWXDc+4IzQjWdsxnw=;
        b=iVlDitc47AjWjbSLUx/zSLnsPU71wquWuBuNSh4E97aFPPkRiw6SSnRk2YJ7LTbDJy
         RpYSPl9Y0BYF0jUgN+XQ73YxD1K7mFZ6/c317weM9YQwYGcMHAUR/NkzxFOM9mE87R89
         Nc2RtqEWwC1sZWxii6uT1d6Ysm828iwjDuDz7eZxoTXwk+n8vW6nmeY9aJfd4axcOe/c
         ir/EybkZ4yuI5QWpiYJAKSf8dvuO6ysdhCi01UIVeruUIjdrtLli+pgvfq14+SZJUdu6
         WBxsLm/yFD6xwQK3cwCeFPOPIRMaXu8ucFLyYN1OeBW5eobyCsUqSAonO5516o47BCJL
         lOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462160; x=1789066960;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1eeL7lzBwTDAvHtt/OIh+AAbkDGWXDc+4IzQjWdsxnw=;
        b=lc657lMGGxmBYhANCNIk1xMf4+oYieLEBNOtCdoD8UYOX6cbVydy3QD4ubRvTE8pAc
         SnjfCcWyMI1iYkT9BJp+TL1rs7jdFP4EeQgFJUhIyhMMSAe/q3FPf8lymZJOuCC6T6iC
         Qa2bwPs5gv0nik0/xb2a7MHegnBK7jwK37WaLH8d5F4/v7pAlax9FTWR8uU9liX3esat
         z9Ya23Dq3VjU/KK00dVJG5ghfENmP7a66mhkwtBLrAiSaUWAuruEgEGZ0/xvEhOxRGz7
         knzRZrHz7Kq92suZvsw0Ek+R76ED3wx/KBxsJfw2k+DE+BacRw4P/MdvR4SHGWhKr9TE
         gT5Q==
X-Forwarded-Encrypted: i=1; AKwUvBz2j/iE0CTE1w7bA33MKgMkg/npATMAZTcwKLmAf6XU9NJYJY/KQ3LttJOAOW3Q9kxuhHs5A8AcynvtL/yAPw==@vger.kernel.org
X-Gm-Message-State: AFuF++lcv7Pvmj9QfSlnbGHUNRv+tqXchsvuO7c7+svh8V4tantpMEI/
	lM3PNOoR9d4Q9Bv1dDctGAXqfgXzU44HqyeM6BLe8bww7cWeWJ2O41VFWY/na4/o32wI2X0FOw2
	xAZPUniVx+IajHFp+YNiuO5qTUaKkT51jg36Ev/LBOURxjewkejA0p/f1BiyOkUS/l3H3ag==
X-Gm-Gg: AYBFou35d1rs3S2Swl9wIyJHYmbCopXLJ81ijUDICbjceH/JCNMbYAYidG314oeTNIm
	GYIdBjLBqV9vE9C3gjqhzlhsY1x/nyQlDhqwj+nS/jndQYNUU41xmGY8grEknuqU8+uFGiHp806
	cbRQ0xgp/7ti7Ky4STJL6zLxcM1gYXg1XVP/hp29qfI39J/Hj+oNDkhB6tkJdVWzKzTMsY4qmYI
	+HuV+rPUNeSxNrOkHiRCAy6Dyqwp8ABOltNXjFyEa0E5Tcciiaph+sWTABxqJtb4J2LUogID0Xv
	hsm6NXeZ+vlH4EIodumJ9d2rq/vKZOeCOTOIeXzfGU6fM74BbXcL7Oy16gWp12UeDy3kR9fwWzQ
	BxDXBs0bmVz5JeXaBrYPQ3AKAifStyVVYbciB6FVzpCWilmZfTLHL23E=
X-Received: by 2002:a17:90b:54c3:b0:398:d6e8:f84e with SMTP id 98e67ed59e1d1-39b2612ecebmr977383a91.9.1788462160074;
        Thu, 03 Sep 2026 12:02:40 -0700 (PDT)
X-Received: by 2002:a17:90b:54c3:b0:398:d6e8:f84e with SMTP id 98e67ed59e1d1-39b2612ecebmr977271a91.9.1788462159534;
        Thu, 03 Sep 2026 12:02:39 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm1230164c88.11.2026.09.03.12.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:02:37 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
        justinstitt@google.com, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, baochen.qiang@oss.qualcomm.com,
        stable@vger.kernel.org
In-Reply-To: <20260801114911.91483-1-nihaal@cse.iitm.ac.in>
References: <20260801114911.91483-1-nihaal@cse.iitm.ac.in>
Subject: Re: [PATCH v2] wifi: ath11k: Fix possible memory leak in
 ath11k_dp_srng_setup()
Message-Id: <178846215711.824911.14716922396673159484.b4-ty@oss.qualcomm.com>
Date: Thu, 03 Sep 2026 12:02:37 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: Pss92Sj0VyOMMUzj8mS3dtvxGQrGIDT4
X-Proofpoint-ORIG-GUID: Pss92Sj0VyOMMUzj8mS3dtvxGQrGIDT4
X-Authority-Analysis: v=2.4 cv=OuJ/DS/t c=1 sm=1 tr=0 ts=6a99c451 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=znwm85vKAZ7j0MCq4kIA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX3djvo1VHUWD1
 aPYiNS62U+qhT9EwDwDhX4tspjhD/9jR2ojOz0gXMXqi/tNTbOsBM+jPgWNQiZy1gm/5gpIrDcE
 VJwOlZAFov12/msBcB+0ko7fqwrk5BFk3DoWTb/YmIyUSZVZKS6XuvhlFhfw+ww6v16jzShUz8V
 E2EmKrkNtHoJXM95FtBiEhg/1CsHgDnx9PpaJk3alT0IeZHCxMGCewXPs2WgMv0L/06sbimq6uv
 tD61zUqrJ3ifLpAEKTWN2vau7SiCJUoXqEnQycSGda2UlGC+o+GGM1trLRUcnp0ZXMUt+UP0zNL
 0xGQJnRmP7g6kb9m07H9Jt1dpGfdrKleHibE2KLwdbYtQ7yU7khVt+VOnUgJDiXia6dfecawYbh
 ImHXm8eJlI6V+GRYQnkSiBVTdyCikfNhz4PMOXX2rzI5r7LLtPe4jxRPZW57i6IRUDoKR3AqjUo
 xA7L4K2cxWx8E0LdPFQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX8mTQHx6ohqnF
 MVElW1o43PAvg0mo/taBSp9wEjrnYsLhc0aRXBY8tS8G7GG09oRFnsBp1o12sVe50LevbGBfwtX
 +f87dOhzy/aeMmplFxt9aRKgrbLeSHA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030166


On Sat, 01 Aug 2026 17:19:09 +0530, Abdun Nihaal wrote:
> In ath11k_dp_srng_setup(), the memory allocated for
> ring->vaddr_unaligned is not freed in the error paths that follow.
> Fix that by calling ath11k_dp_srng_cleanup() in those error paths.
> 
> Compile tested only. Issue found using a prototype static analysis tool
> built on the LLVM compiler infrastructure.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
      commit: 6132d70d0890c03546f6970893fd71938efb2a2f

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

