Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC6F599A31
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887454; cv=none; b=WMMUQaNiw+7WDoeRtbJftahuMw3fazUARnO2vVNcVkUfsoCCJYpo+yuqRKQ4plj0R/lPbXmEoWSMUepyFTTsSuyi79SdSNqaa57Rq+zhT6Ps7xsHWCMU55o5a24oTJjPgUqkObvGjHs75XSZ1BmQhhBz90EWqAKie8rAtMZHRvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887454; c=relaxed/simple;
	bh=3BIpCqgDAnBGrfpL4IV/b7aNMrM2UPJt17dMZbUsoWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+c+8Nl+MZLNcQ3v/8C8pEWxkw9EOBDmOM0Rcjy9UrB/hYRV3hURZ/EuIoBB8AbWVIVcC9nfT27Y26BBmbv5/sVFpS7bXYkzyjiYEfzw/QTJX/7ip5dxoAR53QBmxN16gTpx6uPitEpkEsJWkzAILMpVNbzchKrBEumL0gZRevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FZzDf2+M; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=b3BXePdG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FZzDf2+M";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="b3BXePdG"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FeLeK3324735
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pCsImhyIeDGFUN5AVZ441p15WIFo4hf5osqfn8vGVMw=; b=FZzDf2+Mkj4lexQU
	NGozUUASGz2jh064UfgZBVctEF+VTN0nUFP6GaBP8u/kHY9L/MxxZpedIEWEHppN
	ucv6pL4GOYE49DDEKMwUUBPzw5ohSFRftvRFRGWhW1kfoyhh8rK7PNdOGuxyxKTq
	sPdxn7VazJ4R6gdV5nofk+sNoTfnMmGaB01ioiaYTbHZ/1wNJ3BBBsGCgSuOcZqg
	91vIk3O3QKaUi7xdkooG4F00I7X4lNcUjTf2uAZ3W7eXYfLafABMqzTci7DQHsLW
	XEIVCdOvXSiBTjSVk496gbREZo9SPlFk1DlzZwKZ/sIjNp/7/3WZn9wSHW7/GdX2
	u9/4aQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjf1cj9x4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:50 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so3804293a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887450; x=1789492250; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pCsImhyIeDGFUN5AVZ441p15WIFo4hf5osqfn8vGVMw=;
        b=b3BXePdGq0K7eVsMgvF3rvfamzpQLS27gJMwGWaBRM4TmiwgJbJUWithUz01X7zz7q
         wRsjiaQ03+2a1+fdWYP4vUF4beKXkdiDkKYo+/Xfl7bRp1P/V6KNVpSf2yLyG1Wn4sNN
         P3bTVqLe635toVeX5oV46ltEiOBsMNJoBoCsm8qdHWH1QzAkruIgcRokLP7LXivlxaRD
         7ntN/6Jo9KWSjniprL70aKfEUO6Jr+sMrthveP5vJwqJN96V11vQ9ZcFxZl2eksFaF7r
         wCcwXaPLZojUlGWK/WcdTVfe83oIm3j5FUEqBDaINAk7E1vIinzrCYw8PgKxkO3JXIQu
         Mn/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887450; x=1789492250;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pCsImhyIeDGFUN5AVZ441p15WIFo4hf5osqfn8vGVMw=;
        b=WLK3VEJ2/PYx1KcwZ12z7ktjxRka1jVXAu1Kj4yyODOrIHxsNZg6A8AJjFVI8zdnUR
         xLZcoF2/wdX7Ec0YukgN0yQv0TxJWu94Umx0rdHjuGB4z6Hegb0Ne1P6SJftnsJ/fVsI
         M7DyGmBH9+bPWjHqP2wFj40Mtdz4M8/yD3df9Gk3jwX908cxtfBAd527V3X9RCOQ2CS/
         ejPtHtCJLtfrXYRsTV1slYXEZyaIMVNiGgZkfS6QlJL+ElETfCLBpufZv+1aaBPIs7oo
         DFyNNI+lF2F/PCygGYwneQXggfHOLTxgySV0TfBX4sSssgzcrVLOS+jNFreAzLYtPp+C
         dmLg==
