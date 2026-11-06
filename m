Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951994;
	b=YX2/0EmVh9CqMpJpDQpt0pk6yM1eFZmnm95QvbGJIpLX7XbJyvviKzx4AZHlLnSkcOL7
	 Ib2JLef3wNYj67KaDj9j2DDdGHxs/jLa7VyXEDIWbrlXNoQfLjtamSn4/u/YmeWGK+yx7
	 lzZzJEIcWwxkhmnsmGiDY9Obw+ZC/KuNDgPiVXolKAPDmblafgSCKb+Tr1zaeCOKvx5dG
	 TBuO/aAqRgkJiEUaS8FjnYKzTd/ZOdfa4RAOD8D9KRBy6ir+fxWyC+qO7rUy851JwZ70J
	 sZsqbJHWFgo0wAUHxFJ0qH8GoccpHFFcThNs+5QVfOHKYhefpT5flTz9XybShEAw7Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951994;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=;
	b=jGc5xoJV3hmooyGMovPcNiKqHRjiCY5oEevTwzGkrQV7ROt44J6pwMzgvhaGh6dHCBrk
	 70g09OKs/TEgH25ODhXUOke4a63l+MIe1wTshtl0XGiVKwCg2ZeS4+YVBV0qRqv12WYue
	 zvTm92pTnZ+lvELSgH6GstO/5OAkQkpky7eoVenT6WxsiHn178ETg5RL4AZby2MFtfUMi
	 2Ve0DaVWBQ//jMw39SnuPrYzcmLZKyb6zHgwTcus1MLxkSDyVoxZpfdBo/sEKd2k4uJS4
	 T+gyEzLfckjjAeEwV/U+1rZJ/bxAdagEwTdnuvIC2sm9EvPgfkP8anyf2rJO/ImdkHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SP3XSop2;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Lg7omrsv;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84260606D81B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84260606D81B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SP3XSop2;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Lg7omrsv
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RkUq3883409
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=; b=SP3XSop22ikIINBE
	iSHF64ttjGnlJzvk1WcKZjx97etHsSt7cxhK41IdN9gjszRtnyh7XeHolHHolZ8I
	3zGXJoFw0ldf1JgbWQxekl1kLl+sZSo/665FfpSIJN5tZD8ad0ssH+6qJHWyMsZ7
	8nzkB+5h7jPartg8iokGMiNfMml5E00z1/QXjvQaL49w1mMoQJgDRQfJdwvYJpDd
	lYwBuv+mbOwkz/xD+fH75/wEWDmybhyKx6PCr67QBpxsK/lfhAXGeUCFZeZ64V4J
	KqaueLJzYB+gKeNEkf1LDIhg33FPXDtKgUystp+/asnMdL1w5aBG17UrJJRib1IF
	92e8Wg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pb1qx8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:52 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b0e00d7cc2so382035a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951991; x=1794556791; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=;
        b=Lg7omrsvnkiWB+2lY3bCKM1AMb4Zu17ObJjp3ZyaQI4TGY9qgNNDzYkSuk1PoND9qN
         aAxm5cpVcOOO5BvkIV+qqycSSO1QsrE9GTPcWB7MvdM+6GgFXCsEvRxC2bVb92Nn8Jgs
         KfAaQhdkEHYAvi714+77wFcIiIgiUEkM9GdJKfT2N10MWjgCPLUKdls03D5ZnOpPrPNH
         pbCx8cSxWLFlInfTDmzXHJz7oy4IclRHonfKrHCz+h8wlpj3bfcLN3lYeLmsr4gLgPzV
         gVAhj5LoAff71EzR0oj+hTjMr2bBpbdl6wARqWbSA0YIcaRlrMaz+0M683b6OaVErYVc
         Us0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951991; x=1794556791;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Yg0+W/ZUmL/NhPphu9P99TIgajYjwa9JI8GXTbbHRM=;
        b=Cls2iiyC125K+ov4ybTQWou+dRbRV73Tz1kX+3eXaKLPEPO8hMy4fY1IPHVn032Kp2
         MllObm89184U7CeiWW9//O33mEA+7g74nXe9qTJDDMOKul/zuJJVB9tSPz4DxX0ZcHPq
         RpchNHWxJNEASBk+Q14HldPg2nLHMl4tGHJFnFoewxSTQ4NSbC5MXm0C3Pe5QYaez8ti
         pg/3Rit9oqt1hF1TVFL8awMM3pDe1CC2tca3JfuUx2L75FtXOqudsVTrvm05XJwY/sj+
         g1x+Hqe3Ztu0HZDXvsP2r0hEw8yg9mdJHB45OYzwGSusOpwc8uDO3GmW785EMNPjBzL8
         VgDA==
