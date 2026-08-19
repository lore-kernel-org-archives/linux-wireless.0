Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929CF456E02
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787137426; cv=none; b=fVCyw1KFl6cwCnBM8n2T8UsV7B3kpzbU6mJRkOxpKta9PcmuPe7bHg4bNBVt5De6qBzmUludxEK+X5NiugUErJxlyJckw2rggKCTDhaMImhmWL3RSrdvgAkD2uQyU42GNBDjrhgynAVoSI/4cfWHMCP7O+VHI1xr/s7gnwt4mvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787137426; c=relaxed/simple;
	bh=kZApW+AD2JjiVX2PHeGiIrm3HQ2Z7DHfB6WMSwUA/+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJdJ/tXUwG82EM9qw/wVUl4gfR/Eu3H7DMROJ+s1JRwAu0CGtUh2UcR9HdvM61P5UQeYJGhP5PU5J8ovPWdyJ4AwxKYR6O1KqvP6bACq8RDAn+L7Qoq1QTbgX42xhjOLNW+DTT90LDxc3y16mt7HyBBlqjVGHUjUgQdnYzlpBAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T3bhPkxl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=USsPoTIZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T3bhPkxl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="USsPoTIZ"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JA87Lh4160918
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p4rGRVXIFEkP/eFGaEOLoP/WZecNrB0d3SfXEBkRIEA=; b=T3bhPkxlKYaFrpoR
	XxRnFXfG8v/FBPQaMhlKed2BwcNmT6vQqpkh7qJJY7FkF5465nW5u/0Y1PrvHGdS
	wbk6Y5osJyXrtsF261EQQAqs7MinIA6lq3n571NHwNaGYCaLXPLYZeIg45JOO+OF
	VeaxKySZa9mkUPf6bIS5r6Llu3MbKbi5dP02Z7+NzUOj/e9NhAf55xrsDE3Pm6gK
	aS8/z7bmMZsWY1XW5kw7tL2l1dt5zbWhdPD7hzzTdy88aj/FkdcqDPR5uqt6gMzb
	c8927nZqGcIZRwiBxopGXh28a+eWtb9rmf2cE7gFjMMuY3AZ2+v1uJ6yZpegX1Rt
	bi1K3g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfttvhn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:03:44 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ce8a76df2dso18457425ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 04:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787137424; x=1787742224; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p4rGRVXIFEkP/eFGaEOLoP/WZecNrB0d3SfXEBkRIEA=;
        b=USsPoTIZnNqTGTjCcfj7dzxTClPrWWx4eVsIbsNy33Y8AIPwyQfiZqZp/Ec5orluuP
         R9AXf74UxyACfDCaONxTpjmgS76SpxYYFONjRmZRGmJz9/TQvvk077SI0F3r7H1oi7ow
         9fF3jZD1JsSZlbDOkP4SvGMOy9QU0oEdJpOdzSVp1XnqawX7FRLBB8kVuQIS8E1A/SCA
         JHN7/dyU/RdFy4qajVPJ0CSlYBpIWlkukcG6/1OQe75iYplRK2d0sd82CH8/OpgQG+2L
         TNacn8+XiCYJJ5boo6Rg6LzB2o1H2n7vBmFwuSEyUTbGQWwA74K7dYdvWw7K14Dcd6sZ
         OD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787137424; x=1787742224;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p4rGRVXIFEkP/eFGaEOLoP/WZecNrB0d3SfXEBkRIEA=;
        b=XOEvNku4U28LqnyMjvalGC7TW09TjqiHwpaXsAWc1+Qk1+kLb9tRbWiOFjx3xa848x
         QyiKKM5apqUjghVAwecu4zRA2AP8tTGNvAX/c0f1GxNdAyMAG1aOvfmQb0WJqFvimFb2
         dzV6QdLlAOuPOdD/Lz2Cu3QH7EkDECWAGSJeypzW83MsQAIZ8m1eBa3mEy2bU/TxSgem
         bCZgCz3oGdsMjZ2yAi8/M+jhOnR2hn3gjl05CZJRyNLQXzKofJuijqIPwhty+8euYclx
         evwEVqmnUtqv6y4DhxNLn5rqj4wjZt4/SQh0MyftufwaRA2rRM8ktjbDfInc8T8C9jsl
         PBPA==
X-Gm-Message-State: AFuF++mH12O9TDOA6MOhFWtdqUhTEDUSmOHtysBWg/tbeC5SPwi5+T11
	B6jIHkRn5NNYIqhvv+EIvZfGA91lwp/P3DMQ5hEnyuEp6nNAqYunuGB034vsk+G6mTLKlZwAuT1
	pSOrPHg1EnekGpZYm88fgUEY5EhG2m6j1MLrmx7E579SgggklEBAoarmfrWi3dCN569/2YQ==
