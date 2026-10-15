Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C9E51616C
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085753; cv=none; b=CcrXbzY0+fvXsoiN0nPSLxieI+oakYkuQaLF/YmoySJVm8RAlFr3a4ymrWRKa7ZnsvboscMetiFvZfKV9uWPvDawXWIIUqY3dJuZTP3A/DC/VGsL1rv5K004QnVBLqa3bpzDYC9ospergckyJ3Wl5meMhmRmJft6NYhdxJgLTHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085753; c=relaxed/simple;
	bh=H/etT2HlYpIE0hVXJjfbsEK/thEkSTMryAvWwOvIJfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raZ6t4+JhpYv3NDpO3/N/zX18pYyfZS+Q/awl5Y5e8nBA8rh1j6wnoQVLdjU9sQFFqbVK+2VY5wVNoNDXTD4PEqFMwh0X5jppSAGCTkW0fiwlIWk2D9US+S7kBV1LD9mB2giHdTxntmP2BI7mlz8EPX/8eF+tdRoWI3YkuMBJ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YS+z7bgF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fJ5ZwDFr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YS+z7bgF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fJ5ZwDFr"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FFmED72416893
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 17:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lRcyzxmgidMhHq2yYqji6ESeNhh9z44YPDLaLG/n0tk=; b=YS+z7bgFMjTyG9nQ
	sMB8HkKmUeszHnO0RSCITsF+yizNww+MxTaNmsNG4I7VCFwgjm3Eo+tLZM9LBDT4
	0bTxx78hW36RrVel2tb4yNQhIA/B0753ohJLUGWlicaFRCVa7P6RE17MORzzFbdX
	IrFjg5Hw2fzWMQWBYwFDYZ8OlQPnJOwE1BXRF58SW8ce2TCRAszlX0pdc8ma0IdU
	TRWf6O3ZUjjbpVhz9ckSixYf9DUK2w/nmus4wrlb8z4zcU7r+gfbC3GFFw1GFYYj
	R+df2NJRkDUJYzJXe/GLPAWaEsKsEu/lu0pa1WqIfb+83Q4lU0tmaAWgURrM95OM
	g+Jpsw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haqdhkbud-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 17:35:41 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso9754418eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 10:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792085740; x=1792690540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lRcyzxmgidMhHq2yYqji6ESeNhh9z44YPDLaLG/n0tk=;
        b=fJ5ZwDFrv7WXC8ShmFQ5fGA3hOkUev9/OxQhOZdUz1eB6VRS3scDMzPJ4s3HTiETbW
         SfIgYLb+ROw5mO1ThA8cjIzfI3x+/x4zB4j1vk85u/USm/jAHQ48HfZh0SlGSBjN9Cgg
         BB01d58y0usfFUg7e9tMuBpoxwMtcxrpcc2rV6Ouq7N1bxYJ37SCQEkfhEHLaTmvAj2m
         u/M1TmxEw3ELfsfLOK1/RQtlqj38nAN8i7oKVCfo78HGyaVJYb+BJ0+xe68Xi18AHI0R
         joeBHDxKEAno9xWo6ANKKymOGyF8KGP4WVeD/JVE0edxCGYBCMDtWQ1pi5B1LBZ17Iwo
         o6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792085740; x=1792690540;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lRcyzxmgidMhHq2yYqji6ESeNhh9z44YPDLaLG/n0tk=;
        b=x/SYkYZSrnGUvVt5834jZGraJF5QJ6166vg2YRD3vLrGU2Nlx6HqbzZUsslkFFcvVL
         OKUfyynnZIY1eGJ4xCn5YRdDcqW/+ZEzYwqTIdFC45PfnbF5vzYq1SJGVGvwEvh9lxij
         QVHAYK5tKBgwomOO+LJhJRvm7hDBUmBJyub2fAyUr61eshD8fq7LeZd0xc+qp+utcPNs
         uokgVd2MiACqhJhr6ynPMaLb4Zq681oYRZ6/8fn9KkBlnwchj4KvJmjsC+7DhtmrUQwG
         YoeUxse16aiTFbXzd3VyfOvX7ktAVK7wC3J53MwELhxWOFuHtIQkuOzHgwUrqE4FB4Cr
         RwiA==
X-Forwarded-Encrypted: i=1; AKwUvBzmes93Y6hynRgI+ul3Mfxf3ZxaAu0osQy4EBdRCzM5mzF4OY7E4hQgt6bdBxqeGLJgqOTyGRTyAiaoJWuIGQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIIpOikRdYzK3kRXlToo9KZVIV3FgK6vaJ3yZZ3Nw4kSd9JTAI0
	f/GvFycBFhM/y8K6IIXh/cSeF+TgL++SlpM51HjroTlH1DNCzhNVReWQ6DwKt34K615UOEvy2mX
	DgfwFPHb6Bx/86PcAAZKhwAW7U7edKAdd67YVcV8WLQptBUeFpq3yf16e51OIywbOy+0LCA==
