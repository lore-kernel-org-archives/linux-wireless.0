Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BC547A896
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974097; cv=none; b=oeQkXWkDpdNih6nPnkwLUm2X+KEl3xE7ttNnuk/aOhBq5NEq5m9hDkOmrQl/1XrUczdbeqR+lL8isKbZcJ3vrtxvcYAmTkcNMRxKT15cKThbIX/gDWsWH6dDvP8zjWfaY8ZZkvDOuTFwjBvmESrr9a+cPeh6vpObG6vPxzixrxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974097; c=relaxed/simple;
	bh=VSoUDg1IIknrr3c19TKnkmpSRl8rY97jryu2UWbP4vE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mZqtqaUGsrk6qua409YeoOJkoylIVGOy+glgQfNXvDGkm9Y0rfF5Shllgz+E/dI1AY5I6ElRN4Xkfq3UJf3z2YQOTx8CnwRjqppUFvVo51NeSNpX9TmQ5LQRXaaATOdn2urfl+/JFWMoiW2Wiyu3cbrNxTxSzt6TlalVWiRyJYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SiSJo3kh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SBFdkiZ8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SiSJo3kh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SBFdkiZ8"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E9eHki3697028
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=MXD3mCXdV6N
	8GYe+6P2g6QMKcomasvjGm/yd9PTrocw=; b=SiSJo3khQS3guvcDXpBC9Tf3fud
	aRN4aQrDkfLv3J6wR9nkr78CRNzS48GajgzZ5BK3bhg149PP6HGC1Mj7frqbaxAG
	9U5STLGQr/gxgvucmTZtuLDN1nSqQTJx20/jCz1T/jEQZvbb/MSOIjVSshhydzeG
	wQC6XuurFsrE8ZXDnSAg/QtTwPm6Jrbi9DHmWkAy8pagCD5W3Q+59AhHzZCV8CY1
	5jmicEwdeLYL7sTVgxGXeKZvfFk6z8rrLX6DgRNM99++Y3frubzc7L273EIVrVTB
	DKSE9WduLnndpTx3bYdN3r7fLbMmRHHQU88j0H93Xby5MT3TEuPQRPoPS+g==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha7aeg6uy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:54 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35c5aef2a74so3651591eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974094; x=1792578894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MXD3mCXdV6N8GYe+6P2g6QMKcomasvjGm/yd9PTrocw=;
        b=SBFdkiZ8gTJfuKCvz3IjDQrXJ936So9z6P/tNRjzhEJHSlOgWRiqJkJORn7OO7PCpl
         TKtla1W0Y2qAJtEKArin9IhQiIxftaE5qb7doG5W1XXb9FEk3XJGy4MBBK6u+IoDkYq2
         ETexAWMDqwIcuWNYe9PLtwvQxqj/p0mO22bk/i02q5ranEDoGTiDxevTmd4YTjt2jnlU
         hLxyUiXF+iK9+znb1GClYtRL0yo8RWdl15XIMeQGHW3/3DoDURcJzGoWsKIaklSt7YKY
         kcHwiQBNS3DMpjWL0Zc879BYiKHu8zwsjM7vMsWpcPhqLstVq4E76NgYqdgYdkTdPPfP
         /+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974094; x=1792578894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MXD3mCXdV6N8GYe+6P2g6QMKcomasvjGm/yd9PTrocw=;
        b=Z3pG3fNPMPaRFMtXM9yDdcBc2iC59b4rYFny93r/r1RDDoheGi8DjrKpCXoWCTwluF
         BkfFBAWy4eEuFdJUCsaqhbTdMXJu289jtJOU9/aSEXYyupVzFrzK2OIf3UHad/m0/HBb
         kN9xqVPG5zsV2QdLFxyG/uLpkHZRD0C1c2N/EZgWFJjFUDnQdR1IJcUau84W69F1xNVD
         mVm5HKWVwxWb4bajYdqlBOmvXi9u+VsCqJUZNdASKnl7pvImvnFcgORnlTcp8+NG+y2J
         VKsreb24NCFnmxufW1BhL1+7PLz794s38/WCgOKnGqyY+6kZ4fbOb+QN8E63iW1RIv/Y
         kRpA==
