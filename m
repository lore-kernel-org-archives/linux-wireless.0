Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132D38A70C
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976670; cv=none; b=pb4RzyYZnwIeA5570JkCiV3unE72bCwghAcMCCX+BFTR2CC/rIh013sq0mf7ApASpGady+hY0OK8Kqgv7v8Mp4cbMIFee3ON29ItnhRUzsXXsBrCcRoe1MM8lXW380MiQYFzVBEiFXGm8CN6ziHtteK1zxzlssJ5gEmU+vlo5s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976670; c=relaxed/simple;
	bh=sEycOUox/G4VW8hl6l4S8b1UlJZdkFbYttplnGw7kpI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IMqi45p2cz6qr1AMjPSmM7KS353iEHlWOZIr7u0chMGsdrDfnZey0k31UCXxt+GBSWkJCTN95Frtlq7yvFAhBT6GbLJlg4LYwUa3tNGGdfT9l8Knzx/kqN1vT2ErY6vQJeLM61dt+Zdsn9QcEph1x1mxuZ+q8OPXWkVY8iwcvf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ONFq13vz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RuvjPlN+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ONFq13vz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RuvjPlN+"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H7Fxh3412136
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	H71H+XVmzymD4EyDuwymxNabVhGvupGLJtZG1omyyrM=; b=ONFq13vz3JlQZIjT
	ilRqOVr831QVhWXAkb4wmm+0ue1jfvII0nUjOYbXUEryu0tOrSuAb2AndctpWPnK
	LpDDk77ENGceGwZUPxHloOLXmsjk1LyxWYpM4pi6pSVBKpiAxYhbvLjiJFXJNvlP
	YrcsgcaDluH6S9W+xnUEhGB93NSMmeREXSn6cYU19/M55LYQjijGr4S66kr/x1n6
	e5o0ovWoRo6wkG1PO9kul3c36y21334wMTRZfh9hTMTxWKuns7awEO85LzJFC8TD
	HuYKP6fClpDt5n4YArI96ODY1Fw2VtjUYgE6Vn7Lw26NQnKHOTQRwm2lgev6bsrx
	GiMhmg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk6xh1rdr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:47 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39906175917so7455665a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976667; x=1789581467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H71H+XVmzymD4EyDuwymxNabVhGvupGLJtZG1omyyrM=;
        b=RuvjPlN+5LUzm2+V9St0alJTR2fFcAshsuxdtpC9EQpvnOYkrfLMQnLzYylFHGCrlu
         SKp7oa6K/JGv6jD4XV61HKibaio8hEF+8L+N6008esl3tuvpeVx1mhmryDqfmnA/NAXZ
         Vmg1SC/okjuguxI1iaIgZx2/PhHbJG6CHyHPJ8aFjy3n1tStFXoax4UQQ4sQY481Aoa/
         KtU9VVjKnnY3+/uPApzim364sP9/wcYUTUnbpa8iMbPH4WEx2x5zyN7laRUhmmFKbkoS
         sDMdNQxenxwasFlWbpKf7NSIIOCrJQin4Dugs3lfDLA96UbBhusDkknpISz62wNkJUOz
         WYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976667; x=1789581467;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H71H+XVmzymD4EyDuwymxNabVhGvupGLJtZG1omyyrM=;
        b=Elh8xtYKxUiPqBYS/63kiAFh+hQBHfkVJj+C0zFZuvL0diylGOeQwuBTWcRAmogdZN
         D4rSuWRU0OyadUJmtu1PAuvQoq4N6QSEEGQzqcKFOVS99gygweN9kd01+JLqn3EPddQw
         5V2j5IiB3i7MGTh1YPcUvCfuaa6ksX/CvLdRn7KhxJCQ6De5Md+vRLH3R+XttXNoLADG
         vpxULOfAkTGGEp7yjRa2ZU6sPKnfItlFofOhUESLahQMNyG0nuWFVSdR+Ic7kos6dPzi
         FAPQBC8Viy1XvKdsjcP/QMRoQLUQWjhGUH7uqgk8d6v3G8Ad2F9sN9hKypVkSd+YZjcT
         UgaQ==
X-Gm-Message-State: AFuF++mcijbZep2aVrbUk4Peb4d1jloxc5vTJ5ePgsEvJI6nQgrRg+GO
	5KRQjldcyJcrv/u/FcVrQrKH4Klr5kIb9OY8Y1YFo3/ukqRj1W/Tw8ZD9DqLpwVHUX8af8PVme1
	0echodLVi2dPgu0JFQ4ZJ08s/ioTsLkMXmh6C7AkUfFUQ0MYZhEgQxwrc+c5hUEXIg7flDA==
