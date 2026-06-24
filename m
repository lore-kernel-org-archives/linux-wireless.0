Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE6539903E
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 09:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293799; cv=none; b=FqfCq+Hxs/Q3bqYYP2C6E4KjZEOSvNt9gwQiB7TFPMD6mNBRWLXBNueDMy4HLSsc7AOTwLfD+PPuOu49ejvr5GKpvg/MqrTKYghcaSozJSPd3w6l0hthUnrKwtuG9jvZQoyYMH4KBamP4kH9pq+t5iapFfeY1Z/mf3hZ8myUXX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293799; c=relaxed/simple;
	bh=JTVEF7b4mxhKB39HdivuyGHBfDXZya3Ct+sE3geGK+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GYnUUwMXxh7sX4sMGTWFaI+iFYshlaCNnDCRDGYqI+fKssslvBn1rqeI0naIqfyFKHBFXfRICBAd9brl6RppDStdkoyt7GpRcWgyTqZT2ahoZ+Tweo2+1rqFOlobx+Reg0atqkyKaRNr237Rl5Lk1MLPIbGrx3MpU1TeuCmgUaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GPzJELee; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ao14qvCE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GPzJELee";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ao14qvCE"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65O7HpRq3753673
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 09:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ARBBHP/lX/obi2F3XxFDjHxjHM9YV/X3cKLW3oYFxOE=; b=GPzJELee/BlsJyCY
	W+Z2ZkGUHhWEcYGWxaIrzyh7XGqGV7/rrjvFMeFIjPv7YOR6uEKnDcn4LwQ0+qgr
	y323jo8TEfkavJG40siMgQET7MtCsjsJLxow/MP80rBZsacOClh/gyThsBNjNyDO
	xKrH5O5i17at37gr+hVn4rcWC2hyzRn7L/sVec4PPZ1qqfTkFESMI94I40x0RGmO
	5I/0tk1s4+X6O0gRkwYvKYA79ogQlagAeXUFG/78aRJB7uwHmMHQlsXhIW4T6pfN
	Adm3WmImHYeSVGoS0nyIIm47x2slm5ffQdqkPxrQKb5Y4Nknhz11YPN+pGKJiDbs
	n55uQQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f0aqp8gas-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 09:36:30 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36d992fa39eso1056893a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 02:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782293790; x=1782898590; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARBBHP/lX/obi2F3XxFDjHxjHM9YV/X3cKLW3oYFxOE=;
        b=Ao14qvCEzZCcCNVyH8HxqikaWetcD+D8Z1U0aw56Dliu6EYEOO27NCAmNtF1K5V9dP
         aZwP3K2n+8UxfNESwi+tU/dTn2kAxHa5G6XjMDhPLznqvxLGD46ySiaPyUMMcV9cER96
         cASpZCvORmDL555I27aYCysAoTBRMS46nYsKxH6uuuEDqtP5Xr/vanDVroHx5bU3mvBM
         vrqhu0up4u6sfAx8VTQBSO5ZoOBqUApuGo6JDa2myDOeJhDz6BTWLObaKV8iBbGfZdOI
         /pcaEkDbV6kr/syq2wtfdEp7U2KIiKkqu7Z81pIxbNx2ErR4xMx3EIvfh3MPEdRAv2DJ
         Uesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782293790; x=1782898590;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARBBHP/lX/obi2F3XxFDjHxjHM9YV/X3cKLW3oYFxOE=;
        b=WJU0OONOqjOfFvpFkqfAQHBm4zB0+lycP/VXqiNzAmGcobXsOaUDgoHBz1WH3vDDYV
         Vf7TYlz2+i6klBJemlFKasjdpED9CZeSapzBziqQic6tEl3oPabPEREWLRVJWYWrs1Og
         gayQ1W7vlQa/WMJVRwS0Mnnr9//D1QlrrchBCJQ/TI0OyJiIIz6+sm3k6rc68E/5DN4D
         1IvY7x9Of1ptPX1UHlnX7GKssFg+qSpij02IrwNZxWeQvXFs8+vgKeC2vXCKhFUvESvf
         Ec9+ov364oCC9v/P1pO02cPkiVmDcBV5waPb9Pk6bTJQWEK9N0e8vamqUZCQCrQ7+CjQ
         sOZw==
X-Gm-Message-State: AOJu0Yx4CCTioWeLIMxN6Fakp4WCcQKR5rNPllAoCpbaUcBVErk9Favw
	pOwy1KBsjsN2bhS/Yq5Onixk9TliSsceMM7CDXkrZUSQ3vTi+u3ajc2ymD53do6PGASuUrYPfal
	zw2Drqye73cVTep97ntekE9TBj76ia01JdH/Cb8Y7Lr4RXWSJNV5VsHoS0cmXk0oF/LZxww==
