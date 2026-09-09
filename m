Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C085A391E76
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976664; cv=none; b=Bf5vV1RTaT0PGtWhqsY9Nq9SRXREsCfAE5yNxJXh3WTAqByZDg5mVvAzxkaeiZS83fvub8UDV3kVhRxv2GtmgRQk3u4gIqwoEwWxR0sCFbwAKxSwq7M1psW+O3NmCbYsrm99r5+DD/WUX1eSRU/lFj+Mm22GRJlcmtm4gqcBydU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976664; c=relaxed/simple;
	bh=D1URiTZf6ueO8Tp7QwEnlnu3q0WVabH+7CfFYuJmZSY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=C1MwR3tD3K3at7ZwsBtwZJD03lsvhMpZHV45hO25P+7TKwHDempeqCTAX3oQV+FqBN0M4bYV1K16JNn3ZpKlN44pNI5PyB9wMw5Xr28c64/4WXWmuDExR5mZSHOKgsqUhEM/xaivxKeDqzo+JASs2yRJSYx8WwQXa6NFYsQVSos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N/7nVBE7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HmdnaG6u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N/7nVBE7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HmdnaG6u"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H7dY62600141
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6QSy4GkTRDc7cBXy+QCrPJpyuLi1jTY3mCalzG7aIug=; b=N/7nVBE7185U1vcN
	dJ8UAd+EaZw0wHp9BsaFhcRfcm0jOG4qn3lm+d7wMxlEl9UR/G5C8lnSomDOT8vP
	cl2+hjBmXPJVdG6HcmzMr5jfdXt2LOga+saMz8F49dKzmygwRhQ7cd1b/nZPEVvB
	jpEXPrZdFXAp34Ia8IusO9BJuPRCsfMcAxhLfZkCxd0ZkM8k6lWuCSETuZFsPI9B
	LnA3pHAhxs0+/2pm8zDcqH35gjNx2IZfRkM8PonFzR4eOJ/nCB1aLgK26SuppzFg
	p0sEt/hTi33rbXjeIfTyz3FquMBIKOlMT/ruprSNSZ2urLvC0zkmf5pOMk0zA9v9
	JXTC+A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk87r1ev5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:42 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso7430413a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976662; x=1789581462; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6QSy4GkTRDc7cBXy+QCrPJpyuLi1jTY3mCalzG7aIug=;
        b=HmdnaG6uSOWqdEcbErNsp8V4V86wlOPJo5kH3D3ZHpY5CL74slz4dPp5Kaw0M9MLHy
         w2da7FVCbpcC22doL1xBGoMD1GXi3P6bNvXtfVAAUmIO00Fn/dPjIIQqtSIwA4Wmzc4j
         KHjHQiw4qQdkFEL3BziiTyBNLJz1wrFn/V59BoeKBq6kgy6CP6vsHSnNxZfOZfZmM/hh
         yrWZ0cqiREicAMoG82HziTq6qnn4+TGObilXDjuip6T2+/a2Oate1LsDwAQS9Cw9k6Zm
         1grFqH9xVu+Am5Jf/EYyXttYRQGvuNdu05xvEsnuWw2w6y1CvGfGeoLQ12MHWCUDQ9Kx
         PLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976662; x=1789581462;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QSy4GkTRDc7cBXy+QCrPJpyuLi1jTY3mCalzG7aIug=;
        b=GXBLeYA28aLcwbT5ggV9RYtB7xl1iRYtJfWzS0ehiPtZt9nTrQMRevTaxlf9R7P/D3
         BU0dN0I5NH5NDj4mYOYQMOtVoujhdMQlY/ISo3qdBYAjg200iTEQye6enHoaiU90QG2f
         rNZcP44M1HIomvFekzXb+Z9q7Xwt5CMsjzyocaw90UUyuv8SAYWzDUwzUHEJdpjEwOBW
         +O1jbrT+UrUHNGYEU3UB7ouvuYwoJNYV7rexcOG4k7sOEPsRP+wCe/Y8aRoGFCr+1jYC
         biXdauJULEg9eoNX9JuVPSUzV6nNrI7mckX+DkZr1ePkcMGqBz/6XL3Udz0M+haqHDMl
         6W4Q==
X-Gm-Message-State: AFuF++mqyS3f448tNg/RouiAsE6VK6m8f16kuvWRhpX3sJKhl4r+xvbd
	XEEi5tnTwZ3sRXJ105j9x8278pZ0CP+IrMtHrFWOSIxOR+Ir35U4Xdk+KhOOb1QBW8a1jpGmEQg
	i2EJ3unCu+NjxN4oVNIjPHmmQ7/Vmm1Vf+pzH2Laej35LVo7buR+51P/rovjws5lCSZXjk3MHWY
	7jDQ==
