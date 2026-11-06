Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951986;
	b=FFBx3tAAn2qoaQ2M+8wBmp+qOEwntqU6NADJhcCO58kDtTZWfE+8ghQs7KB/iEyWwsQ1
	 OH5ySRQjX4nmSRD/2PUY+aQEHAllVNgNfUnd9S+mdSMgkSyCHOsOo70tlS/0LYSWNnHGp
	 DzKf2OhY8UE+Glsms9rNUB6At8FoVI6hWLVWwplusPMnjojZTo5g1hYTtA9ldgu+OBu3T
	 O2FfTGVKTyxMytuzAjf/IKo9wmF1hQQ3o0xcMI2UpByMaiTuXEbjlltwJDuYXsyGHHqC+
	 AaE4Y3JZBDdr0gI0QMDnWbpTYHkWd+mn5vCKkOr2n46G2I+m8Mhd9H1lM/0XbE0YH8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951986;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=;
	b=Jb0oUgI+92+EwlikALKVl6TogbuVq6EHmgX+aH2+PWj1CLl+jNKtkbKRUwMnXUAyzkGU
	 wB+tS1LXWJO8EIha2COLuUsxVEk2d1Kv6Kwulq5ukF2J1Hi+iFOc+FwZc3jz/37dStMzq
	 TsbptOouto/vkDGfueONjuBqFqWIhlTR+FxqOXi0jvAtulMRz0D0BQS3OQgCsMCG/nmFI
	 a/69dYeDf9C2mPwHcRjcf+/NyVqCXC/RkmeXas38cucbr0hfSENzrppCMAQDua0VFTEl3
	 b6/AMYPmTu0n5BEpwDyKEje7+cpgJuewL4+ptnP39VRprfFrUwY/kxfWGFBEPQyhUww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Blg6ePYA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cBMCKzTH;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAFC606A333
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDAFC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Blg6ePYA;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cBMCKzTH
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RTsT2730719
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=; b=Blg6ePYA0nbSNN2M
	CwgrTzqWI+SBthlSPpF6m1bFRYU1cxwHgFSBF9Q242avk9v7wYm0xU4kcQUZLQPZ
	tOnvvbJBNaap3TntuSliZ2jc7zr16hRuhSf8wl/HEmypa0NLAd/+84g91bFG9D0+
	Oe5SBotvucZtMr4f+9OaWoSI2meL1bZCp1IQxytLnr9tQvn9bB8Lt+CT3klh9dIl
	fQmAObQheU8EUEinNB5tOXgRf6KhbGG1WxLGDZ2Lm9kAiMv1RdctM45O1Wk3BGdi
	S7zhJUQEl9j1D8FUhVSRaMJ16X557A4sG6/HovBCqwRtE/ePP10fHROMTg4QBWrW
	LX8KZA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9hpjj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:44 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae19907a31so502542a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951984; x=1794556784; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=;
        b=cBMCKzTHXtxHjrFfcLaE63+hw3rEiXHnH6Xz9fjC6zAMCHUOoNJd89mjNEurbLZFJk
         R6lKaypXfJUEJx9prOt0EET0cl7V3sqS1bmHXNFwi82DqLxPrjG4OzTpe36LrID+AuoV
         ucCJ/LwVXv/4dl0L0o4d8j3cS0JxZMrA9SqJlMSVOvDsuEYsvcOiFfxm23OPofhgt65q
         Dd/D0wLFakDIrxhRARHHo6BB7isJhICVYEdf+hlryvGLePw6KytlPjYRZFcs89MN412D
         YHG+NjfnCC0ATZ1N/W+6UnRfqIR7bYoOXHV6m354i3Dta7qr1xKS+QwHwyyc+f4m5dYE
         ph9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951984; x=1794556784;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=;
        b=yG6P4NCYcY0PtIZso9ZLs3lB+6sSgQ2QEyoJLG7AdIL0xtg2aOCes7gO483Rr/RaEu
         /2b2saGg70YMMYG3dq9I1luLVg3mRpGwdE3Ow3ieIMhO6oqUiVrBYd/fUrmhYvc1aKNy
         noSHEnSueoAqq8oGHzBXP87eT1VSZSC9vfsNw9zSBZfixP9wavHljxmzC6tb2bPYKhAd
         nWz2EXSaZv2mzf4KeWRGbx3cKw7rjgVBJqRSkJdg8s+CYGicaDZUZCgX0N9V+NTWHQF3
         XrBNtA6lnQ2p8ZRiFTvaTcW2i0FlzUWt+LvfbohN+9aPTZmKSSMr7JykyDKyTZn1PhSB
         LCdw==
