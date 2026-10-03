Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9BDE54B
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 22:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067778; cv=none; b=ezae1hvFqGBqjN3+hw4OVc92y/w/ceGGLKEteE/xqEGgsdn5JrXZRkbrcBd4L0PC+V0YWzLStVLgr8YeMXh8a22pDfJ7TpshOJKu1B1qCFFRJVT/9B7mtwyOw5qRoiGx3DEzvFgkMvXh/2x80wDjJ96XCP1MnLVHK/pUE2cnVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067778; c=relaxed/simple;
	bh=hu+6MDsGqbd0/MiGYmU6CU8Kd3A8WeGRoQJwcWVTBog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VNKYxTm2JrY1GiLptAjQkRlcORrPk5JMv0WzHI8rHuNvN2FZm9f3/neT1cnCglTNmDp1divbgbCqbGO19Eo3O2swDEnMJw+8zwtN0tlo0koXhbyrW7bimeblv4XmMOjSP4SaZWwFeboq0Nxho6v03/vuK/b1fHRz9aUjycEEDbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZKrDXqAa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CURWDlzg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZKrDXqAa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CURWDlzg"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 693Kokq5675147
	for <linux-wireless@vger.kernel.org>; Sat, 3 Oct 2026 22:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jmnKT1nfy8Qs6HY9rdQkeG88zwPq06mQnK6CAbht2QY=; b=ZKrDXqAa6O/gLaJP
	r9fPyjhm8Ontq5NzMIsIkbwhslqea+GeA9aIfltbYndO7Il8eFgmpS5FNyL89FNU
	za94oqCEwoiuJvEJ4tLH3fej/7xHsSJHt8cRokvDpeE6qHE/MielY/8mQhPcJc46
	zqNwy7bJ7saC9imDDgTcrvnGWA9SZB8e68UWce7U+HZVLS3u7zaU0AABf+aF19gH
	365XdWITODhSOworDNbpNdva8woeD2XcJGeCyE++ji046PUr/Bn0s82lzZkz19wK
	hqV3DS38fJxVhL/SmUq1YRqGkwwjmWeiFWBfuzMSfIOVd6UKtl0NmWAuKuXWHtl9
	hiopkw==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h2tfd9vp5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 22:49:36 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-150efa76c57so754128c88.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 15:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791067776; x=1791672576; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jmnKT1nfy8Qs6HY9rdQkeG88zwPq06mQnK6CAbht2QY=;
        b=CURWDlzgl0cGdvA7zW9Fw0sCgu5S4yPrbhav48feCaHuZFSoW/ah2+CEQSEGNko/aq
         Atjg9YX7sX+DKA6i6Es3W1PBnpHlmRndTJe5C93+y3OaPA7y+5tqzxrpdZ0vimghNqLq
         IRNAh6EB8eHIQWKCEZwyxJWJ8o4N0shNl/yDvdo/FwCDJU+boOkoVmA9MZ++K+k4kRju
         lDw25+13eucbvIzHq81dEADLV6BLwdRoNCQoYTO3WU/mdq3DKMb0sWZfEDGAP0zz6plT
         IhLwTt8AlWlF0iOvKgI0jFQD0+YgEyHJdHrONm8zypRLZ+ZRd66FfMOFrLp1+roO/4vW
         zw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791067776; x=1791672576;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jmnKT1nfy8Qs6HY9rdQkeG88zwPq06mQnK6CAbht2QY=;
        b=0ZfmEM61G7bxZCAf2pao6B4/i12Jlm5VGtX56XcK+wzshf/smH2ssFeG+6rUooz0rt
         CbooVaQDaBRdk31hlCFjYSRUsFQQWFk1tCbhT6nIbBUJTOA9YP7b36Pf1IqGuQ2543hn
         FTzvdxC8Ie+o8jXunKkbtI+VA9XGk9rBVlEbKt3jYqKSkDFNN3y3enVQZcfoRaTV9NBA
         6m89SGzJSwICf/lLcYwVmoBOL9/PxRXCakjL6YdHVrhkUNH8qdjIoZQ70tN+/3l+w8hF
         eBHIDxXYIc/FqN/wqv7m2Y6WedaaH5PEmgLqiMNwc7k8RHdVmfXBVSgg83AfWTOpmLrF
         jDeg==
X-Gm-Message-State: AFuF++kjTROT7qJF4JqsL3tOijzIHJyAp5AnXVq/u5IzkYViaFinE+ek
	AB5qWjwsgVYcOTFXGPWzdEhA7bJCcO2GsOcPG418DYJe4EhnHGTHPblgGQPXQvgt8aYOAZAKP63
	rAiMxwHtLCc5m+GVE3k3AePCYVsWN3JrYGzn8VZfg3+jfwmU3VtxWgNdxlxA6zyGKROwzofALre
	+sXQ==
