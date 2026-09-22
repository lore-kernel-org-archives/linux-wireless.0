Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ACC36B939
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 01:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790040320; cv=none; b=QERp9Y2tEqXQBFhk/1Ff8LvgacP0L1om/We24SdqTU2KKmAppKXAuPZ9mP3wRpt2zudKoxWX9qzmEF11ib1KMjgQMyicDAJQDM+4KephNGHqgs+YQC/v9SLojbWf3M6t8P/LXYTYEMCm1mUdXd2ZnlEZOX/Z1EswC+MpKySFqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790040320; c=relaxed/simple;
	bh=ojjBB5aRep5ewnyN+VVGLDfjShlsAESfPDQ5NjB5RBQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=FDDalTgb2qceYZ52HPR1BYCecr0iZEbeUiff2TRcZArc61426FSXbYMTGmMwtHYbAnC5ISPRRO1bpe8lyCZ7/p5k/Uo6kAy+v9HBUeowrrxIabKrac1L6A4Hw2i9rKJVnWk+6aB/rIMANyYc51briP6ja/BQfKNVxbPIIbpBaHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IfZgR2uj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QKSF72Es; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IfZgR2uj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QKSF72Es"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68M00Pt63306567
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 01:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=v66LYWtKI8kl0sQYCAEnWh
	cI4TUzobxM+G7V+VWy7YA=; b=IfZgR2ujMWGQcEz/UR6Zju4tHgRvaYK9eBrWXF
	oHAMfFV0V5DSpCNoka8lw+n99HXDBDL7Yp56o1ynk92YQ2kUZceFTsXONB9T303v
	pTWsuZ1H515EL+ZYW2M4JF+SmKHGLnMB7h/js0OYKqvF7n1i2yErUEKd866tC9zJ
	3fxgaL5sOWUqIJgZviyNCr6fXLmlnFTxjfHWseIYmflxFdaheziu7SsMbT2MNu0S
	GipnThY+3kT5wxatjNFwKUi/QvgbXuXAyQYvvzrix6TJeUVDVUk/dM97v2QJeMtq
	R0Td3CZXjcLyxR/JXGHO5WUMUCB+lPxMK5v3gLRpcuQ8vxNg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gtysw44ef-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 01:25:18 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1b6f65dacso3125787a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790040317; x=1790645117; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=v66LYWtKI8kl0sQYCAEnWhcI4TUzobxM+G7V+VWy7YA=;
        b=QKSF72EsW5H3XOtEx7dXiO4DjVe5w9nkzxd5YYbBYv7J/z/e9oydY1+PvNOxI/wnx+
         1/w9F+NhZZnXsDTnmLy5Oq75IM0sbbemuPEN6M90u3gNw4tU1eREpM2WS/xvR8XAtWzh
         SX0GtBuK29ltAjastBx+hASEF1B6EB8lmIcLR0jvu7h5z6ecYrlLHlwN13jWbIflq0Yp
         9snnK5BCyKrAtQTfQ5RpwJFWh2MeZHrN+af1Ad2abesXio8QBUyz6R8Lj8Jpl7AFV5nY
         aHxw7a4JzmXONp3DIiWN3P487MWEqCXrakvQ3xzRlaOa8z9UvZzpOtPmT6FdyhPL66J3
         bm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790040317; x=1790645117;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v66LYWtKI8kl0sQYCAEnWhcI4TUzobxM+G7V+VWy7YA=;
        b=grw1sq+Og3B5I6pc/LvzRYzbM/mnFE36J4g1M3wHuliOyOaKjr/789bTmt5vDC0QmT
         CL5T3AL6WYh5uqTTzrhNNL/dLN4vFwIOGsYG4t5XG7GzJPavbffuEySDvOnCeFWBSypU
         zlfHwqhQevard4UDtPWJuYnMhZi492h+XioMToSOaQ+v0p8DvAxYNe97d9nPaP+56pkB
         6jEauujsVXB5zmCDFDgAsjlW1APvmo74HMPlNbTTO9wPrS7Dms/cPaqT4o2JiHBjFkxl
         SAT0zm6YWIx0ij06cyLe+AyWWitc07p7n5gJZZ8rJ3MvGeFiXHzhRPaIKJSMcU8lkvIM
         Ni3g==
X-Gm-Message-State: AFuF++nNcIV0YOAcB44Y9AOOw/piQP3CIT27UnXyU5lKy4R7DXxT9D7c
	CdVnlIuEKBRjB9+13pPNes8FyyOCeFUBHnDtJeUFeg211UxAUoChJsgwiN5hHozQp0oKJ0wXweX
	bNzLrGA3TmkhX5KukRPsoT6ZM6ihLH7OeV0Ux1zM0R3NR5UJ6kRQGzcVukvYUxnKR4qhjfXQCx6
	t0Bw==
