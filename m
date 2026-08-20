Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B0F47ACE4
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242084; cv=none; b=l8pcxDu+VWY+am82CwLwKKTuVv18f9/E/p4ugzpLyJ49OcTnF8fnG+ocZCkNOs445EzBZzba3cEcBGVE2wlSQTOztzXhnniZvEkeycliYvzgnKm/T2poJZfyILpP7C/fUuSKYsdyfAkpXeg2VUYiVwp0BxiB7g5YakwWzf0dB+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242084; c=relaxed/simple;
	bh=QTmXE7t5YYEJHVNUVS9mYQQ4MzfwUnCJqrPIyBOL7Tg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hvqwX5/2hkU41ISPD6jWgoyjns1/+3iftxKSfqrf779RsSXG54RjJdFWh1nak1ftMkidxQxDvdmGJTlODk39goZOkJ8WPBtTI1e/jraP7qtKT6v+LeJKtTY3huO6dccfKTcwZAeadOTaK8Tc83wGyfTq1Ra946fKn8vs6QGMqQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PYbmviCI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AeEgThab; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PYbmviCI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AeEgThab"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KG6vQT3734858
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 16:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=FXZt/QKWxm0hY3dV/YZX7l
	C3z2bji2hBWt0On4WvxQ0=; b=PYbmviCIlTe3F6tAqjqqLHLk1Hn5dNG9At7yCP
	8hhgb+dymYEHa7sUieh8EgyhiEfzKlUq08BRteYjM5TEUUL+cqTPhVE8C4YrKaiH
	Hv0dPuImCk0709vqwkrycKK6f6qsTuUKiupAXRHewJ8MpHFZWh9T7Lv6ZVZtISgx
	bY0lXbl0r6x6Yjp6NuWRBjRB9NmT+VOpWe5BDTWT4kYSrPKc7dN63/oYmpuLORRA
	wa4tgYUrMud6mPmZdm+JPW7zFtigNR83J2Jv5FRrns+XZbOxND9QijPtdrtIaU0J
	7qQr9cv8di7GlNSv2Lh3GaXTbdj8R2loS7V2BfTGVWO2fgng==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5yg0hh3x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 16:08:01 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc5faecf01so657245ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 09:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787242081; x=1787846881; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FXZt/QKWxm0hY3dV/YZX7lC3z2bji2hBWt0On4WvxQ0=;
        b=AeEgThab3fY+A1h6x/7arzu1KKAWBv5HR+C9RUifXnWukmRA+fxIPwH577rCHB84av
         gAjKRw6fvEPGVXDoLQXeqRNVi3lUfcdmrBJ4G4/iMY7Sfo5JHteibMIu891Df7N3XInE
         Ne0WsxSm+FjcYJe3kbYDr4Rncf4POL8yxkeiNucojvFQhbS5SJKPpnk2DpgkJijJFreF
         ONVF9Otp6zylkvDfRifnYoYdI/+CL+7+89VvWvg+/9M4GHj/6HA9Qu/9j0FoQjNOVYYo
         eIpUofJJ2jvpCmXrMvv4G9LwcU5ZMXhNdTj/Ad//BS5Pkg1zyQDNE9jhWO8MGDyYaB5b
         MnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787242081; x=1787846881;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FXZt/QKWxm0hY3dV/YZX7lC3z2bji2hBWt0On4WvxQ0=;
        b=UWuFvXScGBzc1BFVskV3klKGv0pR8lvLWlJVAW6A9qN/9X1J5sgZJ4JT3pWm8S+hTe
         fftRlNw9vfbg4Koz3Hmhv+PhcfVnUal8bQhfH5v5nWqH92Ig1v1Ilc/2c6XZy5bIhgAm
         BhUXOSo7rnV/5qBdjoPnN0aFZXZz2QQ0EtIYGM93s44waLn+yj5k3m4Lxam71SxI9JJG
         g3+RClO8bGKDBS4FTs42jMhVGZVqCTpghemlDZ05bn0JkmshCa19tJFpXH+tuB2Wku7u
         +2ljtm+qq4MjfpFFO7BMBxWYhkRIiWpxwlxbp9I+Epgy7IbwP4D8kxc8FDyh98USS9VW
         73AQ==
X-Gm-Message-State: AFuF++lSq8ZuRhIvp93pvchR+KO/t0cPQyC2aOe8IelXFJwe0rHzmo8q
	LPJwW26kuI80q2GPKszgIJMLN+VQQiKi42fXgMEslTPx9MsECKY2NSnf2/XhmqBw2ZnB9RTNobn
	iPny27h+SuKLAGCod6ryeAx0A7jDA6NY0NTAZZLXnLF5ZdGvfhg7xsB+oWvpTUZQaldQVUA==
