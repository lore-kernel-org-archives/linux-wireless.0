Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B2D51DAF1
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075118; cv=none; b=fLYb4E9htso2G+K7SELW2kI9TwPdvTwPqcp+xZlxRZ0vyclzXBoCJx2gCMEmmGvooXu+jqhmSqvlrhKtKiWIpYMKvwTk2Hw+5t9om2LStamLXa1jKty2Ona/VW3sYfVWHUaJAw2K/b2FpMLarqD4MnK+Wa9hJHeXcyuHsTnLijk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075118; c=relaxed/simple;
	bh=UbQgd5un0qukt/+fB9cHHvTZOjcrEQ9kR7JHq5n/lh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZGj9X1i91WmDeay2eY66/0RcB+q3gQ48id4PvwQh2RPDFXo/muxlMdSIraM9op3aPkc5aFS7SDtRYrrkQCSlngtHlE+zn7ZZO3Zmh2ijl9BM1ijtLusPY64nSoFR4EuCG2Ws6zKIzgpeQM8q9/tdyvQW56Sl2ELjzy4Ab1LuEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V2cuTS78; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hisv+sUk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V2cuTS78";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hisv+sUk"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68M72o2J2166198
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qpELZ5f9XpMmdmJv5+YoiaMSy8WH96P37pYEqhI4u7g=; b=V2cuTS78aB7dwG5g
	p+VNYNNaQvlPwj4nxua//Ea0uIQcnxZqPmLBnMURrWOKkXTx8flCiHbRoVe8Sz95
	EkPdKqpnsL5kgIfsMMF94wIrrqRM970pOujSHfA/JS1MmcAMGyt9SMMjpl6Yl+SH
	6zTobyTTi2m/GLo2RMPR+n7gQYktokuHhcFfKIJzrUyjosZ4AYlpy8wS1lsda7U6
	rZ3p5clKxIR2ryc0CsvQBxfjrefxcU3xpF19G9d45Uc+lwgVQl0uTrlyx0rIUfKS
	c/tmdZjNm5/UIK/DE/P/JSgZLHp8hBpLEkuWnpfRv5KU2e9A3mWdanMtx9ywwD7E
	saWuVw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu8xeun43-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:05:16 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c89704da8c7so5460717a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 04:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790075116; x=1790679916; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qpELZ5f9XpMmdmJv5+YoiaMSy8WH96P37pYEqhI4u7g=;
        b=hisv+sUk9ed8+hnduxQxvfKEyzBJZ2KuXBuTBVF7sJl2mAbUui3jj/0bHjIRIgvjg4
         tZ9UFwgEz3nPCjlldhiHjpI7t8y02tmyJvkaYJ2Nil9PKMJX63JorkkpyVLASLjJbJNA
         fKE/zrqAppXj3zmv1UGZ70KpQB1iAU41bwP1H3PIXVyRjO2GlIuUzy1tl6EUbnexl9HF
         +SR3GnhYE4KQPED0iyZhlP6VlB3FPkzYjZ6zsmrFUpZH7cHafnyVDeHDpRrhn9SsaXKB
         e7QziB457LOv29ZtXzr+mV9q6J5l5fq6CByDkg9xZNMqCQpbUV0ClmLyxY4DITP6FXyB
         G6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790075116; x=1790679916;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qpELZ5f9XpMmdmJv5+YoiaMSy8WH96P37pYEqhI4u7g=;
        b=Ll7wCYwRHtq0NcEfyNnjvfBPgmgQDpaix5rL9pCpvc+v5buPJO6Cmm/+5/6nHF/dSD
         k/vfqwVvgJWlIBQfFJer0acOsEKfOTzoEc/YJs0sdiEBhqaSrn1/oT7Ys51d2BLKIWKh
         b25mSrDCbsFLbP5uNrajcwJnDHD9wbqjEhTMv0410UIdwR2QwMoCmqWdXiBXGo0kVDSY
         Qe/Eb9Apq2Wa0rMALDG018AeIDG5e8lHLTSnFBg94yIY0vYM0b0DWvkkzE12eyfMJGmt
         JQZ9i7pbTGgKe+iM/mn2YbK/HwjAjawXOjmCgiCQEokhk1DCsMzo1vwPb05iyviLbns9
         KLRg==
