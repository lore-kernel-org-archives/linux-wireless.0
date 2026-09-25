Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3304CE679
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350023; cv=none; b=ZLnBQBkDfmjc3Bc2rYdtIOwwcooT/anPLiKiMt0ckGJcwuGrsoTO3OoTdJqgMFgnnObm1JexeiDQ3K1J35PTKsLaJFQ4Q+35LLZdapt0+VnvbeouMkCNI2MkULh+8MX500EzU+Sn0xX1wbCl3o5uqUNQ65NrM/fcPy82+FyyRQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350023; c=relaxed/simple;
	bh=sy5W72lZeugxwFKME0XATWnLJL/K4J9HaXD84Xrx0jo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KC2D1e7c7Y4xvjRXVvf+YQchSBnauVzUo3F50jm3f/ENOTKIIDH5nJhjcNnLz4Ju+YtRjgrsgWBsIAO94JbtpPthS5Y9FKYObnjHsIsBvsw9yaljxfOjvzsCW/zzvmI8w53kzuvp3BIzRkZe55NSpHwgTn3La47CAWHns3Gs2h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kH4u9bZY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=imho+gMD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kH4u9bZY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="imho+gMD"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PDT2Qu3628345
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ckoYhtpH2OqcDnSbmqcysMB3cQQAPrIhEI+eCtKkiZc=; b=kH4u9bZYdwxLpfZj
	QiaChiBaM8GhMYpYgLeZ9M/J0R+Naqwh3sCeEqBW4n+DsTEnboRWpdEL4Z6MbrF0
	hyDArFR6mgg6dbJ8N6toZvvWfcdfiTjm083PRdI5gumqBc86PLJ6j3MSS79T4BKx
	/T+UZSJSsNM6+G7poW6+9ncu1esUVlwaxl2+edB/uhyFzeTgkjTy3HzTN4C4ts1u
	5QdJtfuvCmro1M8grIAp8CG0O91Qky73mSdjuyKiUdLISO2Oe81xRzNeIu8OYZuW
	MhzQ/2LWhP1lYX2f3PiQvmBEhEzwrbnOxuQTKxdKKzf/dgTiZLZqE5ihPF9OsiBi
	KpqkLQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq39ycw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:00 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so1272409a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350019; x=1790954819; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ckoYhtpH2OqcDnSbmqcysMB3cQQAPrIhEI+eCtKkiZc=;
        b=imho+gMDM3lBc9xwogpfpJcRkzEp+L4WgW7VQfl1hPM+Px0m3g1CUkpJVMhULpf/5C
         fAGDoMgJIuqH7+vGgSya1C+KhpgfrSLGVeuvA1bOnpRxeO4EaKUiZQyo+n8yeny8a/MF
         5NCeO6+cuIDZpc8JDKHhEEFIYTU1RJimW2QVCbkHX2jAxu1RAwnckIfM8jhS1dEQdkNc
         R8yoJN8Do8pArzS+1rj5fg13gjxA6wtZvQspn41HUd8IFW83/0X/yWmuzBp0roVdVNdY
         QgaGkGRR1ffEtVIFs+5ae153OLiSDPBmR3bN6nxQi3xBJXa43RxjAckpZ8px7bwAL+Rx
         XBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350019; x=1790954819;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ckoYhtpH2OqcDnSbmqcysMB3cQQAPrIhEI+eCtKkiZc=;
        b=dYjpCnNHi3BgJp+PtE2soO6oIAg0TnMUMLfu/SMAdZy6hzlKifNbiGOrk27iYGuGIP
         VkYRmwRXRInTbb/d0SL8R9a62xocf15yGLkcos8oAaprvYNqYAFd9/s0Y1XlNMUzwYZW
         4FCSpFU6lkFHJKKgTA+xPyuANsDleh7p1xX1Gou1eL6CCLd8LdO+eo54V8GAleYA9BH8
         08bplOdv7NHkukuS4hDKuM9ZPF5I+jO0XKSCLBj/dBv78rg5SPdZDb3eHy75fms3dMlX
         wVptpI7j155LNj8bGORZ7vq4aWcWhs2fzOOhabLHEOLcCfwkszRLBclYQ/5DjNOqzFaE
         WtPQ==
X-Forwarded-Encrypted: i=1; AKwUvBxLhSJTjphLxIZVD1RUPCO1ggy4UyKv+aqVT/NPzVpu/ftTlyKtaAhDvq4Xwtq+x6JAAvXnC1ojFzPFcNCJQA==@vger.kernel.org
X-Gm-Message-State: AFuF++nsIv2086QBCL4AM1Yt2nydZXVk0yzHOKi0lolVKVeeClqxO/ak
	BL3LkrC1kjGK4lIjHnzvaxFgsblpO6U+20Mfm6MpBIzZ+0xJ4Sv97oTP5MSRUgTsuc1xHfVg5SX
	hXEmcVdDAAi/WHA8sNQ5dc8eaqu5D29DgrR8yeh8QckVC+iU1AdoZ3GoEIfrhJbXlGAVong==
