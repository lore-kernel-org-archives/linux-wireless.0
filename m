Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF30257824
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785681060; cv=none; b=GzHXbZhAB+REkxrqXEgADppvnHb7YPaZnw/m0R2yfD5NdQEv8mqZjIWfTT0QVgwBl4y26hyfaeZIZqWkhc+L91sNNZgPxz6c8oUXVz3VAy/RsZIljWOT7IZQA8YKmJZnnYQcMxD4VFb9j42/6WTaPnM76cQEwFVrHQIECFexnCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785681060; c=relaxed/simple;
	bh=4Cw5hHEtwE4SsTUeNi0GjrPqFYX5d9lInGn6AgWbfuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEbpENMkeVrq634Jd72TxUHW2OmQbLdBvbjca4w5IIZ0f4t0aE2l0a9qrSRB1u/Pi3ywY8Gccu8hfJMU0EDfJBTrOlFgmzWFGE0rnwZkZH4Te2MCroAhMFERK0gy7tQmPGc0GpyQhAEsUkFZkxprVT5nCKbwlLjlsIm1dxDbVXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q7KExOPD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JKby09y0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q7KExOPD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JKby09y0"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672B6fme1809971
	for <linux-wireless@vger.kernel.org>; Sun, 2 Aug 2026 14:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2wLRb9QYeLt7rsVJiN7hvsyaizC8vPUiUfINQ6ZucSQ=; b=Q7KExOPD9xdKlaiR
	aHN5+/9FPnOhdkYRb54QhiHeJJ+JF6g2m/nrGHslEFdXpta7P3skcFQgcVWppdxQ
	grVsxUJz+rRWcglAnpKBVdNcUpGO9kCEjw6uEnSGhgdJETMSNlllIMxvKcQNrfIC
	EclpJ5WAF2KYeYN9rmzVUW53rptyB02YUKTUpkdwK+4/LxVZc6uY4WQIFHuSZLVo
	vVlgDjATtOwwdYcGUIinMg+9cLOG4oUTzRHGuOK/pejMZR8ZGHO/5Z4m5grmFTie
	44Ke/jjusXT65rp1h+j97rnJWdzTSGzDy++Rxvli0aG0IgPtHRi2NrzMTaBNbw+L
	U8haew==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8q530xw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 14:30:57 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb4cdf95b5aso5139368a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 07:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785681056; x=1786285856; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2wLRb9QYeLt7rsVJiN7hvsyaizC8vPUiUfINQ6ZucSQ=;
        b=JKby09y0wDxr8WUAGnj214enHIypTcq9V7oIm4NB6+f5BdYX9qlwvtbrt0ijsEs0rv
         wfJW7GsitssmRLgdQ9KEVrJZE3SdTeq0N3wQiw7JeZMFSiTIkMCX8ipJ+8PPDNaN5a0B
         +pRDjGGfffDqkK5ypcoCr4sbSkNLSLm95HwPCaBIjSoe99WLFWrlNC0ITJuuFGu+b4fB
         BiyYB0JRrXsvoHsrvdSJkEZaYWFyw407I/ij6VIAJ7MUae+iq4tMMn80l7RwFSA9AjyZ
         hXdGRO0yHdXN0ylwPEPa2rOMxuIrdRG2nXFvDZY1iNrVscf6xoe7JubJo2mSIGh2l2pf
         e84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785681056; x=1786285856;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2wLRb9QYeLt7rsVJiN7hvsyaizC8vPUiUfINQ6ZucSQ=;
        b=BnAxU4wC8bGJMXszV+Lq+xrILVOKV264TWDPYF2N6EoDuJETwtKSe7SbWcnB5i1KFZ
         BqPDCFEyrNgM4zB6RHEszAo9OKaoqzrT2p0bbboAJjz9Wk7Fyvr8jUsFsgJ8P1CRdMZ+
         AikrY8Eq+Eh9lbYXWdkAY527WlUCfzD5Nz0xUysrrX+CkEWvsQCnSLVzc1YZhBcQnjCu
         xoQYHm2kLpnXi+SoCt/jBKjSYM83UMUYYH9FMZcvjJ2wdl+ylIy8VyXyJ3t8gHjCPGw4
         iQb3fFRk4e5dhrSs+k31rnSmVNrdmkybrVJIQ7K7fLvMfdLYtaDKlbwU3GCo2NIKlWIz
         I9Kg==
