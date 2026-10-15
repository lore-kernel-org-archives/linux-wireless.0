Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BC64A6CFA
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050876; cv=none; b=cCEXSGf5NEstJWLhA8ZKx+lz/TmAzvvnD1TKI+gcMERq0efzEdLeIymQt0XYMvTSjbvNMjwLaKiYQOhOLq9ijQdtvkMfnpLqjpNl77oQZ6OPxTRfq3KrJuJxsq21/dyBfat5iUj+R+TOhckwZByVxaOKLcbyX3RW9FihwbVjbEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050876; c=relaxed/simple;
	bh=hVteIZnn/KZGhwyV6npF3HFMEF8PGQ8W2HWu0o+zPKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aftpDLB5ulWXxW8kKWYuhKSZB+TlcJXNU1onGqtRgsJwAvnGHmOP28m/zy3D97tX7Gd4gfQ3NUMVQW2Tzyi6vU8mbMg8beWx7Ki2n/4XgDZZQEov2ujkAgojL87CIrbjMgjLb3SQYKzeyrOw7L7Am0EgcR5qOWFgvHM8t1Y0juk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BUOJCsjs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Px6kr8sV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BUOJCsjs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Px6kr8sV"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F6Orq3644679
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1dJSG07GXyGKGiQW7TmuVDezgqv6wfOW05ypU5gMGE0=; b=BUOJCsjsIAqYjHJI
	AF3wypISTszN5hD+N7W+fcozerWK14lPAXXETxlWb11U5SEVyHO/pcaU2dDcBtfb
	L//nsOQN1X4j1tSgtPbLKcSMbS1eg1p6CmFKJ9BgZ8SgrbHrqEGovvgNS0GszWZW
	K/jrfOmXFu0hg6JvTfXD64s5h9xg7X6BNtG346VVjeHhYMIrUJEsoP0JwsITp6xi
	9tha3OXTg8lKiWDA/TM4hikFaMe2MZKqZ/F4uPgLGVnMRmgtG/JoPRpCQ1uIY+IS
	hIKCshKsh179sXkZwBMGuPNbFnNziTtXIEWzd+R+CkWS9PncY10GOsjoq/BMKATA
	bkP3BA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hajmy9txn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:54:32 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e818ca61bfso17800515ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 00:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792050872; x=1792655672; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1dJSG07GXyGKGiQW7TmuVDezgqv6wfOW05ypU5gMGE0=;
        b=Px6kr8sV6z102UhliOUl1fkIIc3wG4qP3hgJ6F1jlXuAmTidRVyHCDFNdgVX7jXp3R
         zpwXHLHpI7dueHMxIS89d2DM0BunsrrVgN+6oGFydby0wcUGxy0k+JlVnZWEZsub46KA
         FufB/pzHmNKnQ+MUTgSU9598rS8yY+Q54IRvw2U91U4mku0Oy7SEBABjkisYndGsxOGt
         GcJ/Qfm1zI+QszJng9ndGhSPcslj15u6vS8VL3pJRgwa7po4eiixcuvI5+ip7+bMoSW7
         dYN9epv7O4n6nh2qXUSeViEsSwL50Wn40EkFRHGrDKvVFEZtC9xJYclMmBT1sW2JnNK8
         PGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792050872; x=1792655672;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1dJSG07GXyGKGiQW7TmuVDezgqv6wfOW05ypU5gMGE0=;
        b=IXrY/6dJAbRPh+Nmz68T3yH/YsOGndNRTDCGek8+dY81MDEY9iMaY+m6UoKXpF2pZQ
         jsm4PmvimBXB1sXmNBhiN9NEcwOHPBkz5LeiAIKhIHs6WnCmWLEtPNy3w4gvfcNWQVjC
         f7OmWYPk5+thKrPqVaVBW9IOilms0oFoNCb6CkC5xO2A/K+zyvMe0T/exhrnGi9NyyCA
         Fa/MHwHMY/+EwrRfqziDH2iglnwirJejQuQJ3edDPpMh31e5e0FxJSwi2IXXRnXYNq/U
         gr3uSFjeMq7fEFRoAwss6bRbQlx4pXgtmAPLx+pC6QKJYjg++5Usp2tlUqiXc4kYi+29
         AuIg==
X-Forwarded-Encrypted: i=1; AKwUvBwFreL1iHurJpZXQW68fmjQ+PRcdXkWI5QgtOLVVwoDXW+5+4NLdBjiH2Xwa0eqXArX3kMFAHPSpiy4XSjIGg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIzBXP4J5TH0xMEW6K09my4AW1JnaJC1Z/gW2VpmxcenLQF6ObV
	m3hEmIhj3NUd/TGljH7mFXltFd6B5ToQNdmk3j8FSU1Gpwd6RjWi2hHru7Ez4YfjC/YX6yXrlhR
	sU1iFt//i4cmIdZMNkHGIGMLwnHqD/wxD+kq2QZtX7x7VqLRCe4yqvAe5atdECeduYfA7JQ==
