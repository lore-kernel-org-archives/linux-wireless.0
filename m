Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D00B568FC2
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096902; cv=none; b=CidO8dnFMQlGQ30Cri2uxVH7fGAbN+3vihLpvtOxXkuL+nJ5g1PoY3pay6Ztm71cY8NMZL9MG0xrTEDp5RAsv42qOh57JsZLaXdfATiM3A9HLHUXvA/pxaCaCB66Wm2ipQyKx/AuMo91vYLC2YdB0UDrTmZBUr/86Viu0V1tg6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096902; c=relaxed/simple;
	bh=iD/zzZgmRhJW4Nl5vQPx14/d2nileWoW87yndp3Ml1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iRb0/u3Wzz+HyKmz6sbDdnbBqfcc9XKqjA6MiWFj8bsFKpfvxZkqrFxPWAFIytrN5nC6WdQkOAlqp9HYSytfG0BczJhPvUnBBB2F3L8HSBjkpYbAwsrngRhXHuvutN26LJpRinP15+KCjoQTHyojFdFD+BXml5EhLFXuYASocek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Svvt2SmY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YqtxHqxZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Svvt2SmY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YqtxHqxZ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MEjrQM3953066
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x8oRSt+sEOboeNFCv168cePKrrWr+FqZQJjlgNOUwk0=; b=Svvt2SmY3+ymXzIc
	CWQFf9FtmUpvg7wLbV3aChiv1BvdzWYKR/XATRtCRlgqY2s232oIzC2ikWZSnQXu
	vKmpSVO+G+nqMkEI7Qt5YfXiDjx+htW+pI164UPoJdMlFp3uP0aLazcfg0XJhp7w
	gwPTVTV8fOUliKjD0nluzlof3bxyI6pEtCzXziTVhi4N3kf6Oi0E2dXu7Zon96Os
	ZVDi5Y6Y5T+LYGee5fJ0vyUlGU6kCeTfIQCLO/hTzJUFMgKkvsIthosPABrg3MK4
	8e6z3f8/giPGT/MNioYR4oltQpimlJdnMNmZa/7pbfyFqtxo0UAC9ovG0zBojsOe
	EJChxw==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gufsqbs01-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:08:16 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-7847917c402so12513137.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790096895; x=1790701695; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x8oRSt+sEOboeNFCv168cePKrrWr+FqZQJjlgNOUwk0=;
        b=YqtxHqxZQbhoKmmMaEipVx19GlMYZcqpSAUTjC6SMlWIoGF726grZESiZ2VeAbtNN/
         HaioNGT0h+vGjVu9t9E92XABA/yYsvneaxz3BUvmBvn/Mujm44c5EjJI7xRdy40f1r12
         hVue2LCl1Yp9zsJgh+6FN4BQ7isFSc0XCchPOuxt/GqpHINhw5VCy/NLIlxduZHUiL3t
         6zGv8p70tNTfhv0nn8T5DFOac7BuYNr4kyTZcU+w+BBc6TU0UpdP0G9lgx7jzqQPXXp4
         PFWJ64ndEh+sM0yLwCiqGTmJ9+sYDNcCP8UPZnEi3pPVNRt3bDyiRnjBQQmgDwkWjl36
         oGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790096895; x=1790701695;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x8oRSt+sEOboeNFCv168cePKrrWr+FqZQJjlgNOUwk0=;
        b=MgbJP1HGt0PDX7JOfmoM2ud9jDtsOn95zaTO5i3m0cXs6FtlRjOPmwxd/e+oh7lHGY
         ilhHtjjrcxCR47wHCvmqzaL8ISORdOZfrasn9QYmm1Ae2/6fiD7c9Z9o+gLYTXgT/9ib
         NQ+yXHEkw1mZ7pVmeIRtt5znwNbsHwMjTxDYK8Te/zOrA5rsAsWDIhVtoEWLNk4Q4Itr
         l6Y2btWxZTli+EJeDkQOPJwW0wCS6zsluRLLlgLhQTzIjBrHrNXDdI4PSEgrC6N1zqJP
         3bRZ3QqA7OySj8C5ST5hQ1pgiuIMla2aOos/wnLBBqJ0GOmFfKyE/+xcOevHWY3n7dU8
         vaiQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5aWrqpqqvpX2O8DS6CDzDhBTMxLh7K8EwcTWZgCIxlmSo8VTH3HJ1RcpVF8FA04C/DaY09BZTfR03njjITg==@vger.kernel.org
X-Gm-Message-State: AFuF++nKR95/ljFyamdQBFUaRkzLPe0XxFoFOH6o7FtXmmlRQtQCaEbR
	brdRsh0/ULrBRoPh2DTXYV/LwszmRlpkYCANhW7OTnHeUD0dG0b6MWgCpxRDw+Xd3rsJanej8mw
	6sC8Xb6ECHaQ6q5KJjdD3Ly9xGPZQFyaiQoMByRppbHuyQUD9L9aa7qXiBsD96OQjF+xT6g==
