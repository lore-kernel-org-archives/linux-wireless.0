Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4961DFF0
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 00:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790122328; cv=none; b=RANPamG2jn6RYfDboneUWYFH1M/EXl6UU27IlOB3EtBx1aQh5i0rKrlqKqfNorZfkqtQscJpaPjt0jT28U+lqOYSarith6Fz7BPTfmh9VVkKfwKvr2JrNJvCWlMjhV+O1kCGNOMH4dorFUwtQ3IcKWHcTi7dnVVNdl03/QpGcn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790122328; c=relaxed/simple;
	bh=+9ijsx00YMEuJQpjKbg5M6wHQJGvvXasf5iTxjYEpUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyxOjDICrbPcGrX5SDf0NoWtzJtDg/LBD0jNRpNy1mV9TBh8az4AC+qX3LaO+mYQTgsfjczumipQncTQwaPgODc2ICIWTtAJYJrkOtHxvqghYYVzdxuGfmEUeDc1+GcFAbXy2JzkQ/WNJi7mO5PS1iyZtjueOVAkb11mdLRexQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RQEnC8/o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ay9KZoZc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RQEnC8/o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ay9KZoZc"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MIXTPe268464
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 00:12:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vUvIhBuiOIGVTHL/fz03Bgye1wplgivSPR9c5jQFA/I=; b=RQEnC8/o0N3oiz1O
	CPC1WMuJDHvvaxHEjdHgjgEkgk5D3mbAeDL8itJww+z88fAhD3CXskDjQ8ijnOXK
	IzTqTbBAkA2chC//xTZHZQtl+/xL40mSc4Cm+4HnriLlwW2RTT7iB+Jj5lAX6RCO
	iQb+UjSLNgUv3U5JDNcFuRUdCPvB2Lvn8khR8Cbzpgd+4uNnzmuiIFOSV/irQ3u4
	La1zwz6vvS0YuUPt8EwqRSJIApKOAX89SVbK1xKYkYhmzIqq2Ad2TF007sVxnOI2
	cV2S3aRp/yiRRjCirIrHss0PsBYMU8oq3osvMgppEw+KgY8TDANfQkUBL06Z3tFH
	uI0e/g==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guy2c1bn0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 00:12:06 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-333543ac378so377937eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790122324; x=1790727124; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vUvIhBuiOIGVTHL/fz03Bgye1wplgivSPR9c5jQFA/I=;
        b=Ay9KZoZcsMDtbdh6XJYuOI7MBj+7n0wNgqcyu3+ujmpvBbNCggGcvyOmnXMUIQkhxx
         GzKl1ER9fWYOVA8wtasY8f4OWzO0WQIjjz6KzQS7hSttNItKdHEJ6gQAj9zvn9M8WDqM
         ApDQJscgJkuxoqXFh5BerR3FmYdpKZ240Y8WArKeVpN59iGL/mf8P9jkvw1B5BAUICCP
         +/F4FcVVPL+R4QLMLBy/6AwjlzsoFijXW4KeFepL0IihySHjyMpLiliArrZgwgbdX5QQ
         XulpEUBu7H68DZgQmLV/xs01+MagYeZtwTWm2EFglZ4szYJQQfXSm4AaBrQ4eay2EW+K
         mdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790122324; x=1790727124;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vUvIhBuiOIGVTHL/fz03Bgye1wplgivSPR9c5jQFA/I=;
        b=WvUtsXFduTg0nU+u87E/z7L224QPUaetYs+9kuCfCHeX0OlTqc+JG92sBpSmPc1MAr
         a/4ED7/OKasJ8QCqbTpXzsCt1N5oNZ5D/fBONPGqP5j90m60wr+9EngYvOyG43VCHur0
         L5OytW7/kh18IjlwNH3abuwTS2yHKYKWl4hfUPIVhyAAa3jZ+OuN8/rVASOey7Sb53l1
         zIZBQ49tItoO8M8iQo7Cw0tkyuwmeZYlodCo7mO/P/Wmq5D8v9RKaAbNduJBTmo30cgk
         FrLirJX2uerGTyxxgI3s9Q8GhqasfVrFxpEi1ZlOAGzUN885639Q1n1Q+LylAGDcUKCu
         NqmA==
X-Gm-Message-State: AFuF++leBazrk6DczP/Tl5eohX46gwIrUNRY4bp/lmmul5R97hBYddG/
	D6XJdMEErrSMjYBIa2mv5wLdI03BFv7NyEOV5qbIWZ+ScPmeAbfqDdaSZxE3wCXJJPeZPnmRrWV
	QFO4UJ5JwMRcba4V8z4tbEt1Q3+XCFNhaQVCO+4xlsZJnoN9KxEosuzmqcICF6amkBGqDyg==