X-Gm-Gg: AR+sD11a0LEKa8qiqtwpsC6kLAbmvLuaq1sI1OD5wFMD9hnxWdTtGCInOkyNlCmVNEZ
	5663SfTeYdBk2bFdErdIgPEmUiFRbScQ8sPth834FTNbvbug35fawUlJDvIMYOubLJL6TMSFucL
	LoS5rEuITr3Uo7bs2e3rwLTZh39+oYnbiedRrP1bomN10Ng2nqyNRWaqCECjCG+maKuPdwHGGL/
	8oNs5mR+VBVaXJCrc1d7RoWzzq6F/WFf4cQfTgg+Ua7HWqRpkQDxQIJKJGfqpREKdRyv80ysq6Q
	zhf/xX7lLCNJVjDsuOlEnQOXSyWP87qDonxTBeVNIUxx973b/pACVOQq1Ankmfb8kpmhVgUOJGP
	NO4AsGIqDDERsRljzvj8BZFyd4i3SK9o9aUoQBzWFZgCO+fS4KKXK9247M82HOFDsFlfRxJGAPw
	==
X-Received: by 2002:a17:902:e949:b0:2cc:f5b8:4c2e with SMTP id d9443c01a7336-2d601468c49mr75918175ad.9.1787137423855;
        Wed, 19 Aug 2026 04:03:43 -0700 (PDT)
X-Received: by 2002:a17:902:e949:b0:2cc:f5b8:4c2e with SMTP id d9443c01a7336-2d601468c49mr75917245ad.9.1787137423415;
        Wed, 19 Aug 2026 04:03:43 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5bb51e0e5sm25564745ad.32.2026.08.19.04.03.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 04:03:43 -0700 (PDT)
Message-ID: <cb770572-c837-4431-a6dd-d23b3a59f352@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 19:03:39 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath11k: fix reg_info_store leak in
 ath11k_service_ready_ext_event()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260817-reg_info_store-leak-v1-1-77025a99b074@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260817-reg_info_store-leak-v1-1-77025a99b074@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=FIorAeos c=1 sm=1 tr=0 ts=6a858d90 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=kraVzMtvL2C5sCo40MEA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA4NSBTYWx0ZWRfX0usD66DU2O/l
 5QfajCTfwey4LV4qGHXbubcPdMiJ7XgpJW0FyDw1kHswlijg3UQZWqErtEb5MPcjzpGmNlBspTE
 D1A9ZjiZd67zUC1r2rsqhiJRET2p8v0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA4NSBTYWx0ZWRfX5lN9bvHnIbnV
 BC1uv9+aTKqmvAz7Eshy8kJd0DK5fHrTcWGhBP8xoQ0vIah9caQL/C4m007jLbOqrzxzNjJKK2Z
 uzpMdHqJHEttydL6TssVw3CpnrbTue4vs/l9i/pZx/vrc4o3KQkAa4R0Lspcg5VEMhZNW04acfC
 vTk/MA+tMh+yrELqb7JRZfY4NNNIGAdpIEyJVyYC4UzV7UTZxR3SY36V3tuU/k/0Lbwyb2WzKHK
 /AMZ9c7r57f3kgn66FOFc2XPumAcKkzDJCADJxARsmxDDJK6Fh41vXCp3bbEvq5PY/+h79QMOWV
 x1i1wh07Sm/UBHBRr2uPsui26wjM6Nf5s4igIxIAQBoyjD3um677j3fnFUoMLMshmiSDcMlycpK
 a3fH4UuC7qemNDq1wKDB/zCzzcy+wsTnRy/BKMf+2G09yuhlWRfvD2OqFh318XCH1fUjeXrVXcV
 naqDbX2bJ8CdpMRSJlA==
X-Proofpoint-GUID: zy-aGyIwag1Zt0Oji9LyNf1J3XtphsAw
X-Proofpoint-ORIG-GUID: zy-aGyIwag1Zt0Oji9LyNf1J3XtphsAw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190085



On 8/18/2026 7:46 AM, Jeff Johnson wrote:
> Currently, while processing the WMI Service Ready Ext event, the iterator
> in ath11k_service_ready_ext_event() can dispatch the HAL Regulatory
> Capabilities handler ath11k_wmi_tlv_ext_soc_hal_reg_caps_parse() which can
> allocate ab->reg_info_store.
> 
> If a subsequent failure occurs during iteration, the ab->reg_info_store
> allocation is leaked.
> 
> Directly free and clear the pointer on the error path.
> 
> Note that the normal cleanup function ath11k_reg_free() cannot be used
> since other regulatory-related fields are not yet populated at this point.
> 
> Compile tested only.
> 
> Fixes: 7004bdceef60 ("wifi: ath11k: store cur_regulatory_info for each radio")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

