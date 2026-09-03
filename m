Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2CB3B2FF9
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462167; cv=none; b=EAhve9z/MbA8ZKw/jdxWFz+xORiwbL3FVyZm/QMRFXtM1g20yqBtNyRTi2VAkWuqo0qNEQ/k9YsmBQ9HBGTWk7iSgIQq6F3eCiBEH7PcOBJkjTLZ6Vgp5imphH0kBihHIJhe9BzX9XgmZ4U7BUYx82dB6AuMx2RAxz/xWjjCBVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462167; c=relaxed/simple;
	bh=KsSzZJoUo3eRJL+QMF1QT1S6rvVdOYkCPLndC+Wx3Rc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=onUQS682RUCAHmQt8m1OvhtlpyydaAh8YF3fm6CKhMBFkjkzSK6W8b0+u6CThSPCLm3M3v0USfCKlTyJQrcI+grRwAatdqabj+Qcup4UHfRWBJnuJZqF8hItWGe+eI/v0zNTqELhdVLMg8r0Lh3wOyESW34GWk14SfNYOBqnt2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U+fKCQI5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FM+ZdzUo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U+fKCQI5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FM+ZdzUo"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G3ceD820082
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 19:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wWafkb7CS909dTCbVmWblMfgmqDyzgj5Ms8qb4F3WRk=; b=U+fKCQI5Xh6sbJFD
	gbSHXz77ap6DOuqUB+TaB0HOzyYAV7+yhQubQ9TYeA/0ZRBu2Si0btef3haw/8rg
	hcJ5rJ5GgCBPthIozH4o73NZ1I9DNKMoLjeDQNprilll8Qm3dNkKi2AS5DorK11n
	oxOtDSUHzRTig1RVJVlDun5iY+RRI7Yo/kLHEVYhORBuwHWZI9QrjPDDBOzDZZD9
	K7zW+rdesCxuwqdR9lKUvpZ3bMeKMwMUSxLtEpw5r3FnL4yFR7OI6VnpgpQAsOM2
	YA2js7ztzzsB2Ms/6feJQbM63S/R7Wa1NxkBDB5PorDsg9hCCtvSO+NcVbTzPV7q
	4iyBhg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gf82ka4ar-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:02:37 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398fe469aa0so184285a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 12:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788462157; x=1789066957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wWafkb7CS909dTCbVmWblMfgmqDyzgj5Ms8qb4F3WRk=;
        b=FM+ZdzUo020PfcFbnqmxfPfIMtB/80dHFhdjlmiRSDt0N7xxBUzBQp47k08r2IqjuT
         Pnj7QdS2Y10sUdQXp6y5c3p0aF+IgSCzjdWsy2gDsz404mgmGqcrh+tNGS3HYpEjqqzL
         aCeaH90puSv/qAUrTc/A0c7PUa/GciD7x5rX8BM3a5HY88h/Nz/B+Yl9VlDrBjCcQElH
         xPoQPlxaZs89ARjuKesjH8Hu3NYpWl3G5VG86YHTU/fJRx/P4fWNBYNhV5SrBhBT1cSc
         vyLkSM2FQ2vKypP7H5Gb/Jwa0DplClwn/QPUOqEjVcz+3wGD4YcVEKEeGhn+13ZXPUCP
         7V5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462157; x=1789066957;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wWafkb7CS909dTCbVmWblMfgmqDyzgj5Ms8qb4F3WRk=;
        b=iqEZNgPb6+58SCKuutqHnPOsooOmVRPTxZm2APzpN42ZkX6uCpGFXDdJNJys8fTzTS
         99GFuZOQ4hVLCVavPab09JyDAHMkicfm064M77uUTi3zHFbgl8IA3RUK0xdyihOOTZHv
         3febVXIEP1wrwpR7YBh/Ajphhi+uOGagrm+fXS4VyiVMOeT+maJrXFEnatKw59ZkBQ1q
         5WaTyQpz8dejGvt24ii9d7vs6MBtIQHXckEd8nuAIOlpRPP2C1zpx4tc2PNpcKHrmnc1
         VfXfOCRfyhNedKrOKyVMicIAxkQCJS4vff47i2138gMNXgN7PxgINykQRxsvcjjr3VoK
         PBwA==
X-Gm-Message-State: AFuF++nj9oh8Hm3hxPBmTeMUBxunC3zLSRC47IWRvQO7bJJ6Zj26JQlR
	LgxUYEumCR/CAPcMIV12D6e1CVWBLVrCHAMg5w1m4Dm91+ijeCJ5MkzsYNoUoJT3VT/Wxj2hRKv
	0rgol8RWYdgKDaGtI1GAPdBTDNqnJJ5ryZiw1K6OZ2NOSFgCTOGRpl+eN0+jgtrVsqM1d61VDS3
	8P7A==
