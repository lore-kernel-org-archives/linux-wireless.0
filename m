Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AE9396B98
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976672; cv=none; b=C9TUoLnTEIo3STVKtOhd63Z72+uOv/fsIEHvsIXAS1hekDwUPRe4MjEmotT0JPH7hOUqYiRfI9zWHGP1D6MtAh5rRlZ6ecnrq8tPVWuDZOrOGCtzOSa8YwK/FBIeMxwnlbHm/tOD3t8MxpbtBngOk3uDWiRz3GUxaRQRjVlFxJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976672; c=relaxed/simple;
	bh=8O9bKRxlGnnLgywGJjQ/uZq8c6/fxYvVCDyT1TV4Qok=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MVQWQouRZbT4XMrO0KLbK3+yxjzBs28glk2Grg61WBDhS7RLG1BNHps7zSCq8Ms5N9rq6XXSj+Dexpl2ekLUk5fzUT9lkfZv7Nupcx2aPVvMsbLGdD4pwBdrPdgbtjG9i9AAvNVOjRP2tpNV203GY2Le55jS9+PFUcPjzYA9H10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BWULOAri; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VKDF3Esd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BWULOAri";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VKDF3Esd"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H77u91899443
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4AJdDXnIcC3t+ZLAD31bDqg6mlpTdQVsA4WJa0ECEew=; b=BWULOAriVHqVQG8n
	tV2cQ0wZ+HSihGKuJn9vhQZRABaQEWNzICia/Vfch/tI4MvpsHuhvj4UQ6KRVXEl
	dLFdboNh+xfAS4+Hn7bHaIQROZCcPFIrIgu+hJVCh1DXAbScSyMrN7e70FTq+DZ1
	ibxn2BK8vHr4cKCeBeHSlM3rjvewNNqah1tSNUtM5Y9biGcWM/wqT4a9Hu88gM43
	kXKORUuBFEt5NX3cJKSEq0det+ZujLLOaoXzhUu9a0QIp6fGFYC9BeqRktNDS6aa
	wvcGBNcrjKQzqavGNUB+Pw3cBt/JhsVoPDwBZ4KDZOByEKCQyKqPlIme0WcRuMtN
	lMLRkg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk77vhng6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:50 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so10739619a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976669; x=1789581469; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4AJdDXnIcC3t+ZLAD31bDqg6mlpTdQVsA4WJa0ECEew=;
        b=VKDF3EsdRmTwznNy5o76kPKCl0sle3EbANKirBrja7lsTZ3t10/gJSt/3nw6D7Jzg8
         iGd02Uaet/o7zEc3sH9ZmYltyVx/Dp4+WyG+JDkNPtUXrlU8q9hp1pvqc9cerIsylSRR
         dTHP5RFOrQBNcYg6r6gkPnUS3nBtm7d6wtspF3St46+ycjJbM9pqZFQ2zhKK80BNqI+8
         WDuUPuLmhnrmoSK7OT9vXO44R1gOS1G2dWklRGGLJzJPks2ZF7gmsluJsw2HlO/aX1/W
         IPsNUx5FwQiN20KcRTVQnmlrEs4m0ElbW/RAdTVYzK3UhV5Qk4aXPUXWAhW9dMcyV9dT
         SvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976669; x=1789581469;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4AJdDXnIcC3t+ZLAD31bDqg6mlpTdQVsA4WJa0ECEew=;
        b=Rwx0OaGOJHhKvExGLe9sGMpibvuTtM4+Tg1N3waYyeFMBsqp/5RoEDFnMApvmnyqPX
         9MkLjReRKGINkbnNxNqIqJUKSKvOpXFDSv/69l4W/Pq4VnoUkdyugXL7b1HUwXGx2wSu
         u5wLQIO3FXYeHoBqd4TZeO5XyaFIBQd1qgDlSt5mHDvqKaAHZb3g27SabNQ6nOuoHEbh
         EhonhogTieg6tp9eGpKapG0L1jN1sb/JZxkOEnWNwsqwuK+chA7U580PkCV21mTIuBS6
         PQB34WhZv283ZeiunCqRVY6qkcXKZX/C+LK2bWS1sOhmBdZp2gCTPbPSFQX3cmxpiUdC
         orIw==
X-Forwarded-Encrypted: i=1; AKwUvByX+UDT1MPuayBfL8ES7dPofkwu5p1MvkoSC/nsQQTfOoFHeqxajM7NqnL0um5oCK2uZYcsdT4mC9uOVk3b/A==@vger.kernel.org
X-Gm-Message-State: AFuF++kPw3w3qYykzi+7QXANL7+mf+gyd+xcby6qM6gTLIgvrcd7gkD1
	uD4BDj1LVuPjbMf0QtT7LC2vzjEiLTKZyESM/P73SZ9ERbmF70AYPzxMaMEJDL9lZtbbDZxwigU
	0kloVXRYzMDHAecYqvFgl62OO9LRx3cCWo49BEHFn0W6aGN/yqlJPP7GHqFlpkckprRkuJIWf/Q
	H/eQ==