X-Gm-Message-State: AFq9FYJVBIJaEDqlFeAgusviR42506SwhyXbyWJQwJnAevoG9GysS+Ff
	DKxfTNMGlIplCoojGDVsAcC0lXWdUMTQAd4uUDwJzD2fgfo1kkFjOd/bO9TI7eu1Y2X4rKvjn7p
	fEjhhytCZYtIhT1eN1JD0Rxe0gJ1+WYQ5S9kOMGLcrUTkwk89ksNM+PBm9w38JeqY16Qan3E3Rq
	tfdQ==
X-Gm-Gg: AYBFou2NdbcFVKipec7yqKr/JW9DcFRFtymI+s72Grzm/CR8w6hII1wiHr99dFV+pC5
	KwXHfoyDdIISZsNTo+JV3Q/E4gvuBA1lEfxAWsQ+WJe8selZR93uVcdV/In00nGLKb6DDjRRTZk
	MCw3ksfrtjqbbvvFE1J0gh+8iE3E0wojlWMl0089Sl6TcnhiE+sHIu5JmU5dDI7Akv1yLcBh0uN
	lwPXNBZX+v2iuzA/1gm1HppNXCPrdqIGOO/ZVyke9P3nF0LU0Q0Em61ZScIHj2tURdbdxB1oVdX
	YX/F33w3IXv1TdTiN1gpDBtvAI0fSnexYr4pO5Q68LV+hhRzSI09K/RFgNp2pavWSzTao/juyN1
	HJ9Xjwxw73b7vqFeqA57HsdBjsPrhgExnJ05H
X-Received: by 2002:a05:7301:6494:b0:341:225b:d6f with SMTP id 5a478bee46e88-3537dfd8d79mr23949389eec.19.1791974093725;
        Wed, 14 Oct 2026 03:34:53 -0700 (PDT)
X-Received: by 2002:a05:7301:6494:b0:341:225b:d6f with SMTP id 5a478bee46e88-3537dfd8d79mr23949356eec.19.1791974093104;
        Wed, 14 Oct 2026 03:34:53 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:52 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 13/15] wifi: nl80211/cfg80211: add support for NDP request indication
Date: Wed, 14 Oct 2026 16:03:57 +0530
Message-Id: <20261014103359.1508345-14-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: tRHkA2FfAet7w5AnNTL8ZhUcPDqKAbys
X-Proofpoint-GUID: tRHkA2FfAet7w5AnNTL8ZhUcPDqKAbys
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX/LgZOIPPRMLX
 jdjtSNPkwAseo3eTwcdiXBy8pXL/TvlQkapKSTg+iV9DPdShWaaTaYBU2TRIxZ0xJqA3XaSQ0ys
 25HUkHrtYVxZGZZEmliULoJrljYC9HE=
X-Authority-Analysis: v=2.4 cv=NctzRGD4 c=1 sm=1 tr=0 ts=6acf5ace cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=Q-RXIXx9LWi5T1gvJX8A:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX1skaFJwIPsUi
 aLioY9wnC57nNCBI1yvBKx+sOStChj0Y/HpjXStzzBucFgmBlJl44kr/IjvZ3lzbN6cE7k3bGU6
 Q0mC6T35t/Aulbs6w25jbrB25DIWr0dKP5a7LEHtev559am1ZM1hktIXM5cuTUSdv9Ruqdhv/eJ
 rVnyKw/wU2VvSqG2syqjJ/RjkPT56186exdSm820EGykB8zpYU6r6KpoYYasExCvCzsF5y74TKK
 GD3P/EqsqHUKWA9dbiPoIGD24qI8VPtx6nJOY73cXMVl73YhIps8a5YdSECmXlS96Ao3FoAfOCJ
 tkSBy+ng4evtZj/cRIxeA9rpSYY+LJlrYqxEhlWYjWxef/ciDSoDlJoe5bkSAn5RhKt+xTkQGVX
 Yi8afh15JR21GuzAoLww6F/YWnVdBwfx7yt60szQmJkhxFLfAhe+KFcwa/IMfuAl3waWQkHASDL
 IrEvKYyPL0fdIavawXA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140042

Add NL80211_CMD_NAN_NDP_REQUEST event to notify userspace when the
driver receives an incoming NDP request from a peer. Add the
corresponding parameter structure and event function so the driver
can report the request parameters to userspace for accept/reject
decision.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 51 +++++++++++++++++++++++
 include/uapi/linux/nl80211.h |  6 +++
 net/wireless/nl80211.c       | 79 ++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a79098623442..b356818e135e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4436,6 +4436,44 @@ struct cfg80211_nan_ndp_terminate {
 	u8 reason;
 };
 
