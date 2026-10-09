Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57501A76BB
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 01:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510583; cv=none; b=G0SVNEuwHfOcs8JiNcrOF3Io9+nhcfs5A9tJJRP7U677F1KT1FwZassw28nVTYutHWHSW5KLpXN00Ui3qI0w0HCePt+qfuyzRaYhKHsWL7d/bTpABjfQ2g5S27Ds//0Ymj00fjwd/SqY9QG5a2OkVJzq+F2nkejzQRvdtJUzgcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510583; c=relaxed/simple;
	bh=ca5Mgs+luSErxHnEBUS3+I2ZBtbK8wRBQhy3brjHCSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KtHbzl5qQHVVQZyaTQvNwexRprCmdwkBrBGj15Pxx3CHymJLs3mYAZtIhCL8V0d9yT4zUtJoYeTJwELdrXyJWe4dpIMZc164tiia5sOqHBxflKrDhdxf0xybpL25PFHt65iPa2UUpkV/LF9YUQMoG19Ct5X0K21fpABihqEyCmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ik0rWI50; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NrufmFTq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ik0rWI50";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NrufmFTq"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6990POH23578500
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 01:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	reYM3P+nlWFzN0k3Z53zyDtS0t70RVoAF/laZ8YyJOU=; b=Ik0rWI50KOxBilrS
	XZf/mw5UmwiBYR71M0YEfB3+x7S3JoAJd4JhNDqKnREsbV9aDoXtE0bWnWOPSFqm
	7QmikVL/8XxAfiCr0tgwVNq4GUlqttKgEaG4totioBflBr0GqmE/VfG51i6qZ1Fg
	Z/VwNn8+06SoTXxZkbl5rYYQewv202TJgG16PHcbCrQCHhJVlE9eF56NACtVFtGh
	hfPcrVifJ7q7W8Gg5N3HH444/0GhTMdQwc9D1X5Csc3Dzuhw0m/4zHmEK0EeCJEt
	7RVUH1G7dMfcMbJM6YBmwPC1Qp/KQxw+Su9nAyMbMg7T8YsYpi/+A8Seah3kW/Ls
	UNK/iA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fxk1d29-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 01:49:40 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2db8e9fe9c7so61437955ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 18:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791510579; x=1792115379; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=reYM3P+nlWFzN0k3Z53zyDtS0t70RVoAF/laZ8YyJOU=;
        b=NrufmFTqkKNZaDYMdck7OIO7VOfDtIKiQyrv4SIepKwY9M8DNTeQ7pCaufg/vdXVW2
         oNtqsRfsbw2TZgdBJFqcnLqQ2zEUDFWrQELcWDBcbd+W8AlhfcRQSkZcUPs4iJAUFsGB
         Rgv9iQ/jiZa7J+/QMElko3NQJ8WNRfpHA/VNBZfSxFNXU+ImeGuCPGdHlo+3+ACVd2iB
         tjHJxXuRSLFnuRXOQ1LHDWYsc7eo7uWMrBUVDQEcrIzbBFi4LpcTB2/Nr4mS0q2MrjWr
         R/q3Cn5K5YiHsA44BbQKL0cpsxo5RxTFNuglYkEI/rAydK2MqjWb1+5fU6SNjC1dEPux
         cKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510579; x=1792115379;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=reYM3P+nlWFzN0k3Z53zyDtS0t70RVoAF/laZ8YyJOU=;
        b=LEk5lLtRRyA+qKmR7b2XOD66mseUmqu997xqe61D6nLNYOe3X4D0xN8p/9/6N68WBZ
         ipByy4HrqyUq0/yXtQ1cVFzw1lMYESiZR5Fo7UgG2taYFhhMlA9FhwPCQ+g4OrcChUk8
         5lwKuqSg+g2W/TFtuJI4rF5iuQWxGRMnyuJOr12+aMOL9CaJ2Cm4t4BegMfb2uqK9hTY
         gh4tS6tlt41tITMssTr+BIOYqAPXM0Zp8pfhVHL7+r3VOyI2L0HOfIB3h/4ehGWJMny5
         tZwPSgS8xe+xhK+AJOwa41CZPuUW0Y1J2L+7EEPONo0r8pP+Lnf88jfRoxTAVfF8Su9+
         14qg==
