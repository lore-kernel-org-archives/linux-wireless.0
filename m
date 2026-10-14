Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821974E01E4
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971935; cv=none; b=s1fYMhKS0EG/0F1J15fZpBLB7vN7qgj7ntWMxE48gwYodeb2NsHMI6xX59JAHawnCxlCIKk7UV9D20BDVl3p8NUyq3tV0KPLfhcUBGHd74X/FCsIKAZXsypR20SY8KbiCZMLCPCYSWbZQGOSS+9etAO64J4Xkz1eN/yHi7P2zqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971935; c=relaxed/simple;
	bh=nFaF6SNjro8o+7B3WT7xn0TYrW/r5YnGJw+dLw50nFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqaQRmPhDt3fTGqlCzOvoKspxpkGYZPx6VVMZoeVcepN8PmUKQV15SXk4laBJ/ff5MrBalglTbGHI0zDMohswCjMcDtVhmn7nCa2kCtWieUh4DdCrEszl6mjrP7yyCvYmsuDbGLiaI740hd7IzBS9OfKKfBMjXbi7BlcmqoEAVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MEZ6VAT/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z6MZ5ZAy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MEZ6VAT/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z6MZ5ZAy"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E663er3365337
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gjDHRrp9q62Vy4VXfnTEgQ6XbZ2XuesWLJKlYoTd67s=; b=MEZ6VAT/ykMVDVpE
	ETSPRg9nAYpyajiw8MY6CLk361BFb7eQqH9LYKM7ZEOjjCD3QHx13m722SDvQJsG
	dtURp7A/mhLmV1z/57hoyBJKxJTFGJE/G0e/GjVeBzQJqQvIhTol2QgdXn06pwH1
	y+SMwYtFBcl+wwHy331VrUWLcVcV6spO0wa9OZceuQ7Lq160K8wHZoChBcxxmuvD
	W9oH7MESPbAYxP4c+gxrdRfi7RdLotPNoF0+qJ7M9sZEBzjN+EDVof3Zx7UFVqmz
	OxXsqliOce02St55VTAiTlS0ECtapqw2B6uiDChnn7WaRgWDjER7F3ndvX3rrlft
	dBKU9A==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha4620yq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:58:53 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cca35cf9f77so2456479a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 02:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791971932; x=1792576732; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gjDHRrp9q62Vy4VXfnTEgQ6XbZ2XuesWLJKlYoTd67s=;
        b=Z6MZ5ZAyP+W12E6Bm+6Dl48/Wgm7FwT1FEgo2KfqO4u36q3mEGUWx2+fYNaLbS4bb/
         emla+nf3M5psgLX0+FUwGVlo4RdTVJZ6bHKKHyS9VMzUx/K1B6RstLT8TQc+Stp5FR8z
         vwXjEde8HKtnWcYPC4GLBmiEqK9hzEMtxSVN7kQikuxcPyQ2/R9509XjiUGp+3qH3xRM
         KN/JkjDDTv1m7LRvijNhoF5RLEZ5q9GmpPBbC6x42v0uan2RV1GMEyYiAgOM5BdS5T9F
         awJpbQFFqfV53OgvI9GEzw4qkn9L3USD/joshpRCJKmfDsdRWQBhTPY/NiscvdeaKuWu
         l/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791971932; x=1792576732;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gjDHRrp9q62Vy4VXfnTEgQ6XbZ2XuesWLJKlYoTd67s=;
        b=SY0iHa+JGzqoNuUI/NqCMruSIGnotpJXVXxV8Szfax3TeWvkIKxCZEkiBGTSL5BS0K
         i/fMpipwvBaJGgiW01hAI3PHC/c7pAOIc86Av4WBRVIIaThmaaWUKsSM44nTLUTtl4O1
         JOxv8AJnYS5BX3P1fG0KrCRgEN4MMsvD8+s7MLRPX/YwymkeWk/15+BjDtTbKAyxXK1S
         mCpg/CV2rhoDuB63ukqHDlfzo12+9/i9byQTxdk4mOKHgHrv6s1onZB1lEoIAk+DKia3
         B8xJzFNTpGVidkQYTKNLGFSh/00JoQqnZxl08yPBVyhSomrXlXGnKVUdN9bQ3k/UJyY6
         8paQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5KImuj9S+7AZXwhpq/gqhCTKK5OYeMIV8jua0zvZlma6bLkTRzWRexwjKwOQ4o1H2e1APxfSC8raeMg+1gA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIOpYytKJPGqYRPsLpB10DCDfTB47P4DcnhwFhtWGYblyG//jQb
	b7zlSfpkszJr9vjDxnfSY7USFudrWXQFFjhb4zomthhJtQ2VU8dxwZ5Nls1a8c3/lHYw5aTxNAa
	8ScMDZniTW/hv2G0x2y4IFpyZGuc1zvVx/JsocM9oJR6mK4y7BGzsK23qamv6TkDgFof+Dg==
