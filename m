Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA773E40F3
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217743; cv=none; b=pYxsXzE7rdh52yDzSGovwgvLYfiIKBIgsgZWr1sAZWRCSuW5HnsGK00l8+agnuHiVv7ESvRoom2HOLanQGeNOj+9k+/EudwW3cIq4VI6HgujxBn2DU7qD/UQQJnDkkVx4lm72FnS79gXsKU1ayUhvvMlWSb476V4Y45ttvD8nx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217743; c=relaxed/simple;
	bh=G5Z8Q4mrpaJUYhgg7Iye7c1HxPEKe3dEZvEpQlOglWk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TK05vCtaRkCmu9pVxr3jEnPY/JelNr9pPVysva2++4NmyoqhlkkZBdNfG2NCsd13p38050VWNeEUZyNea3WiujLagskECPtWzqrguLJsvlaumCinem0Ek7OCM54Sp++YQHiXLmLHojwTslKCDvDeWi5xVI2YkjzG17vJFnbo/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ppsID+Ns; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bh0VLZHw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ppsID+Ns";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bh0VLZHw"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2KKEn1852021
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mrsSw/baF5mdn64qF1y1HmmUd+kBtiEK8BpufQrVGb4=; b=ppsID+NsaiLeMwci
	dV/UART6Me3o/UbCghH9DUGkqJhRYcRgz3spb2v9CniICxHjI51i43LV4p0d3ecF
	Ku+4JZt/XyUWHaQMvMBMyqWN6xN59i5vq7X7Vyffky7e6/ASOLNQzqjgZIsoQ82o
	tf0wbZmc7L7AK0qdvYqaDcD3HvSSph7Kx+rUDW/TY7W+2/Ua+Ce4n0/G148J1ayY
	EuC3jHEGylabVkgt3MgzcRPiPPVjdGpZOwIZGNiMmrAEOGJn0yxc2f3ZrUyOjpyA
	nYH1CZCHGsXh5t412E/xXU99+nNHcwYfmIvKyXa7TY7JJZLY2LdpV4Rsltf80iKb
	dYwCYA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjxtx3e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:20 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33310847fcaso2831411eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217739; x=1790822539; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mrsSw/baF5mdn64qF1y1HmmUd+kBtiEK8BpufQrVGb4=;
        b=Bh0VLZHwBlKunZUaky5tg6sa0dF3w9tJNe9Z8GHySe7cd1JcnLMuKGzNksmpR8B5QU
         HBNIoU8VRulhLUFFEhNVDfMenUw+FJxp6F3+/9STNjge1Q/wFIXDU6/Y/98oLt9ftAYt
         hz3MBrUwwr5mefwVpu8O58H7BqajdrrFRrPOIXULSUUa7dqcnzvOiBB8dFGko3KwZbES
         BOCkzzVwQHlibqKlBMF1cuYF25fqId0O74728aDTHjbp+jPw0wNSBLQ0/eRrmBn4Cvzr
         EwdBzGoUzV+Jp2ULQmI+p7WdEPBBRg6bbXSCT5fqSqKy9XXbrODlNRnhprPVN2sIxt9O
         74hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217739; x=1790822539;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mrsSw/baF5mdn64qF1y1HmmUd+kBtiEK8BpufQrVGb4=;
        b=dQ25vINyajpgLKrFOYwfMie/xeUZTrSZv+K9CmxLeWTjnXqfEZ1GFbY5XaPpQWiC/C
         QYCpfRyxEEnoDg3MLDJWKKq8Y8JbqJuqKYv/ji86Co7GbNaw7boP8ok95WtN/ySn8gAZ
         5htd7jjXDqoOm9RG79SsQsn6uItWke0fM70DIHEM4u9HL6QJSoU9Y71cNKnHQW6jxrD0
         hXlE8PFhxJYqKmOT6i83DMP1MS1Yd0fKUMkf0Xgdm1WjupX5IAIc+oQL23Dpra0e8to3
         cLoTjiGvkcBrSWndPZkCjYXAU5xvIcoPouvKSVcGO1gLoIQqIz4Mv6Anvs6o8+bogEda
         o69w==