X-Gm-Gg: AYBFou3jG3aHlUOLFtbibiER9qYcH7JePSXlD10JpUYmHSPdfXtf9BMtic53VXQuvOV
	E7vcU6Iz7hXKrNt8xj8HB34gHmlFgfTrcs/2UoJBvMFJ2gyQyvgQt8G7M7xsD9S9PnDs3Q7Uz/S
	hReaOsljfzqcEXssC/lsdF4A5RmSU/pATDwQkW5xo5QNgI+WnUzMgzOLx2F8NBNNnai9XlgLL+H
	hteYUva5kNx3fSnfF1aN6zVkoOYrXcka+bHlQQhVvC0g4bCfjAkYNjLYC39GBhEbg4/3zWAauEQ
	HxGzTFniTOx5GdrkwMWZ79+aQn48P3XBBNpHXcIF6Pi5FeMC5bVdKa2yA0G6hyrr9Xy26sBe3Vd
	7gxzoicPK5DaZmqIpbx187ZiSS+uQg+qOBXAFlJM=
X-Received: by 2002:a05:6102:8094:b0:7a7:19aa:8a85 with SMTP id ada2fe7eead31-7a719aa90a9mr7105787137.32.1790096895152;
        Tue, 22 Sep 2026 10:08:15 -0700 (PDT)
X-Received: by 2002:a05:6102:8094:b0:7a7:19aa:8a85 with SMTP id ada2fe7eead31-7a719aa90a9mr7105724137.32.1790096894617;
        Tue, 22 Sep 2026 10:08:14 -0700 (PDT)
Received: from [10.243.142.186] ([212.136.9.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1c0f6csm5359905e9.3.2026.09.22.10.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 10:08:13 -0700 (PDT)
Message-ID: <3f5da6c9-7394-4452-92f8-b773cd34aecf@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 18:08:11 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: qrtr: Allow the host QRTR to assign a unique
 node id
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
 <20260921-qrtr-multi-ep-v2-1-27dd80d841a0@oss.qualcomm.com>
Content-Language: en-US
From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-1-27dd80d841a0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: tlDPm1TlPynvP3Zvt-W3tG2Kh3R0wUsY
X-Proofpoint-GUID: tlDPm1TlPynvP3Zvt-W3tG2Kh3R0wUsY
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDI1MCBTYWx0ZWRfX5GJG6GxoaABT
 7kHqSmJ9FyUoyJNzKaC2BmUQhxf0neC0/tc1b0+ydvku9fIN2XFLFq73sqaZttQRvlWlVxcgXmd
 n3lLI+NGged4NjS8nHSqqQQh6q5AYbQ=
X-Authority-Analysis: v=2.4 cv=NKBAaE6g c=1 sm=1 tr=0 ts=6ab2b600 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=dNlqnMcrdpbb+gQrTujlOQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=JX_TeLtU1EXCEf5LEwoA:9 a=QEXdDO2ut3YA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDI1MCBTYWx0ZWRfX72WSqfVt1Tbp
 4jQQMQcAvpBm984Ojnl1uCSzKmXCSiFMwGpXvST3TdKTtCKAmPEJGrbF8yi1h1fH/vWrhrndiI2
 cDiov72DRxjJ50SffQWbRiV/LS+fy9+DQxe9chZZFYVyrNyK0EIegeZDx3J9NF2a5Fr2nj+66rk
 OqB0UIROL539mklQSyI96UVtD3xhRWhzb0NfewGokZe/ON6zle0ZoqB+R+r5LUMNwH1EZZjHs8S
 P5EzLuhLprmUQg0XzCpNtf5L07vzZpiA5GjZx1XIPSrv5vo27I3FlvR/AlJA7K3TqTtxDBqYul9
 Xe0kkjXpmDvlyIycN4Y/SEW8T7w1IRB/0XhgVj6gF6qRmOcpo8J5XOSt5va1jF+XKfbmcO6ecpa
 lBYVvrJKO9q5NU7ziOsRgvL0cuvNH7v8YpvmdtZUrgP+FpvUPyHIcscDP4/J6u0OBcT7+S5uR6W
 Uq1lMcwBQYcni6l8qLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 clxscore=1011 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220250



On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> +/* Replace the node id in the control packet with 'node->nid', if both are
> + * different.
> + */
> +static void qrtr_node_rewrite_ctrl(struct qrtr_node *node, unsigned int type,
> +				   struct sk_buff *skb)
> +{
> +	struct qrtr_ctrl_pkt *pkt;
> +	__le32 *nid;
> +
> +	if (node->nid == node->ep_nid)
> +		return;
> +
> +	if (skb->len < sizeof(*pkt))
> +		return;
> +
> +	pkt = (struct qrtr_ctrl_pkt *)skb->data;
> +	if (type == QRTR_TYPE_DEL_CLIENT)
qrtr_tx_wait() will create a qrtr_tx_flow object keyed by qrtr_node->nid.
qrtr_tx_resume will attempt to retrieve it with qrtr_node->ep_nid, which
will fail. This leads to the HTD path pending packets reaching
QRTR_TX_FLOW_HIGH and block indefinitely. QRTR_TYPE_RESUME_TX should
be handled here.> +		nid = &pkt->client.node;
> +	else
> +		nid = &pkt->server.node;
> +
> +	/* Rewrite only the endpoint's node id, not those of bridged nodes */
> +	if (le32_to_cpu(*nid) == node->ep_nid)
> +		*nid = cpu_to_le32(node->nid);
> +}
> +
Thanks,
Youssef
