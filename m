Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993586;
	b=L5KZKNilKOcjU0w5TVQPkABYRkxk2ztwTrgkn0DnYaZrhxa7kntVmStfxwKBV65NHBXZ
	 XYdCPxGBDDqIK+IB9W2EebXn9pLGIGcrm0y+sb0wRKsV0J6DLgTFHyJHQiVhiGjjRcl40
	 3s4LQM2sBIpfRlxke95rloSYpNJHzo0Agq7DpHf6kWE9Nc3zQjWJGkHrwE53gKoH59y6S
	 lf51oA+kT9tfE9c1/TQmYUiv3X+IDjKpYFdVyNkXM0DTdaL+94AJgEXkkMpW1ek3xe/eb
	 n0maBymO47WYxo5o2Uoqa+5O4LvMJmtqD+TqMJ061TOonltIySogtCPAemOT9RRLCwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993586;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=FCaEBLM8TF0N7QOs/wlJYrgcdnAFOY0k4hubewGb+Zs=;
	b=VE5YBtzXE/+JYS1UxcRvM7wXuAG8V/TW6G1AuIUGmSuThmgM9IzL/A0b7+QAsb2mgQ4e
	 M5y0iFTuTqQK5DAyxD2URt3WEBq4PSlDeRbT60Ob648Hizr4W0k/X3LsirTt1Wn3kPxCH
	 suMh7xIULcoDUGgprTNpALnCgLAPeCz6O7FTjNIrVbjThMKuCbYNLojKpMk2w430wn25M
	 CjG1JuyY6fF3HKR8sdJqjNhfttkFX7IuxlJNWPG8RgfU+ciUtRpdrAO9Bduo0VAYq/Psb
	 WQOhftoUMMj3+3SjS7lmD2wzjHqWCtUytW7vT2ARpS56IHpAAufGRnV8PHlGruE/AlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="TKAdjAT/";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=imjCpCBj;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F7F606A32E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:46:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8F7F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TKAdjAT/;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=imjCpCBj
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4b2qH2806372
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FCaEBLM8TF0N7QOs/wlJYrgcdnAFOY0k4hubewGb+Zs=; b=TKAdjAT/NFKxQ85q
	4Uj4JIxmCtBzzE4PAxeAYekjoJLotQQuPLLBm5IxQ69bEFKWhsXCzUB4O6p0jfLO
	R7re/X6NTyMr/tifE3X+vkPzSTthx1epnH/Wy35ufrnvDExjC89TQXVUf73PRuEt
	w0kvVVNHRo02R546Tz9c+mCoXIvvN+CX85NqBt8Hndm68PNBO1z4o3fHJF83e+jq
	ps0CSeiTvnQ8OAMomF6gKom9OzlDhsIDSf1gsDPp9XLB8603XU4WK83/NdLPvlK6
	KrHBJVhdcZk3lc5UmAfmyAXsBR1hZ4XKm84VkDZ4ifXAxqSdbAJGhCf5NNMFfZX2
	h0ARiQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgm8xn0md-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:46:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso2442306a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792993584; x=1793598384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FCaEBLM8TF0N7QOs/wlJYrgcdnAFOY0k4hubewGb+Zs=;
        b=imjCpCBjUFNfkNq8SuMoFKAUY9zzV7eLE4vMLwEeTi0jfwQvsTmSItYVhHY1X420Ao
         rfnRrHuF8UM6nk+tWutNRSVfXBdTLPHfHdVU/SIgNxs0JvHdceIYX6D1SP0rWYr0GFjj
         hpLTN/tGRFeCDNifCO7LK2PXxUI/YOA/d84Lb7OHAcD06/Sja0TFRXsAJaqCdomaaLUA
         k3cbNn1pn3149YJTxaLzY2NsJYhiiTNMKxP2b4UKNWjJxu7j2NGIalpoldcM7bKwiHMr
         9EvfilXBHuTfQFXk+y46U8Xeh+wFB5Ce8t2s6dEri1hvr23PodpFRrG9Pv1GrVOWpYeo
         0UaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993584; x=1793598384;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FCaEBLM8TF0N7QOs/wlJYrgcdnAFOY0k4hubewGb+Zs=;
        b=0zaBg0P3Kn5LFTHbysa3+PDh5fF9IEl5OVifOfCRkZMY0iBgXLJgTIx5b3PLjdDhJM
         jnv1zEG+oiFFch9gTCcEuhlfe+KCuxd3nVdK9nC7chl8S1xxuVYjOvjRSW7CUswLzzVN
         yzfdLc/Kt7/d7eSCWCT7/w+FTvDWXOn0cgqcfHzDr7MqnQgqfrWt6CMYdlrMyhCGhowp
         PPKwSpNRv40OkLUTIjTxsLdqb/HSJmd1joBSbZIRtDwAdDFMmpfr/5VzMWV9hWk4xy9e
         FV63437YSS7709RzY23HqQLUSo2u4Sgq0u1YAbn2dqO9qH0b4aqsTMuKaNai/H4cFiMs
         txmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzR88a2DESAfaF59CPubWPvX7EOplODmr0U6rpVnmYhNIbqqJI7XjhYeA3A0Vux9ZJNcJsnDPY9HRa/ZHv95Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYIKPTL/X84KeQkdedBtFwaeTYzBwF5yMYTlSQLlb9Jhu6hQ0Ok6
	Lnv+6sFZmid8gJfbkIewtlZuKToVAeSTGrW5RtlewCRDapimX5mtKuU3uCDd3IZtFMg2KqYenH7
	Fi2yTRNuK0RNSgmJi+bny66wxslmj6puX2PhBWccp+xW6Y0fiTcB0Ajypal09CKBXsnk+fw==
