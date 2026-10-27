Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793127256;
	b=mlQiYYUnKSegyu2xfH6O4Dl8NlM+QoTCLNYgzgjqK93bpW3itCpsQkC/aifpB4/yxLxc
	 V6xLNUWlGOXpU0/mS6aEN10Y4n1q/QlvBjKD0/4VdpFifgcxxs7idNS0bjhQ2PcBX+lbt
	 fGtNHndBs5hFDsuvVbafSYcmkbmLWzpXEfiEYaIzBxvliyzmV1cISGI1wDPwrJZlS0Y1o
	 cwB9pQu1fu0LeUk6xnUYs9GKCFBqT+8uYO1T48YeDpLTmhiVQF1jdsYgo/hWFzftYAdH2
	 uD1T45P/K8M7gVNQM5DKRLASU9rT0/3kI3hWHf777OzwsnqSF3Y57NfrhKhR4ul2KZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127256;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7BHSeB2tXvPZMKBn/DL1YApAlb2JGYfD53s6iM61Yxs=;
	b=NoP76ul3O8l/sdgZhFR8SGw+t5xbWRihG4aq/qs9FbEgQ6mb9c32YuU9p/xlp2c9uQ7l
	 NFa6LpRMENaDD7maSGE9v9AbmiwWfqWYyWSGAXZnqKWx+E//a7jFFqxakpS41BPibs3ef
	 kRwx1YmRsdt2Pz+b8r+q9HJLH16zLzlkiJpZvgC4KKOGJugn3ymcvC6OJehde4ZqLJ02b
	 hKScQgmVXBn5TglJEmllo35xux/xSlurxu/BMZ4FvqijEydabeN7tywlOq5HA1AT7ofja
	 pqnz8TQDzGKXwCFEov+pftK3pnwClGEVxkdTnVRY09oFnhGVNVzNeus5+AzLKxmXGJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lxoegA94;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bM3vZgv7;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A716606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A716606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lxoegA94;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bM3vZgv7
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIHWVj1917333
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7BHSeB2tXvPZMKBn/DL1YApAlb2JGYfD53s6iM61Yxs=; b=lxoegA94XWTfia0O
	UnlSUY0TgVTpCHqa/buUmnkOlrNq4mUC7Mks8AtdhOiiRAQNVwqosKs/gBUN8UvZ
	p+KFp6aiDMyYZi9hSCbBy3SlDDqF34btygJRR5QQLiA7c+prdHWMoprMapk7bN/y
	tcAbtIpujMq9ubhwPyInIt6inCvvIDA0ngo9i/9B8nZy1Q8HHy4rk0KOQjiBeG4m
	RvzOH0inVsBieg+h2aQE4zrgtszwwtfqnKixYM/s1CfvT1/EwcCSsqO/TT6CdZFi
	RueyrsSzrHPeaEg/LEPWT8XCGFUKkgFaCN6oPnChGLXM7aiIp4Xtcy8+aj8jTOpC
	txMVCg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjux99r3q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:14 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35cbea41088so192314eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793127254; x=1793732054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7BHSeB2tXvPZMKBn/DL1YApAlb2JGYfD53s6iM61Yxs=;
        b=bM3vZgv7WhoE7cTCkqAM25r4LEw00Ez7b+R7YpO5M8PObWS6hC19btkU4WiN1hiHBV
         87TuNw61kEb1d5iqEid4GQsAgRMYPI8llrKOuld4vGnACDVmEblNNszCwz1vZqGR/qLI
         TP2BdRq0FCQYDb40fNtsd9VQAz0Ub45R+05hGt0hPYpCqCWmqgRcGnPa4S0ljVDyc5MG
         HAb7ZBSa+6fgUPtAbfAtMnuO2ARApdNsVIth+MBHdWn+qzCnDhhPqxLDH5OauzvCbYnp
         ItiwrORGp9PKj7Njf0Tj5KVWhwnaU545EfnvDOMosuPe+AIAa0XmRUTQrK6F93o18yra
         xBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127254; x=1793732054;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7BHSeB2tXvPZMKBn/DL1YApAlb2JGYfD53s6iM61Yxs=;
        b=G0+sH1zpR0C9iCt/Q9QraFg05sAn8LWnXCK7/99X5dhupCITa/WtirtEBC4sEXGz4b
         Ig+PpODagJm9hAWQPIiZ4v9ZOMj9SC0nre46HcjaoGSshIvQFcT8Qm+z+6KniYWspRRQ
         PhWPZ5WGQZC+n4rkNJynG8EVnjWmNLz7chOrrBGGUPg4h+RLhD+xg1m8CmYSabxGlB21
         khGlwdLI7Pj5kyJCxEhaAaBz/WZGTxtYJCb1GWptqvHKfP+HiAblxA+0gGczSpD+fU/t
         xz9pkZNGRofNj4mmhFGhXhkXFCFB/WPxLtyRNasTJ2AmGMagnRaxo6CvTxh4huzN+IAW
         LghA==
