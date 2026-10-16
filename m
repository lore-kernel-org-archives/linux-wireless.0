Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05368456E14
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140306; cv=none; b=M/XGYG0/lwo98h2+JRs3xClv77xgQie7typ0mtz0kFts/qqDFXaKr8OKi76vb5yiOLijYZLruZT8sNwgpVDYJDS4BzTl1lZjLCuw7/hG33swZP5l4EOxHZYZc14muTEpkk45YW0JcC5C9N2pE9WKb2QLpb4H91oWQM0DtBUG0qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140306; c=relaxed/simple;
	bh=uFiZb18j3hwZ6J4muSmWIEiCFf5QPR+W5J/7KCW5SuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CWA8iR5EnttIh4wjp91qI+zZG9IsoZ2rt5K/3PVg+Ll1txG6s/Cy9Bes7rSMRwlSaCxJBlrFXBVw0ZS9G4DiMqU29DMOOnLGTX9pk3DOAXo8LdiIVSPF9L6eS9bMURPFZpm5yVNkSxxHQfEPpztoH97GD/pYFLRTo3msJ5XH60E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jA4GxnUt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KDKBYsCr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jA4GxnUt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KDKBYsCr"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G4KS1b3800216
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	R92Hgshg0R8xysfps3KhIh1Ju04mP4QjU7m2262gaOc=; b=jA4GxnUtkr5VlKEw
	Z9HgNWJb7ihY86KYDcbXu90722ThYb8uPSiBLcUXDdf91UKXDS5iSxfQdErQMyYW
	GlS6tBMT9bl108KAo57kxJvAWiiQ1s+fPf2d/MlU2fbOPlui3dnGVuoQFZW6XqxO
	Pgn2VriCxhqL7jAYka3/0HPal/5Qu5N0kGInBnMch8fDaSSj+aRB3zitbsFui9G/
	XR+ryinq6R9dOgLhQCKAPYsw5ybcU/raJNnrX+aPqacu7uUXQGD5ohWA5FzGP+q/
	7+6P8dunKmwb9W79IwS4dcMJ3XRczuIS31DOlvm+B+ouAWYrVNCKrkiFw+um1stZ
	mvaT3g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb5seacs8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:45:04 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac0ae43900so4414102a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792140303; x=1792745103; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R92Hgshg0R8xysfps3KhIh1Ju04mP4QjU7m2262gaOc=;
        b=KDKBYsCrhgLAjguFSy5L6YdJMcXABdK7uVpa15yl/1NaVKpiZFJtrcuaoNokuu04mA
         n2ZezO9Bjk9GDelNpacwuYX8lrXcGbnLwYIihZgKyvipTfEdPTucnE7Uvj7t1n7336ma
         GNah77rzAvXUL/lFaZJsTvFb3ETasSPQnDgTI3j8ep50ONXUE2ie3PdvnZQzN9Bol0xI
         DksJC8KBvFjbY1NhH7k0w190WsDRDGNHCnK7jC5QR98wgieEGQWt1wdFlZ4t7owHjszA
         OytfI37dJWOWVVdrt0ONdH/E0g8cD3UCdsWSmrZTRXvXlcjvoJcQpHoaGxXn3IVR91xE
         5eWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792140303; x=1792745103;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R92Hgshg0R8xysfps3KhIh1Ju04mP4QjU7m2262gaOc=;
        b=uh/wVfTSRTP2It5XETWmdGzxUgVmOJaA0t+wWgFhsRzA4rq0/b7/ri1/xIr8IMyaEF
         lY4kGZurYHhnIApIp3EvUOsqlhv8Um4mTocd4ePd/5umDNHrZbW78ELzUBP0NDe1aNTo
         4BBxDGrO5MrwIm1Fc5A3vQTZr34XrrL87662SNTqR24lpRW5a1uEQi9fdQAev3Kk+XZM
         042efzClK7icvIHFJft/pj9D2c4X25Uj+JXtb5tutYXHomxzAt2t4EGIl66u2xRTLHbY
         hn/hPDyWocOBH5AGCqnhXjEa94uDMbdiNJ1NnQNuwAUQ+fZLL1QI8abh0jLnyqOOtGmB
         jI4A==
X-Gm-Message-State: AFq9FYJu+5mBXldg6FpkG18ebaPxRbCnqpV08GQOAuAD/t7oHYHe7SK9
	4lGw22qgaxEHOlZEFohWsH+F1FBpSCT638WCtMw5wXD41Qs3diWc4YfHYhR7y+Xa1JonFoqOv2r
	ZiwU3j0J5y3Z8K5X7aWhTTlyQ9y35lvArYzzvGQFCsEAIiVp8D3lsm2ICbPqWoCMnSWBtUQ==
