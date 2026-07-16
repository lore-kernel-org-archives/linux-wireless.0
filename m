Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003733F4DC5
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221970; cv=none; b=ZVr2MMmPG+RpmS21gKEi6iEGtYLpkytCJ/dOIFzHPsNs14PVxIpvsNKCSVNfHnqdT8hwtEAPd51HfIlAyC9iamk4oNCWJWmDmxkgjiri2Q/jHmh7wZ3+r4A7orfWMGDIC0xI23dMMi0HaCeNGZqe8w7e5WQ9PLuFYZFqN5o5GVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221970; c=relaxed/simple;
	bh=vbzHOCzv6nIQrABNmSdoQVcrvKTGee/SXos573cobWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZBrsC+gVWtSScQ5hggr/69xCAhMQ8c4rCMAR/8JiXBeBZCds2aYb3YnXEkMqwnZ17tmwp+O6L5t4yKfzyeXS9LtOAD5670N5QYvvjl5HFnf5qlJCQ5mQ4pXsU03Gf6+hpvZAosKzCKisSVmxyFnT0lOdkGcfQQvkqB4smNafxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JwPyugTY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DOPnzgib; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JwPyugTY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DOPnzgib"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GGSgAs3154918
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Eb0tsROvYgrJwXInWDRPGfgNwyHzgxiDdzvGFul31AA=; b=JwPyugTY4Q2zixX+
	JmZZ0qpPwOexrsQyczWnBtUKSzi6eKf35ZubXjrd9/XaL/AQzdhBPcHFT/PfiqoQ
	/9ODRBfDPBMTMPqOUI51ZZcrecvzdDDmSfZsWiOOqn88g7nT3TrMQFyAVP5wZlSO
	6aCJrfUZDrWyuV4xVRxCDt6B0W+HP7sTT2DgwmJgW4b9KNb+OhXUnVUl5jivzut7
	PH8R54/gb+PGBSopQPBIDDm/+o8KMNDUrI1veTxXYq4ksM73x18ylhIyhHmz57St
	JGZkwEhTEUbIPO2GgL19c8WQ9crYr4QHlgHObQRN6SDiiUZ4PtWNz26xaB3DNXQz
	5ztq2g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff1we8gef-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:12:46 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cce14a21faso14501375ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 10:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784221964; x=1784826764; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Eb0tsROvYgrJwXInWDRPGfgNwyHzgxiDdzvGFul31AA=;
        b=DOPnzgibP5gKHGwFppKWWPvtezPIMah+YsnFbnWqI7IK+OuWtSoJkhr2laLOhg1lBZ
         ciMbw9x2BttdMEoQIXC1HE3npsmecNnkyAqtyB0fi38uyQKTAoO04ncTDTd6/4pqWJRD
         6CRN0YF1v+rGTk7FSYx9gn6Ce30pC4TvQqbGWixUsmPVZ8vVi9Wh/uHY/4/Hn/SO7W63
         K8FIU9ZBIafXATNE6ShwMr0LvvY40nL968dxIM70/2310YIc4KDkTF7uFkCoPRisdQX0
         e1C127J+mxYOfQnoTNzahdxMA/lwDcx60aH43zOP95BGBKJKa4JF7pZN5hvlFIWsndc1
         N50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784221964; x=1784826764;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Eb0tsROvYgrJwXInWDRPGfgNwyHzgxiDdzvGFul31AA=;
        b=UsMf44y2fS0rP405h2y5xg8e7RRX/+xGoUJav+Ofi54xI1ZqKcxnBN8bR5qEeC/wTV
         lifcvMPdBXc/BT82xXSiN3A3zO4vXKN7BCSQv9OtnbSa4WBkvQTRDacl36iWRkUC6ISb
         CYIv20mfiEI52xygRCCxK2bVUOZdfGilArWC/HktfqWNs6azsfW9stT1/3wH3UCrj/BL
         1GQFqLgaqi0LQYdp7bGQRJ5lScbFSeMMPLi27cRFQdOoh4qpYq5eo4A+uXRtQhrvqisZ
         irsho5iU6I4jqXU7cpO3E6x/ecXOB9CRBiwrJzPiivU6cVxYL2+8gpCjvvRWNrOSa5GK
         139w==
X-Gm-Message-State: AOJu0YxEJ7/PQ23f233KJf/hWPbseOhKPV0quzdRwCKUqHc/xGTgmjGZ
	xeLKfm1WoWczsvlWGwaWmFxZAvvE1RiMhKieUlJdFzAhX6B0sWV7kfzA8anqBdBgZ0rkPuv/MOn
	Gs3MXGnmHe5YKULkTpP0qMUQn4RdpL/Yj9U9EWXShyXSsqXxxnxg4ZA/WZt8WTPqRw0W1xA==
