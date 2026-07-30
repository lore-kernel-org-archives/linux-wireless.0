Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9636476026
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785374672; cv=none; b=iggaIWWvxTnuMPI/RQzhJnUnh5rPKFp7R+a3i6iZTheP8GDTC4mK9+D67uFt0e1sDQ5N9r1uSShWCKlSrB1urcNuXujEi6i5MLVb9g4VzRsRQrzWlW+131ErutCdq17JxP1n9WjirDWWv/3vzmBsXw2IXffafSo82Im7wclPbxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785374672; c=relaxed/simple;
	bh=F/GN9Vw5jyHVRZzshn6T9qf+tbLSQIznFUDDUeVKcI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUFApT8v+mojGoeLtQeIESr6LGsqaAJlTuX+trHm6mbVdpEa6O6xImEsc9stJirhJ8k98NUUrKx4RwIKcYZpOSS4x4nqb03kv1pla9P9shvfFBy/zy8qvbfvuW7byYQQSWRsLxyjageY/LHRnhK8dqHkkSXD322w0qNcZfBDCnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CksDfOVw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RRFLsDQ+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CksDfOVw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RRFLsDQ+"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U1IFsF3305877
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HDnspEIVuTCXuRcKdi6kqP3UXQ4ZvcdlyKrCIK6R5R4=; b=CksDfOVwJKYmiLi7
	WXQMOfxd4DerIX60bdOoUREBACXhaSMVNLCPPhBTk/cdi+IcBDvQ7Fgh/Zya9ajK
	DlR1W+GhS8d1R8gpM1Kvmqf4FU2NV8AHUVFmr8z3/4e6dEpWA/MPhwDRTz2W24G0
	a1Mp530NJgryw+UET0gFI4fulfBmBprGhYf6C/8Zh/sD1O/CEwtQFmxTOcyhpiu7
	5ezksN/72IGIlgrfsdPyzHz/wOINZUVNcd1W4zG0nhWSoZhhORDHoWosKDSaTANp
	B58SsFmtIOtUQE4/VPqQF+9F9Imcs0weCVUwJ8G3R4Yj2Z8zFYYsyuxm1/5eXqB/
	K7pElw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqvu400je-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:24:30 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso2045033a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785374670; x=1785979470; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HDnspEIVuTCXuRcKdi6kqP3UXQ4ZvcdlyKrCIK6R5R4=;
        b=RRFLsDQ+qijUP7+tTDlnlU5Mxxh2pxo9niiraP6t//OxseMJs4Txyu7wVGlUd46OBs
         MnB+KT/77JSQnKMTdc0QlUDrhFrvAtrZg0rfXj9AuLU3wrYFkLWR7tkovr3cxlR/v7uZ
         b/jWI3aFrzu3RYjzL08r4tc/6iI2T2tJCLMA+Zu4wHRT55ZGSrDaONpqOSDr0IaEqLn+
         I54lBBM0kV6W9DhEWr067Yz0OG7H6riFsytRdmvtagOuD4wMDnESqjeK0Xe1+iMYIyWk
         h5KZXud9csXPtfNHNXdvf6Gq1UV5sVgyD+VKpkjkeZ3WWrfUdOiKIlz3n1bGvAq9OEJR
         ujPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785374670; x=1785979470;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HDnspEIVuTCXuRcKdi6kqP3UXQ4ZvcdlyKrCIK6R5R4=;
        b=f1b5nNlfDV0LGY0EcKGbi1tTly/jfnRuxfNHgI81xhoJC/wPy+1DsWYSwZMNgG1lUV
         pmQvdayTCYWJN44tYaxp53hOd1gaHlGLcwf/K5ipzRNrMzHTNX0lavHeWbDt6rhLAouY
         zHedAAu6sTgBOgqdngonIOv9fTmUEhdncji1JN/gPM5GFxuFXz3EJ9qe6aLfftmkEy8y
         DLC1j16a50ICxvS+hGQF8Wilth0nTPUwU3frC9ZqcvXc/7KXcp0zEVIo2mAErjhjbvX8
         3Q3K0bmniNNql9LU+Ga5lHVqBJ1+VMkUdN6DNYl62UuJ+9BSbYzLt5VS6kPhAcLMiMUa
         D2hg==
X-Gm-Message-State: AOJu0YzfX0fROlYdlAqH7G/xmLyoMwfpx2tK6K3GjRbg6NrMW7oWnLKx
	xk5mDG2MwcYp2zDbkebCmxpFRnlm66Yl+400MfU1qg6NcPI6SLbOia4uiQIUk0uan/S/B02XFzV
	ajVd9pkKx0RJBqrUYDxuOmfNzpsoP7bl71nKGvDEKCv/WLi7TKNF91vJtB8nkSNFgAuAxrmg+fs
	Axlg==
X-Gm-Gg: AR+sD13tBs2gkCPifOI0FHkgJY1Ae1k4hOc3jk3V/JHtNY5d3E/rB+2zx0FXlYFM2N4
	YjPiIYE4dgadRh336uRSqxKuHQnOXdMstIgtIiZNtsn8fKO6zxz5eGy1krYvnDsAB5DMbevc31V
	bAd66hoP7LbC+mu88KAP7BqFXglBpRv4uJOKKEgiwq3yu3jElldEwKhQm/aitrm4gUaFM9G+o2S
	IYqz10SKTIxfLy9xGW9ckJw3UBzNX5yoHiw+MJKmodMUnT+T66ATDl140UTX8clqsg4U+pgiBCt
	VFWIjXeZrwGLRnMb09PfYQ1Zk4jW4woNJGpXzRwoJTFhhfNKKsyRcSv7XLDSYE9BbyaVPsbu9s9
	FsNMJvgyQ2HpOlOqWKJ5vd+sJ8QdtVDzkGTXDZ9cRyoRGJXC52HarPzUuQA==
