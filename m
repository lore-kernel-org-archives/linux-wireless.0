Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC821C84A2
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599741; cv=none; b=LadB7BKRK0Icps3/LnFcXC64BGwJaOODbKJG7hsUdnRfrOY2ls5KvzDoA5iK7IU907XGgwNgitMXlDu2Xtfz4HhNXoeiVU79WyySZIXoB34cWzAA8khrA2iy0bPaKERlc0Wg8mfDUPZRzZee2G+FEm/j8he1HaobE6r6b/E+y3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599741; c=relaxed/simple;
	bh=x7ymH09tVHNuzuO0GRvdbRPjA6l3ibwjvZ5ww1cW7SM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qMaTZ6r+ipzbuAs3furdT5Z03g7LhSjt1eV9FzEtCq/FKNMIENFQ3n5MFi8KrbSNDaqoh8Ydzddja/IAST12Dp9wgMvURnQ+fqGkDefCxUTPiUsS1uVN6yS3lOsBALOw/g+AY400ampAgHybR4rz/y/SmMqtHQHER97u/hF11qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iPdcZfEM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PcBoSPUc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iPdcZfEM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PcBoSPUc"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671FaaCL3490853
	for <linux-wireless@vger.kernel.org>; Sat, 1 Aug 2026 15:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DSgnhMPB9z7atmQR81PmgyeUy3N5ZUkW2ThnjxuGh3U=; b=iPdcZfEMqKFpP/Cq
	sa5OyHAZysOCyu/xLpmdEsFq3tze5zoBIDuh8aR8sqK/2ZOfJPhjjzD/L7Mse8dG
	/+RJ7b6j9psDMdxj1lBCWubzEefMB3DswSwpxmC+URU55HrmBnZ8GsE1EYmVThHX
	YMPlZ1vn/lfItQBgQBe5kXhDIzFbttYgcnuq3jzG1iHYFfoNP5lTqDSj0EMKU6zs
	q89CiHkQwsGDNXu2NKyDSITfgbDHt9hvbP6k/w1eYzi3loC8b7fhy7khJmBKcyPX
	OGBjpbml0/1oeWZO/QpavqHJBoGRiTlrJd8wh9nVOUJ5clBC1Q9zXQ6IROu+Eoy9
	tpbh2g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs91196b8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 15:55:39 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cacf17c7e0so23619985ad.0
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 08:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785599735; x=1786204535; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DSgnhMPB9z7atmQR81PmgyeUy3N5ZUkW2ThnjxuGh3U=;
        b=PcBoSPUclvDr9ZiQIIrEO4jyc8rh1TedTas6r5ttRNDJWdJKA0VwsmV/ZnWqrJNjIj
         /SJyn8Xd3F62SyxNZWaBiR2d+gP6ifjc7JGb/hf3ztDZnYomrzFilrufwepHaFj/In0s
         1hErvtaFK2S8t9NUPJzq+dl84gkrN1KIBJruaBdDbruUZIGMCm/lzdhl7l1sOzBRqQYY
         baaFjtPU3BZlb+MjNYkYcN25ho3EybhCX+1QPlMbOqdOFlKPOileGV+1NhGufXWdZPd8
         NzsKpuOOYz7adr2pe7wJIco8XHYfbtGR1UB40Kl7FuDF20t8zLB7pEd0a6Br0RH3guLe
         5CLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599735; x=1786204535;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DSgnhMPB9z7atmQR81PmgyeUy3N5ZUkW2ThnjxuGh3U=;
        b=o3VSfjsLUytBEU9I7noOLgLMjw/RPRBc2uC0fGWiWUS5P+ffXHf2Q24fd0YdHBWt2f
         9D3zDXKUYQds20dbLSjEQrofddx40FGRDO3PR6kFqqE/FworLMs9igXq8SN7VYWsDH8a
         fGOJiWerBUFUtSSev+TFebszwSSPuSjJg5Ra/MWaXF5La7IAl2ZD7NQ1sRgeb3aNDaKy
         3plopQhA916p+s8egS/iqewwHyKXifMvw495VSCpjFhhoMkQj4Yv3yUmLTUzFj+joPFh
         7oYH25HVVvEfiTmrVOEdDXK9gHqrBSbLQR8ebILtuMKDub3wn1GSF0bChLgjcQrrnyHG
         XsyA==
X-Gm-Message-State: AOJu0Yxd9r519YR6jJoKiGLsiLsB4eQfJoXJEqGFFU7mJE+7VrR7D9uE
	aCiVvpidGzWrsZ0yJd4eY8nHMb7SylYuAw7JhsMHO8Lz4w4Wy+zzzBHHm/O+IIIqTruhmEqv1Z8
	8jb4xfc1whmotBcAj+9QGFtgo4uluhKkYs+LRUF73Vb0rDp7uTTClllKWohkDHrQzckaYYb/c7g
	krww==
