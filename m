Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C483546E7
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786731889; cv=none; b=Pzt/p/lS3PrwiKRy4S/87p0mpjwRawsdHXHE9qQsIWAS1baHol54SzutL1p4XE0CXj0/WVNKbsj6D6e044W3Zsgz/eSKtKOmbKDXOdUXvzN7yUP6PRHjcdapsaL3Cv0YgRxa7RjKdHvO+pKtuoFU2X1MA4vB/rI+SKIipE2c/es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786731889; c=relaxed/simple;
	bh=OS9OoHAQWlSGrXHhyzVTwDpzc4mMS6pS8Yn+TmEqnyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=be8WHstKi+60sJ9Oeu/3MIADp4pienUiFRLL/Lrp4t/4Vcl87oy5ZeOmWDe+bsJrz4RUmyzA5PSp49qf45eSZN1+8Ju6iWjdbaaPWz2qgaSuUI3vo037SwVNw0sWeRyNcwin2M3HLTP4QWoKFwxlA/aEhOc7svhvEL5qvyOk4e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Fa4nTT6Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LAlt+2/O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Fa4nTT6Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LAlt+2/O"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EGhjET3360469
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 18:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pZ0ZCO0QYYFyjzNa6YQ0UARU0WyzWWP97iWFolq8hpw=; b=Fa4nTT6YnPmll15U
	5DBOPZuSxtntTtoBWedK0wreoq6wE7PyBHouhDKPMu+ijsEby7RJTdn4JsCYjlSG
	uJindpznZvQEHpdXudBRybrhgZd/H8SUv6rXZ+3fXeoSo0U/9T4/MDtxCiVEnEf9
	iVlkHdDC17YUn9XkrB7GTnn8Qrs9ALYtIhbdCx+KZJJNPkyCr64jgEbrEB616wgY
	1NK8T05eghV003WXHfi4hxYwuJMweaqx7n7/rBUawwHJvVUHJiu9/LUMwPK77PEy
	22ZErQgOJyV8kj0+DkrRKkNdbSiJxEdtvFlhNEoCXctAArMlU65m9EO6rZqEmqC6
	R1ABVA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g20sj27gd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 18:24:46 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso924346a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 11:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786731886; x=1787336686; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pZ0ZCO0QYYFyjzNa6YQ0UARU0WyzWWP97iWFolq8hpw=;
        b=LAlt+2/Oq7I/uMZGDavy+0E1dJbJTrqm+Onjc8EeV+1/x0/6mVwerJSjzFOymqC98R
         ZK3iIB90cAzmBWZNh3qIZS99eSh2ZTad0rcqBSHq1StIgp0S2FqTnCvSh9tCD+NZNznT
         ta/789vfgB2tw1HtZqAPB7he4djI0HNqk460Q7uVyRiDINj+az/kxVaDTcrC6jQpZUg2
         +ykTzIc0gpbgw+XYG/h7dwik2vxqFffgikOU7h1Ih1JW45jltCr9ggHDrKuCbRxKnwnl
         B5CBREBmFyqsJpc23ke0WyhSdhHuAcRe/PNUz9qFb4LLOPn9n7DDiqZA5sMVW2ukkQ3F
         YizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786731886; x=1787336686;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pZ0ZCO0QYYFyjzNa6YQ0UARU0WyzWWP97iWFolq8hpw=;
        b=Axfp31iWrDIqXNVK9EVy38pUyjmwu5EVE7YmI5l+C/wXzSWMZTIDM2hu0t+u/AlyNO
         iDA/ji2AzOi1MjbaT7JOQ8A1x1F/6Ve/CnOvroBHn7nSL9gcnOOvQcvMpRfqGKUoMExM
         c5gjM2EdosIHLpdjdaf/WRZ8/DQ89FLhKoVZgsJ0Uuk+lMsPoqsBh/vwaWH5ONrz6dFf
         r6UCKMcseLf9kaYINaQZ8AeZnNQZ/x+xLj4L75GS2jm9wYpBVK+eJdTVIVJGOWM59oVX
         iiK7TffXuKR9DFF3auVybcxjbjem1pweL4eLI6qIz1Icra/6xrK+Uu/yqj4RlZraxxF7
         ZScA==
X-Gm-Message-State: AOJu0Yx3we/DX+uaCLG4eLb3K4Tm1O/3PQE9gx6Fz6qU+bIbJA6tod5n
	J+O5/3/UgUfUD3lpZqIYkwAjECPYa0i8Dmilt3s5TFdhChmoUSNKnyUKnJ6/ceF4kwPQFHQP4KF
	nu8T3MGnB1E8Dc3mN8VryY3Uj3QNTHyJJjgGx6CJZCUy7dwFju8vHGpTQTm4RJd1Y87JWiQ==
X-Gm-Gg: AR+sD12PGUUk4XchfJaSIeoeoP2xjSAsyq0Ln+h9TfV03HIemUC8vUNwPF+MHAOzh7M
	6ilJbhWKEYgIchBL/lCy0zFZdXcHa2F3xPGH4o0UK028C26nNavop4LZ8Y5R3cfDLiPA7+UXWEZ
	ngaUoIxDwmk7eJNOw3602DxhormlLjpm41ZIl93/Gx5Dy5abrq46Ja4cLbSIl6XwXFYQxg5oXbE
	754ZK0p/OGoIvTg70dMRErAqbYhIxLlpWjO/zwxzbC9uRmYWAPOIK8Djii1jwUkoellZ4Ov9kQU
	R12zLs+E3uhy5fUmyiTJtONHlID8UY3EKZMmJn9o9XiZk1k6z7UHyRnZLnV7QF98v8F8TdzR6Uq
	3f+w557B+GVeyq14j0YBVAQk/+iwnkmpqPMSjhIJUYTWAkQj5mKquhXPTzYGO