X-Received: by 2002:a05:6a20:1d98:b0:3c3:8d4c:668a with SMTP id adf61e73a8af0-3c90094c2b0mr423523637.75.1785374669996;
        Wed, 29 Jul 2026 18:24:29 -0700 (PDT)
X-Received: by 2002:a05:6a20:1d98:b0:3c3:8d4c:668a with SMTP id adf61e73a8af0-3c90094c2b0mr423501637.75.1785374669556;
        Wed, 29 Jul 2026 18:24:29 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7265010esm14721244c88.6.2026.07.29.18.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 18:24:28 -0700 (PDT)
Message-ID: <5ba0a5c3-7009-4e9f-b5b0-11ec79469451@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 18:24:27 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260729020005.219253-1-zhaojinming@uniontech.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729020005.219253-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAwNiBTYWx0ZWRfX/Et/X7QqLv5/
 zFuQeVoKn8g0MWjtjPaDZe5ATtx3WsrMPv/FEg/BmovcVrwvBiVeTaT2F3ucb/DBqlEmjGnmTF1
 Zb/gmEuDonQyY7Ry6O7clq3/wgfqO14PELQ2WeEBbPdwby6r01NOqtwQWzNm66iTUr0OHD8o/wD
 ubRSdfsgjmFp2HeJpTgnOTthbK5zHgNi9SfD7pcL/uz3170p0rVlpgvX0gA1L2Z+RjCeggAWnnd
 Iwola/qUGkeNt8NbHCkXa/LLyPzLS9odFl3TVtH1AOhyhdutAwjAb8kV8m+7L6LHiV2oW6PDnhh
 moY0JAWlfq7An2BmyKJPDwOYtl/rW3kBK8VCjwtDL1viyQmd4JT1bjOqxNrfkIDXxQ2Q5uEHR7C
 EIXpT6b3BJBzG01WVYDCI48YCaikC0N3a4LpH+QPt+7e8pzV2TWmU1Ek7qRFf6Je1saoEWTC9Vu
 6mrvBUK9mny9nAol+VQ==
X-Proofpoint-GUID: aNNDtLLVv0jdLUmjtFkudpwAAmbQyE-0
X-Authority-Analysis: v=2.4 cv=CMsamxrD c=1 sm=1 tr=0 ts=6a6aa7ce cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=3x75WggdeHjsNz2JpxQA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: aNNDtLLVv0jdLUmjtFkudpwAAmbQyE-0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAwNiBTYWx0ZWRfX2ABT2ssc4FlW
 zs9pCYyn/MRnx9KCWTpldxFMse0Op9QoUXiNpTSwlNCA6+bq8UX0HJLXwkvCXemfDbnMwUS1gar
 kyjY039AUqrPo5VGgAEtUivvMFxayso=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300006

On 7/28/2026 7:00 PM, ZhaoJinming wrote:
> In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
> returns the error immediately without freeing the CE IRQs that were
> successfully registered in previous loop iterations. The probe error
> path does not call ath11k_ahb_free_irq() either, so the previously
> registered CE IRQ handlers remain attached to the interrupt lines and
> are never released.
> 
> In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
> the error is only logged and the loop continues. The function then
> returns 0 indicating success, leaving the device in a partially
> configured state where some external IRQs are not registered. This
> causes enable_irq()/disable_irq()/free_irq() to be called on
> unregistered IRQs during runtime and remove/shutdown, triggering
> WARN_ON(!desc->action), and missing interrupt handlers lead to data
> loss.
> 
> Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
> function returns -ENOMEM without freeing the ext IRQs and napi_ndev
> that were successfully set up for earlier groups.
> 
> Fix all three issues: propagate the error up to the caller and unwind
> all successfully registered IRQs and allocated resources on failure.
> Also move ab->irq_num[irq_idx] assignment after request_irq() succeeds
> in the ext IRQ path to match the CE IRQ path and avoid storing a stale
> IRQ number on failure.
> 

Is there a reason you didn't carry forward Baochen's Reviewed-by: tag?

He first gave the the tag for v4

In v5 the code was unchanged, and Baochen commented:
I have given my Reviewed-by: tag in the v4 review. Since v5 is identical to v4
you should pick it.

once again:
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

v6 was a trivial change in code. If you had applied his Reviewed-by then I
would have maintained it for v6. if it had been a bigger diff then it might be
ok to drop the Reviewed-by, but you'd then want to mention that in the commit
history

v7 was unchanged from v6 so it should have had Baochen's RB.
code in v8 was unchanged from v7 so it should have had Baochen's RB.

This is another good reason to use b4 for patch maintenance.
"b4 trailers -u" will accumulate any tags and update your patch.

That is all advice for next time.

You don't need to post another version to pick up the RB tag.
Running b4 in maintainer mode will pick up the one I just added above.

Baochen, no need to re-review.
Ramesh, would like you to review.

/jeff


