Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952010;
	b=c/YfDL9ByyCyx3UuT65AKLN2CmDxKtuWSYybGdS3abxm85MSS7539/XX8KLY+jrC5ZtP
	 7BCH7swJB/i7tw+Hrt9wa2xULXIsV2ddyZ3btx0MVrN+H/6d2Kqic3xGbsoxmbRAXarVK
	 frlV08x5qxEGwevhfgD+VAKtccIdbEdsN8A6jmU5z6WQLSPv8xh61na+nEf34urFz3PFx
	 +n6XuhLH/WnuTrjEou2o3pycbjQ+CJ/3afenvB4HMeqpg2Cv66mkHXB/hdICyKK3Dpcjx
	 v+TfiTBVaukZ8FlH8lmuNLneedvMmlokx6eQhGaVXkyPNR6chojj9XsBOYA6o9n2BLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952010;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=rT/d7+i9YSFZFfCF66tfzOlOFOmBtXy3cwDPZswL+pQ=;
	b=bJDUw3amCgRznUFGMIpecYko+sw0WKmB4CFwm1bwtm/cDFnYJOI+ySVGrS8invESldYg
	 945+3+/Xfc07OJWGSXve3SAR2LUyWJDCZxiGuukGRvWFDU3bPMUEqpMFSjcovgR80MGsW
	 FjCpZX/aaKSyiBFTz9Ohk0amGV/BjXAundpe/evPMmDQZHoiEtNGo8bY5Myjdg5Wn8hLr
	 PfQorvz4ZL0Cb1XUsa6LSX28u97AdSduL/5TqvVp/JQcSU2IJOktck7GvS8rZHlRKTt5E
	 Txeeht7yHTLQHhUFRY2UhSROdDavJ2g4iTdLSYfoX+O5oo1KZtIqSNXZrRUYdwn9Rog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=l1bjP7gu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=O94qcogg;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8866082BFA
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B8866082BFA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=l1bjP7gu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=O94qcogg
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RXs43284548
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 08:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rT/d7+i9YSFZFfCF66tfzOlOFOmBtXy3cwDPZswL+pQ=; b=l1bjP7guESCFs1df
	rSdobeW0X0QRxmxSdXvxd0O9hj5fdW6tJ3T63P2qY0tc8hTtWJllFNtj3QDcnaHo
	bgjP4dso6k/qcoRuI/bl4l2ffBPv6AU1+DhIDSWhNd9/HHMnVR//iytHy3g7P6jp
	SewldhVLA1+K/izA1m+Z7Vr3olb1+ZKXEsfKc7PZ2ZxTay4/roVDFp7oq7M1yT7S
	PRBVxR+bR3FvN/JsDMzi3JOWjmarOKB7CWwkxcWAMB1YxL+0MHMxrFCw+ly4sLwl
	Ymv+VHzvpNdnQMiGJQS3TvwYRd9kgRJIYUWXc66FfPvjuTojxcXQhCYH+072UQMq
	ir/3YA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1r0c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 08:00:09 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso343949a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 00:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793952008; x=1794556808; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rT/d7+i9YSFZFfCF66tfzOlOFOmBtXy3cwDPZswL+pQ=;
        b=O94qcoggwEP0m6j2HcB/+mhoN1qp66EgedQ/kvFuF7sr9IJHZyHGqAV2VPDsq8a0YL
         H4ffdW6YRqj5T5Of5T2YRloRIXkUcHqyzHaQYM3KB8UDZptaCFCNUz0ZZcXK+ziaRolQ
         OgZ05KRJzBKQuqc2Kh/kBcefYTbWBQu8HFRNPVV110S0WW/mw8zbdFgPN9zFjJW620LH
         nYTRBJoLPkZz8N9ZNdAXD3Q+Jyobj61OvyuYXC/gU7uVNPjp5/onE1vlpRskbtZ9cui5
         d+5z07gBH/luwqL45t2LVZtGMUtD++lzKVTgM7M5W30gWfBRS6W/jRmc19V5ob+2yVEx
         SCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793952008; x=1794556808;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rT/d7+i9YSFZFfCF66tfzOlOFOmBtXy3cwDPZswL+pQ=;
        b=Htlgxk2zrQ8XoLsqFeg4mdDEI9FVr5CervdxDVfFGWrOcW7SbiMKY4diEfe61C4uUB
         ARXoLGJjeeuUmGPmo4qhV2SiAWuurr5q6PII7JJ+d/gotbdLUbjQ8yGSjAD86SvtrYNg
         Jju9nIKWwr1MzQ2qlynHZ/v63IsaRYhdrWc8H9B913TVq49Ck/29SxDHM4hmH0QE5Wvp
         /EeqfuSOyPvV9oxn/E/+qtxNGbnVKm9kTSVPNSBZfzsqtSdauH8ip2vsQT8aRE8Art9X
         z+tZcM0BKFis4C/ootpgHBuZ3JZKeFWRtkpHwJQmtwb6fpuAAEM+jHBU1jVr6gXhLPCt
         N/3Q==
