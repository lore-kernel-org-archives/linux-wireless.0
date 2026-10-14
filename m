Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AAB240611
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974100; cv=none; b=U73xdr5DsGlsm5cSMhOUgBj5KTA9LbcK0Q4lj6eKUT2XKnFZ8QeFkxgiQv8NNoNEn2nydV2KPyBfIG+UPYvtD4HY2rqM7Dw/hJ/xMyVGRMr5ordjk11evnNJnuxlBl89kKPN9GawY5k1ZhZof0PrxgE7joL+rXzh09WZP1Gm3IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974100; c=relaxed/simple;
	bh=8rqJOlmbTbvJspY+kPlL2Jw+S/kalkZ6HoCqbkICQnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bVf0QZEqRTFhDUU3Hq+wOJhyo4xwih9POqvoYQhPBGrHx6xZSRTD9kV5vKS3trzx5WreTcG1CTHS2uPEvCLP4TnaGwSxeSiv7wuqIT/tx/HBu8myMBGVWZj+CqunI9puyK1+OyBrD2bWQXUUu2AR9uO3wb+9WOjReq0Wf9Idbic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jQJcK2sq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S74Xcw8T; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jQJcK2sq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S74Xcw8T"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E663kL3365337
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=EJLEuPNkfwb
	lnKemAT1F+P+ok3kNl6yO31vKf73Advo=; b=jQJcK2sqPgXeLyXO+dKGokOySSu
	2hvaYD5y1GKPM2mnO2eStsxJyi1bjYNKsEWNGytlPb95ELT75hqtXuu0qra2uLqa
	TKT/DaPsoib0M2ieQ6mHIkEgbsm8KvOrnlmh7YVIeXMH1qSt9WWw5IzWmtozMBpf
	y2SRvDU00Y5xhMeRYlcEnqoQURcLa3raoASvZOZIrHrebfB/6xzZD2twN7L0OQx2
	raI7qdYF1L6bQcxNucYWxAsNmzI4YQxIQp2mkng9YODp4Msz90avAFc1mx0EPs8U
	Zz+wRsdgPoHsrLF2F6jkSZCF8blZ2AoaFeckSHXF4EuoMjLtzxJtGBR+u8A==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha46213wv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:57 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so8265551eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974096; x=1792578896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EJLEuPNkfwblnKemAT1F+P+ok3kNl6yO31vKf73Advo=;
        b=S74Xcw8TRm1KWcVrweX/vjTZ98u2tkq+x+Qhvv9OvTGduZ6AGrOLMBTffZuWTRLnr2
         71mLUV+qtqsqtDKG1dQ4VgmSHDgae3lj77pNNleFxWUypQYf9hnALzMMINYUlxVoezgI
         mUz7gYHnBPksHqPt+mfQe2OhiLiZ9NP+6pgXsJhUDkc58arN43ufeQmr0Pj7oDmZXM99
         45BRNpRt/1gpT1/cmaTNQzyMF8C6vGU0xqgTGfbEFcD4h3B0T62NxUbDCey8yA54fJNW
         9ftBtN93oagC/heb8KIdCPXfY19q3XJnQqxerOE9S8yu+XFrsjjx58w4DZS0cN7y6tF9
         25xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974096; x=1792578896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EJLEuPNkfwblnKemAT1F+P+ok3kNl6yO31vKf73Advo=;
        b=vXXIiC5dMu7OH7yW38hOhCqkAGH8OV+fK0GukSb9t1LruDQL02ndynI2qwSW18i8Rk
         DW391Qsi3TG4fhy4HFd7v3YK2A21SEj9FV+T3kSjBBpoem+VJNqfnmuz3savWmn5663l
         lPx10tOABnCyMpxOt8cV6v0kEZmoR3D4EwmXSWAGufmp0mqSSjuQgHCzS8Eq2/4u0tMp
         3j1e/Pgf9wPOL81huUfPPWfajdIKgoUmHGcWdPIriiWr6M4qBTbSZe8FcPkCXZKRYTuJ
         shzr+9GtTUKhT7CkrcuKgoZX8z6GOchAbCpge7JT0F8BdzUeFVrQdSmQU/Yn9ffrXNFR
         hysQ==
X-Gm-Message-State: AFq9FYKe/w69ma/nHpz2KvVdbcElflS7n75w5ooIeKh2pNBn1Z7+j6wV
	c3yKzgQZUVK83o6ZQ4kpOaQsxhEPc3zHGoFjBBlMLDqVEXW6E7o/NGQ2uP2rNy5CfoKZOKPSlyV
	4jQp5eX/+yVkfyOjNpQzqjxcNgGe+p2gMtUiQFykXMZ2v2QLfrwe2HmH8t8uJdT4Gpgss5Q==
