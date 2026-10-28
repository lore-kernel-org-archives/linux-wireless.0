Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228597;
	b=Uc5olJliAbHm+wm0sm3Yjnk5Ll+vIdTPt3NJJJ/9rxlOgBwN3Oepgc/cF07XTw70DNKe
	 z4JC0hQHZy0QaX28UJIZR9BsBDfyuDWJmIkNxCsjnEYfx0kLDggxMHwXW9FsOfakSfgIe
	 AurFmjCflzG+8ZMDbK+I07V98/JS89goaoP4qzE54gz/xtJV4qLJbzHwAMPoCUhIhMHV1
	 fu8s4zXDxqw+4zQJthqmEaxpC/uql4xfmahr2DMaEFsw/Rp2f1jazdFzifPN3iTfW+VLV
	 jUWUMrTYSJo6xkodUbU3uqVTkXQtrP3pbA21j5LOrktq0qleBuQqXxKKk92XXitjIjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228597;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jc9JCYI3/sVgj7vbhhCWJdpM1k6YuABOYoJMmitMtrI=;
	b=zoXcD90PkZ7g/imvCS8yVYqyaQRBZSVsx7+Ee6K8bBbYTTBZ4BxS1r0AtRKBqpO6FUwQ
	 04xec/pFwc67mvmqHnJe8Qwkw6rgoaoOBFMCwdlyxyrThPK+HfsJaifc2JHZo/1dKuM6s
	 TKT0Mv3bGQyqhwM2qTxRQObs9TLV9d/UOpMTKL71zyZ6RKvBB3bnqvT66tFjdmvKnwzio
	 +cSgRnfAie1g5D9qca3ag2qvSzbuaucPcV2BZyTQ4wAxZIhcW/+ACcn2lN8oVxLkp7ZSt
	 c3M2Dl9uG5sApOCBk1m63UGI5X/jW4LM09X2wXDkgXtBUanJT63YvtB013oGXToS6kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JFMcgnbo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JqcInRpr;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A34606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47A34606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JFMcgnbo;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JqcInRpr
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SMA3Za2369043
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jc9JCYI3/sVgj7vbhhCWJdpM1k6YuABOYoJMmitMtrI=; b=JFMcgnbohcofm4gh
	82Iq5JsSqbq4jM6wM0i1jno++N8CwSbjzqpCXuxnNTDqlRKZqZ09MMsygjCFBvB5
	WOW8wnmfdP2s1ihGk34mu/sMMbsIfz1ruZ7sQdKYnBcz3qzuwu0WL0fyIQS6MjIj
	XjIvGoGAgxJVaGIPRH2Q814TheTYBjMuBlheJQhIbCDwnVkaJ4bnqZFItbKa9Xga
	nPzfsB9UvcRRhgw2IC7ADONXcEDrAHKLSUUkIhaxNK/gXj6+hG3+opnEMF9iCFZg
	qRo6TrTboHd2x5rCIEC9g+CIPPOX/OF/+NyPCradJYLn7/R136M07/6JD1UpNiSv
	jfeWEg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkpgprvur-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:03:15 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-341eff9e381so3097940eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793228595; x=1793833395; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jc9JCYI3/sVgj7vbhhCWJdpM1k6YuABOYoJMmitMtrI=;
        b=JqcInRpriPHdfr08acwVdeTrX0PMPWD6eAGQOw69s+8+l0h4hOM9yg6O16U5HeL9ty
         yGLXHRpg3TYamxNNhHhSy+qTehJdw8p3mrO/HX1mAzXqKQExvLY6Y+O9cwFjP70FnL91
         YHyvZ3wPbgX1fe4avFQBquLQDnm1LHVFvR0+j/9Cjw96UhU5wwnuUZNP3COL507l2RuU
         rNkIL3RT5hc57MGFTY3WphqModwlrzv1/Vn+3kl9Jb65IkNSnJMYoznRRgfLtnPGYd6y
         V0uvRytKhLFR2X13LD08HiB9GvjshKyekLYTYTJLxoClgo0J7y3M/cJlU6/xHBgMP4aM
         dykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228595; x=1793833395;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jc9JCYI3/sVgj7vbhhCWJdpM1k6YuABOYoJMmitMtrI=;
        b=wG1u+io4jWSg2+1idXFOSFqtNNy+tNZ7hgaKUu5Fs6Za+oftqrvdjtYzSDB+KTzc8Y
         5dkp52V82DuIcFY76e6r/XnmjepsNVf+5retcor7QgYBAbjHwZxqRTY66C7OXJ2eQGFj
         BaszR5YntuDPXpwjcqWqO101R+Jf1yD/z5a5MrcNJFo9iW4AkgOoC7Syv0j7Xonx28mX
         MCyOeVyf/q2lX4rRESMgoDwaAtltEcpLAHTkIRphS7VGCG9dvRSS2spsSixODkSXFLoZ
         +YpNwetwaOPzmij3QX/kyCzp5oq5nCRHX1D+K+bvrbQbzUxccLMC/mGUoz8OmceUegXU
         RDcQ==