+/**
+ * struct cfg80211_nan_ndp_request_params - NAN NDP request event parameters
+ *
+ * Sent to userspace when the driver receives a NDP Request frame.
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID from the received frame
+ * @init_ndi: initiator NDI MAC from the received frame
+ * @publish_id: publisher's service instance ID
+ * @ssi: service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @cipher_suite: initiator's cipher suite ID
+ * @pmkid: PMKID from the peer's SCIA (%NL80211_NAN_NDP_PMKID_LEN bytes,
+ *	valid when @pmkid_set is true)
+ * @pmkid_set: if true, @pmkid is valid
+ * @gtk_required: if true, initiator requires GTK protection
+ * @ipv6_intf_id: initiator's IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ * @ndpe: if true, use NDPE attribute instead of NDP attribute
+ */
+struct cfg80211_nan_ndp_request_params {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	u8 publish_id;
+	const u8 *ssi;
+	u8 ssi_len;
+	u32 cipher_suite;
+	u8 pmkid[NL80211_NAN_NDP_PMKID_LEN];
+	bool pmkid_set;
+	bool gtk_required;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+	bool ndpe;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -11314,6 +11352,19 @@ cfg80211_s1g_get_primary_sibling(struct wiphy *wiphy,
 }
 
 
+/**
+ * cfg80211_nan_ndp_request - notify userspace of a received NDP request
+ * @wdev: the wireless device reporting the event
+ * @params: NDP request parameters parsed from the received frame
+ * @gfp: allocation flags
+ *
+ * Notify userspace that a NAN Data Path request was received from a peer.
+ * Only valid when %WIPHY_NAN_FLAGS_OFFLOAD_NDP is set.
+ */
+void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_request_params *params,
+			      gfp_t gfp);
+
 /**
  * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
  * @wiphy: the wiphy to use
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c2b81e2c4366..c18580fffbd4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1483,6 +1483,11 @@
  *	Requires %WIPHY_NAN_FLAGS_OFFLOAD_NDP. Carries %NL80211_ATTR_NAN_NDP
  *	nested with %NL80211_NAN_NDP_ATTR_ID, %NL80211_NAN_NDP_ATTR_INIT_NDI
  *	and optionally %NL80211_NAN_NDP_ATTR_REASON.
+ * @NL80211_CMD_NAN_NDP_REQUEST: Notification sent to userspace when
+ *	the driver receives a NDP Request frame from a peer. Carries
+ *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
+ *	all parsed NDP request parameters. Userspace must ensure the NDI
+ *	interface is ready before calling %NL80211_CMD_NAN_NDP_RESPOND.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1769,6 +1774,7 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NDP_INITIATE,
 	NL80211_CMD_NAN_NDP_RESPOND,
 	NL80211_CMD_NAN_NDP_TERMINATE,
+	NL80211_CMD_NAN_NDP_REQUEST,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7c2952947a84..8b133637e4e7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18798,6 +18798,85 @@ static int nl80211_nan_ndp_terminate(struct sk_buff *skb,
 	return rdev_nan_ndp_terminate(rdev, wdev, &params);
 }
 
+void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_request_params *params,
+			      gfp_t gfp)
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
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_NDP_REQUEST);
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
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_PUBLISH_ID,
+		       params->publish_id))
+		goto nla_put_failure;
+
+	if (params->ssi && params->ssi_len &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_SSI, params->ssi_len,
+		    params->ssi))
+		goto nla_put_failure;
+
+	if (params->cipher_suite &&
+	    nla_put_u32(msg, NL80211_NAN_NDP_ATTR_CIPHER_SUITE,
+			params->cipher_suite))
+		goto nla_put_failure;
+
+	if (params->pmkid_set &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_PMKID,
+		    NL80211_NAN_NDP_PMKID_LEN, params->pmkid))
+		goto nla_put_failure;
+
+	if (params->gtk_required &&
+	    nla_put_flag(msg, NL80211_NAN_NDP_ATTR_GTK_REQUIRED))
+		goto nla_put_failure;
+
+	if (params->ipv6_intf_id_set &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
+		    NL80211_NAN_NDP_IPV6_INTF_ID_LEN, params->ipv6_intf_id))
+		goto nla_put_failure;
+
+	if (params->ndpe &&
+	    nla_put_flag(msg, NL80211_NAN_NDP_ATTR_NDPE))
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
+EXPORT_SYMBOL(cfg80211_nan_ndp_request);
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
-- 
2.34.1

