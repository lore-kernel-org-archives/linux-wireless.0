Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761D3AE198
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642868; cv=none; b=HIHIB3QTQiVz+takMHzhqkKHBdjGA11Fre8N6l1rAWS2/Pz0jF8QnFJZRNVmrvKB0rY00nrkguasW4sFS6BcZUnY5E4am7yncMQxpxt0iD8K0/h3QT74FjB+RpwikIj/udYMH3oCMSOiAdeN4DHoJJn1H08hMwMTbgls+scj75A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642868; c=relaxed/simple;
	bh=ERB3Ht3KQ7PJfL69qf4To3ZximdNxC6SNofrFvNxe0U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sLHpZIs+JjeQ1EyOk0vqHt+mXUCDhk8+Q6/p9PpzUuL2EV28dLZtroldeBzRvNR8SP/sb3cjL40yQmDbxxYpji4RABZbi/srJC2d3g8NDgwiTJU7WhxcvasASuJZmDLoPKnCTa3WCLvBL4R/TQqQJzA8ccum/90GbDMXcbOH+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ESXHz0IT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z7et89Bl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ESXHz0IT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z7et89Bl"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DH8EW03052436
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=JLpr7daqz7OTT67FQV80/z
	+XbfGvlShMvH/5gavUb5M=; b=ESXHz0ITk82PMgKwDSgDOl7y9fDfTGO8NghIae
	/fNEOTWzqqHaVe5bYu2ftaUKyARIYDdVIpBdpdHqaSfq8ZlM0DXeke1uqNDwK5fw
	vQ9R7wgvfE/b8W4vdlyJW4lVb2HwgKGJdaJ0zGdwSja73NomEhabEZLnoe1W6I83
	SbFdNMvkYswc8fRUtz+F7XwCbQp+4zyx15qCaht4FWsk35i0w8LOQZXQRDmdTDDt
	Pqkj44Nkb/Qm/nfGEYPtGElM7CU9eBobuc7r2HdLr8jP3+B5MF+zxha7r1yXp4oo
	IeApzNgQd8FstirbTO3w16oTLiSHc33p95E8nFn2aI8iAPsw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g1j2f04vd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:41:06 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso58144a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 10:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786642866; x=1787247666; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JLpr7daqz7OTT67FQV80/z+XbfGvlShMvH/5gavUb5M=;
        b=Z7et89Bls50T96oL0/05IamVPG/jz4quT+Hcd9pNhTRndJsCNtqV5YfORf5Vx06wPU
         q7sgBlC31cseOmvjhMxHbQLiKw7zPgMAUr6DmvhNFMTMmxZSsgViaD1MVTorrvK5jPsc
         zvJx8zmFeLms40qQhJdC+xfcrQF3Kgimj0XyNLvFte0qk9WAixnaxVn27XEZ1WUcQiR/
         D4zzznej1eI8cBsDdFBtJoNKg1CziRtH2JYEdEZWPheOqANuAx+3dU8UC5U+YGh9/Qi8
         wT5qPS1bgGmfxQ4WDSiK97i/OkdrW+rxuCZqub5MKnaDT9gFFFZxRMe+ThQ9b0IfJqBC
         9ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786642866; x=1787247666;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JLpr7daqz7OTT67FQV80/z+XbfGvlShMvH/5gavUb5M=;
        b=b0M+yAsZTDQv9Bt5GJdzX09TJir9CV4l5cQDSKjYY/R1zJZOdCQ/PRjBq8fcmjQ4Hg
         KFV8p7gNN8+TMZ0JTWuDDblVxdeT8tpwFzQLlHXDuAztc3pqkULJHtqkFaBdx9mc3HMx
         JwBd/5u6hzywB1JAaPj77KZO+BFpIO3fcwJ0NDDTsifwkUOxUMjv8hhFyyZNo38Z3l5Y
         sfUHsgWsGV7EH6Ug8285oE7tDtavP3bZVJDatGKBTnp/Ssv8HB9G//hoNlVFzy/hPh+E
         H42w59omwdrXdd/Sgu5kRE6ToWRzNYQXfn4AfG3KJrnl/F3kx4aRhYOGOpSoNxdWqRrf
         9hJg==
X-Forwarded-Encrypted: i=1; AHgh+RrIOvQiize48DLyQoC/fATLX+DeDWQ9F9aZCSCJ4hVMlYO/xAfMv/tuGAifSR97ExKvAWJm0EnDLtyCEtKqaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkQfAy/OBB0MPuTBKzCTcFjZ+/h1oqKQLUt145AW+/OsJWn1Ze
	QjDzrTZ2yIh8JwjLtXi7iz+buMU4TKNvY6MA3u+QJAA0rG0+1ocskYph8hehbmsDngDlE90mXAq
	nGsf15ddn53QouATK/JLy1UazOuZcdMjEnH5KMuBlNDx2yq+fk1bfftggb4NLI5hheJ7FBw==
X-Gm-Gg: AR+sD112lI/KFEBpMahaA/pXMZYiKokkPBZlhRHtFF4J4yCb8pk0S0ZIxQ7LuivNu94
	2pz6ZwrnJZZQX6/i0ciaXVoe6qh5MGPu4QYkg/TSvdgCJ4Gde0X93kVPFE2w7QPcUWh0by/bn+G
	PGLXOd9uKH9Oxi6Ky6MDOYZ7yvDIMYaJACMVymIGAJUer1UQmgJUAx/xKQ4pSb7tqtajkNlepwg
	w/G5kTobaOHyi3jj3346zfn3ZGWws6y/qrIrbtIPaLbTy+TCTnfvJdnspqMNuqns5TPHXBD9BlF
	yoNRqSJG2XIUmhs5JcgMCqoypk/8qScAhOTYcf+UCO1buGQPC5Xnp8GUu/56D7iSTzgMnP/1K8+
	jx6sA/n1p8bNVD9Dl78YIELOco3lu/1dNt9PiVV6Vc0mbvkx5L4dVsVA=