X-Forwarded-Encrypted: i=1; AKwUvBw4V+7EO3xUmaPOuv9beRNS9e4zaVGXyRDkBl2ycqiZI14P/isscAvdfQR7BFME2zwIVqvNtwTZD67Av17ePw==@vger.kernel.org
X-Gm-Message-State: AFq9FYL73TAqCM2HEqyFj05cS6d4X6EzCx1roe3DFXuuMXecbG9FPM/M
	ucjsMVNCWavg+bvLVnU5lKBNtrsuZLlzFqkmSSEm5CjLWErl48YfNWjksl6oIWBRRoPKKQB+1aJ
	u/wER2GA46tQQsgAMAI1P6ClESntLlW/bHngG/7XtQsXzD1gdJrbzdn9Zlpyo4yqh6X8HIg==
X-Gm-Gg: AYBFou0qCYHAoDUnmHvm9sWWKnyZDDC0RDDEFfpckQTzMleUvV9tO8eqRajEy7CEQF+
	upMxUBEVSOikejbNBEISASmKbaZTrkqGYHAhcKtsEbfjHBX2HJcelj+F3dYxfaXvBMskLGENhOd
	yl7TW5n/HKWE0kCkWd0Rzr/1J1U2g2g7/NfQuRw5gtsd42d3fRiHtFB3nfsiI15iRRqMoE0VNck
	7uRj6UGTeSRBLkOhotdAZElMvFQlImskqGZBFiKv5Kt+FT5QGh1WVFbUECy+Onpwtlp3krXnUAF
	D8D0VDtH1uFvFGq9LQvP1pXN2GAFHRAAVFlpf2XnO9fqS9gLRKPmIwhDu4xPayHGynyDe2i/0w0
	2fRz5uA9+U01DAS/2++1NC/CbPbgUj7N/Q8Z34wbGWgkfAx9HP6dus6WKwksTh+HeyvWfj9gmri
	hr3PXuDQF6pQFWhLNylTin0pObBVt8WM8=
X-Received: by 2002:a05:693c:20d1:20b0:36a:20b8:ee9f with SMTP id 5a478bee46e88-36a20b8ef9cmr4898313eec.1.1793228594673;
        Wed, 28 Oct 2026 16:03:14 -0700 (PDT)
X-Received: by 2002:a05:693c:20d1:20b0:36a:20b8:ee9f with SMTP id 5a478bee46e88-36a20b8ef9cmr4898270eec.1.1793228593948;
        Wed, 28 Oct 2026 16:03:13 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a23908449sm10585197eec.11.2026.10.28.16.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 16:03:13 -0700 (PDT)