X-Gm-Gg: AYBFou2gKxUowgeM316eezqIzvbfrMUyGFqf8z35gDpRDiuV0Of6CBF7C6ER4Az51ip
	uppg7TyZkl2VRYxP9usJ2IwSA9XAFCqwf0hv1GpbYYBimvREfsDW/SxVXv6x4w1+hnG1hLPzB0+
	iH0/njAnsFPZOpMdYhdrDg/1SBR2gDacMdvUt832+eIda4qrKA09OMJqQjgbnxdDPiAppIMIqi5
	AfhEwpYtkFLFr/Hb/Q/DBbr2zwnBVmWeIXnznjLdqq2UB0xPmt10qj4cdml0B96FSw1vNoHOaTW
	r7ZlSeJmE12yGu8HdTOVoTMY34s6pSusGFMyRj2O7981agIyj4S6OcuwNaTUU6idSBe/x6SAt/a
	vAQbv9uDQ9gtbv6ZJwV3X5u0y8GmJoc3ObuA=
X-Received: by 2002:a05:6a21:390:b0:3c3:bbe6:95de with SMTP id adf61e73a8af0-3dd8c3d18afmr21360149637.6.1790040317034;
        Mon, 21 Sep 2026 18:25:17 -0700 (PDT)
X-Received: by 2002:a05:6a21:390:b0:3c3:bbe6:95de with SMTP id adf61e73a8af0-3dd8c3d18afmr21360124637.6.1790040316540;
        Mon, 21 Sep 2026 18:25:16 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e613014aasm781214eec.22.2026.09.21.18.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 18:25:16 -0700 (PDT)
Message-ID: <e142b46e-4cfd-4531-8611-717612e329af@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 18:25:14 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: pull-request: ath-current-20260921
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDAxNyBTYWx0ZWRfX5IW8TfJN5+qE
 ftsoAGc57a/0FsokKa/BU9XHpC4OUstQKxT+fOjljf/LT9Mj5PYsts/3zqpw7COq1JGfSP2fH1f
 fSLvAFz18wHlsSwofacBHHmSyLXVwMnvQBYRlms06unMnKJ6s4sE7QrwLgwv71/dKGpCfz2XD+b
 ah4O/StkJTUBuPh3BzxgBuxz0U5lKK6brKVibTfMOrk3zBwxzGfwwkq3SqdV8n703eFgw/R5Yh8
 hqnREQz06PH3+3PlTz4kzYpNTR5Qw31ramYIdJD5r/x7i7rZB5JbyYih0C4S2+a9YqhnulXKcxD
 cy8Kl6HNEa/30MThZIe7Ecaq1OCv/LUeAeMOpMMOoFslWbW3ughtH/TRMLasayKthRRY0Rpu1pb
 XCgSLwFoWyNUBY6PVr053iMDdDqr01eZZvXfqJrWrPT5jKcL2uT4lb6O8OgCFIWmzOopncgSi3F
 9E8c0ZKAw4/ufiPWBxQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDAxNyBTYWx0ZWRfX6hAFyzEpDb4L
 lCIlkP3n5LlmuLLi9qoKRBoBaOahXoayTJ3jhkeEZpIsES65iLhC4wS+wIjA7odevZjApm9wfxl
 qiZ9KVau8de6z+BCnPMRo3fiNEroab4=
X-Proofpoint-ORIG-GUID: XJdwU8dYv5ozM69d2O3sXAfycYLRBttO
X-Proofpoint-GUID: XJdwU8dYv5ozM69d2O3sXAfycYLRBttO
X-Authority-Analysis: v=2.4 cv=W7etxhWk c=1 sm=1 tr=0 ts=6ab1d8fe cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=915--R92nBw2hSefkU4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609220017

The following changes since commit fefaac1176bf3cf002a8dc83339d6ed6a369941a:

  Merge tag 'wireless-2026-09-16' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2026-09-16 15:54:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20260921

for you to fetch changes up to aeaca27c1db3106967ffbb2b517d98c835f6d500:

  wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE (2026-09-21 10:58:00 -0700)

----------------------------------------------------------------
ath.git update for v7.3-rc5

In ath9k, harden the firmware interface and correctly handle a flood of
large frames.

In ath11k, fix an accounting error that eventually prevents clients from
connecting.

----------------------------------------------------------------
Georgios Karantzas (1):
      wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE

Nicolas Escande (1):
      wifi: ath11k: reset ar->num_stations on hardware start

Pengpeng Hou (1):
      wifi: ath9k: reject short WMI command responses

Toke Høiland-Jørgensen (1):
      wifi: ath9k: Clean up device initialisation guards

 drivers/net/wireless/ath/ath11k/mac.c         |  1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c      | 19 +++++++++---------
 drivers/net/wireless/ath/ath9k/htc.h          |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  7 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  8 ++------
 drivers/net/wireless/ath/ath9k/wmi.c          | 28 +++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/wmi.h          |  1 +
 7 files changed, 36 insertions(+), 29 deletions(-)
