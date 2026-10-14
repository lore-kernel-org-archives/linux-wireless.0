Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA39F4DE706
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974102; cv=none; b=Itmgm6ur/M6HGzPMbCxAfEHsjWVo+IoR1dc5QM4lU1L2idJk7DLGuOCM365JkaXcVbdvKAfCAlqKqx3ktCABRxIjLY5QU9AweaIhRgd2JQOk/KCAJPBJ1kyJjf8qGgr5V3QhxpPIzvbZSBa8hBz6pOcTjlExTsDSwQ30aDXpaGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974102; c=relaxed/simple;
	bh=i65aWG0WNowWimvWjM4DxteAKckH/Gv5zmBG5Zmpf6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dUwHCEKkfYMuFwQZRgFjFLQSQ7+31ok5j7oGVrGD3REeixi7StMWIwjVddpzeycbQ+59B31C73gQQK2ONFpwiDGzGTn8826s7diyo4q3e3as/U6BxMBtUvZbOZS/gb0DHykOZtsrzmA8vnQELQ4P0AEv8saBzHfty7c9WX0PdWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G1fZOdxC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dWya5t8b; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G1fZOdxC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dWya5t8b"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E5x4QW3952148
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=UmV10mrNWAA
	SkZpsBEU6HnLorG7XbY2YPd6mkO//xuY=; b=G1fZOdxC8qAEf1O2jMmjx6hT85v
	EMjnwU1sAERvdqKcpTzp5PO1gGZQzAYEKvKZY9MnU53doX/uQKA1C1a/iVgiESuR
	Xm2gev3FJBvFL3vhcTu7fSyaDrJOMm+B32Oqizf+nvg7mBPgOS885bvuYC7N+Hym
	ao2IZu5imBSWfiUq1YgOu5eOXYUyTzEXOWYo16yaX0j3Xj338q03FCzK7j8f5kUl
	k/hu/TYiWPx288UTsrmGUTsGzTuukfWzgCMAUIcRZpGQ47MY2sNkkYyKOg5KINNS
	1lkpW4aMOqysw9MACJuwpMu+pGg3JwTmFX8WEf2PbC/7BB+O5ncAin96B9g==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha42p1599-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:59 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3592749a017so867886eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974099; x=1792578899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UmV10mrNWAASkZpsBEU6HnLorG7XbY2YPd6mkO//xuY=;
        b=dWya5t8byfQOq3nZ1HryzKuZxwB10E50D3MgtDTULUIPjUIR40RLlk1Gj3IUIRBqXm
         TqKO0LZrTeA3qfxoMxn0OInYCgKBOP/zhrAnPxNrlHZqvL/xFNRSVv1uXL/1UTKyujC4
         3sxfeC8gV/fpXqgOGOyV1kZBMsOh9P9jo6vqfp3IdHcUvU1nlB5tKpV2ZBdhVQ8K7Hr8
         tGp8doTZteB2bP5owjAfdhGJeLO6HF84wuYrxXTtrgpUXc7V+V21ttTfQxYgpS8DFdBe
         qUgnhNcrBgdPrmL6bwJyWnRzKUg6dSmCt4Ar4nTTDoTXW4/RlCJ3eaQJ6l4R2HVH4+xe
         2PJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974099; x=1792578899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UmV10mrNWAASkZpsBEU6HnLorG7XbY2YPd6mkO//xuY=;
        b=I6Pe54fNu2IMInxvzNGUP7/UDyBfr+Lwpjjhzr4XpUXQQDXdxmhxIzWt4ejrhnwsgh
         u1VaRT9a4pOheiq8paFUUajQ2Ggp+dwKeZ5C2TLsMtahneU/8yZLJFqOtOLkHiXj89s1
         DxGPxjgCloekjED/IePtKpsD3txh9NJAq2AHqUz3FM5cqtj+z+gaB/i/dl0RBm686O3L
         ghq2w5G0nuMF+oL2lOH7voQ3azLwStQqbX+6+ap+F+g6p0Cky3hnzMeyrSd4cWgmT29t
         YLQ4wEhcZFU7wgDIIZ8VEUMIs644qPt+JTfh0wjztQbcbexKpY+Asrnok1a7cC3Djap1
         BcIw==
