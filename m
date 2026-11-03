Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793683073;
	b=iHyXQTcISM489rtTH2VeY+wsGMM2bkmGBq8f//yybXLxiuPkhjgOOyz7JMFhu4Fa1ih8
	 7hw2/EBffNR74EQBFW82unEYbfHkbI8L0yuiBM23AtWdOJGq/sX+vbLYtjvVVuEGY1NI2
	 zRtF9Ia1alKsz7Xp6cEurWLMTqrwzcxH7x/cQgE0PRp1xwsqaY/hLsPEvI7i9YIMthQ2P
	 PPP7gQ9XxmGzsQkiLsmbNL/v9EehwTYji7JAyhVlrMcsvCf0orOpyXKwXUsatbaEaondL
	 F2hzZUHH1DVnKK8x8DlTXpyXvsOntu4QHFQUDDj979UezHWzOox0XWutgRNMT6C3qtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793683073;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=t3XRZvz+GQC0yOihm0T5lJcwUKciyujg/5Kq0kHZDdE=;
	b=pTqO5NElOOx1GX/8+uttwSPDG7Mpu2gv5ZPa1W59VCJYFXzfb5vmhA5wLiaYy9myX1By
	 xbxE4DyRiFNQt015xvYio3TPZK/Dx9UB0ob+6/sv6i2nCm+OQeV/rCCKxkA8X6RjaxLDX
	 /lFwKHGTI6Th0HJH3pRiah5EETjYrgyQD4U4T/MMxWbAiSp9oFsrjDK2MjtdLqH9Q6w6p
	 xhRP0AKeG3duhgQczwc7bx5e8JNvo3BS2BVaXmIRj8ahIsg3XX3ZMpr2J3CeMWamrHoQP
	 RBH4aAk2YvujXuEBC7acaZdUZVmamvCQ7U9cJB0aoASCqtNAeuIfGG/GF3MOu6pZXug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Sv2pKMXE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R3HA23iK;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020EE606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 05:17:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 020EE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Sv2pKMXE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R3HA23iK
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A32oWjG2608872
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 05:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t3XRZvz+GQC0yOihm0T5lJcwUKciyujg/5Kq0kHZDdE=; b=Sv2pKMXEUi0yq3hU
	/ur0DJLeq+su8neJpf/cY66WHmwOiUqqyvxAl8EgNWavlsgJejFotK9wfa15vI5B
	vGNhLqvodqQy59sU6FLsGK6a3qaqaybTG7e8riPZR7yAg9wXwIwrAF11v2hib7jg
	TgfvQqA6It0Su7sfFiVRI2tO5zuAZwPt45X7Jvx4VYi/N7MDVpQPNyBgouTBVmKk
	g6HQktUtNR0Tq4OxUAOuWytna65pv6GuKm5zDSjanPH8Vb3pqJxGNh2f29PwHSEU
	IMF8s8j8sV0f3V9jkW8EL5GejVCIJbMLfPILLl3wZJfeE7wAyj71KMppNTWV8mAy
	Sub/TQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq76d8f4h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:17:52 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e832c03576so56178385ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 21:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793683071; x=1794287871; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t3XRZvz+GQC0yOihm0T5lJcwUKciyujg/5Kq0kHZDdE=;
        b=R3HA23iKjDoP/nQnGFeMn1GDOGFmg6yALW/vpNQYAoN2weRK58IJBeuJlw875Fuf1w
         l1NqP+8t++AprpO1gOtr9nYCZlWS6tofOpQPnviYlvwleuVxTLIcSshmH+xzmUETJqHa
         2oEIIIEBjsymfUAzIxEWwhTZQKSBAK29EfKbVgPPRyGM8BHNBrYk41r8qyD1IscC38JA
         1fEvz+1zIouC+PPdOKKwrFaWjZJ2lkbF5a82vd69MED7GT6lrInpPiTAImyberC+wn+l
         tK1aQsFEupBrfUaEDabruCpaQbYPYfqXVPgphzJQZRCYayxEiYZUPuFBvbIYXh0UVo2e
         EUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793683071; x=1794287871;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t3XRZvz+GQC0yOihm0T5lJcwUKciyujg/5Kq0kHZDdE=;
        b=Zcke2YIfqdLkInTUO3yTKg76XGf2BbUM8IBT+JXDjz/2yeXApoG3CtP9nUwvFLQekO
         OIysRx6uxtBHPepdE5P+iGY/2RZqtNSbEdk80BTkaq/Ez2an8UdlRNAlvKmCbEC2ueMA
         sb1yuJBeN+n/AVy95LWvC0b27ObzG2SiodRgJ4UOBnJ3MNMPjr+u8ghHFWVE1biHplm3
         +5ArAsDvRuhpO/zh4a9L0G7L/86EKPyAiEpAt3pKhJ3KjbP+D1Lo65lpGed7xLOaXFaj
         Mm+yjOjb7sH5Fw0QGkzs8hzxmeMPESAiOP+5cet9OrFBR5ffWegxKbrHlbmv6Rz3Yylj
         VtcA==
X-Forwarded-Encrypted: i=1; AKwUvByd/EnsWrMfW/kNmzUZSvaSC2IcM6FAt4Gz/KSEDaeY6aDaXC/xxJHqi9tuRqNsUPQJjwwqzFDS0Aslkm9a4g==@vger.kernel.org
X-Gm-Message-State: APuU4Z80jQT5/KjfylQkxkxslyaaosFBxE0gBbU0ATLS+GQXrdan+wjf
	UP5g1U+DzgvLJyppGuk1ZLsjDW/qZvxguzz9qvFOsp83m0SWDaLQBDtcsN3wF7DJwO9IYVpI6DV
	ya83gsjT8hCkXxoT9zG0D5I1ImNIxSw1uBwzb1b6L3z5k2woW1Ha1NOnl3O2jJ7NEuj/fDw==