X-Forwarded-Encrypted: i=1; AHgh+RpBh2tzg5XjcJms56e5sXdtQ72xlxA2xRW4edQjKDA/OYe6JsC5DO0t+OkHRpy9gjq9Lh/c5Gc1zC/Qb6RqCg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjvhBogGS0sskdvwwV5lPwYM+96wKUmk9oltttn4kdfb5cd0vY
	+FqL15lTtOtR+AxZMk9ZaKsoem4nePHo3GNA1yP59vKLg1CGSJJv4K9Fb/lf60hmoKWZo0J32kT
	aNmx/xYptKnA3IcjezL/rhbXnOkg4Y+c6IxrMu41stc59JGAtUaOBUREoVW4On6DpXLg9mA==
X-Gm-Gg: AR+sD11vAaLa7K/z9PH6TKPQ4Y5fFvDeOjoOxVUmde+IXQfPK5/KUIyNHX/sMQYEKAI
	jszYxPBcnIqvyb2CVszPtvW1njK5LKc9dkQCDssNVNnfYqXFwI/F6jSHh6QYnLJRkZlx7Nck3vl
	31lLSUxv5tdsRhhMYGNUawokAQUvQQeCLodslQTLSNz0PsN23KfcZzp/hRK7k7zm0Zn2RHix2a8
	9sCzRmqTax3GmB1d8pNbYE+TXAuPatFMnxG1zlbF0xZITjH3KJTIvKtNGBbCmdF6rVV+4N/s34i
	BqQ/eP6Jzv0twUdopWExvn8JtHE02yKZz71wtLBxpitPORO1YfM3Z12718WXHW9khNX5LVlnOJs
	mZRlMRhAjqd/UDhe57/P5k7kmDsbZceX3GSnfyQcK4BMSpeUVYIZv869WYKM=
X-Received: by 2002:a05:6a21:a04:b0:3c0:e6c3:224a with SMTP id adf61e73a8af0-3c92a85cbe3mr6691734637.37.1785681056458;
        Sun, 02 Aug 2026 07:30:56 -0700 (PDT)
X-Received: by 2002:a05:6a21:a04:b0:3c0:e6c3:224a with SMTP id adf61e73a8af0-3c92a85cbe3mr6691704637.37.1785681056010;
        Sun, 02 Aug 2026 07:30:56 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e666sm40316903eec.4.2026.08.02.07.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 07:30:55 -0700 (PDT)
Message-ID: <bdb87a52-80ba-4f74-94f1-cc01881e0c8a@oss.qualcomm.com>
Date: Sun, 2 Aug 2026 07:30:53 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: rsi: Fix types to appease CFI
To: Stefan Hansson <newbie13xd@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht
Cc: Stefan Hansson <newbyte@postmarketos.org>
References: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDEyOSBTYWx0ZWRfX4mdNxNOEZf7z
 PFlSvk8YSE1qafTc8znB4hHbT4qNF22P3Uj4AQa8CzZstnTelcsSMeiVTix+bdFj6l17BWBpNwK
 sEN01g4ffmUozy52Pf8eD9a9uPvFjBU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDEyOSBTYWx0ZWRfXzODjiRJ5Lil0
 G43xw9/uTUCUxI0LL/vy0p6nOk/uyfUTCn9zBMrXrg07ujy5aYgwMyi9yr0zsfnStYOjf+BG4/n
 7Ep88U1pUzN8LI8+vKIs+Af2L6qmBFe/P2AlniZurXf10MqMoFmfap7IuanrWviaP0nIZ6p/sqw
 flZdBH7DpYe4v9Md7gNShVSmEWqlNQNupSo7OokHDTMR49+nq57N7LpuP/Q/b13ML9QkjURWeRr
 D6WNkXK2rSqDAXICkPi7YdOaA+FWRhhaVCWrgL1eSkdBgI0h743aHNOyxCn0Wwp7V5FJeaqv9VI
 MPw1QVn4eC9qqpv8ppu4I5DaVcP+LMwEx5hOb3DXFNEBjX9j6ANemookURriIR7PyIzEMi+W/PF
 QwBCsM2KahQy8uF4SnwW8kBLPqW0N8HhMzkrh/fTrEIOi3uWz7IZUKpT8Lqr1f53nekTsJEs6Vg
 9MZ52okd6IhCI40WUlg==