X-Received: by 2002:a05:6a21:3282:b0:3c3:b57b:6459 with SMTP id adf61e73a8af0-3cc54f3e1demr9186874637.7.1786642865592;
        Thu, 13 Aug 2026 10:41:05 -0700 (PDT)
X-Received: by 2002:a05:6a21:3282:b0:3c3:b57b:6459 with SMTP id adf61e73a8af0-3cc54f3e1demr9186802637.7.1786642865089;
        Thu, 13 Aug 2026 10:41:05 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebf732166sm16244436eec.18.2026.08.13.10.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 10:41:04 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Thu, 13 Aug 2026 10:41:02 -0700
Subject: [PATCH ath-next] wifi: ath9k: use rcu_dereference_bh() for
 sta->rates in ath_merge_ratetbl()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260813-ath9k-rcu-fix-v1-1-424665a1ce60@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAK4BfmoC/x2MSwqAMAwFryJZG6ifFutVxEXR1AahSqsiiHc3u
 JzHvHkgU2LK0BcPJLo48xYFqrKAKbi4EPIsDLWqjeqqBt0R7IppOtHzjbo11rVGNX7WIJ89kcx
 /bwBRMdJ9wPi+H3vKONNpAAAA
X-Change-ID: 20260813-ath9k-rcu-fix-5469a4603fd5
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        pengdonglin <pengdonglin@xiaomi.com>
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=FeMHAp+6 c=1 sm=1 tr=0 ts=6a7e01b2 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=6wmsvPg6niT-l0PZxM0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: eFf7g9QB7cC4y0KxA67yedRDsMZVqGdy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDEyNyBTYWx0ZWRfX1AR4s48g7UsJ
 hMDnXoix1jrZi23wq/TR+wQjeH9soodhaZ1755e6XupX1cQAJIpf6nL0IEIdkaLsAq8WRghahDm
 ubnHDLXF6smqhejiPegA+cDW0swoA7B3oFK7ycH0CjThxFERueExPejRf7sYaDo9d1RJpM20Qb/
 z9d7L9Wv5e1NLPkyKaHxQV39dJTuN56hWEOI2tlTko9WFZBmlmHES7p583YTvLn8fCXA0WjIF9p
 xiyvgh12ftbFQidZkJNxk3jRo+DS2KQmHQ/29gbcSbhKUSPEjKvf9DYt93pvlmFYbCIRqiWDf3X
 IGoxMQVFIJ4V9q6X7EqIGjCeRf1O9A+3JVU6JMGLkCRp1bexGT/Q4gMC6cUol93e/lmEo//OpmW
 3999hn9Mfdte+5h+U83772ZbsOzzlsQCsujjVjwNjSEpPprkCOl029b/hyb4u2qtFybdG197LUo
 QunYKHFXwmFwCqBJDJA==
X-Proofpoint-ORIG-GUID: eFf7g9QB7cC4y0KxA67yedRDsMZVqGdy
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDEyNyBTYWx0ZWRfXzuTWRA9rSTo7
 UoaLrtaxu/yJsJSMyqPEnWcDngxsXiJ3A2TClOhkGI3a1L2Hcc7AF2dJpZuUOAQ0gLsXsh33EAm
 4KaZ0ushdz/Goj8RyiGcyWBTCwBb9NE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130127

Commit c4f518736472 ("wifi: ath9k: Remove redundant rcu_read_lock/unlock()
in spin_lock") removed the explicit rcu_read_lock()/rcu_read_unlock() pair
from ath_txq_schedule(), relying on spin_lock_bh() to provide an implicit
RCU read-side critical section.

That is correct on kernels without CONFIG_DEBUG_LOCK_ALLOC, where
rcu_read_lock_any_held() falls back to !preemptible() as a proxy, and
spin_lock_bh() disables preemption.

However, rcu_dereference() in ath_merge_ratetbl() checks
rcu_read_lock_held(), which under CONFIG_DEBUG_LOCK_ALLOC only returns
true when lock_is_held(&rcu_lock_map) — set exclusively by an explicit
rcu_read_lock().  A spin_lock_bh() does not set rcu_lock_map, so on a
CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU kernel, any call path that
reaches ath_merge_ratetbl() with a non-NULL sta will produce a lockdep
splat.

The correct fix is to use rcu_dereference_bh(), whose validity check
calls rcu_read_lock_bh_held(), which returns true whenever BH is disabled
(in_softirq() || irqs_disabled()).  This matches the actual protection
at all callers of ath_set_rates() that pass a non-NULL sta: they all hold
a spin_lock_bh() (either sc->chan_lock or txq->axq_lock).

Fixes: c4f518736472 ("wifi: ath9k: Remove redundant rcu_read_lock/unlock() in spin_lock")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 89d8b3178784..3413bb4906d4 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -168,7 +168,7 @@ static bool ath_merge_ratetbl(struct ieee80211_sta *sta, struct ath_buf *bf,
 	if (!sta)
 		return false;
 
-	ratetbl = rcu_dereference(sta->rates);
+	ratetbl = rcu_dereference_bh(sta->rates);
 	if (!ratetbl)
 		return false;
 

---
base-commit: e07447e654476262558bee570f4cf456e2b32565
change-id: 20260813-ath9k-rcu-fix-5469a4603fd5

