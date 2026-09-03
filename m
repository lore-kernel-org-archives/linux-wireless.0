Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F943D9DA1
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 19:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462198; cv=none; b=SGQNFJIR4ckBSlnZ1JmudVCXySL9Haw/euac2evZziVuDiUYb0N/CxetEK/cc6uhTkjUpurgfPi0yDCgJvia7CgS7RUMrI+Q5bGSmDjCO9zWK1BF31RbaICyMx2zWEdXBM5r22gRET//TsosNl5et9cx92Z3U1P4A8RU/uJ71is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462198; c=relaxed/simple;
	bh=Av+Ccu+qywSP4Z4y6HFs4D81a3D7FkQfr9mBxELay8Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GiteCTjCEdKwO5HQws7ToldsEnukNh8PCQeJnzkPHKM2ASIYIoCEJY6S2PHfawj48BukEjHJulxA2HyOot+XRHVuLR0w45lS+K121hHUPZAqDAe0i3jjk9qF5dEno2s4TfhHJbh8EpohF6iHpNsiMy5cx4Szv+uLQ02744M7y28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IZo/CuYr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AppJtzah; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IZo/CuYr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AppJtzah"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683IHgGe716011
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 19:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4xGweBqCCA5QiHSvA0qStGRFMzMmgoroskX+XtaYuco=; b=IZo/CuYrTpW5faji
	hWievtY3uFaYyripF76Bn2w8Y5mLeCN/vgWaf/YxXSWVIuENrDCJsqGeXlctTkAN
	JeQnaoQ/nrqogbgoUZ+IyZnAy3opIXHotBY02+BmX6Qn0m9jZt5+IfBIjPNm5Mlh
	82OMr7v+NLN8mBZoNI2frUBmaH5YBtom/1acLgXH20ajZCFAih7IYtUtfe4iTRCr
	BdVR5hay93DxsM8Gf35jxUTNcPSsMsh9UrzXHH+zgrWZ8K01iRnCk51uDuo5G8Dy
	wJK91kKxwS4P4RY9rCAjt/2WwhSfHcm7QxpuhOXFMKmwEGhvizTkn7KWD1IWWZBy
	7PYd5A==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gf51m2y5d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:02:53 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c89704da8c7so308121a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 12:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788462173; x=1789066973; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4xGweBqCCA5QiHSvA0qStGRFMzMmgoroskX+XtaYuco=;
        b=AppJtzah7KFX7J5VqUr9tkmWh+FahdHLf4PUz4I6od9nYE0TNEQa4W0tl8qsFIBnZP
         ed+UCrrHgvP/xiziTtD97KgMP9mqozA4ALNiwrIfQ9s3EKpHKbZVkNHOp+qTvXu3c0ZU
         ABOeaOHHupz3nT1xaQwv2QHn50bTICW/KxIx3TUTq6c8nJMlnjWRoH9CEhZVH4Cxz/tw
         MHfBvFnh0644mv/XLM4BF1xELCTIIgxvdKtH9CQiXBa5+noyACkW4u+kErmlZri41sxy
         7y8mi9ITECzITixVnmDbPU2dwW+TDVOr05Nx8vWUYtNKioBdx6f1F5lVH9sgXk5voSSB
         SL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462173; x=1789066973;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4xGweBqCCA5QiHSvA0qStGRFMzMmgoroskX+XtaYuco=;
        b=ijVqBTBN3Gsm4z64x/ICh7e6JyTATcFkRDlY+CE58QhDam7cfG5s8cIuyYAtyMbU83
         zIziIpfL1n8VyWzYK986mSDmjSLZnLmjWx8tx2AflFVVTXJSnvc4V1QRnVuBrEOhBFes
         zl/y3/VQio+g20QA6rv6xu+DLUg0VuJjR+WDBLq8hJCyInKS0ZGfso2q+/ucA2IDMs16
         /1oQf7gFSE89+JOq2FGijWQTJfC7YER9dnLGdThEDK9vakL+LFiPDJmPzxuK5tQilvxy
         5JZUsDhtXGljisc7xprR5T5TZUzcQHtX7t+dGKS7HSLsPQu9O17TVauNJJeUtQJR8mF6
         5SsQ==
X-Gm-Message-State: AFuF++mAoDp9WBT18+m5RDZ7Ixlt0qGhyl9JTQ+C6BzSLspXx6I6h6WT
	UCtpxrDzTJ75xWxQ2+NWFwvYYjvn5vKCtWaNpa1z0fafnJo1WEsHnGBBq8iCgp3UJcDjtCxZvSj
	OBoNh1zBIfSiYMCdgNMrABCah/m5rgGOYXBU9c1KHB4dErcfkOMH4d22EqNphyULWv1Fv8JHIA/
	l+NA==