X-Gm-Message-State: AFuF++nf4Yfx7RKZtAv9vzXpxH86cvG9cSY7AgVUGJYQp5XTG38e+xHF
	tDGHNcoRmqY8SZFUNHnVBmee88+nx7KhEVs86pucdRAkzTpdhrotAO8ubfLQX15LzAXbA2xkXEF
	swuDy2+t/uvd1EGH22fGYfE/ca2Rs6iEbExdJGzAy/b5BBpnMj7eohRghz52TLbKC9g9NA8y50Q
	2c
X-Gm-Gg: AYBFou3hgkTyaGl6CjsBGBUv1PV59XofZvgQhdsy4EDSGeyz4D29Lc9TN/nWzMUHGHW
	cWtNm7YX3H4n4M9EvSHq01r/I5f3QFXfumhin6OsCECRhx73Bm3pw+oCcBdLEmTBLsATW09lkyp
	Pbv0rSV5lHVKpsu4Cj98IyZtS7ujM9bDO5w150g/DIUg3lnrYjcsKnf9MPjwRyK0R/4XhjBUimh
	3qq3yePyrNNSnZBmv5+/01xX9s9c7JHebz4OvjPAEJwjb9lVo8t+whhkiBz1Gf6T+hSgTMBN3Rl
	mTM6TwCcZ16ZwbwyxyIgLopAKoMynpFLex2H/3Kb7i7yBnVfH3KHiD30QJsgJAMxk/qHgy0waKv
	eZQMqxTGAocqsr3rw1FCaZ8BVPKhGWo9FEEer7CL2fsq3Y78oWwaExYLEO4kTN0jXX2jIqlvIsz
	+ErFUk7oGyENYZVPzlqAbU5g==
X-Received: by 2002:a05:693c:41db:10b0:339:7204:9490 with SMTP id 5a478bee46e88-34001917564mr719278eec.39.1790217739099;
        Wed, 23 Sep 2026 19:42:19 -0700 (PDT)
X-Received: by 2002:a05:693c:41db:10b0:339:7204:9490 with SMTP id 5a478bee46e88-34001917564mr719259eec.39.1790217738293;
        Wed, 23 Sep 2026 19:42:18 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:42:17 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:52 +0530
Subject: [PATCH wireless-next v2 15/16] wifi: nl80211/cfg80211: Add support
 for querying SMD context for target AP MLD
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-15-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: U8s3D8_-o13UvfeMjRG9X9x4ID4gi2qq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXxy/9FC+LsgYd
 4T9Vbn6ogjqNgMxo8tvOOkstZ3eE5kjEHzWtCpvd9BuIwiiXgy9Hu6kogUO+fZp5oykrT8Tuo9q
 Xr5qaxcl9YgvR72VEatCEwIr/px69uT63DMXkI779DEETvEXF1zYWDdb0MlWz0GTKArLK/F8NVk
 8vtOdZyhjLR2aNPqlEIjMlgyfE5zCCrS0sjjRL5MNSrW54LSwI1O/zIegPj3XqZM1CC7jPZ6gms
 utWTRgxGUDT28G1dgBwi+oxA7ngnl2GOJW1PjBuYTBP8lUsZL0xC39crKrlzewNkUBTXTdHORoG
 nVfkiV73jJr/Op0k1+SDX4opXodn7yahsvehKH0KqU0p4tbpNyka4jRcby718ygFJL66njEaoiw
 6ae2uVkv9mTRgA2rXvmLUyA5ON67McSUdIq1O9ry2uAGJWsaniRIOB5RQOKfIEiYU81bVhHQ+43
 S7kD37WH+rTChXpUjtA==
X-Proofpoint-GUID: U8s3D8_-o13UvfeMjRG9X9x4ID4gi2qq
X-Authority-Analysis: v=2.4 cv=NLpAaE6g c=1 sm=1 tr=0 ts=6ab48e0c cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=hdw18t4awISUpvPuE2cA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX2XAC4ZCaNUKN
 pAM774eI7fkEzeTwcd2b7fkQ+zj1hK0gMGdXcS3g4CM4C8Y8qMsRAvkGOSBTbSBh7X2lDyoK5jz
 5abNZvruBmdKrFwcFPH5kwv4l/fidFE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

During SMD BSS Transition, the non-AP MLD that has been prepared with a
target AP MLD may send the ST Execution frame directly to the target AP
MLD. In such scenarios, the target AP MLD should pull the context from
the current AP MLD to program TX and RX queues.

