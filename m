Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0A48F000
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814534; cv=none; b=TdkWDdeyqGCBOJWjrtOqOE/RnPzToZMCZTjU0E01SNgHGxGQnLXKtfTeSJK9+v2PxiGy6XgQjFcz1alVaDJ2NlQrQldHyDN3jyI3pZ/NAIYt7oHTjuBGqW6q0VZoO3hEGkstfBdYaKbcFl9sMmBSvj9NzM58A+zaza4AXwLlm2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814534; c=relaxed/simple;
	bh=1kaXsKB1fh5+qDLa1LDlgXg2iHpGQnV77ZWJonixFSw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VIPitpMRMkjrMjEZR1On2g1aVxpttQgZgeELYHFdQl+vrIhCAEmypPXkRDWrs6+7uqRIAn0LXU2aG2jnJZ2PyrqSMfhhqWr6DP1c1p72YD9VS43i2Gdp0i5LSyQq9GW6gyAZLbeDfdUgyNgWxBAeca9TYSjXba3rhmEhp3rO5iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZDjckY2L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O4sNn2lS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZDjckY2L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O4sNn2lS"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CC07M32786899
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aFX29kFGAtu2xPnsttu6rTskuC0EwNUJ8aX+55jfLAA=; b=ZDjckY2L8vr+JJ35
	7MvKR6g4V1kRet4H0ExeEU3lMbaADfgQkJn4efZjxU5P1d34Xf2f5HP966oBLJJq
	TOnlRpDYB1xHSd3vYQ4XFQHQjQLqp3tlId/yt3fxc+fDEX0uekxnBwrJJ4HRmxIe
	wnmlIuZjXjG9q/wLzrDlAbvDPzyvBEqRP+YjyoNx8RDvbLWyajPVZmIF6vTyhAXb
	m+GNOtA/8BGzzsF58e2Nzd7XrV+YjApKVOaKNh/0oKzWdBub+5fEoXHk1IirNRQB
	8YAo9eSceaofn3iuGUUgq0Dlb4XqghzFDsFaFn7n9tjO6Ndgwum4SyVdr+I6Va8C
	7A7+qA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8wffh2f1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:15:31 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso4917034eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791814531; x=1792419331; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aFX29kFGAtu2xPnsttu6rTskuC0EwNUJ8aX+55jfLAA=;
        b=O4sNn2lSxUQBsX6St/4FsvjoZJxQmpluLCEab5FOARoxzWGeLjqgyxBo1shGwWYaa1
         4Ow7zYvcxD9y2NU7CLVJiLOpmC+xZfu3AWz2FIVtjcI2zydF9NmhXKJkzlVbMAsC+A5M
         /gbigNkOwFmVkhMauGcIwi/ottZyWIT+6IYcu9XVGhw3CQCxMyzzAm3Qd9OpabyihHhh
         EJKqi73Id1RtrkOir/HvhYuzmvSaCQRKpsAYCUo2NE8IdlM4BNOywc0jT5Cuyr5cLTcv
         MdrtEFS9Oi6f/ZbRwMH2HRIH0Dd+OLOxEIqDPuGkZ8sk5uUStvxq/NNgHBimHgRiu7G1
         X1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814531; x=1792419331;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aFX29kFGAtu2xPnsttu6rTskuC0EwNUJ8aX+55jfLAA=;
        b=MXj6RZGidveBc8nPuNwkteFI7mFafYVWQQ/gt5ukCPmoW6mNVAzYGSA2DsPaS4bQzm
         GIFeQNSPEu6KDMZBQz2cJ+UBwUudfVxr9C9QhVx8hQAbvVgwZBzx2J2Yt0HYDt4s1ay0
         HFQlYKBc6gCp1sOrB2DTRkaxe4XNQlSfhh/VkvNMrW/F6XcUNoSX9CWkBKYgemzaBayZ
         VfShkdGdDowxSibBMnlERBj0PevG8L1sXTNHylBqFynepI7FRRfxSLm+7orrwa1h6YAr
         MycPGclomad16P/6irj0yIbVq9DxcJGHHY4GSuFe7EdmSOxYlF/7v6LNDGnCgGGztmTJ
         l4ZQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2VGXN9f8jhNm+5HSsypcH0lWje9laV8UcDZoMq491LjH44BkYKQXDwwZTJjOjxeP114+AWapccr91N7r8wQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKWlptp9Zd5UZQ+DSZQXLXduus5dI0KwrFoGWvgrZizJ1Byk02R
	BKHQOpf7x+3hdjZ9nqLwbJRPkt+kC95AApLjr8uSBtcKGOZtsgFabW7S/hfkvPGH5ngOcf6hXui
	i/k5FAO00FF7u5SZwwJHUDAwyQVwRPdZMr4ERx9//Z+YveYTqwhcPPwMwj1fGjDpW4M5Ujg==
