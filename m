Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B9123E324
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484981; cv=none; b=jfUPY/ITUXvjh6hBQjLk9lS/25jJEeAdyDhJKCDKHIDZTdzdNKLuKZZP48HtDkY90pc2bcU+9rAq8btUxE6q+I+PCM081jbPkBkOLAXtO4yusH8MEgDRT5VU/o4O+yb+cVOzqtrpTGZEkzdAXcY3bCGkZie91OWMU5wM/xiEWMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484981; c=relaxed/simple;
	bh=+kKDSm/IS6w/8O30n7a4YMhBSvMMzvPigmvj0yDJrXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhgXTVQX+cCqRq5BcDPz+x47997EKBOPDL+APmBrbqFggGXEfTsXOUBFVyH5wBg2FVL0aB/VXwqRZULymruw2VltmaVbBHpKsCdy1MCsXaHF04dtkZchpHFixh+oQ8eG3/Pd7uq28wcAx5bqsaRqIbGVpvld1U69YxE7+3Mljvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GohOw9VZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VMBm5XqV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GohOw9VZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VMBm5XqV"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V7wnGm3694122
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j71HTHFsicwBuXZTYdByExT5ln5C9xVWv9Y1JZNj1l8=; b=GohOw9VZOtV2RV75
	JXiptDZ8Vgo1ykZ9OGSdjdAymeEvnmNyTXLvBQHuJekzA5VOVpuXZA934DqtveJR
	Gj+ni2LqbEdEnjyODEuFB61qnB/sTAG/eOlYMLwDcY+KRd78rRGkTxBwlhdN6VsP
	+Apv3InqZcUjxoJQHhYuoaLEL6XxCFxD4Hp/3gLG6VjTxByd2Nns+jpQIHBd0FYF
	TcmlNGt3gJ+jhHYwlM+fB6rGmgcvB7r13E7+3nsgzg3mAhpvh4oWwqUZPrNQlMij
	Xirp/+BjQV0uxAzzP+q4Ssqxyrb8y7eUSgb6EuAS6tGahGoEFEOyzoXOHxE4yP32
	22YsoA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frqssr0gb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:02:58 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dc085b0a7so1356836a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785484977; x=1786089777; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j71HTHFsicwBuXZTYdByExT5ln5C9xVWv9Y1JZNj1l8=;
        b=VMBm5XqVhCadVOqsORX+4YSVkE/oNeOSfRtLy10F684JMUQSC6nxA8PaCvQEIVRRwH
         8Q2heDSSOroDtP0fm2UPGNjP2vq3xHzAwqsShAAJbKmrYyKMiTs/mH84PSIfU2nm07SD
         MUtfuB9YtnIXkxSKO1uBqH1GVdNePFgE14Uyq3qmFodJjAcfhJV5dHGHY9f04hMARCYz
         pC91NW/A9PNLMWSUxpQAMCVJl0l57aKuX1mmxNZqGZJu7Z80GJLfEY9gwnIKlWTPjEyv
         pgYLaCL1upeV9QwRDmIab0YsKgtUx2dqfU6/0Cz6++NF/ZikMR6bXRI8c5X5l2PVOkrD
         O+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785484977; x=1786089777;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j71HTHFsicwBuXZTYdByExT5ln5C9xVWv9Y1JZNj1l8=;
        b=X8QUz7OwcCLFGn6AvC+HrDy/MoBJFJWXSMeWph1WgWPTtqmBfHnshGr+crLCCks5aT
         63iQVc031bN/nJu6B+uyElUzuMm8c6QWyMKdFfvw3sszQ2u+Md3xMD5PCq9CQKvlVuoa
         66Jv4au5eohE2ve8CsrozUG88eVTC3L05Ae1FCEYJf9DzieqOHvbb9P7JD6rGUnm8x0C
         eNKqyeRxlVsc7AxtXoeY9xLb5WpLJWZsWQjA9xJSGQDFGm+lfELt+O9sB0fsOw8f2ecU
         J5FL0EeNb3qUV1ViEpAeqMsKv0snjt4yt0l6uY4KTAoPpOu77pzah4hug7OXGcnRbxa6
         c2rg==
X-Forwarded-Encrypted: i=1; AHgh+Rp40YHb0bjiadXCvtTEH+kF3CWZyCActIYk92Ezjx3cSnACY0NV0wI7me+O0mbGTdiCCTFr+PTw4YPo8Yf+9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxN0fOGl+D08Ee6bqCQQ0pVXPNYK3vcUrzyVpm6U8ge27288xk8
	ZbrFxxp/DAYpg5JCvpXSysh6UbRl5dmD8+oHP6xFewnzXeMfNh/dvoRsfa3YlBtim+5+Ps+3Bsw
	4NIqlKAldiFCeGoTF+M5R8shmpyXbCm6bl0JfM58TJ+NzMaEsdOxYaFMwe9xU8WoP7a5VSg==
X-Gm-Gg: AR+sD11g7adWtA6ZzCrp1mCPKfUfz7bnBj8IjVQLjadOU61Z75DnKPhorbqtJeriY1Y
	nTDtVfxXEuLPhR1dCJHAtFpy9D7QuKJHYf+zd1oqiQsRBkwrTcU6YMuIuDuwrAR/I+e8gBEI62c
	0lwY/mvPNyoFoKufavjIQ/UaTVSxfVb+xw7YW9gtM6BUIqjPZrjVQoaUXFqk473Kmh0b3XQr1ty
	3GaNCBBNS5Elbgk0D9739mRSI81g/muYIj81xWA8pa1YZ3d4viKkI/J5w0KRfHLBJgs64Wvoke5
	XurOEYkey/CvuGyeq4m7eZAU63lzKtyrLkiRYbtcpOsDV7JTnJ3wf/QrXvIfDiqnHepWx3Vhr9q
	7qOmp1x982T/XPsQyoZsodq/HrSDUORiajo4l12Ux3bd8zSc/wLLaqx+aTa3bJIEF2ZyOdVRwoQ
	==
