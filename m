Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F825293E3
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813238; cv=none; b=nFBwDW3cjV0QHeW/wDaKo1OvRMphG5puUZ7pycX01pb0svTEUp3vn3O70RqFYiSSr0ob4YuFTzFmzAwaAZpFAK2incPwVokDidYkh77ddTeG/CUYizN+kHTNvf0I4Lq6x+KGThGsqwjvFdhC/Nxk3TwZfL7it/SZliV6i5XLDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813238; c=relaxed/simple;
	bh=slxYMd9pIzQAMKVqHjrMfdvbnPLm31GqOFhQsu0FO7Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TF3WNZA2ZprCCS6coffyF/kii3yqv1gY1BRt7CRpI4uxvTLsryDicAG7ovidg1wNHiDUl8tPtA2V77v5LpOKZx5AUyUcXiYGru57bLrFlpqcpW3fflJ8gtNvkVsaGWTBr6xZm0mU4uVSYDvcirvUbehkifw/mVeZJj3GNOEKxqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CBxFsh19; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AU0b1aXX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CBxFsh19";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AU0b1aXX"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H8BPm4016179
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gYoBNxGLCxDZv4uAHMCNobIrbYmFXndZnMWIP9T37jE=; b=CBxFsh19AT4k+2gG
	A2A4/GcF7oPQGVdC7W3lsh/9k2PO2iwHkZUnds4FiZOnWGQ7gLqs3JwqAE5fJHWX
	BtxM3c6awmRbVNrnUXu8ieXFRQqncQDZ9aPL1DqJByNl0ve+c2Tvmn6A4Bz0vrXk
	CYPpsfQpDAN7LbCqLTUL6U7l+a28lZouMrXvTfrHo3pOnwp/YajuI2EjtjgYRgU5
	dQ3p1ACMP0sRam1P0yOrgY7pEuVRDPyPgWlWvD2CMbrdsZZVljVMsxB8h7dpv5vt
	MXV83PTCsxtulGTTCDi9T0vQZPFz9/2P1jEscPe4NVyuOBI2xH/gc/MdGJYm6kNi
	HaXkQQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghsw22fv4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:56 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so3164163a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813236; x=1789418036; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gYoBNxGLCxDZv4uAHMCNobIrbYmFXndZnMWIP9T37jE=;
        b=AU0b1aXXKf+e/V8FXF9/Ci2j7SCEmlBKdYtvsTWsgr3NrgATgHcJ+g/xDd7giMWILc
         M11gzawDUaIAu424MXQQLQzCsho5SBEtyMPvxboOxRxoQk3kJQRUxlRzXIB6qvW3V+em
         YbHW+bayY9Gh56/GXzkun+qThMBRfXERMg8xWoAnopLJX2XsVATaOEMNfhigycN1JGYc
         s/g5r+sAZyeRYkFU1jDNqlVFO5rq3T3IbgiLqWMrVqIm63POqlxjnf8+ds1RJogZRPTB
         /d7W8Mm7+mx5QuvySLIFT9UXqGecNBCY3p4awXSF46fGt50hLfEF//niwC551z/bfRgN
         pCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813236; x=1789418036;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gYoBNxGLCxDZv4uAHMCNobIrbYmFXndZnMWIP9T37jE=;
        b=AjZmE4BLgkNurRh2CI5SlXJoazLv2jEvWdFtaBnzz1cdDWAlt4zCTbHJrBsDRCOyd9
         tDvxWUHYu1MvkT7N/z379jiRXkHrPlvxEWJwwxVIhFKHIn1lwT5a9DzCc0+O4NGUxpjF
         NI/ffrQc91cXQgvdDLpUoiJep+GsfDR5dFOeVQhtoyOim+ORDaLBR3CeQX8iqbaF6tQc
         jLJwsjr+yh3oKH3vWFvUmxJMz/1AImjOTfeiS7c6gXpH64lJ7aI+pFWpHOn8m10fRavK
         5y+nvCwYs9daCVtTV8ubz4Cr97SBAorJGqA3LFpgw9XFm9OjPr4/d+0u0rhm3aD0jBsJ
         8zSQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2dugI4xSgx/t2e4WIFFIaot+6rFCvl66T2uhDjsB8G9t0q2qe3Y1nZAVoUowlZ+/DqlQRyySowGKc40d6WA==@vger.kernel.org
