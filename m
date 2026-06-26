Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD3D2EB859
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 08:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782463981; cv=none; b=TnkWivDDdRrP26V4jdioA7EEuKtY+bjQqfLkcQpChd7iZeVt9ii72D1hcK5QiNrlLi4S+FU0orQMPCO+F98l2lbgBfxVIVOFTd+SOC/L+2/a4YKI5XRhclVhwNq+MBcZqlierK9RwjtINlN3PkH1m4t4OE7iBk5A02moy7BC2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782463981; c=relaxed/simple;
	bh=T+QrpZ+P2htSZD4tSU9qYb/G2ufsfnde3mvfnb9dAS0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O3LtIAhq+LcbIfDZ3hxyzcF4Oyl+ygKRokMHvmgS1s2/8b2cVMjADbHAXDi+MIE9XxW+EIdaTw59vOt2HlCAA1BlaUZVc9ZfkzPrcvHLxIxrEcDm8KRW7u1Sg0z9PfPKk963uwUuVTMLwIiQ027OhD2+/ev43QKQvJbru4aalAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=my98i/gb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z4z6dO+Y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="my98i/gb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z4z6dO+Y"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65Q6VYZs587016
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 08:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=psSbIjkNvBr6Z+IlCpHYhWJ5FvKywc2XXem
	DP2v+LZ4=; b=my98i/gb5q3wvpfC1Fq520dcGwaxJJm1wD2feB+rhBv3rjThYDa
	3jshs6ufVO7Je/J1oXGWF+oYNoWNJH4H0t/J9YYsWlQCVGxODgLOdjq/OXOzka4S
	rEjlXDejr6bzo7Ou58vYO0FNT/cbL687GHVXjKzAbU9qDfN37oqCRKkOTc6bZH70
	2gvDorzijlYQfDk4aodmVBHYlAJdhctXPH1Q8COn5roasJQn23duKpgwewSAJYQF
	dRfRSxiW7ju/+VoJ43G6xTDWy3KYR71oSNccfpdGsGKiBpYFW3oWbfiSQKKc9IAF
	HlM1JyJR6Kal3JTkh7emGu5b2WvEbLutpVA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f1eew9web-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 08:52:59 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30ca81e05bfso4138eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 01:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782463978; x=1783068778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=psSbIjkNvBr6Z+IlCpHYhWJ5FvKywc2XXemDP2v+LZ4=;
        b=Z4z6dO+YRVc5a1pfe7t7X3Ld6/tys6GLnwSnQEfehAmhyHB8r6RscDDAYKkS1JCxQ0
         IMYdLT1vC0VscKMgkCh+GEvsAPfVkyZX7AYFmhaTWsOmnSQV8xglRZR9EK4CdgTnEgvW
         5LYmpF7aFkGLruXeTze03wkrk/4RCs/EwW1OLNOap0CkkJ9vf37ZdgzO0+jvbrD4LN6w
         GCBJSNo33lJX9cPycvDGsfpWhHjipLrbiFGclcD3TP69uvoPzuRCzvfWWlgx+MthHSJp
         yxDyHmjPGreD6BhmgeCT1sS3QSVNJBrHDfdUR8BQCth69JX3kc9AO2okfXkSI3XVsoF5
         uBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782463978; x=1783068778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psSbIjkNvBr6Z+IlCpHYhWJ5FvKywc2XXemDP2v+LZ4=;
        b=UNKrUvciBIO5zpPr++AsdxpqfKS3Qbga9M5uixndFNzVbA1zJJvMV98EidGrVCCdBp
         jaZHbN/6NwOEocxQ+uf1mkjjl66rcvZD/UFHFn0k4pnvHb/1Rk6nxJHUy+m71wbcTXug
         cYp1jCLIyQ609tD0t5XusJ5JREAwoP79bRXsdrH2SOaas2Y0eY/vBJ1dqTtwOemXL/kE
         2ympyKJpfFJ2vsv0PvXUsBPSYroWNCtB/cOdclovsRhCsznYUWzmdsVmEWkaXgBLWZhF
         NKCpoX5KkNMpFp8she1ndiHfIGU/R3B/T3WVKJADtdFaCafFckTL0xhzHBHUqNV+YYH8
         1ZVw==
X-Gm-Message-State: AOJu0YyhG2+1oNbW6ZKhc18z2q0myHvuGs8CJai1m2Qw/PU1xolotjwL
	aCGAVXTbRHYixOOkdgKYTKxUIlCwlRGn85qTCXkf3C9i8UKTQ5t+rJrrdPNu/TGquwJnNQNVQDb
	0ZWYRt6eI459tXedFEu8HYlTBL0KjCFQ1+cVKZDmYBnQcJ6waHvOtpGuz8BhRnTo6z6MQDxvsnE
	b3