X-Forwarded-Encrypted: i=1; AKwUvBx4DU9P1qYWcjdsFRneX2gd55DuzrNc2td1tY1NQ5rodVTexVI9PReIwpEa4E3iLAAMbnK92rFPsnOQNWeqhA==@vger.kernel.org
X-Gm-Message-State: AFuF++ndHOJ4DHm6Uvgcw506wGoYsCDuY3bUNW+KWwiQZ5BNibWnVRsB
	JpCMBvbis2A1zmhKFXXFjN0FV0RAMXAGERRCchunbPVFcGqn0ikS8NQLTM/OyUzmfMuXlim4Zmo
	ZhcIGTvchbnqfGWzI9s0srIVLAXJW14dRRkq+IPDInNay+IvZq4yZ1nc8Kr/JDhjpRbwJ
X-Gm-Gg: AYBFou3tGmY54rzpVMbS4y/wMebdsVWQFOBN/B/86pMEdJqQQSUW007cNpDB9dmdI+V
	k+MCBBiWfGCudgBKuHul3eKzGekQ2U6B5RTXrwSrNk5XEI5j9uFIsvAzwP4vNspO5PurFOnf2oY
	+QuSVdloDkcLW680SBTMCIwGkk7kyOFYPqg4wlWSn1AQoQAdq1tnHCNREb36kz19co7wmhzqY1K
	g9LmbYuZJlWtkbL1mN3zoOZnme5e36wKQUHZbDl3SFn/1osqa5tQqsmf+bmtzHaS+84YK5BgJCL
	qTogCHyfeipLG7bx5qRHnTxmgPCVd4PVhkGyv1FcvnpiB18yLIWfzUU71YNbPrS3nMzVlahnp8V
	UjqyuEDtqQzDbQaYcsnZn/l76uVGsks6YsDbD50xgFLN3HlWHQpdodwdqJZI+JiMbBcFEurYPLP
	h+FvLTWHo0thYRFqzK3aN42w==
X-Received: by 2002:a17:90b:264c:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-39b2612f7dbmr44616563a91.10.1788887447365;
        Tue, 08 Sep 2026 10:10:47 -0700 (PDT)
X-Received: by 2002:a17:90b:264c:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-39b2612f7dbmr44616272a91.10.1788887445127;
        Tue, 08 Sep 2026 10:10:45 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:44 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 10/18] wifi: mac80211: Define SMD BSS Transition context for transport
Date: Tue,  8 Sep 2026 22:39:38 +0530
Message-Id: <20260908-smd-v1-10-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=VN3tWdPX c=1 sm=1 tr=0 ts=6aa0419a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=J9-iD1ZZfo0dXw_rko0A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: RnPyTGdV1x7Sc3wPDe5wpIVV_nATvzeX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX4MnE2yFhdSkr
 5wjAN/++WF9Czt3F1V1XG9In6rEKZ3TORAxqFEXO3GuOvBlQb+VAxR28Whon904p55kZK+E6HmZ
 k7/wRbmVMyq0lCkr2YeZjXJNFWEI3k4=
X-Proofpoint-GUID: RnPyTGdV1x7Sc3wPDe5wpIVV_nATvzeX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX1w6luKQH8kFY
 ZCiZBxqsDd4mDgi04KbOSTGS5vbL/Cm7UCpHnfpv/uLRUwpyv20OodyfGxczrf0nPnuNLW7Gr8u
 9IuDlYWFra1F96G6V2ZZqI2MiAB8tZHPaNzy4OGW+GJkot2PL2kB1vbQZGd/M2cS9voiQPt04TF
 Px1ITnO/AA07mBylbMuw+3S7qER5Fg59nWPVY1Qz3+x+DeJgG08u/1cIt8+/geGa8ILU2iLBQns
 KfPD0Umz4bga/3kQAz/MBhsk5lO1aoAaNmg+gOlR0cOshS1uMFEmGm46OfW+OLpPraMQDhcx4Lh
 azT0eZD2PIdciJfkfRrk3a19R3paHOWF+pAJB35udG0GGC7ITKE6TPJvnimHyFsg9kJYzD7+kw6
 Q4tkEOddlYs1MQMuxWc0tfCibhj1l1CJ8Wk6ND6/cfpIXC6Ob3uhbm6Ntb+RcUt019gNx2Werc9
 Bcm1UMI3YLu9OTE1cnQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9, defines the context
