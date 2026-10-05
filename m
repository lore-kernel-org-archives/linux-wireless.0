Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8B4C6500
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212999; cv=none; b=AulUyHs3Rg5V/TN/XeciRLbvtfUC30nhoW75ikGzNAqBaHktFxVLj1AWtwfr2HpuJ4z+fWYMlLyK75Svi+FlXZy+5SioCGgZWzRgVKS64eLQ4fHVSnK6D1AkfwHfyoyw2r95L7nvfjHojtRmg68Wwa8LAr9u9WmH7bnyshAuPd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212999; c=relaxed/simple;
	bh=A4qzcg0t/3QLE2XJQsCOb4cgngfSC3a5v4LZKvG6UV0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tEhS7XJD50u/IHptzNSfcxbR2bhXI5/cPK5aA5MKz9KqyzW0O/+bxF0NB9xIngRqt1mlBVeGokISN+OyrQmu3qM014PKtC+id6om1JJfrvz4UPdbIpaZdFAHZxURkEtqjqlMV3kWL3P8R+TWhEyBOQAendlpEIvsyQgUfCiCHSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Xx8mMNlF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BKtUm6T8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Xx8mMNlF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BKtUm6T8"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP0Wv2178390
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 15:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XTlne3T2FPsgfeIHj85O7fAaGN3E084SkCGxWBQPoZA=; b=Xx8mMNlFVdiwxobV
	owrLU8ThXEU+b/hPZs80NjCDdwU5VmZTxr8a6M2Byt6Tf4MU+Gjrnm6iry/tujSl
	L6sfgXIKP+nkoaeGIAHtnVh3EDlpzYKd8M/INYNkbbDHUOnKGGWSad2YratsMCxD
	eudkrpmOvlsupf44q62T/Lh1gDO36ByiZhdsaZz1UwfgXB6qQ0zLNPluwXp796gV
	SVo5/Nurg/VJ/ULgtw9FI7KgcUgjsHRvFQD67VWtfweWrLudPT7elYXkHuV8RuBS
	iRNOK5Xfc3aFxm+1b3+c2cUxGBIO98zWaFY4f/cBet+NoidI9wsdaGqWqBX4vWxK
	xtQQ9Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4cj60gqd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 15:09:54 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e2d3a3ff86so27154485ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791212993; x=1791817793; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XTlne3T2FPsgfeIHj85O7fAaGN3E084SkCGxWBQPoZA=;
        b=BKtUm6T8jNIROe0ClNyJUXsxMYM27pOz3a5csdBDgCl20HPt+WwxcG4Wq46GAtyQC1
         raZy8nu5mMkQECWxJRAvn4nN6o9KNJ3KMAMA+U35R/MWeDRqp/SD0paFqV2klOgpXtV2
         mKtoIrQgNQXQCJFN6B8wInmdHS5sVEgiCVDc8YBYJEYPlumiL4GmLyGCkpR3wtZTLI4q
         9JDsBt61W/X14UakD1oT0ehEzt3i4Fu1rS1wzvXduk1TrvJkzcgM0z26u8wny4jYRi38
         UuIZ2ZFi6N+31Hp6/VKs+D81GpTKcbvPLbTSK12NONq7aoG3+tr93802t1wxUAd8Qkzz
         CLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212993; x=1791817793;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTlne3T2FPsgfeIHj85O7fAaGN3E084SkCGxWBQPoZA=;
        b=hNu0V1r3guBKuRwFkZn7fhlhf4TEIctBAGZuNRna3FQFrmvH4Pz43JgmSLH4x5jFvk
         e3lha/IW66Ospt+pqbFB+XzOjlmJKaNBaBvwtyJrFsEdorXtVM3WQTVsXMkxOGiH4rSh
         H03INcdK4Nz/ujMN23bZc20kbdTwTBtgPAiKko+ZUvkYFegmLAjcpmmzeNAKWKji5IMh
         fdMr8ctLhdJil/6wdqZMI9jN1PSZhDj/TRF+cNkVnJLA4Ng1tfxgoypULTR7YZKjlPAR
         4JS1pl3hJ8ZGZG+VOwt+cpjrh2zcq6UXWi3GSTRJ+h6OVYLba/TZpG9jxayN9CkPyg+U
         AhHg==
X-Forwarded-Encrypted: i=1; AKwUvBxdObDI3eDTj5NtU41xOkSvu9iP8g5b+z2Nbft6xm0Iuq2TJWy/78ixT4gB6ssU7BrIPA6+VW+FgpF38njZlg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKfwThYYXn5kM77laqbmYiJ86s5NuQAD73Sip5xPRsYFZTOj/Jz
	Vne58RHkRVa+7ts7QJdi+Si/U/FqcS1G2jLttlvBj7nEyUMcJ/sKv/LaJcT25nX58RVjR1SdixX
	8dHgbLpBDUDLK4x+BzjgnUkVI8vibcTchgds1n+t1psfKvOen1FKyplgLzfLQTU9UcwI2fQ==
