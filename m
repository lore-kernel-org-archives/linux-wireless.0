Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4FF485926
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 05:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791869015; cv=none; b=tNp4yNl+pvzEsvE0C7REdenLFcvDPDYsaV/uh9IfN7BglAXtIbUcqV5WfKV5laLC/+Z9j2jl1nRKt5dPp7ftDTp/kG3PT0sz4VGppsTOtVGy70qKV04Ao08uCAjvBjfblQmoQM2VanFkekDMv1cpIDkw71rEuuY3LJXP6F8B7nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791869015; c=relaxed/simple;
	bh=JVx6dpEccQaMA7CMCfXA3s10a4YXdLEp+SKGvRudmng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPCt5J/YxLVgJuquvGEXflK7ZCE3LXuzixxcRcLJUPFNf4EkP19W0LZDSFF6uv/a0sOyHnprgHmmX9li3kExdtojjVJ6lc7O7eI5T1QYVp39PZOYSqUUYPDkLa2aWwryOwjcPyiPwk8z/J0nLTtl250TcHwrpeVblYmrJAd+kzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UecfDA5h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hZNrcCrj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UecfDA5h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hZNrcCrj"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D212Z54071819
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 05:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/SZN17hFW4GC9KUw1ogcVV38VClSXT6eMgRXyiGOLGY=; b=UecfDA5h0NXv0cGv
	x2XEaFlRXrOoK+82wOwqjLVebQ8tclsDFd3EW0P9rQ9SOaJbDgxN3+BQ8jrfV+uK
	lZNYZ+Wk0WQU/CI/dJLjUEhWwlM23hr4ul1KcF++WkLqEASlUluVxx9ima3e4GHV
	2EaLtBr6uP1Wc5xAowGZLct1AiilGHovkwWvS9P4Xa963xz5WbHE4GtKjbnXtSUE
	C9nvI5eefGMS9l5bpy8KVGSzdPVb0ME+vv7/l/l68Lu5o3zIqHilAmk97V2MaA3G
	Kv9OZW9lACSuS9pLUcJi7tcJv+Q174w9TRRLI7JFmTprljWdKMD6N4eOhNTgTj4Z
	UMyHPQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h92jjtt68-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 05:23:31 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-351788121cfso1841768eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 22:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791869010; x=1792473810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/SZN17hFW4GC9KUw1ogcVV38VClSXT6eMgRXyiGOLGY=;
        b=hZNrcCrjFZ3ajE3ZqT6UGf0l5kzAf3dWxr7HWR7rvGV6Gpspz4jYGsiwvp4ItsVrLV
         NiO1Vbj9lT3ol5TrlUSR/U/ppiqpwj0xSGu8+i+sGws6tVh4gTBlhdl9tJcvr3yfM/CF
         /MlYLs4sjiCa95KIWRD3rWusDGaRELd1HZ+CWUDjwfRqlOjRkXTplh+MjZGUSTCkGZ68
         MQKE7dFOMf2xriYaGWjHfZT/pOb74AY7doG444Jom5fqDyz3q91g6bFPNYaObaFKIW7i
         DEQ6qiLxgjWSHcXOtx0iiuE5OdqiDqNhFLQI4rZQuSsHd4aYuBOQAx2lzGrehhozzdGv
         wJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791869010; x=1792473810;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/SZN17hFW4GC9KUw1ogcVV38VClSXT6eMgRXyiGOLGY=;
        b=ZPNBYqF6tbJcvcBYGj+qPlmQuhEeVFEvAhtU/k6oLW00GOIORA82aYzoEU+CTSYFyf
         sLZnT9LWN7G12a4Icn6RAHFQKGNvQLevBctPg1rBRfdepAAKxaE/fDBTAdKcWGp59sqO
         sSq7Hvt/DS+56so9hZpS5XWLKPIBxVfhqP/322QSwyhNES7hMXWwI/vGeHEvhMSR38Pf
         /6Xgw3AZyFvOwo8hiIKrzTxQHxbIu4jbBuQWgCfh2SWFw89UtG8XsVgjK5vc0Lw4fjD6
         Tuke4Y2OQLnMrfJFgH9Uyr5/c/CBL9eJ0qM3EoNrLDNpXHqw27fVn6HJdbEIgRWuswjr
         GSIg==
X-Gm-Message-State: AFq9FYISNW39f9Qis5VBrOfdvKvBnhkkZsGSJ/bVQ6TbUCSa0i8/5ob6
	QoVWTxpsIrzZZZGQU9cbdZv/u04CHhO96n8QQuEWIDbfdrUEdc3oNLwxBiGUqmm2V46kLjQKlA0
	xg6uyw3rc+AiBUs54jjIHblhVy/sz2F4rR8ds3kMZR9daDTNWDO/XBmwB9QSLNTCG4sjLvIF7wm
	VVoEpi
