Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD9A43746A
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951548; cv=none; b=iKL+IWIfeRdPQrHXwb+24MVTqo7rbSc0CE/3+i/LHBeY3GTbu8MmqFReNzMzXbnTJfF8/vN5K/cu7+dUF4Wv1K03QcdSPGeYlYiP4/CxFuwm5bvFnULOIvXt7NQ9Swk2TMF61B7+jkCEQ4assCKYfruAFrwKwWBXrGhkJRZq7FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951548; c=relaxed/simple;
	bh=zXO53mRWayQTE0Ts1V0i1gp25mX2EuD16nt3o6D+bGU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZfcsPf3b8NiJBOOfMOxfB7/tYjg0U5AceEWjXLhNWL6OB9U1nV2vtIsxz0Q4eXyVIdrqbJ0XP/5Yib4qwJ6zTZ1GwNqwgwHkquT8RL3eoMskG1A6wBKWZKHTylSXsemsge5+OVCxim16WeVdBPy+q/1fuEDvnpM1LItf/NiBxmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P7M6HtgB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ux8T30Sx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P7M6HtgB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ux8T30Sx"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCDkni1398813
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 14:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oIMnaU+Ol4JTO7loHeoW9VtHnJZj6Ry65twm8XWtzq0=; b=P7M6HtgBYTYxPNHT
	U+DkmLTCfePqyGh+epWQQI3nObwSiw2zXVX5YKJTwydBZI70+w/NYAbGLN2alwc4
	VqoCPWTgyA39KDBGB7t2NW5tWR+bHalZ0pLBiidHkbzyHpy5RCRs0VXk5fDSxugL
	lSwhLoNnDAcBxjaNqMno4xfDHo69AWtHKFc7bgx/NOQLS7lTu4AW9mZg+RcrtS7t
	P5GZcpuCv6wjGJGbFdkloErz6KK+92R7O7loQwUJy3NyM+UGSSfz98r28O9nlapl
	ImnYSfDfcMjjXOG9tNRypuCG1yRo48AgSIZZQaB2vDQ6JOkWk6cATJRn2pYZwRih
	H2pwrQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcwu4rwr3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 14:05:45 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc77a6943eso79945805ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783951544; x=1784556344; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oIMnaU+Ol4JTO7loHeoW9VtHnJZj6Ry65twm8XWtzq0=;
        b=Ux8T30SxhBcfLFaIjiIPNc1H5u+yKNGd6Q2k9hKALivlOXWRADW8BbJ9LXoRq3D6q1
         GWA4QApoFl3yNv4J0bFD9irY+SrdPwgGd0zJpzCliPO5T8pS7oAwni18AYLRUXqIoFiS
         3wmZP3jSyUd0KtU6lp4gPIl32WWVEfTcufErgKO/1rUwfObhAT32mfsluKloV7pbD4+r
         anQFQCmIvHhr9WPjYa7i7Yn38yy7y+yYR3nWeWJb3x0bK/pmvCR61TcregyTnmK7KuEb
         Cs4sVTdMzNh3MuleBka35M75aoO8qOH5tMhD5tmql9tXnfedjkH9uydtdnNVqlMz4/02
         jnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783951544; x=1784556344;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oIMnaU+Ol4JTO7loHeoW9VtHnJZj6Ry65twm8XWtzq0=;
        b=WIWQIywTBD5y1axsi1lwsl4Z4R2qsj0/KKVtogvgQyEKQhXq4XoGI1GZbGXYMANkSU
         RV9d85k0iA/gJzPc2mq7UxC1+Y/Mmko9vPsp59R8Nw810iGLsWfyzCTtT726sTKUcHCh
         OIwG81H2AkNPAVVMmP+FgOAUdaTpK2mZAn3tOBgrvcF44oUs+ZylbLm3oKFx0ke4M75h
         +5WVbNbcI6WvhWntwib2nLczigzeMmIqQHNxLF7MAKJJtVhrXQROAr7PitvDfKxEm311
         fZbTyLGrpV5J61aigTxiQeAO1XGVJdRVjJRb26HVyU+G7/21U6VkPL7ibTA1L0lvItG/
         x4qg==
X-Gm-Message-State: AOJu0Yzz7+OyqY1AfnXPSnIhzwR0ORFvsEXgQt0Lh7U2uujykUWCO56O
	J++eaGUaCicoXrPlUFqRD7ffFo/SHh4Ci06IvK7sUrPx7fxbo1AGAUfQgtNVJOMND6+mzzRU+o+
	DcuQbUc8VphiPRQHWVgllbgiauXNqJrMDp4MfiuI14q41qnQ8yX3R/T/Y/Uq6SOrEU7XU1xZvkG
	cvdQ==