X-Gm-Message-State: APuU4Z/LxwkfJLrf5mdDTOkFC4KVqSaOl+6Td2H4ujXFezxSDrI/ZNNd
	XmuHuMYSzI/F9Zice/UHqDq1axbV7BYpfPbwWqzDyKbsNlimonz+JQw8H2LvrSFRMt6/OMEMFyX
	owT/RYjzPgc/qlZsSjekS4qdYYIfHNrYAkQCXmKJge6vaOrroL++No+OjmL56FDrjAsw0mZxtCU
	SR
X-Gm-Gg: AYBFou2U3Z3pADhWn03nrHJoiqerC/NAseCSPUfyHc8xKjB26JI98fh5Qk6eDMeGNL/
	Gk7wrWtkbmFA65ytJPgL3cM2y+FmlEUcNp3hmA9v+xzWBQe69ttIn8yTKyEicmQrK42k4TDuCsf
	3TOlvzSrFdfd+hep8v8WDO19/2dxdtWu+boB2MuUYdyQ/K1YUysMKT5Srtbyre2EA/m0XJuQZYe
	nnmvdQ7u+5sftfVqbOekqdKu4HkULPgOXGoCNaKDwbcesdzeSBgT9/sQ45eepzPJLTGd2bAz1+/
	8ppnpFPt3zsV0NIHomczu1137Io04mIMHzpepMrJUXgzX0sBoVKogd2/UMyuFdl4eitla9vskqV
	5wFl314okA9eD+wabglDIN3k5gepp/jyJO+EQ7yS8NmRp5sy0+QiQbSmPg6KLAa6G+W1j79vN1G
	PFb8QS9VQtiSKu1xWKgLBj8B4C/TBgEFo7d/axCgNeVbiPN1jQRGSTrRGEzl3v+snVKvH8dZE=
X-Received: by 2002:a17:90b:270e:b0:3a4:b3ac:904c with SMTP id 98e67ed59e1d1-3b0db7092eamr1650307a91.51.1793952008049;
        Fri, 06 Nov 2026 00:00:08 -0800 (PST)
X-Received: by 2002:a17:90b:270e:b0:3a4:b3ac:904c with SMTP id 98e67ed59e1d1-3b0db7092eamr1650286a91.51.1793952007523;
        Fri, 06 Nov 2026 00:00:07 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.06.00.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:00:07 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:55 +0530
Subject: [PATCH wireless-next v4 18/21] wifi: mac80211: handle UHR Link
 Reconfiguration frame
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
Message-Id: <20261106-smd-v4-18-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 8zArh_CVlTVBlAXsdTbpumuOPK_1OVTn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX697un8zqP7Ma
 Gj21fj807Ewa/yD3/u13nq7X0I9QigdqhI7koRJWQ8oe+zRUuY4IbQjvsIUjs2iYVVCub3PXUiJ
 l52s3zHX0Y2oGDpCeZqDWkIS3nPO0AY=
X-Authority-Analysis: v=2.4 cv=e7WT2qp/ c=1 sm=1 tr=0 ts=6aed8909 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=2D4fXk2DXaNhJLBsYzwA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX2UIdk5NSAFAh
 czSavdiPe78Vvncu7+EdqcKtMfHJezC7O6xxE4QpLxUIKG0BKA12Kgxfxxa1xWqdQjsWcGVvt8v
 7Rk2aXxw3+26ePKQPp5/9fxUHhYKqQm9+8Kn2K84q4VnFI4DrxFcvNxgE9cB2FCRgAeP8q6zbMn
 a+2gc2Y3rCepfqMzWbSHUQXPjtocXhW6pyUKLBKOhJSe+qwEsUT7s77MVBvtblrrzPTJE/M2QRD
 hnpWFClWcgOp3Bw+2kY9M4SaYKXBuUm8no45acnz0j2BJtHnQXnaHOB+JWy1r5McoZm5LegErNF
 e+44PjygJmmO2XEi8fdMbP64gYUuAEZxmZ5XFSq/4hpRTIW61xLKuET8Gmzr5JClESQdhbClQge
 CqCvnRvwjnu+0D2I/wl/LqcbxrsN1xMXBZlFec1Fs4ukiEY4+w9Nrd5BBaaP57q2IbRzXgknXj2
 bWfcy1D+WX9kwU7pPEQ==
X-Proofpoint-ORIG-GUID: 8zArh_CVlTVBlAXsdTbpumuOPK_1OVTn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

A UHR Link Reconfiguration Request frame (ST Preparation or Execution)
triggers SMD BSS Transition on the current AP MLD. Userspace needs
reporting of the STA's dynamic context along with such frames so that
the same can be transported to the target AP MLD for setting up the STA
TX and RX queues.

