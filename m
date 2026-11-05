Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907636;
	b=C2QrGQJgBdk/YwZdccl/W1cBJURmLEP0R7eKs9XZ+6gqqx5VU/c1kQhbvOFVjMY5nL8b
	 ei10IBZvabXYIXKG1jlvE2nm61G0c6L8DuRtM1oRJA+eW8FeVoTkGZqikhIZ3TXd1Lw3n
	 Sbb4D3KuOVlrQV8GJuMw6uz6GRX+ApQpBBqo4/wUd8IAXkboHUkN4t/an/xYOOv77LcdK
	 8IAltfqcVb7Ghu015CjTuj0/dZMjZ1cOnWxLZ7m6jPuNokmngh9CH7ymIl74cSgnGBFnb
	 KJoNRWm29oku6HIiFVhZIbRbNZbmADKsqIyxXAQR/ANMycyVa0e7s5feHk2kFXsk+WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907636;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=;
	b=w4pvUUavBfX568z3N0zctIPqwuQdn2H/Mn3qSj1UE60ety5WkwEYMkykOjnAO2XPBsba
	 w+7+KoBy6zlobiMUFBJPJmRXl1oIg6qKxxwOIdhch+5932NL45qQkS0xfk5WlTIEBDaYT
	 nGxfWHwzvJFkpdkgJYq3aB2W4its1p7vNpxOM9YDn6DgUN41Ww40KNmCNmAJfnJpBT4H7
	 kK61Pxi53har0dBgcko7ntCNA4UhiLgnbZqmI37AVR0DnCyJrBHyGiURv5FfxZAxYEkLy
	 tcWvPeqLsgntONH6mEsjLI86ElYs3BmIArrZTbs2oVB9DhldNy1a+HjZ0jEdQXE9MWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="Q/Fr7YCp";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WTmgMYxr;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB7B60A6F7B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EB7B60A6F7B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q/Fr7YCp;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WTmgMYxr
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeDIv1474575
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=; b=Q/Fr7YCpD7X0ijzM
	dUYfnI4QEbXAGvqs4K67SZHoZ7YrCRV98kcBl6Bd7iytE8PMmyyi/aPPaFv4SNzZ
	z7tPRlO8t37beNrD0H5U3o108epzHLve3dLPQDtX1NUY3AKWvy4SCztL8r2gd6bk
	xwhH1ej4TZIz7/hOHrlhiPP6onEAjsmZmzKfiTS/TQ6Nw9kD8hKnFU/c7l7XPckR
	utSWuc1xNhV2dqBdQxNzfe5AVcH5hqtxYRi5PqlxDSL3ptpuHxeONh89ls2Vke1x
	Jii3imy9EML3n/u68ja328gnZDCWZRMTgdb4kGnNY6E/YJzWurvZr4cabBn4Q13W
	c3JFCg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrmcdbfht-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:35 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so4315986eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907634; x=1794512434; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=;
        b=WTmgMYxrOidHKG34Q/gFrM6G3y10sVBcoedMq4YlAinhCdj9mu5jcCTxNWgepyNh9y
         jUuoDSiO1L1AaZBsD3iSM5FlP+2qg9XJGrapARZqdAMlViVP6XiWvSRQKoP8Bydk32aR
         VRaKrX1TvgSPAaksAO6uEgq+FCyP9figJQZPG7DXNuvLPsL3w8G2Qal5nCnFFs7B6ZsE
         6Irhz+RZ4Fv2LSGAQexLk0Ql7+K5cikfwKnoMIVYwJ1XshJRZnCXqq0wm3smwBrEeQqu
         aC0t2w1agSPK8vevpsFFgEHMtp5qszfxHSXikIh/mffWknuW4QIM53xZHyldtP8W2Ovv
         OD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907634; x=1794512434;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=;
        b=sUVwh/+Kv+js9SUgh9FvJZDJeEBoW3DjgtkEpS19q7gg0GN3bcbMMsFEf3t/umgPQD
         Mhc26SkyADMVJsR3C51jNraxliOL2OBm2Gj4U2MHeCc+kHCo6Ad7+Sfuz9sYAtpS5EKa
         IJfgQA/VNznlVgY5VBdTVL2Nic5lTA6HpcIDAIX6S84aNCzxIFBAcEGXoMulkxrJknnQ
         cbxdExl0Sr/Iee6BJvOMGJ3wyS5xu8nGdFvnx8iUYpfeSIBHiysY46M6yYqwPtQpfolJ
         n++HZ85C0Vy7+nxznZ7ZvaexEzIpXV32V5Xt1ho00THaFY2kUThG2D7iaU/ET1eNf87K
         scQQ==
X-Gm-Message-State: APuU4Z/KSgVj0+SDI9ha1POtDYyHZ8Cyq5SDYN2go9esK//xlOJvRnxx
	+Z4KmC8QJICma/qKlD4k7832yk/njy34GF3QUtdj/eh7HXfX9mF7xjr+e86hyTbm6NJ8GFNeev8
	NT9eQMHuiYAqJNxso7ztcmBhduNLpmDMoiTlLv0IeAVSeY23YLh0ecw1c3qEq3USmH28M
