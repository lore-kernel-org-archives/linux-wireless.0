Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702E84CC267
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350022; cv=none; b=MECTEWe6onX31ln6fjQvydfB6OGE+CF34Cc1TdSq8oIMGCrIgxkkFN2tqPAbOshUrYEPxVmZXRWtls31Ef8CzFuTycEfoNoKgV9W9KOMZo+piCqep1Oc4IHcE3ds06WPWP15era8OHuwulL9E3ycgH/uFkl3od2xwzDp55QzvJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350022; c=relaxed/simple;
	bh=MJKtxmh5YLQ4CTMXT7Xtr7eovK4rSJJzlr3jIYaPDp4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ThFeLHGhacWGutdrMYeSWwY2fG/iHoQABl/7aIg90va9cNeI7MPWW0jTL1AZBP25nWF6XXK/HoUoR5RknlQXcVY+CgsvzYjqbXwemNthMGjQH9jTejpzBPmuB+C+FrygbX/ImYAXxtlcdVoPa0S/VsqrhcrnESQ8Zdg1UNmoezo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dUv8z3s0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DnOJUM1v; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dUv8z3s0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DnOJUM1v"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PA4D1m609155
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5DKvmXhpPlBR3vI9A+Drw/VIkw1kzao7rZBY+Ap1mi8=; b=dUv8z3s0k0KBBbwd
	NNjzCGxSoFZpRrYh4gsf4b/rsVTNhsq3s1WxUbIhens0l45BT0yRCL5JuR3Bz3yI
	sSQarEpn1fsDZxH5W+YCaddyiYHMM/O83wYkAkNE5lgV07rWL3z8R6oPZs6F+6bF
	bVXroe4y9B9eqRxscuLFPynjV9gFvgm20WAmAAW7u6C6g7oxCVPTZayz7AB4elc5
	fNkQhfOEGSU/HCuLiUIYQs1ROYAN9sH+AgCBDCvuQMeNXz+q7w6AI+9JT8bwU+Ot
	klN83LPPEgQVFGLBiWS7Fpb3Zh8Q6jlyOFaG8q40iDQJHWDZA0mPYvmKGW9td4Qr
	8bsMWA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwpvns2a6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:59 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so613545a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350018; x=1790954818; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5DKvmXhpPlBR3vI9A+Drw/VIkw1kzao7rZBY+Ap1mi8=;
        b=DnOJUM1vNIhldMWFyRAtHP+1yElp55XsEt+ulk+RgKfIBqm01MTXMrk6I8S5s1tp2M
         QOWy9NNYe+WQyXB2uTu+gNX3jhxCkakOgHr6P8DIJumc5OpMsMSghjMFO2H0MZMYP/Ns
         mfxjyYy7vQCb9oz4OSkiUPo0m0f1PpKTq7jNo2w1fr/FeAM2EGn9o6+nS/L06lexla6+
         fWYdzPWuagDXo1sZgdUxhU/5XUi/PlJzcNfMjxLhw8i7GSrubtHr1BH9jtrooJ84LjPa
         h19d8L26XA/2CTko/u1c0KSp+dwAArsuaOzs0VJ63z8YWJS/U9xD1sBxzgWRtCkLVuXN
         +8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350018; x=1790954818;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5DKvmXhpPlBR3vI9A+Drw/VIkw1kzao7rZBY+Ap1mi8=;
        b=ynQtawoe9Emld8hTmhjWs1lMLb+xVMRNmxWLvscKQu1RFLrU8pcDcZ3JAzQS2P7/Vr
         itjUkIEtxz2k21CBe8MSVq6UTfW/Msv7Kj984CGV2F+Nei0EXBaptyWvXqmoTmYq+MSP
         0gEuzgTmV7LCE7Ah84bdu98ekWXez5bHT11pUB/FR08pCdObq+w+ereQ6hIZe2WaMWWb
         TDrKm5/Qo19dQMa8t3j1/qi0kEiW53esHxmvOdhBxNCqiJVe3tQCJi566Kh4exaCFYAa
         GuC9AZNTe6mCn7jx2WWDInJyHaEcbaQg04kZFyCH0hYbqCU3BYHXvL2aXRK4DwnTjMxK
         L/ZA==
X-Gm-Message-State: AFuF++m9wafXLP3pCyKiRn2WNf4LUQ17KVkYKZdNoy3VhDLDtjnGD1iB
	6VM1+L8wm7c88eBwETAvNa/LQT/jbB/Kj38+71kmc6oajPO/4u87ESDSjp2MI3jvpFXR24bvWQE
	fGKY6sWKjIBSrXttbMAj+EvaVvjK6kUb6F0iQ9AZxt517jQM0IC0GDw+QOCdf6WAwo5vUUA==