X-Gm-Message-State: AFq9FYL7mpObxUoTjaE0/CXmcg5tLiIT17etcLhAbK8EWdlYTRhb6FKv
	EWlE4NZw2Nuyva+OM0xj9ofXH3U9f15MS/N3F9/R6Yh24Rs8wtmn255EDf+kb3escwKExQIgK6r
	nJWoXmTox4EXzGr+8gRlY8su2T/qrb6iNgRy2hTIlussujUHEWRon+CZfVJYeNO4mq04s16ttd9
	g98A==
X-Gm-Gg: AYBFou1pHNFp7UyUnXPfiuIlYFsYYcqNu1Bxl8uCWPWj/g3QnxnSnuNbZv5ROfZVo0Z
	RXQ/C1F96SMnzN/bFY2x2+KzkAP26aC0NxPiiSTB51Am0m0oYSranovulmSuGNwSPnoP4Ra3Sm/
	dlqU73OyT89mffXeghqcYacsNnpJY1EWxaQwSIIZIgrm/nYd9QufVQUlYUQcZkIIDIqT8OhvGcc
	MMrZ/Hwod2Jz5AoAXheKrthsm4kPFthfYHY8l08JJTi3pNJ5ehTjop43q/olGKNKd2LxZjtjObe
	+1vZcHG4MqpBKRbekgSK7KyHCCEmFbKIDc1bX2kKAkV60AmxWRIModD4SQ7VsXaVdXE8ib4+WvR
	r9yGY1TLE+wlUnf9/1hPFTU2AOPuGuFXLf9Hk
X-Received: by 2002:a05:7300:b0d:b0:35e:4c6f:dc28 with SMTP id 5a478bee46e88-35e4c6fdd1cmr909797eec.22.1791974098487;
        Wed, 14 Oct 2026 03:34:58 -0700 (PDT)
X-Received: by 2002:a05:7300:b0d:b0:35e:4c6f:dc28 with SMTP id 5a478bee46e88-35e4c6fdd1cmr909780eec.22.1791974097963;
        Wed, 14 Oct 2026 03:34:57 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:57 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 15/15] wifi: nl80211/cfg80211: add support for NDP terminated indication
Date: Wed, 14 Oct 2026 16:03:59 +0530
Message-Id: <20261014103359.1508345-16-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX0JoCiO6o+cbG
 22leKc7Pkd50u0y2F6hNK8tPi2Ci0Wx/a5B5w+S1LSskkCYDa7F/XeiHbcDLhN6MgwUhn9nCx0J
 RzmZY6yCcQTAc0tFKdAf6k0lBpaiX9E=
X-Proofpoint-ORIG-GUID: M9c1PGp-4SpnOQsOuK-KYBsetHVbj2iF
X-Authority-Analysis: v=2.4 cv=aeb0Dhot c=1 sm=1 tr=0 ts=6acf5ad3 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=SXNX8jZLs4P-37pDPesA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX1Un+rrM2bKq1
 LkX0ndsyUpddnUQWVBdxDKgbU9RUlN9mRUnkWzjV1JuuTirbUV48hK2yvqmLFvL0e8yWFgowEFM
 4yuaGS8pLmR0oJDq+PH12M56lkjL+Ek4rulA2q37tvupNCvU2qeEttym43XT6bN2OM8SW3mOJER
 LnH2bzLUZ4Z0nrVhKc07JV2MnftaK+e1Zt9yhLsXXiqSZnOrBhDdvtmzRHrA4J9N6z80w6k6jDP
 NENo+jPJY8FVpoQRAvQ0EEhXBw8QdxWVbhSQKwL1DT5qY5C2BTWjUmy6psNy/zp79yJNHyfMkFN
 N3xs3gthP6IoPDhpM5kIzfgXdaQxfmom1OfsF70goDWMt3yLC8QI7VYxEU9ksCi4xZnPj9Hnxun
 3f0bH4c6Bu2rl1SQCmwIkua1InWqSqB6415xToIn2wd8kI6+w/Guu3lrGc7eXNJdRmRohNzvBJa
 nU4t53J1ZGf9W1y/xkg==
