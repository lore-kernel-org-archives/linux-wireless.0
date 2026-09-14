Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19792E7379
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411588; cv=none; b=aI9IMJBhIlGAg/JIvD8ow6KbTnuQtqgpYuVvFkG28S5PBTuCPBr5uYSdkJXPYyb6vmtSEf42oVPPqcnPU27aezrfjUwir8asnF6aDnkDqKXp8+d/VHpisN7E5bdfA+H5f1wRgpvtoI1BJ6C5SQ5oLXgsu+Pt+popan5dlZXZluU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411588; c=relaxed/simple;
	bh=XY/3qIYC2EQqr1ohxOSa5m4ZSvYy8JKUA6mpZ9fziOI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=W9aK6KLwUZk/X8vCg+Xtv652atzvzczY4ozno+lgT+0sw+jQ9zlpGTnami1jFzqSPa665PBhTWmUw3UoFE+c90rKKNn/7kOmdu8f4Q/xOQItuoD97JIhGYS4qehpqE4Bm+0uibq4ldSizGwn4AVsEDp7EXcCxYtgwBul02onb40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=llX3C1pT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fMZw47Js; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="llX3C1pT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fMZw47Js"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EI9us73588164
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VGLIJ9VPDDvsw+y1uf101oTVK9Fsa0HkriLejdXe5bg=; b=llX3C1pT2oJpHBmG
	63LvUiHXFHmIW14Nrh/mIaQfJKGQmLvv7i3MiioJbK3Dzz/7RMMrY8E6SYbM4da5
	xyREVw0AuY4NdkQq6+RU1ADpUWCF6EWYj6n/2mk63nfQDOfFD6pCh3qyj61Lkjg4
	rS8n5LzAx6aOhGgqv0nbnBSec60VCh0xPn1udjkOGTpUPWltYb5ddHGBtArnao1H
	hd9DnacfJPzq1hNqGP4RidZ2PP4Q5/uCGeHbPz9aBkvyuaqHy4TKexrY5nZIQWqn
	foSOON1A/2eWw4I122teVS0HHhq09I8cMyOnUUiqoos2wDOh1cG/7PeBQwu4xA0C
	xYqkfA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gperga5de-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:25 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc2229450b4so3201376a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789411585; x=1790016385; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VGLIJ9VPDDvsw+y1uf101oTVK9Fsa0HkriLejdXe5bg=;
        b=fMZw47Js6jRC+dXQs7mAblEiEKvpZVNv/lz3fnAUV2qzbtw33bB0loWZcNd+nVzTD7
         Dl/sxohtZ+Sx6SXx/bjV8utfDtydQd75d/kp6pjplfClVxK5PtXpIrhocwO3gmnXBC7I
         GcBhL6OeSm9XlNKunjPfg2/pbi6Q7cfz9i+X6kC55fgTS2dwMUoXNQARuwt26w232upW
         TESwZPEg+yu9Wptukc9IAJblaw7njGbcB3pzcVWVkHIIs4UygWyKXZgo1JTk56ks7w/a
         XBuH75XjRV2GvuC36htxR66RpwISWXhDk0lv6/r2GF6oQh+ZHIfa3/BJwrefblIOHbix
         XhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789411585; x=1790016385;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VGLIJ9VPDDvsw+y1uf101oTVK9Fsa0HkriLejdXe5bg=;
        b=OQsGL3K/aEc3+xio2Czbrt4GJBrHH+3cfNGXwO9uIm4iHVNhxM7Hiun6pBKl2mN2wx
         TO/HU1RNSLjvzsUA1cpt0MtbYCtnk7dKtD024q8SJzsJxn2L1IHzIIEyorgAfX/nuu6X
         Y69ZYFWpI0P0ZVDyTpVwCnmuW0cBFC0hJElWr9npfRQn/J3bbY/yTSiCR67sUzQlZJYJ
         ywubJLN/NMIOmsY0rbZjWNLQQr67+ksTUQl1ec45JCNZdovAbJrNuA/+T4D1eVI/vccq
         0FdlYSkyAtwlOdTgWwRYh9Z9/Y0oPT+07ZnIfUDngx+pHQzV0tX6gCzdYRRPynC+257W
         RPHg==
X-Forwarded-Encrypted: i=1; AKwUvByphHs3h0QfjcNh9NeaP1HFQOpEshdgWEtvxLhyCkmTMweh7k9iOQE77eoqNI5OUEWX278o0PFBdG8tNWxJ6A==@vger.kernel.org
X-Gm-Message-State: AFuF++kdltNreqyxE83bski62sfNDutGhQz0a5KvPABvn0uankZjX07O
	3n5J4NybpR92zkLQ+Fk8ghsT1pS4dSbGi4zXlgwIKMT4cHaL79dtgt8N4XgH5hBC+0m/hnmPL3K
	bFWOzI8WmqmVwGEh47P0biiAKBDkMDrRq3vbYehLp40o+yNxmN0iXKl59GajKa+0Qre6NxA==