X-Gm-Gg: AYBFou31MKUaUmk0Yol6gLTb0JrIYx4Px5fKiZHvIWWoXE6yVutMKb3B+AaRZmdGrGW
	hYrm1zkLG9t9kKpaKOyhlX/UsW1e+5VcM2JIvaaUADjbNNFrL0CtVPi75PrtdKcgF+FvpTLYs4Z
	3iuvuiathVcHi6TyeQc708df5p1EMgHsLck16kWYSNHNebE8UyTDOomMGu35XQ8zr8Xr+4xvqrE
	Coamnu0b7gVkzgyEkA4UeQu66tDJUsGCDyiJNDLZlOK/PcwCzfJdSBY6RAp2OSJIUKD2CgI8vDh
	9o9BOhmS38s9cYPBYrtaBEaRArIs+/Y9BsGhUXRsBPSow2MR91YN6nGruNPeizqfA4KoYvWEU1n
	5KOXS060+fgLwzG9YRbRzc1OwxyY+WV493K/+
X-Received: by 2002:a05:7300:cc14:b0:353:7b68:4f6e with SMTP id 5a478bee46e88-3537e03ce89mr28803197eec.12.1791974096154;
        Wed, 14 Oct 2026 03:34:56 -0700 (PDT)
X-Received: by 2002:a05:7300:cc14:b0:353:7b68:4f6e with SMTP id 5a478bee46e88-3537e03ce89mr28803152eec.12.1791974095486;
        Wed, 14 Oct 2026 03:34:55 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:55 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 14/15] wifi: nl80211/cfg80211: add support for NDP confirm indication
Date: Wed, 14 Oct 2026 16:03:58 +0530
Message-Id: <20261014103359.1508345-15-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: 0xbyVuLZFgOhLr5UjVvt_D4PeGZU5BM1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX/bTOn72qh6xr
 1W7AuNkLZduIB3DpiFgJP8YZ3cHZ8Z0z81C7qRXS4FTXG6/vc+VJsK/9qR418+EDU0Tqz4eYFnY
 sRd/+aehwaeVgT82DFwZsAdFp5bocTMYV/+8dgAiaiz9jGXbHK6A21YiZI3dio6Vhxlv7aaWQy6
 1S9qNB0i/lw43RxRp1paDCoAwZPJmAIFArhZbX0o+U/9EwczU/0geH/UCKVtcQF7TWzCpmDFUDa
 CaIfv0Qiz8K29B+j60aWTA7q8U3mY3UeI+mBIh223qk3FpLR+AAjqgne1A4TVxBOngxP4JbCn3u
 wsCpmKs+FDENSmjtoUiqJCJrdQA3aISaDFNFvpuQDgBxOeCYT9XhSCFlv+9i5u/zoOd71Kd4q5u
 qXswAVqeJXq8LL5hA1rZ972L5gQxr1iq3M6S4t1HEwFMDNVVVyhiOe9FlaPKIPLhq73FnLTmqC/
 poJBziC1T5AzE7aO09g==
X-Authority-Analysis: v=2.4 cv=ErZHPicA c=1 sm=1 tr=0 ts=6acf5ad1 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=g2rSZhvOyYkLztQbP8cA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX8iUvIFHmL6c2
 ul9G5gPzc9/iZS0idyJ3zAfqGofeCHdbCTBT3P/IVKJZ/GGOWN20sU+/W0mfVRPb0RZ6Nu0blK9
 ms9n10lJRrwlUh8AKd+f2MmAxkNFdA4=
X-Proofpoint-GUID: 0xbyVuLZFgOhLr5UjVvt_D4PeGZU5BM1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140042

Add NL80211_CMD_NAN_NDP_CONFIRM event to notify userspace when NDP
setup completes. Add the corresponding parameter structure and event
function so the driver can report the accept/reject status and, if
accepted, the responder NDI address.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 45 ++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 24 ++++++++++++
 net/wireless/nl80211.c       | 75 ++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b356818e135e..e3d3dccfa06e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4474,6 +4474,37 @@ struct cfg80211_nan_ndp_request_params {
 	bool ndpe;
 };
 
+/**
+ * struct cfg80211_nan_ndp_confirm_params - NAN NDP confirm event parameters
+ *
+ * Sent to userspace after the driver completes NDP setup.
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID
+ * @init_ndi: initiator NDI MAC address
+ * @resp_ndi: responder NDI MAC address (valid when @accepted is true)
+ * @accepted: if true, NDP was accepted; if false, rejected
+ * @reason: rejection reason (valid when @accepted is false)
+ * @ssi: response service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @ipv6_intf_id: peer's IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ */
+struct cfg80211_nan_ndp_confirm_params {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	const u8 *resp_ndi;
+	bool accepted;
+	u8 reason;
+	const u8 *ssi;
+	u8 ssi_len;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -11365,6 +11396,20 @@ void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
 			      struct cfg80211_nan_ndp_request_params *params,
 			      gfp_t gfp);
 
