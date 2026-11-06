Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979614;
	b=CE75soSBLxWvUFhPSXfHIipjcSHGxukI3HwrYFey4cQxSeAfq7mkTup8wtzEFJzsxKG0
	 T60aBc4fQ0aMtL3yJ0v8Qwl86PbWgh2WXv1GWy/bDi4tlY7xihzJeljaPxJpe2ugJXHKi
	 a9/btZEtkUIVwH0x6Kew8IsvLfnBYqP6+33eoUbpz4XFXYy5WSUERUIbf3zLIcMgvSglm
	 oGl/2pLtODeyyeRhybJBZS9INzaVprAlt6ITiABQKTuI9JgBfVvIOjX2RUCpvkONfpg7h
	 nqlhLxGh6U7GsWmAE0wbU2Slh8toZmtoiDT63KNZQyynsrcVEF5ijwLNv+v92SqsQvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979614;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7RDbC0pALLr5CnExCFDRPuafJ92+0xlIvMW5RZJKZVA=;
	b=vB9dVY+GGTjiyVkkenjquaE2q45sDzvXv87B6L7CBmOsfIZRcjAUYEafbjSnIQTPufwl
	 G8IXtlk7eCS9PD3EytPPrqIO7oIi8mKb3Gu+fMmde948m8a+cyumCFpXdpoA8WVr9v4fv
	 4vbzXp0ofFBzvtmvdX0Y4lRbkq4+0PipMG0LnLOG/Zw55IUJqq6BYREn0qAz08LxGFN9Z
	 zhh5YmzY60H1Px5vBLRS2x8iRuxR+9eVg8DOhXYCz8D6Hy1yLVBGNTFPqZXtu/EhM/5aB
	 RHOPLm4fLPvn7iG+oQ5ZQyfIB63tIRnJWie5M0EkBAvSvA29VKZpfn7/lvvzxWDnQRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ETlvFZcx;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N+R94mQk;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66502606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 15:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66502606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ETlvFZcx;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N+R94mQk
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6F07SP1039755
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 15:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7RDbC0pALLr5CnExCFDRPuafJ92+0xlIvMW5RZJKZVA=; b=ETlvFZcxJaJbViQg
	s1Clz3k1BfRQ4S4/4cRR1kIAadFr0qPEgoNsYlsygLNDjsEoeM77wm/Hcp88th/r
	8wI2M8bAUQ1EorbRlwe99asSu2nCoRL97F+Taa7Tjmfu3d+9XXF07rWI61euufRO
	ViW6LkGvLeF1ZI/Pawk4gFyM7nBvaM7TCiG1/h686QO4ILjPl2pcbmcZ7u8grVAj
	iWnzzM3xA/QqNpq+JpcTHyekjVg7spprisImQQYmWUrMcgXsboenr0HkGa0CSf2B
	FZ7Puxmd+N93Mj6PD4Yp+Wh98ZdumTXu1qnyS2UTzcwAzPBsZbazi9srBNPoAbm/
	N6B0qA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9ufeu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 15:40:13 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36d1353fdcdso219102eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793979613; x=1794584413; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RDbC0pALLr5CnExCFDRPuafJ92+0xlIvMW5RZJKZVA=;
        b=N+R94mQkTfp9rDrrcQVCx90uwDppsz+XFcGipvLBqDTDJRVJcwpBrPgeICafu5qf/3
         8IqtAEpvthPKCCXW09PF8yc4REV+fG403kWvIN5Rtjk0tiRnxc889Adl0pTMQJheQi2M
         7WMcn/yNNirLUYjPiQUFGBum6X8dESAb8n2jKK5N+Vb/LUTLMs1gC4IaUKum34uL+bLG
         jUsy6VxcZDF7RxWhgvZk/ZuMfhOhFAuK3IFAijYOWuW7G205m+gFlpPJUZoGmM11hiUX
         1jbtSBJ3X3xwn/vYtDqZ3LnY9RyxNstGKG2zAprKA42XF3xL+fvOoC5k/YhmmqCKZULq
         AkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793979613; x=1794584413;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7RDbC0pALLr5CnExCFDRPuafJ92+0xlIvMW5RZJKZVA=;
        b=Uy8Ja5BPmRAXej1smcMP4psOi60mg4KYvUHx81YCoXwwEQQplcVdTDOpHmt9SVAjO1
         4La/upf7SiVFlupUk0ADTL/SbUQoMuN6lghptMMfP4hNpgze30k1+KaddWT4O9vwH4Tq
         kUFXxuDGQsx/SJMD9965qDNyRoFMiBaB2b702H85ZnEujoRETfv29wIS6jNMbfsvQUh1
         D0YMBOs9XXQ4xs1h/yFmjGCoqosPQC21GwE7I4GOFdC9qW9IdjEwT9XWMm5++ZjyAbkV
         8xnEq71cc3qBeSaurHiPR8MfeMhq63rqYckI1M7vOfw9eWEsq3u240cnv12a/FmqdxOW
         /OQA==
