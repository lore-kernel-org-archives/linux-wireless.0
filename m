Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622B392819
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976681; cv=none; b=mkGnDaWRwMwhKsoy50y9kk+sMMTc0qximD8y+Ku9FxBlo+Rr8hRXf2GBwnhedDPLXPS+SUB6jPVNuvqebzX04IR0G0WOd+7HAHobp5riBKM1ZgZGzJKYowPQM+g9bX97zhrX2C0/VviqUFM52UFuQQdP0p0615kQFIWw6z7i+kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976681; c=relaxed/simple;
	bh=IYMmXsPW2Siv1hll5bvjdy+rUx7kyaPjpYDFTE1C3Ow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XUpFUs8POan3+EtiNocOTE06q0UW2uCl2D7G2eUlLA/UNXEaw/rPKTqj5D0NXW3V7hPioos6DDchrpKPN2d07XaYOTHg0QzpB8ttGO2i2pf0CtBIXY1zCtTPLsZsi0Ry7n8RHfWmhLhtQiVEl5c4ffLrbdgMW6nnlJw+xY2U0n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Lb5Cfu0j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fjyevaHp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Lb5Cfu0j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fjyevaHp"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H7EwE3411921
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Dg+vOyYVeG/J+KZ5n/59eHOsMGy/Fco8k3zSySXeruM=; b=Lb5Cfu0jwgIZzuWS
	e7Q/Fy5TlFi0e6pi1OEdS+i3TeG//HIXGQi6WR4s9DaJNSA0eix/kzTR8k8lSnEt
	ywYM2/JD6cn1DFPkcqCc7U8DMAeDmBlFzJ+lbbhVTOdf4EcoRp/HPEWtJ7oqX+pW
	LeO2YSa3mwyj2b+6fhx3Dxjts3ToFJcMiwhE8lelvv5F89H5aBO2tVB1CJEon/dA
	55tLN7ICh76gg/Ts/yhsR+0he0/hpuiJsuMrR1G/31i5sqBojqRrkA9Z7Wec5+rP
	QFisbGVuf3CVPnw1HifGduY11abp/bCrRRfvYXxQp0AIYbYiInqY0MfZibVdLmK7
	yg5idg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk6xh1rf1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:59 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1cdfb337eso8711003a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976679; x=1789581479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dg+vOyYVeG/J+KZ5n/59eHOsMGy/Fco8k3zSySXeruM=;
        b=fjyevaHpSqKR+fdzuU1TS13l0eN1x0eZEyP9aCKPYdEY0nBx1/nfEUEe4P05t+7R/f
         Y1bRPPPs6/WbBrNA00PnhcnbkvRFAq8RtNoRdrQjhi2Fadh6PJYaOvtI8G04rDhV+Ea3
         d7WeI89mKhJ849QNLlUKMKBy8y83n0d0rJ8OpSwQPSUA2XAN/YaC1ti+CVfynY/h6f7m
         lvp1uyYTKc62hdI5v9kKCJl4nrjLVDmXlpm8xjSeVw0FFDoszdrgpCHsjpfOAQs85YAM
         4i0NQD0RUXgWSxVIfEJg/SRMZU1rnqTpah+gauA3o4dQqMCVAivopPFT2NhRl5Gyz+hc
         OFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976679; x=1789581479;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dg+vOyYVeG/J+KZ5n/59eHOsMGy/Fco8k3zSySXeruM=;
        b=h84FocnKJciYT0+1sJ18skYs8Wp2BoNPSeEy714+6elwkVaryYZi9x6HGgv6KW3oOD
         MLuqG4+peyJIxgCtSc3hoYrNOGwIHjUUkHstIzjginhFqH2w98lHyQsLlUmlXng8wj3k
         gezMBkbXBi/F/XJJ0uChf0OS4aONTn6IRTt3nOuQPWlxBkPRY+7b/mfRWqEX9iY5tSJ5
         n27PYN/lOXEljyIbf9ZLSM1/U8uMD1VHYzE1klh/g77ZeAVV5PAOTr8+IcZ3VAqjCwpY
         MdjgoKzGwb42lC7LPUR0Cp6RPHJhdd45LzCC3U4jUsXV7MU5TTw84RcCK6vCUnVlNNyB
         T0mA==
X-Gm-Message-State: AFuF++nnwQNsGNfyyGHR8u7KxSU8xuPjz6+9igN59Q+olKI8rlttoMrD
	wZ+/IUBAZ+KNZ0rVbAYBol9XVLp5p0syQHoj2FMGlSdsdqH2lsrBW6/dzns8Z40lDxBEVC+F6zK
	kkmo13rgN1Q9KrVbrYk8RLuBso0AJ04vKzZIWzDAfSN0y/Vdw8aonT+DfIyUmIIVpeH913oLUzQ
	+SNg==
