Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C88386564
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300770; cv=none; b=DkeY2hcPeCmuCNKS4FKaoS7iD0MPeVCnGcoE6bncwiIaJUZhlBLkukvLvCs4T5ndkJP0wNX1gja8H5OELtQPvUgyWDgepoFKSKYX5Vx0BLm8fk7JauUtDt7QZX1unx/Bgp9X9sYvaggaDUu9pIOzE5K2R5oiNBuQp1BuM5G8Sdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300770; c=relaxed/simple;
	bh=fztB0Bec4zbXqHadlwKEKuJLnLdNNfJK9HHMN9PoFi4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D3aOdCNQ5pJqdH2+VwYfyfkUAweBa/qHIMI30c3a0TtEblUSs/wA5aLdlH/YOwYKO51okHRNO50Y9Ghijv06QT5eduGmhWfjIsV5JP14wfJaWSur/TYwilCG6djnTpSnEkS9u2nHjHp1gZlyiXEApr7yTJrqiqQvb43i2YruxFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kis/fnUU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cOTO8Yq4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kis/fnUU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cOTO8Yq4"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7fG03123225
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7AojuRYk6z30fX39EjxdpLOAOLbMBF9jrafkQwbpO4M=; b=kis/fnUUcMagspDg
	sP6BubVQk8G+gvPHCqoAj/D7TlhpGedyYdNm+6z5AT28h4z02ASl5WYD+dVHeV8o
	6CxaHPkwmqbLSs1CM3wP8nkZMQkRlHbicZGa702e0jVK/BqVWYgBR1MktmA55fmU
	/+L+6/QwhxDeG/BCrLxNDfu0cEJn54PUf2+7pm/ExqtSdJAcaZz0P/VuvLlQ/cMI
	r40qnPQiqqdsIMwWRhMqOTU1j79zGUOStoHLNJPzVF6t1/ocK6mW5e9fY5TEaJ18
	gLLPlsptRFs4kpYF/PPpd5TCJYCU5Nwjb/Ap9NB2G9COevysLYiEuYsTX6DJ2BvT
	WFZ+8A==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff3u6mahd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:08 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-384419c6c74so10114027a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300767; x=1784905567; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7AojuRYk6z30fX39EjxdpLOAOLbMBF9jrafkQwbpO4M=;
        b=cOTO8Yq4nRIyFv8D3cNYU1K1oDY3WrmHd/fp52+LDAyI1qvQN7OTz+UU4CnlaJi9Fl
         0hGM+nu+NiaMfuC6ddW64b0YZGr0tOWYrvA8qPVaCdSRePvWMA4teqCyBywoCXFthxkY
         TCptgoToqYoE7knWGfOGQN/S/Z+jCSe8dytBXPKqFmFTYUqs8dphsYm2QBNMdV4Q5Phd
         FsAX8UGPpiBKVluyty08HwwwFNlxUw20V0tp6RMGrdzF9gWEkZWV8IRc5fW1RqKaANhu
         fxrGiJy9iLRoIy/Q3ewVOujk8jBM5A41ZDJgZJhNJB8QLPejpob9l2Y+NWC2mhyhnKva
         yZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300767; x=1784905567;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7AojuRYk6z30fX39EjxdpLOAOLbMBF9jrafkQwbpO4M=;
        b=DMgOIicbErE7g11ZV8uBhuwvtKXLfQXhVJJWkkO8n/WPyOYT1HVAxgZ75VhZk2KhpH
         eorou02NK2xX5KBroGTTaPzVeb6i2VcxJHt5IPEyHUZ/hTHp474W/iGlqWDLZyFoug9p
         TkiCTnTaECVmZXFIu7A3cMOWlNrbAFgJYq9w0NE9pPkP8GSEJkLIlv0hVIUWGWStFIn/
         +O7q4MmlJF5N+DXYck6pRg+pLGLAbZunfZIhXIzLYIMYdsOHAabxIu4VjKXsiZiq85gj
         Fsp1qTbccxXq16AvPXIc07gX74UIkXMQa/clsxWlXjotJbG2U3QAx/7ew5bz3oGpf2Lw
         ys5w==
X-Gm-Message-State: AOJu0YwuHfKIWlOpM0+komF4xGE1JGj477dDGTgRlQkLKpP9ED5BGEsa
	Jc+mR+oGHYjoXZRkJfEXARbgIYtpxfkuACug1CUbfItQb315fpNX3IcZE7XwehoEUCh/LetVltb
	AkeykiWBeugSa8kSoZTkaOQg+AJ+hu6JvpdrYgoWvVIXdgw5Pc4EBBebRYRurhtCAUub3I8lH1O
	tdkg==