X-Gm-Gg: AYBFou1BHiiVTOjeSlbybxv2HV5+SWPEX8bSf2Kqz+q1IEkgG8/HQeSYZCs90XXI45b
	rNK+KhoRuCNc55T1EKpiUdtj1K10Fl7AcGNOVfk8qUe0nxQiPwLMJU3sADTlNbUK9QI9lWFGWVb
	2PrE9Ou/Reff0v+PiErqzRWCKCuTXygEKw8+xH1gd62njz52bqMN1GOtGHxvUWa17GgcYEuLvZ8
	NN8cciPRdl+1D737iYcSgVLkvROH5Xa5BE+2lt8E36/9zwoYPkYtt5tVqoVgf+tq7VreXodObp+
	zMsWAFPHPNbhXgT2vMZ26iPl5IIwWiT3FDkmHtmqjH6Ss7GDRoJDbrMLj4UfV0tYLKSYtseXoci
	Ks17hpNB0wAV8hWR2x30y3Jmxg3bvHRbNsk4K5ZHCxQVhWqiTmw132gg=
X-Received: by 2002:a17:90b:560e:b0:38e:2e86:ed02 with SMTP id 98e67ed59e1d1-39b261e7931mr56241863a91.14.1788976665384;
        Wed, 09 Sep 2026 10:57:45 -0700 (PDT)
X-Received: by 2002:a17:90b:560e:b0:38e:2e86:ed02 with SMTP id 98e67ed59e1d1-39b261e7931mr56241776a91.14.1788976664895;
        Wed, 09 Sep 2026 10:57:44 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:43 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260819-ath12k-cleanup-userspace-types-v1-1-161a1e8910f5@oss.qualcomm.com>
References: <20260819-ath12k-cleanup-userspace-types-v1-1-161a1e8910f5@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: use kernel types instead of
 userspace stdint types
Message-Id: <178897666372.2048605.5251378053771622917.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:43 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXyqtj9Q1HpWWm
 RnQRHSj1sUj8l0/WWVNLOrLynUr0NynTl+XnYEkObK7qG5YqVTQu8vnYpNg1Qu+fPQ4sflbeRo1
 bSSk1lG92XtAKHsL1SB5Iyxzd6dbs7Jymv+/8O+oQE9yKHvpSOwvPPWauv6orbhYVNYvbhUOk0Z
 lzNE/8Eb8A9MMlnjrYohFCgIdkbv0LSC2cVhO0Gd77kRwnIDg1+3X3QwUl6YPkFjnewFnThs0uO
 47w5LBmemEJoPSuB6uoE/W0nC8aVCLrjov4jiklb+tmXJz67G2/71w8sg5V1mUT/YT6ZfHbjn0W
 Q8fIydu4QyLzpGMbCQwc3Nwx7qzM22nWlAGXn7IfjAJrc35YcWEp3yIg9TCeXc/6UgXG4EBzkEk
 q4BoWLB7f7RGvbcAAy1RIJj241jA7FiLY3Jrk5wJ/CSsjoQUTM2IWv4kDCfE0FG4n9cuECMQXTp
 aEPI6i8X7BT5HG9di0w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX5EHiQfnGNbJM
 2IqDvALHO8iBateNRfnq4/3tOao0e+VKAW5Q9GNaaHULSlZxmknAMDLIYNi7tFEqiMuOQpuXHiy
 b4Yv+w31s6eAJfWPOun5YmvK0wkHhXg=
X-Proofpoint-GUID: b3jssiC3GdvV6XbH3_1-4wMA9ozmvtml
X-Authority-Analysis: v=2.4 cv=KOlqylFo c=1 sm=1 tr=0 ts=6aa19e1b cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=S76r9hedyb03ojg00oMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: b3jssiC3GdvV6XbH3_1-4wMA9ozmvtml
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Wed, 19 Aug 2026 09:43:16 +0800, Baochen Qiang wrote:
> Replace the userspace stdint types uint64_t/uint8_t with the kernel
> types u64/u8 to conform to the surrounding ath12k code, which uses the
> kernel types everywhere else.
> 
> No functional changes, compile tested only.
> 
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: use kernel types instead of userspace stdint types
      commit: 958287de1c1e373e634a5751d74e94bb0ad94ad1

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

