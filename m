Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A8929992A
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784770034; cv=none; b=Unw/chVvxqghrslNDzFbZ5xXpxpbIN6n7ZVUHkV6yU77ynsWKD2/3+MECCgqqA+H45jfvkxsOV/DvZtn9jR8uHAy+6rsaumlfMrzJ0t+ki2kiCSh7u3gXtx6mU27LeOBdoLBFy4yXFZBJ13wnauqcTdrExPx6ZDZb7A6l1p/lB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784770034; c=relaxed/simple;
	bh=kNH7Voj4BrMj4vL4hKl3TEX7nxgdpyHnc9326Sz5g2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uXo9J3PP1zzJT9QIh8Bw124XpzzraDsrhPjmBvdr7LjrN9pWL8DoR/o2ZCyyWQPAoU45VFhXBrM2fL37oHt8u9DZX+Z08/diahUnQbfHnSLsfO71/nGg0hKPq522EzaGxFq/QL62qR5Z1/wc8k5qBXd+moOU68lJUuwgEx+BrW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f8VCzNbs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EXxMiOLb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f8VCzNbs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EXxMiOLb"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N0X29a2264410
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kNH7Voj4BrMj4vL4hKl3TEX7nxgdpyHnc9326Sz5g2Q=; b=f8VCzNbsyFyVwbUT
	axprXy31irDE6miHTWLDvY8slz8skAzzZmXFwXjL5TK2s/aAoIdZ7pJmqjf4rQqI
	UEIbJyuZmf0miU2fYVabpGCHTcUtA8vg6kzQMUssIMMa0DkHYA7SvdODXHINog3a
	C30IMC96+k7xGEXrN+yJJmG5P+/4+XutGW/IfHcmQ4YO1dvzOblBq6Lcgv2QI8CP
	jnUV5AhMTeiBU7+YQEofUdLdGw94a5uiVtVugidPl9YFU3W8ofbHg1/lGpB7cMmK
	ZbUd5HIvlcw6g2r1ABjkbAzH3T28uVFslwe9178G0NxBXilwR5qZUHJvchWSSVK/
	sjnOCg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjtn2uues-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:27:12 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca8aee88725so328728a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784770031; x=1785374831; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kNH7Voj4BrMj4vL4hKl3TEX7nxgdpyHnc9326Sz5g2Q=;
        b=EXxMiOLbMTLr+IkJZFSGGSC0hbMA41pZONX4XwULvQ5OWxXGy9YBreQJLARNsuJhI8
         tBfg5Gf5NxahlnoBj55KZb/4dhry/vsaAWVS+IbQf8settgW/UAZAge9d6ImUWeaNtml
         8KF42fIrlK38vhXUlXR8QnDEJp6tV+GWWqtugDS+Ch5T0vstdZTfBOoIHJ4qfsNI9lkN
         l9oP1roloWUlp8CpQ/SJQ/aSHMLTqcN6R+SXHlPvvj2PnfmKXu3hBFY7HU6hSKdhgC2d
         jdExMQRw3r5lqe5UTaoKjPdLJV98k5Aen+gLpC6xVjlXdUd+hH9DKsXGEMjl0du2H3Ti
         V9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784770031; x=1785374831;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kNH7Voj4BrMj4vL4hKl3TEX7nxgdpyHnc9326Sz5g2Q=;
        b=Ev4BXdp68YjW7rHS73Ch46SOp80YD5ilYfuEEsQfkC3uGixySXracJyQxwc28wwe6I
         aaHNBTH5KKCHY6FWmF6kH4+VvXLXZrXMLqBbSPMWBKOfU30gFjClxwSnxvElzHnzMsqZ
         M7CPDqubopdnh/lkgK5F16YtNnMxcn3ZLnDugGRZM4NdFNxpjJqh26T84/XN2mXvGFI/
         XRjPxtb2KSwQZ9rd1uevw/by4iKowSAx40Llv4+um2FJgy3njzK1azqGtcN+RXsgmYx3
         fvsuOlphTTUciRcGLv8tdTL7g2rBMamWjY7KFA8m4K5jKlPzE4XR1p6a2S8EufhY7Ixq
         R2Bg==
