Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238845;
	b=Hdt/MK3APFwvAjE4yX8fS0mYgSsh/Sc4d+Xrt0fAp2GbXTcjebNRrZaF1qxZ7PitAeHP
	 Q11mputzSIZDFJY8WXPQ7Y/ozqiA0sT7We44uf0KoCGyl42+nnELetRcYgJW6sZSv/gHs
	 /s7kv9XPX7hJ2v17p562zkVJZ5ASJ0KXIiR+bNIQzMI83k8Wk9u/3NQiUcwrtjRi9RWmf
	 X+mcbFJPFR5cjKPhKEbwyXlDl+mKi+Si07gmXqOH3SrgmhTGzLXijQb5MIU337H8yVwwi
	 FQuurnOjvP9tTpAnW1uMLUpD2Gvin5CYZ5gZ75RxsPKi8+S98KoTF6mkJzb7/Ub9MhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=49SeZ333tsPITIB8snkOI59M7shf/qo0S4AZopCi6y4=;
	b=jUxpnnOZNzB4IsAhDzTeH5cr8Z6r5Z9zupS8iHta/wD/f1SPYYS7bjWl3T+SPRcQuVdF
	 0MC19gZPMxatbICO7UeJhm+673+jpWlgem6+ll+9X98GE4r0O1AbxRUsHbp8WSI/OZdx+
	 aGyhcu1JULyTZHW0M3wjxjzhu6mugBMqC9RsYa5uBKagGx1gqf7PZ745DbncfgSdrZ3Cs
	 mRLJcabRtutliSYJ0iKDYTM1PHYoaJhHfSUpZuxox4Ag8h/3qfdZHUqvmxkj0f60kunaN
	 Ottgg8LpAYvKt0VD2Sep4k58d1wH+nsfd/3vJL2b8ZRhARO3NADJiPR6UOsILcsrHGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hEUUBp9V;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JPQIDwBD;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A14606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:54:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78A14606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hEUUBp9V;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JPQIDwBD
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T1jWQC1975022
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	49SeZ333tsPITIB8snkOI59M7shf/qo0S4AZopCi6y4=; b=hEUUBp9V+fVsVHlJ
	pJ3AL3HGzUS7sYV8sj0idLPd2RHUYay7AJSUEGL3VVdbF2piXm4GJndl8C7KkaJO
	5hJNs5NjH2RrkYi2UHhWYDoQZzyO+kR00gWFVhfm/PiPutgc6vYmEEBOYQU3qf8B
	pp552ade0Xn/cw9l3Om6fJBubtHyJlYhWeQChbOOt4pemsFw82gFTJNg8lUN6uD/
	QRPEW5Dd6Q1bJms+oDKnNniG5xNCXrryFnv6V9a29fp3Bph8O7nQh36r572f7QlG
	qrAlKdi8UHMKAZxq9k7YLst6em2/qa9T+H+dvRxtpDwKZPL+rnLnV62BEXUZBG74
	m5+b+A==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hknb29s6y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:54:04 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36a1e2485fdso3469308eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 18:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793238844; x=1793843644; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=49SeZ333tsPITIB8snkOI59M7shf/qo0S4AZopCi6y4=;
        b=JPQIDwBDd6oKeuSsAEEs6CO8Nxs2A/NXEVUe7JoEXb2+A/0mnXQgQEgVpxfc4ahJ9d
         /ckhi6Hb2nK707MACWQkjC+hqfmipjxHPG2CuGg9BMGOJrhkOEXeSO7kHKSFbQofa7dO
         nv4ljWs9qbasy1bayr7DZKCvSkKqSfVQTi/72rH0pex95X9KBR/UAkMaIccCx+4Fshad
         l1i5LeLhz3L+uucCRHP5wfiXVqgYSD9QKzdzW3cDvApq5CCtC7JeaSMyOpzB/6V8ZyPU
         1gieUcC0TDopMIy9EuzuZpmy5QhfQ6T+aJ8loqU6HieVHn1Fw25crBWghmMGmNaRePzK
         ZdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238844; x=1793843644;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=49SeZ333tsPITIB8snkOI59M7shf/qo0S4AZopCi6y4=;
        b=OFdmTMza7+C2hLukxSNFe2iLyk8HKUZvtVZvRiEHCmTVstXvdcbF972xS0Zw/Ip4/f
         /t/ArZxmxAGd5USgQFlzjvEZODfBra1fKsp1dtISdzs6oh/JoPER9PF4mjVHyeTLp0H4
         RC7Y+Sl56Z+5xmh/DSUlGEW+XM7GHUp0jcfgeqo866bW6RMOfXywtCXsXs3VheJp+Imb
         1oog7/DZWhuHgDvItsdH/IBi+WIWH0m5lgpzTPPxOeRyE+VBAVNSFAZvu+XpZXhBcNKB
         3GkfwFf2h5v1xvTtNxtstNug+LL/seMj374qll+qLPzm/rwF10WfXOtqRb2r2donyzwU
         5EWw==
