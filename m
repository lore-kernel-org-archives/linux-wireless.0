Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35463C09E8
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785167246; cv=none; b=oYGJ0fBIyvSIKPA876EpEexKhm5tQC8Bn/7hXp9p6JSJMg028F0Xqa5PP44CaaAqpyS1oURmj49KXBHNMePc5hKJG/Wnyy9tuxTsELffrR0THbCpK+l0z9lCWVWpc152AXKgiUeCLMBNwRPJv1yalOUPiCHC97X89o/FNjAJhxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785167246; c=relaxed/simple;
	bh=t55UHkGONOFnSehAuIawlCkYek1fcr6fR8fbLk2bM8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HsNcF4IYW/hbKAyOfTeysT/0iH9/VVNCP7rg4N9o1rn0vICjhWD1ifGe/pSssaPYo3rBgfYqmHSggwH519aPTm1etKMNrN2BC2td9OP/fC+EchYOz3ptLeNpteQvaRgtmfvbqpbKE68yL7G99CtHsbvrIk0Jyaf8XVoIjyLJU6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oQ7Z3mpI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YL20BbHj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oQ7Z3mpI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YL20BbHj"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RDlhsk4061124
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t55UHkGONOFnSehAuIawlCkYek1fcr6fR8fbLk2bM8Y=; b=oQ7Z3mpIr0YkTn6k
	yKI7HSvDosJeTafL3XazcyU2uIq8Hj5lqZsDopzpPhSQPOwc2vozLGir0pYao6dh
	URTK55UXP5moxzvEqJIaGmXASEk0CT/NQ4sDC3JiRobeMKSdJu+GFHtP56Hr/r+L
	yyETqSk3q4R8KVBWNOcF6UGN7+IXLfJJHV2NKVjYVmI9U+TjehesEyjliwgAFi3I
	Kn6Dml76Ikeag+RTGN/n0xun79i69TBTv6wxbveiLiWRShfbDhP45E0oiABZFTIs
	KkVP/SqC7lxL8yXkPOKoH3wPoYiqK+AtCYGrSlym5Czx5VW9tSA5eqGMecg60kYl
	LVI1gA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4mq1hf5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:47:20 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cceabd70f5so79610625ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785167239; x=1785772039; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t55UHkGONOFnSehAuIawlCkYek1fcr6fR8fbLk2bM8Y=;
        b=YL20BbHjEqYkUimDxT6ncpflq+iwMkIb/E2sPLGc2bHAZbjTN7FghvO+h2LUy3wxno
         Rb3Cd5dhtDmx/M4Fb1tesqJJ5DxvQkeJJYdJaVlPxEWe8fSxNwDGxIOAoNZhPTbZQhXx
         SndFfu0osUfwIdlSfEUTqiw8uOBNGfs25nvQixEQtQav4LYR2AmEua4FxWyZzY2/fsz3
         d5NdiBe6FDrJppMi6MlB5BA89LcB9Evi3AHcpOYzYwMMe4Ji883L+e9FhbsHsNLPjdyG
         9D4zPBubpGGqIh7VAEP8xy1NQrTdA5fqSpJD8FrK7UnqLiyGZeiwyBc7n9HT5gB/QKad
         mFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785167239; x=1785772039;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t55UHkGONOFnSehAuIawlCkYek1fcr6fR8fbLk2bM8Y=;
        b=smvHsWtRtptbLQIqnieDPmZQKbXjt3SN/p181zNnP2kYanWUrsiFi/sONKYpKpb/Bk
         /u+6NOVyYEckarsZOCJGsRjGKkjMqb7pvna8J7G/23loL/B2wpOsZGgA0B0jLE06PKKc
         9r267XJ7tShM2LstG1SO17JU3zccPOTbLO1sj6jKJxb4JwEB1L87tK8OifFFb1WPaklz
         CnGXTCNiLb53ZkdSm9fiCyPAnMaxL7BHCtMGiJaEZBK7G8ptv/Qn8agJeiv8u/RPY49z
         fqY1p8t8JAzJmhgU7ZkAOIqh4B2VY4gcDJ1el+rowuIgpsI3W5Sl6eKOkhw75iCpH5kO
         vMmg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3w/QKVwwXrzbYbBUgOdLBo6WrX+xjUZ9rdYA4p/K4idjtCwIPhRDIfKyfYA4rLGUx7ZLjZB7BH97fvX2/0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGxv8fHUE2aW9RoI2qnVThKVFMuNTlzN2/711yyuIqr38b5uXi
	e0fDbHUtZk5RiJz4kXPRoMIMPzWJ739yq1VCcJJLCk4B2wUp4EvLxhuSvBbMaWFsQIErohdovoR
	ZVLbkhqmbPq8KGvKmVJPTiuOSqC+v/V/5KkeRMkCenwofKYJ/YkkIhroNUrgEqKNuHjTiqA==