X-Gm-Gg: AYBFou0c59d0i+XO9dtJKjd+oIbmnyT9Xd31grv6xLiepjmXweQKyvdI9H6cyeasV9Z
	J5FCOhcFAfsdbH6S+ZYdX+vWYoAbA8o3wtVFQgX4r6uL6akkHjx7YWEEDiUPYrHyBJTidrsZSmT
	rQJxiaBjfhmuCLylTO5i3php4jAcfPA8MBDTbprbd2JQqajFk04ZXi0BG94wWgeqERM/3SuKhL2
	lc5XWKoX1iRGRBskfhfKDzYIv7FeOCpojE8kpOZLWmAIpDlnlZHHlQrQgIndz+C3WlYYjnIkt49
	3jBfJCmrhQZ+ShOw/bfzncKwZ0eJlB2CK2KwMGB/VqVZawLv/I/ELoOQ5JcX8nXFU1idSczNApf
	r7295S18uddZ62kAQ3ms8vrz/SNLjP6JIY1NCYAsTufrE91b4bldV7yc=
X-Received: by 2002:a17:90a:d40b:b0:39d:f2a1:3a with SMTP id 98e67ed59e1d1-3a0bb573f4amr2263714a91.15.1790350019291;
        Fri, 25 Sep 2026 08:26:59 -0700 (PDT)
X-Received: by 2002:a17:90a:d40b:b0:39d:f2a1:3a with SMTP id 98e67ed59e1d1-3a0bb573f4amr2263703a91.15.1790350018748;
        Fri, 25 Sep 2026 08:26:58 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm5320405a91.0.2026.09.25.08.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:26:57 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
References: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: remove unused
 ath12k_dp_rx_h_find_link_peer()
Message-Id: <179035001747.3875741.12204021916380057963.b4-ty@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 08:26:57 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX34XH/t9tsoxb
 8s8ssddVfhKxtCOD8TfjiWC6ANNDP54vqTF9H+EA9nD89tkYAu6aSt11dqQLXx2EdzXt52th9/U
 7HaulNBJ1RFROMZvfMg6ZqS8wt0Czto=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX/B5XBmcJYw2d
 w7+VYQz3wFul8KpgE6z+5aIXpg0/FvfV5EDS9F4MzBHYXSv85+Em4HKlsBlNCb2xAdlhG2qh7A6
 0s9c5IJwYb6NYVSKxFf3sphR82RKPbud+rVctU7Kc4aQgjPn8G+AJ9cL8gYFPQ6pWpOwhBPLmt3
 wtOXEZ8AYLZK0xGcsEUoaok6DsDsBkwEv3fX6DldISXxZC9M1i5KMRZoLJ+v4iEheGaYGqmBzQC
 N5cLAvwgUbC7az97H1x4d2z8qR9WwrLHYhhY5ptQfFUFAAzjl6SeXopEHIxuo9c6E3fb0LZspWa
 mkKuheCRF8s549RoLIzlpMw/RGi/xuCD5HWY1R5VRd7yREQMe+++xjgRaTyONABrWhYVhfNSIBw
 bqrPk9dh/GqjX0JwTTuAGvm5SOVqY919YHjZigks+RkvRtfd1/ZWpEsBALDo6yu4ew07mCPGj//
 mfmIpbABsp2Iq3CydLA==
X-Authority-Analysis: v=2.4 cv=VuO2kO2n c=1 sm=1 tr=0 ts=6ab692c4 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=luzD6lnB6LjBjRZFz1sA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: mRc1UC9fxCk3o3LEucyHBw9kd1Yfis1f
X-Proofpoint-ORIG-GUID: mRc1UC9fxCk3o3LEucyHBw9kd1Yfis1f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250061


On Mon, 03 Aug 2026 09:05:32 +0800, Miaoqing Pan wrote:
> ath12k_dp_rx_h_find_link_peer() is no longer referenced anywhere,
> remove the unused helper and its declaration to avoid dead code.
> 
> Tested-on: QCC2072 hw1.0 PCI CI_WLAN.COL.1.0.c2-00229.1-QCACOLSWPL_V1_TO_SILICON-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: remove unused ath12k_dp_rx_h_find_link_peer()
      commit: e1ef274a49873a9545b51e36f1f1d25707372872

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

