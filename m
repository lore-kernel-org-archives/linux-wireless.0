Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91884D09F8
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974093; cv=none; b=WPQeZEkUD2/cf1uPjn1YVsWNoAeYYYL0BAI06JewDJu0yRdqUcR29D7hDezv8Q5rGrrnoj+QJ6Dl0GHul6Wgt6b5UdDew6WVYgaQNx5tATqAxbLHcvOwEyOFUzSlwc3GIFw50O9qUxxrY/TYhtCANOK3zlDVWbucbOgrUchKDFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974093; c=relaxed/simple;
	bh=IuG4l5NE1OO+1udUIEXVUcUgAAN0AhBsOyOqBhb5k4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EDN9bCdjVAoNBizS1vViZPDLEUavHOh1M9vcjPzQuQO290rotvpMhdtWyj/S4bZY5OcRZhhl79IECzyp5cKzsgtbqFm5GF8BD8bOnhTQiMKAmLl0kWcNifY87qqv7mkuH/6dmdqkVhm6BWPAYmtzGlSoTUFNcpZZEXje2/W69n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IVEUDS6O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WBud5NZy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IVEUDS6O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WBud5NZy"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EAR3l4466257
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=DDE/GlNMt3d
	no1FQ21IOe8K0v9ozGXf+GU7fTbkza2w=; b=IVEUDS6OywafSWoMif5lWqIi+8p
	bLznxFcNtQbZwYrQWIxhJ9jj5cdkgHhV8UrO7oj5v4HQ/8vzvWN2EAnfAvHP2xBO
	ujO6/n10/0sfx7e+oK1bX9gjTgM5vmC6NF+xIHbBgUw8AGzt1clDbG1YnzXledUT
	c/QP8sX7pNpdeUdgd6Q/hCufBH+OwbohP1nZVmZSicz/rM/nkU/JnCk3KYVXiNey
	0QOJ6zDE01QpUgu/LVSZzi+YUumIK9XCOBMSv1a+M7CxqL2Fo7nT6sTVi0ZHFMgQ
	tD8qHc0gzWqQx2OYOctbizKkpv+h/p+NJVeqLiJQqCoXrhjVwWs+Somm/Yg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha80cr0wk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:50 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso6253695eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974089; x=1792578889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DDE/GlNMt3dno1FQ21IOe8K0v9ozGXf+GU7fTbkza2w=;
        b=WBud5NZyXEXYmzL/Y6LeNYa8e9c1e+1HC+q6Sr6ZnEn1HoNDORDbOxR/Tc5/BGHFEt
         BpbabKVrlKL+au24ygcXDQkF6TtS+mffQFuiDUTTG7sJMeUhMSnGk1G4IvXWmKUp9czt
         +g7aqnmixGp2u1/4mRNRVVKOZGCo2TfqLQAkqg8PkjgqiPJ5rxUNSp+FaOTJxZTmPnAN
         fWigWJiP/bMI1awMpUT2M0xaE9s9hC5Z67lIUjBuJ/Av2yDw4gErbndAT2NIMoAnqW11
         zHqTE7EWB8AclWjxPDxyGnfVMAvlhFS0WukR2wp1z+JmMqiBNDHNl8Zw+rsZqxx5pFlj
         oRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974089; x=1792578889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DDE/GlNMt3dno1FQ21IOe8K0v9ozGXf+GU7fTbkza2w=;
        b=26rj9w1+EIep/7qx4zlC8p1ubr2aBP7vWk6MWMrLlc1EDcrDyWLMJ7Lxfz63hxgk1q
         wrdPpZyM0Jb9oDMNb0RfkpzUp+DAHL5ILMMSBvCC3NuP9g2+kiidXrimM3fVtPZuaGif
         jpTYhjJrV/QDpLxIoFiXdY5R/6SKjtmeTp7CKBRzhLzhwn3o23l61etdO4UoAkBd9bUM
         MdyPD5uSOES87kodRmOA7a1ks6anXwVAGhMGoijO1UI9otkm91/NDtJ/H1pZz4j56LrC
         fZRHofJ0EvNEFRzXBmT2peVBcZjcoOsOsui5HN8W44Jem6WFxZ+IOsnGxJvjVMTBjiEj
         er+Q==
X-Gm-Message-State: AFq9FYKl2lE+HqzT4VXyxWremcCH6uMy+EtamXe8r+ZuIqwsmM6lsjQm
	wZWEiomsfwe72XdZU2EdBwYbVJCgI0AbGgZWX1rr4iSxYNMpkinX+SM7adopRVZXsMEb/QVWHtM
	uj3iYdjFaj3D7eFVi5G/QSRmvu4VFTqT0XIfQQXuTNWOCssbbYqSaAvFvtqNEWR2/8/tiUg==