X-Gm-Gg: AYBFou2iYEzjt8Uq8Uo2GNsyJDEO1nZ197skW3+lad8bRu0RC5DpBrS7pf2SWqqovUR
	H/BElF2WD68xQagBOQE5E20LcS3wuz/eUdgP9J0jVaZxZ1nCgI1h49CcVsNSNWw/P4bTPaFFvtj
	kCgBYNxrU3aYJ+4RKk1GRawdv0UaDubueLKQgWSrDU4cJgBNUajKvwRDToJ5sodDxtZ8omIScTM
	erD1fesk9NMV4oluJTWpvxxkGu6rsKkasu36qL3V88iCDDfzwpy8f+PlrYrW1lKwHO5qP9Y2R9k
	AInZR7NgokXaZYiocV6UKlGbS9qD9e9xDSZwjxmSAeS8m/GezIYmcCeKqNK9gfSbNw/FHGlfyDH
	MVr7FZVZFoyyh3dvSyy6yE0pkTsTwa4WJbkVn0oM1O/EFO1Jw6f5Xqn0=
X-Received: by 2002:a05:6a20:2d22:b0:3d0:f57d:c87a with SMTP id adf61e73a8af0-3dabab860f3mr13078849637.0.1788976678897;
        Wed, 09 Sep 2026 10:57:58 -0700 (PDT)
X-Received: by 2002:a05:6a20:2d22:b0:3d0:f57d:c87a with SMTP id adf61e73a8af0-3dabab860f3mr13078801637.0.1788976678484;
        Wed, 09 Sep 2026 10:57:58 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:55 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
In-Reply-To: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: Fix IRQ cleanup on PCI
 IRQ configuration failure
Message-Id: <178897667494.2048605.9304437211489801497.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX5VSVizBg7QvK
 8m6XWd0wT6aXqwUDfotwpUwUsBzvt6fDBspXpwKBHI+8EGJ1KDocbbUtoHFNTTNpw30fj7pgeuH
 viSeS+XV2hBSuxkyjnR+vnz+Kw9LGxJPT4Bm0uBlqnduBpIsoWWQgKDg94AiSxwQm1epFsSFVA2
 Tyk5jfk9VL2IIzWpED+r+Bi9RUDr4kO2MAHg5pdu1mcS78UNx1IEem55q5expDkbGh6ceFzwxGa
 KPli2Q3x4M22WNe4anWmE24FL+r48EyWAarqDvDZaUQYZCzTLasnShL4TShJoFdor/vFx85CmDQ
 VuT54PluJZyccaBqDP5GGEmhMvElsVkywy0v8QbM9F3HaFR+BgGfvWkCLcGTSBCndHkxoBQCxWG
 lj1Hbh3YL7KpUAwiiVpM66TEr7L8bwTFG1Jaos8oD/+z2vvh7SfroXNoOgKV6WtXSWzGBJ3vU5O
 IEqDd/Sb2ZRn/yzIBew==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX9JMh9CEFXUDC
 gjvzH50Ilv8pfxQx83uOvvAxoH2HhP85WFywTnSPO5UJL5X66RcpmToTdjhCdAOD9Jd7XjtL2mD
 l7yX0+FwcMRvd6psWD4l54+HgBmGJAc=
X-Proofpoint-GUID: uQQ_l4wqOrfiDP8o0XVwOYr2CXg0ouY1
X-Authority-Analysis: v=2.4 cv=KOlqylFo c=1 sm=1 tr=0 ts=6aa19e27 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=JJR71pI42961Z5K6J_YA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: uQQ_l4wqOrfiDP8o0XVwOYr2CXg0ouY1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Wed, 19 Aug 2026 16:32:13 +0530, Aaradhana Sahu wrote:
> Free partially allocated IRQ resources when PCI IRQ configuration fails.
> 
> The first patch frees previously requested CE IRQs if CE IRQ configuration
> fails.
> 
> The second patch frees previously requested external IRQs, stores the IRQ
> number only after request_irq() succeeds, and cleans up allocated
> resources on failure.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath12k: Free allocated CE IRQs on request_irq() failure
      commit: 12ca935af2e68447e9218a615ebbb5ff7faf1554
[2/2] wifi: ath12k: Free allocated external IRQs on request_irq() failure
      commit: 9a78703ec4a895bd2e99bf43bd18d76683126c19

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

