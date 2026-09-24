Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9293D810D
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217747; cv=none; b=Brq7nM4r11b9j0FUGZYwZM9lqvxj+6pvP1EOIqrhJuSGkmWHRXhHHVE/YESZP6bA/I3UmY7bUpanLBxS58FaKvb+eFVIGmysYJpEiLPaYa/KC0/+S4QlK7qb8RfHD5vWkGdPVnyyZtFKNnFfGQBhWdz6gv92Ao90Wvhkd6QAOiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217747; c=relaxed/simple;
	bh=5cnODwmbssOxPI5F5nevd+OQBmmnItipdocbwUtvPQk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NjaZFeh1haKgOh6k4Ktys9pho3Ns/QRrX0PcFvFuLTprJbfqRoV0OJZi/5x4Usmbas43If7/v/tl/ekgPsNGdicFA4oWy/akfg6Ek7zP+IKhFn+vWDky+Bf0WiWh+jLQJcRQrvlqa9SxywJSZWXMOSSN+dCYeidZ4eUlMLCPPj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FOpIjt9j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gl9unw3n; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FOpIjt9j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gl9unw3n"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2Jr2w1107764
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fLQsUrUtDIuno+/NSEW02njKLVWe0y6MbvL6C+eWsxg=; b=FOpIjt9jIaQjABSm
	VBafULKtg/stOJm5w9LcC8ZJDfrZsHwGefqWMluF6F08mV7lvIUsHXThp5GOGE0K
	K5k/Pt0SyKrV2/tiSDr8qfv3Ophfq5Bf0Bs4laIaQlxbrhJQrY80K/yqzoWgFs3+
	sfBDemC+mv+NCq6ArX+1UjC2JJp5Sql55tB3uCHaZQm1JuCpeXnRJC+QRDdaFhJn
	IWIge1Wp+qznfrIYQeArnWWrTiJZx7lUULHLmeIUjNr+cH3q+r/gLQsaG5mZgshl
	uSSNO77OqL3ysuQM+b5A6QOVDIaplJvhp1b01GNMuBg0KIoR5MS5uUW1QEzlAn09
	djHOiQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvsfgrb31-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:23 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33bb08e80a8so521269eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217742; x=1790822542; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fLQsUrUtDIuno+/NSEW02njKLVWe0y6MbvL6C+eWsxg=;
        b=Gl9unw3nrsFwutoSDtlP0oq7clKDWDG4G2zOGgSXOwfNyrlu0eJrid68hdardwxrdG
         8CaAgLe7+S8cKElMN+FXC91rQxg0uav9dhiyvHyjn5X09/p7MkJOppckFO1qPS28wwC9
         Zs29fCh3kb1/X5GwAYt0IW3sQHT/dME5aogYR/58Eanbt4NZNOp5pEMyUzOTE7Y4YjCy
         CqF2ylx7w60c6XnD8k5xaA9jxjQYoO5ARxK662Ia8wjN8fb1LsejpxiFPPJ7L2SRe9lc
         0Neqi4TpByT5IE4HkWWadZvlTSZ6KRzVMTAuEY1H3wSJX1ykkS+Q42PHlRKQ9H3nY2O9
         HGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217742; x=1790822542;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fLQsUrUtDIuno+/NSEW02njKLVWe0y6MbvL6C+eWsxg=;
        b=jTaYXK/zguxwvHC0EAJYGGGSXSfkpnzqYgIxFD77iqNEpuwxpmJE+ZdvfezMZ3b6cu
         HwJVUhP3piJDy/XHlniOgxy0QguaGauCcc3MUb/XyvIhGTTMI2yRUyrv/lCwti5z5Noe
         4Ryc98Aa/DBfhv3SHpbNwcMJ7BOUQQ5hBmJtROE2LFIEZS9fdwhXF4ql3yNa+W/qI5+D
         JHYoom00dq47eYDR1Lk0vDjUos2xJl3T6iPvEEHF/8JTJiPDm/dTn2mH++nAOtgrQbwu
         qKKBCGcYyVGB21Cbcd1pCdFI+1OI5gCZ4mbGAUZEOGEM3FNXXcWZBHO8mGeKcfH1hECy
         9b6g==
