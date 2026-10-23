Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792725244;
	b=dcDJtsXn/yIkQY6JvwmwSxql5JSwCo1EIZuANj9XKUhLiI6zCVPmNhfHcFZ1LgqHCBXR
	 Jo8fTz4PxRUya58i1GG9795m5Kkied2gw4XS33mntzfaZK/U+HnFWYDY04itS3c1rEPLo
	 yjMkk8L7AA1cEZZKt/wySUM484Id7m+R8mZ9/tJo9gzITVDSvAhw7F+vA71gm145YOPR3
	 qi3vPwnJheNoikqqDQoSE6gfYR0A6DdM91MBTEol8y1KbkfvJremWzPQ9j8hJCxZSycZP
	 2Gy+6OmEpRaBDbg84LMA6H4hgFPoRWyMzemAuJ1HxuEwIRrKI2o0vWuRUHP3dmhgdZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792725244;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=y4QYmaKosc0eqCjBcuMLgpeZCWwCkKpgCeWv4X2n4lI=;
	b=uO+IV4r8nr6zn4Q4eLRsws4E8KDAuAdr/gLjwF5Lr4CUpJQ74V/wm9mWuN1LiBa7vjSb
	 PCld26ACBxoN+HIrAfuVLnu/BLjlEZPVHdNBVu8MX1QIZP6tDAiuKDG35YlEpZ8mgDncw
	 paMDIHDvoOPiMTSffq+2VYRQbnpmzz4kbsEmnVAs7eKMWE/3ow2nc5DGPTggZPeiyMxEW
	 MA+K5rrGxyVKeKghJ3MKf/iQyiU8V6pQhXjn+5DBtweIGrOrso6c/Tq88QY2yxjTEawwv
	 X+ysJPCcR4s9pdmIUgLACJYtfFVJz0T/jaFaK+zjIDv8YDGR5fZeKbD4M2p+BJzViHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="c2/0eV5p";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dVahHaa2;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42119606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42119606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=c2/0eV5p;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dVahHaa2
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1F3w41869045
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	y4QYmaKosc0eqCjBcuMLgpeZCWwCkKpgCeWv4X2n4lI=; b=c2/0eV5pBeOc3Aac
	EddJmSPcQpZ0iOgux1W22RkgzjpeZI1Lr42HNgnYCrpgIbQt8ZPT6NLWWtZmrP2f
	YRnUNQtEaE6ASOmGGett3lTRq+VmsbKIhzs7l0zkvMs98ROiJXlh24Sb2T7urOmk
	5aLXXy9bgsBFWmJgiOJHGlem53L0uAlcaiZ1M+80Wj7S9aEm94N6qb+ykILs9S0O
	cD0xIGTlwnKAvYOJDdEQjHWGFo8xawyXEky1nsMYGo3dOOu75EuGSqvx5rRLjEdM
	EWFb63jBRbfug+xSknqOasOkOVmrjLPE44q9tuM5sgCNqOpkmZW+DOR0sCyFMGdb
	cod4uw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmj9nw3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:14:03 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd0cf3b1c70so276124a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 20:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792725242; x=1793330042; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y4QYmaKosc0eqCjBcuMLgpeZCWwCkKpgCeWv4X2n4lI=;
        b=dVahHaa2mK6p5u7p8qrltX+wOVyVT+xp6a0q/LqOUGdpCgtmZtOyahtm61LXpVll/g
         qzwHcZW0DlqZYfc+bJi5b92QGLf4PpnzUI73zXeF5ZWk9RYr1Kco4WiLypiauw/kEyNA
         cCOFyTtznzWet/6gAT6w13aYSqGm1+qmmIO0yIRTLSP1MUSXYMIhv21EoLKn6RuL3v7Y
         FJaWmhPJRKGQnWF8VU719bkv9LduOE0cuKUrwA2Mhiq0jLsmF12kpKnJb2NhHD7ked97
         XAW4VPYqrfwYAVPNFgi16yQqi3cAqn3/qm2bR9cUEpsLB8aMm2S+aMHS0TDkRj4j94WQ
         ifGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792725242; x=1793330042;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4QYmaKosc0eqCjBcuMLgpeZCWwCkKpgCeWv4X2n4lI=;
        b=EBcrbdKEIU4wOpGiBCmwrXV90sn9HFyrWvBFa5FL3rx2vdO/pKL+KipsYtkRBQqA0f
         CZobKTut7yrUQI23D0fWVQdOd/1FzzyLZKMSqsuN1xg9AdpLtznU20fiqcX0RvljF2aY
         L1Pqr+LsQwlm8A0KXlCOWGg8s/nZxfzvTHHZCIaT6VsoF1Tgf1cXpTUPABdsyjXmiOnj
         5zXYbOfloek78BK03aT19xjjepigedz+QJGJDDtDRxSHBvyw2zYYwBbqFdRmT1ZhHvk9
         +Y8uKFD8+UqgxwGgr2kK5tzOzq1PJokkLkNd3MhVJHwdmbtK6BadgEdq2khoz1mVIoF1
         Xg8g==
X-Forwarded-Encrypted: i=1; AKwUvByk3Juae/irZ1hRo2vBQYTzlO34+pj6LQ1AcTEQ5KD7EXPsHCm8qwbdHKjVnwFXj9sAVX2IVbwNxfmy537h/Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJeOxdzSnF/Yzk07HmmKAJp/cWlD4kISTgxx0ThWO/bV9JQiL+/
	/5cJ0bwK7xtgXkpQehdKeDY7I5Y4pw3Uej5Dyx6dgcWZT3rhw7CsBnUDHPDWPObqLNrCgbLscrR
	V83uajj6oKr2ENmiggGAzkBsZlprSRazrxuVb7u3Wc/uoX9Ee2JC83xltFUmX8FGYBXwpPA==