X-Gm-Gg: AYBFou1spaLfowsUfghU7MMKJt3t4rxdSRaVUcEfUWQBD/APROX8LxMRr5SmSXDcOUJ
	M23ghWnpK0Kmq5BYRzOvB0oYqHbTlNOsuZDX9PqdPbhzr8EGwUALHiVmv1F/ZkGxzNHNw0BQ/rt
	PQv5fREWJmISGf765i7vPcNqZtSklXDLmhEdQREhZsB9gK8+BlXCVAIMLzt+90GkuHI5RDTv6rG
	Wep1qGz+FZLS7vcjbpUg0h1fza0EPoyGhInXClPSecF+Zds9IvPDdcC8mJd9UAqpuiyVjKKxVAG
	hACco4tLf1FB/kIw+pHfYXlVpPB80bGiQk1FWcrb3oFG3bl7pSiaWlNsA3zV5hnLuCddOOivCUy
	5cjVPkyBVWKRiNxZdcj7f9HPqJ3B8TU8zIiThhIp9U4rDvAsNsHZQiswh0lqe3PPoBEDFxbbC
X-Received: by 2002:a17:903:110e:b0:2e9:2a1a:8b69 with SMTP id d9443c01a7336-2e92a1a8ba7mr57665865ad.55.1792050871818;
        Thu, 15 Oct 2026 00:54:31 -0700 (PDT)
X-Received: by 2002:a17:903:110e:b0:2e9:2a1a:8b69 with SMTP id d9443c01a7336-2e92a1a8ba7mr57665605ad.55.1792050871349;
        Thu, 15 Oct 2026 00:54:31 -0700 (PDT)
Received: from [10.133.33.32] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b8cc1sm76306455ad.54.2026.10.15.00.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 00:54:30 -0700 (PDT)
Message-ID: <56832d7b-e7a1-49c6-8995-4b17a442e4e6@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 15:54:25 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] Enable Qualcomm WiFi PCIe passthrough to VMs
To: Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, alex@shazbot.org,
        bhelgaas@google.com, jjohnson@kernel.org, johannes@sipsolutions.net,
        mani@kernel.org, yishaih@nvidia.com, skolothumtho@nvidia.com,
        kevin.tian@intel.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
References: <20261011074514.515894-1-jtornosm@redhat.com>
 <b1a3f755-19e3-407e-b8f8-b494de83f59a@oss.qualcomm.com>
 <20261012144835.GG14213@ziepe.ca>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261012144835.GG14213@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 99wBzfTC0yhvUjVx5yBOXdB6EUl_h415
X-Proofpoint-ORIG-GUID: 99wBzfTC0yhvUjVx5yBOXdB6EUl_h415
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAzMSBTYWx0ZWRfX1UQF/Qcea4e4
 eiz/CNWhM6Vc/sC9oQJ72F8Ql4zpGM8ohtu9i7mJzZkVwUyRub3NzaKIJg0AdvbobWvBuhqZ73q
 SQScE+Vy2RB6xk4u15ZkACriAxu9/jo=
X-Authority-Analysis: v=2.4 cv=TbQDJhQh c=1 sm=1 tr=0 ts=6ad086b8 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=n56IT1IzDtYYEsRGsiEA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAzMSBTYWx0ZWRfX4Mpn4B2RS779
 Vx5+MIoyFA5FLGEPV/TfbsclcT6U4iisC1WIYMkK8eBLOFQ2fI1Vl0ybsyrMD6DVkhCbdmvOOjm
 W4b8oAamaj+92IVy9v1JfFwnO3wfAhwb4oWFiNQr2db4P1+86ZaDEiWAvfLqsiFloPEqQoGH3Uj
 7f3dsNOdMu4eTOpaRvs8jtseqzyiJhG1e8xWL2EFPb1pRZWnqFPDLK1pDmgHbObiL9kMKU14q/Y
 fRuF5sttv9Md+yEb21MwWG5GtqAy/0oquDTVmP6DdBDTuNe+lhHj/11rNA0l8a3jcSC4CUVwRpk
 q+j0cP6uPh8y9IxXU+Ypof4dLQYI6GADt7qwhyHDM6tLEOx1n7SfG/R1HMzIZZs8YZdJHbkUB1w
 o8LXv0n7SLO5mA+w0nCYi8vV/Z+3ze0ON+EcHFenTt9II84MCM4jHSY7SXDFGrBcNBTDMsyt2jp
 PjxkzQQBlfCB3SUoUNA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150031



On 10/12/2026 10:48 PM, Jason Gunthorpe wrote:
> On Sun, Oct 11, 2026 at 11:22:26AM -0700, Jeff Johnson wrote:
> 
>> Thank you for providing this level of detail in your cover letter. I've raised
>> this issue with the engineering team in the past, but I've once again raised
>> the issue with your in-depth analysis.
> 
> The main issue here is the driver can't use a normal MSI-X in the
> normal MSI-X table.

to be accurate, it is MSI :)

> 
> "private" MSI registers don't work for virtualization.
> 
> Jason

