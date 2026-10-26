Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793050489;
	b=lzVzHJeCIOH7sxGbwRPgA8kR+OWCNhJTuuwBkctfTHLeF36bY29PlTk2rsWO4nTcY2LS
	 UoAWr3H1671TxXEOfr3HhfN9TVEhRDEda31E5ALvEUnF1btBAdHGLRVhZQsBme7oZe4v7
	 weyR+eWiZKJPsEHIUQyJI6yXr8msHo6o2CPUSbLlRQHA5VbuExj4t0z/qrBg56ZKGWc/g
	 FZiO/fiVg4pU4jfEQwcOImNoJz2HSK9cyBoolv4fk2h070nypHSMQoFxrLaEi9tvGUXjP
	 unDSa2Hfnbj61fWC5fpJJxEE3Pi5xtPRJF/F2dpeUNZC71IGWsZm7rrOjVhT5I9sbpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793050489;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=tAd8MORnWjoXl94lwOMxgtVTViC1oD0+1RnyhP9e8qA=;
	b=UcgInFf2B4wsWWTxXQ235GFfUnIpyQfnfT9KZXcR/mTWO5TUrjZ3QJZg+P4IaT/kWP8B
	 WgXewdXSzJGg27rwPJwTQJWT+xprROovUW7Fjkj+ap2OhmF+IqEkPprmTBYviDrE5ZKsx
	 lv131mjTcJWgW0e90T+dJWLjCyCfwGmUoJRUhPfXPdrhzoP7iftl3tc/V/21trwJ1ha+K
	 tZ8unTOoJR0faz5M3cW/uahTdaSVvHcFghNJy43IOUXmuXiSYWFHqzyObtshbUrrBltXF
	 joZkGmmkeT+wBnVvGbpGCeAWPtMWF7ZkOh+S220nLXo/VJV/zsjJ6DZ2Wxlf1TgY2bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SWj1g++T;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Jkn6mb7P;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC58606A322
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 21:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EC58606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SWj1g++T;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Jkn6mb7P
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIo4iB2591045
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 21:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tAd8MORnWjoXl94lwOMxgtVTViC1oD0+1RnyhP9e8qA=; b=SWj1g++TF+yDUQr8
	ywP/9IqD0m7ocatSpMQy8Q8jDT3oOj4l1AKnxfYt7NwDHVSn7oZo922VNeVKwesH
	SCmUvdRkVSjj5lrCE1gqiQ2SkzGRynJOJpV9CID3rXqh8xs6btFZmteeIYKeopa7
	9klJ900DpTVcKDxhNly9YlPjwrvCMjExoMwOJjr2q90Bj3DEP47t1k27rzS0aYLR
	BGUzBjh7atVnRzw6c04Budrs2hCTw7GbfskyWYrhrl3pkIfpn4ddnwlfrPfMq9qG
	vsa36kdcj5yhOhBRDY6Z5T2l3WXxX3ylySjHtiZvmAH5vSk/T4qCGEKeFnDC/wER
	7hBolQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjb54gvdp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 21:34:48 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35cbea41088so5542351eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 14:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793050487; x=1793655287; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tAd8MORnWjoXl94lwOMxgtVTViC1oD0+1RnyhP9e8qA=;
        b=Jkn6mb7PLfiXNftKzZLoZrh8nZjG/G6KYD8SBkYZB4Lyhnz6J5jLVWnE/OIdqFEgii
         l57H3SLBVyezx15LQRSJAvsecejHHnbu62wHXwc/0g7WBJcic0HcFn4iOCy97L6DMV7w
         GphViXWThKsXNU4nglk0BMT22kZLH9doo6dt1s6eGao2MdgmcXrN/TbzWD47TEOhYpOP
         F9xdXGcltXMtxN7VHu2FDBIorM0S184a0LBMDlIl5ZI+yjIidOk0yrHrb3ct0k2do4GS
         sbz24SnVChtpzJjcxLZI8v+kmSiaPCGfVXP83RdkgusSWAKvl2E8jTarSs7int50nxMy
         hwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793050487; x=1793655287;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tAd8MORnWjoXl94lwOMxgtVTViC1oD0+1RnyhP9e8qA=;
        b=MeZrHR+mgii0GLcTEugVv5quIOpZY0Ig1Gie8bHghBsgZD/eeiz9PvpFlCdQEhxr1o
         xu+MLPJI6ekZ7UM3Vs09kJ8P0ofPsVwov+Tj8E/pLwZX7Tg0hmtAedttJdbOGmWUQ705
         A1+Nw+C3GQyZfqYv32ncaxqYDEgi2R0I9MsIne0vcGlMaT6DV1yd/JOhMbZmeq/f10cR
         acwx0UEuia3CTXKUDQKRyH3Q2HfUKLqXiDUPdYt47L0s6neilGSDOj3BGoi8VRC+YxvY
         Q2YZ16ryTu7Bs+YMbEC43cUwDwxswhOJuhAQpOMOtERc2e/ZUTC7dkIReltE4s6CPUSd
         adcA==
X-Forwarded-Encrypted: i=1; AKwUvBxVJNB4U0y8GutroLhnTNzsPkh8Y/S9BfCTN3cinu3FKLCFliYO80Pmlc5piFez1XbbOL/k1ifVY4qK9oCi2g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLKvrM4+0pJo7LVZxAv8Xc05Q29FkB/8NKdam8IlnSZwoSliuea
	PqQdJ0pwHDv1lL2uxqIZTedb+0FWf38UIUltbCJvP8iFRFAVg/Ug0VHqdYFRqndFtUYzEfMaZln
	Uzu2gGyEbmUdNMHi49EE47M5AOi9xbDoLSMXxC1UGnTR/YU+m0lgBYjZRp0tc9zGe3CQYAg==