X-Gm-Gg: AYBFou3A4TA/IhMb0yRdLDXp8cKYf+JOexI0ADhb0njw+mYMDzoQDULiU44mrdceIj1
	JkO7mMQjzhP/Rh1xkq/mfsF+JgtKurFuFM8wDR/ZhSTqnC6ZXOc3cOK6X9VwlrqXmJ/g3Dy4AFb
	AYA7zsm9hts8xTEv49oN3sS1QVzkrVDboHhrZeH0zjJo/Dbcw7rTkHK9QdMeb6lmloa+PP9MzW6
	t6c/s//rO2XKTbQP1NxMHoimakKWJrSiORI5KZq/urceZxZIJCka79tx021CpVKIliXZs0Y4Vjo
	9lf7ApG/+bVZwSUU93Izg+oNKR61gLCDks9lICVPtWItj7pVIwDxnIbVtHCpzk34fg3PmU18Hli
	5hXobTGPR1bT57KnVk+Jbjt4NZHncA6+KLKIFpCBllnRojYWdVtm6iwtq82hYOxiDpvB7R/V5
X-Received: by 2002:a17:90b:1b01:b0:3ab:1b1c:8a70 with SMTP id 98e67ed59e1d1-3adeafbb11bmr4747443a91.38.1792993583557;
        Sun, 25 Oct 2026 22:46:23 -0700 (PDT)
X-Received: by 2002:a17:90b:1b01:b0:3ab:1b1c:8a70 with SMTP id 98e67ed59e1d1-3adeafbb11bmr4747431a91.38.1792993583138;
        Sun, 25 Oct 2026 22:46:23 -0700 (PDT)
Received: from [10.133.33.143] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba32f70sm6741206a91.1.2026.10.25.22.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 22:46:22 -0700 (PDT)
Message-ID: <d4e86e92-9cf9-4fbb-8f36-56db9c6f9a8d@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 13:46:19 +0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: set MSDU payload correctly
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: pV9EGPLDTselpt8Ct2Y3vwflvopfuNCv
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6adee930 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=grpZdo2CoZbIzhDbOCAA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyMiBTYWx0ZWRfX9MuFf60oDML+
 SRNqZKQbI6JEr2N4klI9QLk4kG0VZ/OwamhSMOpUMN1aPH3YZSlpvN9WXOEAu2juQ9vae6jolDw
 2+h95JBcwuPAlsFoCChraN8CjObxYUc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyMiBTYWx0ZWRfX3FiLQ0xnEQKX
 uPkg4DiMe9XsyamEslTshghuZvHEM1Wbx6/mjjbF1krBJ1VCIKq65QhZlVey4Ht9xsbQoQEDftS
 khEMikryP8EcvLzJkE5WeACzPq1QMJDQQOq/qyqKL00WFOvS0X+y3jMgT89WahMcyGfYM4DVrz/
 R8buvg6YLPhmVaR/sE+MMFJaLwxaj3fJhhNy3GKjwBq8npPAxgyk8iw61kSrKe3sGANKVV3CJIY
 6M8+BpCIqMEnXFtOxSAmF7YXV5SgUPT83oV5mgOf77cJDRSdelLYOyJWgPtHgLsaRpYFik9nVJp
 j4e0DJWNr/8BSLzhufDV3l+sJON0UwWoyo/jA45bwE0jkwPxP3p9NfzCjqeQnFHmnsqh+pv1FMv
 quSPHah45AG7ht89TI/fEWoJWig9vFB+k4CI+yAPyWzOdCF9YWCJ9KA8sAhdOjr4WNq9YRn5fFE
 +wvd+FWoK0os2wf/LGQ==
X-Proofpoint-ORIG-GUID: pV9EGPLDTselpt8Ct2Y3vwflvopfuNCv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260022



On 10/20/2026 3:52 PM, Kang Yang wrote:
> ath12k_dp_mon_rx_merg_msdus() mistakenly passes head_msdu to
> ath12k_dp_mon_rx_msdus_set_payload() while iterating over all MSDUs in
> the chain.
> 
> As a result, skb_pull() is applied repeatedly to the head MSDU, whereas
> the remaining MSDUs are never adjusted.
> 
> Pass the current MSDU instead so each MSDU is processed exactly once.
> 
> Also rename the helper parameter from head_msdu to msdu since the helper
> operates on any MSDU in the chain.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 1cf514fdc790 ("wifi: ath12k: use different packet offset for WCN7850")
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

