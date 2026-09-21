Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94904F391B
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790013615; cv=none; b=VLp80/A7ltR9EvivmJohlYohfWTIT6DHJ8xzxVH7LMYB+7x8w73MTBxfbIgx4FiYAUbR59avd/I+p6I1hng7zlN6Y7+J7eqJiqBu03CDHJRAv0hCeqwv5s6spIgo9DdQiOL8zyCzOFCPUk5/3TrCHmQGWBV9iTKIaYgVjeX5WBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790013615; c=relaxed/simple;
	bh=V/azQhttc44ebopSYPCbCKIgpwm4SqDUHB3m4ffi+Tk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=J6QRQmEk+jKOY0MtBliqA9p9nYutV252aJLa2I0eC0AeDiXQ8HbONmD9mO2g3QlWB1Z9XIuAEdbRlP1h8Y6+1UYj6SquMuAQ0tZvT1WEWV0CqfaQ+82Hm2ExxatRlbA0QkP/u4Qz9FojSj5PvWWhpYxcGM9QKKcmzUs7DbtSdfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XJ22OteC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qb0hj+C6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XJ22OteC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qb0hj+C6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LFAIes2011980
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pm5B7pklnwfPYckNndlu/FGgaXUOCb3QM83BtmKF8D4=; b=XJ22OteCctDIchKI
	LRkHsw4T5MEUUm+yqX3wRx2CO38VN/Nh/dC+WCkoMGPzSpsdazHiC2F2rQnAM0lS
	7COR8x0+t8jt2Ygtdtus1o+suchhk5bQOFir/nHRzvRnezw1dya0ljqDYTZa32qs
	ZEu8+qG2vzvvyBwUtiE6afk7Y5TBofv8/guRYhCJFyQS8efgq8L3i4EEjf8s/Jqm
	k64V1rLlZVa54ijo1u4j7TmDrVJGP/T6hsPDUbMEGTOcjI7lyoZ697cP8CKE8SDU
	ZCxX/tRckE8txaQIYOucCu5YQYba0hVUnXjLyWZaVwZh7TIxYR+06bi4X6BZDIGS
	8vWSaA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu01d2m7p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:12 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca8aee88725so4812341a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 11:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790013612; x=1790618412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pm5B7pklnwfPYckNndlu/FGgaXUOCb3QM83BtmKF8D4=;
        b=Qb0hj+C6sPF5zzT6vnqHxScnt12gqf59cFpkI+QQmY+Rf8cIo7iw+PA/X7q7VbQ/rE
         OHSLZNyr00+LzAeUi0XHGxEDhtBBv1w7GphAEyA9U8+qQgyNtcNlPSaqKhsLCMy9Vc6O
         bnOnqj2Nx2eYYd0cucs8OhJMYsYlvLPVkA0CoNsgNjNfjrUbEjM2jHDShro98vsJumG2
         cWEXavxWVgIBzcOCoFkvECWnluu1tn3x1GtMyKFDusoVb6+Je+6Czk1fVBC3t3QrS4+U
         QpciHB3kWaS8+aRb0nagqyQ6WCx6BPjzloZ+mXVdpFJKVwaM16kJKh8t6oCiLrVhXff+
         bjwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790013612; x=1790618412;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pm5B7pklnwfPYckNndlu/FGgaXUOCb3QM83BtmKF8D4=;
        b=yO3D9EF6Tvpx761kyn3MuDBT3JVZuDyoq4mbiUZZ9ELx7B7NIPMgF4if0XpwBnrQJp
         ic3DuRqg7W3Zce8W5Y3NShN6gCnq+RTl0sTmJGEOA5tv+3tYHXSxBA6f3b7M7zR7ajC+
         dvGibdJg9rfrkhYGPUKt/d0HtOtUEImvTFk73W6RlXnpUB7niScLkzx1J0g/nHHFJm2c
         3oCvkkTOzRK5M051PAq5B/FgaU2S1qurp0Ynq1wSD0Dq6n88otIBHKdRYKkH4b2YDfS8
         PBlsZA5SQTTT14bJSK7judoLuGzFDQbGXmdl6DvKHuTAdO8xTSwm2g/+NFFU0GBfl6z6
         Dy5Q==
X-Gm-Message-State: AFuF++k/fxErd+XchqMMs+tbY1s8GO/Ut94nBXHatwuf7jHwy8sgdB3G
	bXXdmmEr/Ih6SYBgNx35ZquC1RZa4JgCmrmtAWMK5NM+IrF4H4MapxEvEJYzhJLR0UB3KZXm3W9
	NJUpVjO5NC2VX0ZbVtbpPLywk2r+YzIFMC+hfOSVYLfwCd229UyQ7nz90zrQHoARtlHzRmYylvA
	MSrw==