X-Gm-Message-State: AOJu0YymgQG+fGBHAtgd8qXdjNwT4I+d7CrMoJ7ruGtpqcak3gKkggA4
	3K7m3WlBfbYbiYUvt+23Xe61zw+C1l2Yx4v0vVEVFqXf/QQUGclrqSKzUu2EpMr+Tpd857paKJt
	L+M64dELJxkUOT4dE5R+RnYrmuLz/rBlN8kkXbH1gSAqLKBiJ3kkFHNCfcqM7AIwugfHUVg==
X-Gm-Gg: AR+sD12UZp8kJSTyILI3al7O1ugXevAX0wx2Zp3oFI66cR//00W/xLT69rARgoZTfVh
	d/FKrxVkZlYJGd7XLyiNRzgMR45eDI3kcmQCU51bnFX9CaFJgnqYFxqjGmekloeYISWfMw2j2Q4
	r806oILTttqKBPw7hUUhpF1je2vORNS9hPHXUJLyRnqtES6Ligyha9HRIWBXuzwaazkDl3qPLSP
	aFRdtCW3EbngZRXW8i3SPTpoC4lDzIKRhCIJWLJkZgefuVIMOHhMNgUxl7oMR1xhRsrtbV4zfir
	6aF4XP7Hah76TNFtq+ndjyMitcYqwhuY1HIqsjqmjw5jMiI222lHL2NY00jN0ERfmC88k5NqOVI
	tbUEnGeo8VjeZ3j1eG/7pGxOEW6dzy1T1cOeDwJr48v4J7eIPoDES64nN+g==
X-Received: by 2002:a05:6a20:4387:b0:3bf:6c05:ab with SMTP id adf61e73a8af0-3c44b21f1e1mr1034482637.58.1784770031400;
        Wed, 22 Jul 2026 18:27:11 -0700 (PDT)
X-Received: by 2002:a05:6a20:4387:b0:3bf:6c05:ab with SMTP id adf61e73a8af0-3c44b21f1e1mr1034457637.58.1784770030951;
        Wed, 22 Jul 2026 18:27:10 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm10579220c88.0.2026.07.22.18.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 18:27:10 -0700 (PDT)
Message-ID: <c8634216-e35a-4d01-8f76-d6951e4689b5@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 18:27:09 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260722095419.1411003-1-zhaojinming@uniontech.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260722095419.1411003-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDAxMSBTYWx0ZWRfX0DCfR+xZWv62
 CQKJ9UCGwXfnVC85pVCszn0sAVz8eOPCckmt9SB7jMjtXlw5lH8w04vLstFnM4XyAUGJFoVTHIx
 k/gK6Dn074Qe9lwwtOivfsdEilWcnnrOgyPeO5rcCtFKlG03i8P52NkRaZ/I7VqhciIIuFo8OvI
 X9sdN1UHXAoH4PzniPId1L9lxH/nhYq7foLojQJ+kgwK71113c0d/5xnB9VKAq2yaoGAVpEwFOe
 MfGcb+3j4QzXlRs8BWsGOoxViGSEGXrzLI+EAMWZWs41Id/s8WjIYlVVGVjI1+/iTs4A2Jywuw4
 wWgqrdf8GmN3glhNHfAF+F1MJOVj4XJeVw0OyUpJKnxifSz5TyZ/LH4ADIX5h9oaKGRQpVPngyV
 ryc6Z+Rpz1vggS8PKmCx/Jmd+3hBR6t7eGn/2G194UkYLk7nsbcz5DG7VfNyvfrMUF8gt7cGCmQ
 7cGm8kEE5P/na7oJi0w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDAxMSBTYWx0ZWRfXwH0LcHGkTRv+
 IceeTAWTwJ5z35fFoovBx67cr25/AR3vmBBmJSgQHr3ZMoiPvC7vdTy8Qi3efmKA6MxDw9PBfGi
 tNYhVFR8KN3iu8t3vTq7qgC/Q6Y+BWg=
X-Proofpoint-GUID: VMGbR0F4r76Og0RTF67O0OkH6PYp4UfA
X-Proofpoint-ORIG-GUID: VMGbR0F4r76Og0RTF67O0OkH6PYp4UfA
X-Authority-Analysis: v=2.4 cv=T+28ifKQ c=1 sm=1 tr=0 ts=6a616df0 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=nIXYEoMg1qDLEO0gg3wA:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230011

And now there are two patches with the exact same subject.

If you repost, you should either add a REPOST tag or you should bump the
version number.

/jeff
