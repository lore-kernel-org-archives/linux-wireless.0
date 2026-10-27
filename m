Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793127257;
	b=4ece1jSXjQaFMC5I0R3VEyCddZ4WZSxjpVxECP7S8vce2D+eFS3qTGHBPP/o3zt9lJzK
	 kZ8QTImr/8XmvrOnQcUZgEW5la1gj7Y6jt6JiPoGzWhcYg3X0bPYx+KcPaK1LfLE5BwD4
	 MgeLaPlrfTT8zbFZhKZLBOV7T+Egobuya51MvCUxknlw9pa+2cV4IJ4+JwGEV4WtXzTb2
	 W3feBnXomZyaGGZqgO0qLkg6k7PpKdvIZOED5jLEhZ/MuUwo4c8a6fcwEALvSmKuKbtP9
	 l3ZU6Bpwvxg3sqHBymhMnPiB5Sm3BkS+Vs9HaY1G+Ap1W15lHai0JkjxJJmLuZ3aKcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127257;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Evx6U0q+4cfv5pYUIY1J7ygr/HNwHNAc0aXiO1GKu8c=;
	b=d1vP3rwRRFVFy1scT1Uc7b7uTMRj86328wucShPOcEzS4++Y1qf3m4gKGjiCLfNMGE9K
	 4l6luISRR2P7RnhEiQNw2yR75Dpk3aDmQRJuP/pcaya1KZ/PuEEpTI0QeOYyC13FnPDoQ
	 boWzZ0zG+tnhhpfSE4xbv9SogI2qhAtuFKxlEM/qElRVkRPAbFBuEOwOBVWoH7xt9vPqh
	 DjOFIfCaKvYpf7Je60L4VAf+PAaNniHMStkPSpSwKqWHN7q15cNbkJJoYPzeNjNZmXkEA
	 O8PH/ve8V5KVBQrDKumpswakcld9jA1kLhwLsE3DwweQvvVmuC7KpeyMsUr5Qhxkxjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bwU6p+pI;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jTz8KgIF;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14CC606A31F
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F14CC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bwU6p+pI;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jTz8KgIF
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIHEtg2087940
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Evx6U0q+4cfv5pYUIY1J7ygr/HNwHNAc0aXiO1GKu8c=; b=bwU6p+pI+6tlBDo3
	b+2/e7OFO7kzx1qv/M/Wo4d0P8E8FLvkSz4KDvocTCgovAPyxk9/n4Tl4xg4t4/d
	tzM7suQiikgQQ6q7JU9R+zhqe695taqTLfrpEkIYKkkfRAK844pyOAdydaYejxul
	hGjzwnVOARNaNlUcKs8p7GeJl6wldthdaFTJDWqFHnzof88WqfwNLVMgz3EWfuZH
	6EKVVV2Q9AVRxoHxdo+bfmBG16Xw3yJ6clXG8NOBDRWASQSEkCCJHeA0tIArg/ZV
	8ohWHEK3a564/RJl7fPWjbx5UmZzB223zdrcAsl5HWbddXsoUr3POTyBJmqPtAFw
	uTsFsQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjp2tb757-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:15 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3662e7a9299so591333eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793127255; x=1793732055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Evx6U0q+4cfv5pYUIY1J7ygr/HNwHNAc0aXiO1GKu8c=;
        b=jTz8KgIFr1JymcH0AaJ1y14LB1m8UyhTa2QgrtnPQzn/kEJlJl4E1qGv1hUyIb9oF+
         uuwQWMauzNwhHrIKEXFa165PXbBwQugaszOXsNOnnBtffna95VagAHtIkS+8dZccAwTR
         CqKNXp6LMVOQpKBj1X3Bw6KmTPi182HOxu3V4msQTxIiuOc4HIwPXIWbnh6jZMNrgMTG
         EcTmMrE1rdy9Ybngfoykk66JNkxMqqKgyK5brBODMBq7rt4wTnDduWb2HS+21GucgvVC
         kL+Gr5+rYTOyvlABopZjsfgu1ELqtdjSXKyqfxQ1BE2pG7nJnpk9sNMYlBIhww3e0e9L
         7gSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127255; x=1793732055;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Evx6U0q+4cfv5pYUIY1J7ygr/HNwHNAc0aXiO1GKu8c=;
        b=F9GnlfG53Vazesp4mFEg6EbYzgO5M5NWyDHmem162dAJfyTaNRM8CHmQGKI8zI45Mp
         GjNaUYdgnfEgq1kP1TtcIpQaUls36ZS6yY3b2X6hfMMVId4qX6EsoMkS3uTx7lva50ro
         jsK8jDz3gZ5vZcQqDdv9WH/QggRPMDGYQQYcHqq+kweelQeWBVpa27fgEoDYPaUAcJGs
         VSjiQaHsg7/YFuvkoBiTqFctQmiKfUOAOqdh6zmgPjngQkxQC6wP/+6lZ8BuBXt4FVKE
         nvNyxVZNp8Zyha8fvsAL5ImUs70OBvvFasiIjIuxFJZpC+eSvkoD4RGBxN6690NCPLZc
         6bkQ==
