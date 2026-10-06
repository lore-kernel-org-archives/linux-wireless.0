Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37433E49EC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294270; cv=none; b=aT33EM7hTSnCCZWz8D70hQ6NqTkvbZku9Rz8ffTp8km+Xhk8ZF1CqBQGy2Jq63dBgqs0+8lKJgHj8Bkzp0Y+Z2jcXUcFhTvhGhtZ+F0MCrLP+S8VjYje21CNvIP8WjJM/+hWf2BvQS+de9xf9lE6HU2EI+JwyHaqR8teK4Uq2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294270; c=relaxed/simple;
	bh=ygHAgdW3Z9Cs6z8zmqlqpO1P7diQciKBvJn92r7vRpY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=E7F2LTixcPy3r2E3zTjyLXGHV4vRIAPcsW4ErtqIvaQZv0N9DQA85qsX01Kc0c18iZawGL5/rScX2fEjiS537FnXM6YvIJK7n3idbsSJ/b7Y4CJpBA94UdzCZDIxKHczXLCiDEG12CGI+m5c3Mh4PzVreQ/kSHnMV3bOwMlIWLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HuCKxunx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bbGyJdvu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HuCKxunx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bbGyJdvu"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696DV38q1444759
	for <linux-wireless@vger.kernel.org>; Tue, 6 Oct 2026 13:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rYh0A2WV89qELVCG9L3F7Oo0b5oCSOSM4UplqqLuF+4=; b=HuCKxunx7gm17XRU
	92U+DCWGL//CulSXeQMUSjYLw9wfVxlasuL0soNT9B7CZDZBoc8U9yCRTex1326l
	sXC0oIVUdZT7su8LsP+E8vK1Qan/PXHrgzPdLkWY25WVFAWMj0VXJZW1wldYNg+z
	yNX7VtejEE8dNdnodhbLVLrtDIhiB49QtOIRJd3HufXWmj4w9nBcg5xQcvE2FWIn
	mbBZ1vA0/gB7WFjx/98kgE2QiIrAicO7oufwAwo6G7GNIV+J3MyDrQXS8ZXNCbKt
	Xx34V9ugSUfnzokxDhmyP7BTOMzWKas9+CW/FYEwu1kbXBYSijkwOmRNQuAdyt2R
	Tpyw3A==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4xwwrq45-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 13:44:27 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1384427c3efso4212235c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 06:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791294266; x=1791899066; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rYh0A2WV89qELVCG9L3F7Oo0b5oCSOSM4UplqqLuF+4=;
        b=bbGyJdvu6SVDDzzkyrNkF8sYRSCu7/JfjKSmUU5objaShn+StLbbRb5wFvuF4IoNKs
         h629zlOegWqoK850gXdkgVyOpaZc520UajA1NBNOQU19sZ6BT4yBJdbG4QSvilLIzgpy
         kQ+rI1da6Td+frROftdw2AqwIBxboTIatUC4srh7BxiIMWyeUdAUaIS9jnLahEf0dzqP
         0bjXiNgM2czvAgV97s5xgNVvf4lcxebPn5zbYDnQO3QadaovM1lmjl2p9TJ2kEmuJ227
         bI/kVZWPiPj5dwOkbb4Jo+GTlK6iaVh884w2Ujsq3bJVdf5QdPa37TqljtoGF32su8Ac
         6RqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791294266; x=1791899066;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rYh0A2WV89qELVCG9L3F7Oo0b5oCSOSM4UplqqLuF+4=;
        b=tO4zwY6HCc4OtRdESWdAKxEffvKnVZN7ES6f6KgMLDpb4DEcZDLjk0q2sSNtHQaaAm
         XPOcfX51mdQ0BjcyS3zgC92hicxh6Kajc6ewyx5WkTyYQBLfOHNLnKHp7hCmeL9uB/lP
         I1zBOzSEDx9dKsTdDUwdAy2lHBKvWi5/nLwD6lX0idfyTEa7lHsUr5uaL+I1zt1wHDnt
         VUDZBiRLMKDBRCdue2SeZk9+x/i5xct8ZIYjCza7sWlgJbRPiAzg7eJTFWaysNJ8kYt3
         Nu0WD/uqdWLBu8T9gF14Y4FPraS9y/Zm66Ho3vk0rlNfYTMHXjkDGx1jb9NNdssiizng
         1aGg==
X-Gm-Message-State: AFuF++kh6kqK1L4jRSsCJx3T4uuG1T6pFS9fDcnsv+QxiNHWcGPtQ+hI
	ZI278d+2Av6HIyoTq7cUTbSj5PP2YjJwEpu9YWk02/FRQ+vIvo7nNMIHMfIkiaAO7Uf14fSuaDI
	uZvCzgrHtDiXQ64Wh1VRHJL6y0qBqUSsis/pvzjAxXVmyEIJL8+UTPhW7xNBHAXYwMpa0VXXuOv
	hMZg==