X-Proofpoint-GUID: M9c1PGp-4SpnOQsOuK-KYBsetHVbj2iF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140042

Add NL80211_CMD_NAN_NDP_TERMINATED event to notify userspace when an
established NDP is torn down. Add the corresponding parameter structure
and event function so the driver can report the NDP identity and
teardown reason to userspace.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 28 ++++++++++++++++++++
 include/uapi/linux/nl80211.h |  4 +++
 net/wireless/nl80211.c       | 50 ++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e3d3dccfa06e..8e0325501bcf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4505,6 +4505,21 @@ struct cfg80211_nan_ndp_confirm_params {
 	bool ipv6_intf_id_set;
 };
 
+/**
+ * struct cfg80211_nan_ndp_terminated_params - NAN NDP terminated event
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID
+ * @init_ndi: initiator NDI MAC address
+ * @reason: termination reason code
+ */
+struct cfg80211_nan_ndp_terminated_params {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	u8 reason;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -11410,6 +11425,19 @@ void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
 			      struct cfg80211_nan_ndp_confirm_params *params,
 			      gfp_t gfp);
 
+/**
+ * cfg80211_nan_ndp_terminated - notify userspace that an NDP was terminated
+ * @wdev: the wireless device reporting the event
+ * @params: NDP termination parameters
+ * @gfp: allocation flags
+ *
+ * Notify userspace that a NAN Data Path was torn down. Only valid
+ * when %WIPHY_NAN_FLAGS_OFFLOAD_NDP is set.
+ */
+void cfg80211_nan_ndp_terminated(struct wireless_dev *wdev,
+				 struct cfg80211_nan_ndp_terminated_params *params,
+				 gfp_t gfp);
+
 /**
  * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
  * @wiphy: the wiphy to use
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 58127fbd5738..71ed38992d33 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1494,6 +1494,9 @@
  *	the NDP confirm parameters including %NL80211_NAN_NDP_ATTR_RESP_NDI.
  *	Userspace should call %NL80211_CMD_NEW_STATION on the NDI interface
  *	to add the peer NDI station.
+ * @NL80211_CMD_NAN_NDP_TERMINATED: Notification sent to userspace
+ *	when an NDP is terminated. Carries %NL80211_ATTR_MAC (peer NMI)
+ *	and %NL80211_ATTR_NAN_NDP nested with the termination parameters.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1782,6 +1785,7 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NDP_TERMINATE,
 	NL80211_CMD_NAN_NDP_REQUEST,
 	NL80211_CMD_NAN_NDP_CONFIRM,
+	NL80211_CMD_NAN_NDP_TERMINATED,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ef7071501915..e4b664bdf53d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18952,6 +18952,56 @@ void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_ndp_confirm);
 
+void cfg80211_nan_ndp_terminated(struct wireless_dev *wdev,
+				 struct cfg80211_nan_ndp_terminated_params *params,
+				 gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct nlattr *ndp_attr;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (WARN_ON(!(wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP)))
+		return;
+
+	if (!wdev->owner_nlportid)
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_NDP_TERMINATED);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, params->peer_nmi))
+		goto nla_put_failure;
+
+	ndp_attr = nla_nest_start(msg, NL80211_ATTR_NAN_NDP);
+	if (!ndp_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_NDP_ATTR_ID, params->ndp_id) ||
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_INIT_NDI, ETH_ALEN,
+		    params->init_ndi) ||
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_REASON, params->reason))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, ndp_attr);
+	genlmsg_end(msg, hdr);
+	genlmsg_unicast(wiphy_net(wiphy), msg, wdev->owner_nlportid);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_nan_ndp_terminated);
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
-- 
2.34.1