X-Forwarded-Encrypted: i=1; AKwUvBypojWjmcJSOBYXSO9P/sOv9ZDkHxVE7hpyJBBXyEhPokZTUG+/7SoV9TnTq+XKXqYi9HtLrQj2w483NzyAtQ==@vger.kernel.org
X-Gm-Message-State: AFuF++k/n++82IOUWl7HRdb5B+bTu2KX3MoOcO2GAcDpAmxL7e38YZwE
	04gqAKhEeV72JL5m5fH1QKq8ZXH4JwMJ0z7BXpI5ojosCYZM+406OfusXBcbL8WrAYwUyTietT2
	i3Pw6leef7zbTDcaNunRphcgiwEnB/zd3vEiMTRoK44AOEgvcHk4HAMWmuExlXFyP832TPQ==
X-Gm-Gg: AYBFou0k4UpKMBzKta/vfKuiydQwus3Z3V27VwDKOBh8f0xIcFR1dY74m4qQtewwiyf
	fWVRTFhHmA9xsLMlmxQB+YA80XrJBiJtreBwWY2VcJ04+LecCtViYqh4kRXON4oiZAszL5H/dil
	s6I8qowL+w/FniyZMJ2eMAFXEWGdA1EkQPJYWwqJEYnHspE1vpA/AyOhcjKyVdDu7NkP2pkLu2E
	qEbJVrraCJ7tLjxt29Qkjo6RzWRCq+gtgMBYb3UQWwnZrZaixpwEzvgNSxvbNFrcTjXFXA8bZsc
	ktktd4epf7McbE5Kddm+36sC6M/iHHupOdLq46Q8gPB22K7gcOSMC0w+BSrUvTRoYh+tbQU52YB
	PVb+6hrm1PHx+zMifo1sPo1Hr3BNXpKwp0RdVjlnG0ZFkFLg=
X-Received: by 2002:a17:903:24e:b0:2d9:2fc9:5706 with SMTP id d9443c01a7336-2df609b0c4cmr8782185ad.2.1790075116027;
        Tue, 22 Sep 2026 04:05:16 -0700 (PDT)
X-Received: by 2002:a17:903:24e:b0:2d9:2fc9:5706 with SMTP id d9443c01a7336-2df609b0c4cmr8781755ad.2.1790075115554;
        Tue, 22 Sep 2026 04:05:15 -0700 (PDT)
Received: from [10.152.209.53] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm6822733eec.30.2026.09.22.04.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 04:05:14 -0700 (PDT)
Message-ID: <c802e9aa-6261-4dd6-8229-8c9862965d87@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 16:35:03 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] wifi: ath12k: Connect to the QMI server belonging
 to the device owned by this driver
To: manivannan.sadhasivam@oss.qualcomm.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: YIINZnPGIQU2RKUbV9NEm6EkMhFomsej
X-Authority-Analysis: v=2.4 cv=PZhqFShd c=1 sm=1 tr=0 ts=6ab260ec cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=bQg6oyjaoxrshYPP:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=R4z_reooDQMcG2LTbH8A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: YIINZnPGIQU2RKUbV9NEm6EkMhFomsej
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE2MCBTYWx0ZWRfXwtDikB+UExsB
 zEysuzTHAI7sJj/WJjGJGrDDNDjlNbLma201c/HFeu/O6YxI/CA/EXRSuIby3OvtLyQMoT76lAx
 9NyyhEsD2xOMQVPVa1VVvp+HNdTxefjo0VFQ5X/TwxtitZOs/K0TjQ+a45kjCazPKmg6Iia2q4F
 XMjuxYA6DLiaLRG6VDG5AjtAnYNEZCjA//YdE4xmxjwt+dO6FInY2chOAUdsPz2NYBsOELOzoaY
 Yul9fNQToaax9pjOXn2fAbggfGj4cd7yr8poGucjVpxKjeFnVmuH7/RrEktvc7VkQd7joX9c4cV
 nlSdsRE31Yoo6upjNwqBjdLPxHGeixXWMQ/4nz8XJCvLZ9s6gaU/mP71M8v2lWJa3IXP2SORJrG
 0n0L+h4eyeRTbxUOKtux3mM1TDuT7UsHceAqKVtwmYxBAOoTMRrq7a4fOSURInjoqUd/u9kf3p7
 Yw98uQlOHydRR19XyYw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE2MCBTYWx0ZWRfX/nKpYYTeq9Rh
 LoZA12DdV5oMYnCujT7xuARkMtWCTr6jOtRVj94BjUdbYm2Yv7mZsAP2gPdqRjBaEVxEvTy6WyY
 +n7b1Fv02x4NFLmvJXlqo3EKmv9SPRg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220160



On 9/21/2026 4:53 PM, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath12k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, skip any service whose
> node id does not match. A node id of zero disables the check, so transports
> that do not assign one keep their current behavior.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>

