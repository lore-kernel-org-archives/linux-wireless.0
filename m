Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A1372EEC
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785378758; cv=none; b=gFJ9TzAmhaM8ZB2m7w5Z08+wlHxae6DeA2h82KxfbeX0sSIlRsSUUHC6v36cRnG2vt4kG1lFK7Wc/3ytXcUMRLA44BOug0yexvyv6NfGmzr5lTOZDeMlijikHS5ho2YKhOIHQ8/bcLP6vKVJrx52ytTmO8N2dB9IShmlBvu6uWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785378758; c=relaxed/simple;
	bh=FYl0tG/g3vDBxvRwG6pmEXvSbGJTaRtCRelAVFL3W6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZrfZcnq6g0aiiHFNz33UiMm9+IDVaEl5ctzC4IQYPvD+RHmICjzoHgrZizsPMDgkYEyzn0ZfSh1fLGjiPGycf618kmn/oUs8hHILzCrzMt2k/waBPrD3Cu9n9lSWSvCGzlzaa2PJYZeaV9SClpFaSNc+PHChAPQSXuOYklMvbsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S7elofE7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jRnvK4W/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S7elofE7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jRnvK4W/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U2UAfP3912874
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=897I7FKgCTAsVWazYxO3OxwbnSDtjMwV5dg
	naRD+8qA=; b=S7elofE7LoOVniZ8nB+cSjjBRuDWKrJ0EbSczpF3GtfQAX6POfd
	uiKJrUQSP6HWj82r5MFWSzZeKwPOxp2a9IW3ogC+SAiEEf74GlE/GoQsBbhH5ttI
	9ykG+5qtIbXsQpIz59k0wtT24FdmipLw/7a1owyOXzqbvXIXbVHKS06sdsvV3r9V
	PZrvJ+PdNGUFHg8KicXAL+XKYSuWwc64QE4QbCKvSRSEUQbTiJ8PqZaBZ9v1sJQE
	lg03BT47aUuKH/bEFTlXEblSSpWO3+ktyaXPrY4tuM88JIOitNmiHYvTqL2I5TkJ
	h+kxTSPv8fn+jJGHnuGhCqbOL90lzWTSVYA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqwvr80b6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:32:35 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cf74ab63easo2255015ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 19:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785378755; x=1785983555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=897I7FKgCTAsVWazYxO3OxwbnSDtjMwV5dgnaRD+8qA=;
        b=jRnvK4W/Gmapt4FEUamXCeF6thH2xv39qS8N9mQgw5ETK0uLoZSIXXh5sWwAY+uOlh
         On6z+2ltGr3fkeMNc1zqmTF7neRvo6gKNRB74euAAg+UQF7vhBo1ojMBDxSY5Wplc8sZ
         YGH4yxnLWLaqAzOy8T2OFlVjukj3q/LxNJCR6zrWxdC9ECLEFWzqilQK1B5PYGHnwiEI
         jFK1nRH2iKq3X3WiOqBa8SJFeFEtqvKDzuOJMFtyN8ApyXvnkDqivDtQmmD9izt4myDB
         E+Bqpir7jeP4EYWgNIz1FNWzsFDnjw1Y79whnPVHm3iUDCzcSORPSNCrf/4yxa2ox701
         80yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785378755; x=1785983555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=897I7FKgCTAsVWazYxO3OxwbnSDtjMwV5dgnaRD+8qA=;
        b=BXxfVv3cQsifZYVpxWnlyaKdCwi+utH9IcewlA4X8j1uoQYCCjyLL9tf8bRgqluzNM
         /slxRuC14QYnjDl1E1yih+LuEikSPw04x0KDfIXJ/L1nLMLkWlgYm4zvIGvU482gFYZ2
         Xy5MkCY3ghf2humM5OsoFMLOzkeIbVZBZSPHqyCBu/tR6oLbDxNEhXmIJjUEQJKYZe0I
         TBubC7sjKUD1EmD1ucTxXgvxFWgzwwBNNRBfEmYtHo29Elgtj4pFT/gu0/+72CALoRLH
         xy+2HItnhtn2AflNq7bjKL5+FMt6fFl51sWCOtvshw8GklQP1cFDXMomAvcpnuMDkE6F
         9r4Q==
X-Gm-Message-State: AOJu0YynQXqKeIjbsxtSg/b4YNF+wsq67yUeeyB+uRdBtNdWCNi81tal
	KFGQIRxu3Ux4tOxw00IZ2T0ExwFclPz8VoCmozJFtuyDBoOrA11NcS1Ggq3toS9aQ7l2AaENsfh
	nYKS51UAlAynlW5Ovl6rGaPGvl8bwWl59lbrL1qUGBYnsW1rZawJH9EZH7Gp+6iwWQ4pZ6rRJz1
	fmiaO7