X-Gm-Gg: AfdE7ckEWJuYkESoQWjfHVH2alOBkqTJnlBVcRENpn1IaucIeq2v/4ulF5u4RiFdrNF
	sFhC7HAkzoH+pjD7cdNC/4k2/qBQzOtF4kKxoYTBCrJ3EmFXyyGRbcZcaFc1E/K576NZ2MTXfJU
	Kx4jXTj7baCVB+uRoGXcy4PxfMLKj/SW0Vjdt7V21srg+Eoy7DnI1tg1hUM+Gbs9sPVNyiAhBHW
	qwNxIG7a2YR9K8mPl9OIg7baOpoPdQGL6N+EnHdjwpuq5rhUlDemVToRch0lF6JFFXlEkaY7+9y
	VGTl1nSKWNX+q0XI1gZx2SeXI0imaxbG52mPe3HGoC0CzejP1Ru1kW90Wrw8m1w8uNB5iI/ntSN
	PIHW7ycP9HXg/aAYM0GqnyDkOeJbdQYEoJq1OujwL5dTH/HlpFCec1uj4tXOk38oSyqMmON/1/B
	NV9r3vCiTj
X-Received: by 2002:a17:90b:5405:b0:36b:3ecd:88d2 with SMTP id 98e67ed59e1d1-37dd0d0d8d1mr7786298a91.3.1782293790179;
        Wed, 24 Jun 2026 02:36:30 -0700 (PDT)
X-Received: by 2002:a17:90b:5405:b0:36b:3ecd:88d2 with SMTP id 98e67ed59e1d1-37dd0d0d8d1mr7786272a91.3.1782293789746;
        Wed, 24 Jun 2026 02:36:29 -0700 (PDT)
Received: from [10.133.33.165] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3ba11c0sm1963173a91.14.2026.06.24.02.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 02:36:29 -0700 (PDT)
Message-ID: <09a358fa-939d-4c1d-ab70-8d6e9fe7b18b@oss.qualcomm.com>
Date: Wed, 24 Jun 2026 17:36:26 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Fix inconsistencies in struct
 qmi_elem_info initializers
To: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260623-qmi-inconsistencies-v1-1-0fc17f2b8338@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260623-qmi-inconsistencies-v1-1-0fc17f2b8338@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: QEY52EZIE7DKwMPdUqGEoZOSOuElUzHv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDA3OSBTYWx0ZWRfX/kxktoeGt5KI
 7VS4X7VEJawVNOnbV5TZtxLcg9HMfjQUaObfnqW9qStzCMkayaaBgWW543RGOg+YuqR/MNb85LF
 mDWVnkgu7aPAnl3CimYjn5gByPWrakmnzT9RRGC48j4hM422Z89eyIoK6nMP9q7Myy3cjXon5TU
 Zn5w5hzaEKPvmuTBi+UMlGSGOaHranz9SZi5ZsErXqTqYApXtfXYlHQT/dI6aT/ZDq7vbpmFrmh
 BLp5sgt/Du2Aw2jB8xVumS3jbBtF10NzwNryKhAJctBjvgaFX4Au7im8QrQzl1gwFHDDfaAusNB
 RQDl8caTlCrYgr/a3pF1kOpMdXkXW7oO9ZT2LQMbzABqeUy9oW1OoQBg0JYMw1yuxZ5HfRwobY+
 J0ba0tlxcs62cVKxsDBmbNe5z4Dv3Q==
X-Authority-Analysis: v=2.4 cv=QLhYgALL c=1 sm=1 tr=0 ts=6a3ba51e cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=ZoZKXFMULng3zEwbkoQA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDA3OSBTYWx0ZWRfXzgkWtC45jSfj
 ZXBd4EjlFPmQKgxig2d55ywCK4azLZseKlav+bHVZOfltKJsAXeIOAAxyRsYMIRBjb0PsC5N3zJ
 G6Wzx+lK7VX8J96CksfaiXWN7mSJkdg=
X-Proofpoint-GUID: QEY52EZIE7DKwMPdUqGEoZOSOuElUzHv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_02,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606240079



On 6/23/2026 12:13 PM, Raj Kumar Bhagat wrote:
> Currently, the struct qmi_elem_info initializers in qmi.c are inconsistent
> in how they align the assignments, with tabs being used in the majority of
> places but spaces being used in some places. In those places replace the
> spaces with tabs for consistency.
> 
> Also fix incorrect and missing terminating records in the following
> qmi_elem_info initializers:
> - qmi_wlanfw_shadow_reg_cfg_s_v01_ei[]
> - qmi_wlanfw_mem_ready_ind_msg_v01_ei[]
> - qmi_wlanfw_fw_ready_ind_msg_v01_ei[]
> 
> Tested-on: Compile tested only.
> 
> Signed-off-by: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