X-Gm-Gg: AYBFou24b+uD+YFJR/qbfzwNXYHlgx7UbtHVfQ6JHXZ1xufVzdkxwGu5zCCaRofj7Rb
	pfo0nKdZeHv+/uWVd/LWUbF/pOqBOXTIHC3ZS6UyDDynEmKeX/PddsevnwtxDBdIpgL7kxOEOIU
	hWvia0lxkYotlVVRUFW4DA563GkmYqC4rHvnFX6w15oH/JiAEAx6uuMrGxgs+ZwimDEQdika78C
	2BWKLGivqik5Jm7PEJlfqMIalHq3e4pHCNBzHifeOjYMioItecP4O3ZDIkoPkKhnFmdG8jJD+JH
	fOQx6ZIcSTWr2kJcnJCiRR6BXe9MaBIHZQjollOIxeqoqh39prvO3mytJMOiIR+WBYu4wMaAj7t
	j7gQCd8uc2tHqSfsghDG34U9Nn8lXu5iy1Yi+r6aYiElPqJLZnKwngw==
X-Received: by 2002:a05:701b:4204:20b0:144:c128:4c4b with SMTP id a92af1059eb24-15ecbb6b400mr1884822c88.36.1791294266239;
        Tue, 06 Oct 2026 06:44:26 -0700 (PDT)
X-Received: by 2002:a05:701b:4204:20b0:144:c128:4c4b with SMTP id a92af1059eb24-15ecbb6b400mr1884761c88.36.1791294265151;
        Tue, 06 Oct 2026 06:44:25 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-15d84ec510dsm10148527c88.13.2026.10.06.06.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 06:44:24 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, Yingying Tang <yingying.tang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
In-Reply-To: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
References: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] Revert "wifi: ath12k: add panic handler"
Message-Id: <179129426438.4034642.2830752698143137972.b4-ty@oss.qualcomm.com>
Date: Tue, 06 Oct 2026 06:44:24 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA1NCBTYWx0ZWRfX07A55huw3kfb
 9Na7DIDPPyfkztba/qJt+bQuliv1zl6ub0I71rY8Qc+36oB8VZbB70/rsKAsic9kpGeMgwgwMOD
 2305r6p7NATcOT8B2LytvG0WK8d+b9+gi9mSSu/IIu+AhQlRRhNznPR3mNq2g2D9lTS9Xwauuiu
 mbusyByJVBKtE//HyZXCFgUgELzfoolfBDdG4fwoYntaWTlNktgmHNtKcqSb6txAPewLSF1avgO
 a2RrRz1qIER6y6Fj8PMJKj5JzKIVnd/ODKCrSfFZW8eYgEC2z+6OOuVv04bPyCzIRWek3yF9xL3
 PpjaDJdKrga+KlhsspJTChARG2aDAmhBF51m/L+JseK86A6Hs49lti+DpiJQC3NU2JnieY65GGc
 NFCKrhgsWNkjTC/86pkSkZjbYouxAbTkzDXJ8pH6zpMb9KDz+FXcV/voO/5uxCoiqyy5kBEgum+
 4AHz8lGu3y8/BKmNOaw==
X-Proofpoint-ORIG-GUID: dFQ5h8pOJcVx9CCzYSRaPdZLs__sZZYx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA1NCBTYWx0ZWRfX2G7PLbXcvr/T
 jIPMZJuwzn0/AIqN6XVPV9sbe2mZUuKJmJMsNe+2qbxGeqIl7ebxa7BYHd0iJrluKu8KZEoRslz
 xDBbsY/vz7gftYgU6LjxskzkCeiZS3c=
X-Proofpoint-GUID: dFQ5h8pOJcVx9CCzYSRaPdZLs__sZZYx
X-Authority-Analysis: v=2.4 cv=SJXXx+vH c=1 sm=1 tr=0 ts=6ac4fb3b cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=hNcc2shypapaRV4aqP4A:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_04,2026-10-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 adultscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610060054


On Thu, 11 Jun 2026 20:23:32 -0700, Yingying Tang wrote:
> This reverts commit 809055628bce824b7fe18331abb65e44d02b0ecf.
> 
> Call trace:
> rcu_note_context_switch+0x4c4/0x508 (P)
> __schedule+0xbc/0x1204
> schedule+0x34/0x110
> schedule_timeout+0x84/0x11c
> __mhi_device_get_sync+0x164/0x228 [mhi]
> mhi_device_get_sync+0x1c/0x3c [mhi]
> ath12k_wifi7_pci_bus_wake_up+0x20/0x2c [ath12k_wifi7]
> ath12k_pci_read32+0x58/0x350 [ath12k]
> ath12k_pci_clear_dbg_registers+0x28/0xb8 [ath12k]
> ath12k_pci_panic_handler+0x20/0x44 [ath12k] ath12k_core_panic_handler+0x28/0x3c [ath12k]
> notifier_call_chain+0x78/0x1c0
> atomic_notifier_call_chain+0x3c/0x5c
> 
> [...]

Applied, thanks!

[1/1] Revert "wifi: ath12k: add panic handler"
      commit: 05165f7b3b9ab6817fe216c24f90755b7c5e15f3

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