X-Gm-Gg: AR+sD11ezR3El9mFtFeDMCJnX+jbPnfeI4TEItin/tWmGxWsXB9hQi9vE8C5Fc/rgf7
	W35PKNadh3J9wmQ+cVYcnvMWIhsyVOkh89gtSGBTVjdmKvzpO1/bKrqrJ80D0xjziX9S9XrFj/Q
	gs0FyHhQpxZyeWEg9gYx6m8k52QckdW0Fwm4yNJMXpSozw21h32/+9Ha0yBCZYwJnl5nJYxjLqY
	u8HbLABW/F5R29rKqJExSb1MIaENH2gCKULPSZzWrc2aOOweYjIvhRLo/0Kr5K1X4CZapFSwLRp
	6xJdBf4Osdk3hqHEcE/SmnAYQJ6iibllNNWIEkgbaY4SbPj62rODeCjvPCXxQPHIkaRnNqjxVDS
	yFd0wbT2k3MkaY9l/kq9Q9tSZXL5HgxTTjx9UBUeJCe9ELZ0hLPnOLOTySm3na1C4AlZoVt8SsX
	c9tvMkyw98O7FGMsynS59Mk4V45JREJW0u
X-Received: by 2002:a17:902:d483:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d5fd6fb665mr234148865ad.10.1787242080861;
        Thu, 20 Aug 2026 09:08:00 -0700 (PDT)
X-Received: by 2002:a17:902:d483:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d5fd6fb665mr234146895ad.10.1787242080292;
        Thu, 20 Aug 2026 09:08:00 -0700 (PDT)
Received: from hu-mdharane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf175399sm32005387eec.26.2026.08.20.09.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 09:07:59 -0700 (PDT)
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Date: Thu, 20 Aug 2026 21:37:53 +0530
Subject: [PATCH wireless-next] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAFgmh2oC/22Nyw6CMBBFf4XM2hKmGh6u/A/jgraD1CDVDiCG8
 O8WdKGJm0lu5p5zJ2Dylhj20QSeBsvWtSHgJgJdl+2ZhDUhg0xkmuSYico2LAxmGaZayyxHCNW
 bp8qOq+YID+upIWbR0tjB6f3mXl1Id4tqAWrLnfPPdXbAFftdGFCgSFKtCiyk2ZV0cMzxvS8b7
 a7XOJzVPMhvNv+wMrCyVBpNlW5JFX/YeZ5fHDvaGvwAAAA=
X-Change-ID: 20260817-fils-d17716cc2781
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
X-Mailer: b4 0.16-dev-5ef6c
X-Proofpoint-GUID: eu7bX78TA3Ipp_SQj0MGALMej0gDlXFz
X-Proofpoint-ORIG-GUID: eu7bX78TA3Ipp_SQj0MGALMej0gDlXFz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDEyMSBTYWx0ZWRfX0SMZCwyofmRT
 i5dckDErpctjnWdkKkxtr4IedIzh3AoCUUr1dAKY1dQVjhvRwUTPspPa9RhMCfFPFOTaoChOiJP
 LC9m+sqHoN1f8XfcdzbQNZt/Mw4GlHz+wew79vonxTWTZ5oDOZmQki9m+XwVs1f3LqxhIBQ71lb
 +5Nzxe1GlOvAUd1fCSn/Euj69qk8CLVfkZjDQz3853QQqKX9ZMxqfdahSXu6PQebmwiFYCPKocQ
 Zp/fAJbDVlD8R6jCWgEhK/PlvtcyZrynA7M9vI23zZ+7mSsNpJF4YkrcfG8F10SndJqlX5l42cD
 13H7wKhd6F1ePtldSSPkaLQsI4ChcJlw/nf/mmWUPah+9wJT0jrAaHo47XdYMN08kBKDtSLZtQC
 1ma10Xk8IJAXjoRGzO21NlXRficOZbEIyYpJq3XBo99W/d1S1rk0E5JXXuFDE7oWgrx6v+MEiHf
 xBOqJqMHiEOHe4Bx0WA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDEyMSBTYWx0ZWRfX47/6GtfAUkay
 vA57NMb9cwJTIsFC9/k4OWVDnChKqio0tLdzEuBQUo1lrfNMlrnJqvMlqjF1qAF1qRaNub5zK9Z
 BxAGLDYQokuiiORH+FAyW4BGhU5fQUM=
X-Authority-Analysis: v=2.4 cv=JoXBas4C c=1 sm=1 tr=0 ts=6a872661 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=W1IpCFpPG3alwyutPiQA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-20_01,2026-08-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200121

According to IEEE Std 802.11-2024, subclause 11.45.2.1 FILS Discovery
frame transmission, only a transmitting BSS shall transmit a FILS
Discovery frame. Currently, BSS_CHANGED_FILS_DISCOVERY is set
unconditionally for all the BSSs. Hence, add a check to allow setting
the FILS Discovery flag only for a transmitting BSS.

Similarly, IEEE Std 802.11-2024, subclause 26.17.2.3.2 AP behavior for
fast passive scanning, mentions that unsolicited broadcast probe
response frame shall be transmitted only by a transmitting BSS. Hence,
add a check to allow setting the BSS_CHANGED_UNSOL_BCAST_PROBE_RESP only
for a transmitting BSS.

Signed-off-by: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..8b6e2a400b5a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1138,7 +1138,7 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 	struct fils_discovery_data *new, *old = NULL;
 	struct ieee80211_fils_discovery *fd;
 
-	if (!params->update)
+	if (!params->update || link_conf->nontransmitted)
 		return 0;
 
 	fd = &link_conf->fils_discovery;
@@ -1173,7 +1173,7 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 {
 	struct unsol_bcast_probe_resp_data *new, *old = NULL;
 
-	if (!params->update)
+	if (!params->update || link_conf->nontransmitted)
 		return 0;
 
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260817-fils-d17716cc2781