X-Forwarded-Encrypted: i=1; AKwUvBzaAGavLJogH6R7KKEIn72SkUX4yL96ggNzuDwP9NjLV779kYNr5TZbSCkT7nPHCKOo4hHeYlFOIdqgJOiLkQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLA9zaDB2ooPNU66xas4qb/eI8gyPe+m6esHxI9HZtoxYvM77PD
	sp4CqHNRI4tnWAHfIBo5arTxUoigcwIWq+6LOuGfbzpx1OeTWVeZ38be46U46Rc7ZmavYY3nenJ
	RhaSwY66ikO1zkmfkApGOLtIqs0UJ71+MP7w3n0QqCL0WWJ5cjwLk1qzgbWFrjzYnYzg/eg==
X-Gm-Gg: AYBFou3fizWoMp0/IPYAa1nlTu5opgviHQ85lVNDlAljT3fzIM+kvEL+dY21Bgw1Qli
	siZ2ej31lqkhMih5i3XzBQkFrcQ859eW6Z8Q6GhVgYHY4Ud0X8cvblVCLSCXtQCcnowYtYDsTDK
	hNL5foqBM7OsaoK5mCmJaB8i94ch3wy+kMtgFAn1i2DVk1gf/bp/8hU0TPdpJmMvuzrr/kkA2sE
	QC0gnG/F5kBUBzZ2CE3mdbhDxmX04zjxp89t5sgeoJgIC6HOBvgHx5mjk/e/caQ7zU16hapvGbG
	fDrzZyS7UVvbrtovRiLSIPSRpJND4FyBp9RYKVHSyOhjKs0yEs3BBL2Dfzii82k5J5Dpavoo3Yf
	szs2tvvmKnumgWRgHnNr9gtVGInJN9T0Zhfc6Liq2UI7UBn3DbbF7SP43HmZeQDt5F74zFiZzuv
	A5UqhMlF9S+ArGxMkPC2/cMMcTdBzSdmk=
X-Received: by 2002:a05:7301:1441:b0:369:f419:e7bb with SMTP id 5a478bee46e88-36a2042919bmr4915325eec.39.1793238843632;
        Wed, 28 Oct 2026 18:54:03 -0700 (PDT)
X-Received: by 2002:a05:7301:1441:b0:369:f419:e7bb with SMTP id 5a478bee46e88-36a2042919bmr4915292eec.39.1793238842901;
        Wed, 28 Oct 2026 18:54:02 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a237bc445sm10671612eec.1.2026.10.28.18.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 18:54:01 -0700 (PDT)