X-Received: by 2002:a05:6a20:4324:b0:3c6:3c5b:fe55 with SMTP id adf61e73a8af0-3c91b362e6dmr931131637.52.1785484977224;
        Fri, 31 Jul 2026 01:02:57 -0700 (PDT)
X-Received: by 2002:a05:6a20:4324:b0:3c6:3c5b:fe55 with SMTP id adf61e73a8af0-3c91b362e6dmr931087637.52.1785484976644;
        Fri, 31 Jul 2026 01:02:56 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe3963daa7sm257353a12.5.2026.07.31.01.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:02:56 -0700 (PDT)
Message-ID: <f7e90024-df8e-4fad-ad42-864c092a56d2@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:02:52 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] wifi: ath12k: fix MLO dp_peer ID desync with firmware
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727162748.963275-1-jtornosm@redhat.com>
 <20260727162748.963275-4-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727162748.963275-4-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA1NiBTYWx0ZWRfX9QoCdLiYXUdX
 /PBJKW7xLwemcxHRWl4Z0hcg8c6DCUFIE/51D4UsxWTOhExzz3JYgBrZ1P+YVX0XqCJRm0H1FEM
 gGaj3+pkjTdES2a/ayqHjUJbXmonpDQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA1NiBTYWx0ZWRfXxvbxWhBcZuS7
 Xk9/SRjTIB1SO1e65oUdQtugjZcePS/KuYW6x96hygOgcUaJ05i5zpdv21gfTEzqnuQ63MLGA59
 tI5oMPlTyF+/6kC77WrBOiJdNousk+Jvmt8/mlRdbXI5mSlUY/yG5MPplWFTbZ7XcoeDY2eIOWf
 nC06hn6VHooR7nktixiXSJFe+eibdadoIKY5ZtLeOQa/4RDjegGxBXPzuIlwx7T702ETJTxhJRE
 Q4/FRyElSU8cbD1rEodXmN3juISb/CsVTRdJIzKdd5ckZWmUVOdq+hHqDUwOxHuaF8GvNJ6AGAX
 BM8MgDqUzr002XKCpXA3942wPTY1t4YUEDYzUr6yK8dBlgFMmCg/+v7dBmrXcW9LI8xXR5u7vDf
 uzKRjDYrudTGj0wAPDqf8l/PMnuy8+Evf10jU/XAeleU99ulUjReTMA+I+CPoRWQRG9fG6M7RZY
 ROMKkurM0qf4mSIzrXw==
X-Proofpoint-GUID: WeupPj0DzeACM66_XlHIsmMrBXCrXMHB
X-Authority-Analysis: v=2.4 cv=QMpYgALL c=1 sm=1 tr=0 ts=6a6c56b2 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ZiB7qzRtAR3mgBQmdTAA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: WeupPj0DzeACM66_XlHIsmMrBXCrXMHB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310056



On 7/28/2026 12:27 AM, Jose Ignacio Tornos Martinez wrote:
> TX completions fail with:
>   "dp_tx: failed to find the peer with peer_id <N>"
> 
> where <N> is an ML peer_id (host-assigned ml_peer_id OR'd with
> ATH12K_PEER_ML_ID_VALID, BIT(13) = 0x2000). This happens because
> the firmware uses an internal monotonic counter for ML peer IDs that
> does not necessarily match the host-assigned ml_peer_id. The desync
> has been observed in normal MLO operation and is particularly
> reproducible after firmware crash recovery, where the
> create-delete-create cycle guarantees the firmware increments its
> internal counter.
> 
> Currently, ath12k_dp_peer_create() stores the host-assigned
> ml_peer_id (with ATH12K_PEER_ML_ID_VALID OR'd in) as dp_peer->peer_id
> and immediately populates the dp_peers[] RCU lookup table at that
> index. When the firmware later uses a different peer_id in its data
> path descriptors, ath12k_dp_peer_find_by_peerid() looks up the wrong
> index and returns NULL, causing the "failed to find peer" error on
> every TX completion.
> 
> Fix this by initializing dp_peer->peer_id to ATH12K_DP_PEER_ID_INVALID
> for MLO peers at creation time, deferring the dp_peers[] RCU table
> population. When ath12k_dp_peer_find_by_peerid() encounters a lookup
> miss for an ML peer_id (one with ATH12K_PEER_ML_ID_VALID set), it
> walks dp_peers_list for an MLO peer whose peer_id is still INVALID,
> syncs peer_id from the firmware's actual value, and populates the
> dp_peers[] table. This lazy sync approach ensures the host always uses
> the firmware's real ML peer_id regardless of any internal firmware
> counter behavior.
> 
> Guard the dp_peers[] RCU table clear in ath12k_dp_peer_delete() and
> ath12k_mac_dp_peer_cleanup() against ATH12K_DP_PEER_ID_INVALID to
> avoid clearing uninitialized slots. Replace per-peer clear_bit() with
> bitmap_zero() in ath12k_mac_dp_peer_cleanup() to avoid out-of-bounds
> access when peer_id has not been synced yet.
> 

this is a known issue and has been fixed by [1], and that fix has landed in ath.git [2], please try.

[1] https://lore.kernel.org/ath12k/20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/

