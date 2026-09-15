Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFCD3CEB99
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437623; cv=none; b=VUcGOIXC8du+u4HBwsdIdz2C7ivUqKillUoS2debgtUONUtoKaedHoB7phus42LUj77FteOTi6j5QNVhQbZ5mT7T9Z456KAJ9QPVMRpWc25YPzLTI5vov4bgSiVN/9HElZ/UUkeJP9520QyO+QEn94570twmtIr27cUW0HUJQBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437623; c=relaxed/simple;
	bh=WNLtVYovulm5H0PESXUKdmexqCEBjcueUzUs+pZdCpo=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=f+j5EGCAE/XWFz9GjT+Wyp+vapkqJ3+x+C6A0LYYup0THIXt3qbfSPXKgEhXHvzpN/KMdKgqt8VhkjDSXrFGXVKo7beH5UK2AkoB5AyMGdaQ/Sl/wcaPAQsbgFctETLZyGOeyizQ6BpVkEVSflieHgCYHasx/iSFXmvXrwPgGPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f9ZU9bs3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jjzg5IWT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f9ZU9bs3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jjzg5IWT"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EN09FZ2827339
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 02:00:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=VjazF2u6aHcCpAoZDETq19
	dN3ZnMJLylSSJylHYqTeM=; b=f9ZU9bs3a5oUo9/qWaxRlLegWqegOsM98sGUek
	YpLAWywyhrft9sL+JNzBCdIcH7my5zgqWiHDWHw5ORQw1HtThXOt3iD+7Wk7Y/g7
	0f2jc0gLjIhqyZSeqFd0msrzlLQOV6g8UsIjK7G6tTi4jTGcaA+oecjGswvhC5iu
	lNzIJHC9FphsGcVU8e+Zv3e26yCywEd5Vfn+1q23f+mxD6UNXIyUUNbjnSHz3n3D
	5rfhOdsmjcSyypY2XifwcNYLwAM67wGf9YIL87zbWue9GNZKEZj54xxHXM1BjO6r
	1Uih7DDRLXLqmGOWO9aCnCMJDhGmmQqWLatN1zl40sFzxORw==
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpn41sp10-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 02:00:21 +0000 (GMT)
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-455ad408573so7138215fac.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 19:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789437620; x=1790042420; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VjazF2u6aHcCpAoZDETq19dN3ZnMJLylSSJylHYqTeM=;
        b=Jjzg5IWT0hF1hyrIKcT6GFyDZHTGz+9yGVzs4zOfwvDwXemLDz3+cJINLRwq/KK39j
         aCElWxAWcN2tSsxwQlO0fMdOcv5lASZDgcEJ2MM85nMKFHCm9QpG/gIRIVOfowsvyRth
         qm47bVS7GMc1iTfAin5kRhBqzE9wmdwgvlnyS/QNf5Mka0BFVtVZPyLA7Q2FuwqDyjYX
         LQE/GlQzISvQsIe1y/FEs9Un9cIzX8gFDGKpMgqINQc13FXL0U44UpohCUqnIjWrTloq
         XRgTKDmpbQIem5duBGnT1STT4r/YEqvKr61Hn6oJXbur5DZOyRwU8Q4L+tcC8U9jFgWz
         hgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789437620; x=1790042420;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VjazF2u6aHcCpAoZDETq19dN3ZnMJLylSSJylHYqTeM=;
        b=1uo4H+Ifkm3RvL6gne1rIk7j2vCscpnMdkTJTbHPPbPWh8unB+rwOMf0JCjU6B8tmJ
         cQvFdayWrV1oRRXWXo9wEROrIBjAAanuMV9GSGPnWvhZT4x8XmFP0YFaWLoFNtqk2/pj
         0dH15lnZmhzUTs8rC0GeYaTbolTXUpVuBy25MG1RAjkZu2XNgtCDFAMHPyelx+k6/zls
         60Rv6AojpczMIOauS4QgLzrTGejN84iZn3fl9HdsaMkpNaJzCv4GQsKj7WJl5OXPV+OU
         wzTD2ZbV8DuI5xbehMs17UKXWZZfo6spLNW6s11auVcpjEPomo6+NQlv8/YVi/Ngk0Do
         5UDw==
X-Gm-Message-State: AFuF++mersqjR9+94gkgFW39q6qhZFCECSLNXR5xFbb95+Ot88BlSCJg
	7dPUtZ60tpoS1gbF5I4SFG8+8RuN4gEnsFMPUKfC3mEBPhrsKeK5ai0s8YPuIeZ7wCm5NPlej+W
	TBPjXKfVM5nf5RNWZNJAKvhg/KX87LRNcwfonMFwBzvdno9BOBfN7A75TZV+O9ktveSFBvsk8p8
	XKyA==
