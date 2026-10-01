Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DB14F5DE1
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846035; cv=none; b=EX5rD5kbw/7GfJMeWsYcVXo8amfanKV9UCSkxWnmYkPthTHPuVFr4qRxxiTKnvgEGG9l1W/VUvV2leI57hY6AvCZwY0ubEQt9PaaFDv4Lj+X9oNgY+b9qKr/hNPqQyZhFLLF8yFFAyAFn4tk75x3xocqWi+Gegb5UodyJHkKqis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846035; c=relaxed/simple;
	bh=eppgexe6cQRaVSUc/LRRsqHD+y8q/knFMiTV2F4uLcQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=c7Ib1FWC1gksInncAehrBbzvy1lBUHcWaGgCouy2Vf38h2Uwk9ZtHH64h1BXZgYssB1hOpFcul4sszolRgPBS0ka7Pul5IjHU7Kfa/l/FF4Q7HCgNmLMu+KN6g1kdAjmd0UGKK4Iz/IfWci3zvB3rNPa2Jf2YQLXSm3UZ5CxNWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RryxN585; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=caquMgR7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RryxN585";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="caquMgR7"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6916xPYo2806285
	for <linux-wireless@vger.kernel.org>; Thu, 1 Oct 2026 09:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=XOFKMvOewvgJINNEKpQtKr
	YF70XUZuosc2RHyGToySY=; b=RryxN585c2kZ0j6SXYjtbRpiQELu/2r0pOhSHg
	Qr1NjQI9DsFJ7dCLMDCBMXXkiJBJ6UNSG1t0RdBUV45whNiprZ0gk6/X9k/bW8Dy
	IC7aZxy23AZ4MB9rwhSAyZdtthWzV+4BfOMtDEPMmRx5OtmG4Pgy2Zz8VUh0YRwu
	MOva/maUp3x8Elyn10TTQM3UqlhAKzE9daL2WfQnS+Lh8UWon6I8AD6gjLbYgDJ8
	kK8EcUQjbLqFwNAhn6qJ40eHIKQYb7x1nbfiZhv/hVLeLG3LAW19WuVwjoaW2dV8
	lWVupgbxtzS1PsZuxBRal9BJQM4uq9v9e67S7DJdq3iwuiGw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h1hvkgrxc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 09:13:51 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-34bbf2e3c5cso4530482eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 02:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790846031; x=1791450831; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XOFKMvOewvgJINNEKpQtKrYF70XUZuosc2RHyGToySY=;
        b=caquMgR7fb3nCi4T1/bs+RtcMbiItn0/mk0hm5YNXdn2cxRzCQXJSZfQRGsZi3WhoM
         3uvD6Ql3ieSinQMHVgX3mJmoMdpAOeQ9e6TLsq5cW8YIWRtJfkl4bWpC0lJDf4T7iMtY
         ftSUOE5v5xUUkFG38Gif427gGuCXWzVaQkm1ebZAdrj1utMzODfGoEVkSHdfXP6r6U7f
         1y/EF2tKT53Q5a0Oy8g4gEGN4viNOTCGjVVT4mKyIDYKHERMzJEhVstfdhQe7ywxo+E9
         tRAvd755ITkdPn10bfe2dFCGwhNIBsHg6qGKq8uVPbsjEtY2N6DfMh0Lk0LbRnmGmutV
         AmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790846031; x=1791450831;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XOFKMvOewvgJINNEKpQtKrYF70XUZuosc2RHyGToySY=;
        b=hqKR3XGS6CmrQbwvkatZRLktXs3R9Ryi3DQYlBd6j0KteZci3CCMdnSYFlYIhCqBaE
         sBSCYgtYSSV0Zps316btGq4Ieta5BgMlxUQwrjyCyzetwFqNnROGUxX+08RedbjQPzgc
         xp8DmAyuuhIIziFm+P2Yy77cgyryE2zqdlyRC5s47RKlb5KX9xKfSsN/iUX3uu5dbNn3
         qzeS3wrZ7in9MZljNu+77IWEtpaSOhmAXdmR9trmIcypzblRlD63EVpfR2uZWF/7TrVI
         RYDRNRBih2Hla+p48fIXSMPutFohjy46u+uvUUcoVUTygM6FTTCthmcWgh6UjXIRLPql
         HLiw==
X-Gm-Message-State: AFuF++n/Jtwa0NA4sKqANKflxbYgRX0dv4568rmSAHKpogzvXM5LOXN+
	1ipOD3c1NLzUbwOdg42C/j6vK3KCjkdO7sMwHKO+XKO1Uf9DQLuxpRuSh2RVTTUre6EnO26HJ5e
	u0iLAWdsGIaXedJvDCXXZa9J5p5hONeN+haA5hQfA8Ta3xj0X4Sdq3g/Cfrd+1S5cHusd3Q==
X-Gm-Gg: AYBFou24WKXFC6AKwj/Yx3uEGHoYUh7QYTqeidJwnmiKW4CsUJIpdtuC1tUbzdlsshU
	mtQZRLADf/4VSJwWbKiOPwMhMPjNLLUEGPKKQ7AuAZsUo+yfWUmhYwyyuY8hMgHXQ+Ul04jcZp5
	Gu+uHput2lzwYj3A/j3pI/BSKOBmgJuMMHpdGc7OPStwAZO9nc2+Xad8hoscfuKSPyNIBAn+upe
	S05P9IiEIJFqHXhNP3GA8ZEvnnbMVWFjxdbYeRPvl1MKEDkh7zR2KLs+3QkE9SkmyDoa0Pp3KRN
	4G7f+JuJi77p9YMtI9wEVZAStuDr/HNL6NzapfH+KR84S2D4z+74nkszzXS2/pZJCWdQDAuB5g3
	ZbRL3n+xVWeqMvdHD5CmxGG4am4nddO948yCZzcWMCvAton20NW0tkl65zafA5TdNIRlSfmVhcL
	K5nFV+6uzU6DeqeXJTxgSxvncrYlaCcH+l