X-Gm-Gg: AYBFou0VfFXCn0wD0ALv5BJugmnZD6dp9VrwUpmqywpSxb16tOING2sx/rVHs+v8faG
	oY043hIY6b+9J0kjYpT+u6EQ8Q2wbBimwpS31rh5TLELbHpGD1Ul3uoAnlF7y+qcg488gNjWkAO
	uZZsET79AgN13tHN6eE/wVHY5GfExSc/OKodKk5OlSHedA3PFGbbO1yN5QQuhREaF5BlPmkKrst
	zcoOeS8cogOyNK1mVh2NDzbXwnajD6T/l3HtPFFxMipueh3Ov6oHRaPmiOWCjpoVaKmEp9byZXQ
	a0rhtNk6FJO1dHmcMGC7vaICGBAcIqTixxxLJO+O95v8H4moWb0xzD3ujpICGbLHzmqR4vic0Cy
	MHp8hxEAncIkrsXW722r80h5ROmgw64sx0Eyi3hKqfYjcBxGAHS+eBMI=
X-Received: by 2002:a17:90b:17d2:b0:380:f389:447b with SMTP id 98e67ed59e1d1-39b2613e70emr50029993a91.11.1788976660683;
        Wed, 09 Sep 2026 10:57:40 -0700 (PDT)
X-Received: by 2002:a17:90b:17d2:b0:380:f389:447b with SMTP id 98e67ed59e1d1-39b2613e70emr50029929a91.11.1788976660086;
        Wed, 09 Sep 2026 10:57:40 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:39 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath11k@lists.infradead.org, Nicolas Escande <nico.escande@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
In-Reply-To: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
References: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
Subject: Re: [PATCH ath-current v2] wifi: ath11k: fix locking problem in
 ath11k_dp_rx_tid_del_func()
Message-Id: <178897665895.2048605.3669624011112275824.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:38 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=AImJJIpd c=1 sm=1 tr=0 ts=6aa19e16 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=3DUWDGROrjpMhqWfQrEA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX3BOki5e6soBl
 JIA4mWa2CgDN8sWgy38F/pnIuUZ01R3EYBMQUD6sZqVf3SemZirvxXa9EocYUoVhoE+NxwQpRyL
 0hKZnHHEAkNsKkGuUf+Jw/0QZFGVltSgqOaYvFsdRtdvjfD5RbOKf9YoGq3P1Ar4Xc+JDUR7OGA
 h5j7prqac9bqj3st8JxH4HUooSTWbWE1WrIZAkb5vki7RSBLfV0fvkmbXTIglwcw54bfTeaoQx6
 vMqC4a4G88Jxyu/8rpmRHsCdqBLZY5wyGXQecp/XDznXsLvpsLzD3qt4eMsaObVmDzAcwrPwO++
 38NloOEGm9UbjFkPlLeUi1lEjM4aojbRjc+zVu0A+4HggiiWjmNYg2b/e+regv/UPhzRMbiCaNH
 /sqPEMSac3X2B3Jynt3O2+fzyd4KhZ04z489qtoR2tn7yBF1icoJcBP6Uqw0WBasCNVg0ApaT/x
 m0Dn7YRVpOrVUN2pwbA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX2g9lhK/SQBZN
 muKYl/E2eXQpY14cYOFbgSQk1TdM41hHuwPwlbmzbu9j1sNaoEQH5wTBwZMK4fqVIcg8jkudHh6
 U2gEf2z2EsTdfniddHqq0yZXEPLSf5s=
X-Proofpoint-ORIG-GUID: 7bNcGjfDIKt-zHUYPuxbOk7f1f_eYo1E
X-Proofpoint-GUID: 7bNcGjfDIKt-zHUYPuxbOk7f1f_eYo1E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609090200


On Thu, 13 Aug 2026 14:15:28 +0200, Nicolas Escande wrote:
> In this function, we iterate over dp->reo_cmd_cache_flush_list using
> list_for_each_entry_safe(), under dp->reo_cmd_lock for concurrent access,
> and for each expired entries we :
>   - drop the lock
>   - call ath11k_dp_reo_cache_flush()
>   - kfree() the entry
>   - retake the lock to keep on iterating
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()
      commit: c7555d47b1d051e0406474349deccf74b491ae01

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

