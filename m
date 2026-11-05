Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907645;
	b=iKtL9yq3FTkZY99pSKs7ufFXnCtRqdrbd2F+QEX7C6MPQbJQ/wnG4tPxR/DFmz6ScGxW
	 du0z3zC3g1BxEOYqqGwaefXmOMt5lXifois1wL/IOCEe2ze3VboXfwAIqALnmRSnVIiMf
	 m2ykHdyFe5KdZwEY5umBIf/eYRCScvpW9Jt4gS16ME67+rhdfNp2cbVfLW9y4DDODLp5U
	 MPLBNKbshhaPq3TgJiqKub6ZHmCO/QsYIssduz5JUP4iD0Wh3v5PbQXdUri5hZIVwzr/6
	 6VP5s5ONo+GWUToqxjll+k67lmoykSp/DEZ7uWzCK4Tj6eKm3y5IYdF0hQBfKK3/hUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907645;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=;
	b=klTwRPzs87sJ5QHaQDfUqkNRs627tY+EvX1tav90AAQjI5XdodgYPKV5xmToseggWacc
	 AipQolJSxeuTrqgc8mApq4DaaNJjzgKjO4t6SkFIdLIVEwl5iMEZ5YTUq+INtHNoGukCk
	 tuIFCLq7GUfnDKXkGbIYOfvPkP4BapGdi5R15zlReoVmEwaNFSADGPjmK6mFsvjefFkuY
	 lpHyZFhSGfsB6UeDFZp66Xb+OFq5P2aEYiVQWSt0KTUkYTK1jnA17Xsrlr2p2swYU5FAK
	 CBCQqWxR/KI8Y4B2M/txb2XsKYAYsNjma0oRpPIPmWS4NLOnQsZF1CJ44vjsjXUOaCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="n9Os/i2j";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dKc0R0sU;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600BA607F40B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 600BA607F40B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=n9Os/i2j;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dKc0R0sU
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5JLNVO597527
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=; b=n9Os/i2jn8OCc51C
	GJAkBkh+ydXnc1Ld7iC7QTg/lXJYBqQFb9ENL8kPTnycZc4qWrOuJcCYzAV1SYFA
	lUJSpjqmeHPV+JGPuO/e8u77jqSYsL9Zl+SWjMxX1CBXHHhdcpGd72SWgUIvnJDj
	2s3enzrm1tMUkVDsIUXDasbjclD4bd95Uq8yHcw6w/DpTdA9KN2BBDxwQSe8qFv8
	WhNYcSTgz8vvwusyC2ehNsFN6S64b3OnONQEFqRNSHIC6r3pM99LVsLqvucqZvoG
	iUTW5goEbi0YVoeJ+Lh1qJ/hoGR72Oo/pKWmrFOblUdluW3nfoyaHMA7plLSsqCV
	/GyjEw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hryvv02t6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:43 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-351788121cfso4236239eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907642; x=1794512442; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=;
        b=dKc0R0sUoVJzjFHarHUIsIuDOE1vEm5pcySkN2aAuCQXtdyU5OH7hy7f8VXh45qvz0
         nbWvDg4PQ6zpW67MXBDNYfCqzusd8qfzAWMdWOnaulcaTyvDSx88TfpqAMyyvtwHFSSA
         lqcGj+/XdZsBZxhvZ705rc288908/o75hid05sJqE+vEOQ8ZkPdezsYEXgFwqujlk+Sj
         2X+YqsGLq27kA/C7coKagKRd+SbDihV0LCp3zEQX5pi+tQnQAnVwpHOSNyy9Y+sAoQdb
         5onYxql1QhgsY5tCHjw3JYFOlZsCZxL5Ty2j9jmMWH0wDFsVdd522z3EE/c+B+X0uZjn
         SRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907642; x=1794512442;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=;
        b=pCBhWTfQOogIwx2mNBscN/y725kNyQhjWkJxDep20kwGupeibF1k9TDtKzvbGQKXKM
         rD3YshONJzyjUEDWbjjbLdrwSbV5yCaOK/IDi604UwTFlwyEgDPHNHmAtqjBgAtp0mD0
         BmmtKMFCte4fwJzkZnVGvjvJjNhn0mfFpvdi9gLsP7Zf/CDjQ8ZWc3txC1TiC4wRSwbO
         wrddx3M1LJNVlnLguDVIa9MaozhFjtfGI1T3sARASScbtJq8BQVQt3KCgxqtWyWYhkkz
         PEyAf9Hmj0OeePXqXdki32VllLHiuRsICO1yVrw33vayqxNXEn4ocARHWT9bCuduVjlh
         tk4Q==
X-Gm-Message-State: APuU4Z/OS5+dBhkDL3+p5jYcJfS8tLiYhGSKktWByqPXJwcXzoEvMRKI
	UXJkrzoRlC6Eh+VfgCQuH05pIhtKFMQMbUYiPpka7ot8bjqdLa0lIDze0EtBHgW5hWOaA+coOvC
	vnqE4qaSGudcnu74lC67zx9opLnJ7DaidkYnfEVdsdfydM8090ZWxywASRSHnPL9NR35M