X-Gm-Gg: AYBFou0kuQzKEnH4BF2jQJ+2PZPVizxu3oNY+yEmCfC4DMRVQ0ZAyztlBgBXLsopCOS
	Ka6i6dAN7BP/iLjGIsOKSQSZqDfvULLN1zjygtgBGwefqjZukd8krgtXsw1J8qCxTg9LGTPnOQ9
	yM3LjkLy3z/FG8+jiuCLOYicLh53XOexlTaSrkWqTg4pKLJrLW3y8aR9PIGMgadszCyzDorJGiY
	h2lBFmgOpIYhmWDah/pwBDZBJGUSkOqZjSr5dqE0LhWwkzzR4V/O8m++4n8C6MbW41YprJoSOVf
	lgARBL7KD/bVadmqF6o1Q+7b8VunPqoZhhi2y5BA89jzxYDo1UEy/9LW5D+0m2OvG/jYhb68OWS
	lGU691aQq1MOUTT2KkOVEiVo3yuEWWT91X9cGvo9AWj57anzw9rNxy1dbHA7FtAMrG9JKxxn1SK
	IUYDEfZFy/EbuwCj7z/vdOMopsOS4T/U/mIXUFpEy6nBA5KulfQC4lOz42vF/ENyMbrCSeNg==
X-Received: by 2002:a05:7300:dd05:b0:36a:1f:9b74 with SMTP id 5a478bee46e88-36f75b30488mr214193eec.27.1793907634189;
        Thu, 05 Nov 2026 11:40:34 -0800 (PST)
X-Received: by 2002:a05:7300:dd05:b0:36a:1f:9b74 with SMTP id 5a478bee46e88-36f75b30488mr214157eec.27.1793907633520;
        Thu, 05 Nov 2026 11:40:33 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:33 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:42 +0530
Subject: [PATCH wireless-next v3 07/21] wifi: ieee80211: define API to
 check if frame is class 3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-smd-v3-7-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=EOGTQFZC c=1 sm=1 tr=0 ts=6aecdbb3 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=e1lpAkfDEvgZfVEreGkA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: m2X5UiqXP5o1Tc-KQVAuALQz-qjkZuLX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX0mTX9nDBlguX
 PLxbGnI88NcFxcCRMmJ73LQ02b48Ygj9HqnlViHp5JL+lkVdfu2S9A1IAvqKEi7AFf6wUCUESJi
 TGiM1wp6WsSGooekvdP45Xk1SnCgGZY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX6TrOaLMkGdlB
 LWsQX9ZrfnxNSIBe9AOp2yodu4gvJGhEwg7omTtzb48HYtfxXVDbX3Jy2i5ftcvX60L3RJxvoWZ
 VkCkTs7dsQQ0BWM8yeURBpf3rG5MXxdxd4pnZj+jzOgzjTQKcPaiMBJkNPGlB6Lvkp4SVshMRlp
 2JCnAeHTheUhiENODCISZzg/SL3x7Bn/TaWManbki/m3P2i9huUKb93zvKo5UlG3NZosGCjfiC/
 x3meF9bvWN9+EHUPLmIxhHgGg+uS74FyUeG46vcp82wAgDMYCmZXX3JWb8IYFmEl32Hmj7ep4HR
 eIXBfkLp8pgobdczV3dFB7fZ1viYmyUBwpMlYpEszYOMR1HxEeQch38ATsbr29mlr6/lUC5wQZE
 cbujB636CnjY0f6Tf+AyNkEPJ0OTeeQr3go0j8SbQB6f2RjPxawiSBn3gUZdlXd333nlQV3USqa
 uQg3/o8s53RgeBKQq1Q==
X-Proofpoint-ORIG-GUID: m2X5UiqXP5o1Tc-KQVAuALQz-qjkZuLX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050078

IEEE Std 802.11-2024, subclause 11.3.3, classifies a list of frames as
class 3 and these frames are expected only if the STAs are at least
authenticated and associated. Define an API to check if a frame is class
3 according to these conditions. This can be used to filter frames in
both TX and RX. The API simply classifies the listed frames as class 3
and does not check if the STAs are in expected states.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b2c90c4b262d..3754401f3435 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2940,4 +2940,47 @@ struct ieee80211_cip_cap {
 	u8 v;
 } __packed;
 
+/**
+ * ieee80211_is_class3 - check if this frame @skb is a class 3 frame
+ * @skb: frame to check
+ *
+ * This function checks the frame class simply based on the list defined in
+ * IEEE Std 802.11-2024, subclause 11.3.3. It does not verify whether the frame
+ * is unicast or related STA states.
+ *
+ * Return: %true if it is class3, %false otherwise
+ */
+static inline bool ieee80211_is_class3(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	__le16 fc = mgmt->frame_control;
+	u8 category;
+
+	/* Data frames */
+	if (ieee80211_is_data(fc))
+		return true;
+
+	/* Management frames */
+	if (ieee80211_is_action(fc)) {
+		if (ieee80211_has_protected(fc))
+			return true;
+
+		if (skb->len < IEEE80211_MIN_ACTION_SIZE(category))
+			return false;
+		category = mgmt->u.action.category;
+
+		if (category != WLAN_CATEGORY_PUBLIC &&
+		    category != WLAN_CATEGORY_SELF_PROTECTED &&
+		    category != WLAN_CATEGORY_UNPROT_DMG)
+			return true;
+	}
+
+	/* Control frames */
+	if (ieee80211_is_back(fc) || ieee80211_is_back_req(fc) ||
+	    ieee80211_is_pspoll(fc))
+		return true;
+
+	return false;
+}
+
 #endif /* LINUX_IEEE80211_H */

-- 
2.34.1