X-Gm-Gg: AR+sD10Iyx8ebFZFApZ7yf4gGIMWjhNVQGIg5cnhk+ByJv+SZYWm0Bc6pOFm1jUEVS4
	VIu4194ClYY2zmaKtPtEuShAJt9scORIhgfaockzK3KMQq69wrXqvwSQyyHu73jJv458+3ANzmp
	NFrVbMPzzioIZFvbnNWpcCuQe15tzhtN5z8SNh6E9l6d6KYO2Tcwx/srvztJEvaeHZDZbeUXVXJ
	dQObdff6mYXHsHZSwJQ8q+8cXgIjF6CAP7mhbuZyKE65EHMYECXdjRa6Ad7VQlxGpeaE+QyBljP
	JLpn1DTltYur002GcWaeOU8vxoV/SxcieKW2uEe0jwowPXGOogK+ocaMHKnxhF7qTm9TwLtbWCi
	f8T4y/XcZGF7BVQgoy203K6UCDSFoE1tpGuUzkfu7hFkg4R/oOYtQ8rp5SdTu
X-Received: by 2002:a05:6a20:5484:b0:3c6:55f5:2bc9 with SMTP id adf61e73a8af0-3c67df10d35mr9526504637.49.1785167239085;
        Mon, 27 Jul 2026 08:47:19 -0700 (PDT)
X-Received: by 2002:a05:6a20:5484:b0:3c6:55f5:2bc9 with SMTP id adf61e73a8af0-3c67df10d35mr9526477637.49.1785167238645;
        Mon, 27 Jul 2026 08:47:18 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e6461ef84sm16043901c88.14.2026.07.27.08.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 08:47:18 -0700 (PDT)
Message-ID: <81a72170-870a-47be-930d-0772b7934ab2@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 08:47:17 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>, baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com>
 <20260727065500.3827035-1-zhaojinming@uniontech.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727065500.3827035-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0OCBTYWx0ZWRfX6QT2C/YJ16UC
 0JnKLYCdgNUG7esBgeczah/11gHH1WvEuI3MIQEWGvvY5w4Y9BE0OlVgRhl6hHB7qJWxGCk7C3E
 21n92loxRyKxG5WKcao9M2ypoK4/Blc=
X-Proofpoint-ORIG-GUID: t2fkgXwbQrR3zz9Wc-5Zk-L4k-xaKOs9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0OCBTYWx0ZWRfX6XdefOdW71pn
 8gYVhmq71XAi07gUDfmfZvxmp3hPsw93qQii7ojvz1Y48R6V9gTndVycL9E9P8gUlR07yxKIRzs
 fvsLVUMKfCsXYPy9zys4LfwyFrVaPgMicfWnlXW5UsXlPTOB/VHwR2sSjTM16LniLeioEAASozo
 dw/0g/LxqM67za32vk1AS21W8GEXvzS4HMKd1fwIhLooziJWCYldkGM76bZqcHNyJuaojABj85h
 CAJi/30eIDkFV2PqFGy5SzByhUvcLHhQGSbryaq4QJI6s39O83KjKR2/LOrQmCDWDuFedVVqQZI
 Q9YuU98ZpJ5pipE35G13fuZn2wTuBJQiSo/ITBHwAGlVNRmfY+JKhkC/R4YTspmd6U6kixsK3It
 QYN8J+y3tiSS49L0X1UM4IWgDAc3eKZK+hKAdAxBIlZzfoOf/Jwm6Naw5Ochq0HVahpn7mD7FWK
 VM/5m3bsJP9CLtNb+Sw==
X-Proofpoint-GUID: t2fkgXwbQrR3zz9Wc-5Zk-L4k-xaKOs9
X-Authority-Analysis: v=2.4 cv=TemmcxQh c=1 sm=1 tr=0 ts=6a677d88 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=RgswOa_aB-mjHIJR3Y8A:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270148

After v4 I reminded you:
>In the future please post new versions of patches as a separate thread.

Yet once again you sent a new patch as a threaded reply instead of as a new
thread.

:(

You are ruining your reputation.

/jeff