X-Gm-Gg: AYBFou39HGpAUvcHb6z5h/zqIM0I+qi5kk4cdyrGi77qFFC6jgL3mvHmLBr1QZfM/j0
	S+imA0wh0U8aYp4g6EWUXeQBTlG0SNPkLuNKATjKRmgbhPrqEvwqe36bPomxfg8u7Vg47SwxyJ0
	HUxPRLKQUqcaHl4ezVVWHlAvpmBL57XHl2OarYh3+agG1xqnMiBcPMZRwGSUJonbdt4p9ROFVyE
	8ow6ZffrEOpsuHtK+ClHsIGi7T2LLeS+b96Z1Q8k6hS3/cL2OXfXAoDkW2rcGxzOUpp5xtvof+z
	U7fNVbw3nnkV/V5iAm6LF7pft9fpbh672dXd1S8jTHinzA9bKt90GobM8Ifck8yiz3mL7ey+mqk
	VNvTQKrqnhmaQUzT7XrukB3Z/xvxKR0ajokC0
X-Received: by 2002:a05:7301:5787:b0:351:7990:f3cf with SMTP id 5a478bee46e88-3537df9b5c1mr30464324eec.18.1791974088913;
        Wed, 14 Oct 2026 03:34:48 -0700 (PDT)
X-Received: by 2002:a05:7301:5787:b0:351:7990:f3cf with SMTP id 5a478bee46e88-3537df9b5c1mr30464281eec.18.1791974088192;
        Wed, 14 Oct 2026 03:34:48 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:47 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 11/15] wifi: nl80211/cfg80211: add support for NDP response in offload mode
Date: Wed, 14 Oct 2026 16:03:55 +0530
Message-Id: <20261014103359.1508345-12-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX4cMfHgnVv2CC
 +UNQLhxHwoVUybOPDTg7qR8Nxes7HJzIOB8xl3eZ/k/Jy17PIqd0lKI919rXQFOS9eI+Sg1zFcU
 Q+ACTFCn2eiREOGKBIKW5PhepNhpYn8=
X-Proofpoint-GUID: z3ILxxsgU43LKnIfv8IV2vn16ZD8aLef
X-Proofpoint-ORIG-GUID: z3ILxxsgU43LKnIfv8IV2vn16ZD8aLef
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfXzu0rJhZS4xc/
 zbfmRTfu69F+k5wm3PL2l0YHXuqzMptxrG1uuXFhI9iWSRji3IcN5NCDPeyARLwDzetRUvCtiif
 u32t7NHsG+Cftrpjy4E8+iTm+Pm7D9zny+/wBXwL2TDEmFsu9huJg0iGR92MdeuOsFJEuHPc+3U
 Qmw0cbIixofrJvBzIpdXpa9f/SGlrYXmXdAuv2tjqqLjgsrHjs5p83Dcmcuu6e+Es1UDHogsKgM
 BL4zEZ4elbqVjjW7Ei1pvphj+YA8r/jGpifKvAWcE8pj9H0MlID8yPojL2B0VbbYuzuT7F2RMjK
 Yo3rvu0BtPEYO2q+FrP8WQstGTlHGHI8ANE9uepFb11MeiOpqGTwLrUMXg/LBHrMcCMNA2H2Zin
 Vs02FUZL+3f55vKvFvLQIFng+6dsrf/iTOpW5svm1GoQInNAZ4SwksO9029ntm41MFZHDd+94oS
 RUivw88JfXPHQT05yxg==
X-Authority-Analysis: v=2.4 cv=JegpPkKV c=1 sm=1 tr=0 ts=6acf5aca cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=HzrLvHWT_3PvwsSceqsA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140042

Add NL80211_CMD_NAN_NDP_RESPOND to allow userspace to accept or reject
an incoming NDP request when NDP management is offloaded to firmware.
Add the corresponding parameter structure, nl80211 policy, command
handler, and driver callback. Reject the request if the driver has not
advertised NDP offload capability or if security material is provided
without secure NAN support.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  48 +++++++++++++
 include/uapi/linux/nl80211.h |  13 ++++
 net/wireless/nl80211.c       | 129 +++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  16 +++++
 net/wireless/trace.h         |  24 +++++++
 5 files changed, 230 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ed1f476c526a..15b9c88d7ace 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4378,6 +4378,49 @@ struct cfg80211_nan_ndp_initiate {
 	bool ndpe;
 };
 
