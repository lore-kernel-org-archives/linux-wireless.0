Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792564848;
	b=A+0GZFsb0XNWACae+sIlGAR6bjBTMn8ULfuAiJP21sdtjs5QoKcLXItNUfCSlYFzmiCX
	 3WDv3T3O9zp3DUu7QsiSd8iW28368hZlbE84fpC54PbZTatytTyc/XEh/xrkuStGcgb1H
	 Vc4lhVF1Lr24C1Ut0ze9jeUsE/1mzBdKZPjBi0MWJwduSQ/UK5nEBQ54jsubYP/3iYvL/
	 qHRptlPP6MrwmPYLXnvtX4HmwYWIIKXw+7X58aeYbg2vPjtJ/erXpAHIS2Ae7Wv+bbJ9p
	 7YiWIisTe/XkCASZVA0f/wfUEtZL3LImkHiENxzBLfpXBWKvkTbWBjREvX3gB1UR6KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792564848;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=wDpAq55gb3RVcVpMzZxojIe1Vb00kuflJMAc87sfmMQ=;
	b=Fg4lKe6R0P+aygI8RzjC+jGK5wTQwHHOdT8183sZ6kmtTSqf2fJX+XQ2zQakUhJ52IL8
	 iUmuRcHBO5UW0o8Q4nZ264eOMJmIiCCzTiaIBUyW7OuxK57L45JEE7FSh0Qenglyp3m5Z
	 Z9Yy1F6EAsSY4yykkhtmiKfBtYXR7+jmO6F8tYFODKgbiTKw8ydvIur//0yrMT6ebR8Eb
	 lXhJBvKV35equB+KYpjUwLgxoSUikzraIeRp2o9aX8DQZUk/K7hDkp/cqsJ3aCwkaiokF
	 uk0P/h3CksRa5qNlW/7Qkgr4RJ4918ctAFGMZd5BbbhqhtDYysTEZH+wLzjgj8fb8cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="c2/iXYyb";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ULDLFrfp;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DB3606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23DB3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=c2/iXYyb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ULDLFrfp
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5j1043355615
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wDpAq55gb3RVcVpMzZxojIe1Vb00kuflJMAc87sfmMQ=; b=c2/iXYybx2H4VDo2
	AJnWd1VpVihNJxW+swHw4BBcnyczIydb2RZJ/c+BpgT7YYn/46wiFS9XCFLhN4r3
	+WV5Zo2IOvFC6OZMbOFWFMTlz2EE7/JJevisRdlpzAY1wfF7UqjxWWc5CA/uykZ8
	96wxU2tfG1c+pRiVbXFPJI4GvJKgU3nwnUGUaPREp1Xu9iJSl67eCKI6p4Ukjnwf
	IsjcOLM5dhTyRVwWO6oSuAq+Yye/cFKbqrXY7vApgLSSGWNaMw2jIiPvthxaZfzS
	NU4ciQxbfRF7eUOZCdLHsT497VZdMfNpB34+Qs0rl+cqAoyn4Nq8+OdrH0W4Rl4E
	pdGN0A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heda0jbtn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:40:47 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ac7a4ba546so998690a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 23:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792564846; x=1793169646; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wDpAq55gb3RVcVpMzZxojIe1Vb00kuflJMAc87sfmMQ=;
        b=ULDLFrfpdvC+pbLeuhWGKqMXkFm/byG/BBPxU181U5KjKJvqQeEv7Qwlh9s9LhzRQQ
         6DPN9XspcUBFsWL2bfSvV8gX6I7WkNmSzMr6evLJEjbU1ap7WJ1gZW4r8v/IzfLmnUdN
         zWu3pjejHPlUR4zWqGl8CGVXhn18rLpIwsDa8MDCSI4MKFcPyzNbpbJBrw2uEA1nMaDe
         2DoSyXFlT+ZcW2QTfHQ2QeII6kAGFf6CMuVh3E/QjqLhfqsu8BuHXXFQkuAtb1BwAcOr
         3WllXkOhcYU2VsyO3ETkUW6b5xMdF4x7YytYBafQPPFCEGoV5W5fJM8YhmIwMvKRgBf1
         CkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792564846; x=1793169646;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wDpAq55gb3RVcVpMzZxojIe1Vb00kuflJMAc87sfmMQ=;
        b=P21YqRw8Sf4ZjECOunUWgmdj9zUs7EH/UpPa6nIQWG39idnfGIqb6lSqV2uhL+fxVA
         veswMZeZgYo3eqlWXHMp7Q9cOuL468wKf8msEDxiVemdQo5u0833QxE2CPIiVljxbOaG
         OBDgwV1sJoVvlWxUJRMlFJ28JonSgkLiy8z+1AU3AdcMY8WjuEpDBvZXWWRfJkdGLi2e
         h2FFcJFNo8MAZu0Ujtuorztl2XSAkbys4MXDcOAducwPPVzZV0e1X46GD8t/ZEn3mHkO
         02QMF4O+r5K8Qog1X0VbfQNHrn/UIJJ+aJU2rUb2ssDSLcq+q4iBM5yKukoSX87KZCf6
         UfQQ==
X-Gm-Message-State: AFq9FYLraY7fP+UR42JNvJMUKu+xef3TDSEpEtsbqPznVbrlO9yZg2i2
	ln0FRn2T/nPhur+48P4psfzp3ZXgC1YNKbFVYPce9kqoJrMrzrfyrwLSK+8ttH5KZieyKupZNqr
	ocCdvYDPcESqpkjM5CDXVw3H55SG9kwhMDr66EqwW+vCWIS8/zaEE8lbpG4si3o2QeROJCRRmQO
	jyamFj
