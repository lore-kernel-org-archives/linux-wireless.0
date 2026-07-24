Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CCD233927
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853605; cv=none; b=tUbdO/HhEKpHMRenXS23kL804C78nr74MfDLYxlhVbnYW/QiqDTJ8rhn5lR2iPUMrvrfMk81Pw8vl0TYwcYmcc7tmuBAC18Wve6G2RUdvBzivuoPA8zgPUvBS66wwP2NqcDIb35KJDC9yfIlWqtq91vPzC1t/bUKDXYFDcaOew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853605; c=relaxed/simple;
	bh=o7n+zUjOmQKkw0T5F9B1XnByOrjXiy3/lcQEMuS2a9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r+bwqFccnHno5Dm3mJ3+y2EiTIpVSWIE0bdJNRUteqMFW6qOmSMwKNwzD/C4JQtNKUcyoEV5c4Ry/gPUDlqKlveoJcbGunHNG6pIv5vT+PS1lt67s17+SE7uFJ+PFVSyAlxyYJeHyqDFvfOT59ZcuvwlsxVu2TK8dAo7K0DtGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N456S+rc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FYiv1Lw3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N456S+rc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FYiv1Lw3"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLeTmF948929
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	o7n+zUjOmQKkw0T5F9B1XnByOrjXiy3/lcQEMuS2a9U=; b=N456S+rczol82cMy
	5PBrcT8EnNPOBHGSuB6kZKPmhtb4Fl2J1YyjybtLl134MsWl7L8jb/tR6YV2RGAr
	ZRUs7SubKxUn++J+BW5DHC76uqFROwkQpNX+Irs8f5Wg9gBCDFUZOBDS46Os8TO6
	9C1aN1UepEADLiuf/iCLPYCBuOeO0PQWRNQHaW5FQdp9ikIF0ND74HYY3VqMLnbR
	3mnDPtoRQ0GmFUyYgH5l7eqCESUJqASol1xCJ1oS8BG5//IFtfQbi3uQtVIbTyaD
	5OHOUXM+dKxObduo87Ol8zXJIYpjLsthA1VOKizig35moraF+Mcre0JKzpZUBWen
	r4B1Mg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0kv4nn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:40:02 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e6d253330so1094225a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 17:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784853602; x=1785458402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7n+zUjOmQKkw0T5F9B1XnByOrjXiy3/lcQEMuS2a9U=;
        b=FYiv1Lw3Xk1KquCoRCDBgwyJ3+kqIFZHbpYtK5I1M6VXwVw/pj45Gu7FjO1CQCO5ZI
         RWzQ5VizISY8VP8D3hSwSpZYj6NC5ikvyJHJPh/sOCQfqMFULZMGY9ko0SYa+uHz5KaG
         6DWBftKZhEYb4RZcPz/xA39zTTeugJohsngh2ZadC6joQxFfdW3YCKB6uR8fFGBtyihI
         UzudgZHZaZL08UlIpszxyZYnS4BI3QimEFbWPfulMI471HHcfC5fwLChZ2oyYAJxOyyn
         RwTd3TFHJBqv6ZqPaWCAQb+qKoq1oMGaxkcLsczpi+HLpIG8EZVrsvb7cTpmQVEjIWje
         rPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784853602; x=1785458402;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o7n+zUjOmQKkw0T5F9B1XnByOrjXiy3/lcQEMuS2a9U=;
        b=MqI5e22dNqRqaOYojW2xIM+FNBLIleS1cxiqCGpOKr1jRNOcL8+AdQX6QypytCdKiL
         byLojgs1z7rHv+pTu6BxgxrHWsCEggxzKzQDxx+cPqpr2B02oV0SOyB37QvT2EfKN4Zi
         IHdFyN4VRB0zqvAPAMywuOO+pnXyJYoLZznSFJUzw1erwtO8zMUJtO2QdS8GO7vmyZ8r
         mO2MfFhX1qEena9oKwAruiyzxbSmG+tgA6VaxyQtpuwJOZ16Ijz0gl2j4COmxLSnuzGf
         y8Z22hB03+9gPsmCJcZSAJxP8nUbz6BPaYD2T8LQReLlCCKcLzhIbZWeOZnibvieoZ/X
         yVTA==
X-Gm-Message-State: AOJu0YzghwgF8I2rnSkOVfpN8SvDz+bKMb7YF0bClyFB+0OyWc6rCTZO
	EAigp0yE71e1Yrd0PQ1BI2KlpxyM6x1ayTXH8iSukr2uereudi0vwLNbimIJRJyBlea1X3GCiVX
	+epUw/minDZcpgAAKcWz//3cbLzyREqSdnxcXqf0k5VdPHfZvMWBCRDCrye/0eHCzELqwPw==
