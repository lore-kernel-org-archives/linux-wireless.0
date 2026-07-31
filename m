Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA2431A33
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508913; cv=none; b=AIVZKqMN9Ol11EUcKgRG4fZFXbN+Z+xf2YxnReZvoA/JwY3+zHNWw998zR5SEg7/x83ZltOfMMoozjCrEheFJtpJHDK+3dFAz9VLznn7mmwr+Vmb9whSTZxaDQ0/9TF6r+vimqilH3bNXrFyzrXYgT8A+w/1GRN+YXAH3BjP+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508913; c=relaxed/simple;
	bh=auqB5D5KRMWLfsnNJkEmivKz9/AtxkQIYvku4ToAYR0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aTeUVp8VgFJEKeb7RbGAqA+HAF3C/a6jVb31nuqToB1X/Xk5OsDp/KD+hE6Jkrvtqyk1nugHArjwyxVvY4sY9oeriAeaAftyL3j+rITJKjH4Uv3z3fOpXVVLkAe91ZYkPcc/QrULs63iHenNv5eG7ZMcpmk5n70+XOU/tpTtPHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kGdfgSW8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VdwyFJol; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kGdfgSW8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VdwyFJol"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VCBsDm3776885
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2DL1707qpbWXy6RtnqhQgUS3iYKbXZtK7tzN7S3GS+A=; b=kGdfgSW8tX7i5pr6
	fL1vaeI2wbCm3hDAG0vpS9fDFZnCS01/55xszfH2R4cvBz79yvwZWG2gwR4eGtiP
	WwF1ZTfNfZRI9iNzUPh5/RQLktWNKj+w7kRNIvXgvuZbb/dRvl7ISAKRiPsGYz9P
	NXYqRHq5ZBIPJ7HTS8j1Wj0F+iibrd/oaCEaZuYNAIl8+PKalI4wiXboZbjmIwBO
	EdFtiPgfRKIRyx4NEmAV8y9Tzj4vYJi48NzUJ16O4BPjYIGSAI/sFISnI2xHR8tm
	wiCQNgmuhZ/xaIa8wiT10UmMQGCbB12XP6niVkUId5Pe4CXehG0pWFRxefqgTVeu
	M94qcw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frugh0ma3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:50 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so1197835a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785508910; x=1786113710; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2DL1707qpbWXy6RtnqhQgUS3iYKbXZtK7tzN7S3GS+A=;
        b=VdwyFJolmsPlM6FVasd+T5+uHmGjZWMxbWSGKGIpKAypURqDMiVCWA3PYf0+q3EAAw
         5DhprQmKGN8kIPvcUL0Vj/knDNPp6xrHzW5fjog2GitvDurA8tvRjCDO9f0L+RDlvMss
         OUnP/HVzucd5BroEnvQhRCsSGXO5KfJIcjcyCM3MSeyiSsqqZ5ZxP4lutc/B9nPfUa2f
         +T/jMbrEtxYmlaSQFmKsHH6zNlFAbi6QJjwhLUwrkWpPeGTv8u2GwANcIx8vlzIe7y4q
         VCVq9zWLiPEVSKMFzk37wIqWblkVizoQbr7I9KUGL7iM6VBvo5BfkU7rN7ljJXVS2Qfu
         64Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508910; x=1786113710;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2DL1707qpbWXy6RtnqhQgUS3iYKbXZtK7tzN7S3GS+A=;
        b=n7OzwERJGqKTiUSUV6CS5BKJvtpUeOAz59+WceMfM5JCeNMau5nBJWjiv4AMjrMXCG
         /xYxbCn6DevNzjz3Zr4Q2oQ4I3guLtFRa8VEzYOhNTkwJqKwxszI3vGjMHYoh7LHnumE
         RYqYbgCVJnvUrSHjQIjrsrHAO7sxNr7toKUkbjpnFTLYZxnmLEUkZpTiOj2Vc23iXJ4c
         K1uUevmefWrfsWGXjcD2jS9xSQMRDG+BJsL5ppfQz6qG0ex0HtkT1Fzo5rC8uSoLo0Ku
         U8iJdFHLGzU9rO3qwfyhdYtnoxo/bKEecE3WX00aVlrkGudvjwbdeECyHtsVPpzxvkbL
         r3qA==
X-Gm-Message-State: AOJu0YwQcLTpRHp9UgkOGe+HpMKGBOR15ZqnAW7lpZgV9kBy7rPkTxBJ
	PiUZgHoUsmVjBuITU2Hn6XRpDSjRzfTcdL6bIxWH9BjTP36zOYXK5XOg9bUiqcVVkINLipzCC7D
	3S2ZUICN5gny1YjL9rHVYVV2sBJ8wZw7BzUCNMcoB/vM0XKvTXcK3K5ZpAAJwow93cO1UWA==