X-Gm-Gg: AYBFou1KwMAIfIF2DhIzPsyaD+dVqsOvDaw+DHcALSAyP2ZGvWQzMCYryR/mPwaiUIi
	YsezfkDLSHagPfZia3v+oW1ux/rdmhmIMFL04DcDCCxmC+h8+dLTg7n2bszCRd/8HVVnsoYEI17
	ERxZLnSMfmJFx4J2k+FJrCSrj4VvxdXabgc9LeuTkzfAH48bu/AIWzAU/qj0s8OOoa0k9x1JH8M
	q2/UEZ9vNDaPLIHCMwkpVkmqJsp8n7NcF0fpFWrV1w9dbiUFNKCM3IvcBy2gkCMVF/MMgR3OAFx
	FHI3efcdP1PGIvbqNG8mvozULDRw7yyIEV8EPSuJrByzcFby+CryfkqH1oMEVvfIhYOGv4saWCo
	iAexXFz6MfXfeQWvmPPO2n+ySX3Ue815Ejf3oa/FTVEdI9iU=
X-Received: by 2002:a17:90b:2e4e:b0:39e:59a0:46b5 with SMTP id 98e67ed59e1d1-3ab3ac9c833mr11979332a91.24.1791971932329;
        Wed, 14 Oct 2026 02:58:52 -0700 (PDT)
X-Received: by 2002:a17:90b:2e4e:b0:39e:59a0:46b5 with SMTP id 98e67ed59e1d1-3ab3ac9c833mr11979319a91.24.1791971931856;
        Wed, 14 Oct 2026 02:58:51 -0700 (PDT)
Received: from [10.152.209.53] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5ee3093bsm5225244a91.0.2026.10.14.02.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:58:51 -0700 (PDT)
Message-ID: <876187a5-f8e9-4c0c-8b20-2809a1441514@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 15:28:47 +0530
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
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261013-ath12k-fix-descap-multiple-rx-buf-v1-1-5f3a10c4d8b7@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20261013-ath12k-fix-descap-multiple-rx-buf-v1-1-5f3a10c4d8b7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: COs49AwieGctysP8xFGi_kSWESHXOVxF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDAzOSBTYWx0ZWRfX6H/qdVC7ptZv
 NMX0k4lW0oGTJmQV2/BKQeOp+q5pCpRaf7qvas/eYgD9/8uYFJYckcVhySorU/joJQjLhLBgAx0
 sgyCnvRuPz0UT8AcmYIwiGKXhKtTgSH3vUxN8a9cMsFBpztAjiDwORbb+m5C7ec2oGjtBCJHMTm
 +T6l075MBdZj2M+KTdk4IgDwfqHg94zZU/nTqubFFPoVssIrI4eKBcf+y817Yu8Ju2R9Z1BxpUR
 wMg9XwnJy4vpYBFBrYyTtI2cJIMZgGxkGLAjspfDWevUMf2nMtf114olpzT8PiwkWV27NiL8RwT
 TGfYIX1SVCjlPaTEnwCj2AY4CEqit2sgS+Qi9bVaYt80XBVam7Mxsi4fxGwy5vKup3UWldOQPZc
 8Tq0CzwEBCXaJxW8RBu6Jagv4Lk9Dbz3nzMAz8FaCKpZxL9/DInk/V2vwwlDWac7d6NAin9sU62
 AzJxjx/XqDVADj6rHMg==
X-Authority-Analysis: v=2.4 cv=ErZHPicA c=1 sm=1 tr=0 ts=6acf525d cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Awmu5xbjiVYryZGjqygA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDAzOSBTYWx0ZWRfX7STyrd9nwiGc
 Oda7J+gki6nEVK7WD9/tqzSEofZgJvEGRQlq43UwezN4Sa7H7n5KxTmOpBALs/EBhDBqzZ16eQ7
 d8F3cKjKS9HjqioIWZdShE8zg2hLKcc=
X-Proofpoint-GUID: COs49AwieGctysP8xFGi_kSWESHXOVxF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140039



On 10/13/2026 6:59 PM, Lorenzo Bianconi wrote:
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
> buffer (rx_desc). For single-buffer MSDUs rx_desc and ldesc point to the
> same descriptor so the behavior is unchanged.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: e8a1e49c6328 ("wifi: ath12k: Add new infra for the rx path")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