X-Gm-Gg: AYBFou22jwEWFER+Oo4BhmQMthB2IJHkdkZ91p3UWM4YQYjm0t4FOysilybtJOJ/VNY
	nrPYKiYtHLX673eNgO3waZlKov2ncOCIzO7rRE8xMEQT/L8rMC3jOqmadoIkSeMk7ZXkL5bEVA2
	fgvGsK1oobYJurK73/iVGRsbzKtCa5gCdeQZ3rS6qOzAY4O3Te7tXxJ177kt1TGPks5DUEO/8fT
	wXw2SKNBvW/XeQ8MyzxWY6E1YzDVPiCj5biv4tGNOpIykYtHURycHprL6YpWgejZaRdyW1WPF52
	4MhmfvMK6nMNS181oKlR5o2/7IBRkC9TBg1qsh+S65DlyihuGRoN7M9sM2GuF2ePG/zUdnJRWmE
	iu24XrwYygftuBnnHirkg47DLqPIM6nX2xDoVsCq1D5s=
X-Received: by 2002:a05:693c:41d1:10b0:35d:74f7:3b9 with SMTP id 5a478bee46e88-35d74f71451mr9525046eec.33.1792085740305;
        Thu, 15 Oct 2026 10:35:40 -0700 (PDT)
X-Received: by 2002:a05:693c:41d1:10b0:35d:74f7:3b9 with SMTP id 5a478bee46e88-35d74f71451mr9525002eec.33.1792085739523;
        Thu, 15 Oct 2026 10:35:39 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36058a8de1fsm381704eec.25.2026.10.15.10.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 10:35:39 -0700 (PDT)
Message-ID: <f4c53076-eb99-4306-b595-7349aeba95f0@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 23:05:35 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: Fix failure to create
 ath12k_dp_peer on MLO reconnect
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA3MCBTYWx0ZWRfXxkjOwle+lR3E
 jwTqjq6adgqtUlVw1VDIhIWelx4wU8PAOnQOVggjvO9NQ1Hr3GHyk/bvjy5K9jFV72G3zz4203V
 Mi6vC2ao9fPDMtKkpb3+RrBeJCBJdw44/dquZBLc/2V24huprugSi0zBYWdF02+1l0qVUyXK3bV
 iTwSDoEbJf5R7Q99zn9n58KYgwIZOkzOMM+lVeQ+OUjhaBPbzlpOWgTJKukP/wCtfV+nO3qyIIi
 34KwcVaNBOsap7+CuUgVo6wQkoSydoyUCafxdScfnQukn4yfSavBhUC+Xc4IxTdjXK3zEZu5klj
 2IKbk3py+rlHk8g0mn3XHdFZ/y45kAhALKd+iehbWK1JyJbtS0VkWcjYOWsStbo+qj20uhrMOAy
 GAiEsjqaVnItrZhAIrbozCaiNHzksbnjUHIIg8Cz+IRl9JBZOBVM34L1honQpzBC5+wR30RSgCi
 Ziu65wU9Wynoun0BqBw==
X-Proofpoint-GUID: ktRrTFnbJo_NhquBFmuQsDmyormXZwZv
X-Authority-Analysis: v=2.4 cv=DeeCOftW c=1 sm=1 tr=0 ts=6ad10eed cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=FeBjiSnNOcrKIJN5QMIA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA3MCBTYWx0ZWRfX3EsttSXYhiMQ
 1bHs/t+3tVyeVzwWu3hHxBg8BzCWnECk7AEjQq744esXdedAod/zD22ZxGYSLwxan2kEhyEvcLM
 +8V8o5NjfivWKvbW8WBVIT3tX6/YtSY=
X-Proofpoint-ORIG-GUID: ktRrTFnbJo_NhquBFmuQsDmyormXZwZv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150070

On 9/15/2026 1:30 PM, Miaoqing Pan wrote:
> In ath12k_mac_op_sta_state(), when transitioning an MLO station from
> IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
> succeeds, on is_sta_assoc_link verification failure, it takes the
> 'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
> the dp_peers_list.
> 
> On the next connection attempt, ath12k_dp_peer_create() finds the stale
> entry and returns -EEXIST (-17):
> 
>      wlP4p1s0: failed to insert STA entry for the AP (error -17)
> 
> Fix it by changing 'goto exit' to 'goto free_unassign_link'.
> 
> Also, there is another error path in ath12k_mac_op_sta_state() that
> jumps to peer_delete after ath12k_mac_assign_link_sta() succeeds, without
> undoing the assignment through ath12k_mac_free_unassign_link_sta().
> As a result, the link RCU pointer remains assigned and a stale bit is
> left in ahsta->links_map, which can trigger the same -EEXIST failure
> on subsequent reconnect attempts. Fix this by redirecting that error
> path to free_unassign_link instead.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 0cd46d1f36ce ("wifi: ath12k: identify assoc link vif in station mode")
> Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