X-Gm-Gg: AYBFou2vPfBGFZr243VLFh7dy0T3nAeauy9H/1tp77XIt0hUr2kZGq0TGpFN1J2tT9a
	YnzDcLOfuBOM4RVLvVe2PMmT/8Z6dO+PmBYvQqslSiS6iCeeR05eZ1uv9g0B9ottqP/dWw0ce3D
	+0KT+oRUe0lRsEKdjRcfCF7UxYE8GoEFWc8eHMfQoLxXxE70CjFypaDJMmyituzlt74aoJwzvrY
	w6ZCdeix5tIqOSlWOoM0TsXi2BY6VQGS9Ng7Ok6TJNWccVL/UVAkwpRIlNRilPTKHip0pCyptRo
	/Y7FHGR5dgPX5G6Di7gldcP6kdtQ2V3D2o+oTaQ5CXZyCRktw/EB6QAmAtfrZWsfImlh81LatvL
	2fuDofhKjnUGHLDBv9mqSq4u45cqmls1C8PFGZMUt8D3U9Y0phOPWLoUNeA==
X-Received: by 2002:a05:693c:42d0:b0:361:167c:2364 with SMTP id 5a478bee46e88-369e845a30emr11787578eec.8.1793050487032;
        Mon, 26 Oct 2026 14:34:47 -0700 (PDT)
X-Received: by 2002:a05:693c:42d0:b0:361:167c:2364 with SMTP id 5a478bee46e88-369e845a30emr11787520eec.8.1793050486424;
        Mon, 26 Oct 2026 14:34:46 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d93663sm32084643eec.13.2026.10.26.14.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 14:34:45 -0700 (PDT)
Message-ID: <5f6a27c0-9e84-4314-b221-6bb9f82cb1ef@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 14:34:43 -0700
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
Subject: Re: [PATCH v4 3/4] wifi: ath11k: Connect to the QMI server belonging
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
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
 <20261022-qrtr-multi-ep-v4-3-c6fdb75fcd3e@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261022-qrtr-multi-ep-v4-3-c6fdb75fcd3e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NiBTYWx0ZWRfXwg0YDJe+CkJD
 IrclpK7Jv3vh0dEKeDRgI6gBbPChmdvQcvq3Fx+/K9s1au29PSeSAAnzpdNimi4dr5QTcWrjKA0
 7kTb+3o3KHvOkSDnsXFeKch61qZ13HI=
X-Authority-Analysis: v=2.4 cv=bsnZl0ai c=1 sm=1 tr=0 ts=6adfc778 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=bQg6oyjaoxrshYPP:21 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=kpOCkfKLFM9ZImtyOV0A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: IdTjooivlfK5MSzIqIe-XtGNkneAet6I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NiBTYWx0ZWRfX76bqoxqInxA4
 vRoM4n1Dcln2d7OHek6t1SvdJ3tmeRNSqKy1VS/RBVEDueI76OS8LI00BajlhqZcXhrADDuXbM/
 W7nj5SeEDA8DELzu4RrbsfoXtBwKhThdabryuVu3cyHk3Hg/z9n2ToasKvvXUC/XgIixtyiHuIe
 buRb0UjLxIA/wEdkE02eD8+QvQIAuX901gkVRifexpE9mt3pN1m2kzxDiT9dT46kIXOe1ahXJR5
 WfE4HRdN1llVTYbQEeJwFoVM2cLE5R2EVMbIek0N6MBudaCWGW0c3dh1T+Kt1zfAl5FR19ta48o
 X22jqCjTGrJFPIRzOVztnDM4/MsBTOFUPo8iohz2sF8DiSyokzoW08UUtCDU68Hzbuuyo/Fl5+X
 TT2gaRxo89+W5+8OrtDcs3mQYqJIk/+3z07y/50Hk1Azq4LF2wm3Un7UDYq/snoQcEV54eLdMiF
 ldo6+ue9OEZbL69v6tQ==
X-Proofpoint-GUID: IdTjooivlfK5MSzIqIe-XtGNkneAet6I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260086

On 10/22/2026 10:43 AM, Manivannan Sadhasivam via B4 Relay wrote:
> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
> index 7dc07339b957..6d86e552038c 100644
> --- a/drivers/net/wireless/ath/ath11k/qmi.c
> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
> @@ -3170,8 +3170,18 @@ static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
>  	struct ath11k_qmi *qmi = container_of(qmi_hdl, struct ath11k_qmi, handle);
>  	struct ath11k_base *ab = qmi->ab;
>  	struct sockaddr_qrtr *sq = &qmi->sq;
> +	unsigned int node_id;
>  	int ret;
>  
> +	/* Identical devices advertise the same QMI services, so connect only to

nit: note that networking code no longer uses this block comment style, so it
is preferred to have /* on a line by itself

> +	 * the QMI server on this device's node. A node id of 0 means the
> +	 * transport has not assigned a unique node id, so accept the server
> +	 * unfiltered.
> +	 */
> +	node_id = ath11k_hif_get_qrtr_node_id(ab);
> +	if (node_id && service->node != node_id)
> +		return -EINVAL;
> +
>  	sq->sq_family = AF_QIPCRTR;
>  	sq->sq_node = service->node;
>  	sq->sq_port = service->port;
> 

Since the requested merge strategy is for netdev to take the entire series:
Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