X-Gm-Gg: AfdE7cm5lJ9HUh7dVztvRA0ejcjejSN7AWgG/my4m97VQgNWUja5XvpV1KSGo6jPuco
	Z4ON24zrffLqjKhjUHAIxMwxEWmtyEzDt1BgB1ABkvgASi7BSI08KkCnzk6R4LdqjH1tkRgPGga
	BuwhXjN6Ywg/ZmlnbyTgfq+CeFE90wvCvEzQpTCfSLKScfpOtbdFfH34+vVukeXEd78ZSW1AbUZ
	/3/CSfnIXOPQdlvAMypeDs5JWfQaRziiiKoJodrYh9qtB+ceD0JpXP4GC26vGkW01npoy3TDWV3
	UTYxOvBnOqbEjOt4dy32FWnM+Z97kAxcRfOaf3lzOvIp4+n2JEHJFN/3ZtNP92a63b/GK3QvMm6
	jJ9QGAXWvDeohxKV9QoYJkafEkVQufKzBTAeH3N63PDNIZyd5vBTjtjY=
X-Received: by 2002:a17:90b:3f85:b0:38e:3fdc:62e5 with SMTP id 98e67ed59e1d1-38e4b479ecfmr3042967a91.19.1784300767326;
        Fri, 17 Jul 2026 08:06:07 -0700 (PDT)
X-Received: by 2002:a17:90b:3f85:b0:38e:3fdc:62e5 with SMTP id 98e67ed59e1d1-38e4b479ecfmr3042899a91.19.1784300766645;
        Fri, 17 Jul 2026 08:06:06 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:05 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
In-Reply-To: <20260713-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-v1-0-4ffc4a472992@oss.qualcomm.com>
References: <20260713-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-v1-0-4ffc4a472992@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/2] wifi: ath: Correctly copy the hint BSSID
 in WMI scan request
Message-Id: <178430076545.128359.8126500058186814616.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfXy0K4SB9GOB+B
 xUfZUQj6DHMsQazUg4wTnU6O3JKiLnCEzxEwn6AXdk20Dxp7u8DiRE/yog3+F2Y+v0LKSAHGmt/
 BTvjBvXqvWF+1peb5R9zCRuaacglNvb2KKmDvgXZEI4Bvmqw8gv4NdPBLxN1gXll/ICLtQvHn1y
 bu6iWSBRhWaPJqh12EFKXxh7RY/uCNBv0N+7LPLpg0hxstZsWVVGb+zmpAazFy6iy7XLg25UVgf
 q+g0wrEPK/M+9tBmtck2vkCRwOQ+PdtUrzni9ZKI0rKZ0eX2WtLTMytqf2MBs6E42l6c6OLbqtl
 JSFNY3fC4FbsuXKGg5XKrLVYBXVqEwyQs8OVK7ZDQPgHZoROQ2BOkOKcBUXsleIR2/QtZjQLGRl
 IoSVurc1dfyL30lLCSXMOLDgx/oCWkKwY9SJha2/gqLNBhzaAHx3ztM3tLrsJoEFvPlN6Y9FUWv
 L7KmwzZTgiEpzXkd/zw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX3gAo2LiLvDpM
 /Gjb/RNIKjUSCLuaVbzVcpuauJg1qnWzTZ+Sd0B1MTgW1a6ta/KfoNbL85D6FcsZqYa8x1XOVMf
 rHsRpb/0rvZZ1MZ2e+EOKfNkzMz9t2I=
X-Authority-Analysis: v=2.4 cv=DYMnbPtW c=1 sm=1 tr=0 ts=6a5a44e0 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IvR6sJYjICgyGHFFWMEA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: 65QwwoCczw2XhnLUVb1dMBiE0dhkkPV6
X-Proofpoint-ORIG-GUID: 65QwwoCczw2XhnLUVb1dMBiE0dhkkPV6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Mon, 13 Jul 2026 09:15:48 -0700, Jeff Johnson wrote:
> Issue was reported in ath12k, but exists in ath11k as well.
> 

Applied, thanks!

[1/2] wifi: ath12k: Correctly copy the hint BSSID in WMI scan request
      commit: b127f79a49335679d117406257cedab4fc20596a
[2/2] wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
      commit: 0db9d58c8757d0be5ed546109e37bcb10f6c1fb6

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