X-Gm-Message-State: APuU4Z+6zSFz8r/31T7VVXeAXk56GnwY6ggGwXk+jK5i92TDwEBPIzt+
	U+ybZ826yv7OePQVUy5N7QZwxrsNy98zM3VGvONW0vEl1EpQ9JoLq68DwAu9GTyEJDFdUo9J+jS
	jPzyo2NR69Ex0iWucad+HfhKlBYIc8xPLYohN6tTHg9fCMnEUOScaQAN6XVS/ZW0QpY7a
X-Gm-Gg: AYBFou0gGRRreQq179ogtdycngJG/3xMEmWNS8al+O2XgsAq4UKAyYLSkYlZYTd2MdS
	g1l1L7kUUtE7CMLOl1kfRbw/ExpgpHpk/wgM9kvidMGX2cI4Y0AtDnnvB60EU0oKVB+ODNIgnEY
	54Xmysv4hKCZIvPHWJIxuYluCm4stXfoCVwLqY5eHZxbdplavr+lPpn+gVlbNta89T4+YFzdZog
	diVXaqqvFw5x8iGuDgI4udTTuEM/VRE0euCvgPCoyeHi3kc23LgY89yXsZRvG/bZW590AXVIn8y
	jNJR2cXW0EQ980mYPfZmmF7rWlrVTGesYQIv7gHUPoKC7y/HogGIEo13/TPCWCMsO5fkm3QUzrM
	B5fksskclP/DMH6sHcpgoGWgtV7nc6EB04HqlWmEKrLkCL5diIh3S7OfDg8lj2tHQZPAgsldx3y
	wc+wrlIbshLNYnK/qaKfxeXnfvnpWEqQ7nKVpStqYFLjTFZrTKvhQc1pJsWAm3Cdj9hu/2Gp4=
X-Received: by 2002:a17:90a:d884:b0:3ab:b764:8256 with SMTP id 98e67ed59e1d1-3b0db6d1b82mr1004138a91.17.1793951984256;
        Thu, 05 Nov 2026 23:59:44 -0800 (PST)
X-Received: by 2002:a17:90a:d884:b0:3ab:b764:8256 with SMTP id 98e67ed59e1d1-3b0db6d1b82mr1004121a91.17.1793951983709;
        Thu, 05 Nov 2026 23:59:43 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:43 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:45 +0530
Subject: [PATCH wireless-next v4 08/21] wifi: nl80211/cfg80211: pack SMD
 dynamic context along with frame
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
Message-Id: <20261106-smd-v4-8-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: zlaw8ZidXZw_qViwVD3iwydHgeebSKfm
X-Proofpoint-GUID: zlaw8ZidXZw_qViwVD3iwydHgeebSKfm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX2Z2uYC85W+bc
 C2Xn5njA2AXTWKs7QovtyqQXbA7QGValN1Az5EtzbfBjtsHfq4WBvNjCED3Qxe8j1O9rvmTuVC9
 VfMexdukwZ9a4mPQAbQbeuWnxS08UbY=
X-Authority-Analysis: v=2.4 cv=XvNvqlF9 c=1 sm=1 tr=0 ts=6aed88f1 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=Q3n5vibPIWZSySpmOWoA:9 a=DZ0Sps0JoYeYFSLR:21
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX0j9f9wYOLZGu
 kTfHy056/FZ8wsrw24SmuZykkiE9C6SAyF7zG19+hnRWt4sVWY0jXL+iTpMX3fQx02AyJFFeUoh
 w/w67fr9AuaLrRPFkcbr/UI8GR+Me3OAxCJz/2Z4HPMAQnY6z5/enReD0E/8jxzDYqrVpjHlk5j
 7F2RGLZ8TKZk0urr9Iy/snMf4g8VgjWrx3iiuswdqm0fYjFnxEQfW7AA/w0Wc2/4dafBlVFW6sM
 k/FcuI2863hmc8DIArWLpRfCpnc8Olxt0vw3n3TL2LldY4pcXf+Qf/h0xWFQlYgYToM+gVfw+bE
 td3Gcpf9HugOLt6E/vL++qx5x9vXAGjjIEEIr1bualQ0SKhvDRxbVHtFjC6rZTKJin+kRK0bCef
 RiXeM7edwjG+bYywALGgWYM2qv/beqHmUUKNT0a7oKKfx18DNmpT5vN6Nr+4ctRNNvqBCPgww7v
 mWlTY+/kx0CB4DAYe/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

