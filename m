Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27E83BC68A
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 04:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785127909; cv=none; b=gsXWPJDVlElrLP2QLVgSjojZjikVQLOxjSitkTqOlSEyFX6JzF4TY/3Ydyl9y61/Yk5u+2QrTANn5q52HyGe/tsYD31PX/R/MAFaN5hFJIYQtG6kiCZdrAht8xT2NgWnmNZfJo7t4mGdeZPHbgLJt8px7CpWh9wVslF8gSETU5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785127909; c=relaxed/simple;
	bh=vytWF6MXKBdRgJAcmwyxWjbgiQMe9/K0TQKYvPb1WYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ne2z3LVkJ9DfBliwsmDJgApPExQ+P+HiNrhEBbsKm9VumOxqLOVYclZyeYOmiG6WaxN12Ocn6s4M+dXSJuqrBbbWuypJkL7AHU8OOaPmp4LlGvpDYY/VcSySKRgpTx8TJPp3jWcaZpRzp2GZC+hRDvYby2dXh9aMJkhCt4DGSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BedZRv1k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kAeYFUsA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BedZRv1k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kAeYFUsA"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1fifj2239933
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 04:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WZB1dUbaHZf6gE20F5i86eXcCl8V1AJSd3jw+FthmqI=; b=BedZRv1kfTb8UVRt
	hjShLshwhefzBrslg/qHufOfGGx26oJnDwNtHNzJIe1uBlsRMKZn5koMcWxlOr4e
	TFxqswPJrYBMJxLZ9yWhgieZQXeluWj2QIsV+Jdk8hIvlPduWvvzz7GF8WrL7Zpz
	eVrvofCjGUTjK3e/ZCEAXCppBAHNiyW5sDCRX/J6v+htWnGrt9KqEC/b9Iyl/t61
	YusjB22Lq3p9o1bnGZcKzRbI5xP28fZajtKFSPtz5lwfI5Grb2lVRYTXSNEcZY+D
	g701jX3PQ/tHgaaTK3ZM7a54PRsVRBfx2yItc7m4L3qk3TNx45xwcpwtl6qfnlun
	oDk0ww==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fnsxs0tw3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 04:51:46 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb711c88f2eso1424121a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 21:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785127905; x=1785732705; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WZB1dUbaHZf6gE20F5i86eXcCl8V1AJSd3jw+FthmqI=;
        b=kAeYFUsAuBuBFEwo7/wnsEtztyV44cmsZ7S8VlF1bDlf2aUUVdtsXDt+D1VGn7CYfg
         BlaiE0Aw407hFAFK4E6K1IMHXtNL7+CpHFGU/2R8Gpjl9YAkYYZSVblzoQWmVAkOE7yt
         02DDD92W5pfMKtlTFer5zNwS2YLAEG56Q21najc21dsutLendyPK35sl4rFnaXOewJ0A
         bvSSTNoFSoeWwwv1zqLtxrExSWfnMDUmRUNo2Rz0pKz+oq9b73h/moeB9aYf02u8QkLV
         0unHCh8D+wdg5wK0aLkYHEobuw1X6qmedD9Qdt4xNVsgbe293C59eOSQ6Vmu5zTllBvh
         hXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785127905; x=1785732705;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WZB1dUbaHZf6gE20F5i86eXcCl8V1AJSd3jw+FthmqI=;
        b=Lo17KxwGzq5xVHEFom8laqAD5tFmtgDTmQWoAI6T/dEn/+N96m9EqcjI/faniQ1Yxn
         JZBoqXBcCU7WtB/nozzDKPLALfgz5BBwHCa/FxMgzd3ZISfR8fuWKyPKnGaQNAqkVMlh
         sOPblsRXmF71ItqKCr2gdPlRbbyj+LTOanHWfYz21bO24cHcZQQTW3Z/4+VOXq570IEV
         9Vg2JLVHiQiV7O4ddcvEyiiDWTKpA1GnAlBFa7pufwjtqdo2uymiCTmTIXYTePCZ7BPS
         f0V3EzSgtirk0sADwb4x2Jp0IxKx1lukrR4m38YE+8rLMxYlsmZjzQ5K0bc1tlbxbI7I
         RPzw==
X-Gm-Message-State: AOJu0Yz6f2K+L0AvdaAzkDVuWiYs58kbANCpbmi6HFBQZ11UiQRjP3+E
	sF3xgP+aaOq8PtBP1iZpXqhjOK6aEGz5VQqJI7Itz7ZOsHg8j0y4upyEtFD3mqmkMCvQuoaDC6f
	cxJJ+OCxFxXAiYLMVXCALIU7psQ51Od9xLrEsK2N3BRI+crw7PvAY0qDJ8svTw8AyuV0rUw==