Message-ID: <ee500109-531f-4eec-be51-8bfa7b85c936@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 18:54:00 -0700
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
Subject: Re: [PATCH] wifi: ath11k: Reject short management RX frames
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
References: <20260926114037.3231795-1-yaojiale02@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260926114037.3231795-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Yu2a1IYX c=1 sm=1 tr=0 ts=6ae2a73c cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Byx-y9mGAAAA:8 a=s4eqi859e5GuDqKmwUEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: H4wY5pgxCe4P0VE7f2loEuzG4LCnV2mv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAwNyBTYWx0ZWRfX1DF8n7E9ZNZA
 hTd96G5u6EgCa/QBEitKiG4DrkqAJl1M334DORC931xX35Sl7+ggiS2HFULM+8BoRW2e0FwkTEO
 H5OEVS+DWY9zKhknskJA6ARsVXGu+c0=
X-Proofpoint-GUID: H4wY5pgxCe4P0VE7f2loEuzG4LCnV2mv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAwNyBTYWx0ZWRfXyuHrwzNxDHjL
 4in+yVSRIVd7BiVw5uGpNgcZ+ShQHjzpdY3/bub5cpynn4CtMx9qPHdEeHyaZ7eUky6K8Hz5Syf
 VCBP+o3VyWMC01v2FS0FHAEPaduPBLel/5x57M8bA+njvmVic8B07hneKJgMvqHZ+JntMeU3q2r
 uIbMJG/E6tbuxV7da2iK3vnOdw8f14mzfIz2fi7YKcPD0iLE/Rh8+IFkKPdcLD91fgl3gnsORUs
 fge5zzMnuno/xXPmduNYIa/w+fo7r1rFcWI3h4Eh08E71aD3Fw6GFNa1mX+AQy0f3fmicpnriXy
 JLSe+q1RvvJENlU79QJCtdkg/KG4s4MuEI4CzafsQqAF+a9mZ1IdRPB3MLqrEDzGbnt+YsvsZ8V
 DyaSEzKf4ErZaFHWDXwMnUWwBgR0wfFheGnLLVmDWSN9oHU08oLe5rmz6CX7u/eCkdvLgLl9Q+5
 LnkBpIaOcsI9/6RyVww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290007

On 9/26/2026 4:40 AM, Jiale Yao wrote:
> ath11k_pull_mgmt_rx_params_tlv() verifies that the firmware-reported frame
> length fits in the WMI event, but does not ensure that it can hold an IEEE
> 802.11 management header. It then sets skb->len to that reported length.
> 
> ath11k_mgmt_rx_event() subsequently reads frame_control and other header
> fields without another length check. A firmware event with a short buf_len
> can therefore cause an out-of-bounds read.
> 
> Reject frames shorter than a three-address IEEE 802.11 header before
> adjusting the skb to expose the frame.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/net/wireless/ath/ath11k/wmi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
> index bbca275a8289..02cd9764b6fc 100644
> --- a/drivers/net/wireless/ath/ath11k/wmi.c
> +++ b/drivers/net/wireless/ath/ath11k/wmi.c
> @@ -5995,7 +5995,8 @@ static int ath11k_pull_mgmt_rx_params_tlv(struct ath11k_base *ab,
>  	hdr->tsf_delta =  ev->tsf_delta;
>  	memcpy(hdr->rssi_ctl, ev->rssi_ctl, sizeof(hdr->rssi_ctl));
>  
> -	if (skb->len < (frame - skb->data) + hdr->buf_len) {
> +	if (hdr->buf_len < sizeof(struct ieee80211_hdr_3addr) ||
> +	    skb->len < (frame - skb->data) + hdr->buf_len) {
>  		ath11k_warn(ab, "invalid length in mgmt rx hdr ev");
>  		return -EPROTO;
>  	}

If you're interested, my LLM says:
## Observation (out of scope, worth a follow-up)

`ath12k` has the **identical unpatched pattern** at
`drivers/net/wireless/ath/ath12k/wmi.c:6489` — same `skb->len < (frame -
skb->data) + hdr->buf_len` check with no lower bound, feeding the same kind
of header dereference. The sister driver likely wants the equivalent fix. Not
a defect in *this* patch, but a good candidate for a companion patch.