X-Gm-Message-State: AFuF++nM8qkV70/LIVbhuEqIitGT/yJwix2Q/YdN099kIAJjr32zyRlS
	gkz/AsR0o1vbdz0IwGOtlWiCFxxQ30UQiPMrJecOQeEb5M3wT3EyfInl2Tx/Se1FjtPe3rpR2jO
	Gk72A9q1i8w7cQaO7vqmhBFpt/uEZTcukq+RCHpF9l9FQjJAPuckAsm3XK6a2P51PxCo/inLjey
	q+
X-Gm-Gg: AYBFou3f7oYB2uDwhYk7+uQ63dRrWbre2UzByCYPMwjlT7Sf+WyHw2hUNRmkX57qyIi
	goLmxhLzQ5Vz15SxLZteqNMoaetTipwMxD2cyanyfzPeGnVRYNxvuEKVXdruLukvuFpdrPy4/mQ
	anRrbd2l4GJLIbLPKt/FlGxIb+3yVwd4PuCnVhlCG4eXWPvuCt66e2xnCWLwyaTf+OfkeIF3FQW
	avGgTxywQaHLEHR15ltG8SwOjpZvw2Lr+/aKtMySXxUKVEM7WDm2ryZ0zvIiJSLnvfIe3IFirxE
	o9Sjz0d/z3OWA+k7VK+q0wIVTxX12D97gKsAXsF0ik6VaoDZCdTphfLTq9NKfGr8xIFTaP7u6rB
	4tunAeq0eXbYPS0tebr61Z49847E+1wou7pQq3nWToQqwdqLFxOU9sg6P67L8l9jhoPNfXTO/8n
	iXBbwFr+YmaSHEiZm0pXy10w==
X-Received: by 2002:a05:693c:62cd:b0:339:851c:4c1 with SMTP id 5a478bee46e88-340059652f1mr673155eec.18.1790217742046;
        Wed, 23 Sep 2026 19:42:22 -0700 (PDT)
X-Received: by 2002:a05:693c:62cd:b0:339:851c:4c1 with SMTP id 5a478bee46e88-340059652f1mr673134eec.18.1790217741409;
        Wed, 23 Sep 2026 19:42:21 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:42:21 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:53 +0530
Subject: [PATCH wireless-next v2 16/16] wifi: mac80211: Add mac80211
 support to handle NL80211_CMD_GET_SMD_CTX
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-16-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=YfoodARf c=1 sm=1 tr=0 ts=6ab48e0f cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=c93CP5vvwBK-QZUl55wA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: 2yfAhVi7d8-CprV1x5n31XNHhrd4bGdm
X-Proofpoint-GUID: 2yfAhVi7d8-CprV1x5n31XNHhrd4bGdm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX+ebYlQ3OjTxD
 QLheY2/PleME4pcAzI+yHDg1QvDcVSoPqESKoWjWbkDy7Gxbbk8ce+9Hd6UOd7Xdzwnp838kxQw
 d/enmvwRw7QZzr/UESmx7fllM8j8JSY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX/b4u3iOI6LP7
 UBbTLaaQkFLyXzxDndTM01NUWFs8ziFZBctyE40K5f0Er1mxmjXTIxnPPVHVWJDDuAlHc7Xo2xF
 9K7/qY20XeBPj/EGlckmTQojff7MHf6PEIhCLNKcfjdWAXmsYdKqCytsNf7JC9pPSaTXqt+HmXT
 VUFkFd9BBEVpH8lhlHEismiG9mRwDy/aIW82WRGR2AopDy5K2pr0a2iDRRQkqHlgGoZ4++erJ64
 UPzfCRl9qeRrBtVshJVJLitRdr6I+41IAuVuaosADuRrpDVvSP8bKq9+f0j9ofnIjiq/epa1J1I
 3sWxExqe2PVSYVdMWP3LcFgdyJD+41BqxuBN50imbt92azUAvJFuT+bKnCfAWDoft0eY1JwAGPr
 DF4DssjIKTNph9yCKdGzGPGfAmyGqLv2TLs2yGcoUzkBmTj3qjnAcFb/A8ONZAqNFh33HC+4s9J
 EU4b23D9lUF7XyaLKug==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240012

cfg80211 supports NL80211_CMD_GET_SMD_CTX from userspace on the current
AP MLD to collect the station's context on the target AP MLD's behalf;
this context is used by the target AP MLD to program its TX and RX
queues to support seamless roaming of the non-AP MLD.