X-Gm-Gg: AYBFou2UZ1NLhsRUpRRYjdGdeT6PHuiiYd/loGoSFnL+CHnarv/Wgbt06xo6j3chZFB
	08u+lBQmoQIbnteocnyxahwCjeb8yiLNHQPET2XJtD1ewTbsOkwf4zIVtJ6Q5KdiDTrCBR+f9ci
	R/KnJiiEuks6htVqi1HPxaTwkbi5nTonY7zNrg0lU5QqMG5uVXfCvqz8UxIYvqlSeNxZMk76a3m
	5gfUjq5poPSCxJzHQ5xlR+Cp/kgY1rHbOVS4yW0CUG6hwAJrgY+3sLM0TX7kXd9GQWQkblutXCi
	Gkj13u3BrMOIlMLsdhz8aAliWAIrEkRpok23YNxT4jb9WKog5DmcJdoOqGQuRfhVcR62uStO/du
	JBujdb9GCJPvui+CEn6QS7CkgzuBjees7p2cJpjxjHfoRzZSJY0weVu16ELDYhemMZ1A=
X-Received: by 2002:a17:90b:1808:b0:3ac:8b67:185b with SMTP id 98e67ed59e1d1-3ad86f199fdmr667125a91.26.1792564846499;
        Tue, 20 Oct 2026 23:40:46 -0700 (PDT)
X-Received: by 2002:a17:90b:1808:b0:3ac:8b67:185b with SMTP id 98e67ed59e1d1-3ad86f199fdmr667122a91.26.1792564845959;
        Tue, 20 Oct 2026 23:40:45 -0700 (PDT)
Received: from [10.133.33.35] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad80214aefsm2860239a91.3.2026.10.20.23.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 23:40:45 -0700 (PDT)
Message-ID: <bfd4a179-6bff-4d19-a2f5-233011f235ac@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 14:40:42 +0800
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
Subject: Re: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
 <5495071c-8255-4ff4-80d7-9d9f221935c5@oss.qualcomm.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <5495071c-8255-4ff4-80d7-9d9f221935c5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAyNiBTYWx0ZWRfX6T3oD6l7zB27
 fFNRQq2fOILNzlpIPTAX8nrIfUcAzkQfcOC+DfOAE3VkVUFv38+WKfUn0ZBg1LLMxY6QbXn8eyF
 VtsOQY8E06jaZ0L7ZFWa1f7Ht1WwdWQqdwgWuJoktrXcsGFdK8nwpcO6c9sneN5rLsqtzGaihe+
 OALXJe1DW4+MxDBoqgfANA6oA3HsTQEY4hzZaOVNWeirNubr+4Y2T6X0mCVcwSxStIKanSB+xVb
 jt4D/JdlLOclwbJtnaeBl/99lwVmDpB/joOQlddQ9MVwVN2v6yUnLMH6FCGEXNOHugFvyyuaHRI
 xE+6WuAO6PDxS9TW3bYgR8uATWke2bvQaYl9x/0u3jYRGJFr4FxqTtJ1xIKEk0zoyw0/S7c8Ey+
 ZjptU6l5pYCaI7LJAH2W+UaEDSFfyM6WM4QFZVS+Df3kp/X0bh03fmbH/582R/YPvSTNWMN/fnE
 p1Q67CMB/ovFxF1cx8w==
X-Proofpoint-ORIG-GUID: EFNN2Hn-WmqFVcAdHPqqA-nDIzHyusCK
X-Proofpoint-GUID: EFNN2Hn-WmqFVcAdHPqqA-nDIzHyusCK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAyNiBTYWx0ZWRfX0BsQUW1Qdahh
 4ozANfRJ+HusCvPzuAVVqLoaPNUvtbMVLpENEKRh9Mr5xgP0WKAI9oYui+dLI9YNzBv6z6rB5cg
 byf/JBY5qdmxQoRjnAyf5+0st7s2+hs=
X-Authority-Analysis: v=2.4 cv=HL5WhYtv c=1 sm=1 tr=0 ts=6ad85e6f cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=3V2wKRshZKF0iVVPyNgA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210026



On 10/16/2026 10:47 PM, Jeff Johnson wrote:
> On 9/25/2026 5:26 AM, Kang Yang wrote:
>> @@ -2536,8 +2537,11 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
>>   	if (!atomic_read(&ar->pending_recovery))
>>   		return;
>>   
>> -	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ))
>> +	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ)) {
>> +		queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
>> +				   ATH10K_RECOVERY_TIMEOUT_HZ);
>>   		return;
>> +	}
> 
> Even with the help of two different review agents I don't understand the above
> logic. Under what condition do you expect the above test to succeed? And
> if/when it does succeed, why not delay for just the time left between jiffies
> and recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ?
> 
> Or as one agent writes:
> The early re-arm path is only reachable on the first monitor firing, at the
> strict time_after() boundary. Re-arming for a full
> ATH10K_RECOVERY_TIMEOUT_HZ there creates timing-dependent recovery behavior:
> a worker that runs exactly on the expiry jiffy delays failure accounting by
> another 5s, while one that runs a jiffy later accounts immediately. Use
> time_after_eq()/remove the branch, or rearm only for the remaining time/1
> jiffy if early execution is genuinely possible.

Good catch...I will check this>
> /jeff