X-Gm-Message-State: AFq9FYK9a2NZgxg6p3ITqLGSic0utrLZofiRcFduvYIPteTF2Qw6ntZ/
	E0SnT6CqOAcEANXj+CoPkM5/S/lUYmqW1KJErLVk7Y8ZdYMxsyxUbJkAOwmBRp86s7zOM9AJfLv
	TdTiIv7hcsduU0R7YfNy5wLhmJZtiQE3+t87HY0YtjUkVRjiZuPhhYSdrTLZPa8sy2Rj66w==
X-Gm-Gg: AYBFou3Ak4jMS1lnTC6uKS5dGMhAeWZIaTMZuY3jPngX2lCzvu/xPMEoIPMvvUvxxl8
	lVqlv8A5dDqJTU989X34dlS+Ntas00WiE0KUtxRyJaiPHuErD5ciqkICK0LuPNsi6B+JZoaN13g
	obD/urdTdumf7feG6Sf7HLd1R0C/dDtcmZwJzqWVmCwZykQFfT+wezr36yjych/naVwZZAsIdIN
	w6piRdPH6htJPH9ln8HfY6liMje3UvcBu1sBokQtzeljEW1chiFobsLhBSc980sYB0ayQ+yqrv5
	dACmhuY5m+pslfYHvmq/wA3i+0UCQjXOaFF9p+mGWNsMi6E7A93o0E3yZChNIDDeqCdhydxQTGd
	7beMZ5fJ6K2U6DczSLLEiUz9lR01QKvEf6AkuWmqSzCH/HvH3we/dd+GtaiUhP0n6/S0v/xk=
X-Received: by 2002:a17:90b:48c7:b0:3ab:8b2:72bf with SMTP id 98e67ed59e1d1-3ab3a928525mr595795a91.50.1791510579453;
        Thu, 08 Oct 2026 18:49:39 -0700 (PDT)
X-Received: by 2002:a17:90b:48c7:b0:3ab:8b2:72bf with SMTP id 98e67ed59e1d1-3ab3a928525mr595778a91.50.1791510578920;
        Thu, 08 Oct 2026 18:49:38 -0700 (PDT)
Received: from [10.133.33.26] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38e041d4sm1324187a91.9.2026.10.08.18.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 18:49:38 -0700 (PDT)
Message-ID: <9a82f0ae-535b-4493-a5b7-07af047d094b@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 09:49:35 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Remove unused
 HAL_RX_REO_QUEUE_INFO macros
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260413-hal_rx_reo_queue_info2_msdu_count-v1-1-c4c92ccf77b9@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260413-hal_rx_reo_queue_info2_msdu_count-v1-1-c4c92ccf77b9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac84834 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=ih17vKD8RMQI-mVctmIA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: LYNhoM2EhG7GmPNEyq8BLJ1yQbYLN682
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAwNyBTYWx0ZWRfXy4mxqORwSO3s
 PCkuzk4aO7vTrthRM5kIfyMo6a6pjGW65jTK/G65Js2MCdZXAF7D7475LM5Vdo7PCabKsXMZ+lS
 RQkI2VsYdgCf7WRiExnnq/huj6EHT1o=
X-Proofpoint-ORIG-GUID: LYNhoM2EhG7GmPNEyq8BLJ1yQbYLN682
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAwNyBTYWx0ZWRfX1f66OlvXna/x
 yFzG4AYIsNL8uN9Cg+AOGaezPzWcOEOXJYk463g4OtwjtwaJ4QAUBnJZ5oi2x1oR5Ar3JnEcBZ0
 J6zneGV8WAcTubO8IMCVlwaIPjKi7Ct+sHA6iA6q3FEMo+CO2IBGIJunf9gZ3dpl3fby001Qc3Y
 iYX24DoXXHfoyQ0ffIBlgn+6+S0QqcnBS/EvImJyw1wS8GTPtedB6MdWiC3IBVu6plxPutLlJWF
 /0KPQlmWsS229SA2QHJd9gMhu7SriY16HQ+aBMRj1juySsLMZi7UF44krjbmyHQDE3l3FIYwsgm
 OuQiQaTVazjhE9SI77+MQiSK4BsDiZKfISuDvp8l7eU1X1dcoDUg0tR+x2k6nh3my4vFcUZUJDw
 1WzTsRJzOQ4vIB8Ga5fOzMbPxpGI8I+k8MsUNJYyL5AwYFqj8ncv9B0cQ19C218lv3QTjReG/Ro
 iqA7QDBkqbxXHqyEgxg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_01,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090007



On 4/14/2026 7:58 AM, Jeff Johnson wrote:
> Many of the HAL_RX_REO_QUEUE_INFO macros are unused, so remove them.
> 
> No functional change. Compile Tested only.
> 
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