X-Proofpoint-GUID: 92V8ilqXtmvMdp3Enb9zh-J47StxuBBc
X-Authority-Analysis: v=2.4 cv=IYC3n2qa c=1 sm=1 tr=0 ts=6a6f54a1 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=Gbw9aFdXAAAA:8 a=pGLkceISAAAA:8 a=90mh4GC2pPR358r5yh0A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22 a=9vIz8raoGPyDa4jBFAYH:22
X-Proofpoint-ORIG-GUID: 92V8ilqXtmvMdp3Enb9zh-J47StxuBBc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020129

On 8/2/2026 5:22 AM, Stefan Hansson wrote:
> Avoids errors like:
> 
>     CFI failure at kthread+0x124/0x1cc (target: rsi_coex_scheduler_thread+0x0/0x1b4 [redpine_91x]; expected type: 0x89fb613d)
> 
> As seen in the aforementioned error this was tested using the downstream
> redpine_91x driver found in the Librem 5's downstream source tree.
> However, it appears that this driver is a modified version of the rsi
> driver found in mainline Linux and as such I decided to port the changes
> here too.
> 
> Signed-off-by: Stefan Hansson <newbyte@postmarketos.org>

Having fixed a ton of these issues in the Qualcomm Android downstream driver I
was going to give my R-B, but I ran this through my ath.git patch acceptance
process and it flagged some issues, starting with:

WARNING:FROM_SIGN_OFF_MISMATCH: From:/Signed-off-by: email address mismatch:
'From: Stefan Hansson <newbie13xd@gmail.com>' != 'Signed-off-by: Stefan
Hansson <newbyte@postmarketos.org>'

There are also kernel-doc issues noted below

> @@ -246,12 +246,13 @@ EXPORT_SYMBOL_GPL(rsi_read_pkt);
>  /**
>   * rsi_tx_scheduler_thread() - This function is a kernel thread to send the
>   *			       packets to the device.
> - * @common: Pointer to the driver private structure.
> + * @data: Pointer to the driver private structure.
>   *
>   * Return: None.

Return: 0

>   */
> -static void rsi_tx_scheduler_thread(struct rsi_common *common)
> +static int rsi_tx_scheduler_thread(void *data)
>  {
> +	struct rsi_common *common = data;
>  	struct rsi_hw *adapter = common->priv;
>  	u32 timeout = EVENT_WAIT_FOREVER;
>  
...
> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
> index 25c2b232394a..513d2fdfb510 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
> @@ -25,8 +25,9 @@

above here update the documentation: s/common/data/

Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 function parameter
'data' not described in 'rsi_usb_rx_thread'
Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 Excess function
parameter 'common' description in 'rsi_usb_rx_thread'

>   *
>   * Return: None.

Return: 0

>   */
> -void rsi_usb_rx_thread(struct rsi_common *common)
> +int rsi_usb_rx_thread(void *data)
>  {
> +	struct rsi_common *common = data;
>  	struct rsi_hw *adapter = common->priv;
>  	struct rsi_91x_usbdev *dev = adapter->rsi_dev;
>  	int status;