While packing the received management frame in nl80211_send_mgmt() to
send to userspace, nest the SMD dynamic context along with the frame
message. This shall be used by userspace to transport the context to the
target AP MLD for programming the dynamic state of the STA session for
seamless roaming as part of SMD BSS Transition.

Suggested-by: Jouni Malinen <jouni.malinen@oss.qualcomm.com>
Co-developed-by: Aditya Sathish <asathish@qti.qualcomm.com>
Signed-off-by: Aditya Sathish <asathish@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h |  13 +++
 net/wireless/nl80211.c | 286 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 298 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 938fbfe0e71d..877845477ce9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4893,6 +4893,17 @@ struct mgmt_frame_regs {
 	u32 global_mcast_stypes, interface_mcast_stypes;
 };
 
+/**
+ * struct cfg80211_smd_transition_info - SMD BSS Transition info
+ *
+ * @ctx: Dynamic context to be transferred as part of ST
+ * @type: Type of ST indication
+ */
+struct cfg80211_smd_transition_info {
+	struct ieee80211_smd_ctx *ctx;
+	enum nl80211_smd_ctx_type type;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -9624,6 +9635,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @rx_tstamp: Hardware timestamp of frame RX in nanoseconds
  * @ack_tstamp: Hardware timestamp of ack TX in nanoseconds
  * @no_sta: set if no station is known for the frame (relevant for MLD)
+ * @st_info: SMD BSS Transition data
  */
 struct cfg80211_rx_info {
 	int freq;
@@ -9636,6 +9648,7 @@ struct cfg80211_rx_info {
 	u64 rx_tstamp;
 	u64 ack_tstamp;
 	bool no_sta;
+	struct cfg80211_smd_transition_info st_info;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d2cd03d8b0c5..33e52b8bb5fa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20137,6 +20137,282 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_epcs(rdev, dev, val);
 }
 
+static size_t _nl80211_smd_ctx_nl_ba_param_size(u8 n_tids, bool dl)
+{
+	size_t n = 0;
+
+	n += nla_total_size(0); /* ba_params nest header */
+	n += n_tids * (nla_total_size(0) + /* tid nest header */
+		       nla_total_size(sizeof(u16)) + /* buff_size */
+		       nla_total_size(sizeof(u8)) + /* policy */
+		       nla_total_size(0) + /* amsdu_support */
+		       nla_total_size(sizeof(u16)) + /* timeout */
+		       nla_total_size(0) + /* ext_no_frag */
+		       nla_total_size(sizeof(u8)) + /* ext_frag_lvl */
+		       nla_total_size(sizeof(u16))); /* ext_buff_size */
+
+	if (dl)
+		n += n_tids * nla_total_size(sizeof(u16)); /* winstarto */
+
+	return n;
+}
+
+static size_t
+nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
+{
+	const struct ieee80211_smd_ctx *ctx = st_info->ctx;
+	int n_dl_tids = 0, n_ul_tids = 0;
+	u8 pn_len = ctx->pn_len;
+	size_t n = 0;
+
+	/* count valid TIDs */
+	n_dl_tids = hweight8(ctx->dl.valid_tid_bmap);
+	n_ul_tids = hweight8(ctx->ul.valid_tid_bmap);
+
+	n += nla_total_size(sizeof(u8)); /* ST type */
+
+	/* outer NL80211_ATTR_SMD_CTX nest */
+	n += nla_total_size(0); /* nest header */
+
+	/* DL nest */
+	n += nla_total_size(0); /* DL nest header */
+
+	n += nla_total_size(sizeof(u8)); /* valid_tid_bitmap */
+
+	if (ctx->dl_sn_valid) {
+		n += nla_total_size(0); /* DL SN nest header */
+		n += n_dl_tids * nla_total_size(sizeof(u16)); /* DL SN */
+		if (ctx->mgmt_tid_valid)
+			n += nla_total_size(sizeof(u16)); /* DL mgmt_sn */
+	}
+
+	if (ctx->pn_valid)
+		n += nla_total_size(pn_len); /* DL PN */
+
+	if (ctx->ba_params_valid)
+		n += _nl80211_smd_ctx_nl_ba_param_size(n_dl_tids, true); /* DL BA */
+
+	/* UL nest */
+	n += nla_total_size(0); /* UL nest header */
+
+	n += nla_total_size(sizeof(u8)); /* valid_tid_bitmap */
+
+	if (ctx->ul_sn_valid) {
+		n += nla_total_size(0); /* UL SN nest header */
+		n += n_ul_tids * nla_total_size(sizeof(u16)); /* UL SN */
+		if (ctx->mgmt_tid_valid)
+			n += nla_total_size(sizeof(u16)); /* UL mgmt_sn */
+	}
+
+	if (ctx->pn_valid) {
+		n += nla_total_size(0); /* UL PN nest header */
+		n += n_ul_tids * nla_total_size(pn_len); /* UL PN */
+		if (ctx->mgmt_tid_valid)
+			n += nla_total_size(pn_len); /* UL mgmt_pn */
+	}
+
+	if (ctx->ba_params_valid)
+		n += _nl80211_smd_ctx_nl_ba_param_size(n_ul_tids, false); /* UL BA */
+
+	return n;
+}
+
+static int
+nl80211_put_smd_ctx_ba_params(struct sk_buff *msg,
+			      const unsigned long *tid_bmap,
+			      const struct ieee80211_smd_ctx_ba *ba_tids,
+			      bool dl)
+{
+	u32 ba_params_attr = NL80211_SMD_CTX_DL_ATTR_BA_PARAMS;
+	struct nlattr *dl_ul_ba = NULL, *tid_ba = NULL;
+	u8 tid;
+
+	if (!dl)
+		ba_params_attr = NL80211_SMD_CTX_UL_ATTR_BA_PARAMS;
+
+	dl_ul_ba = nla_nest_start(msg, ba_params_attr);
+	if (!dl_ul_ba)
+		return -ENOBUFS;
+
+	for_each_set_bit(tid, tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS) {
+		const struct ieee80211_smd_ctx_ba *ba = &ba_tids[tid];
+
+		tid_ba = nla_nest_start(msg, tid + 1);
+		if (!tid_ba)
+			goto nla_fail;
+
+		if (nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE,
+				ba->buffer_size) ||
+		    nla_put_u8(msg, NL80211_SMD_CTX_BA_ATTR_POLICY,
+			       ba->ba_policy) ||
+		    (ba->amsdu_supported &&
+		     nla_put_flag(msg,
+				  NL80211_SMD_CTX_BA_ATTR_AMSDU_SUPPORT)) ||
+		    nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_TIMEOUT,
+				ba->timeout) ||
+		    (ba->ext_no_frag &&
+		     nla_put_flag(msg, NL80211_SMD_CTX_BA_ATTR_EXT_NO_FRAG)) ||
+		    nla_put_u8(msg, NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL,
+			       ba->extfrag_level) ||
+		    nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE,
+				ba->ext_buffer_size) ||
+		    (dl && nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_WINSTARTO,
+				       ba->winstarto))) {
+			nla_nest_cancel(msg, tid_ba);
+			goto nla_fail;
+		}
+
+		nla_nest_end(msg, tid_ba);
+	}
+
+	nla_nest_end(msg, dl_ul_ba);
+	return 0;
+
+nla_fail:
+	nla_nest_cancel(msg, dl_ul_ba);
+	return -ENOBUFS;
+}
+
+static int nl80211_put_smd_ctx(struct sk_buff *msg,
+			       struct cfg80211_smd_transition_info *st_info)
+{
+	struct nlattr *dl_sn = NULL, *ul_sn = NULL, *ul_pn = NULL;
+	struct nlattr *smd_ctx = NULL, *dl = NULL, *ul = NULL;
+	const struct ieee80211_smd_ctx *ctx;
+	unsigned long dl_tid_bmap = 0, ul_tid_bmap = 0;
+	bool pn_valid;
+	u8 tid;
+
+	/* ST Type */
+	if (nla_put_u8(msg, NL80211_ATTR_SMD_CTX_TYPE, st_info->type))
+		return -ENOBUFS;
+
+	smd_ctx = nla_nest_start(msg, NL80211_ATTR_SMD_CTX);
+	if (!smd_ctx)
+		return -ENOBUFS;
+
+	ctx = st_info->ctx;
+
+	/* Build DL context */
+	dl_tid_bmap = ctx->dl.valid_tid_bmap;
+
+	dl = nla_nest_start(msg, NL80211_SMD_CTX_ATTR_DL);
+	if (!dl)
+		goto nla_fail;
+
+	if (nla_put_u8(msg, NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP,
+		       ctx->dl.valid_tid_bmap))
+		goto nla_fail_dl;
+
+	if (ctx->dl_sn_valid) {
+		dl_sn = nla_nest_start(msg, NL80211_SMD_CTX_DL_ATTR_SN);
+		if (!dl_sn)
+			goto nla_fail_dl;
+
+		for_each_set_bit(tid, &dl_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put_u16(msg, tid + 1, ctx->dl.sn[tid])) {
+				nla_nest_cancel(msg, dl_sn);
+				goto nla_fail_dl;
+			}
+		}
+		nla_nest_end(msg, dl_sn);
+	}
+
+	pn_valid = (ctx->pn_len && ctx->pn_len <= IEEE80211_SMD_CTX_MAX_PN_LEN &&
+		    ctx->pn_valid);
+
+	if (pn_valid &&
+	    nla_put(msg, NL80211_SMD_CTX_DL_ATTR_PN, ctx->pn_len, ctx->dl.pn))
+		goto nla_fail_dl;
+
+	if (ctx->ba_params_valid &&
+	    nl80211_put_smd_ctx_ba_params(msg, &dl_tid_bmap,
+					  ctx->dl.ba, true))
+		goto nla_fail_dl;
+
+	if (ctx->dl_sn_valid && ctx->mgmt_tid_valid &&
+	    nla_put_u16(msg, NL80211_SMD_CTX_DL_ATTR_MGMT_SN, ctx->dl.mgmt_sn))
+		goto nla_fail_dl;
+
+	nla_nest_end(msg, dl);
+
+	/* Build UL context */
+	ul_tid_bmap = ctx->ul.valid_tid_bmap;
+
+	ul = nla_nest_start(msg, NL80211_SMD_CTX_ATTR_UL);
+	if (!ul)
+		goto nla_fail;
+
+	if (nla_put_u8(msg, NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP,
+		       ctx->ul.valid_tid_bmap))
+		goto nla_fail_ul;
+
+	if (ctx->ul_sn_valid) {
+		ul_sn = nla_nest_start(msg, NL80211_SMD_CTX_UL_ATTR_SN);
+		if (!ul_sn)
+			goto nla_fail_ul;
+
+		for_each_set_bit(tid, &ul_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put_u16(msg, tid + 1, ctx->ul.sn[tid])) {
+				nla_nest_cancel(msg, ul_sn);
+				goto nla_fail_ul;
+			}
+		}
+		nla_nest_end(msg, ul_sn);
+	}
+
+	if (pn_valid) {
+		ul_pn = nla_nest_start(msg, NL80211_SMD_CTX_UL_ATTR_PN);
+		if (!ul_pn)
+			goto nla_fail_ul;
+
+		for_each_set_bit(tid, &ul_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put(msg, tid + 1, ctx->pn_len,
+				    ctx->ul.pn[tid])) {
+				nla_nest_cancel(msg, ul_pn);
+				goto nla_fail_ul;
+			}
+		}
+		nla_nest_end(msg, ul_pn);
+	}
+
+	if (ctx->ba_params_valid &&
+	    nl80211_put_smd_ctx_ba_params(msg, &ul_tid_bmap,
+					  ctx->ul.ba, false))
+		goto nla_fail_ul;
+
+	if (ctx->mgmt_tid_valid) {
+		if (ctx->ul_sn_valid &&
+		    nla_put_u16(msg, NL80211_SMD_CTX_UL_ATTR_MGMT_SN,
+				ctx->ul.mgmt_sn))
+			goto nla_fail_ul;
+
+		if (pn_valid &&
+		    nla_put(msg, NL80211_SMD_CTX_UL_ATTR_MGMT_PN,
+			    ctx->pn_len, ctx->ul.mgmt_pn))
+			goto nla_fail_ul;
+	}
+
+	nla_nest_end(msg, ul);
+
+	nla_nest_end(msg, smd_ctx);
+
+	return 0;
+
+nla_fail_ul:
+	nla_nest_cancel(msg, ul);
+
+nla_fail_dl:
+	nla_nest_cancel(msg, dl);
+
+nla_fail:
+	nla_nest_cancel(msg, smd_ctx);
+	return -EINVAL;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -22872,10 +23148,14 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct cfg80211_rx_info *info, gfp_t gfp)
 {
 	struct net_device *netdev = wdev->netdev;
+	int st_roaming_data_len = 0;
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(100 + info->len, gfp);
+	if (info->st_info.ctx)
+		st_roaming_data_len = nl80211_smd_ctx_nl_size(&info->st_info);
+
+	msg = nlmsg_new(100 + info->len + st_roaming_data_len, gfp);
 	if (!msg)
 		return -ENOMEM;
 
@@ -22911,6 +23191,10 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	     nla_put_flag(msg, NL80211_ATTR_FRAME_NO_STA)))
 		goto nla_put_failure;
 
+	if (st_roaming_data_len &&
+	    nl80211_put_smd_ctx(msg, &info->st_info))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);

-- 
2.34.1