X-Gm-Gg: AYBFou08VQGJ4eHfcQPtN9a+6OJlk1v1X5RiTcQ9bUp9iKLzPQ+Tfs6xkYGW7GCFYfK
	Lcxd96CCqJ/ybiLjxYBeoR9RVUX20XgmReDyg0Fs9c4YGpx2D6fwRUaZT2k6bdXe2hBYwefzvTf
	+NeBftySZY6zX5PTcH49fWZuc9rCbp3iOmnTzTI5c9XxlwBJXRsKA/nNXTo5e1r32wxKvfmz2YI
	kpd3L4T0zZ1uBGJTO6AbabegM+8DKHJXzhL8fkuD2GDuGn3ILe0ga1DflS+dH6I4lTnpOkbYCsC
	waVbNGdlgewzeuWloFp8l2VhTrjEZOrh6KZC+1e19CO7f74zHzQyXA3JzDqTd/vAthmWP5EZ5tM
	+H/QAjFu73Rg1aeBDyENOg/wMtffUEtQ1fSxu2kDUxSgGcxzSRiqHYBE=
X-Received: by 2002:a17:90b:3d8b:b0:39d:f024:c7ee with SMTP id 98e67ed59e1d1-3a098b444bbmr4769222a91.25.1790350018135;
        Fri, 25 Sep 2026 08:26:58 -0700 (PDT)
X-Received: by 2002:a17:90b:3d8b:b0:39d:f024:c7ee with SMTP id 98e67ed59e1d1-3a098b444bbmr4769195a91.25.1790350017326;
        Fri, 25 Sep 2026 08:26:57 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm5320405a91.0.2026.09.25.08.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:26:56 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260817-reg_info_store-leak-v1-1-77025a99b074@oss.qualcomm.com>
References: <20260817-reg_info_store-leak-v1-1-77025a99b074@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath11k: fix reg_info_store leak in
 ath11k_service_ready_ext_event()
Message-Id: <179035001623.3875741.2110365933382475990.b4-ty@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 08:26:56 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: RH3kC6MxsIYEBZmkxu2qGJIypwMhXobB
X-Proofpoint-GUID: RH3kC6MxsIYEBZmkxu2qGJIypwMhXobB
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX4cPu/Uh2Bjmj
 Hc4xS8idHVCF6w7D5ri1pMta+VG9RhCCLfuvOg3IgWhxOzq7xO85QuUEAEmxuy+v5r4Y8kduMU1
 SbUhvI+XdPTJFRpvlWG0bvZERm80nFk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX7ecCiODc/FqC
 FrE2hVMoOviBbjrkKRk3oiXbelTma99/9gY2Cf+R7MDkFWc8X0a5t89KExZVaANnnBAKQJ4tZfh
 KkwSEmbvLgfEt5Kvc3B+m3w3WiqATBGDNbbakpdXo9OKZ5Lza4Y8OvP9TtRlfCVcJWQVph39pEr
 jfxxPvoc8fyRrxFE/4pX+kjn7p9KSThDBdfntqDL4LjZKeIfRyZD6r+L/yqtDM/IlIhqHoRzDpw
 63Pypc0ZmRgKAVv8t5KzsaduiZAsfnMNyhC/qHHInrhAqzTqKfJXiPUOQMxUorZFYzgvLmfJrBu
 h3kDu8Bl2IE4Xa2gbQe4hwnliWrpnoaU0h6bi/L9arF1MtPAt7d8VL2Vnt2gay1Nq32J4yUn5Aj
 8YqDP8lFBRwvAautLZKFl0bxp4sZxKbMRVAG/n/1A9ZpCJyU8aQMTPEgF7ti8/0Y2xBjsxixBbe
 QiU1fcT6QY5diGJ9suA==
X-Authority-Analysis: v=2.4 cv=eNmGH3p1 c=1 sm=1 tr=0 ts=6ab692c3 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=9eebIFysW1Mfredz1lwA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250061


On Mon, 17 Aug 2026 16:46:34 -0700, Jeff Johnson wrote:
> Currently, while processing the WMI Service Ready Ext event, the iterator
> in ath11k_service_ready_ext_event() can dispatch the HAL Regulatory
> Capabilities handler ath11k_wmi_tlv_ext_soc_hal_reg_caps_parse() which can
> allocate ab->reg_info_store.
> 
> If a subsequent failure occurs during iteration, the ab->reg_info_store
> allocation is leaked.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()
      commit: 64828f091c7de5c1324427b140fb545f93ef073f

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

