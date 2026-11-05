Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907647;
	b=xlWOEBZwlYHf9JYoDfYKqDp4iHJAvhftTbTpILwGt/bsqoF/I8bf8V0IpdUCs7zyden4
	 hzEoQI/pyf8ogzVHDw40fBW42b5GXsKN2cPIofO/6wzd79Scb81qa7JiCJleZ9GZR7o9b
	 Qb9HxSnGDWExOg4zu5yYwCqZbamaeKnbQEW/YXGR/IFx2hF2CnFx+3kbicyxkFeeSgz8B
	 nqQRhepzwoQVsOtddMerzr9WCd1MrF53lWOCKrffy0Tu9kuWYHH8q+ExqLJgpASogQe+g
	 uT23EE7BbLUmErT6qPDoQweAiiba7Xvznj5LI0GRQv8guOzSAd6ULa1KEZfyScz8k8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907647;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=;
	b=sSzZlAvvm3qqixuMCUpRBbw+cG2WCoFjh6ta4Z/nBF8Kic6S+W8QhnspXdZnLlQYsTSq
	 14qxKzl8IkodGzhvWFEAhpBGmzXee/hhpZAuUWVYov4bOS8ou8GziyiASZdYLhEqt573d
	 v1RhC1sMpTKr9DTfnm1Y/kWZfQR7UcoHwWVWBFMVwnxnfd2jNJ7ypOhuo5vJSEVGejyGJ
	 QJm3UjuJWnYtONd2y8l+2cqLIV987UNcneCauDCsMn5KuT1ayaDYwyUSYva46TBlkHLjx
	 ydIT3s+iGczJ1r+XXKtGoVa9nt7wheyfzy73XOj8AOjiAQoIUZbRZ8mSC/d91STpcpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BCyPmQe4;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Yb26WKpb;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF34607F43F
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CF34607F43F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BCyPmQe4;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Yb26WKpb
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeKT41485080
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=; b=BCyPmQe4EqtuWN/N
	TVdExSHor+GMda7EzJRoDe5GTZX5Gci5CLAiprCjTtFw9XPZ/gKxsGeh+AHFCY8w
	aSclgTpr+jYUr2i0Cc8ct1Z24q02oCJPr0LTY/HEpvkdMvEuCQYtxYTaPZIM8mSW
	jwi/Q4/LosC/4klY0GgCya7582Eqs3DRjvzodJ0zgKFX4q43CjwOIaZmJe9egHCc
	swAPULcjNFhzLf8S0mceKSoC5TMqmd/rTikvDR8NMRD6E1m+9M6dtFmGODEf0EqN
	zWfK2wMJ6dIj2ZIe4Mbu3J9Mh2EAR23yVn4S2MAWwyDjCN/xxRvWq0oK40uGcvGd
	0bshGw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrpaajyee-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:45 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36de26cb4b3so1730028eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907645; x=1794512445; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=;
        b=Yb26WKpbANa9BzdQLynVcwXOoz0OylxT2o6z2GGgWPZEedJTSZ63SQbsGGJDw8JXc+
         /2FRCVy4Bz40csDkWq4cLRjJ6390VPGD/ddjYkpYbOMQzYlO+FKPsLOWpqyeeLp3Ru78
         mwFcwNWv5bH9tk8MZQw13CiQG9xm8ZpHrg8t74SUuQWfn1xO21icbQKD/m8n9k/nVcMK
         Yds10d1r6PUiYRrB90/pkSdQKRy6NULctRgecOkM0fMTGf9/fvcgeVgTfhZZawe/AgrO
         bs1QLXuPqifd31kSeCFvWX4Vi5za3+Rl+A7u6YhOWqQHH+Xh8h5ul1/7sxg0ofOf7mEk
         pR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907645; x=1794512445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=;
        b=xIIEzaYpOVotGIdnWA/51T2s2GveRPo5mK/3/GXegKh/zgxuZHnpOLb4O3djYBIR4P
         XGZ/0nsaFWP0uz1Izv+etRM0lpmaB0m5ODYN5bXpunGdH19Tcp51sJG7I9hCAkXMzbzv
         h6kA4i4TGwnXi5y4fsRDGgP9cSp3FNAJZEhDawaZqX2QgR2w02PNAxFG6UhdkXzDwCxb
         6NVYu7OSchCWYwUZQoUCCWlRG5m8mIWf5ds/KgSYGPsoNzIcIgZKHL9v/164ByEhU+re
         NDGWUo0dH96tajXfyQlYFokjeh/ZnhVv1ae62Xg0PsG3qmMXIwQ5thghGyev6iw2uSp8
         lq9g==