X-Gm-Message-State: APuU4Z/7Wjac7VfMiBE2SIMuIT4EgoE4yDR06zi7B5XsvqQXJYMGQKLn
	1MthpQ5sQiDeMmowMOH+KekLfVKp51XcYx9SZTOfbEX6/AU80WNOtCsJOsNp4o+We9ArshDwlue
	bPVYx99enGC2//C3/gFffWOZqwMNbN830xJmmsZbbyLPm2YycboPVpNl5RSHu1BqWdPbJ
X-Gm-Gg: AYBFou21+H2ujmdi6mGn3buorQVyU1xy6XL9COOfwXQSPji/dAy6VigeePelWKIJVhV
	NrqMR2hpdiZNo8qqWUPmtzZnshmq6NGIJtwcG34BWF2vsoWiMfoU7y+8aSN0wpcmtU87mM4HOYe
	OSUsqVShQcBFvzTJ2C2k68UlhP5aKPkFc9mKj2MEgcjB11NfpVJiiQi+faI+39HP3zkf/D0g4BY
	+pmNx27rMHw2LotRMjcH3cMLpSIl2kr2DbMDm/MnqZVIQcmNVIt6aw67FWln+a/BxFvG7h2jhYo
	L+61MuxowvPUGn2bEkKb5IC0W45sbUloFXo+ksi37wn4IPhgUmdzVy5Q7Ghn3UPrZrayB0E6gqP
	hqZWxW2weIn4hv5ZGLioZkIMot7pMVksjSDxkNUWhAvtedcocK1cGleECO2YDPf8+60TU1CXWBq
	z+beHIeiuV/Gx5Td+SktLK4rdjsqmUVdhtYhOGp8ArZpxgXc2Mr/FmEVUu4QkcCLi7EP1yylI=
X-Received: by 2002:a17:90b:254e:b0:3ab:e588:c295 with SMTP id 98e67ed59e1d1-3b0db6fc409mr1573188a91.42.1793951991490;
        Thu, 05 Nov 2026 23:59:51 -0800 (PST)
X-Received: by 2002:a17:90b:254e:b0:3ab:e588:c295 with SMTP id 98e67ed59e1d1-3b0db6fc409mr1573164a91.42.1793951990984;
        Thu, 05 Nov 2026 23:59:50 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:50 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:48 +0530
Subject: [PATCH wireless-next v4 11/21] wifi: nl80211/cfg80211: define API
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
Message-Id: <20261106-smd-v4-11-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: Gkc_kqz-gSFSih-qGJE1kIue-oI8rrCY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX6b4JZSVxZh8G
 ifrLlTwwabSerZNyrwL+RocXbTvsYRxprX+Iamm1AJadvbN37DN0CRt5lpDrqXnqJXNX+cYAbfb
 5mrn0DIMAsw8Wa50gLrym3WrYbjg9dU=
X-Authority-Analysis: v=2.4 cv=LIrz05W9 c=1 sm=1 tr=0 ts=6aed88f8 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=kjsMnnNidseNLnQZ4twA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: Gkc_kqz-gSFSih-qGJE1kIue-oI8rrCY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXwqI4OXiNYX2e
 vSmmajfD+9YC8xfODH2IRyB31Lx60R5pwdyuO/+3hlVu+Mq/zghcnWB5puEoYeSSdwEqr01FW5J
 lgbImtkX61k79SRiAV+otPL/cZ6SisMDUZZn2shN0k83o94HMNgiNXgKkEUkp3kNCrXvM6+WTFf
 aE2WPuf4S1fkSR71mVCrE/2cS4VgOK9JJ/Gl8vSZ5tlcaaE8Nimqy26or443dEEr9BdBeabEUv8
 yB4X1tuYJsXYIhfU5J4V64pCUA7YMn3dX8HB4XI3YHZWttCSMfEq4w+Z7pji1HpVvn9mx/V28dA
 qg3ADX4VwU66kX7F4/MYrSrZB8v3uaHxr9Q01atWzdReLfSpfmEiPwbI51wLVwWm4g0wGUEUvue
 vUPbPNBwXbejG5Y9sqjIOLDB96CAmFoZYlNOuIL75fD4nkjTmEz9cNKYma9+KiPPrHP8vDgw7vl
 b1TP4yaRdA3yglrmOMg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060031

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

