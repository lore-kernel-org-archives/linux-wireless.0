Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793314570;
	b=E/Ub4xZPfqNdibLe07Vo28Gfz5tGwNKSz3CEAV/3LRIQs2Xw8xfAXen7qdGvgzCLy1Oz
	 BD0k3OC2foxhz3a2Ks1u/4oFtRXnZe1nph7QtXosL1ytm9aqqgQDWKVtn4NrSjERnGr3j
	 OrzMDH3zooxpqV/P9RzlsO4Y1TrAi81k8Y/MbpG0Xgdpbuimfhcl8Wkb1VU79knCM+zmA
	 L4Lcj5qxA8EOX28bhNfJK39mSgg5C1oQ6vKb5LD86L6/EgFYBelQYblFADKwvj2i9HZhv
	 T5Xp4d7RFi771e3v9QV0qzwG++NLk8X0AKvYtvcOaSIlRZ5hggyQVjh/uzyplErwJCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793314570;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Kovbbk6loTr0hn1v5TMoxCLs3KlWkkhMntV1tVmNBmo=;
	b=32V4m+v/X5Br7oedGO3q8pm4nM3PTqNOD8iA+98V2TFKGY6VYOOZ60kc8TWXfy1TCuQ1
	 LZgj2rNJhVjo6CKHv1PVAuhq4FAlQIPQEszSn3m2Ohj6WmFrcpxp3kq41E1FBP0Vx8yEz
	 9uCe5ms5WiwWpMsZkqxsGOqZzm+kj+pthpPwq3yQB2tTcul/XNdVcbPuEWr92V+de8Q1i
	 bDaKco96ZR9l4rlK9l8Of3HiNJfovftsqEvFTso8Am1G8fpeP0tiu3Acf5l3riEj/Tap1
	 1Bg9sxbSBhUrCDhfVNP56OaK9iIMo64tVD8N1PepRJ4YUFlDv0kdwaUdvMWrt93F2qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HnpWCIY1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bgd84zGn;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A182606A321
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A182606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HnpWCIY1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bgd84zGn
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TLaUBa291290
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Kovbbk6loTr0hn1v5TMoxCLs3KlWkkhMntV1tVmNBmo=; b=HnpWCIY1ECpy+4bI
	+DWyNZONjtaCnPuLuU0IKZG4Jb/OAyW65O53Dqbt5DVqiojEi6K+uzsvW+h3no2M
	4mmyAvnn4HrGam9QF6M9vYmP9mTJFNCDe3pNZ36bLVPj9NjTGg6kGhmAj6r7PkxD
	f6VSlMJuPjlmb3ncsmMsfJ51jh5177l4pzY3EuPweSv0CYMWMF0Tj7/1gCPnB07f
	k4EM9wSBclJKkCieARFNnDFqGyhJRkF4Pdp4XtO78VnbdQdztEY3XFx3D21Q6Gsc
	U3MoagN7z3PEUQm9V92nWnVRm8EYT/KAjPMz8aV2kraLl5YVpXVnvyLmnB81NrXb
	HUtdlg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6p08nm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:09 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso382988eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 15:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793314568; x=1793919368; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kovbbk6loTr0hn1v5TMoxCLs3KlWkkhMntV1tVmNBmo=;
        b=bgd84zGn+zIL5hCjSo3/aVDJuEJ7KUtzpThmrhcwigejaDoH6XqEFy1k44VmXIYebj
         D1Fp1DNu9O35b/ltp1RGPgoeHmdWGUwuF5Bx0tC+kBZQUAGPgG0C+cA0S7ArGRtVC2k+
         ru06JeZGczgVyCAb+zOE46OsVxewnX8tDFp/eCXFbqLJdMAGKrL1XlG2NpOXWTmg0TPX
         7F5JgBCdUaMvHazccZV/EtGq2AkdTYlWlx+7k4V6/vyeGCf8ly1+U3g9x11VOOYg/u5F
         qimRpfdEIrfH3EuChlhivHOzypzzV+kTrwp3UPB4m7SEOH/GihFOYhjLXHIUMg4GUhR0
         rMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793314568; x=1793919368;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kovbbk6loTr0hn1v5TMoxCLs3KlWkkhMntV1tVmNBmo=;
        b=C3E5ZywnZadci5iC/eQNQzx5XHkxCahl/VDeaNTdln3TTCEMISdTj0iP6ulNSVWJ/D
         21dTfkvSOcqy2aQj/oqO6Aln6lzvSQC5/sP3rxrvaZ18tz3EkmBsXz9UM0r3odZflBTd
         yIgr/ZrZlIokjrgZDN/yZ+/x/xW8cIeJQxUVq2IabxLB+epCamrqXwKiNnMhcyjRrHvm
         sr1Ol8HegeNRPXAUsj6+Ld+YB1hQntlcL5cKkviv8yZa7qKhJxAuyDhZQ6j6KKzLHvRw
         navIKw5kB8eC01zIbHui2WtI9IMlRVl0/dhmgYq2CbVaNDxvjpbdwT0i4uHhck8ETwAj
         zneA==