X-Gm-Gg: AYBFou3Ix2iX9c+NPkzEabjHW4E0r/6+xdsVEVAv6vFurtbuZb1i9J6YCWqMYbDqOpc
	taRCk/myfbSGEk2W7gOnZlczffuu/nWDFKET7u4+Shqn/b7x//H+sot4ATPCITr9aHy2s2ciQBV
	eKOoKsGGVWjmcyK3HGaE8s5+1cf6oUfYAjFwtrmjyqaSEf+7t8O1zORsxQdKDke0BALdM/KoJf1
	fti13jr8wQbPHU44vLdzTOHu2MDkNGPOCqoFHMSclaHtlRsOhXFbPAJQl1MK+NsKtGBHndL6H9c
	YdmWN3xh/CL/B/T4oE2VKZ53HSBqM0RemuxwRTIceP8TsCJOlo2qJbGfU8BtPNBSWBRQW3dGfHl
	TPiVu8ZnYFMQjxiuZk5r1MhAkXlnUe+uD8nW+9MTP3vU2qjhkh1Yo8b8=
X-Received: by 2002:a17:902:9341:b0:2df:ab09:2656 with SMTP id d9443c01a7336-2e49b6ad7famr76692715ad.44.1791212993064;
        Mon, 05 Oct 2026 08:09:53 -0700 (PDT)
X-Received: by 2002:a17:902:9341:b0:2df:ab09:2656 with SMTP id d9443c01a7336-2e49b6ad7famr76692465ad.44.1791212992580;
        Mon, 05 Oct 2026 08:09:52 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5cae1bfsm9130075ad.28.2026.10.05.08.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:09:51 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        =?utf-8?q?Nerijus_Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20260908180308.788642-1-nerijus.bendziunas@gmail.com>
References: <20260908180308.788642-1-nerijus.bendziunas@gmail.com>
Subject: Re: [PATCH] wifi: ath9k: refuse spectral scan control while the
 hardware is disabled
Message-Id: <179121299145.2358654.5147778588803855831.b4-ty@oss.qualcomm.com>
Date: Mon, 05 Oct 2026 08:09:51 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX9ONpW6Adq4DL
 1sPtlI06q86y36On+H6LV7cDL7ThQ7mn2BMjbQ9SS3CQRfqYCou3qYMus2LQEeLuTIRVt5uAXoK
 axiuJIfgu+zPmaI7L+4nVK4wtVYsmliHvHiSsM+lz490v6ghWMWvI0d/SPJsxeX9LNu+LyDCKFt
 rp9bcIr+FZhalCTsXzLFZZ7DbnKBAQ5ZZftO/1cnLNoOG+bvsPY4wtEnNToL6boMxJjXnFSlxio
 w3pjbxhz5Q/NbsHddMkyLcKLacOAGSOfaAUv5YD2bcSuN4pWLRsAK4NC7GC9NNN/kBM1zKE5Mro
 JeSkABIWze3B5pJ8V36fW8xWZxPdkhG7Tml83JHWk8b+680K5ZOF4ki92wVBc+Z4IsONbuzguqH
 XKx/g+V1hgZEIgAB+t2gcmSxE4WPiVNrY1/FQINt9owgqvBnFkoHsQDEXr6qljuWu82n0QD+U7Z
 BzgMpYvfM37bQ5jAVGA==
X-Proofpoint-GUID: aIpLhXWG4fL-0Ao8WndU4aKWudLuJeJP
X-Proofpoint-ORIG-GUID: aIpLhXWG4fL-0Ao8WndU4aKWudLuJeJP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX21GZLCRDtzrb
 1IrQQrL9xkCfHdJCsQe1hJA3Y3iTY9gNs9HglCrjHP8s81KlztCHLCHAz5GPiCwA9SpabcjUIut
 vOFpzqiH5fGgk9MOFEEkHeu0VrRhObM=
X-Authority-Analysis: v=2.4 cv=bpTZl0ai c=1 sm=1 tr=0 ts=6ac3bdc2 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Kmx-Ht0RI6vGM5YZ5n4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050059


On Tue, 08 Sep 2026 21:03:08 +0300, Nerijus Bendžiūnas wrote:
> The spectral_scan_ctl debugfs file drives PHY register writes, and
> nothing checks whether the hardware is up. While the interface is down
> the chip is asleep, and on the AR9271 those writes go over WMI to a
> sleeping target and hang the firmware until the device is re-enumerated.
> 
> Refuse the write with -EBUSY while ATH_OP_INVALID is set. The reset
> control already refuses on the same flag.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath9k: refuse spectral scan control while the hardware is disabled
      commit: 59411703660919197234fa0ec80ee1a5bcbe4276

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