X-Gm-Gg: AYBFou2xryIEE+EWxfNxmtKRxS+p3PLvvcce8G47cuhLybpRPSREazoRewGzXFIBWgl
	g7wldYqQrg7BT2doMstdm5XKw+yVyILfWr7LpEjoB+Fi3D2XEoJEHeciEp4135JJbYGKMdJBySu
	+eH5k+xnrCiBj0tWlv3hXmzsRCO/hUA9WXA5xrNBMSdn74bVlpEAOCmGkfzTE9LmXs+HK8ah3C1
	U7OzeOMWrAJSna3MRyRr1M7bivBlb+KOhnev578nLNbHPkPF4MQ9v5e/yatQ9Bt2+w0l8881Y2E
	azt7th6tZxIayQHNAf0WJFTTAXEeD9wLhPrk4nNfRyOUu9cxcXANJJxYmr3TzPlVNBagEK4ZiuI
	qhiLs7bKageqHHkK7HS0hhcXyZ6XB4Vp7hlPR
X-Received: by 2002:a05:6820:220a:b0:6c1:6bdc:466c with SMTP id 006d021491bc7-6c5404802demr3020702eaf.20.1789437620395;
        Mon, 14 Sep 2026 19:00:20 -0700 (PDT)
X-Received: by 2002:a05:6820:220a:b0:6c1:6bdc:466c with SMTP id 006d021491bc7-6c5404802demr3020679eaf.20.1789437619876;
        Mon, 14 Sep 2026 19:00:19 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143659a9a06sm28347650c88.0.2026.09.14.19.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 19:00:19 -0700 (PDT)
Message-ID: <22125816-3a33-4df6-9dc5-e45f3c970e1c@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 19:00:18 -0700
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
Subject: pull-request: ath-current-20260914
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDAyNSBTYWx0ZWRfX2ZonrgNYsxnw
 o7pc8ucPuJQGVba1Ek1GkvbSQdD8QsTHaPmsR+8y/ei+b03awkFyKOLGvHz0wTPIfAPo7++TMk/
 yP3TBhREPz5rKfgkjQaioEj8Bg3NwIbK6lEgpo4t8IQIAs9M49DikcbzvpbAw7fowuifAshOQXD
 q1FNfcgCqAPhcA7rwiLBrh5/WpCtph05Fwl0mXEsn1FdktQAeErzxvO/OkUjh+QJK2yKycJWfvI
 hRR+/IBlLZCSyNJ6zMaosDCKG3pcRihCg2486UCChte3uPL/Gr+xjQU7Rc+3LRHuc2tXjA1LEu7
 M1ApcTAIMTk+36bS1wa3r26MsNBd1TdhmWf9ImgHGqhuf28Qb7ywiLMNa647GUtQjYCPGWKVvm1
 KRYO0sIpv76hdhtW2j0H3wRHysKL8asEbzVfhbySEZWatLuNwUd6K/f40X4fT/Qk+lfysTIEzIL
 7iiXz+SLbHvl3Mmu7ig==
X-Proofpoint-GUID: QrlIHcVi-f0njirJwMxF6XVZoDO11Ok1
X-Authority-Analysis: v=2.4 cv=cqQOAF4i c=1 sm=1 tr=0 ts=6aa8a6b5 cx=c_pps
 a=CWtnpBpaoqyeOyNyJ5EW7Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=hu0l-D-OjZVreMFwxdgA:9 a=QEXdDO2ut3YA:10
 a=vh23qwtRXIYOdz9xvnmn:22
X-Proofpoint-ORIG-GUID: QrlIHcVi-f0njirJwMxF6XVZoDO11Ok1
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDAyNSBTYWx0ZWRfX2WEPMXL+Qoty
 X/pQzoE5OGliNc9/yxAPU5lnPCCZqmKkTxYGIZON3vGx9hLhKU9YxTKU6DImvTenlCPC6P5TK+1
 oFzeHDDDVkOAfIxtPWNkGcj4nrv1IQo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_05,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150025

The following changes since commit 50d3d79dc0743b616afb00d01a626c76758721f7:

  wifi: mac80211: set up the TX info early to fix failure paths (2026-09-09 14:51:31 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20260914

for you to fetch changes up to 820b8cff81c796ba20573e04722ab62500713f97:

  wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all() (2026-09-14 11:43:31 -0700)

----------------------------------------------------------------
ath.git update for v7.3-rc4

In ath12k: revert an undocumented and unapproved DT ABI that was added
during the v7.3 merge window.

In wcn36xx and ath11k: fix preexisting object lifetime issues.

----------------------------------------------------------------
Fan Wu (1):
      wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Krzysztof Kozlowski (1):
      wifi: ath12k: ahb: Revert undocumented ABI and dead code

Nicolas Escande (1):
      wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()

 drivers/net/wireless/ath/ath11k/mac.c       | 25 ++++++++++----
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 51 +----------------------------
 drivers/net/wireless/ath/wcn36xx/dxe.c      |  2 +-
 3 files changed, 20 insertions(+), 58 deletions(-)