X-Gm-Message-State: AFq9FYJ4qaXBZyWV+EfT1gZMnM8zQmqUIOFuHkqt0zda0tljfpXGs483
	664xl5uoULKPvKhhMOXG/sI8w386CEA4uukBHkZKxK1QTXpky4BxR5yKgt8kzTwZ5mNg02o5UUZ
	GZ7XC78+RLwKsuLkdSqKBN4QT5wD0XxhC1DC9o70JopIjWnBkew9VlJfxvkMzaOdjG6c152GhRv
	hsJg==
X-Gm-Gg: AYBFou0Eok9kPgBtRblFbAIAqJu+2seJ2rJ74dbubh+k44Kjmxd7g+BFL4YXowbs1ww
	5OzWnFsTvM+v5eFGBBje5y2aXfR9uyFBLH50l097SC0edQvbQ3CUsLue/6gj6S+iO02KaQz/88O
	inO9Un9jhla24RTxIGwXFUmie+ptvUqA0yiMWoCb7SiTF0tIuI/9DO/c3qN+DK1Aotm96IK7/W+
	2Tpf/Ar8B6N4wh71rH+f/RzqyVSYtLbCAMIFXiJb+i0pQ2g1v/3ukIaJDl5qslfdoX4rMupBzQs
	dRrnKSLZ9nYSwfY9YnowQQ3NImZwKhJV3gGU2vxkpR5hn61I+p/4QCVLq9W+neTlBqE2EeqmIE9
	PgnbCGkENUE+1l5xCQ8IoqFURUZ3yCdNEAg1P6E+xODrQ5vBOcadvjCCh9gOJLH8se0boHy7u2z
	Fv66/irOmfWS6+86dsrPb5pceSpaPV
X-Received: by 2002:a05:7300:ff42:b0:369:f231:4707 with SMTP id 5a478bee46e88-36a42225abdmr958165eec.5.1793314567895;
        Thu, 29 Oct 2026 15:56:07 -0700 (PDT)
X-Received: by 2002:a05:7300:ff42:b0:369:f231:4707 with SMTP id 5a478bee46e88-36a42225abdmr958121eec.5.1793314567149;
        Thu, 29 Oct 2026 15:56:07 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm1644278eec.8.2026.10.29.15.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:56:05 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, P Praneesh <praneesh.p@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
References: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: fix IRQ disable imbalance in
 AHB ext interrupt handler
Message-Id: <179331456572.1083805.8183504418860911959.b4-ty@b4>
Date: Thu, 29 Oct 2026 15:56:05 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA5MCBTYWx0ZWRfXw4Hg8CPdsnEd
 vZ4pa6p0osTKvv1Qw2W9NWxv6bbgwR6jLsNRiAVO6H5bcJQlkwpxArY4QWkn1D1fFX+Za6swj/t
 acXbhnjxWZUAqJfCch2IpBcKFYREWx1n56lZUOuK4yhdjQ0kIbPMKBwHDrBCcJYO1aKSQf9fiI8
 y3IlBpkBoca1Lvb0l7VnTsbbSFgjXxNatTPRs6UofO8G48HV8LS1DSlHtHFdnkmi86+qfFWR2Fp
 q2ojQtu3P14aW3IPyxJfO9g3MzeI4PwDuapuTJUBo06fL4bkPDgmBjCcO2tYXYdFq4ckxUBwdIA
 4sZdUsl7ojtM6PASoCjPdEG4Rcj1DLzWbvIBfYgjvP/eYfTSLvBl/mGxQOUuhJ7+nWKP2txL5ZA
 k3cXX9C4N/GgqPlsIp3ikt7koLSOTbvTOCJPdQuiSMH2/HkG0v7XGCWoO3KuHbHVn4Gti0EpvTS
 Jf1OjnDQXCrrtHo6x5A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA5MCBTYWx0ZWRfX0TrovOQvBUVk
 Y5sLjUv6DGkJU73XkU/1Vt9wl5KwyNANVLoy5xIk2LG8MbqvYxqf8sloEFs1NgxPdGPTMor3xZI
 LKL5uuQeBqH/kyOD3mF92oMzj9bfrWQ=
X-Proofpoint-ORIG-GUID: d0Si0ie1EX9LfQ-v3twmLyE6-NP9lf-z
X-Proofpoint-GUID: d0Si0ie1EX9LfQ-v3twmLyE6-NP9lf-z
X-Authority-Analysis: v=2.4 cv=TL3Q2Fla c=1 sm=1 tr=0 ts=6ae3cf09 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=n7ogJBxv0B39A75zntIA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290090


On Thu, 15 Oct 2026 14:14:45 +0530, P Praneesh wrote:
> On AHB platforms such as IPQ5332, IRQ group 3 maps multiple hardware
> rings to a single NAPI instance. Each ring is assigned its own IRQ
> line, but all IRQs in the group share one napi struct and one poll
> function.
> 
> When two IRQs from the same group fire simultaneously on different
> CPUs, both handlers call ath12k_ahb_ext_grp_disable(), which invokes
> disable_irq_nosync() for every IRQ in the group. This increments the
> interrupt controller's disable reference count for each IRQ twice. The
> single NAPI poll that runs calls ath12k_ahb_ext_grp_enable() once,
> decrementing each count from 2 to 1. Because the count never reaches 0,
> all IRQs in the group remain permanently masked by the interrupt
> controller.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix IRQ disable imbalance in AHB ext interrupt handler
      commit: 216dd4fc57435726506e250ba2483f31ddc3c01b

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