X-Gm-Message-State: AFq9FYIQm3I+zMCRXM6w+G0gYQaoxrW91/RVCvzdal24li/Otqd42LZ2
	fnKyqwn7i0BKlEWiXoaxaef3UPFXKo6uF5CfoEMR5NFG5cCyh+shXwFn5nFI7D6vRzchiL/Eb79
	+L6GlVs6SO4Jyd8hPvfDUW/SOFSMFpENa7iC/9PjDTb+DPnlgRGCMLIKJlfeA5rNnTec3QQ==
X-Gm-Gg: AYBFou1mY4vf2Vkk+9jHWy792dV3F17Z35exwSE+tHI6r4XN1qiwzKD9a8mDakUb1i4
	C05iVQPmOgw4xSQxw02IImPDTRP8X7dM2IB5Ldbj26nb51fjxYqTkONJG6mjC0yJhXHlhioKozS
	85xaBMkXX7H4umw53V0VfGse5vwKDg3riZgbNKEh/Xp0ub13UoaaWk/kqKfPeiyCO0lzncToB2a
	5QdVDP2huEyFWhsu1Ma7IJjXQJwqnpJdIOEq+Gag6JfoO2KyGzM/AIsihvGb3qCanPkxos8/lnI
	j6jypA4AH5WkQRtkexNuJGPazX//dqVv/rMi4kT+LUJNKRiw9p0JKs3iGBwFMoFKWgIjg/++yY3
	Hi6UJjObI52WrkZnbVe/nXFfU6oOxZoreMI2FDt485ZdSucjCyT4mag==
X-Received: by 2002:a05:7301:6192:10b0:36a:1489:fdf6 with SMTP id 5a478bee46e88-36a203ac533mr382027eec.11.1793127255078;
        Tue, 27 Oct 2026 11:54:15 -0700 (PDT)
X-Received: by 2002:a05:7301:6192:10b0:36a:1489:fdf6 with SMTP id 5a478bee46e88-36a203ac533mr381980eec.11.1793127254190;
        Tue, 27 Oct 2026 11:54:14 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a14383b02sm8989983eec.14.2026.10.27.11.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:54:13 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        =?utf-8?q?Nerijus_Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Oleksij Rempel <linux@rempel-privat.de>, Kalle Valo <kvalo@kernel.org>,
        stable@vger.kernel.org
In-Reply-To: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
Subject: Re: [PATCH ath-next v4 0/8] wifi: ath9k: fix register access and
 spectral scan filter handling on ath9k_htc