Add nl80211 support to handle NL80211_CMD_GET_SMD_CTX, which is sent by
userspace of the current AP MLD on behalf of the target AP MLD. This
command carries the context type to indicate to the drivers which context
needs to be collected. Once the collection is complete, the context is
sent back to userspace as an asynchronous multicast event using
NL80211_CMD_SMD_CTX_EVENT with full context data carried in
NL80211_ATTR_SMD_CTX.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h  |  53 ++++++++++++++++++
 net/wireless/core.c     |  25 +++++++++
 net/wireless/mlme.c     |  30 +++++++++++
 net/wireless/nl80211.c  | 140 ++++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h  |   9 ++++
 net/wireless/rdev-ops.h |  14 +++++
 net/wireless/trace.h    |  26 +++++++++
 7 files changed, 293 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab003692f00e..71711dbbf749 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4900,6 +4900,16 @@ struct cfg80211_smd_transition_info {
 	enum nl80211_smd_ctx_type type;
 };
 
+/**
+ * struct cfg80211_smd_get_ctx_pending - pending async GET_SMD_CTX request
+ * @list: linkage on wireless_dev::smd_get_ctx_pending_list
+ * @sta_addr: non-AP MLD address for which context was requested
+ */
+struct cfg80211_smd_get_ctx_pending {
+	struct list_head list;
+	u8 sta_addr[ETH_ALEN];
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -5335,6 +5345,8 @@ struct cfg80211_smd_transition_info {
  * @set_smd_ctx: Set UHR SMD context data for the non-AP MLD. @st_info->ctx is
  *	freed immediately after this call returns; drivers must copy
  *	@st_info->ctx if asynchronous processing is required.
+ *
+ * @get_smd_ctx: Get UHR SMD context data for the non-AP MLD.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5716,6 +5728,9 @@ struct cfg80211_ops {
 	int	(*set_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       const u8 *addr,
 			       struct cfg80211_smd_transition_info *st_info);
+	int	(*get_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       const u8 *addr,
+			       enum nl80211_smd_ctx_type type);
 };
 
 /*
@@ -7288,6 +7303,8 @@ enum ieee80211_ap_reg_power {
  * @links.cac_time_ms: CAC time in ms
  * @valid_links: bitmap describing what elements of @links are valid
  * @radio_mask: Bitmask of radios that this interface is allowed to operate on.
+ * @smd_get_ctx_lock: lock to protect pending get_smd_ctx requests.
+ * @smd_get_ctx_pending_list: list to track pending get_smd_ctx requests.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -7407,6 +7424,10 @@ struct wireless_dev {
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
 	u16 valid_links;
 
+	/* protects @smd_get_ctx_pending_list */
+	spinlock_t smd_get_ctx_lock;
+	struct list_head smd_get_ctx_pending_list;
+
 	u32 radio_mask;
 };
 
@@ -11085,4 +11106,36 @@ void cfg80211_incumbent_signal_notify(struct wiphy *wiphy,
 				      u32 signal_interference_bitmap,
 				      gfp_t gfp);
 
+/**
+ * cfg80211_free_pending_smd_ctx_req - Free remaining entries in the
+ *	cfg80211_smd_get_ctx_pending list.
+ * @wdev: wdev that maintains the list
+ * @addr: if @addr is NULL, drain the entire list; otherwise, drain only the
+ *	matching entries
+ *
+ * When the current AP MLD requests the station's context, those requests are
+ * maintained in a pending list until drivers notify completion. In case the
+ * device is brought down or the station is removed prematurely, free up the
+ * remaining entries in the list.
+ */
+void cfg80211_free_pending_smd_ctx_req(struct wireless_dev *wdev,
+				       const u8 *addr);
+
+/**
+ * cfg80211_get_smd_ctx_done - deliver async GET_SMD_CTX result to nl80211
+ * @wdev: wireless device that handled the request
+ * @sta_addr: non-AP MLD address the context was collected for
+ * @st_info: SMD BSS Transition Info (set @st_info->ctx to NULL to indicate
+ *	failure)
+ *
+ * Called via ieee80211_get_smd_ctx_done after async driver context collection
+ * completes. Finds the matching pending request and sends a multicast
+ * %NL80211_CMD_SMD_CTX_EVENT reply to userspace (MLME group).
+ *
+ * Return: None
+ */
+void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
+			       const u8 *sta_addr,
+			       struct cfg80211_smd_transition_info *st_info);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691..129af6ba5fda 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1405,6 +1405,25 @@ void wiphy_rfkill_set_hw_state_reason(struct wiphy *wiphy, bool blocked,
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state_reason);
 