Reserve a field in ieee80211_rx_status that enables drivers to attach
the STA's dynamic context to the corresponding frame. Since the maximum
possible context can grow too big, attach the pointer to the context to
the frame. Add handling for UHR ST Preparation and Execution Request
frames so that the associated context is propagated through cfg80211 and
nl80211 for userspace reporting.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h     | 10 +++++++++-
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/rx.c          | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a595126b1e3..2539b5ffd78b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1735,6 +1735,10 @@ enum mac80211_rx_encoding {
  * @ack_tx_hwtstamp: Hardware timestamp for the ack TX in nanoseconds. Only
  *	needed for Timing measurement and Fine timing measurement action frames.
  *	Only reported by devices that have timestamping enabled.
+ * @smd_ctx: Pointer to IEEE P802.11bn SMD BSS Transition context information.
+ *	Only needed for ST Preparation Request and ST Execution Request action
+ *	frames. The pointer will be consumed by mac80211; must be kmalloc-ed.
+ *	Indicated by @smd_ctx_valid.
  * @device_timestamp: arbitrary timestamp for the device, mac80211 doesn't use
  *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
@@ -1775,12 +1779,15 @@ enum mac80211_rx_encoding {
  * @link_id: id of the link used to receive the packet. Set and used by
  *	mac80211 internally, it uses @freq set by the driver to identify the
  *	correct link per vif.
+ * @smd_ctx_valid: if @smd_ctx has a valid pointer to the ST context. This flag
+ *	is used only for ST Preparation or ST Execution Request frames.
  */
 struct ieee80211_rx_status {
 	u64 mactime;
 	union {
 		u64 boottime_ns;
 		ktime_t ack_tx_hwtstamp;
+		struct ieee80211_smd_ctx *smd_ctx;
 	};
 	u32 device_timestamp;
 	u32 ampdu_reference;
@@ -1814,7 +1821,8 @@ struct ieee80211_rx_status {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 	u8 zero_length_psdu_type;
-	u8 link_id:4;
+	u8 link_id:4,
+	   smd_ctx_valid:1;
 };
 
 static_assert(sizeof(struct ieee80211_rx_status) <= sizeof_field(struct sk_buff, cb));
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..82e8542973bc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -279,6 +279,8 @@ struct ieee80211_rx_data {
 	};
 
 	u8 link_addrs[3 * ETH_ALEN];
+
+	struct ieee80211_smd_ctx *smd_ctx;
 };
 
 struct ieee80211_csa_settings {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 78967ac95343..a3ffb08f50ba 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3992,6 +3992,22 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
+static void
+ieee80211_rx_h_userspace_mgmt_st_req_frame(struct cfg80211_rx_info *info,
+					   struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_mgmt *mgmt = (void *)info->buf;
+	u8 type;
+
+	if (!rx->smd_ctx)
+		return;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	info->st_info.type = type;
+	info->st_info.ctx = rx->smd_ctx;
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 {
@@ -4003,6 +4019,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
 		.no_sta = !rx->sta,
+		.st_info.ctx = NULL,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
@@ -4024,6 +4041,9 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	    ieee80211_is_ftm(rx->skb)) {
 		info.rx_tstamp = ktime_to_ns(skb_hwtstamps(rx->skb)->hwtstamp);
 		info.ack_tstamp = ktime_to_ns(status->ack_tx_hwtstamp);
+	} else if (ieee80211_is_st_prep_req(rx->skb) ||
+		   ieee80211_is_st_exec_req(rx->skb)) {
+		ieee80211_rx_h_userspace_mgmt_st_req_frame(&info, rx);
 	}
 
 	if (cfg80211_rx_mgmt_ext(&rx->sdata->wdev, &info)) {
@@ -5630,10 +5650,18 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_smd_ctx *smd_ctx = NULL;
 	struct ieee80211_rx_data rx = {};
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
+	/* cache the pointer to free it later */
+	if (status->smd_ctx_valid) {
+		smd_ctx = status->smd_ctx;
+		status->smd_ctx = NULL;
+		status->smd_ctx_valid = false;
+	}
+
 	if (WARN_ON(status->band >= NUM_NL80211_BANDS))
 		goto drop;
 
@@ -5765,6 +5793,12 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 
 	kcov_remote_start_common(skb_get_kcov_handle(skb));
 
+	rx.smd_ctx = smd_ctx;
+
+	if (WARN_ONCE((status->flag & RX_FLAG_8023) && rx.smd_ctx,
+		      "802.3 packet but with IEEE P802.11bn SMD context"))
+		goto drop;
+
 	/*
 	 * Frames with failed FCS/PLCP checksum are not returned,
 	 * all other frames are returned without radiotap header
@@ -5784,10 +5818,12 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 			__ieee80211_rx_handle_packet(hw, link_pubsta, skb,
 						     list, &rx);
 	}
+	kfree(smd_ctx);
 
 	kcov_remote_stop();
 	return;
  drop:
+	kfree(smd_ctx);
 	kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_rx_list);

-- 
2.34.1