X-Gm-Gg: AYBFou0E1h81M0d8abWgEwhOMYZYDEFuVHqirRerjQDM7OxWKDHF+DMginPWsrqb/8O
	D8Os6mGCoKmzHztSsDkkIq2h7ATXO5mAGxQB7Zl0S7G1isQWDaPq6gV23bxtqY7tsSGfBW8XHTP
	tBd+/LwJDVEksdtGpz6efoXf1lxPH0WaJIRFexnVUBf8AP3mAHhNC6sQSMwnY2Uv5J6BA7Z0B+l
	ph/Z5TsuUfTUWbsDqwHkT+xvu22bNY3UdiL0EVaKTc5F0o3bkudY4dC0EoznV6fr6aEZPDQHqU+
	nxj/Cwg3NSPEbteAgmZZmeayXwWnrWqjQ1sMCm/Kw78XIR3bzk/bt6PzWLfOwRo4s0NxVaT9EnX
	Bd/7+vLtH/p79yMsg45iPvw/uMke5/2tygtFx6bYzI/fvOdjlIjr8nQA=
X-Received: by 2002:a17:90b:2e86:b0:398:9be8:ea64 with SMTP id 98e67ed59e1d1-39bac3b0c7emr10982902a91.17.1788976669524;
        Wed, 09 Sep 2026 10:57:49 -0700 (PDT)
X-Received: by 2002:a17:90b:2e86:b0:398:9be8:ea64 with SMTP id 98e67ed59e1d1-39bac3b0c7emr10982822a91.17.1788976668916;
        Wed, 09 Sep 2026 10:57:48 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:45 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Linkai Gong <gonglinkai@kylinos.cn>
Cc: vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com, baochen.qiang@oss.qualcomm.com,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260811020523.387433-1-gonglinkai@kylinos.cn>
References: <20260811020523.387433-1-gonglinkai@kylinos.cn>
Subject: Re: [PATCH v2] wifi: ath12k: clear dangling channel pointers on
 error paths
Message-Id: <178897666508.2048605.17545031957726182083.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:45 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=GKk41ONK c=1 sm=1 tr=0 ts=6aa19e1e cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=CpnD9HFvDKrr3bQfTTUA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: P-ODPmn_FkuCulqG8YhwoS6cfy9NOmWr
X-Proofpoint-GUID: P-ODPmn_FkuCulqG8YhwoS6cfy9NOmWr
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX95M/2DEMJyFB
 OM/cNs2mz441NKZy3gqaOzJrEGAiA1Pyse1VbVh1VXOaeFH/vsWJ9D4D7O9OZCQdkTcl4ocJzpa
 YqLTx9bFu0hFb67jMFaoJ1kxR+Enuxo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX59GP+JX8BJ/+
 9QAGd83RaXGzzgc/KprOtLd1Ydj2L3Eo5IpS/JOwFe5hpg+xEAfPmSnw1xvBWYDqJ7xA2t0u7ZQ
 r1z7McNSOs4pppi2A18rXu0/OSBxZM2bQRFHUV+Rj2GL1CkNqidR9OfXAIrviT5MJF639o+ACRE
 mvxi/AoijpnU6WBy8EyS1x088hH8FbKUcZBrSH/KnWY3muzqmizgc8nAgYElCbfoITjOQ3MHf1w
 /IBqcVmprj3W3i2i1KNl27Tuxe6BmqP6zd4NgvDgjlrhIkc/X239B/i/ZRq/jGICFaJ4EdiiQve
 PEk8Ss7oEgtgkyrZKf/DD+VGWPaU2vaaYaPTKeD6mcwcXlrEw8X2BSWPDN6gY7cNPBagExqsQpo
 /VG6vZ8Dh+fELolCF+DglxT7vSIlUAIev5nSDGA9IF9FmHtQWA7tXOgDP6JBB70ykQe+sOzI560
 ZbjqsRtoGnEbNTrmbdA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Tue, 11 Aug 2026 10:05:23 +0800, Linkai Gong wrote:
> On failure, ath12k_mac_setup_channels_rates() frees band channel
> arrays but leaves the pointers set, or clears the wrong band after a
> copy-paste typo (6 GHz free paired with a 2 GHz NULL). Clear the
> matching sbands[].channels pointer after each kfree().
> 
> Compile tested only.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: clear dangling channel pointers on error paths
      commit: 507478f6f93864978a399173d4f54c8a987c8235

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