X-Gm-Message-State: AFuF++nMQNPdC3FZLeNt3/QFAHOp+Tc1m+HxHvNUFDp0V+Z81hHdg82i
	zu6DMaCkJZ47oVNV7qh6on2dWMBwXLVe58/2VNUgO3OELajCZmnhprOMpIFDh5EG2aizcE7eG/h
	q7WofQpkadjjLNuwZFAxFf3PuJ51rhgy8Iq4w3d7ECc3XFuzdGnqomZ3DZTzSts3a1x90
X-Gm-Gg: AYBFou0lU5DDTe3oDXuMC/UwHL9mq3BBYgjUtUTgJo7FyliX3AV16F5pwkox+EWdOs/
	ILBxkcWmE+wunlv5uPl3Nr8OwIZrIXDGDK3gg4H8U6BLxFeIml9FgUdpceYUge+Hzit3rc+2WO3
	uNJe/slEbo8baoHOX3RN8F9vBUY3M3HE7F9aC0vDJcHeVdtTeUbEbCjnWbUvnqrLOroPZ6LZeCg
	xXxLfOI+w+1ww+zF1iIcS6CyvRHr4NWI+hICZojM6GhlqH44mnhpvZsi9zKG57iO1UChETfmzLD
	SPMj5VsY9aB3gwwrhdDK3CdnoGijhzqcTRv9Jq9Z478asHTh4WNPxsA1QVm+mhP438tOBsu9grF
	9p1wovdlt4ft6+F3MPUoZDJu0JaRLRH/dSiP4qRe4I0ytMs+3nLTJoIgMnd5+hIyScffT4rUHzf
	cpAm3nG0E3kHVj27xkStT6Zw==
X-Received: by 2002:a05:6a20:4321:b0:3d3:b02a:61a5 with SMTP id adf61e73a8af0-3da3a217599mr37266726637.28.1788813235693;
        Mon, 07 Sep 2026 13:33:55 -0700 (PDT)
X-Received: by 2002:a05:6a20:4321:b0:3d3:b02a:61a5 with SMTP id adf61e73a8af0-3da3a217599mr37266691637.28.1788813235300;
        Mon, 07 Sep 2026 13:33:55 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:54 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:20 +0530
Subject: [PATCH wireless-next 11/18] wifi: mac80211: Enable skb extensions
 along with mac80211
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-11-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: YKrKzXM_Gg1zutKZCDeqvWcJOCQNdp_K
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX8+ZBH3510vdn
 uJl0Wg5jqVkdNYctsAERWVPytkgrtv3u+L1zle3r+Gx+xxFMrhDHkQ4N6wJ6MycO4X//0oPzgzC
 Hrpf1UG7HSCdloB2ftbbWt/sOBwv22Y=
X-Authority-Analysis: v=2.4 cv=eKwjSnp1 c=1 sm=1 tr=0 ts=6a9f1fb4 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=iJey_kD_w1PlP-9owF4A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfXygL7qKNN7sqD
 BqsuylwOxVeFsx6L5kIABmm3pWvMHSNuesABSYzhiIAs0DXcOTBrRAX3R/Ol1WlZURvvJy54kW4
 6yesZvy5Bc5oX0pXjrIzPGH6LSlKg7pcUiVYOndXcWbjXQ1NgchR3gPs34Lh+VjYIWWBqNWuIb3
 HG6gP/OMcGLysvFLKLBCFXWrRm9MKYp/WMeYtMxZ9y04bYLKZjXZSr90QYtKu+ZE53rBJ+0w3AE
 /OtUiwv6zc7cK5CfiTxaINyVuU7kjf0Tv2jGiHGe6+u+zjpSWX4SwwFnEpjQKkRVJafLTgqx6FW
 ByVWeTARLHAVM+vDchAoa6AbJt0Lllvvn6z59+ydk/od9BgJBxjowPiHvYfUIjM6lRyjVD1yYHK
 rPG8O4V8Ayh2OZrT0+LUTCDNMxnP00+9lyUsl7Q9ip6pLsFrEl9CHupJ++7h7QTAe/JQ4t7Tkm/
 KwEfDIUCJ4I/Tn7GFOQ==
X-Proofpoint-GUID: YKrKzXM_Gg1zutKZCDeqvWcJOCQNdp_K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070226

When mac80211 module is selected in build configs, enable SKB_EXTENSIONS
as a dependency since mac80211 has started using SKB extensions with SMD
as its first user.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 net/mac80211/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d6bc295e23a1..10d28985a1ce 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -9,6 +9,7 @@ config MAC80211
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRC32
+	select SKB_EXTENSIONS
 	help
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.

-- 
2.34.1