+/**
+ * struct cfg80211_nan_ndp_respond - NAN NDP respond parameters
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID from the received NDP Request
+ * @init_ndi: initiator NDI MAC from the received NDP Request
+ * @resp_ndi: responder NDI MAC. The corresponding
+ *	%NL80211_IFTYPE_NAN_DATA interface must exist (if accepting).
+ * @accept: if true, accept the NDP; if false, reject it
+ * @reason: rejection reason code (valid when @accept is false)
+ * @ssi: response service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @cipher_suite: NAN cipher suite ID (must match initiator's)
+ * @pmk: NAN Data Path PMK (%NL80211_NAN_NDP_PMK_LEN bytes,
+ *	valid when @pmk_set is true)
+ * @pmk_set: if true, @pmk contains a valid PMK
+ * @gtk_required: if true, GTK protection is required
+ * @gtk_cipher: GTK cipher suite ID
+ * @ipv6_intf_id: IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ * @ndpe: if true, use NDPE attribute instead of NDP attribute
+ */
+struct cfg80211_nan_ndp_respond {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	const u8 *resp_ndi;
+	bool accept;
+	u8 reason;
+	const u8 *ssi;
+	u8 ssi_len;
+	u32 cipher_suite;
+	u8 pmk[NL80211_NAN_NDP_PMK_LEN];
+	bool pmk_set;
+	bool gtk_required;
+	u32 gtk_cipher;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+	bool ndpe;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -5358,6 +5401,8 @@ struct mgmt_frame_regs {
  *
  * @nan_ndp_initiate: Initiate a NAN Data Path session as the initiator.
  *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
+ * @nan_ndp_respond: Respond to an incoming NDP request as the responder.
+ *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
@@ -5769,6 +5814,9 @@ struct cfg80211_ops {
 	int     (*nan_ndp_initiate)(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    struct cfg80211_nan_ndp_initiate *params);
+	int	(*nan_ndp_respond)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_nan_ndp_respond *params);
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 02705ce77685..9eb96251f0c2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1474,6 +1474,11 @@
  *	interface specified in %NL80211_NAN_NDP_ATTR_INIT_NDI must already
  *	exist as a %NL80211_IFTYPE_NAN_DATA interface. Carries
  *	%NL80211_ATTR_NAN_NDP nested with %NL80211_NAN_NDP_ATTR_* fields.
+ * @NL80211_CMD_NAN_NDP_RESPOND: Respond to a received NDP request as
+ *	the responder. Requires %WIPHY_NAN_FLAGS_OFFLOAD_NDP. The NDI
+ *	interface specified in %NL80211_NAN_NDP_ATTR_RESP_NDI must already
+ *	exist as a %NL80211_IFTYPE_NAN_DATA interface. Carries
+ *	%NL80211_ATTR_NAN_NDP nested with %NL80211_NAN_NDP_ATTR_* fields.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1758,6 +1763,7 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_BEACON,
 
 	NL80211_CMD_NAN_NDP_INITIATE,
+	NL80211_CMD_NAN_NDP_RESPOND,
 
 	/* add new commands above here */
 
@@ -8105,6 +8111,11 @@ enum nl80211_nan_conf_attributes {
  *	interface identifier. Included as NDPE TLV type 0 when present.
  * @NL80211_NAN_NDP_ATTR_NDPE: flag. Use NDPE attribute instead of NDP
  *	attribute when peer supports NDPE.
+ * @NL80211_NAN_NDP_ATTR_ACCEPT: flag. If present in
+ *	%NL80211_CMD_NAN_NDP_RESPOND, the NDP is accepted. If absent, it is
+ *	rejected.
+ * @NL80211_NAN_NDP_ATTR_REASON: (u8) Termination or rejection reason
+ *	code (enum nan_reason from the Wi-Fi Aware Specification).
  * @__NL80211_NAN_NDP_ATTR_LAST: Internal.
  * @NL80211_NAN_NDP_ATTR_MAX: Highest NDP attribute.
  */
@@ -8124,6 +8135,8 @@ enum nl80211_nan_ndp_attributes {
 	NL80211_NAN_NDP_ATTR_GTK_CIPHER,
 	NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
 	NL80211_NAN_NDP_ATTR_NDPE,
+	NL80211_NAN_NDP_ATTR_ACCEPT,
+	NL80211_NAN_NDP_ATTR_REASON,
 
 	/* keep last */
 	__NL80211_NAN_NDP_ATTR_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e0700aa12dbc..7593e69c5b3e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -794,6 +794,8 @@ nl80211_nan_ndp_policy[NL80211_NAN_NDP_ATTR_MAX + 1] = {
 	[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID] =
 		NLA_POLICY_EXACT_LEN(NL80211_NAN_NDP_IPV6_INTF_ID_LEN),
 	[NL80211_NAN_NDP_ATTR_NDPE] = { .type = NLA_FLAG },
+	[NL80211_NAN_NDP_ATTR_ACCEPT] = { .type = NLA_FLAG },
+	[NL80211_NAN_NDP_ATTR_REASON] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -18623,6 +18625,127 @@ static int nl80211_nan_ndp_initiate(struct sk_buff *skb,
 	return rdev_nan_ndp_initiate(rdev, wdev, &params);
 }
 
+static int nl80211_nan_ndp_respond(struct sk_buff *skb,
+				   struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct nlattr *tb[NL80211_NAN_NDP_ATTR_MAX + 1];
+	struct cfg80211_nan_ndp_respond params = {};
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP respond requires NAN interface");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(rdev->wiphy.nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP)) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NAN NDP offload not supported by driver");
+		return -EOPNOTSUPP;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_NAN_NDP]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP respond requires peer NMI and NDP params");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, NL80211_NAN_NDP_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_NAN_NDP],
+			       nl80211_nan_ndp_policy,
+			       info->extack);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_NAN_NDP_ATTR_ID] ||
+	    !tb[NL80211_NAN_NDP_ATTR_INIT_NDI]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP respond requires NDP ID and INIT_NDI");
+		return -EINVAL;
+	}
+
+	params.peer_nmi = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	params.ndp_id = nla_get_u8(tb[NL80211_NAN_NDP_ATTR_ID]);
+	params.init_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_INIT_NDI]);
+	params.accept = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_ACCEPT]);
+
+	if (params.accept) {
+		if (!tb[NL80211_NAN_NDP_ATTR_RESP_NDI]) {
+			NL_SET_ERR_MSG(info->extack,
+				       "NDP accept requires RESP_NDI");
+			return -EINVAL;
+		}
+		params.resp_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_RESP_NDI]);
+	} else {
+		if (tb[NL80211_NAN_NDP_ATTR_REASON])
+			params.reason =
+				nla_get_u8(tb[NL80211_NAN_NDP_ATTR_REASON]);
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_SSI]) {
+		params.ssi = nla_data(tb[NL80211_NAN_NDP_ATTR_SSI]);
+		params.ssi_len = nla_len(tb[NL80211_NAN_NDP_ATTR_SSI]);
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_CIPHER_SUITE])
+		params.cipher_suite =
+			nla_get_u32(tb[NL80211_NAN_NDP_ATTR_CIPHER_SUITE]);
+
+	if (params.accept && tb[NL80211_NAN_NDP_ATTR_PMK]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_PMK],
+					    "PMK requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+		memcpy(params.pmk,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_PMK]),
+		       NL80211_NAN_NDP_PMK_LEN);
+		params.pmk_set = true;
+	}
+
+	if (params.accept && tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED],
+					    "GTK_REQUIRED requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+
+		if (!tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED],
+					    "GTK_CIPHER is required when GTK_REQUIRED is set");
+			return -EINVAL;
+		}
+
+		params.gtk_required = true;
+		params.gtk_cipher =
+			nla_get_u32(tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]);
+	} else if (params.accept && tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER],
+				    "GTK_CIPHER requires GTK_REQUIRED");
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID]) {
+		memcpy(params.ipv6_intf_id,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID]),
+		       NL80211_NAN_NDP_IPV6_INTF_ID_LEN);
+		params.ipv6_intf_id_set = true;
+	}
+
+	params.ndpe = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_NDPE]);
+
+	return rdev_nan_ndp_respond(rdev, wdev, &params);
+}
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
@@ -21781,6 +21904,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
 	},