X-Gm-Gg: AYBFou1wd22mTclcWD1wTa4264uq6yddTY0Zii13i9zIzZXItddCIH96DTy2mgfD9HA
	6BGigh8WMZrfOhjQutXjdGFXLTKO/M9qPUimrLlQVbE6V1ZpVhqyYKLTrOzObW1bSaOep6N5MI1
	cnfwtdjk6bkTlPvnxIU8AexqQovxGwD+irOVeeX6HGyuX6G+6zvP8ezJd3N0Fkg0fjNNSCHMmF2
	ScbvhHdfLf3rQSHNWYIJ1q9vEE/eufDJ8WVcqUXtL0g0YyjxxM01n4y590kYi36sI0w9B1asuQS
	DPpJTDJ/zMbTc0DKtFWw6cEQgwsn0s6qlOK8p5WwNTzjAHPyqowzfgFXQiwO014MhbLv7NtiYBC
	82HQmXOhayuG6OOPkRQAO8EJMVPeQyv6JDxChH+oV
X-Received: by 2002:a05:693c:87c4:10b0:356:4b46:9393 with SMTP id 5a478bee46e88-3564b46940amr13288198eec.24.1791869010094;
        Mon, 12 Oct 2026 22:23:30 -0700 (PDT)
X-Received: by 2002:a05:693c:87c4:10b0:356:4b46:9393 with SMTP id 5a478bee46e88-3564b46940amr13288167eec.24.1791869009486;
        Mon, 12 Oct 2026 22:23:29 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537c841648sm44915106eec.3.2026.10.12.22.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 22:23:29 -0700 (PDT)
Message-ID: <657ebc48-0faa-46cf-9cac-7fd06b2547c9@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 10:53:24 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath12k: assign device id from the WSI index
To: Benoit Masson <yahoo@perenite.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        stable@vger.kernel.org,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
References: <20260928213322.98949-1-yahoo@perenite.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260928213322.98949-1-yahoo@perenite.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: aOkFWPC7pgyGG6LN-rcmWBuCip01WnPl
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAyMSBTYWx0ZWRfXwVrThp6Ol0E2
 xso/e3V1Y40eA8YPDwjzJEh8FaB+WpTop4gGr4JBtT8VX5+ttOe9l699Wc5/Ltm28HNY6cgtZjG
 /J0MYRh4KdOEv/YYMKJ7TbpIIk9uhOQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAyMSBTYWx0ZWRfX/KXc3pLXGWhX
 1QmExqOH3jkx4uUKorOTPC97dzd8cy6UfLm3VQl561R1VK6xTOKcg7Yf9CUC0ene4w66imEceZ5
 T6VeLBL12eYtPWkoXTyyyELTqcvuMC1NsOKjZDPQw1njWYiL+KumWoYnRXynNlwXfdc9sN4gAxF
 blB8CvFH7i5nr+043h0bbIuzrt++REz2I2aqvxsVkBR1awMLsDpKSaZMnIpBtEJ7z85lDJRZdl0
 8vtJdhljcLFW6jVOIsjqTFQpQcPrLW/fCi55cVwx51nC2EQOZ5WCI4rSyuiX8StBxcZ47rrS+Zd
 t+/M3Jmz/MWM4VTEMmW+yEVAWWzLx518fYSmzYlW+uGsz5VqK7kLD5tvr0zq+w9YVUGQk5g+Anj
 M1sbfr7d+jd4GcpTjq6AAQJ70ifDI4K55V3h4WzOzD/Szt79BxQ3HIS8AYGXfy1e9x6Gxs9fkCb
 xPS8jkRShgk/zsrEokg==
X-Authority-Analysis: v=2.4 cv=GfKCDgXL c=1 sm=1 tr=0 ts=6acdc053 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=LV5C8B2hAAAA:8 a=33sO1Vo68oqyLtPrM3MA:9
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22 a=uiVh3g-rw18WZz7NjXbe:22
X-Proofpoint-ORIG-GUID: aOkFWPC7pgyGG6LN-rcmWBuCip01WnPl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 spamscore=0 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130021

On 9/29/2026 3:03 AM, Benoit Masson wrote:
> Devices of a hardware group are added to ag->ab[] in PCI probe
> completion order (ab->device_id = ag->num_probed++), which is not
> stable across boots. The wiphy radio array is built from ag->ab[] and
> the wiphy device is taken from its first entry, so the wiphy sysfs
> path and the mapping of radio indices to bands change on every boot.
> 
> Persisted wireless configurations reference radios by index (e.g.
> OpenWrt/hostapd "radio0"), so such a configuration attaches to a
> random band at each boot. This affects any multi-chip group with
> single-band radios, e.g. TP-Link Archer BE800 (three QCN9274/QCN9224
> radios in one group).
> 
> Store each ab in ag->ab[] at its wsi_info.index, which is derived from
> the device tree WSI ring and is therefore deterministic.
> ag->num_probed remains the group device counter. The unassign path is
> unchanged, it already indexes ag->ab[] by ab->device_id.
> 
> Suggested-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
> Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
> Cc: stable@vger.kernel.org # 6.14+
> Signed-off-by: Benoit Masson <yahoo@perenite.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