X-Gm-Gg: AYBFou3famLrABcpkyLZINzY9+4Bj+T9T9kT5jb2QjlBT9/jeGD0R9WPKqy9MqtqFZU
	nE+PgqYcQaB1dH06qAIlNIHhKDmZXIaMO4lOAvpuWjhiMdzJIPr5wRsCTwE7RFJUm4I5SH5lice
	96nAhr1yNZCmYmuXzkojDJHjMcFi9x3BNWz/5hXErDT+k/wSUGahsblx+981CT/eAD5MIYaFAF8
	dHrTzY/Sulw4Jnsivns1/qaxCMW6rcN3vs6iCLFBwFpYUaA1wFuNqm6oCX/SogxxwprBWAGVUpJ
	4lyrMN3dv3DcA+irNx79zK0c59tsZrBeALlJxV9JbfGGAR2VTiJZHHkLRZE811ZbkWUMjSOL48O
	TOqYHA7ueCKvD6T21CWlTJvnQ/nsjgtormwamNYbDP801j9RteOqfWGaHbw==
X-Received: by 2002:a05:7022:7e8c:b0:151:94a6:6f5f with SMTP id a92af1059eb24-151c2b16e7cmr4783137c88.10.1791067775800;
        Sat, 03 Oct 2026 15:49:35 -0700 (PDT)
X-Received: by 2002:a05:7022:7e8c:b0:151:94a6:6f5f with SMTP id a92af1059eb24-151c2b16e7cmr4783109c88.10.1791067775078;
        Sat, 03 Oct 2026 15:49:35 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35105835bf8sm17010560eec.9.2026.10.03.15.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 15:49:34 -0700 (PDT)
Message-ID: <1ec8a2b9-7855-49d5-9ef1-018aeb3ead01@oss.qualcomm.com>
Date: Sat, 3 Oct 2026 15:49:33 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] wifi: carl9170: NUL terminate string in debugfs
To: Dan Carpenter <error27@gmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <cover.1790839793.git.error27@gmail.com>
 <674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=LroHWXdc c=1 sm=1 tr=0 ts=6ac18680 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=cNYCaAY9Ej7UEau_2mMA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-GUID: 2h3JI6DRXdZQ86c5N5cbBDSIfPHZCbiw
X-Proofpoint-ORIG-GUID: 2h3JI6DRXdZQ86c5N5cbBDSIfPHZCbiw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAzMDA5MCBTYWx0ZWRfX0H+xJLQq+Ttk
 DGpHgonHwSctE15t93iJqLvASm77L97hCTn11K/gfZZRoA3XCkM6v09xEvvJRNZy59qc0Cqq7K0
 Sh/aDIuvLkTDPIyvXGMRnn25F7Rjb8Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAzMDA5MCBTYWx0ZWRfX43nnIXzQKAxD
 Rui8SJok2xybk+WxZbGp34VeIL/CgkY/mQy5GaES91gEu7HdE14TTJRLfFh591NCNtQbpLOb1nS
 i2y++tHjve8rIHe3D6aovkXH8rSEgTymE2CcagT8oVxKZz9WJddFIrUSiQSg+899/CZZMVQoC+K
 9ErfXl/re0Uu91z4OvFTvE1IeP33IAfX3ygzuCcZaBsY+Q5+rG0DkkIetb8AFdqJNGewxXhV41d
 WREGsVgfBXgJa2RsdFJbYczRduviZoS0nmLR693b3S29awQI0wjGFnIVvR62FOuau8Jo3rsIBbn
 /dT4pewmI8J39xe8nWcnTLns4aVwFlRF+RJRBS558Qz3GiF9pAgE7vERpNk2bbZNjyImIhK9Byu
 mkpbZrjKRXtn13nQhd9mI8gtoj5Z+prRsVSgWWdTv4uoHCgIr/rq+FdWfgmzxfmwaQU54bf6Avn
 ofaoq1drPeMrDvqO/nQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-03_04,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610030090

On 10/1/2026 12:37 AM, Dan Carpenter wrote:
> The "buf" buffer comes from the user.  We use it to store a number or
> two so it doesn't need to be large.  It gets passed to sscanf() in the
> write functions such as carl9170_debugfs_erp_write().  Ensure that
> buffer is NUL terminated.
> 
> This is debugfs so it's root only.
> 
> Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Johannes, since the other two in the series go through your tree, you might as
well take all three. I've assigned this one to you in patchwork.

Acked-by: Jeff Johnson <jjohnson@kernel.org>