X-Gm-Gg: AYBFou0mMaJQuBRFEoGgCb4MfQc2ds1FKYU/3slD94SsCjYQEFJvWaeUzfnlzFHzQqr
	HCVBgU+jufuv32TygiLyKyTDXGN6lFIiJrJ5vp7qmp+63PGS08lbM0pD9Zn58rMtiP2JWKjaDbc
	pvjvuUx9rOMG1C+9cHcb/r727Mz/L8I2gxLeF7KOWxvMzEgL481KVOv3M2d23sQe/pCFdL4m73v
	lE0ZbApXTCq9mhX1I5SAATQa23TplOV+GmWt8gQUevzvB5oGQqZhFo8N40/04agEGuQhsOYa9eE
	5xkkehdM4n6juyrB+mxU92iq8pZ8pp5vudWNSEA6cj29jyW8YcLx6zjeWafOF6iWi1UQhrnIaD6
	bqnfBtyzCzEX6BwZXLr0JekZWINo6k4aT74qTW6Ez2qMDSEzlTUx1TyM=
X-Received: by 2002:a05:6a21:481:b0:3bf:7e2a:e874 with SMTP id adf61e73a8af0-3db4039cbebmr8612105637.1.1789411585188;
        Mon, 14 Sep 2026 11:46:25 -0700 (PDT)
X-Received: by 2002:a05:6a21:481:b0:3bf:7e2a:e874 with SMTP id adf61e73a8af0-3db4039cbebmr8612040637.1.1789411584633;
        Mon, 14 Sep 2026 11:46:24 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f06423sm32032524eec.20.2026.09.14.11.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:46:24 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
In-Reply-To: <20260825081313.71351-2-krzysztof.kozlowski@oss.qualcomm.com>
References: <20260825081313.71351-2-krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: ath12k: ahb: Revert undocumented ABI and dead
 code
Message-Id: <178941158388.2896945.2176290382706529944.b4-ty@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 11:46:23 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=QK/91QLL c=1 sm=1 tr=0 ts=6aa84101 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=qqqMIIPnSBjTorXjQPsA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: VGm_vzs8zt5DYo8Gct8rRLl8ycgXpm_7
X-Proofpoint-ORIG-GUID: VGm_vzs8zt5DYo8Gct8rRLl8ycgXpm_7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDI2NyBTYWx0ZWRfX6pSX27WrM6oo
 IfLyKAVODkrKSvo7z2rrAK33xMD7GLHjWFLaBsRb38xGD0lDHes5YgywKaYRvTfEg7Edub+qLHD
 WiIzvYyRFC3Blm+BljJekuPKqRXNA299N+GsOhC+bza81OXXq8LAFemW8/RGiEFoHtWYfpPFh96
 KrZFPTWl/5VaJjGGU5NRGSDMIILEeOncW3x+Y6zPkJtivXQ0jQCjpA3lO9IcwTv28UPu47G8uVf
 J6qJmK1a4FQZszf2T4ocBcdjG8obErTm0ASUJEG34bhT3oAm0nfe5AaVYZ9FnNAuPpgDYTiMbVH
 4V/tnB/EI9pVU6q7+yng30momT7a5eCU792IPetoYnHgOx47+AD6d2Is6ErPlTVbTGdQ4ih+Heh
 wcwREK9C1MltEeMiQPkZ4pMhFjnDyzU3FByG9KfzR1jwQuwoga8qZULGkqcM565mpA2cXz2WL4/
 QhlqwEWxdOAOh9KJEiw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDI2NyBTYWx0ZWRfX6QTAnBxE4ke9
 kTG0XoOV6AYj8pC2HkKLRLZeQa8nx6696xyja2TRukD2tLsmwW/DByTjOLBoswwaw43cWmGphtG
 RU1FFQlA61TMkbtnRXwmN+ySsYwT2v4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140267


On Tue, 25 Aug 2026 10:13:14 +0200, Krzysztof Kozlowski wrote:
> Commit 96f46607bbce ("wifi: ath12k: add AHB platform descriptor
> support") added undocumented OF ABI, by relying on a very specific node
> name.  This is not allowed and was never acked by Devicetree
> maintainers.
> 
> Additionally that part of code is not even used, because all devices
> have exactly the same user pd, so this was added "for future".  Adding
> dead code just "for future" is heavily discouareged in kernel coding.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: ahb: Revert undocumented ABI and dead code
      commit: ce9d5197d651cdd0fbb586c3d77c28438abe1b10

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