X-Gm-Gg: AR+sD12g1X4QEicBnjxzZqZb8HZmMin4lubXaMCbqpx9D+4qelac705w6LhHiiOamVL
	Ofl3Fzre1Rh1cYkvQ3kSoN+vSqLtGadV5gIT9aZhDgtBCfF7SyeM7w8Dnj68uyLCtWJZAxCdlqi
	dsTSScPlhlijdecAIOtr/2I9kCSZXtlnTfGW2R/CT2DnwSPahnGLdWDnaqAvW0pdknwekpcboHR
	fDMzlC43LM0cb4dHdK5O/oIj2+mbuIKRkofQv6t30W7yFbWaCr6CE6j/O1IZt36tJlDX0FIrXt2
	Em9GNoCpykA2kInnH8sf7mLTOZB7yFvqKOtTed1D2bgIkGFLoTpkItCk5ynxIkRxqc3r9AuBC/6
	cs6erYkEn6186fmNiSn05oLQQzQ==
X-Received: by 2002:a17:903:1ac3:b0:2cf:9e90:8be with SMTP id d9443c01a7336-2d035d1e176mr11188445ad.4.1785378754686;
        Wed, 29 Jul 2026 19:32:34 -0700 (PDT)
X-Received: by 2002:a17:903:1ac3:b0:2cf:9e90:8be with SMTP id d9443c01a7336-2d035d1e176mr11188195ad.4.1785378754301;
        Wed, 29 Jul 2026 19:32:34 -0700 (PDT)
Received: from hu-lingwu-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b6d14bsm13986723eec.10.2026.07.29.19.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:32:33 -0700 (PDT)
From: Linghui Wu <linghui.wu@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org, Linghui Wu <linghui.wu@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath10k: filter non-UTF testmode events
Date: Thu, 30 Jul 2026 08:02:26 +0530
Message-ID: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxNCBTYWx0ZWRfX+4XioYaI8qNk
 GGCOmAJqcHGk7foN2ma3ytEMnf3hvZ8lEQeZz3T2ogInH4ca6ICXEr3OrqyHylNaNt6oP8y1Acp
 tEv4weQwp5Hq9uFoiZRweemnFJMjobdEsZYUb9rYgECkbjbmm1c8rVox0+MdYW4rX1Tb7YsRZVs
 QYfsCGNdpxN6B0KqDdzS4he2pddf1/VlgQXyiz21NmWGUu1AuT7crb72tiMf3rv+OJz2C76HLYD
 pYnRjPRtM2+vBM7KadC5RyoUGXCCmQw+Ng905jT0wqX1gCG9CnJLu4WIzYdxuqVME+APXWO/j3A
 XS8GeUaFBgPlASlZm6Owhl+hk2p2WvHWzuaihQW270jPY3aELrkS51QPtfOPeLONhfs5a9VcxlP
 ugpr0e2XCdP1PLqg1oiuFgg27xmFOhcdKF0wLWFa/ayZ4cZMagmnvKmuedUww+fTD+QbKlVlkUt
 M/22N4KBpbIOPhu+7mw==
X-Authority-Analysis: v=2.4 cv=HdIkiCE8 c=1 sm=1 tr=0 ts=6a6ab7c3 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=O1Ui7m3IpNT3MPDsLiQA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: E_5EJbZxv_jBehfWvY915pu4LddBJHwC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxNCBTYWx0ZWRfX9Ooh0ski4O9D
 ktQf3cBZEOAMaT/D32D/H2ublO4Vle97GWx1kslRrl/BfTgxskXLDAUxphg8L+YETpCQte84nIp
 4R5dU/JkSmEwvr8qhFd8tqyYqd3hryQ=
X-Proofpoint-GUID: E_5EJbZxv_jBehfWvY915pu4LddBJHwC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300014

When UTF monitor is enabled, ath10k forwards WMI events to nl80211
testmode. Non-UTF events can therefore be delivered to userspace and
confuse FTM tools which expect only UTF responses.

Only forward known UTF event IDs from WMI event namespaces that route
events through ath10k_tm_event_wmi(), and drop other WMI events while UTF
monitor is active. READY events are still handled by the normal WMI
receive path.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00093.2-QCAHLSWMTPL-1

Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/testmode.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index d3bd38569..282ae6e20 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -156,6 +156,14 @@ static void ath10k_tm_event_segmented(struct ath10k *ar, u32 cmd_id, struct sk_b
 	cfg80211_testmode_event(nl_skb, GFP_ATOMIC);
 }
 
+static bool ath10k_tm_is_utf_event(u32 cmd_id)
+{
+	return cmd_id == WMI_10X_PDEV_UTF_EVENTID ||
+	       cmd_id == WMI_10_2_PDEV_UTF_EVENTID ||
+	       cmd_id == WMI_10_4_PDEV_UTF_EVENTID ||
+	       cmd_id == WMI_TLV_PDEV_UTF_EVENTID;
+}
+
 /* Returns true if callee consumes the skb and the skb should be discarded.
  * Returns false if skb is not used. Does not sleep.
  */
@@ -182,6 +190,12 @@ bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id, struct sk_buff *skb)
 	 */
 	consumed = true;
 
+	if (!ath10k_tm_is_utf_event(cmd_id)) {
+		ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
+			   "testmode drop non-utf event cmd_id %u\n", cmd_id);
+		goto out;
+	}
+
 	if (ar->testmode.expected_seq != ATH10K_FTM_SEG_NONE)
 		ath10k_tm_event_segmented(ar, cmd_id, skb);
 	else

base-commit: 913998f903fb1432c0046c33003db38a9e8bedb1
-- 
2.43.0

