Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CB4CE683
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350021; cv=none; b=TMp7mTxhgRDNFiei44AxYM6Rc5ZSGRcmTEls8U4YFF8L5LCPWwDiNAoPT1S8Ea3m+mHwG2tnACPg8m/GGRAcI1YnYl+54/qO8XpOn8B+1ZYTKULSkXfNYcktckmKag7GZM9BPnZBrME6fpfnbpmds/wkmSDZiAQoxeEHmzdAUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350021; c=relaxed/simple;
	bh=0hazFWDgToNCbclcWJhoi+q3wfWma66ZlZEkN6avOig=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=W7hOVjq4Y2eoJNj4PVmjbF1Vc4EVHaHwKsqau4Ut6itdhMMc7xtbmztGx+oMhxLLkWK1utv95IB2CsUtXiQUOFZpAdXu1EBaT0M4vMoxIF91nN1CP63GuMLiaSDunKQact2facrqHXslFKFs/lDJDOuyaJ5P/EMBaGsoIZORvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sv1yHC5M; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XrKcaqC/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sv1yHC5M";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XrKcaqC/"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PA4JH6609258
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AMXbf1KVzY+/YL5Xd0vxtQ4Rer17TezgpyQ3zdjS3RM=; b=Sv1yHC5MLBe9tBrN
	v09xBB5HCx5W5BjzoVN+EJbfJlcuCSQq45jnYiBkyYBAkn40vqbmQDG+ZYwxdSXK
	rRyy26d2Avbh3xt7UdjaBDNf1ZwHLwKBLPgqJCaqDtYOS0GKe+93o+ijrgFwtHGL
	9Oj3ZPLvPJoARU5whbQE4AUbcQ1cDPlKNifyAcvkRaQIIht3SwI7Tk7m0OMbRLCJ
	GmKg9i9TU0cBHfgf1qJVIbOthVygNlcCqxbGZ+g8IPDSyVM8yWcaYso7IOB1qdUz
	7n27+P5EW2S+6zg8ZAE8HhUm5HMfeEDtidwsmYTBAPDQ9oIXyVOLYHci5+RCfhGx
	Zo10mg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwpvns2a4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:57 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39e3f521346so1128545a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350017; x=1790954817; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AMXbf1KVzY+/YL5Xd0vxtQ4Rer17TezgpyQ3zdjS3RM=;
        b=XrKcaqC/NnQj8rTQNQglTO4Kk6h4v/exGQicnIicPib1Izx2dqvtwz83euBWa/f88Q
         w1mGP/Gkd838ueZgsPL2v5Zi0+a5AdBL4e73EzapflSg0sfnVaaP44kUJzqslXiFKHh7
         D9Xc2kuAF0etNBJ6xTau1Uy9zwZIdO3pG7xLlSiraIEFjdR3jgTLuwswC2ID+uGHvoLo
         6nYYbg1/XtjXRmNcsOJ8DSS25tEi0G2yR+n1enkhYjaU1AgwOUoDtx9eINGX6V9TBLiy
         yaH5sfgBGR59HZu6wUe9zEqWOpF8ewUPMgTvqa+NkeCK7cRyQduvGuI4hQ8rcnYgQbz4
         4RHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350017; x=1790954817;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMXbf1KVzY+/YL5Xd0vxtQ4Rer17TezgpyQ3zdjS3RM=;
        b=K9bDQB3jhq5VniuSQvYa/TQc2658gM7iFa7qyyuoywrcHrgXi7AOrDpTXizyTKVdmi
         rCxNTXUh8QCgA26fpY6PE2UlecEn62pBtOyVG6sp9CQXpTcgTSjWOc6ItyNsOTpu1s4g
         knT3hgTSNKuGuDd+OCGTJq3hXAc11NKnxF7qt6S4NFiHNQn1n2ecoUz9cqJc8xaE8lav
         EY4jntraUrhe8dNu1AAdIabteEVGikJRMfjGcZ1nvTjVHXFo3I7XiFy14vENWCgYUpxU
         6LTV+rkJY6Gj2omHUzA0qSzcghlLtaatthRit7GN/bROu5SELm8KVhWJ+XdRT5vvL6CQ
         mU6Q==
X-Gm-Message-State: AFuF++mZ8CeHc2bwpNWxn8ZlF0J2gDzhaSGXYh/lPS5OE6e7FkXfrnEg
	FOFAg1tS+E9U4RS9e5aFncDCwh6uh4lbys+AnAUf5k5w+E4iTPPjxyhe5WCUcDDwhGGEUidaI7L
	ML7vNnHTnFf6QEOiz8g/Sc2I71OQf25bJQ/EtoUxyWHNgfbR/l+3k39hDfcuNorsMHcSGpA==