+void cfg80211_free_pending_smd_ctx_req(struct wireless_dev *wdev,
+				       const u8 *addr)
+{
+	struct cfg80211_smd_get_ctx_pending *pending, *tmp;
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_for_each_entry_safe(pending, tmp,
+				 &wdev->smd_get_ctx_pending_list,
+				 list) {
+		if (!addr || ether_addr_equal(pending->sta_addr, addr)) {
+			list_del(&pending->list);
+			kfree(pending);
+			dev_put(wdev->netdev);
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+}
+EXPORT_SYMBOL(cfg80211_free_pending_smd_ctx_req);
+
 static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 				      bool unregister_netdev)
 {
@@ -1477,6 +1496,10 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 		}
 	}
 
+	if (wdev->iftype == NL80211_IFTYPE_AP ||
+	    wdev->iftype == NL80211_IFTYPE_AP_VLAN)
+		cfg80211_free_pending_smd_ctx_req(wdev, NULL);
+
 	wdev->connected = false;
 }
 
@@ -1619,6 +1642,8 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
 	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	spin_lock_init(&wdev->smd_get_ctx_lock);
+	INIT_LIST_HEAD(&wdev->smd_get_ctx_pending_list);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a0d1cde26f0c..15e14f429c16 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1475,3 +1475,33 @@ void cfg80211_mlo_reconf_add_done(struct net_device *dev,
 	nl80211_mlo_reconf_add_done(dev, data);
 }
 EXPORT_SYMBOL(cfg80211_mlo_reconf_add_done);
+
+void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
+			       const u8 *sta_addr,
+			       struct cfg80211_smd_transition_info *st_info)
+{
+	struct cfg80211_smd_get_ctx_pending *pending = NULL, *iter;
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_for_each_entry(iter, &wdev->smd_get_ctx_pending_list, list) {
+		if (ether_addr_equal(iter->sta_addr, sta_addr)) {
+			pending = iter;
+			list_del(&pending->list);
+			break;
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	if (!pending) {
+		wiphy_err(wdev->wiphy,
+			  "No pending SMD ctx req for %pM found in %s\n",
+			  sta_addr, __func__);
+		return;
+	}
+
+	nl80211_notify_get_smd_ctx_done(wdev, sta_addr, st_info);
+
+	dev_put(wdev->netdev);
+	kfree(pending);
+}
+EXPORT_SYMBOL(cfg80211_get_smd_ctx_done);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 550f65634480..0de939495499 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19595,8 +19595,7 @@ static size_t _nl80211_smd_ctx_nl_ba_param_size(u8 n_tids)
 	return n;
 }
 
-static size_t
-nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
 {
 	const struct ieee80211_smd_ctx *ctx = st_info->ctx;
 	int n_dl_tids = 0, n_ul_tids = 0;
@@ -19708,8 +19707,8 @@ nl80211_put_smd_ctx_ba_params(struct sk_buff *msg,
 	return -ENOBUFS;
 }
 
-static int nl80211_put_smd_ctx(struct sk_buff *msg,
-			       struct cfg80211_smd_transition_info *st_info)
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info)
 {
 	struct nlattr *dl_sn = NULL, *ul_sn = NULL, *ul_pn = NULL;
 	struct nlattr *smd_ctx = NULL, *dl = NULL, *ul = NULL;
@@ -20506,6 +20505,92 @@ static int nl80211_set_smd_ctx(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static struct cfg80211_smd_get_ctx_pending *
+__cfg80211_get_smd_sta_pending_ctx(struct wireless_dev *wdev, const u8 *addr)
+{
+	struct cfg80211_smd_get_ctx_pending *pending = NULL, *tmp;
+
+	lockdep_assert_held(&wdev->smd_get_ctx_lock);
+
+	list_for_each_entry(tmp, &wdev->smd_get_ctx_pending_list, list) {
+		if (ether_addr_equal(tmp->sta_addr, addr)) {
+			pending = tmp;
+			break;
+		}
+	}
+
+	return pending;
+}
+
+static int nl80211_get_smd_ctx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_smd_get_ctx_pending *pending;
+	enum nl80211_smd_ctx_type type;
+	const u8 *addr = NULL;
+	int err;
+
+	if (!rdev->ops->get_smd_ctx)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_AP_VLAN)
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR] ||
+	    !info->attrs[NL80211_ATTR_SMD_CTX_TYPE]) {
+		GENL_SET_ERR_MSG(info, "required attributes are missing");
+		return -EINVAL;
+	}
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+	type = nla_get_u8(info->attrs[NL80211_ATTR_SMD_CTX_TYPE]);
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	if (__cfg80211_get_smd_sta_pending_ctx(wdev, addr)) {
+		spin_unlock_bh(&wdev->smd_get_ctx_lock);
+		return -EBUSY;
+	}
+	/* safe to unlock, concurrent commands are serialized by wiphy mutex */
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	pending = kzalloc_obj(*pending);
+	if (!pending)
+		return -ENOMEM;
+
+	memcpy(pending->sta_addr, addr, ETH_ALEN);
+
+	/*
+	 * Take reference and add to the list before calling the driver to avoid
+	 * race. Upon success, the reference is released while reporting back
+	 * the context or in the list removal and drain path.
+	 */
+	dev_hold(wdev->netdev);
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_add_tail(&pending->list, &wdev->smd_get_ctx_pending_list);
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	err = rdev_get_smd_ctx(rdev, wdev, addr, type);
+	if (err) {
+		/* revert upon failure */
+		spin_lock_bh(&wdev->smd_get_ctx_lock);
+		pending = __cfg80211_get_smd_sta_pending_ctx(wdev, addr);
+		if (pending) {
+			list_del(&pending->list);
+			kfree(pending);
+			dev_put(wdev->netdev);
+		}
+		spin_unlock_bh(&wdev->smd_get_ctx_lock);
+		return err;
+	}
+
+	/* Reply will arrive via cfg80211_get_smd_ctx_done() */
+	return 0;
+}
+
 #define SELECTOR(__sel, name, value) \
 	((__sel) == (value)) ? NL80211_IFL_SEL_##name :
 int __missing_selector(void);