X-Gm-Gg: AYBFou3YSRC6Y8NRLWNxC5rGwjbShOo69jK9mTXUvxM82zXuSELtm0qKdTKNLzIWwwy
	izAqGDP/EY7rAEaB9R2bGNOPEm2uXxa+ch2FFpIKGFY6mhDHF0bC87cYGjXjI50v1EQtKWz9p8l
	Rt8boMBQLZTj5bfPws7dmqwpgXpsiSPhYkOu1SbQYvVgs8gKndO1TNKnd2wDRcey2mf9FWhBO0u
	2qajxUbm/LABs/EV2a91b2DHDhtNHPyTq+92LTD13iWtq6VJN9r8KhkDHBf8EMDW//6Hqbvqsug
	uTkq17zBaJRocxmMw/4C1w5+Ep/WR4yfj4HbWyDOqKhbE6d25B8E9zOMBFRuOC4R0fdPma2MALV
	PH6av0YvwMrrvnWnGHS7+oUlDAap6HIrDrLGMZY5D90JlRzAnM3hZZhDMNQ==
X-Received: by 2002:a05:7301:4393:b0:33c:1b80:8ae2 with SMTP id 5a478bee46e88-33e8ea84a8amr791791eec.39.1790122323510;
        Tue, 22 Sep 2026 17:12:03 -0700 (PDT)
X-Received: by 2002:a05:7301:4393:b0:33c:1b80:8ae2 with SMTP id 5a478bee46e88-33e8ea84a8amr791766eec.39.1790122322914;
        Tue, 22 Sep 2026 17:12:02 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96d497e1sm1544345eec.25.2026.09.22.17.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 17:12:02 -0700 (PDT)
Message-ID: <435e3012-9b6e-4327-97cc-f65ed1e0e5c0@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 17:12:01 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4 4/8] wifi: ath12k: add device DP stats reset
 support via debugfs
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
 <20260819053247.1420393-5-pardeep.kaur@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260819053247.1420393-5-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: dfOoItMajTpWdB2EhzpM5HcWO6vPJGAF
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAwMCBTYWx0ZWRfX0HsJn1dRPXcS
 H9GTVdHCzC0obqcgZ5C3Hzc6VAja7idVGK1qHadzWAtpMwzCsxojUxAErIn0v7VRfrdD9bgp+/j
 iL0G+0G/gUfWwJP7026YTbnZqdEvu8Q=
X-Authority-Analysis: v=2.4 cv=Zsh4uN7G c=1 sm=1 tr=0 ts=6ab31956 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=53jHxVQQaW14DdMQJ6sA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: dfOoItMajTpWdB2EhzpM5HcWO6vPJGAF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAwMCBTYWx0ZWRfX1/qyKEs6VE0b
 snRr+XZTjoVOjnFnNuZGI3qynglmlYYVDicn5YMqSnfn6exwj23LCOR720J66umugPqE+o/iBfO
 +UTBQruzbFyFMG1rloZH1xVppyA8aw8htp6OIxyQZd3tsiBjlK/wnVkgzlD6i7KzObJJn3WW234
 vf7SA3ec8ou1b9au/AGq1MDLMLdaruSOUzGNSxAwLuLkoKRhmuJ3IQ4McbGdr8V/mOYqskw5vD7
 2wYtzOLQy+BymDla4Xn4m4UCPhOqSEvL1vYZp5XbNFbqO8O4jJ7Yq/ZmYN4Hox01PgRBTDVKhKk
 MVDAJaLO5Wk/2A6jp1PgxmstIELdUbNSZsw//wyO2vi4vFvgk6cDfTTTdmDtdlT50zkBUx1tfi4
 QDeC/qxag0prJ5bwrQ5N0v/iMGPm0C5VK8LEy5U5EobB4rSlb3An/TEk2Zf11J1kK6omoTPY4BQ
 FHWnKD5+BFvn3Lh1Izg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230000

On 8/18/2026 10:32 PM, Pardeep Kaur wrote:
> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> 
> There is no way to reset device DP stats counters without reloading
> the driver, making it difficult to isolate issues to a specific time
> window during debugging.
> 
> Add a write handler to the device_dp_stats debugfs file so that
> writing 'reset' clears all device DP stats counters. Change the file
> mode from 0400 to 0600 to allow write access. Use
> simple_write_to_buffer() to correctly handle partial writes and
> non-zero ppos, consistent with ath12k_write_simulate_fw_crash() in

in what? the last sentence seems to be truncated. Or perhaps just s/ in$/./?
if there are no other comments in the thread there is no need to repost just
for this. Instead just let me know what text you really want here.
> 
> No lock is taken around the memset since the counters are updated
> locklessly in the datapath; taking dp_lock would be misleading as it
> does not protect device_stats updates.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