+/**
+ * cfg80211_nan_ndp_confirm - notify userspace that NDP setup is complete
+ * @wdev: the wireless device reporting the event
+ * @params: NDP confirm parameters
+ * @gfp: allocation flags
+ *
+ * Notify userspace that NAN Data Path setup is complete. Includes the
+ * accept/reject status and, if accepted, the responder NDI. Only valid
+ * when %WIPHY_NAN_FLAGS_OFFLOAD_NDP is set.
+ */
+void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_confirm_params *params,
+			      gfp_t gfp);
+
 /**
  * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
  * @wiphy: the wiphy to use
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c18580fffbd4..58127fbd5738 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1488,6 +1488,12 @@
  *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
  *	all parsed NDP request parameters. Userspace must ensure the NDI
  *	interface is ready before calling %NL80211_CMD_NAN_NDP_RESPOND.
+ * @NL80211_CMD_NAN_NDP_CONFIRM: Notification sent to userspace after
+ *	the driver completes NDP setup and installs data path keys. Carries
+ *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
+ *	the NDP confirm parameters including %NL80211_NAN_NDP_ATTR_RESP_NDI.
+ *	Userspace should call %NL80211_CMD_NEW_STATION on the NDI interface
+ *	to add the peer NDI station.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1775,6 +1781,7 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NDP_RESPOND,
 	NL80211_CMD_NAN_NDP_TERMINATE,
 	NL80211_CMD_NAN_NDP_REQUEST,
+	NL80211_CMD_NAN_NDP_CONFIRM,
 
 	/* add new commands above here */
 
@@ -8127,6 +8134,8 @@ enum nl80211_nan_conf_attributes {
  *	rejected.
  * @NL80211_NAN_NDP_ATTR_REASON: (u8) Termination or rejection reason
  *	code (enum nan_reason from the Wi-Fi Aware Specification).
+ * @NL80211_NAN_NDP_ATTR_STATUS: (u8) NDP status in
+ *	%NL80211_CMD_NAN_NDP_CONFIRM, see &enum nl80211_nan_ndp_status.
  * @__NL80211_NAN_NDP_ATTR_LAST: Internal.
  * @NL80211_NAN_NDP_ATTR_MAX: Highest NDP attribute.
  */
@@ -8148,12 +8157,27 @@ enum nl80211_nan_ndp_attributes {
 	NL80211_NAN_NDP_ATTR_NDPE,
 	NL80211_NAN_NDP_ATTR_ACCEPT,
 	NL80211_NAN_NDP_ATTR_REASON,
+	NL80211_NAN_NDP_ATTR_STATUS,
 
 	/* keep last */
 	__NL80211_NAN_NDP_ATTR_LAST,
 	NL80211_NAN_NDP_ATTR_MAX = __NL80211_NAN_NDP_ATTR_LAST - 1,
 };
 
+/**
+ * enum nl80211_nan_ndp_status - NAN Data Path setup status
+ *
+ * Values for %NL80211_NAN_NDP_ATTR_STATUS reported in
+ * %NL80211_CMD_NAN_NDP_CONFIRM.
+ *
+ * @NL80211_NAN_NDP_STATUS_ACCEPTED: NDP setup was accepted by the peer.
+ * @NL80211_NAN_NDP_STATUS_REJECTED: NDP setup was rejected by the peer.
+ */
+enum nl80211_nan_ndp_status {
+	NL80211_NAN_NDP_STATUS_ACCEPTED,
+	NL80211_NAN_NDP_STATUS_REJECTED,
+};
+
 /**
  * enum nl80211_external_auth_action - Action to perform with external
  *     authentication request. Used by NL80211_ATTR_EXTERNAL_AUTH_ACTION.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8b133637e4e7..ef7071501915 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -796,6 +796,7 @@ nl80211_nan_ndp_policy[NL80211_NAN_NDP_ATTR_MAX + 1] = {
 	[NL80211_NAN_NDP_ATTR_NDPE] = { .type = NLA_FLAG },
 	[NL80211_NAN_NDP_ATTR_ACCEPT] = { .type = NLA_FLAG },
 	[NL80211_NAN_NDP_ATTR_REASON] = { .type = NLA_U8 },
+	[NL80211_NAN_NDP_ATTR_STATUS] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -18877,6 +18878,80 @@ void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_ndp_request);
 
+void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_confirm_params *params,
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
+	if (WARN_ON_ONCE(params->accepted && !params->resp_ndi))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_NDP_CONFIRM);
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
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_STATUS,
+		       params->accepted ? NL80211_NAN_NDP_STATUS_ACCEPTED :
+					   NL80211_NAN_NDP_STATUS_REJECTED))
+		goto nla_put_failure;
+
+	if (params->accepted && params->resp_ndi &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_RESP_NDI, ETH_ALEN,
+		    params->resp_ndi))
+		goto nla_put_failure;
+
+	if (!params->accepted &&
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_REASON, params->reason))
+		goto nla_put_failure;
+
+	if (params->ssi && params->ssi_len &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_SSI, params->ssi_len,
+		    params->ssi))
+		goto nla_put_failure;
+
+	if (params->ipv6_intf_id_set &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
+		    NL80211_NAN_NDP_IPV6_INTF_ID_LEN, params->ipv6_intf_id))
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
+EXPORT_SYMBOL(cfg80211_nan_ndp_confirm);
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
-- 
2.34.1

