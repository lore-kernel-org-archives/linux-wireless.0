Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF9479867
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 19:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761352; cv=none; b=R/3BhxO0mm4hyHV+NA1utWEkxJT3sLOKn+B6VrpF7PxBqPI3jupoOEGCWjxF5MnslgOTICJdLkO8tVIEsxCfTzAoK/KNR1yjAYMLLa6K9aEo+FaF3ri/BMcFhK2EvYJJOdUWfbFvGiGzkxhiAlmpuSTDQj0GbaUQRW+AOxCfYdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761352; c=relaxed/simple;
	bh=YMWjy8npfAa+E/wV3UL2YF8bCyiSn5obCw72+KqphjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MiBEz40hztctkZl3kkywxYP8REQ96Za2ZHkXUSYJgyAVJPUPKfGi2JF9opbii1VM0T573S7aHktNjiSZ8qGuwNJdItJXT2bxWUk6ab3RsnNi6+Hj9cM/koiltrvJEL3YBazGNXvjTUpbLx+o17ROoOMNy4PzZ84AUiphJO6EuKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OvNY4cmx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gOwZmkLz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OvNY4cmx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gOwZmkLz"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68II09mm831684
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 19:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YdBIY0uUQqeSgElDaNwdALJQD/ybwZDrWoGNgtgXY68=; b=OvNY4cmxvVfPVYZI
	Je7//cTN1kMWGH18ml4TfkNLffwmAh237zpuYJ+qHuLZPDmyWoLpvfcKn/tvsp0H
	tjZaK8+9fWKk4qFQpHAX2nkebRM3bFr279n2KGr39TjS+5PaOiC1EKzNUiJ4diVU
	OATphmxCIeWSmvxhTbrBFv8hhZF+n4/isG6v6weAizv92WbwXRJ7NtVGOlgZWsnD
	5u/i6Gg+RSKJxEZCt5/daH9ggQNamFbe3PqNbh3yDejIR78JDSUWQhchpxQDE2bl
	Ij11X0NWOoFp5rNzhFDco8nmgc0ntb8VLyKCVnzzoPWfeTpVYpYBH3lmsNnfth9o
	hDUcgg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gsa6mred0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 19:55:50 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so2063362a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 12:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789761349; x=1790366149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YdBIY0uUQqeSgElDaNwdALJQD/ybwZDrWoGNgtgXY68=;
        b=gOwZmkLzVX92DOBvSYfGxklsPMy0owXT2B+RR8Zp1wOQvqu0LFfpMauZ2FikxCJ5Zs
         KhBLaQGZV+ULP1tZFuEy4UAB97uZgJybfImrCaVEkrBU+2XDKKS0sk94JGmI+n1E+tn2
         +kc9MATZHvvm1o+bvkav6L0r40cIh9QYdX3vRQfiZh4+uyokEqOVBq0FrPrhIl+svhe+
         f0PGcl9SFsX+VBVYlHJOdxczbkVJp5Q2XBp64G7sTFD7EMn8nlGNM6yWCH0HVwPG3Nak
         hkdkaIwusmvMkEcrou2CuNJ4/TAIIF3meoT8ZY5mhM1GXXhvCmOOSyocBYHt3F+Wo9Tr
         YeQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789761349; x=1790366149;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YdBIY0uUQqeSgElDaNwdALJQD/ybwZDrWoGNgtgXY68=;
        b=HJ8hixOJiTf8/hugXoFqO/YWdbiPvVaEdFyNpv9av/VLhWOL8VPYqECa/WGApM7hrZ
         EqymauAwUvgcy7XpQujfWfSTrqUyH3ZW3YVHSXWLnS3ah60BEjCMROD96MwnrZYBhTQg
         qC/hf5S1oGPQE+c+pKghhpUl6b9vRQsx1cHFf/FS/xYk8Ypjoa0f55KBLYK26kdDBmLV
         5PL/iuPOoXJKaE6TEzXBMi8xKaWQEKZ+WWkOfq10rFLut6v/mYPW8HvdECJtbgjZN9WS
         QQz8KhUVfzJxiU/pj/yPonJzDnBGkFnwZKTdnlJFTrpJoiVYK9QZSfnyDvtN14u8SKvb
         SNgg==
X-Gm-Message-State: AFuF++lBxHauKegYetwBUnKycliPDM5tS1YgW2slj3PNYQpM7qVBm9VB
	+JMQPgu5zPNk9eH8XdDYyuY9lo5UT1ubXkgN477ibSvYnMFoe9Ecwubrt0WledkWySGY/gsIevY
	JcnFwrFGyrlSJPLxttNKuK8cfVebbyUSGQ9OYXNavs3uRX4Mfp1YunW3kyyv9lXSWitPWlg==
X-Gm-Gg: AYBFou3/FawsRx9HjrJvigctJ8Yn+HYj2qzbOtX+ZlKZWbdPAk1Ro8PZXjhHpgOaSZp
	UMiwEt3g/MwFbWl6hrnGoy5AfJVgwaO9HZfC2OeY/ljG+mkpdvvSnnv5ur9l42TjSqPq8FUDZ0a
	86z5Vq1eVuX5Yk+FiUa5SaB//aAq+2IIgmX+t0EoJ2a/TBmrlREoJ/I4EiyAVLOJIV5JCGoc7IS
	+HyZN4Op7wZB/d5Zym9/XPl0S0+4gf1dBEN2fYkn1NuvZ8qsgGgaPCtPI4UpOtods85qYmpMQCg
	qdbQc76vwJBoVZ0prG/W2SkiW5a+/okRANmV6HwU7yhFZozhsy0dSnodcCxX1zRyZijBqbVaSL8
	My07VYuBFPWK0VPidlYXBt5PUkEegb8pM6U+tlL4Zx/WZM0aDmNijBDWWEA==