X-Gm-Message-State: AFq9FYKh1DYHFx6gC8Zf2FwZWfMHm6IGc8mkfTLLmBHubJC87b26si43
	2ujmpsZeX1x8rWgQWwJHHx/iQbiAr4R/nLux97NkdmL/Ys3XrfsB991poloiXRNnCEZd0A5TudY
	lmdnc483PCcFulQKbsJ5+VArvv/CdH0Ma3j87amXRmvWNF7oSBrdxRaYmJQFwCWOYQyrXtL/YC3
	47zQ==
X-Gm-Gg: AYBFou1ZpptaYRFarXdvjZVmi/7kQezAutMM5rKOOp1KYJk/mO2YFglDWzJ53bMZx2b
	GJLAYGoPDSlWcOo8X+c48DPVV64ImtWAHyn3QUzZZioG1FlbtTRvv+79W8GwdTgo3M4SU9c3mQO
	2ewJL7aFATrykWPnXdUrAErbzVR4sMsRFsRGfb/uXAWDdXaIW5DPJOKLT6h2Un+29A3Uy/mUcV4
	+R25EjTtu3UH3iPTBufnnzZoGmzYkUKzIKXKZ5740VNambrX2rrzUhpKt7E2W4Dts7qEvEuzb5O
	cGQLz7/j2uA0PBXRpVw50Vs5LXOXwDpkKJcb81VECLPfvayGvOp6qR1i0zfkzJ1v6eP2MBxZAsE
	yAJiJYE9twcHeTq0SmnECnFM98lzeVZu6o29KNX3yRTYDbYeIXtc4yg==
X-Received: by 2002:a05:693c:83c3:20b0:369:f182:8e99 with SMTP id 5a478bee46e88-36a20114838mr489093eec.35.1793127253670;
        Tue, 27 Oct 2026 11:54:13 -0700 (PDT)
X-Received: by 2002:a05:693c:83c3:20b0:369:f182:8e99 with SMTP id 5a478bee46e88-36a20114838mr489049eec.35.1793127252830;
        Tue, 27 Oct 2026 11:54:12 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a14383b02sm8989983eec.14.2026.10.27.11.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:54:11 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
References: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: remove duplicated STA
 state from link peers
Message-Id: <179312725075.435197.858186897775824456.b4-ty@b4>
Date: Tue, 27 Oct 2026 11:54:10 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Authority-Analysis: v=2.4 cv=GYyCDgXL c=1 sm=1 tr=0 ts=6ae0f356 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=gG3WNXbvo0fGP98XFQkA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: FZ6_26YQlCBV8Q2c04e-ybo-ITKKzuPi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfX7vkaEv0OC61E
 fYE7j/Ugmt6s5ssPR5WLcCJYwhMnJzoRrrSiM+aMD0BSU6oUDbfenmCDW7GVMl1NxsI9vnLOAMA
 OhzYfaC0SArESMPnrO+l8zBpbIxVQcfq858DW1dA7i63vcilmZttQkAFwbc3vDCku0VZwLoGUeq
 D1PZqjZzCMqxBHHgsEOL2ym6rSpychhBeFJI5C5rcVVBjSkJyznzOvKT1LWZB9offl8b5dQBsnp
 2B/qlBPBkya5Sw4AVv4tkg4TBbxKP1tSAEYKEE4HownAE11bdCkVNT/u315UtSEfKJUBF97tB8q
 n+xDR2qFRwJjW4EcSjVGJpJR+E49FWWjgSH2Ygf1eDNB9cW8r4aKBV75AfR+sVyNaljwuTGTtDV
 OZQZT1QUIzJAW7u7RTTm2o427PNQMdXKJwacGkjPBYfGaDc52k8hqDbYp6NxNgkZR6FSZi2MJld
 CpPrTWFd5qvP1eCiNuQ==
X-Proofpoint-GUID: FZ6_26YQlCBV8Q2c04e-ybo-ITKKzuPi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfXyc3+0vIQwhq1
 rg12IjxvzJdEKHelNeC13G3i/BNY30VjjZibylYiZx6eDtP8WFBDwOOLzIDRTp6HORyjLftdzFm
 14igUTvJLOVwEje+GSJ+UDfYA9F0XuM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270075


On Fri, 25 Sep 2026 10:40:34 +0530, Aishwarya R wrote:
> ath12k_dp_link_peer currently carries state that is not inherently
> link-specific. Both the station pointer and authorization state are
> shared across the links belonging to the same logical peer or station,
> yet are stored separately in each link peer.
> 
> This series moves ownership of these fields to structures matching their
> actual scope:
> 
> [...]

Applied, thanks!

[1/2] wifi: ath12k: store station pointer only in dp_peer
      commit: c752394249f8334d146d3f0cb7797fc4c1cb0beb
[2/2] wifi: ath12k: move is_authorized flag to ath12k_sta
      commit: 02121aa4a0127fa87c137b11fdabebc8512f8cc9

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