X-Gm-Gg: AYBFou3zcwTuAQf0io57CTCU2JSq1/Ub0tGSO6u6LapBVslQWw4tUTT8gjzlC3jsGKm
	DtDOHzBwvepbP/v3i7xdge/C3HPIh1zVagBxBcV6aGEEuXmpW47gAjG8IXMP4QFf4NByAQFwWf5
	N8c/Ev/AVOIiwX4ON5Lkl/LCUKF23uhQ06oL8k3mzAnHz9nYrsF3rbwwmxldl5ojwe8jsKfQcgO
	xvZkfPHoa/gWzwZWm+DtV3FvrU2z5A32wosKfNC4KMxGGzFjlV8imAl4QoWLbTqno9KcVR0yz+y
	kS3cI2MbPc/Mw5+I79iNVp36kw4ngTGUWHnCx5BDA7N4XKP+EXFV3awEHXroudx1770ztQCUfXj
	fuWvZIBHZ+syM7bHLL1XfPI4rHcryyITf3Jl5hBDtHXA50iRpWyWbUNY=
X-Received: by 2002:a17:90b:4ad1:b0:396:635a:9b10 with SMTP id 98e67ed59e1d1-39b2616ef8amr794433a91.11.1788462173221;
        Thu, 03 Sep 2026 12:02:53 -0700 (PDT)
X-Received: by 2002:a17:90b:4ad1:b0:396:635a:9b10 with SMTP id 98e67ed59e1d1-39b2616ef8amr794309a91.11.1788462172645;
        Thu, 03 Sep 2026 12:02:52 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm1230164c88.11.2026.09.03.12.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:02:51 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Andrew LaMarche <andrewjlamarche@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
In-Reply-To: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
Subject: Re: [PATCH v2 1/2] wifi: ath12k: support calibration-variant from
 device tree
Message-Id: <178846217113.824911.11446976488422487073.b4-ty@oss.qualcomm.com>
Date: Thu, 03 Sep 2026 12:02:51 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: s_V-CBNgesNLi4J_dpwBaJREBm3lHYEk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfXyDaTBXhcH8SV
 dzuaMBYwr9rSqH+Fdl+lGi+G1ygsAT+Gn4Y5J/TYJ5alFr9+HLu9dd5/OD4lk7Opd2D4dQ/QUXP
 s6JIdCKNeG16eytJFWSrL9Bfz98RblXeJ3j5u7oBQ/9DoIlLpSbHutz7Egt+7l/GQq6J/3dktur
 K5P0SP/2hinR1uvDcP5FKUePNcBfTdHkDZgtSnAVkB7+h9iANKDIpxZW5S1U82aRKgCZLw6gUvA
 jnmIq7/Pg5Gb03W/Xsti/AVMivc8EZtIebfyrpHuvO1I2yop1j9P8XBA9VMJ3fW4L+Ohujxe/sh
 R0pnFNvWogp6LLlYegGLUjyky/xeMlLyS7UHmRSxLu8aNnw1B0yeiWXxo0P4THBv+PHsGV4n/ZO
 Xovs0CfJSOfkTsv669Gwi+hFsGaLiF1mVnj6yXmfEZqb6jNiXtzwol2AQNSz4zF17p97YWQaLOq
 HqGSSCvFymPgxDV2YvQ==
X-Authority-Analysis: v=2.4 cv=X8Ji7mTe c=1 sm=1 tr=0 ts=6a99c45d cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=erCTOyO-HGHO-QmL5V4A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX691xt/TCnQge
 vf8Sy/N09PmKYmj6DCRh7PvlU+bu/DXEhIK20IIJ5592uIXC+Dq+qYY+UVtiCZbp4PTGKL+VyEy
 ys8RFdaGrkipCkfvOahHti/G4jL9mzk=
X-Proofpoint-ORIG-GUID: s_V-CBNgesNLi4J_dpwBaJREBm3lHYEk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030166


On Tue, 30 Jun 2026 13:30:00 +0000, Andrew LaMarche wrote:
> ath10k and ath11k support reading calibration variants from the device
> tree to locate the correct Board Description File (BDF). The ath12k-wsi
> binding already describes using qcom,calibration-variant but it is not
> implemented in the driver.
> 
> Many ath12k designs expose all the radios under a single phy, each of
> which typically require a separate BDF. Without this, the radios may not
> come up or will not be calibrated correctly.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath12k: support calibration-variant from device tree
      commit: 06cca100ad083609ca9cc2d1f692546369144189
[2/2] dt-bindings: wireless: ath12k: drop qcom,ath12k-calibration-variant
      commit: e6c2d73f27b3948cabec1017c9443fba24f1dcc1

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