Add mac80211 support for the same to invoke the driver to collect the
requested station context. Since context collection is asynchronous,
the driver reports the collected context later via
ieee80211_get_smd_ctx_done(), which then packs the context into
NL80211_CMD_SMD_CTX_EVENT and delivers it to userspace as a multicast
event.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h    | 19 +++++++++++++++++++
 net/mac80211/cfg.c        | 36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 24 ++++++++++++++++++++++++
 net/mac80211/sta_info.c   |  6 ++++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9b451628f248..6a26823799d4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4788,6 +4788,11 @@ enum ieee80211_sta_smd_state {
  *	The callback can sleep.
  * @set_smd_ctx: Set the UHR SMD context for the non-AP MLD. This is used on
  *	the target AP MLD side to program dynamic context.
+ * @get_smd_ctx: Get the UHR SMD context for the non-AP MLD. This is used in
+ *	the current AP MLD side on behalf of the target AP MLD to collect
+ *	dynamic context, when the non-AP MLD sends ST Execute frame directly
+ *	to the target. Since the response is asynchronous, the drivers that
+ *	implement this should not store reference to @sta.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5197,6 +5202,9 @@ struct ieee80211_ops {
 	int (*set_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
 			   struct cfg80211_smd_transition_info *st_info);
+	int (*get_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   enum nl80211_smd_ctx_type type);
 };
 
 /**
@@ -8266,4 +8274,15 @@ bool ieee80211_vif_nan_started(struct ieee80211_vif *vif);
  * Return: 0 if success and non-zero on error
  */
 int ieee80211_encrypt_tx_skb(struct sk_buff *skb);
+
+/**
+ * ieee80211_get_smd_ctx_done - Deliver async get_smd_ctx result to nl80211
+ * @vif: virtual interface
+ * @sta_addr: non-AP MLD address the context was collected for
+ * @st_info: SMD BSS Transition Info (set @st_info->ctx to NULL to indicate
+ *	failure)
+ */
+void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2cf0e80137a7..95b699117147 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6106,6 +6106,41 @@ static int ieee80211_set_smd_ctx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	return drv_set_smd_ctx(local, sdata, &sta->sta, st_info);
 }
 
+static int ieee80211_get_smd_ctx(struct wiphy *wiphy, struct wireless_dev *wdev,
+				 const u8 *addr,
+				 enum nl80211_smd_ctx_type type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+
+	lockdep_assert_wiphy(wiphy);
+
+	sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
+	sta = sta_info_get_bss(sdata, addr);
+	if (!sta)
+		return -ENOENT;
+	if (!sta->sta.smd_params.smd_sta)
+		return -EINVAL;
+
+	return drv_get_smd_ctx(local, sdata, &sta->sta, type);
+}
+
+void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_get_smd_ctx_done(&sdata->wdev, sta_addr, st_info);
+}
+EXPORT_SYMBOL(ieee80211_get_smd_ctx_done);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6225,4 +6260,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.nan_set_local_sched = ieee80211_set_local_nan_sched,
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
 	.set_smd_ctx = ieee80211_set_smd_ctx,
+	.get_smd_ctx = ieee80211_get_smd_ctx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e764dd394de2..0339ff71cd4a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1844,4 +1844,28 @@ static inline int drv_set_smd_ctx(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_get_smd_ctx(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_sta *sta,
+				  enum nl80211_smd_ctx_type type)
+{
+	int ret;
+
+	if (!sdata || !local->ops->get_smd_ctx)
+		return -EOPNOTSUPP;
+
+	sdata = get_bss_sdata(sdata);
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_get_smd_ctx(local, sdata, sta, type);
+	ret = local->ops->get_smd_ctx(&local->hw, &sdata->vif, sta, type);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5aa6f5b481e3..9ea0a8791289 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1312,6 +1312,7 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
+	struct wireless_dev *wdev;
 	int ret, i;
 
 	might_sleep();
@@ -1321,6 +1322,7 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 
 	local = sta->local;
 	sdata = sta->sdata;
+	wdev = &sdata->wdev;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -1390,6 +1392,10 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		cfg80211_free_pending_smd_ctx_req(wdev, sta->addr);
+
 	return 0;
 }
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 7aba79e441cf..38ad5076232d 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -3487,6 +3487,33 @@ TRACE_EVENT(drv_set_smd_ctx,
 	)
 );
 
+TRACE_EVENT(drv_get_smd_ctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 enum nl80211_smd_ctx_type type),
+
+	TP_ARGS(local, sdata, sta, type),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, st_type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->st_type = type;
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT ", ST type=%u",
+		  LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->st_type
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