X-Gm-Gg: AfdE7cloOQARX0WljizJ35+6DfqxP+9eg8I8jRKoX2hTiMHWKXQFlIUDwp49nxNIA8H
	C753xiqZNZGieOYP6Z+o55hEEcCIVgnkqpE5eMmYk3BO3wgiKNQWn+WMbF7WRxdKOuuwUnmME6D
	o/Yrc0avQF1rjikLuvocwQRF/LvtaQXTr2Q5i5Ec/4hf1O7OfR2kN0ZAOqC3msa383RaKZWq76+
	Z3xdMfpS3rS9bKeod7g8ovUGMriTSpLUNDsRKNeoi9nipXESivvFVPtOA1ao8jjcnODzkjUmbtk
	96+xnvSE79DJqcHxtzH2hSIpc90fUb6BpBUeKQom+KWc04WIlMyAx7vIxtHlUC4nauE3yYlu0wG
	OcDxYqoYR5FDc8YaP1k1GMLgcwpFz8MmqAEq3NtjLYrqzQzAlGdkjEuA2bh88O6cZpjtfNJxpKw
	0yN147TugHxhn/UihzSeVFjp/waa3u+WJDuo+X
X-Received: by 2002:a05:7301:644c:b0:2ea:e93a:ff9b with SMTP id 5a478bee46e88-30c84bcdacfmr5766324eec.13.1782463978338;
        Fri, 26 Jun 2026 01:52:58 -0700 (PDT)
X-Received: by 2002:a05:7301:644c:b0:2ea:e93a:ff9b with SMTP id 5a478bee46e88-30c84bcdacfmr5766284eec.13.1782463977784;
        Fri, 26 Jun 2026 01:52:57 -0700 (PDT)
Received: from hu-ssramya-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7ca8b918sm17384044eec.28.2026.06.26.01.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 01:52:57 -0700 (PDT)
From: Sreeramya Soratkal <sreeramya.soratkal@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, sreeramya.soratkal@oss.qualcomm.com
Subject: [PATCH ath-next v2 0/3] wifi: ath12k: Improve dp stats
Date: Fri, 26 Jun 2026 14:22:50 +0530
Message-Id: <20260626085253.3927269-1-sreeramya.soratkal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDA3MCBTYWx0ZWRfX8p6FUNgG1P2s
 Ss6byOTCaGqgNjM9yzuOAfIQ7xhv7MfB3XbB6QRH6a4oJ2bcEUrS2uhEPjvohfoZuDlIfd4PrB2
 E+PEYvcFKgVofzEpAdO21feItwHS9r0=
X-Proofpoint-GUID: xpgccV0l4F157aRXmHUNOS_-gQZGU-hJ
X-Proofpoint-ORIG-GUID: xpgccV0l4F157aRXmHUNOS_-gQZGU-hJ
X-Authority-Analysis: v=2.4 cv=P7UKQCAu c=1 sm=1 tr=0 ts=6a3e3deb cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=Y7FTOXQ5Sh0Y5_iOd24A:9
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDA3MCBTYWx0ZWRfX7iFbKkjM8yC7
 4ns0aNK8BXvXwphguAmqLjfyHBWFRP+ksqUo42XMY1+NQpkN3TlNq7S4pSQybcEcjb1l89+2v3W
 U/DWu0+zMpJdVovb5ppks7WZDowE7xtOCNfnDchlBZgkVJmdaKSEdOndmxsPByYyrygik7SCuZf
 YtRsElnWjJLOP1aSz/k9nk7fgfM0bG2bHW3EvoG2uYxfmpsR06ccchiK0ayQ3LaQzIYG67ldSlr
 QVtFPj7cN2ZRMf3uxOZAE9s5CjvBuS//A3yeg8MoQqYi+CejOTRidyL5HSiwX3qZMPTVWNP1isG
 UPpeS2aREV8vs1lGHmKEftpXu2+DaaalfdKQ4HyehMHwzCxajDsWJffYmrYmT1n0aXd3qW0zxxE
 AuIWAy1Vkci78Tiadn187kNk4RA1aOrJi4PjlhqHf83spl+f0C2l6mnlFSnYubSj3uF9ECNSE8d
 RopCHH7sCmjFn/b7fuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_02,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606260070

This short series improves the device_dp_stats debugfs interface in
ath12k to produce more useful and accurate diagnostic output in MLO
configurations.

Patch 1 fixes a latent correctness issue where the REO Rx and WBM
release error tables were unconditionally printed for
ATH12K_MAX_DEVICES columns showing zero-filled entries for device
slots that have no hardware. Replacing the compile-time constant
with the runtime device count keeps the output compact and correct.

Patch 2 prepends a ktime-based millisecond timestamp to the top of
the dump. In MLO setups the per-device file is to be read
independently for each ath12k instance, so without a common timestamp
it is difficult to verify whether two snapshots are contemporaneous,
making cross-device counter comparisons unreliable.

Patch 3 extends the existing per-radio section to report the center
frequency on which each radio is currently operating.  This allows
the reader to correlate throughput and error counters with the channel
without having to cross-reference iw/nl80211 output separately.

---
Changes in v2:
- Rebased the patch series on the latest tip of ath-next
---

Sreeramya Soratkal (3):
  wifi: ath12k: Use runtime device count in dp stats display
  wifi: ath12k: Add timestamp to dp stats display
  wifi: ath12k: Show per-radio center freq in dp stats

 drivers/net/wireless/ath/ath12k/debugfs.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


base-commit: 972c4dd19cb92e03d75b66c426cfade07582a1ba
-- 
2.34.1