@@ -21414,6 +21499,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_CLEAR_SKB),
 	},
+	{
+		.cmd = NL80211_CMD_GET_SMD_CTX,
+		.doit = nl80211_get_smd_ctx,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -24441,6 +24532,47 @@ void cfg80211_nan_channel_evac(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_channel_evac);
 
+void
+nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct net_device *dev = wdev->netdev;
+	size_t msg_len = NLMSG_DEFAULT_SIZE;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (st_info->ctx)
+		msg_len = 100 + nl80211_smd_ctx_nl_size(st_info) +
+			  nla_total_size(ETH_ALEN); /* MLD address */
+
+	msg = nlmsg_new(msg_len, GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SMD_CTX_EVENT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN, sta_addr))
+		goto nla_put_failure;
+
+	if (st_info->ctx && nl80211_put_smd_ctx(msg, st_info))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index bdb065d14054..2855d30ba354 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -129,4 +129,13 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
 void nl80211_mlo_reconf_add_done(struct net_device *dev,
 				 struct cfg80211_mlo_reconf_done_data *data);
 
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info);
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info);
+
+void
+nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d33a969606d7..ab520560f604 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1650,4 +1650,18 @@ static inline int rdev_set_smd_ctx(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_get_smd_ctx(struct cfg80211_registered_device *rdev,
+				   struct wireless_dev *wdev, const u8 *addr,
+				   enum nl80211_smd_ctx_type type)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_get_smd_ctx(&rdev->wiphy, wdev, addr, type);
+	if (rdev->ops->get_smd_ctx)
+		ret = rdev->ops->get_smd_ctx(&rdev->wiphy, wdev, addr, type);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 6234ceb9ebb1..a2662919b8f0 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4452,6 +4452,32 @@ TRACE_EVENT(rdev_set_smd_ctx,
 		  (unsigned long *)__get_dynamic_array(rx_tid_bitmap))
 );
 
+TRACE_EVENT(rdev_get_smd_ctx,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, const u8 *addr,
+		 enum nl80211_smd_ctx_type type),
+
+	TP_ARGS(wiphy, wdev, addr, type),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		MAC_ENTRY(sta_addr)
+		__field(u8, st_type)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(sta_addr, addr);
+		__entry->st_type = type;
+	),
+
+	TP_printk(WIPHY_PR_FMT  ", " WDEV_PR_FMT
+		  ", sta=%pM, ST type=%u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->sta_addr,
+		  __entry->st_type)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