X-Gm-Gg: AYBFou3w0hjJtj63mNP2s/752Jf/tEA8WP7ZjeCLVHMfDI/9ujYDqCKliZ+/iWfos2y
	LuVIcYgv2YYzxqYmqhosAdIJnfCeEev1bYxWAY7P70slSdFZUkxAw+Fiw0tnXUl6lnia12JUaW6
	tN23vzw0MJsNp454aYunigMCOplfiQalLI9P5v+oA1t7vYMO241IXnQsDhQswHCCVMbxxxYEtR+
	69jQKBInCfCgznYxaHaqjK8iKpv+iifPJjViOFbLojrgnoyNQV0jwi2L9B4hn5wuWeTIAnvDUuV
	OCQgdr+gWX9sitSGMQqr4tI4hFcyQsKw+To2CQULxlYm0XnXP5rs2zFnBMQvhuVrGKgwFJOAxpC
	xKUWRuj+xRD+easXrrtnuZa800+WgZsISUr3NKMB9RsX7b+r534Fd8KMJzupSD8Ql
X-Received: by 2002:a05:693c:4196:20b0:35b:af:a075 with SMTP id 5a478bee46e88-35b00afb749mr3312630eec.22.1791814530307;
        Mon, 12 Oct 2026 07:15:30 -0700 (PDT)
X-Received: by 2002:a05:693c:4196:20b0:35b:af:a075 with SMTP id 5a478bee46e88-35b00afb749mr3312594eec.22.1791814529564;
        Mon, 12 Oct 2026 07:15:29 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (las-colo1-bdr-fw-bdr.qualcomm.com. [129.46.96.4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-358de54fe47sm21302992eec.31.2026.10.12.07.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:15:29 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        =?utf-8?q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        =?utf-8?q?J=C3=A9r=C3=B4me_de_Bretagne?= <jerome.debretagne@gmail.com>,
        Dale Whinham <daleyo@gmail.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20261006062728.45007-1-franzelfranzel@gmail.com>
References: <20261006062728.45007-1-franzelfranzel@gmail.com>
Subject: Re: [PATCH v2] wifi: ath12k: skip hardware rfkill setup on
 Microsoft Surface devices
Message-Id: <179181452875.1215069.2287645106143483581.b4-ty@b4>
Date: Mon, 12 Oct 2026 07:15:28 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA1NiBTYWx0ZWRfXwcoueatVi6D0
 RKkZLhp2cW1LvmhuYINPIYM4oRKz+R2xZqvZzgYv3fwn88CLe4v7emAFPfI3IMTGr2Ga8O3R9xd
 muQJI9CdnkENE2tbYjOszrU1urhBSCeiSYTlo4Y68QKI1Ayxx2vuzcdPS6yLLeXAMCKJr3q0JTj
 yvNAVXM+0Vubf/+z1F8hsAQx4IrsYH4c583y3upt5UPVhGRkYsXjYhDxGkel+oYxUs8EfOKok31
 j/CdXx+L+Ih7iJ8lE8IVeF6yCtZ0nDSS+x/TltlTNbhMU3RZn73cjJiEf69Jab/RBlZTdzKW80n
 5okDEJ2H4F4BXQSv6hGoK4C++xCTF7MeHaMRYj3a8ewk4TbE7D4fIp96pgsaqWS6V87rvwQ/oYB
 PhESISnrJdTxfEflFi1Z7zvExgZKS8CHxk21l4o/Uywl0cg/IekYECxaaDDsssP4T6bG/warAdM
 VvjO4epYH2inEcrBdpw==
X-Proofpoint-GUID: eqRIH8GP41urrXkB5zHSkEQJJRT42_OZ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA1NiBTYWx0ZWRfX5OP41ZmhPG27
 Ma8P852GfDx5l38HR18530PWibSuFgUuf1jIUN5K+QqYFSC4eORzjSLn0grIvARC/qjETzp2+pL
 5ePpO94ysvNa2yzs+hBZklkL4CZyKPM=
X-Authority-Analysis: v=2.4 cv=ZcWIpcVA c=1 sm=1 tr=0 ts=6acceb83 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=zwy/ZOtzXhWWzLhDjT6TXA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=5GOfUL4nasl92P49FscA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: eqRIH8GP41urrXkB5zHSkEQJJRT42_OZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_04,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120056


On Tue, 06 Oct 2026 08:27:28 +0200, François Roux wrote:
> On the Microsoft Surface Pro 11 and Surface Laptop 7 (X1E80100), the
> WCN7850 hardware rfkill input reads as "radio off" and the OS has no
> way to control it. ath12k enables hardware rfkill handling, so Wi-Fi
> stays hard-blocked:
> 
>   iwd: Error bringing interface 4 up: Operation not possible due to RF-kill
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: skip hardware rfkill setup on Microsoft Surface devices
      commit: 5949d1910f13c20f6ebcd26eec9e0c02cb4951aa

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