X-Gm-Gg: AYBFou3NfvKcZkZtODPDwqBHUGTHSbeLyYGGKimoD/uB/ZixrVl2u0hKBW0so+ejX92
	KH87L218FJjpx2zPdGd+dlerwUqC02PRlGasESfvm4eF0pMpQ1o13EGXEJz4c4KH+SkknBbviYX
	10MQnKJhK0sW4yxbKpG3XDRzzZBFiKEeVeUqMIsZLPAIYgS6HsbtRHGJVIxYN/taN3T6w4P8GTG
	yBZ1NXwcE8Qb2IfhR3GDMvhRnzuWAXsLlKYNCD/JnD7hcIb0bJfXYJugO4wYOfwA0aFYSYDWj+d
	aTKMIeWvDuLkxOmDmO0f89ZCQGAKorw16675ov/2lk1VOdTzxmI2c6EAD9e1x/4Q+qvLDnqtyWT
	k25W5YuBcSHHR8aX6TP2DLn1LOnm5oXA6PtCjgAey5022LYxOc8rLRSKk8wwtYOvNr/7o/+ob
X-Received: by 2002:a17:902:db11:b0:2e9:a166:f7fe with SMTP id d9443c01a7336-2ea7cf79e57mr10605305ad.62.1792725242040;
        Thu, 22 Oct 2026 20:14:02 -0700 (PDT)
X-Received: by 2002:a17:902:db11:b0:2e9:a166:f7fe with SMTP id d9443c01a7336-2ea7cf79e57mr10605125ad.62.1792725241501;
        Thu, 22 Oct 2026 20:14:01 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b369900sm4424225ad.34.2026.10.22.20.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 20:14:00 -0700 (PDT)
Message-ID: <38fc5a6d-c019-43bb-98f6-ba6a667c64e1@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 11:13:56 +0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y> <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
 <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
 <atrJv0wgF20tmuDr@QCOM-aGQu4IUr3Y>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atrJv0wgF20tmuDr@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: s9TyBZhnuvGl-n6apP7fyhd1-pXFcsEu
X-Authority-Analysis: v=2.4 cv=cPR1IVeN c=1 sm=1 tr=0 ts=6adad0fb cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=0oYm2DgIxsn4U9MLWVAA:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAxMiBTYWx0ZWRfX9G6Xetth0q1k
 xZp/mATKcet3ecsYAZQrZTWs4089eeJj7rHoYp/OZc2BTZdVZ9DHAZSftQm2h3VB9pdkx0muSIt
 CT1O4Z0EvIgenTwKJ7O2AjwAvWOVPFU=
X-Proofpoint-ORIG-GUID: s9TyBZhnuvGl-n6apP7fyhd1-pXFcsEu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAxMiBTYWx0ZWRfX/nrQPuhOVy+V
 h2ptwYlU/GKI64I5TGrsEG3fh05EAnGwMIVWCDRKBqw+Vpo5Qi77mBxx7W0aGonPiZQxWxfr9K9
 Xy2bGbcwgGIowftWjUYWhXWi2NJYjT+OHJmdR1WuYl404L1aD7/CsIesjd/W6yFxrWU2aSFEYpF
 9U7JqEoOJI4ju7ETdFtCxSJEUKd2RaU/NhRvzwN/1PDkfmCxoKFt3gUYZvBkLmalkx2xqMRCFCQ
 UfuJiuK2hgY0/8xAj8m55rwUs5qt3mScLkqWy3IbYofnu5gZyb7bZloRw2O8taE9z7iQMQWRYnQ
 nN5mkQyOj+RmXcUhVO24TocgnWTXUS9FSyf+pvBalz0K+FDVQKfbbSKCF4BgMGDcYlZ4qs2JF8H
 e0pGRQ4AO3HwikRoMEgZbycmvk+HfsNSu6iuTlYfi1lGDOHPvpPtCTcL1qnJxFI9C0wVVVP4NXX
 uJvZRgQqS/GKPR0ZHqg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230012



On 10/23/2026 10:43 AM, Shawn Guo wrote:
> On Fri, Oct 23, 2026 at 10:13:18AM +0800, Baochen Qiang wrote:
>> On 10/22/2026 9:44 PM, Shawn Guo wrote:
> 
> [...]
> 
>>> I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
>>> the ath tag (working). It lands on:
>>>
>>>   15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")
>>>
>>> The previous commit, 643f0bf93617, still has 4096 entries and is broken.
>>> 15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
>>> and works.
>>
>> thanks for sharing this. I can repro it using the 481 firmware once get 15f7603b69a8 reverted.
> 
> Thanks for confirming!
> 
>> so the rule here seems that rxdma_buf_ring_size must be at least twice as large as
>> DP_RX_MAC_BUF_RING_SIZE (I also tries four times large, it works). This rule looks
>> reasonable to me, since WCN7850 get twos HW MACs and its firmware setups rx_mac_buf ring
>> for each, and each ring fills itself using the buffers all from the single RXDMA buffer ring.
>>
>> maybe I should submit a patch mandate this rule.
> 
> I'm more concerned about how we would fix the regression for 7.3.x stable
> kernel.

we can try to ask stable team to backport 15f7603b69a8 ?