X-Gm-Gg: AfdE7cl6D5MVINhlxRX/BCJySKSVGGrhcmtu8WZO6X0DHUrKmf65C0c2G1uPvDl/4vS
	pgIWNluRHnAEzD5Np1Us2umREzww5vOomAL53aw2zyWwAOjo2X92LnAY4wZk1qujmTd+SeRe3Wd
	jsGyxo80TrS8WZi7XAxo7zhbkWF8egrjAT/3/PCthvZhXF2mnY943YmYT9umCp1PoV7fK6jTdiD
	GWckJBCVI+MyssNds37LAz1dIq1a/OUv1F+46YIWe+LpVD1S+ZhYVxVPZPazCWo95kv1I5u4uUC
	kflffuym46rTCk8gG36ehGpJQUKxzUOETwCJ+WGTr1ruFp278gH7RLWct3XuCcAZ+msgM7MSADR
	hxKCAkU+mibdSektI8jRFFw4fXl7hogE1W+1iTJpuBA9Y
X-Received: by 2002:a17:902:ffce:b0:2ca:de3:15d7 with SMTP id d9443c01a7336-2cf1f4baf45mr34071435ad.16.1784221964336;
        Thu, 16 Jul 2026 10:12:44 -0700 (PDT)
X-Received: by 2002:a17:902:ffce:b0:2ca:de3:15d7 with SMTP id d9443c01a7336-2cf1f4baf45mr34071225ad.16.1784221963901;
        Thu, 16 Jul 2026 10:12:43 -0700 (PDT)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd4284a92sm10169934c88.4.2026.07.16.10.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 10:12:43 -0700 (PDT)
Message-ID: <305f65d9-4ae6-44aa-8107-5fe2fbeff2df@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 22:42:39 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: fix scan command endianness on big
 endian
To: Alexander Wilhelm <alexander.wilhelm@westermo.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260703-fix-channel-list-copy-v2-1-372c39306d79@westermo.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260703-fix-channel-list-copy-v2-1-372c39306d79@westermo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDE3NiBTYWx0ZWRfX5K779unXRj+X
 klEBQ2ywItxYHpCC8FY0xwlzxlbOZy8DEuTvWL50jLDGFAakXvmtA3k5VkzJIQI1og7xW5sSLYG
 SbhJ+adxupBVe6q0bcBu8vRAeapODEQSxfi2T0dcvYvEEAms1oFJfd3ncKmNwNcHYy8DmJ+kDhu
 V150pptBuCzQihEjKapzoHR5N9uzGGLLcnrSrCbbvQ8fOIJEEnhcOlfgTg1B2R9Ii77l+padquX
 8lq2qwziPK64jBpBDMkv2mgfeRIbLuWClBHFum/e96Tfhxv7055qA2LkwvGWH8RtemYpB3baAM0
 mjNmpAITF3TW+b3Xi8lJLcTBKVStH7IpqfoN06DveaKNwqk5/wX20pAWMSby3zjdC9ZgFsEOwLE
 CijGqEHOfXUYy+NEvUZ3KlDduUks0d5S0CeTGBeATcXQKHHb+4gmN6ccNx9xuwhUtGu58TEg6VP
 VwJ7hJt47rCNhSr3CZA==
X-Authority-Analysis: v=2.4 cv=JJ8LdcKb c=1 sm=1 tr=0 ts=6a59110e cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=N9GNhs4bAAAA:8 a=EUspDBNiAAAA:8 a=pP303J5G7jxFF2sG2pYA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDE3NiBTYWx0ZWRfX0NBA8IvXOylN
 UqtFtv2+7OS36hlSiPFx9njScxurP57NVP0KD/o51znd32aJJEmT+VyeKSBcqou+7X3bHscrLjB
 u8ZpCIHTfBNEtep+sdb4IRk7LXc6qfI=
X-Proofpoint-ORIG-GUID: 3_G2J9CTSkJIatbwWqXHvoghMXzcy9EE
X-Proofpoint-GUID: 3_G2J9CTSkJIatbwWqXHvoghMXzcy9EE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_06,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160176

On 7/3/2026 1:05 PM, Alexander Wilhelm wrote:
> ath12k_wmi_scan_req_arg stores scan parameters in CPU-native byte order,
> while ath12k_wmi_send_scan_start_cmd() writes them into a WMI command
> buffer whose contents must be in little-endian format. The existing code
> copies the channel list and writes s_ssid and hint_bssid related values to
> the command buffer without endian conversion. As a result, scan requests
> contain invalid parameters on big-endian systems and fail.
> 
> Convert the channel list as well as the s_ssid and hint_bssid related
> values to little-endian before writing them to the WMI command buffer. This
> preserves the existing behaviour on little-endian systems while fixing scan
> requests on big-endian architectures.
> 
> Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