X-Gm-Gg: AfdE7clhWHTzcdTzF1TC9uZYIwmbHPiC/hJeoFksoU8dPHg2mKxC2pSHVduanSvNbr8
	IVX8Q/ZOFHtFJIQsGaUxClMASyl2Tzm8gNoC1451UU6YYzzSb8Os2yVmcw5orv7uyokd/nBo0zn
	ZYoRepeqK6h2TWDreGgo7qty6c49VcEWNlpWy/S9lc/gbAPPTJl9UuQu+HHGHJIjXGDMFc8VUtf
	RNnyNwYR20AfQ39USM66gq/qGpD9jtKxdf1xiow70XqIsr6jwTWYlcxDV8LgXzpLjnFsGqd17Qm
	eVVAQD7veuI2v/TxcemDT3O1eIz9F6e5fEkGM3S3h3pXWspaBzAbZtVAgH7GKP/iinLz+BIbHcA
	hqJM8lBmLiwX1EhMeJKfOJoVOHOoYq1O+Yvtf/w9nyiBoxZsnpbhGYUWuS1kyajp4xg==
X-Received: by 2002:a17:90b:4c4e:b0:38d:84ec:b03e with SMTP id 98e67ed59e1d1-38dc73bdd34mr8130306a91.6.1783951544610;
        Mon, 13 Jul 2026 07:05:44 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4e:b0:38d:84ec:b03e with SMTP id 98e67ed59e1d1-38dc73bdd34mr8130283a91.6.1783951544173;
        Mon, 13 Jul 2026 07:05:44 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117462f5c7sm77071424eec.0.2026.07.13.07.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 07:05:43 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, Yingying Tang <yingying.tang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
In-Reply-To: <20260610053315.2249912-1-yingying.tang@oss.qualcomm.com>
References: <20260610053315.2249912-1-yingying.tang@oss.qualcomm.com>
Subject: Re: [PATCH ath-current] wifi: ath12k: Fix low MLO RX throughput on
 WCN7850
Message-Id: <178395154296.877545.10977957684434066433.b4-ty@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 07:05:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=FMErAeos c=1 sm=1 tr=0 ts=6a54f0b9 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=UZfcueCsd8n1aYJIn88A:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE0NiBTYWx0ZWRfXyT2ar6ZTQyWJ
 nwBb78H8Ads4vsRArBfajbh4ysxxk0DrN1u7OfQznC0tdH8srUyAs3owlWgtBy5fNIjy/ewuLh0
 yEELtznxDfUyhKJU+ZWyVlcrkeDqqbE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE0NiBTYWx0ZWRfX0nHedr+oFuxO
 +2SoQrGM8jN3WyYHGpxBlALlCerZDD/XcK4bVcOhIPHWaIjUa9OUJqqYPMd7EHS5bJd2Hcz2ued
 vgQjoU2ElGfk2hTjXPutDmQ/4HLIdXL6e8Mh/4uJHhJfbZXU3UHQ0jk3836QCHSiIhkJZUsP0jI
 N3/2VZzY+aofZh1QhBQdPGDHzDZxs1zyF6JIv6WnbHsxEi4Pz61NWUfKfhaFwALJwQZv8zc/D1Z
 RzdnasyetuE6jH5+2aHmFKy3Lx/oX28OPE4yoWS5W2vMmLBSDsjdd+VxC7QylURsuposS+leP1w
 Uabwsu3qttmnAF/mO3YAu0jsKoZV3kTV+Bha16J5OvvVPgo9p2Y9p75bLnyCQPE8WeS4lewdHnj
 K1Ci1c/1U+NhiyzhMaTj6k7DxFQkViwYKhEUDpSbg9hPIvQOFjkNg76E6ba+NZqAW3qeYff5i1F
 Pvk1JrWi0AEkdpFsisw==
X-Proofpoint-ORIG-GUID: WdCfUgi_ntyJrqgA2dTlNfywTT8fP1KJ
X-Proofpoint-GUID: WdCfUgi_ntyJrqgA2dTlNfywTT8fP1KJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130146


On Tue, 09 Jun 2026 22:33:15 -0700, Yingying Tang wrote:
> Commit [1] introduced a regression causing severely degraded MLO RX
> throughput on WCN7850.
> 
> On WCN7850, there is only a single ar instance, but MLO uses two
> link IDs. ath12k_dp_peer->hw_links[] is indexed using ar->hw_link_id,
> which causes both MLO link IDs to be stored at the same index.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Fix low MLO RX throughput on WCN7850
      commit: a2fe9dc70f3b8d5716fbcfed5fbfb9cf3948d402

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