X-Forwarded-Encrypted: i=1; AL+hErEAFJDjdXI+a1dLQt/gtg9j1vH6VCwrC/m4YKAu+eRZ3LsrILLVy27g05eKSz6zT3QevgKOfWt7o4/NEz9BTQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z84DX4tZMO3V1aSN7EkJWFQOv/Wf8zx781mahU6l7DwrofisJPN
	/5VEVTbwoacacDtfPiiD81vB6RVwjsynhA/rCETBXTe97q9p6FmNN41tzMfDmYlSYqOR4PotsPl
	6vNcX9Ha31t0Ia4X/KRMYQovD1fOwr2GrwPRwULghP95sJCDbJueFUliR2gqlAV9tEICjUg==
X-Gm-Gg: AYBFou2rWM0+CUmRuaPb8ULcuJky5/0YuB0fg3c6f0YSVH4EldrBY+GPk/J0BHxbPQd
	uD0C3lp1Tow1Oe91hd4pEqIyjysWI4ww8pAAVxfFitfSDaneKI1shl3eKJZJGN+eScBT4cVZ4WU
	ypx4E25m8Bd4wQv/L/q+YIsRRNe04vBzfC2a2WmAGd0nKM7KQVYgWfGboOAfrcY0p+6ncLoEgGS
	vuWcuXHgXqsCh6TDKRMPSt8qo3WwgCzaWMykMf2nZMfwmmSEt6hAIMQuJTdwFlcF/vbUynCOhSO
	I6ZZvDeM5wK3pO3tbEm3i2NJ1cXTOUAAv1bATgIRcAn30+RHezx4tFIVGCXflsdk/9cGL42AGEn
	hS0Z50r5XLCRGRLlw+8wXE41IIOi/xvk9LkesKSeIr9jLrJYYVDViL87NmkrDVGREJR9ZhhOjeY
	uVJk8bcnSc5aUCyMUxt5TFIVBVLIA=
X-Received: by 2002:a05:7300:8281:b0:369:f2f4:b227 with SMTP id 5a478bee46e88-36f75b1ffd2mr3243550eec.18.1793979612724;
        Fri, 06 Nov 2026 07:40:12 -0800 (PST)
X-Received: by 2002:a05:7300:8281:b0:369:f2f4:b227 with SMTP id 5a478bee46e88-36f75b1ffd2mr3243509eec.18.1793979611960;
        Fri, 06 Nov 2026 07:40:11 -0800 (PST)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa97fbb54sm9851246eec.13.2026.11.06.07.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 07:40:10 -0800 (PST)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jiale Yao <yaojiale02@163.com>
In-Reply-To: <20260926114037.3231795-1-yaojiale02@163.com>
References: <20260926114037.3231795-1-yaojiale02@163.com>
Subject: Re: [PATCH] wifi: ath11k: Reject short management RX frames
Message-Id: <179397961055.1195422.13808864180410221932.b4-ty@b4>
Date: Fri, 06 Nov 2026 07:40:10 -0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA2MiBTYWx0ZWRfX720uHnm8QVXC
 umERWhFinxY8IiYKGl+1thB82VOGnuEkw6/5Lm15LTjwZ9BoaPY7x+RfwHS9HNsJ38P7HbYtowF
 5opbBCmKYapogl31yNQ4cAEKaZNEDIE=
X-Proofpoint-GUID: R1BPKEduRDGoLFdKhrKD56c0FMhpUh-G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA2MiBTYWx0ZWRfXxEdF0mmiGhfv
 FiVAshAEl+AQGIHxwyh0+ATorYtEIq1WTB5Xpxjuz079P4vSpx3SiqeMrnT5K8SylG0/PBNwsQw
 FpKqWgMDlNHEhOmyGjVxgnnYdSJfFXnlMUkuL75DOyP2vFAuMWkPHvnQnh3H+CS+ukjhXrC2S9Q
 W9P1r1bO6DTiugMhhxk719Hm5ykxmcXXjAVZywRnS5UkFpz9JKpNj2CLmVOpeycx3SJmIjhxqJU
 f0QibqppAZRj6/57uNLAiksfO+bR/kCHr+uzfYGrNv/nJChToURmEITMP+Qs/TnWBsAokzma2+e
 wWQeKGLNNIXWThO5CqAyojjYLAHTeE6120YA4xMirfx0aDKdgty4SqKPDDLASyvcGkPbzHvlkx3
 ESo9xUwyBx9rduD8iD6LMBOf1tBBw4ORoWV3FIDvetGIqf/nHkmOXu9NVtmgyCaW6NXxRdg6nCF
 vkC+tg2pW8yvkBZVlAQ==
X-Proofpoint-ORIG-GUID: R1BPKEduRDGoLFdKhrKD56c0FMhpUh-G
X-Authority-Analysis: v=2.4 cv=ZIZCCn7b c=1 sm=1 tr=0 ts=6aedf4dd cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=mSvAxenApeD-3uNJg0EA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060062


On Sat, 26 Sep 2026 19:40:37 +0800, Jiale Yao wrote:
> ath11k_pull_mgmt_rx_params_tlv() verifies that the firmware-reported frame
> length fits in the WMI event, but does not ensure that it can hold an IEEE
> 802.11 management header. It then sets skb->len to that reported length.
> 
> ath11k_mgmt_rx_event() subsequently reads frame_control and other header
> fields without another length check. A firmware event with a short buf_len
> can therefore cause an out-of-bounds read.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: Reject short management RX frames
      commit: 9e15ccad0877c4a748bf2b817811a23f2d71bd92

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