X-Gm-Gg: AYBFou15nGOXgc311cNLM4dUy0gXV9HKK1h96PqAQdPYjwylc5UYmE7QvthWDtmklgd
	c8HsqCZdGFZvqnR/Jr23vG6jGrVJKU2m5Pn7o8BbJVdOaxqE8VcdIEHiBWWQt2d9PF4lYA5vhfx
	GEj23sfK5XsOJby5z5VBWFCrIPfPkgMrRWjS/lsQu7GA9hTAXSjlXnyYbVv8w6nMlHS9EiBLod5
	ZzhKuaPiB7cTKXKG2q+lPzuJOMmtbWXjq2D92mavAGpB3XOSW9PaOoHKvTNxq+Mf87TfAEUBdou
	4sGHMRP2wJpQYYSxDuEEcG2nTFzMGtsXIFV3LC4rzpb4JFeewddp4jzXXy4rDT+x2JUlmrItcIP
	eHtYYapKOt9UYfu5wyJbDPIDkl17Hp4vlBYgBrvA2bZF3eKWC0N+o/OE=
X-Received: by 2002:a17:90b:3b8c:b0:398:9bd4:d13 with SMTP id 98e67ed59e1d1-39b26242a75mr658751a91.18.1788462156449;
        Thu, 03 Sep 2026 12:02:36 -0700 (PDT)
X-Received: by 2002:a17:90b:3b8c:b0:398:9bd4:d13 with SMTP id 98e67ed59e1d1-39b26242a75mr658662a91.18.1788462155797;
        Thu, 03 Sep 2026 12:02:35 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm1230164c88.11.2026.09.03.12.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:02:35 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
References: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: remove skb->data check in
 ath12k_wmi_process_tpc_stats()
Message-Id: <178846215507.824911.1946775956361257237.b4-ty@oss.qualcomm.com>
Date: Thu, 03 Sep 2026 12:02:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: J4yUbyuxvu2u6Z6gLruntQvmELcqXSFD
X-Proofpoint-ORIG-GUID: J4yUbyuxvu2u6Z6gLruntQvmELcqXSFD
X-Authority-Analysis: v=2.4 cv=OuJ/DS/t c=1 sm=1 tr=0 ts=6a99c44d cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=tcO1i5LuZZfHbVICEYIA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX6QUq3zB50kgA
 bncnFJWXoYNythYei6jfMhBUhJSX973LUj3wf2ROhE2XnYRT21ZpYte7ksZDv1/fp0ZkfBBSIFd
 r2Y7cOGvXOAIEb3CgDXjpxvd/aQ1WR8EiOGH7JakSEM7f9OQGPepwqx08iDKtWMtLnrYWB15o0C
 X3YpmDlXU37aYY21tEjUyssYq/2VmgemhngpnrfYiS++XdlxP2LvEpf0Vms6pv+vtCRaqdJc6du
 u1TBTnue27BLyg8smRH+nLLuB4hIdfay1GbTdDkHKTi+WPpT4QJgxnwEDJklcX1KBk1F5Ps9GEJ
 ijnrBJyf57AJ/lVwXMPLPudXxsgvuBwrErNqbpwz87bmqCXDoFalkBAG/mCXwusrlMDCauwLQ5D
 4442X8R093pBCv+MZy+LSDVuHy9+TPJ6Y3GJHYeLazxLIsnzANnKssUdD5SzMUfGygWKiDn0Opk
 USnDhz5Z03e3xZuHybg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX23KuCI8Srz6+
 /Y6wfReQ4d5iRwUDJCE01Cxm+LzeoOTlj8IxbNALtJN99309YkIn27qA7Jf8ZLTZvq1VhHJVqNA
 87F39434Ly0di2HHM5vEPzpE97EMPzk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030166


On Tue, 28 Jul 2026 18:15:24 -0700, Jeff Johnson wrote:
> Currently, ath12k_wmi_process_tpc_stats() has a !skb->data check.  This
> check is pointless since skb->data is accessed by ath12k_wmi_op_rx() in
> order to dispatch the message to this function, therefore it is always
> non-NULL.
> 
> Remove the pointless check and its associated warning message.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: remove skb->data check in ath12k_wmi_process_tpc_stats()
      commit: bd3e260f496adb0123076a237e5e72598dee0404

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