X-Gm-Gg: AR+sD11n013rn70cKspw/6FcBF8bpvJFa2n57a1sxUOUOpo7XSY17hSKOKrwmwkDb7V
	3qatxvIRXC4FGMLqc0kDhTJ6Is+9WARY+xZsU1NjoKMb+HoX9jxoxS2xgyRlEoFaMjt+IXEOtJ1
	czoAjM5aoFwV40lEaGSpn33nZBsrgCZpV11FNgVr3TfW6oUZ3ZUdrdiwP7fsLetGlahMwxGo0rB
	+I5ivtM2boQ8kDqkJNqHKg8Hm4qO+TH7QN6yK6biuOh362N62P7/tIjClJY4r6xyJQfYDqlbw9l
	QbRd8ZdoZILA1jj1KJqS4HAh7a1t9TIiH0bZZJZr7sSTX0ywLjXX0RWolNEfcdF9OleZrGV/1UE
	JtbENlKMzx2TOCGnPRmSN2wviU1Y6Kt1pYqieDaEizVLb+F09IjwENX2xJQ==
X-Received: by 2002:a17:90b:3911:b0:369:7491:7b24 with SMTP id 98e67ed59e1d1-38ec8405233mr5035633a91.6.1784853601699;
        Thu, 23 Jul 2026 17:40:01 -0700 (PDT)
X-Received: by 2002:a17:90b:3911:b0:369:7491:7b24 with SMTP id 98e67ed59e1d1-38ec8405233mr5035605a91.6.1784853601220;
        Thu, 23 Jul 2026 17:40:01 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13002f39sm20365778c88.1.2026.07.23.17.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 17:40:00 -0700 (PDT)
Message-ID: <a01b1349-c144-49e3-b669-4461d3ef1485@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 17:39:59 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath11k: fix txpower in ap mode for 6 Ghz
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260514202750.3040404-1-s.gottschall@dd-wrt.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260514202750.3040404-1-s.gottschall@dd-wrt.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: hA5zqK3BjUU8KOo5OWReFMAR2al_BibD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAwMyBTYWx0ZWRfXzIPIUZJCOYOQ
 BrLbeHr7iTcls70aNO2rxqUzXxA3h+BrmSwy2gEZ+M3TJPTWXeFqHefzHVPs0gnPFzRCajuxrQi
 LcJNPQ3oquom4gNbzMWZbpxp/302Sok=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a62b462 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=FdPzbulkkTFOobXHXXcA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: hA5zqK3BjUU8KOo5OWReFMAR2al_BibD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAwMyBTYWx0ZWRfX/feeVq8ia8sB
 UBtL8C0J+ubmfuhSJuP87ON8F2XJhAt0EOboZzarTPTi4MkxFnj7xS6peEfkGp1+JPOKVHQ/BeC
 WEU7/r+1cxPON16WdWnbCoRP99FRihSl8hkS1lNtdVwwPUB6lmO1qrThwhSNEYv7fvmQzRypTBG
 FJNn7Ep/Ks9VOYMODYbJ939Q7p/LlUe8F1dGHwTJWr1OccrjfEXem6885qpnKDCsSRAPCC19PYo
 y+fAVv2DJyG094a9NQ09+FjPieE7AJH0W8LWBluSjHuJWqERMlfYHGF0KnNj5/92bN57cicSz7d
 DTcuyoUx9RxMy8U88kjK29Bfzcm9maYo79pJVADBCZaSUAm8CKUgux3eYqgDcm+TEWqMMwZFiqf
 CZiIZo5/Qksj4dzadze+YqIkeipwAF8QEO4en/zQTFKDcvs4OPV0ky5EKoGqk9DdPBtA1PNO8vU
 hMl54pQxzjOGxPh475Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240003

On 5/14/2026 1:27 PM, Sebastian Gottschall wrote:
> there is an issue which has been discovered a while ago while testing
> which killed txpower to 0 dBm once scanning is triggered in AP mode
> on QCN9074 based chipsets if 6 GHz is in use.
> ath11k_wmi_send_vdev_set_tpc_power must be set in AP mode in the same
> way is it is for STA as it is implemented in ath12k and in the
> qsdk version for ath11k.
> this patch must be considered to be backported (i discovered that issue
> already 2 years ago)

In addition to Baochen's comments my comment is that this doesn't clearly
describe the problem and the solution.

The Submitting Patches document tells us to "Describe your changes [...] as if
you are giving orders to the codebase to change its behaviour."

Also a subject nit: s/Ghz/GHz/ for proper SI representation

/jeff