X-Gm-Message-State: APuU4Z95cy5ib2LIaZaYZ+zKm1JLiXabPudZBAgck6ZFPMCEU42svFSQ
	C2nu2UDtb9j+4tO9jX/n9exJeGCpV2GBaiMN0OjV6k8vvduKw+RKnGFfcj8Vn4UlzXEPz9qwK+v
	rJaRHWPhU88DunNH43SShuvBAEa3sdDZEo+CobJwf1GcEV/epntFaFawS+RJGEK253A/v
X-Gm-Gg: AYBFou3iHAwD6T5c2XZUmKBM2zttWaToDolrG0+4sUuC09qywsHfARmZpX19lLc3FhW
	QH3RCzz9ouTD3Xz1VFB0brZ5xgk8RfhP+SnG1n7ELE+8Bjyc49mBFShVgLnz3+i3ThHSuu/VIOQ
	LfPME1aPtnljRD18nwy8zCpS8iAiO5z3bRnBuoOUyZIkOkTfXCCTZ27VgTmikJohRq/o0MclRPk
	ycWfO6Zg+OcOpVcKTAlBPAy2jYIlMlf+M80c1k7vGzkeWTgYTDkfIY35XjnzyBQ/Dw8kTtgYkEo
	wogIQrQBEju8ceMD2BfdA3bFYR2VaN0GrsqIprrMLLbPmNKOP/TZHaywELSt3n/1bw7Y+g3OPNI
	+KjpnV3xuC0uwh2iyeQlMHXLwUp4Ps7QUrSP+NkpF8adW7Ocxn1pjSca+toG7MpA8DhZQ5kS24+
	P3MWOZQNM8eRu0XNkQFmnn/jLTd+sh+Du+2HpGfeBosnlEUnclWnzHv3VJl03RABwFH+HvDA==
X-Received: by 2002:a05:7301:1a87:b0:369:e8b0:af85 with SMTP id 5a478bee46e88-36f77fd7ef2mr165854eec.36.1793907644894;
        Thu, 05 Nov 2026 11:40:44 -0800 (PST)
X-Received: by 2002:a05:7301:1a87:b0:369:e8b0:af85 with SMTP id 5a478bee46e88-36f77fd7ef2mr165809eec.36.1793907644191;
        Thu, 05 Nov 2026 11:40:44 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:43 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:46 +0530
Subject: [PATCH wireless-next v3 11/21] wifi: nl80211/cfg80211: define API
 to notify SMD Drain completion
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
Message-Id: <20261106-smd-v3-11-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXxk9Ff6XT0rR4
 gbFmXsRVo/ac0b14hIkHbK2nQ9S171Y9UQpcsAuXCrZzDCZ8bL2BSPdByo/hrfPdlA7ohZy4mMH
 14sI0BzotiQW85m5XX9z6HmTEazaviInoHWh0gxQOw5bmnFhfR8w253JFHW0HHEAmgGXtF2Gx6U
 IHbNXHwclVhJeC53/de5UfiU+MzAea6LknsDrCZNFrFf+jKgF64fN6hFwsTxecDGtMVEWraum/e
 N982jOzII1g1SpNm2SKGDa5p5Hgmajh+89mg48OnWlwrNdeko6A/EONuyycEN4oCYDn+htGttxE
 KqOtmFnY+ygTq8NoZ1gFYDlOxmfmLahy2Q5LrBWzIt/+tNteHYizxQMYGpZq06b8EAYt5+AifY0
 8NkweUZqQXr7SIQrAo6+fQaumTcQ+3UXWf8wC29WeAb3vSDyd3zF8/ngVtLvpPdQT0y+5r8Sva8
 IEUUjLnPumZIOUDDxhw==
X-Proofpoint-GUID: auCA2wuNwvbUClJA6mG_vtuQbZ6cR4u9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX63aVvGAAxHjA
 qLNOZDHJm5QVBZZRYibt6i1PZkXEOtBOLX1KQ57KHuR5MVWYbLbZxSEQ6CDLugRA7wTGFU2MqiM
 tDiGlOiaZEWsFtxQk4GQzlCs7c7/qrg=
X-Proofpoint-ORIG-GUID: auCA2wuNwvbUClJA6mG_vtuQbZ6cR4u9
X-Authority-Analysis: v=2.4 cv=WOXqzXsR c=1 sm=1 tr=0 ts=6aecdbbe cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=kjsMnnNidseNLnQZ4twA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050078