X-Gm-Gg: AYBFou3ZhAFAhbzPWOhqLM45SsEL81MES7uUCrcDHkDrLXgw7mHRVHnUWa7/REs/GJn
	gMSaLYFWlkybbP3PykIAqLWXY/GZ7cgKStQTFTaN/e3Cux/cR5qmKhv0Tgl0svKk0z/6xn1UMXt
	8M+/gwbn4yp7eiafqIjus00s/G2XVzTBFpM/pUSXX32hIe7D8Rio9v0NTfZTPk9XPq1mr/9duJe
	XSk9+eYfuO8ZTBomuZ6fyfC7IWOX6SMBDNz59cYhV4xyUpd7STafi9cJHXy4zGfy4ouf0uCcMTg
	kxIgoTQq6OKsQRXDA2/yJW3ctOUtz4NnQppeJd7kM3Qn9aMLuQQZKYYbdLQlIqTDPrzHFJW39uN
	r7YV5iW5H064SBsoSazoDbJj9WAtEqsh5RXDGqYSsI5lNyOnZQTOt+xeaplCMPGDMJMk=
X-Received: by 2002:a17:90b:5343:b0:3a8:a98c:ea07 with SMTP id 98e67ed59e1d1-3ab3a94f288mr17450793a91.13.1792140303371;
        Fri, 16 Oct 2026 01:45:03 -0700 (PDT)
X-Received: by 2002:a17:90b:5343:b0:3a8:a98c:ea07 with SMTP id 98e67ed59e1d1-3ab3a94f288mr17450767a91.13.1792140302515;
        Fri, 16 Oct 2026 01:45:02 -0700 (PDT)
Received: from [10.133.33.246] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd9c4b4eesm1029557a91.2.2026.10.16.01.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 01:45:02 -0700 (PDT)
Message-ID: <b8554d8b-6671-4fcd-a455-b5f92cd31300@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:44:59 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/8] wifi: ath10k: fix SDIO aux workqueue
 starvation in recovery detection
To: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-1-14baf913df94@oss.qualcomm.com>
 <b0f4fc0b-3c42-4fde-a4a6-9263695b0325@oss.qualcomm.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <b0f4fc0b-3c42-4fde-a4a6-9263695b0325@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAzNCBTYWx0ZWRfX2k9C7RooG9uB
 mzMVR45mNUsDzqfk0qoUD0j+0MvI9CSmm9kh19cK95hFMe0rXerNsz/sh6IddPt2eTU/LqQUYbq
 6Pt6n5rvvBkrjSCD4BLptRFv2sQ7v3s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAzNCBTYWx0ZWRfX5kCyXLMZBIZe
 6NugXQpOhM8OS/uyd682WerD65GNePq4fRtW+KTES92YPp8q0G2qZG7RF706aecokzkIoBVTp0e
 SaUc8CRqs0VFXs/FoZZowh/+tXy9az3Apcfol5iSanq78KblIfYoKjJRhuoPQI4HID0Xsv679cM
 aIs9k4dJDOXj8incjHgv1jWXkX0WH7cmPqzst4W2yPv3s7gFfsz5Wp6A/swYpw9YB/zhrarg6cr
 Ne+36cx9g2cWyIORvzx9klEanT4/mTzY8cgioGcibGPRJvrl9tM4OIK1J9sESFlCAU1zxUYirqk
 KIKhZs5Y7oi5MFEXolPn8LCWXyVe3y7U974A1AQ1htC0D60QSACN3lYCpLFPh+i1BxfudAYW+Ek
 iLYD5V6VxkuZzmL2357DUeHhrPeGLlpdwaCrjNVSAUgIe8yNr/DUjb3k9p/ihk1b82ARb0GULJd
 JmJqE3dlFzyJHkU4omQ==
X-Authority-Analysis: v=2.4 cv=P4yvFSAu c=1 sm=1 tr=0 ts=6ad1e410 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=0p70_H8JvZq-mLLo2zkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: EHKhHoIFFstaPCKxiNFFnQSoZS6GhpXT
X-Proofpoint-GUID: EHKhHoIFFstaPCKxiNFFnQSoZS6GhpXT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160034



On 10/16/2026 3:34 PM, Vasanthakumar Thiagarajan wrote:
> 
> On 25-09-2026 17:56, Kang Yang wrote:
>> Recovery monitoring runs on workqueue_aux, which is also
>> used by SDIO RX dispatch and WMI SERVICE_READY handling.
>>
>> A single firmware crash may generate multiple recovery
>> triggers. Recovery detection currently handles each one by
>> waiting for recovery completion on workqueue_aux. On SDIO,
>> this blocks the same workqueue needed to deliver recovery
>> traffic, preventing recovery from completing.
>>
>> As a result, otherwise recoverable firmware crashes fail
>> with:
>>    ctl_resp never came in (-110)
>>
>> Treat duplicate recovery triggers as part of a single
>> recovery attempt by gating recovery startup in
>> ath10k_core_start_recovery() with an atomic_cmpxchg() on
>> pending_recovery, and by making the monitor path check the
>> elapsed time since the attempt started instead of blocking
>> on a completion.
>>
>> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> 
> Since the issue is described from SDIO point-of-view, it makes sense to add
> SDIO hardware details as well in the Tested-on tag?


Google is doing detail test on all platforms, will add test on tag after 
that.


> 
> Vasanth