X-Gm-Gg: AYBFou0a84b1bwgh+D/9VjuG39zpR6Jy+jLhNqINTxuW2Ebrtb4VXyaIsBR+OT2C1DA
	VzcEJ65doAua9mzFxvUWgj78kYZX38ufw1fI5aDun1k4wTTjgOotyStfW8ksKaAq17Wz5dasHEl
	aF5C2usL1h6Zyuwx68WifQQxELIvMnoKMxEMNnAOk9cJqLIWiMudvRnCfO6SgAZG+z2AbWKK4U5
	A7brRJIb/AK/7CZy/0hxb0VnIxBC5s5YoCmq+mXJ8ECepOlUG9dDwEscyOiaYmDmLQrQTzg+li5
	Xscn4a0wV6x79a2kNP7ut8fjP/e3t8y+09blUdqO56jWmFzTMZmWAw7M4YKhSV5q9cKKui4HnoE
	LqLh8J9kOmr0SUTFE17V0xRKaHLAA2hGizcTiH6qO9GKnkyN3VPJK+wj6niETf43DMDZ/VnydZx
	lFv8sp9rtzLFfcpyxdXNo48ay30aPbvty27K/PcguVT36RbxybHGI1cdE2TWAGKay0gkmjGg==
X-Received: by 2002:a05:693c:68c3:b0:36e:2626:4ace with SMTP id 5a478bee46e88-36f7398b906mr201301eec.5.1793907641913;
        Thu, 05 Nov 2026 11:40:41 -0800 (PST)
X-Received: by 2002:a05:693c:68c3:b0:36e:2626:4ace with SMTP id 5a478bee46e88-36f7398b906mr201267eec.5.1793907641322;
        Thu, 05 Nov 2026 11:40:41 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:40 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:45 +0530
Subject: [PATCH wireless-next v3 10/21] wifi: nl80211/cfg80211: add support
 for querying SMD context for target AP MLD
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
Message-Id: <20261106-smd-v3-10-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX1yQKt01CqVuK
 5u4ntxK4k6A6ca0KOf+Eet+daWLOG5kvHsPPu87fE/TQKUex1AVlhgGjRrxa1RUuBElwTojibAx
 WJsn2EJUQG9SJE3sk9qmu6BW8boKM+s=
X-Proofpoint-GUID: d70EupsuAfyCT__xTtTu577jucxXEY_q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX2GUbu7BfamR6
 TF3vUB+YA5Plv81iMlCnLeXn732P1SOwMLwMv53Jxb38je2F0wRlGFA1kPEcUYbRAPDL7CYrKh2
 Q56nyVpcUw2eS9vQ9aZb3EOxhzqiqojsNoGkRBpUix5jyDALbtQt2E0KGiSZOTy5QoZK4wYmqyC
 XGc756F6dMHYy9R2RL8mVqizwT1nvnJgl/J6ZQpGsQ3YV15UGUxw6F/jELgOYOheT7SRgl7+Afm
 5SQSUC7dRhpSzqIElkaAObsCDIpZWQ1hxQd9sfMQEoaavBJstu5ecfG+YkBq3a6Q73hqayfszIF
 moVprlwRRXvd9s88kExLeTwkr7LXHV67K70GVBZXcZiebxWbiEpVcCnjObL8OzMcWDfsl6m8ftE
 oJV9Ovc4hSLDnbOmkmtmbldofjXNJMdb+RPmDdVolr0uH4TgNTRXQwpy3t8nJ4yE7OW1ZrURyUz
 VOYj+VfH5N/oJjQ9ZvA==
X-Authority-Analysis: v=2.4 cv=dKUzC+Zb c=1 sm=1 tr=0 ts=6aecdbbb cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=FHB-pW5jD_jF_FmM8B4A:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: d70EupsuAfyCT__xTtTu577jucxXEY_q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

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
 include/net/cfg80211.h  |  55 +++++++++++++++++++
 net/wireless/core.c     |  25 +++++++++
 net/wireless/mlme.c     |  30 +++++++++++
 net/wireless/nl80211.c  | 140 ++++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h  |   9 ++++
 net/wireless/rdev-ops.h |  14 +++++
 net/wireless/trace.h    |  26 +++++++++
 7 files changed, 295 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 42cfdc885c90..36ee10ebd62c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4904,6 +4904,18 @@ struct cfg80211_smd_transition_info {
 	enum nl80211_smd_ctx_type type;
 };
 