X-Gm-Gg: AR+sD11+CcRXzqSO8lYcMs1NMaDp+K1dlGkS4W22cd9WCih8ZaMzFik/pnKuTHM0F3P
	9j2Kw1ak3yFy5xAxKcT71QnBujXIXxYKDH1oSt4woiCKCYkmM7aq9hVFyPlGoWPU6n+wWoLA/CZ
	6x82QowPSvkVqpzY+EYk7qrwWkeCqOX7X8HSnG0JRJLYNCTNnnY/5CSv48HbirF0NT/tvHOeofg
	X+gkBAq06ciMeo2jgrg1ncQPyL1Gf4Gts0vUUaz7FKd806TwC6U1Mx/EjyC9SMaaQsPqAyfYtDK
	MFXnPRSqn0oTtaRakdUdkFAx2jsclSy1DF7e1CZNFEYbuft6uxhw5UN4qmSVAnnbuspcMCy9mDy
	zogxbwLgboEHt3q9JiGuSRIJHXuEiVY5fIE7KU3aX
X-Received: by 2002:a05:6300:86:b0:3c0:9c19:65a4 with SMTP id adf61e73a8af0-3c67e027636mr6609042637.76.1785127905566;
        Sun, 26 Jul 2026 21:51:45 -0700 (PDT)
X-Received: by 2002:a05:6300:86:b0:3c0:9c19:65a4 with SMTP id adf61e73a8af0-3c67e027636mr6609027637.76.1785127905109;
        Sun, 26 Jul 2026 21:51:45 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e127asm43520981eec.2.2026.07.26.21.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 21:51:44 -0700 (PDT)
Message-ID: <a4074061-0097-4baf-b11c-a265c7f30849@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 10:21:40 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Use different RX release ring
 sizes as per memory profiles
To: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA0NSBTYWx0ZWRfX/1iEkia71uWT
 RTslWyO/tdvEJa5ulpiPfcZT7UEEREsaE9FqdfzFsFHulris+Jj5DkDujLt3e/RmANmZT94lbSg
 EvVsBQ0iDI7skVIMC0M/J60p21xAQWgDbPezrPq8OOq0w3808XE3SvqrK6szC3qmcZUScFggqC2
 15eEkpD/v9K7G+pfFwdmuCUFJgMzW8rXG8WOe6aVeKRS4C6YI5hnmBC7r1e0ZgaGMp73RBEZhoV
 zHS/XRqGCIdWr8CCSINQM+ovWncWHYas1fkFxlvlW0ZlhjyvMNnnr4x+19C/rk/sisbl/oDl9lH
 Eu9I7O/WtGAXCreE3Vw0MRBmXNYctOc995UIaMMBVrGQpZ5kziikiT3KS6kFt++/JFGUEbth72K
 HO3xNiNzYmxuG/lM2HPQdiF5N/CNBlmgkzZqMS/9x8aUTYPbJJRvfpb2BTiSpLvQ9kcL6yhBW+M
 ZnBI4VJoe7GkQ6apf9w==
X-Authority-Analysis: v=2.4 cv=EYr4hvmC c=1 sm=1 tr=0 ts=6a66e3e2 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=32pKNZ-c1SNXjFBoJ0UA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: 3xMvndkhCtGyO51ZwL_XMXdUr9P85bVy
X-Proofpoint-GUID: 3xMvndkhCtGyO51ZwL_XMXdUr9P85bVy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA0NSBTYWx0ZWRfX2qVUvl1b5C9o
 U/9qyHUg0JlaECHg83xgW0tB0NWCQDB2aTExkasuZtIfhqB0zuTuzVl1ydxx6eDPqJhpW6TQxev
 bJZeA7wCFjyPY5qKEveByMQXwbdxyig=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270045

On 7/21/2026 4:34 PM, Pavankumar Nandeshwar wrote:
> Currently, the RX release ring size is hardcoded to 1024 entries via
> DP_RX_RELEASE_RING_SIZE. This value was sufficient for older generations,
> but is not adequate for Wi-Fi 7 scenarios with higher aggregation,
> parallel processing, and increased likelihood of error bursts.
> 
> In Wi-Fi 7, a PPDU can carry up to 1024 MPDUs and each MPDU may contain
> multiple MSDUs. In error scenarios such as REO out-of-order (OOR) events,
> a large number of MSDUs can be pushed to the RX release ring in a short
> duration. With multiple PPDUs being processed in parallel (e.g. multi-core
> or MLO scenarios), this can lead to significant bursts of descriptors.
> 
> Field observations have shown frequent OOR conditions and back-pressure
> issues with smaller ring sizes. Increasing the RX release ring size helps
> absorb these bursts and avoids back-pressure in the RXDMA/REO pipeline.
> Without sufficient ring capacity (e.g. 16K), back-pressure was observed
> under stress conditions.
> 
> To address this, make the RX release ring size configurable per memory
> profile by adding rx_release_ring_size to ath12k_dp_profile_params:
> 
> - Default memory profile: 16384 entries
> - Low memory profile (512M): 8192 entries
> 
> The larger size in the default profile improves robustness under high
> traffic and error conditions by reducing the probability of ring overflow
> and pipeline stalls. The reduced size in the low memory profile balances
> memory usage while still providing sufficient headroom compared to the
> previous fixed value.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> 
> Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
