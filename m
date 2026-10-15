Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF749DBA8
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047437; cv=none; b=bPAjpHHW6aJlDHeb+6nZjcb9gXRSnthBVgmN8lTkCa4OzQyGBYNekR3IHTJTAytToCgvinpLF5QMHdJqpsbIgZoSWBYqGh60kqNoXqB0kwxAHqook6l5xGx3986Xeo8Qff00duEKEj8NyrKTUhPRXv/VTL7EUgoT/SK4QrGwTZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047437; c=relaxed/simple;
	bh=GjevRLp6lHOIooG6GtOrAxohOhXvsktVz3NxbYpeQec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3aRbOiBhyGCBNSYPea0wqUFGPm6I+z3SwRZ7hule8Wky+Xvu/ug1gDbgoszjc+Oj8BWdwk75DE+/uFwiULbq7wCZX5OyFh8iX81azOiw68phnrxXBNu6EdHfaqd39ktlP9PRMDvebf1jJf/LeNYWfyxObU+vaZfX1/byY5csCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UsdVGi/+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RZ4iprZO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UsdVGi/+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RZ4iprZO"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F2CsOq841915
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wdd6oo9PhHOlz5Z+fi4fD3T2knLRhYNkfPM9ysWFy80=; b=UsdVGi/+WevLHjQW
	vHOUzEBoNzaYH2BAx5UKsN79l9RJ8jjofooET36HKvUm5jPA4f9uYk+vgx37bqDs
	uji2yN1/HSf5y1yeLjY3Q2JkE5daRa5/C4H/ZE2IlC56zccfthcH8XZxr1mdRbWK
	FHRLylkML06Kzh6GuaLQV+27HVF+YWsDWMgWfF8UzQSWbzvlPR7I4QVq4pw+/Uos
	NScHlFpnjiZXuh/RrthVBFd1b0qvHTnvOzuGR+z2uc2NkR5/wFj6tjX4bn0U1FWu
	EyzMjgcGE9Jc+i8qWfZX/k6Tc/YDH4vvqJyZCi3jrFfF+OeN33938wNrcCIlPewe
	apMl8A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hae4wtkwy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:57:01 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cfa4e4684bso25512005ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 23:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792047420; x=1792652220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wdd6oo9PhHOlz5Z+fi4fD3T2knLRhYNkfPM9ysWFy80=;
        b=RZ4iprZOCQ2rGLLSGHEASjMPGNbBuxjqlgcIDKzTwixT/lZ+IvKENtzv/8w08cmxzg
         XhoriPGD+JtN9iZSHRaLXqnYMkv+/dCgIxSp4qBA2dKPx5iruMqm6f/OmAh9TuM5bnqU
         cF6FvJDylCFvp4Rokd6a8z08qmqjd49FY7xxVkJ6wkfjS+UR3bs3hi2SYoJQSxqUgC1G
         QzO1zKLKV3sszuH6BwAx/LsqJnjoLCTzICsF0YZtmAI3pg3WzmEXBKDCw2rkBS6rEQys
         YnJ08fIaLw+TxbPZY3AVfzW5J3xPfvXpRA4LpjHTmmrERAY5BmWAjbccRriHUszeCvbk
         qCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792047420; x=1792652220;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wdd6oo9PhHOlz5Z+fi4fD3T2knLRhYNkfPM9ysWFy80=;
        b=PnCoE8XU4BequeLQP4+hw1vOdXz1ymW57nMo7M/F+F5UqingBlk/Ek2j0fPa6E97zv
         NA9caWOnoPJ1hOLjxxorqvaStH0Ot1icdi4rngOgbkHIavpalQ6qw1Rhxez6NNf+ff7t
         RsEU9FiSWX5KVHdsDxO1DmGc+yajJi0cytVKxdu/nTnMVe2vbvxFl4lPGpTRta3Phs+p
         HXmSxlddMqXR8TKLe2T1y+dcq+OREg82E9VLxHvqvX0NMR9Qy1T3xljbDqkntkiaCzTs
         bjGq6anLEoNITvkCfHLXmq66oJQhcg2tqBpsr0AkXgoQ4eh0rGHNJG6PWCHG9yUM7yQn
         mjvg==
X-Forwarded-Encrypted: i=1; AKwUvBwy1/KmyoCKdIE6fhvdrtW2T/ynQimJ2Q/uOCxQzVBO4TmQtEok8ajyY/XdalmG/eNzFSVSZ8V/L5o6dZyp4Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJaRevwMJv7kSY9MhZux3QY1lX8BeZEwKnQDm2cIRgg35aEZM1/
	mlZjc1hujDQBC4hua0LR3t/M/5euynxz9Dt8y9osaD7xY0KN6xXQYCmAXSzjq7tSa7qXtbx3TzT
	Pdo3OFWuKQinXRhuecuDudTv5XifJjW//icCdCosUKREvoaSJALdiy/96cgL72nsc/96m1g==