+/**
+ * struct cfg80211_smd_get_ctx_pending - pending async GET_SMD_CTX request
+ * @list: linkage on wireless_dev::smd_get_ctx_pending_list
+ * @sta_addr: non-AP MLD address for which context was requested
+ * @dev_tracker: tracker object for the netdev referenced
+ */
+struct cfg80211_smd_get_ctx_pending {
+	struct list_head list;
+	u8 sta_addr[ETH_ALEN];
+	netdevice_tracker dev_tracker;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -5365,6 +5377,8 @@ struct cfg80211_smd_transition_info {
  * @set_smd_ctx: Set UHR SMD context data for the non-AP MLD. @st_info->ctx is
  *	freed immediately after this call returns; drivers must copy
  *	@st_info->ctx if asynchronous processing is required.
+ *
+ * @get_smd_ctx: Get UHR SMD context data for the non-AP MLD.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5766,6 +5780,9 @@ struct cfg80211_ops {
 	int	(*set_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       const u8 *addr,
 			       struct cfg80211_smd_transition_info *st_info);
+	int	(*get_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       const u8 *addr,
+			       enum nl80211_smd_ctx_type type);
 };
 
 /*
@@ -7357,6 +7374,8 @@ enum ieee80211_ap_reg_power {
  * @links.cac_time_ms: CAC time in ms
  * @valid_links: bitmap describing what elements of @links are valid
  * @radio_mask: Bitmask of radios that this interface is allowed to operate on.
+ * @smd_get_ctx_lock: lock to protect pending get_smd_ctx requests.
+ * @smd_get_ctx_pending_list: list to track pending get_smd_ctx requests.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -7480,6 +7499,10 @@ struct wireless_dev {
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
 	u16 valid_links;
 
+	/* protects @smd_get_ctx_pending_list */
+	spinlock_t smd_get_ctx_lock;
+	struct list_head smd_get_ctx_pending_list;
+
 	u32 radio_mask;
 };
 
@@ -11249,4 +11272,36 @@ struct ieee80211_smd_ctx {
 	} ul;
 };
 
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
index f4153c249599..5712fc5c6096 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1483,6 +1483,25 @@ void wiphy_rfkill_set_hw_state_reason(struct wiphy *wiphy, bool blocked,
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
+			netdev_put(wdev->netdev, &pending->dev_tracker);
+			kfree(pending);
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+}
+EXPORT_SYMBOL(cfg80211_free_pending_smd_ctx_req);
+
 static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 				      bool unregister_netdev)
 {
@@ -1565,6 +1584,10 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 		}
 	}
 
+	if (wdev->iftype == NL80211_IFTYPE_AP ||
+	    wdev->iftype == NL80211_IFTYPE_AP_VLAN)
+		cfg80211_free_pending_smd_ctx_req(wdev, NULL);
+
 	wdev->connected = false;
 }
 
@@ -1708,6 +1731,8 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
 	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	spin_lock_init(&wdev->smd_get_ctx_lock);
+	INIT_LIST_HEAD(&wdev->smd_get_ctx_pending_list);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 80ca9031d29c..0631e42e2fa1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1577,3 +1577,33 @@ void cfg80211_mlo_reconf_add_done(struct net_device *dev,
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
+	netdev_put(wdev->netdev, &pending->dev_tracker);
+	kfree(pending);
+}
+EXPORT_SYMBOL(cfg80211_get_smd_ctx_done);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 249d7a3c2841..f30110d998d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20157,8 +20157,7 @@ static size_t _nl80211_smd_ctx_nl_ba_param_size(u8 n_tids, bool dl)
 	return n;
 }
 
-static size_t
-nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
 {
 	const struct ieee80211_smd_ctx *ctx = st_info->ctx;
 	int n_dl_tids = 0, n_ul_tids = 0;
@@ -20273,8 +20272,8 @@ nl80211_put_smd_ctx_ba_params(struct sk_buff *msg,
 	return -ENOBUFS;
 }
 
-static int nl80211_put_smd_ctx(struct sk_buff *msg,
-			       struct cfg80211_smd_transition_info *st_info)
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info)
 {
 	struct nlattr *dl_sn = NULL, *ul_sn = NULL, *ul_pn = NULL;
 	struct nlattr *smd_ctx = NULL, *dl = NULL, *ul = NULL;
@@ -21185,6 +21184,92 @@ static int nl80211_set_smd_ctx(struct sk_buff *skb, struct genl_info *info)
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
+	netdev_hold(wdev->netdev, &pending->dev_tracker, GFP_KERNEL);
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
+			netdev_put(wdev->netdev, &pending->dev_tracker);
+			kfree(pending);
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
@@ -22109,6 +22194,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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
@@ -25141,6 +25232,47 @@ void cfg80211_nan_channel_evac(struct wireless_dev *wdev,
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
index 96a47eccc196..e84a5c2153db 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1727,4 +1727,18 @@ static inline int rdev_set_smd_ctx(struct cfg80211_registered_device *rdev,
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
index 67db0b032808..37456e5530f3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4509,6 +4509,32 @@ TRACE_EVENT(rdev_set_smd_ctx,
 	)
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