data to be transported during SMD BSS Transition (ST) laid out in
subclause 37.16. The station's context data is attached to the ST
Preparation or Execution management frame using SKB extensions so that
userspace receives the context along with the relevant frame.

Define the context data - per-TID sequence numbers in downlink (DL) and
uplink (UL) directions, packet number in DL, per-TID packet numbers in
UL, and per-TID BlockAck session parameters in DL and UL, plus a
variable-length driver context - to be used by the driver to attach the
context to the frame SKB. Additionally, define a helper that attaches
the SMD context to the SKB extension so that the initialization
operations (container allocation, reference tracking, and context
linking) are properly handled.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h | 86 +++++++++++++++++++++++++++++++++++++++++++
 include/net/mac80211.h        | 50 +++++++++++++++++++++++++
 2 files changed, 136 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index c3f87d4c8bec..f904b1e65f10 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -649,6 +649,92 @@ struct ieee80211_uhr_mode_change_tuple {
 	u8 variable[];
 } __packed;
 
+/*
+ * Context information carried in SMD BSS Transition (refer IEEE P802.11bn/D2.0,
+ * Aug 2026, subclause 37.16.9.
+ */
+#define IEEE80211_SMD_CTX_NUM_VALID_CTX    8
+
+#define IEEE80211_SMD_CTX_VALID_DL_SN      0
+#define IEEE80211_SMD_CTX_VALID_UL_SN      1
+#define IEEE80211_SMD_CTX_VALID_PN         2
+#define IEEE80211_SMD_CTX_VALID_BA_PARAMS  3
+/* Positions 4 to 7 are reserved */
+
+/*
+ * Data TIDs transported in the context, IEEE P802.11bn/D2.0, Aug 2026,
+ * subclause 9.4.2.364.
+ */
+#define IEEE80211_SMD_CTX_NUM_TIDS 8
+
+#define IEEE80211_SMD_CTX_MAX_PN_LEN 16
+
+/**
+ * struct ieee80211_smd_ctx_ba - BlockAck parameters for DL and UL
+ *
+ * @amsdu_supported: Peer's capability to support A-MSDU within A-MPDU.
+ * @ba_policy: BlockAck policy (0 = delayed BlockAck, 1 = immediate BlockAck)
+ * @buffer_size: Reorder buffer size from ADDBA Request (10-bit, max 1023)
+ * @timeout: BlockAck session timeout
+ * @ext_no_frag: ADDBA Extension fragmentation support
+ * @extfrag_level: ADDBA Extension HE fragmentation level
+ * @ext_buffer_size: ADDBA Extension buffer size; combined with @buffer_size as
+ *	(@ext_buffer_size << 10 | @buffer_size) to get the full reorder
+ *	buffer size
+ */
+struct ieee80211_smd_ctx_ba {
+	bool amsdu_supported;
+	u8 ba_policy;
+	u16 buffer_size;
+	u16 timeout;
+	bool ext_no_frag;
+	u8 extfrag_level;
+	u16 ext_buffer_size;
+};
+
+/**
+ * struct ieee80211_smd_ctx - IEEE 802.11bn SMD Roaming Context (refer
+ *	IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9)
+ *
+ * @valid_ctx_bmap: Bitmap indicating which context fields are valid;
+ *	bit positions defined by IEEE80211_SMD_CTX_VALID_* constants
+ * @pn_len: Length of PN in bytes; varies by cipher type
+ *	(e.g. CCMP (6), GCMP-256 (16))
+ * @dl: Down-link context data
+ * @dl.valid_tid_bmap: valid DL TIDs for which context is present
+ * @dl.sn: DL SN per-TID to be assigned next
+ * @dl.pn: DL PN to be assigned next
+ * @dl.ba: DL BlockAck parameters per-TID for the BlockAck session
+ * @ul: Up-link context data
+ * @ul.valid_tid_bmap: valid UL TIDs for which context is present
+ * @ul.sn: UL SN per-TID to be checked next
+ * @ul.pn: UL PN per-TID to be checked next
+ * @ul.ba: UL BlockAck parameters per-TID for the BlockAck session
+ * @drv_ctx_size: Number of valid bytes in @drv_ctx.
+ * @drv_ctx: Variable-sized array of driver-specific context, counted by
+ *	@drv_ctx_size. Opaque to the wireless core; interpreted by the drivers.
+ */
+struct ieee80211_smd_ctx {
+	DECLARE_BITMAP(valid_ctx_bmap, IEEE80211_SMD_CTX_NUM_VALID_CTX);
+	u8 pn_len;
+
+	struct {
+		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
+		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
+		u8 pn[IEEE80211_SMD_CTX_MAX_PN_LEN];
+		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
+	} dl;
+	struct {
+		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
+		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
+		u8 pn[IEEE80211_SMD_CTX_NUM_TIDS][IEEE80211_SMD_CTX_MAX_PN_LEN];
+		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
+	} ul;
+
+	size_t drv_ctx_size;
+	u8 drv_ctx[] ____cacheline_aligned __counted_by(drv_ctx_size);
+};
+
 static inline int
 ieee80211_uhr_mode_change_tuple_size(const struct ieee80211_uhr_mode_change_tuple *tuple)
 {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 32b9b7cd1685..b4b1d3db9b19 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
+#include <linux/skbuff_wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/lockdep.h>
 #include <net/cfg80211.h>
@@ -8246,4 +8247,53 @@ bool ieee80211_vif_nan_started(struct ieee80211_vif *vif);
  * Return: 0 if success and non-zero on error
  */
 int ieee80211_encrypt_tx_skb(struct sk_buff *skb);
+
+/**
+ * ieee80211_skb_ext_add_uhr - attach or replace a UHR SMD context on
+ *	SKB_EXT_WIRELESS
+ * @skb: the SKB to attach the extension to
+ * @ctx: the SMD context; must be a kmalloc-ed buffer by the caller
+ *
+ * Allocates a &struct wireless_skb_ext_smd_ctx container, sets @ctx to it with
+ * @refcnt initialized to 1, and attaches it to @skb on SKB_EXT_WIRELESS.
+ * If SKB_EXT_WIRELESS is already active, the existing @container is released
+ * before the new one is attached.
+ *
+ * Ownership of @ctx transfers to @container on success - the core will
+ * kfree() both when the last reference is released.
+ * Upon error, @ctx ownership is not transferred from the caller; old @container
+ * may get freed.
+ *
+ * Drivers must use this helper to attach SKB_EXT_WIRELESS extension to
+ * properly handle clone and COW copies.
+ *
+ * Returns 0 on success; -ENOMEM on allocation failure.
+ */
+static inline int ieee80211_skb_ext_add_uhr(struct sk_buff *skb,
+					    struct ieee80211_smd_ctx *ctx)
+{
+	struct wireless_skb_ext_smd_ctx *container;
+	struct wireless_skb_ext *ext;
+
+	container = kzalloc_obj(*container, GFP_ATOMIC);
+	if (!container)
+		return -ENOMEM;
+
+	refcount_set(&container->refcnt, 1);
+	container->smd_ctx = ctx;
+
+	skb_ext_del(skb, SKB_EXT_WIRELESS);
+
+	ext = skb_ext_add(skb, SKB_EXT_WIRELESS);
+	if (!ext) {
+		kfree(container);
+		return -ENOMEM;
+	}
+
+	ext->uhr_smd_ctx = container;
+	ext->type = WIRELESS_SKB_EXT_UHR_SMD;
+
+	return 0;
+}
+
 #endif /* MAC80211_H */

-- 
2.34.1