+	{
+		.cmd = NL80211_CMD_NAN_NDP_RESPOND,
+		.doit = nl80211_nan_ndp_respond,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index dcf2a596a574..3fbc5b701768 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1199,6 +1199,22 @@ rdev_nan_ndp_initiate(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_nan_ndp_respond(struct cfg80211_registered_device *rdev,
+		     struct wireless_dev *wdev,
+		     struct cfg80211_nan_ndp_respond *params)
+{
+	int ret;
+
+	if (!rdev->ops->nan_ndp_respond)
+		return -EOPNOTSUPP;
+
+	trace_rdev_nan_ndp_respond(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->nan_ndp_respond(&rdev->wiphy, wdev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0da1c159315b..f937941c6076 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2574,6 +2574,30 @@ TRACE_EVENT(rdev_nan_ndp_initiate,
 		  __entry->peer_nmi, __entry->publish_id)
 );
 
+TRACE_EVENT(rdev_nan_ndp_respond,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_ndp_respond *params),
+	TP_ARGS(wiphy, wdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__array(u8, peer_nmi, ETH_ALEN)
+		__field(u8, ndp_id)
+		__field(bool, accept)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		memcpy(__entry->peer_nmi, params->peer_nmi, ETH_ALEN);
+		__entry->ndp_id = params->ndp_id;
+		__entry->accept = params->accept;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", peer: %pM, ndp_id: %u, accept: %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  __entry->peer_nmi, __entry->ndp_id, __entry->accept)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
-- 
2.34.1