Message-ID: <9801fdd8-6785-4b92-9f1b-fa8a44c58cb5@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 16:03:08 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] wifi: ath9k: fix WMI command response handling
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>, Mehmet Fide <mehmet.fide@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20261020152412.95560-1-mike.michalo@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261020152412.95560-1-mike.michalo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA5MSBTYWx0ZWRfX/TZDuqPh7uQ1
 oPaijOotLkzTqGNHRqiAjbKMPMdTDDJ7zWyDXF2kZhugmV/W5Y9QNFwMOxsT0u2ASzHsYGN59vm
 9nUkMDnhnrPZhnlVrTRb9UfqmfUj87GXo/M1Pxjf0ItqvhQNV0EOS2PI+5RFXU4vzKuFau7JpYM
 EqGLuDz5bkDdC9ieKst0i+G450zBG2Amfwt7kP8pxm6zDZouwT6LKSq4KYAUTckPGWWDSv+dT8I
 onKet63ZyNaCBwCbQYY4p8YNZg1VJWXtQw/kU431Df2lWTKk/IMsaMuPqTzD60d59y8P5kwW94Y
 4CRpe5w/q3mWhJi99vywM7E3YicKIcOVZAaXqtU05LOgJW2ZoYrq2bmiivRGQAUR7VGb8Nq9Zcc
 JiUytrQ2lsNGgbnaQfi+f51t+QqC/7zvY9CGyrCJ+Xh9qEA08XAFO/z1j0J4Mv/7tG9+C3hKjT6
 3+E4MZAjheqdFS2bJZg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA5MSBTYWx0ZWRfX+3NFuGWXfXSP
 fSWxpaE6oCCBx5Xizug1Lj0GcbZJASxJYpjiAzv1hBGf2Ulo7I8hfyaVcfnpxlj0GPfBs+qA18Q
 MtIIMIr3dxTyFMqJRgzmx8DirTcmbeg=
X-Proofpoint-ORIG-GUID: W9mf8D_P0UX17-AgfiktkN1F6eQ_L9ZV
X-Proofpoint-GUID: W9mf8D_P0UX17-AgfiktkN1F6eQ_L9ZV
X-Authority-Analysis: v=2.4 cv=T4oZ3PKQ c=1 sm=1 tr=0 ts=6ae27f33 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=hfkPbDm_xK7fGWY-MgYA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280091

On 10/20/2026 8:24 AM, Michail Andreas Michalopoulos wrote:
> Both patches fix the ath9k_htc WMI command response path.
> 
> Patch 1 stops ath9k_wmi_rsp_callback() from copying bytes the device
> did not send. It replaces the -EMSGSIZE approach that was reverted in
> commit 90201351a862: short and empty responses still complete, and the
> rest of the caller's buffer is zeroed.
> 
> Patch 2 stops responses from being accepted while no command is pending
> (after completion, after a failed send, or with sequence number 0),
> which could make a duplicate response write into the stack frame of a
> caller that has already returned.
> 
> Testing: temporary KUnit tests (not included) drive the real
> ath9k_wmi_ctrl_rx() and ath9k_wmi_cmd() against a fake HTC device in
> x86_64 QEMU under KASAN, KMSAN, UBSAN and lockdep: short and empty
> responses for all payload/buffer length combinations, duplicate and
> late responses, failed sends, sequence number wrap, and a concurrent
> stress test. Without the patches stale bytes reach the caller and KASAN
> reports slab-use-after-free writes in ath9k_wmi_ctrl_rx(); with them the
> tests pass with no reports. Builds cleanly with W=1 (GCC and Clang) and
> sparse.
> 
> I don't have access to an ath9k_htc device, so this was not tested on
> hardware. Mehmet, if you could give it a try on your AR9271 that would
> be much appreciated.
> 
> The series applies on top of v7.3, which contains the revert; ath.git
> does not have the revert yet.
> 
> Michail Andreas Michalopoulos (2):
>   wifi: ath9k: don't read past short WMI command responses
>   wifi: ath9k: drop WMI command responses when no command is pending
> 
>  drivers/net/wireless/ath/ath9k/wmi.c | 47 +++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 7 deletions(-)
> 

FYI per commit 1e035297ffda ("docs: remove Assisted-by references") I have
removed the Assisted-by tags in my pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=dbcdb6d99d5273cb816350657709867fe2cb5adf
https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=1f4f20fb0fdb2796a3527f996ddd83c6c4400f24

/jeff