X-Gm-Gg: AYBFou3w/sBdGqR7K1w0Yk9TfBvKkTALmmvwuueWDvJzHV2hqaEkRqnuM7lebhlRZir
	BNL4F2Usix9l5utqkujYzQqzYI0Y5fVIW0A6tnFPec2wWKT6IFpG170fOse7Stk0em+ZbZ0UEsw
	mvVqJBlJD/x1ulpV12e7aV72v79Xf82wlSDB0U6y5pMrHQ6V1g+er6PV9DNv0UBnDzPrIfNXY1c
	D5iF0VRnGuMrEv+W5P09Se9l49MC0LyEayySIHN9cfbJ894mgdOwfBQ1MxMp2OjHXmgIlXX+nS9
	mslzaVS1X8D7cU+hyzrNAouGT1siXcaWxshL2dKR9ZKpAfkQByiPBYhq9tce2FhUKY5phvsFO4C
	YodYXb/DvmvhfiFvXUvJ27uqx+6fPEgQd28kbpdrzVTNTk3/Asq9sJxMPn8HhQ9/BPcqt6+/HxT
	OjMHUZtHgaMk5AyEaygZtxE3caPjEes4qj0gbPdHpCu14=
X-Received: by 2002:a17:902:ec90:b0:2e8:1910:e398 with SMTP id d9443c01a7336-2eb3649bf6amr123263975ad.9.1793683071538;
        Mon, 02 Nov 2026 21:17:51 -0800 (PST)
X-Received: by 2002:a17:902:ec90:b0:2e8:1910:e398 with SMTP id d9443c01a7336-2eb3649bf6amr123263855ad.9.1793683071109;
        Mon, 02 Nov 2026 21:17:51 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb392aa7absm34704185ad.65.2026.11.02.21.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 21:17:50 -0800 (PST)
Message-ID: <a3df1c77-4b9a-42f8-811a-c2f662835199@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 13:17:48 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4 00/11] wifi: ath12k: resolve RX link id via
 logical link id on WCN7850/QCC2072
To: Burke Cates <burke.cates@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
 <20261103040533.3388284-1-burke.cates@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261103040533.3388284-1-burke.cates@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KJTPn1Fo c=1 sm=1 tr=0 ts=6ae96e80 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=pGLkceISAAAA:8 a=llqbz5aeeJgODjPUjo8A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDAyMCBTYWx0ZWRfXweCQkImPzuV3
 mj2QL+qIZSbyzzlCv8nvs5HPkl0uCQrODkiq9Z9bcsGxdJ0W5ojfaxSVf3P7ENd4Cj0V7zD0XUC
 I8odMvLNcJ2f1v+9Fck9T7TBetmm11Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDAyMCBTYWx0ZWRfX9CL4doShFH1k
 Oe7RzvrrgxUC/fl+DepELyN9cQ/YQ7Ev90hAzz6lgCeqd7j6lCk7famEs/eJBgtUDhKLu0XPhA3
 vkrvpACSfZhQDe+Pydnmbj0HjBvwGleVUBdOE/8PlwPoB74l2CESHEjWs7OK+cFMtTVXfXl6/Nm
 GGUieGiMnfqR3TBnqOT2yEHoM/S+On7CxeDD+/bcUjsuKrE1usdsLUB14R7sOW4vwkYpwB1+0fE
 TuszkIw4+3o1XAz1Nr/jCRd5vt62o2hU48lCBf5K7Ey1HtNWTk7AZ0tFd73B52OpXpr91TATviO
 2Y385doWOe+yY5QzlVCul5wNVgEXL3ghA1bRGIzdWkALqzP8s8WRIHDzRbBM63+AjKJO/8Zn0t6
 JklcU5YeESV2GcuFlzEiTVLanK2YdRlUIMhzpkh1kFZHxLYCJ5pHfpEX8rYG2UjfB93UR/eonKg
 zF5921gT2+CYaTJku4w==
X-Proofpoint-GUID: kxEHG_SUZXZp5YJtW4UjRniGBoJ1MOs7
X-Proofpoint-ORIG-GUID: kxEHG_SUZXZp5YJtW4UjRniGBoJ1MOs7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_01,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030020



On 11/3/2026 12:05 PM, Burke Cates wrote:
> On Mon, Nov 02, 2026 at 02:38:09PM +0800, Baochen Qiang wrote:
>> ath12k currently relies on hardware link id to resolve the link peer. This
>> works for QCN9274, IPQ5332 and IPQ5424 but breaks WCN7850/QCC2072 which use
>> logical link id instead.
> 
> Tested on an ASUS Zenbook A16 (UX3607OA, Snapdragon X2 Elite) with
> the on-board QCC2072, on v7.4-rc1 plus c752394249f8, 02121aa4a012 and
> 1e678e37ff13 from ath.git and out-of-tree Glymur platform/board
> patches, without Miaoqing's "fix MLO 4-way handshake timeout on
> QCC2072". All 11 applied as posted.
> 
> A Wi-Fi 7 MLO SSID (SAE, PMF required, 2.4+5+6 GHz) that used to fail
> with reason 15 connects as MLO with three links: 12 of 12
> connect/disconnect cycles and 5 of 5 rejoins after s2idle resume,
> ping OK each time. Non-MLO 5 GHz is unaffected. The firmware sends
> PEER_EXTENDED, so the host allocation in 8/11 was not exercised.

Yeah, QCC2072 firmware has that support. Only some old WCN7850 firmware don't have.

> 
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Tested-by: Burke Cates <burke.cates@gmail.com> # ASUS Zenbook A16 (UX3607OA)

Thanks for the testing.