X-Gm-Gg: AYBFou2qyyefJcqHTkKlI8NwCu3UHrZrTH2AR9yChpxAQv6hASwo9I5Dy/Wdeb5V8JI
	NVbeP3+tvj40mYR41IN8ZjuOExT8mBuZPzNrIW1GnwNBrvbuWPMT9/YzjLZg69fyGH1NA6K5XC9
	6T7GVYeCoz2ugNM6DP//4rdnfYLMQ7vf7+HyJbw6DA7V3D/Fh4P5ZgbYhuZxk8H+Fcl4RJUPouy
	ptEp9lbNnonG1lVMdiWvNs7nkATmQ/7HF39R0a9pi3yzAld/66Rt8xH9SoWoHmTlRy06euSXCxC
	CYNnPkgwej1qcFqQ5+mqROJQH7HYfGCMu7x/BoIQK3aH+gRBm5yyCNRwOPUk2w3dpAmYjnEnn2D
	c0KDO4EtAH87GMoOaZa7uDNmMd/ng0y3p4+owkQHldoGJdKb6XnMVXQ==
X-Received: by 2002:a05:6a21:1505:b0:3dd:85a8:4c5b with SMTP id adf61e73a8af0-3dd8c591b15mr17679621637.34.1790013611649;
        Mon, 21 Sep 2026 11:00:11 -0700 (PDT)
X-Received: by 2002:a05:6a21:1505:b0:3dd:85a8:4c5b with SMTP id adf61e73a8af0-3dd8c591b15mr17679578637.34.1790013611105;
        Mon, 21 Sep 2026 11:00:11 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c3311a716sm22873198eec.8.2026.09.21.11.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:00:09 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260814075837.20005-1-pengpeng@iscas.ac.cn>
References: <20260814075837.20005-1-pengpeng@iscas.ac.cn>
Subject: Re: [PATCH v2] wifi: ath9k: reject short WMI command responses
Message-Id: <179001360935.250336.10074436066616143164.b4-ty@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:00:09 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: Rqa9rqKjkAmdbbFo59_CBE9bBA9XH_HC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDI2MyBTYWx0ZWRfX0Rv9InmaUmyH
 Gc5XebjgNh2wZ6vvjQTLU224f4+9aRxOhQE454t4deH13qasylHP0NyDcvRgHZF87W3mgd9ToLx
 C64pw6GCThAIxS76vq+8odiViEpsjsQ=
X-Proofpoint-GUID: Rqa9rqKjkAmdbbFo59_CBE9bBA9XH_HC
X-Authority-Analysis: v=2.4 cv=Ht7jiETS c=1 sm=1 tr=0 ts=6ab170ac cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=2Cg4bRl-HtXqh6CIwg4A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDI2MyBTYWx0ZWRfX2T6F6u/WNp31
 SFCsWCSCXrd3IXIjAlGf0DsgMSzEBdKJjR+FCePnVhgAv8TxsRNwg1OPsW5jD6fSszsNq1Fm6uu
 8oPPt8T/ebmQZPyD1oFW14wu9d+uYeEX6EMz60gluGAvh5eJ39PwK0ZhFYdGo0jxo/URSum0Q0v
 19b7Pv/oo4V5a0NJiTZ5nbZgCRexxY/uSlsTEhhcQ/SySJdE11qjS32E+bP99frGn2NQssOiO6G
 gmmKq7TXDO/JUKo9HEfQzMZnjnYTxKc/nZ4rXkaqStdNUbePPa1rG279N0d3OLTtF0aA5W48iLG
 W98BvcS9jjK7OLjYbD9hjURAZdlCEE33E8OTFVhmTUMwv49y5e4N1pbCuh69bC4FJkgeD5aSrX8
 BxyT1x7D2RBiSdBU1U9tglE0lRh+bNIJDK+NfOGwQmhoYRPwpy+h2EXOIjfxA88aco3ElXuLaWy
 L8oQIfWvlXjP/tugbkw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210263


On Fri, 14 Aug 2026 15:58:37 +0800, Pengpeng Hou wrote:
> ath9k_wmi_rsp_callback() removes the validated WMI header and copies
> the number of bytes expected by the waiting command into its response
> buffer. A device response shorter than that expectation can therefore
> be read beyond the skb payload.
> 
> Record -EMSGSIZE for a short response, complete the waiter, and return
> the stored status from the command path. This also prevents callers from
> consuming stale response bytes as a successful reply.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath9k: reject short WMI command responses
      commit: 93ce8ea70451e800601bc9444aa33043de15d67b

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