X-Received: by 2002:a05:6a21:6e8e:b0:3c6:61c6:8970 with SMTP id adf61e73a8af0-3cc71a89da7mr10359306637.14.1786731886214;
        Fri, 14 Aug 2026 11:24:46 -0700 (PDT)
X-Received: by 2002:a05:6a21:6e8e:b0:3c6:61c6:8970 with SMTP id adf61e73a8af0-3cc71a89da7mr10359254637.14.1786731885722;
        Fri, 14 Aug 2026 11:24:45 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320d5ff42b7sm7647787eec.7.2026.08.14.11.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 11:24:45 -0700 (PDT)
Message-ID: <30a72dbf-2872-489c-94eb-6d68828ec5e6@oss.qualcomm.com>
Date: Fri, 14 Aug 2026 11:24:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: add support to load shared
 firmware on multiPD
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDE0MSBTYWx0ZWRfX9d0sdK1kOdJI
 siVDJ8GgD5RZpmGpUObYhGp5z/8caXHOGI1GIqNmEVzZmA3QwSn6FApl2QMLdwlnlDqe7jEZ9CH
 mPN8I4+bctgOTnPgiD/vQG4ATvdnqutQdjnG6FZRXDw8yfQTf8+GcRgLG9Yvym9r0IcHQek61Nk
 iHvPKLqcGNhK1LYaHsb1TQ6RWP4Z9saFlx8YSiHfetCrXfdWwSxmXEgGdqAGYrMK7ZUgeFi050d
 RZi65StiGrsNECVYySwzlyEz54HeNyDBQsLP9dY5/eN9PMyFoFzLa0W3EwwQYXyB2V23povNpnb
 Yj1JB+zoLHZ+3Mvse3A+gTNrnl2/U6UF5+cR1WC33NbCyrBAKqwujwRVF11G5c55Rbke3VeTsMU
 nI5fYTbWr1bIifYYYoopeRY5Fgui1VovVolSDTTsR0o8qInMntEjxL5RNgy0YaCHovw7FMBJy0l
 mSqgcOVOU5var4NLfzw==
X-Proofpoint-GUID: xH0USR4UHaImTN2NL_qnqao9N9CKa0ic
X-Proofpoint-ORIG-GUID: xH0USR4UHaImTN2NL_qnqao9N9CKa0ic
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDE0MSBTYWx0ZWRfX2W6PcOidTis+
 kWPuVK3YxZp/4M1SMGLlIqKkf4pHzxsB0MWoIucc+sCi735uEHyjZC7gvN3yGDSGHLf2lzqLcKc
 Moo0m6+SVvuRI2NqeMjpSpfWaFNElIY=
X-Authority-Analysis: v=2.4 cv=cMTQdFeN c=1 sm=1 tr=0 ts=6a7f5d6e cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=RLFuG0JbbbH53d3NYKIA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140141

On 8/10/2026 10:43 PM, Aaradhana Sahu wrote:
> +static int ath12k_ahb_load_auth_shared_fw(struct ath12k_base *ab,
> +					  struct ath12k_ahb_rproc_info *rproc_info,
> +					  const char *fw_name, u32 pasid)
> +{
> +	int ret;
> +
> +	const struct firmware *fw __free(firmware) = NULL;
> +	ret = request_firmware(&fw, fw_name, ab->dev);
> +	if (ret) {
> +		ath12k_err(ab, "failed to request shared firmware %s: %d\n",
> +			   fw_name, ret);
> +		return ret;
> +	}
> +
> +	if (!fw->size) {
> +		ath12k_err(ab, "Invalid firmware size\n");
> +		return -EINVAL;
> +	}
> +
> +	ath12k_dbg(ab, ATH12K_DBG_AHB, "loading firmware %s, size %zd\n", fw_name,
> +		   fw->size);
> +
> +	ret = qcom_mdt_load(ab->dev, fw, fw_name, pasid, rproc_info->mem_region,
> +			    rproc_info->mem_phys, rproc_info->mem_size, NULL);
> +	if (ret) {
> +		ath12k_err(ab, "failed to load RO firmware %s: %d\n", fw_name, ret);
> +		return ret;
> +	}
> +
> +	ret = qcom_pas_auth_and_reset(pasid);
> +	if (ret)
> +		ath12k_err(ab, "failed to authenticate and boot shared firmware: %d\n",
> +			   ret);

my review agent says:
qcom_mdt_load() calls qcom_scm_pas_init_image() and qcom_scm_pas_mem_setup()
internally, which register the PASID with TrustZone. If that succeeds but the
subsequent qcom_pas_auth_and_reset() fails, the PASID remains registered in
SCM with no corresponding shutdown. The caller
(ath12k_ahb_load_shared_firmware()) calls ath12k_ahb_put_fw_load_region() on
this error path, but does not call qcom_pas_shutdown(). On the next probe or
reset cycle, qcom_mdt_load() calls qcom_scm_pas_init_image() again on an
already-registered PASID; SCM returns an error and firmware loading is
permanently broken until a full platform reset.

and it suggest calling qcom_pas_shutdown(pasid)

        ret = qcom_pas_auth_and_reset(pasid);
        if (ret) {
                ath12k_err(...);
                qcom_pas_shutdown(pasid);
        }
        return ret;


> +	return ret;
> +}
> +
