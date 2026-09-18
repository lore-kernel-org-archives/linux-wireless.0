Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06738BF6A
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 07:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715858; cv=none; b=laAa7N+3kIOmUNov0o3rakrNYrZdP4t+lqVZsH73ULGnzI6HLP/Nz0uoK5IyGt+XtHEnNVGoQzGODayZJsYOBzzKkuTuB2AeNvdb0rmdPkukiUAgW0EnacweIyafVDCTohpMkroy3R96/EZ8BqGupcqsDDY0wr5LHguUDHMz4jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715858; c=relaxed/simple;
	bh=ucN7nWtXDggJikgu+c3WR8rfCQUY+o6UfVUDnXBkgKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=AaFTleqY2i1ONGSv8x3i5q/cfHVaJ2dfxyx/5KbfflMA1CJdZc8551O1W1gqmRrtVhvbugs9/K/QfULSEfJjRsMOA+Gq+MxDdBOuWpv5C0HzHbTVho2rFcftK/3gbkq1d4gCLDC6Ork972cvcBa91YyrOkNMATy3FLkeOV1Fw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iL0vMmJc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Fv+62s6R; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iL0vMmJc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Fv+62s6R"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I5xxjq2660290
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 07:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=iWkhLqxvxjovXlMy9LL1SW
	rmkCuvrIQADhpI39B3y9w=; b=iL0vMmJcYv30mBXoWEqMHTevlFYnMSgXxY3rxn
	jc4qggLYoe/7yA6MnT63isNf6ATmgVp6RYDQ9A9NHyYAoTYF0MK0zzEnH4yvWQhv
	YDuOLPogNZ/aHuJQG8pw36l6PouRqemsS869ta9TECceMHhOozXe0ft/s4Jm2xcn
	cCjJngwe9XCXiSTR2RxG8BlFsUjThiDSBR+Rxko/o/sQZh+axNvEymjrAIiBPYgr
	sbnoYnGzFwUoybJ19zvTy12cIJ0YPdOKUaxlFHk6iV2ErULqF5vT+z9p6vTfZKyl
	0vrALFdy2r9+R98WaIjAW8AEXSbPe8RfohOolqc6irTHsfmw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grjttun2h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 07:17:35 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so1288556a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 00:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789715855; x=1790320655; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iWkhLqxvxjovXlMy9LL1SWrmkCuvrIQADhpI39B3y9w=;
        b=Fv+62s6RyM2XgFgJA7njBek3RREeyWUBqQNwdSDTeyB9tk47K1SUIbhbY+tOebohFx
         +OoJWXswF8MajyrluVQU1ogvFFwJDTtZmiX3/AjAyRbU6YVLjgbdtpHm/jLIdUo/nIuS
         141lXUuptLf7SbZ6QHF4U0mi5b8C//SpVeSXcQWGAy1xfte/yjSJir3A79gwJqMpD4ii
         69+IBX9SQ+r+1YHEaMmGKHXHxnLJea3kJIbDbcMFz9yapvRE1IaA2M8tuKmpun9BzvmV
         Js2hB4GCDq59FNjM+oHpMC9xKDW6wf6YtPv0orwi5ng77y1QuEgLNqntvUrtduyFb5Bh
         ZqIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789715855; x=1790320655;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iWkhLqxvxjovXlMy9LL1SWrmkCuvrIQADhpI39B3y9w=;
        b=rSN0Lpd1flLS3TTj29TySCxszlC1XnWdyT/2dSWo9YmeYeiwMFFm/FFTbelw3hLcXv
         G+aYa+/gZW09q+L/9qDKbm2XLfuPDL4FImluLJ/eZx5JAM4ia01v66poltE/LggFhrz9
         Klg6pdqOyH1mhOSMRZam4fVGJkA1avGAA7UJB4ZD0Sxf3FQaZhdiJYiEBVxjhLzgR91a
         pT+OklOo8jK6CiGhQLzzxFCqH9DippptJwF9SLPKEYuAaDubYI0zg8w0xqbb/WjQPFFM
         k/81LI4NWTbh4mojx4t+UqEZdvDw2ALP66GA+sMW7Cv9vIraq53PFkg1XCZxG5qI5bOS
         vrig==
X-Gm-Message-State: AFuF++kkLpLG7nWsXdr1VDFEedofPhLiCak25y8/PcLQysoUK/a+W624
	ircujRkwpJWzOQgLNaOmkqx52b8UuznyNzsmX7mPMHNkIDrt1Dc2hJBJem8rufbMjYop36ZCG7k
	gRNAmzlJaCnOz4QuPo6A8tVPVpXgEjlPj8HLzma8DgXJ6ZvjsfuwIsCn6Plbj3pRFp7W/bg==
X-Gm-Gg: AYBFou2KI9Iu+kFvI5txaYwUt4l99VgyVM6k4lnjEJreiG8mDF077nk4vmbIJOeXWyC
	oj+tAnNs0km+8I6drb/h7WVG6vSEOlO3xi30fU5+YeCV+SRRu5Bm/5iLgBIKG4ksZBGkoKWySoM
	OmKq/EZ25wdD7QZmxbqWPCYsHiHctn90YUOfXr1jCwbZ7iiRgWSXuR/r2QK39JR1OfQZjVE5Mor
	it2x4ZLilzo4ThFoT2OY5SEARG7Lz5pBoxiPqrIaialp1R4233DPWL526542YDPmKx53GQGr33W
	8rTh7QVQCF0nsrr7Iwp10ILzljrRoMMmm37oYr8K/Ln6eX07X1ZjcSjkJ+MKBPww+le0CKVYhrh
	G1Qbl61zjwWD6VDBE0DxBC6ZHt1NbIdulRblqCc6XIS7ltXonMql7WskK9GtkH5EJbb+x5fjSZy
	PLi2kiKg91Q3/efgsFMPiKkLyHXqahex9G