X-Gm-Gg: AYBFou0cK9W0sj6SshFNIyxMgerPK8W+3byAe61Rk7czHEvOxRWc2i9ScVT1lLbHuwP
	zuLrxhqAlng1NRqbhCzfYsSPvtXr4ZFjd40nQ6SnDprZbVKhvJMYabVdp3Xd0xONKnF5E/RIsGX
	pxv6eyNpjgraO8exq8yMtmoH2pBlYuawHF3n6kRFmGc1QujUd7BpgTsaYhWVm5ghaq77/CywWPE
	ogJsjOQUF8mwLAyyp8arPHOBFgC57KEgskLp/wpQSs1GnwPpcPBmZ5OkT27iL3+925Dp/VooJFV
	0oONVsMtxBHO0YghUk6PZZvuJ4EjbGkIyn5k5DpwxbPGA3q8eYDXsHXyYCqIokNTgdMlIZZpAgB
	/m51JSVBlF0eBkh6ubNa/3ag3BNCGtqS4ZPLADz1Cht7h3UvWv0qbSdM=
X-Received: by 2002:a17:90b:1c06:b0:39e:135e:130e with SMTP id 98e67ed59e1d1-3a098570ff3mr5247465a91.3.1790350016785;
        Fri, 25 Sep 2026 08:26:56 -0700 (PDT)
X-Received: by 2002:a17:90b:1c06:b0:39e:135e:130e with SMTP id 98e67ed59e1d1-3a098570ff3mr5247444a91.3.1790350016057;
        Fri, 25 Sep 2026 08:26:56 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm5320405a91.0.2026.09.25.08.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:26:54 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
References: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/3] wifi: ath12k: align QMI memory to 64 KB
 boundary
Message-Id: <179035001448.3875741.8716218454908283754.b4-ty@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 08:26:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: xr5dJyizUtrq3ja6oJR1gjC5w55ARWq7
X-Proofpoint-GUID: xr5dJyizUtrq3ja6oJR1gjC5w55ARWq7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX7PnqKCv8ZVuh
 PT9SxFD3ZVkARB/qdKNMIYnKVNyKhdCKHEODAqllxjJdqHks365IzJ3XF3R05Iltqnq1oFF2Bhw
 KT2l182r6MoSMXCbMTi6grARlMpePtc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX3qkD/WRqzHQS
 jwgFS2DTn1HEm1GNaVYWxvDAftKLVhhBUB/orknmxfXyJ/xGVYkwSaa/9ivgYDMTsCJ2VH2gqGj
 uYlYPQ/UqwJAQ6/NQ42hGPGBb41TeydYwrLUPEG7xivy+2CHJ3rmOBD8jzoYxpz8O696Vt+tZ7K
 57fHL+n86nWs7OnBd6b4SX/dj/vTGdDoqTKMCEX9qbJOMzGz5pnLCbieHhPtfBJrmThV1GPkTbX
 s8ErH8x8VkF3h1BoeALY3mjn4X7BYRfWp5Is6gRS5L7WyISC4TXHvb8w77CqSVBEOLHZYyaJTP3
 OwrYX6lYnVpenlC65j83VcPdG2uB4sSGBX71yYBTegMt71fHdH3rOLwr1SPzBh2ixf0EiljNU0W
 ayPDoJWOLGVLoxV76q9YWxaba8SvoDrZv8nAOQ6jrx2P2K7I3FldBLoPBP036qEh8Xq7sP1NorA
 9g5FmYB/m9fRpb8CiWw==
X-Authority-Analysis: v=2.4 cv=eNmGH3p1 c=1 sm=1 tr=0 ts=6ab692c1 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=kY42MZQJaRLxy9bkkKwA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250061


On Thu, 30 Jul 2026 14:17:39 +0800, Baochen Qiang wrote:
> Firmware requests the QMI memory to be 64 KB aligned, or crash
> may happen. Fix it by manually aligning to that boundary.
> 

Applied, thanks!

[1/3] wifi: ath12k: use per-device max QMI chunk size
      commit: 4e286c780d75831a169b0489afd015214838affd
[2/3] wifi: ath12k: clear chunk paddr and size in ath12k_qmi_free_target_mem_chunk()
      commit: a1af8645cf2dcdac5c6b3929e1dcb2274ca9f27e
[3/3] wifi: ath12k: align QMI target memory to 64 KB
      commit: f7f05c443361ebaa503e054e882633913273b3fa

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