X-Gm-Gg: AR+sD120jlWNx5aMm2eq3cq2BI/P/m6Rw6JTIc1/tCOl3ggpR5+eTfOahKvZCK4ZMIt
	Ki6mS7ohXQLAsj7Ro0zicLg6bzG5BR1Zg51CvA1mXM8NABBIUr1kXfXVEKe41dzMxA8IzR8aK0i
	zPBV3Tzl8ukcK1vBoz07rf10ovzJApQS8AJ7Too7DnQYzAg4c8NgolhuX6S43BxMrTodn+FS4fP
	B7TOs6oQSyW0SE8GdudOiL3UhnJe00C+u1h8Yw4VfyrsaUYG13E7UUrX4QW1d9RTyREvwmDbWSo
	UMqNjDdziTBEHruIZE/RQHuvB1zFNgf935DKK5avmp3HawKGj5JzGiDpleqsnz9fRRvwHG7Vtzk
	0m3fW8u/xQgPohw8io31SuZthjjHKnzNz9pudUNtC+8jIsFBKAGZg4nA=
X-Received: by 2002:a17:902:e84d:b0:2c9:c083:cd50 with SMTP id d9443c01a7336-2d0521e42c0mr39008275ad.17.1785599734899;
        Sat, 01 Aug 2026 08:55:34 -0700 (PDT)
X-Received: by 2002:a17:902:e84d:b0:2c9:c083:cd50 with SMTP id d9443c01a7336-2d0521e42c0mr39008135ad.17.1785599734403;
        Sat, 01 Aug 2026 08:55:34 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e5b0sm17110636eec.1.2026.08.01.08.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:55:33 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
References: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: fix encrypted EAPOL TX in encap
 offload mode
Message-Id: <178559973349.3865089.16412891730483272241.b4-ty@oss.qualcomm.com>
Date: Sat, 01 Aug 2026 08:55:33 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDEyOCBTYWx0ZWRfXx9T70FNsNyG9
 Nt2kUJ5FE0qTDqT8ZBPxzSwWFpFxhJ520l1H1G51sGyxX9oBJGSf/BwXkSwLLZlik7z68/Nf3Fo
 VM1eXxu2oYb+9pU+F3OlLzrb4oP9ChM=
X-Authority-Analysis: v=2.4 cv=PvGjqQM3 c=1 sm=1 tr=0 ts=6a6e16fb cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=fnlUnMmD9_IGKKdQE-8A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: uezEUqjHa2W4lV7GXCqUZ9uVXYfkMHOw
X-Proofpoint-ORIG-GUID: uezEUqjHa2W4lV7GXCqUZ9uVXYfkMHOw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDEyOCBTYWx0ZWRfX+vE4Xz8RqUcK
 EwfZ6d8sMgFVZNLptDsx7pruxGjoSe8Qu99oV+02RYKlXWlJQAbXEGOelAiHoLLWiVzb+BTcvnm
 wcFtl1dDb3hSgK4y9tt3sg7Mu1d8ODT93aliJWVIsdFhNPHbbfvlgr69tvA0gIkabZrQoouKE1X
 gc5nLhUQpVAyPFvIdYFrLksyDgu+HDzpmMirrzmFaSUzSZ6SCotU7r16n0SldHpGchpna6pPafc
 jZpUmiTrOWyUmNcKmswuIMWMA2fPvsoThg8T/SMm6J8QDlYaeYSa+sGGZ7v0586Uk5OR8l7gPI4
 QSoOjlb/D+Uq/2rvlHbb8chkB4T/Nv71EUB+gvvdmpm0CsiDGYPxtNHqUY9FbYphDn+fVTPBLid
 ljv7xDKw0TvnAY3lwx3/ZaXUbyiSrbuZqCvynods5LAlbSmJYvJb6Swg+eGHkwzpxH7EQx5h4lZ
 ubHyzZiuUZHO/4zCMVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608010128


On Wed, 29 Jul 2026 22:47:32 +0530, Reshma Immaculate Rajkumar wrote:
> When a vif operates with IEEE80211_OFFLOAD_ENCAP_ENABLED,
> mac80211 delivers EAPOL frames to ath12k in native-WiFi format.
> 
> Unencrypted EAPOL frames used during the initial 4-way
> handshake are already handled through the existing
> is_diff_encap path. However, EAPOL frames transmitted during
> GTK rekeying carry ATH12K_SKB_CIPHER_SET and continue through
> the normal native-WiFi transmit path.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix encrypted EAPOL TX in encap offload mode
      commit: 1e33f8acd837420160ea088160d8648a3db54c3b

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