X-Received: by 2002:a05:7300:ae81:b0:342:94b:aa28 with SMTP id 5a478bee46e88-34ce0839716mr4765103eec.27.1790846030888;
        Thu, 01 Oct 2026 02:13:50 -0700 (PDT)
X-Received: by 2002:a05:7300:ae81:b0:342:94b:aa28 with SMTP id 5a478bee46e88-34ce0839716mr4765071eec.27.1790846030196;
        Thu, 01 Oct 2026 02:13:50 -0700 (PDT)
Received: from hu-mdharane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db5016caasm5717534eec.30.2026.10.01.02.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 02:13:49 -0700 (PDT)
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Date: Thu, 01 Oct 2026 14:43:45 +0530
Subject: [PATCH wireless-next v3] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-fils-v3-1-55c5628f9d1d@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAEgkvmoC/3WOQW7CMBBFr4K8rpHHGDtm1XsgFrE9BlchoZ4QQ
 Ch3rxO6ANFuRvqaef/NnRHmhMQ2izvLOCRKXVvC6mPB/KFu98hTKJlJIbWowPCYGuIBjAHtvTQ
 VsHJ6yhjTda7ZskvK2CARb/Has91jTWf3hb6fqibgkKjv8m3WDjBjr4YBOHChvbNgZVA1fnZEy
 +9z3fjueFyWMdU8GCmemLUOUVkR187pd2b6ZpDPvuqXlYWVtfMQol6hs//77AujFCqIBlSE6g/
 fOI4/c133I2QBAAA=
X-Change-ID: 20260817-fils-d17716cc2781
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
X-Mailer: b4 0.16-dev-5ef6c
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNiBTYWx0ZWRfX+PQ80WjPqkJc
 XL+EN8z8bTiOA3+Zr6sHosICjyGeNd+CpI1GxtN64j79dRrpyrQpU2xpFPdtA5EOGcSctgnagyw
 7QXubYoixuHof4H8TbbM5qhOw0wFJQA=
X-Proofpoint-ORIG-GUID: jE7UjKnushCvZcEtJ1XWuHF5ZBw9QSgc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNiBTYWx0ZWRfX65BaIFDsOLZe
 TnJ1IvbpJcbhy6PSM1JzBwZYhHD3KFX51dgv/LwD3A2nkyYhL+RhwcSjMSNJlh3rcWaNL4Xec1i
 E3xhiy0xyCMY2owQzb6ryFxp3HrxkupcUrmoio+SpQkEPblwSzyjEmGBqnHQx4aDqRhxtqIKJfG
 4JQhHggH5Aj60ZL2WtM0kOYk8stCHrRPZinP3+Gj4BsKB9mDfI/X8kRP/A/klaQu5E6EQSZHnZ/
 cRe3ijt0IOu4xBL4LeHLueT2DHYD+DOuEbIk6Hd75YSAGds5WylwwuJhD5urXt6nZEO9RNvQnfj
 oNpxAL9MIeLdK9gUtX4PEi8OdMehY290bjSFR+DjBNrPdHTetIbf+vScM/SNISO9mZtlDRnvc3K
 cmxoorDMy8DZYNRbQSKFt94FdFABHgt6HSR5x53cSq68dvHoSiD3yAgmsSFMNnCl5JcOYRIKn23
 LupKmhlK14Sr58dTNUQ==
X-Authority-Analysis: v=2.4 cv=IY8Symqa c=1 sm=1 tr=0 ts=6abe244f cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=j3Oc6Xy6ULSXj8zZAogA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: jE7UjKnushCvZcEtJ1XWuHF5ZBw9QSgc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010036

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

Currently in user-space there is no restriction on sending this for
non-transmitting BSS, thus it may send these for those BSSs as well.
While this is not a valid configuration, returning an error here could
be fatal because failing 'start_ap' or 'update_ap' operation would result
in failure of bringing up those BSSs. Thus, to maintain the compatibility
with existing user-space, ignore the config for non-transmitting BSS silently.

Signed-off-by: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
---
Changes in v3:
- Modified comments based on the feedback from Johannes

Changes in v2:
- Updated commit message to mention why the config is silently ignored,
  instead of error. Also added code comments to mention the same.
- Link to v1: https://patch.msgid.link/20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com
---
 net/mac80211/cfg.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..6fa2a0d4b8b2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1138,7 +1138,15 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 	struct fils_discovery_data *new, *old = NULL;
 	struct ieee80211_fils_discovery *fd;
 
-	if (!params->update)
+	/*
+	 * This configuration is only applicable to transmitting BSSes.
+	 *
+	 * Current user-space version may also set this for non-transmitting
+	 * BSSes. While this is not a valid configuration, to maintain the
+	 * compatibility with the existing user-space ignore the configuration
+	 * for non-transmitting BSS silently.
+	 */
+	if (!params->update || link_conf->nontransmitted)
 		return 0;
 
 	fd = &link_conf->fils_discovery;
@@ -1173,7 +1181,15 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 {
 	struct unsol_bcast_probe_resp_data *new, *old = NULL;
 
-	if (!params->update)
+	/*
+	 * This configuration is only applicable to transmitting BSSes.
+	 *
+	 * Current user-space version may also set this for non-transmitting
+	 * BSSes. While this is not a valid configuration, to maintain the
+	 * compatibility with the existing user-space ignore the configuration
+	 * for non-transmitting BSS silently.
+	 */
+	if (!params->update || link_conf->nontransmitted)
 		return 0;
 
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260817-fils-d17716cc2781