Message-Id: <179312725315.435197.11317113706917612681.b4-ty@b4>
Date: Tue, 27 Oct 2026 11:54:13 -0700
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
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16.0
X-Authority-Analysis: v=2.4 cv=AJjzCM5L c=1 sm=1 tr=0 ts=6ae0f357 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=zW7M3SbB6j3E8vA8Zf4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: 7N6fWCdH3243XfPgo6DYkcjyyMPgBThA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfXz5/4rr5E+fUc
 Iq4Sw9CFWzHc6Gpej8Y0sQG7e/atle9zThmYnqatejQfFjzvZvBbDWg1KRwesm7KwqRf3H/t8Y7
 MWEIysA1G9ztJDGffPIIoZ7U+NYDDQ0=
X-Proofpoint-ORIG-GUID: 7N6fWCdH3243XfPgo6DYkcjyyMPgBThA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfX7OfHbqNCTyfH
 F4qKqodPETk8iHsQw/XLfnp81EUaSb3YIJ1c9e72oKA2N43c2zpdcsAkN4+sVfATqipIG4wZPBb
 0O68YZT60+xIXakk6Wn+Dev2AoL/fYVUAcfmJe1SB+rI10pLMGEZUT9xqg/U7PtMT/tWbIqtzyB
 kN5fiX66QokKRQFFGk3dZ6xQf64ixQKN6m3h+2ub7n8zqU7evKuvclLckyC+vipTEG/XRqt7mAK
 XcWr+3Xq7SAc/Kv101vrx6iVw6wQ+wny+AiuKmn25ln9xUQ971DzK8s3S6Yi/rQ2QdYGwpLLFru
 Io1lvdLPEJlqBzzBgB0yH7nYQ0/HtN2LhKVhxUZPxOx+iSdeZe035JZyhyO1L9nmQufAaqkXDJi
 3ce8fWVNcbj2orBPT8T+RNrodCH7C/pw2AZsVgzPoCsF7Yby64QrMxRTOlR8WQbR3t4trHR8g04
 Xl+5hdJeNGXgNx6+6VQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270075


On Wed, 16 Sep 2026 20:34:21 +0300, Nerijus Bendžiūnas wrote:
> Eight fixes for the AR9271 USB driver, resent as one series in
> dependency order as requested.
> 
> Patch 1 gives the multi-register read a return value and checks it.
> 
> Patches 2 and 3 belong together: 2 fixes the byte count of a full
> read-modify-write flush, which has truncated the AR9271 PA calibration
> since the buffer was added, and caps the buffer at 14 entries because
> the corrected 15-entry command fills whole USB packets and is never
> delivered; 3 refuses any such command.
> 
> [...]

Applied, thanks!

[1/8] wifi: ath9k: return an error from a failed multi-register read
      commit: b93cf212206154dc4ef73ef2ec2da7cf9c40cb50
[2/8] wifi: ath9k_htc: fix the byte count of a full RMW buffer flush
      commit: 498e911ada9c9cf47a3a955fc1b346209b25e028
[3/8] wifi: ath9k_htc: refuse a command that fills whole USB packets
      commit: 5ee78539988f3f3910558640cad6f0e049cfe24a
[4/8] wifi: ath9k: stop a failed register read from opening the RX filter
      commit: 9477a8b3e552648ffb1b5716697dc5852548f081
[5/8] wifi: ath9k: clear the PHY error filter when a spectral scan is disabled
      commit: 4c4a19d3a181bb25e21cc4bd1b6c707aa5aeba86
[6/8] wifi: ath9k: count spectral samples in the driver's own RX stats
      commit: 107b9b50077cab2ce3070914ff34abf68d2d7564
[7/8] wifi: ath9k_htc: pass CRC-tagged spectral samples to the FFT parser
      commit: 519850bff38c9dd41be0d42afc03c24228d111ba
[8/8] wifi: ath9k_htc: derive the PHY error filter bits from software state
      commit: 7b14c8f4a9615579b09cbcdc4515b65ae6124753

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