X-Gm-Gg: AYBFou3T4BEPsEMnRkSFKvNvuat7TwSF9ahep47XME6FOsfL6UnLjhrRvBXWqo3PZIL
	V/ixNzFdQyWSetl8II9incdkp4eF7z82NStlQz65SQvh+bDpQHnPMhOVLcr5zpss7U3av7es65Q
	r2YvxdqIGvGNIp49cE0ytwznWsZvDNkRrZM27F5UtLswCCdL7CJEOzjpZ85mvoeG7UGd7xlTCLU
	W7cvgks57t4Oce4htBKmT2rfNNgBp+5RoaJ3HXPgjoSR2hygqRR4ZnyTp0TrwAFAWv4zE6F6RFt
	8ICdFrl9+yUwLoEv2wdgy1KpAuWUU8m/byludGUf7CTvephRLls9NY7pwgm2We8B3xziy0ORSQ9
	Y4u8gO3OGn7g/EbHIAsnNzYP0v24RmRjJ0nimZmehPwF0SgpAwf3+9/u/r3yzwDeiXyTwje8M
X-Received: by 2002:a17:903:1ae3:b0:2e2:d77b:e587 with SMTP id d9443c01a7336-2e842cd4484mr184465295ad.18.1792047420571;
        Wed, 14 Oct 2026 23:57:00 -0700 (PDT)
X-Received: by 2002:a17:903:1ae3:b0:2e2:d77b:e587 with SMTP id d9443c01a7336-2e842cd4484mr184465125ad.18.1792047420024;
        Wed, 14 Oct 2026 23:57:00 -0700 (PDT)
Received: from [10.133.33.32] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422c9944sm77616755ad.64.2026.10.14.23.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 23:56:59 -0700 (PDT)
Message-ID: <39b64d83-4d67-4249-9535-dd5b1ddffa29@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 14:56:55 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: fix decap of MSDUs spanning
 multiple RX buffers
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261013-ath12k-fix-descap-multiple-rx-buf-v1-1-5f3a10c4d8b7@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261013-ath12k-fix-descap-multiple-rx-buf-v1-1-5f3a10c4d8b7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyNyBTYWx0ZWRfXzifyURqZzQql
 sW7/XXhVKeOrgxretkXATFcYdAYeWfMOYfPLWzQVYAjhyeFAzAY5bNMBQNQU5ccxBVF+oDJCdkG
 HL4i8njIEWC4optb0CcvoaU5niM5g5E=
X-Proofpoint-ORIG-GUID: aK4rIV4AAK1bhDaC3AuR-PySC3fn07iM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyNyBTYWx0ZWRfX6VOeyWYpm6Cn
 aJMTEqkn7aW4y8ObqhM/CQRB1uTdMhjXWQ5TPT+WYFSJJx/Di9iJSbxwhuq7AKaVPu4DT8OQP0N
 v+KemNmUEMiT5xqchmu6ds30vaaF7JF5xKpq9tSAapTfrjBloVe5m3U8M/JA+PfeBnrg5WtF7pN
 BJYP5CzQXi/huVrI4ZdEm2DHAKxk+a4Ik8kBXP8tn0DfATigHEHK+kLo/nao9UBP87BIj/rno/H
 mcBRqYiVTf32pCFM9+Qsa3QzrINvVqiVr+XgtD9p7C2n8sLE20MxBbdb3/L4wy5GtwQhVEVdAYs
 FsNjG9/xnHQXMX6tc8Qsp8sYCcVy2j21Qg9Rx7H878r5x3WFPbAv1DDd1H7TfuUcdQ4+rq/8QuP
 QGZNGgkVxzZuSlSDCXZKBnkX1qlMd9DjWbGC0YhUZ8QOJwg7RgaVRQnIVjQju4BTonTrlNBwZQi
 hGAHJEEfz+rjE6BU0Pw==
X-Authority-Analysis: v=2.4 cv=E8BYNqdl c=1 sm=1 tr=0 ts=6ad0793d cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Awmu5xbjiVYryZGjqygA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: aK4rIV4AAK1bhDaC3AuR-PySC3fn07iM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150027



On 10/13/2026 9:29 PM, Lorenzo Bianconi wrote:
> When a MSDU is split across multiple RX buffers, the msdu_end TLV is
> populated only in the last buffer. Since commit e8a1e49c6328
> ("wifi: ath12k: Add new infra for the rx path"), the RX info
> extraction in ath12k_hal_extract_rx_desc_data_*() helpers runs before
> the MSDU is coalesced, so the msdu_end-derived fields (decap_type,
> mesh_ctrl_present, is_from_ds, is_to_ds, is_mcbc, is_decrypted, sgi,
> rate_mcs, bw, phy_meta_data, pkt_type, nss, checksum flags and
> err_bitmap) were read from the first buffer, where that TLV is not
> valid.
> 
> As a result decap_type was reported as DP_RX_DECAP_TYPE_RAW and the
> frame was handed to mac80211 with a raw 802.11 header instead of being
> converted to an ethernet frame, breaking reception of any frame larger
> than the single RX buffer.
> 
> Fix it by parsing the msdu_end fields from the last buffer (ldesc) in
> ath12k_hal_extract_rx_desc_data_{wcn7850,qcn9274,qcc2072}(), keeping the
> mpdu_start fields (enctype, seq_no, peer_id, tid, addr2) on the first

nit: On QCN9274, the tid getter reads msdu_end.info5, and the patch (correctly) switches
it to ldesc. On WCN7850/QCC2072 tid really is in mpdu_start. The code is right; only the
log doesn't match the qcn9274 hunk.

> buffer (rx_desc). For single-buffer MSDUs rx_desc and ldesc point to the
> same descriptor so the behavior is unchanged.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: e8a1e49c6328 ("wifi: ath12k: Add new infra for the rx path")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