X-Received: by 2002:a17:90b:56c5:b0:39d:f247:bab with SMTP id 98e67ed59e1d1-39e54b66f85mr4142473a91.6.1789715854617;
        Fri, 18 Sep 2026 00:17:34 -0700 (PDT)
X-Received: by 2002:a17:90b:56c5:b0:39d:f247:bab with SMTP id 98e67ed59e1d1-39e54b66f85mr4142402a91.6.1789715853932;
        Fri, 18 Sep 2026 00:17:33 -0700 (PDT)
Received: from hu-mdharane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c286d9654sm2451874eec.8.2026.09.18.00.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 00:17:33 -0700 (PDT)
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 12:47:28 +0530
Subject: [PATCH wireless-next v2] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-fils-v2-1-44e41f714f18@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAIflrGoC/23OwQ7CIAwG4FcxnMXQqmzz5HsYDwOKYuamdE6N2
 bvLpgeNXpo05ft/HoIpBmKxmjxEpC5waOq04HQi7L6sdySDS7tAhVrlkEkfKpYOsgy0tZjlINL
 TUyQfbmPMRlxDpIqYZU23VmxfZ76YA9l2iBrAPnDbxPtY28HIvhs6kCCVtqaAAt2ipHXDPDtfy
 so2x+MsjSHmZVB9mKV2flEovzRG/5rhNx1+9uVvi8liaSw4r+dkij+27/snyOAfKzABAAA=
X-Change-ID: 20260817-fils-d17716cc2781
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
X-Mailer: b4 0.16-dev-5ef6c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDA5NyBTYWx0ZWRfX66y3Etox9x4w
 I/o9rhXZsWtsqXnV2qVRI1jwB6HGv3BcrmCJE2jKQlvV4JrzxABAkvGKZKAaEMO0ImvDCNyNuBk
 Yr+MYhmT6B3OMb4Kvk/fCxaTIyZTob7XEox1a6+t0tArCImIGGHmvFScajrOgLYDx9FdwIbt0i6
 XrLWY4k7/DauP3Qsjtbbw87Z2OtJsTuRTiQVpUmaf8FTZKsmACxypzsY6sFazhf/dNoLKb1tir3
 3kNEwvliO/EFjafxpm0YQbxofpHpRFWPpvMyqqXCxAXZbjKwMSm4lgPaUpe0T4ORf/v788q6/bf
 KpTSbiNuR2PtcCBj3ffYAzAfJ3PdTR2It3yg6XK+TlmCZb3tTlOlWm4nxdY4ZyP9//556W1EBEw
 Exa1hzwIev5Oaf8p/B1Fk6T8ZidD60TofizeJbcq0wgUqtjG3cRA1vA2Lq4ep7W1syHUUT5pSpL
 0fwLNCO+LUzaWvnVqog==
X-Proofpoint-ORIG-GUID: MOU0QMSBYGKkE8MkLMvUq8df-lveQ-Sr
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDA5NyBTYWx0ZWRfX0V4Bs3Plzy78
 AMGIikzZT6HaMcTSv7faSSY2LTWhUCXMGJ7MGTzgNIbo9NKlOkhs96dQRMjdi50f3rKuOFtSNX8
 ZvQIDsFjgprWy4HS3nleSjDBh87Z5PI=
X-Authority-Analysis: v=2.4 cv=IP2XmQvG c=1 sm=1 tr=0 ts=6aace58f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=sX1xATwjLoGU3SUDqV8A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: MOU0QMSBYGKkE8MkLMvUq8df-lveQ-Sr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180097

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
However the driver will use the config only for transmitting BSS and
ignore for non-transmitting BSS. Returning an error here, even if
user-space sets these, could be fatal because failing start_ap or
update_ap operation would result in failure of bringing up those BSSs.
Thus, ignore the config for non-transmitting BSS silently.

Signed-off-by: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
---
Changes in v2:
- Updated commit message to mention why the config is silently ignored,
  instead of error. Also added code comments to mention the same.
- Link to v1: https://patch.msgid.link/20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com
---
 net/mac80211/cfg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..df9b84b3b30d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1138,7 +1138,12 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 	struct fils_discovery_data *new, *old = NULL;
 	struct ieee80211_fils_discovery *fd;
 
-	if (!params->update)
+	/*
+	 * Only transmitting BSS should set this config, ignore this config for
+	 * non-transmitting BSS silently even if user-space sets it, as
+	 * returning error would result in failure of bringing up of those BSSs.
+	 */
+	if (!params->update || link_conf->nontransmitted)
 		return 0;
 
 	fd = &link_conf->fils_discovery;
@@ -1173,7 +1178,12 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 {
 	struct unsol_bcast_probe_resp_data *new, *old = NULL;
 
-	if (!params->update)
+	/*
+	 * Only transmitting BSS should set this config, ignore this config for
+	 * non-transmitting BSS silently even if user-space sets it, as
+	 * returning error would result in failure of bringing up of those BSSs.
+	 */
+	if (!params->update || link_conf->nontransmitted)
 		return 0;
 
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260817-fils-d17716cc2781