X-Received: by 2002:a17:90b:4cc3:b0:39e:6a7f:eeee with SMTP id 98e67ed59e1d1-39e6a7ff08amr2505536a91.19.1789761349425;
        Fri, 18 Sep 2026 12:55:49 -0700 (PDT)
X-Received: by 2002:a17:90b:4cc3:b0:39e:6a7f:eeee with SMTP id 98e67ed59e1d1-39e6a7ff08amr2505480a91.19.1789761348865;
        Fri, 18 Sep 2026 12:55:48 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d54af4d5sm789458c88.2.2026.09.18.12.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 12:55:48 -0700 (PDT)
Message-ID: <8420a701-1cd6-442d-8a24-d10d2013b998@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 12:55:46 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath9k: reject short WMI command responses
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260814075837.20005-1-pengpeng@iscas.ac.cn>
 <8c2dbacf-63ec-428c-b283-50198579cb89@oss.qualcomm.com>
 <87cxucuugu.fsf@toke.dk>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <87cxucuugu.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JTpn7-nHEq4v_9DXq6svsGZRPpbGt38m
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDI4NyBTYWx0ZWRfXyPHzu+WcE6uG
 I8pnPn7Ci8uQZar/IsTVG3cmTLBmu0jgPGqaayVEj0RbIaFBzQprJJpPhL4FK89FfOf+evFk+Us
 12iZrk8+06PRPRs+ozWErpREaNHJJAM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI4NyBTYWx0ZWRfX9EcmZGwyokzb
 fVBt4GkxVlwxQsJnkSnyBwyDoBYWF+OLbG2j8/SuPzh4OrJyZU959RxsuQ84pI0Z2sL1zYGaSHA
 +KAEW7KEsA1rYUWb+ml0TNWxOmktG3kF7Tb/GFbPt9n9Lr6ykb6zz0rSmj2gyHaQSdIzZcI1+s5
 tErtHJOHX3magI2eeMBjmJ9iGSwlMXHVphZBd+xfndB3ub+IF5qUsbqkEcQr+gJthE1ixz5INci
 pplbI9qGSnCmiEX+K4F1XiOo4+SLJZ9rUis3OM7CwxDBJLmafSA3fRwpgk2udomqiUIEL+1KPyK
 sJRjUZ2ZlYX3w1iOUR0/arRANWafMjq3Jp6pJPLbh/HBnyIyKPM8srds352CzFLOVoctb5Bs5Mr
 5DJI5zte/TE4JWQph7daxXT1XqKZtjAqJXANbOpvwpHACUqaWdW4edbp0a7TdqsmPaShe6+yJWB
 9h81BRH+gyf8ObR0AQg==
X-Proofpoint-GUID: JTpn7-nHEq4v_9DXq6svsGZRPpbGt38m
X-Authority-Analysis: v=2.4 cv=YYAodARf c=1 sm=1 tr=0 ts=6aad9746 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=VskdBMQvDhfuwUIC9LkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_05,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180287

On 9/17/2026 1:56 AM, Toke Høiland-Jørgensen wrote:
> Jeff Johnson <jeff.johnson@oss.qualcomm.com> writes:
> 
>> On 8/14/2026 12:58 AM, Pengpeng Hou wrote:
>>> ath9k_wmi_rsp_callback() removes the validated WMI header and copies
>>> the number of bytes expected by the waiting command into its response
>>> buffer. A device response shorter than that expectation can therefore
>>> be read beyond the skb payload.
>>>
>>> Record -EMSGSIZE for a short response, complete the waiter, and return
>>> the stored status from the command path. This also prevents callers from
>>> consuming stale response bytes as a successful reply.
>>>
>>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>>> Assisted-by: Codex:gpt-5
>>> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
>>> ---
>>> Changes since v1: https://lore.kernel.org/all/20260704011405.55089-1-pengpeng@iscas.ac.cn/
>>> - return a stored response error to the waiting command
>>> - retain acceptance of replies longer than the requested prefix
>>> - recheck callback synchronization under the existing WMI lock
>>>
>>> The WMI callback and waiter synchronization were reviewed statically; no
>>> ath9k firmware fault injection was performed.
>>>
>>>  drivers/net/wireless/ath/ath9k/wmi.c | 17 +++++++++++++++--
>>>  drivers/net/wireless/ath/ath9k/wmi.h |  1 +
>>>  2 files changed, 16 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
>>> index 284e8c13b043..06d9975f9717 100644
>>> --- a/drivers/net/wireless/ath/ath9k/wmi.c
>>> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
>>> @@ -206,8 +206,16 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
>>>  {
>>>  	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
>>>  
>>> -	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
>>> +	if (wmi->cmd_rsp_buf && wmi->cmd_rsp_len) {
>>> +		if (skb->len < wmi->cmd_rsp_len) {
>>> +			wmi->cmd_rsp_status = -EMSGSIZE;
>>
>> my review agent notes that if this path is taken that there is no debug
>> message alerting this. see my suggestion on dealing with this below...
> 
> I think you're being pedantic here. I'm pretty sure there's no real
> hardware that does this; merging this is meant to protect against a
> USB device pretending to be an ath9k_htc and trying to exploit the
> kernel. So I think it's fine to merge as-is.
And I'm fine with that.

/jeff