The non-AP MLD that has started transitioning to the target AP MLD (ST
Execution) from the current AP MLD will be in downlink draining until
the Nominal Maximum DL Draining Period Duration field advertised in the
ST Execution Response frame.

But if the AP MLD has completed draining the packets before the draining
period completion, the draining can be terminated early. Add cfg80211
and nl80211 APIs for the drivers to send this completion event to
userspace to perform the necessary clean-ups.

Suggested-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 11 +++++++++++
 include/uapi/linux/nl80211.h | 11 +++++++++++
 net/wireless/mlme.c          | 11 +++++++++++
 net/wireless/nl80211.c       | 32 ++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |  3 +++
 5 files changed, 68 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 36ee10ebd62c..7ffe2b8cdd3d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -11304,4 +11304,15 @@ void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
 			       const u8 *sta_addr,
 			       struct cfg80211_smd_transition_info *st_info);
 
+/**
+ * cfg80211_notify_smd_drain_completion - notify userspace about downlink drain
+ *	early termination.
+ * @wdev: wireless device corresponding to the AP MLD
+ * @sta_addr: non-AP MLD address for which DL draining is being terminated
+ *
+ * Should be called under wiphy_lock.
+ */
+void cfg80211_notify_smd_drain_completion(struct wireless_dev *wdev,
+					  const u8 *sta_addr);
+
 #endif /* __NET_CFG80211_H */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fbc23aca006e..993bf4fe571e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -388,6 +388,12 @@
  * AP MLD can request the context from the driver on the target's behalf using
  * %NL80211_CMD_GET_SMD_CTX and the response can be reported back using
  * %NL80211_CMD_SMD_CTX_EVENT.
+ *
+ * The current AP MLD, after successful execution of the non-AP MLD with the
+ * target AP MLD, can continue to drain the buffered packets if a non-zero
+ * Nominal Maximum DL Draining Period Duration has been sent in the ST Execution
+ * Response. Drivers, however, can terminate draining early using the
+ * %NL80211_CMD_SMD_DRAIN_COMPLETION_EVENT event.
  */
 
 /**
@@ -1529,6 +1535,10 @@
  *	(requested via %NL80211_CMD_GET_SMD_CTX) to userspace. It carries
  *	%NL80211_ATTR_MLD_ADDR, %NL80211_ATTR_SMD_CTX_TYPE, and
  *	%NL80211_ATTR_SMD_CTX.
+ * @NL80211_CMD_SMD_DRAIN_COMPLETION_EVENT: Event indicating to userspace that
+ *	the Downlink Drain for the station, identified by
+ *	%NL80211_ATTR_MLD_ADDR, has been terminated early by the driver.
+ *	Userspace can remove the station upon this event.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1815,6 +1825,7 @@ enum nl80211_commands {
 	NL80211_CMD_SET_SMD_CTX,
 	NL80211_CMD_GET_SMD_CTX,
 	NL80211_CMD_SMD_CTX_EVENT,
+	NL80211_CMD_SMD_DRAIN_COMPLETION_EVENT,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 0631e42e2fa1..2a1e00c6f56b 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1607,3 +1607,14 @@ void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
 	kfree(pending);
 }
 EXPORT_SYMBOL(cfg80211_get_smd_ctx_done);
+
+void cfg80211_notify_smd_drain_completion(struct wireless_dev *wdev,
+					  const u8 *sta_addr)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+
+	lockdep_assert_wiphy(wiphy);
+
+	nl80211_notify_smd_drain_completion(wdev, sta_addr);
+}
+EXPORT_SYMBOL(cfg80211_notify_smd_drain_completion);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f30110d998d0..004ee5c6ef6b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -25273,6 +25273,38 @@ nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_notify_smd_drain_completion(struct wireless_dev *wdev,
+					 const u8 *sta_addr)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct net_device *dev = wdev->netdev;
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0,
+			     NL80211_CMD_SMD_DRAIN_COMPLETION_EVENT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN, sta_addr))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_KERNEL);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 2855d30ba354..8088785f0b2d 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -138,4 +138,7 @@ nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
 				const u8 *sta_addr,
 				struct cfg80211_smd_transition_info *st_info);
 
+void nl80211_notify_smd_drain_completion(struct wireless_dev *wdev,
+					 const u8 *sta_addr);
+
 #endif /* __NET_WIRELESS_NL80211_H */

-- 
2.34.1