X-Gm-Gg: AR+sD10WzJCf5eiGnhl9HuNS2S8Y+tb/iej8RCTfD+WTFDHs+7bn+nwawCposhZALs+
	3oKpecHNkI51GVgQ0HrlSCyxYiLhf8QZdRKKkg9TduZLBmDTokpgNX6g9o92eK3JJbnpxBZdNNd
	LsB9g6rLnpBT87/rxh/XLRD6hlgjNXwL6tFXHYWJETXbF5YvXXP8fqZPK39NIj5Vf0eK2j3bx/2
	Zggv6FGwOIlEP5OANXXq0b2Y4MdHKombUdU63ZyfdRi4v91v6B7L5d0wZobNmoMZ4OMomYCyS8Q
	+w+ystSYibNNnHQRVLLF4ePMwE2WOATVnC/gLf4HQnWUA35Vw7Igc8KsMd3OTFXe2ROIPOu5e0S
	U1Je5LXfCjgqGq8FHw2RztKMchz+ba0f7t2kLBB2fTa5vOJ+OfmTqQlE=
X-Received: by 2002:a17:90b:558b:b0:38e:2a4:cffc with SMTP id 98e67ed59e1d1-38fbc4c4dbdmr176328a91.25.1785508909721;
        Fri, 31 Jul 2026 07:41:49 -0700 (PDT)
X-Received: by 2002:a17:90b:558b:b0:38e:2a4:cffc with SMTP id 98e67ed59e1d1-38fbc4c4dbdmr176288a91.25.1785508909088;
        Fri, 31 Jul 2026 07:41:49 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e04491dsm9622360eec.16.2026.07.31.07.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 07:41:46 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: linux-wireless@vger.kernel.org, Doruk Tan Ozturk <doruk@0sec.ai>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260713213251.21161-1-doruk@0sec.ai>
References: <20260713213251.21161-1-doruk@0sec.ai>
Subject: Re: [PATCH] wifi: ath6kl: clamp assoc request/response lengths
 before subtracting IE offsets
Message-Id: <178550890659.2242004.10745983270353218033.b4-ty@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 07:41:46 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDExMiBTYWx0ZWRfX0JYjOTB0ag5W
 XgTZw1zRrB/rOBZHM1cK0bdKumilFFt6md3/noDt54+fc8sy7700Od8W1NWY//MKhjiJRmIty1q
 ITKJ5/Gl39VE4G1cQeG1/nQ8jXApyuZhHTJG+Qkyo7PEilgRdSnVgbuvAhP9qSZUKggTXyOWNL0
 XlJKEIV8/f8vJZDhndLjamUQPiPDAem8p8xcP/7DlXwLZ1Q9/ssfHXWdcPpdlmag8iySFyLCVYw
 HAov8l3Aq8ype8cco1A7QTju9NS8bXIev2sXg3PbgQXGX2yPmzWv0LxtO+Dv0CgZzSPCLGlwJZM
 j7X3guhzVNwm08IwxCEJEmnDuu1DO7ZvSdJhcO2hk4glA/1YI7+aixp+lIRWuLUiDKqpYlsuUI8
 /T84WY0hOGajszBL8StjciDXLsKpOg0v2kWpqhaMTHiKEFnh1lMceXfdLQ3lBxzqPYf331/XeHs
 e/Ztc+i3zg2IUotFA7g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDExMiBTYWx0ZWRfX2qi0otVxqME/
 5pzKQk5urdQcS3Du4Z6BE7CuIq5Z2CiDMspbdiR8DnpxSUt5BAicsqKcw1oao1D935q4bLqGaUQ
 to+xBWUnF2j32lFuvBOclXfCssXh+Os=
X-Authority-Analysis: v=2.4 cv=U+iiy+ru c=1 sm=1 tr=0 ts=6a6cb42e cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=Tiqys63qfOma7-5uHz0A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: b2Q09XFyq0jgAGstbpPeyOAIbirNnYt3
X-Proofpoint-GUID: b2Q09XFyq0jgAGstbpPeyOAIbirNnYt3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310112


On Mon, 13 Jul 2026 23:32:51 +0200, Doruk Tan Ozturk wrote:
> ath6kl_cfg80211_connect_event() subtracts fixed IE offsets from
> assoc_req_len (-= 4) and assoc_resp_len (-= 6), both u8, with no lower
> bound. The aggregate check recently added to ath6kl_wmi_connect_event_rx()
> bounds the declared lengths from above (their sum must fit the received
> event), but an assoc request/response shorter than its fixed offset still
> underflows here: the u8 wraps to ~250, and cfg80211_connect_result() /
> cfg80211_roamed() then treat that wrapped value as the IE length and copy
> that many bytes out of the small assoc_info buffer to user space via
> nl80211, disclosing adjacent slab memory.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets
      commit: 3bbd05723d15dd06f0560bcd94fbf9a91b5f5613

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

