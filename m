Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76278525A94
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813223; cv=none; b=u8N5VHfR+5L4H0K8oC61P3sePh4af1oMNxcox1AKgXrnv4yAFulYIwpQmxy/HWjyZaKl9t595W/3G/nIf2samjWpsMWNNCIZfiIdDEcb3v18SAAM7OFIJWzVyM+vnNLdJkyVnJVn1D5fsjcczFVg5rlHUE06/3fNjtGFS3fHb9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813223; c=relaxed/simple;
	bh=XxXeGyH8LowR4EFnJMlxM2wbsxxbipviiWhjmsnKVcM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P9HQ/JsCwjfJ91VZOprB5Y4Up5U8IlRiTFkM1TeVevQHt/9jJfM6P7yjb4xWnMgf2s5DwUjbgv0y/IOOr42niO+9fz4WzPYHZP1Etopnf1v8jiUN5SOMVrWh1MtEKDh6REwPtDcZxc9MVrOyArkfDQr43idd7Mqmih7dtj1yvpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jx2LWUgq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yb13lr6J; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jx2LWUgq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yb13lr6J"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H8B2K3485582
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C4KjAE1JwpT6DGpnh/CZZfax3IJ/HuYkECxZMwDBCSw=; b=jx2LWUgqwXxwmLZC
	FB7Bk21kDrkW2c8kjyfcP+BAaAsVGyN68cYYqCoJFWZDrtujs9lzHMvps7NKFmuP
	aHTuSpWSPC2H2X5uDRinMgiiO2RDjqBrYS2v364ptdZ5bW++k1GKDKmQ9+REVmZ4
	RbFAKTfU+kRmilkZL1v0ckJWU7tlu4JZDKC/+c8GOyXZoqsEb1/OdIM5Qts9JQ/B
	ocU8j/TTFsG1NZErbEKTfedeEDcsSAOCaL9F+W3+80rvZqw54pghhty2c2e/nBkt
	TPi7ZrpXMu/GS/6SRPyh5zNDX5zZhPMgMBDoqLfnK6fqWlSTZDBggUWhGeC2zwPG
	gTZesg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghtty262k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:40 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2db4e331406so26717875ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813220; x=1789418020; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C4KjAE1JwpT6DGpnh/CZZfax3IJ/HuYkECxZMwDBCSw=;
        b=Yb13lr6JeSZ7DmWi0pWUpUE5u6hC03RQAkYuRPiqUwIksSJ/VkXXnNcqGCCx/aO2yy
         thlvVuTocbJk9vj4PTyYy2HoYo6m0fdA8aoZT4osPMs/NX8G6OG29v9l04zWQNzdT/35
         i5ARSR0aMNFFPDsaVdTOe0UYrI1A0mLwCmP1agFJZRJE+32BVb5ZI0jq2Xyyx37l+PN9
         floZKIoXpLPBcvrVNGs6IDxLJFcWTdZAeiuxsPypwrRpK7ihZs9eX+Qj1F6cTwTvT/RO
         IfpUbwMgPWnwC5MuJYad2kcdfs7YTuhh/NqMxITMp2H5HfW+lCa1gnFuYrjIPsQo13gi
         664w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813220; x=1789418020;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C4KjAE1JwpT6DGpnh/CZZfax3IJ/HuYkECxZMwDBCSw=;
        b=mcB5yvslAitaDtLRWym1xukRMwGXpkJ+J9eShshXv74B1JgMOxXpGEZXqTgqxdJH7k
         ExLdqIupFW9QGQU7xxSX1AZFq984ee91mLcIhT8ENUQX9wF5FFz1rnB8WMkY3BBwWyCi
         wZnhQbL1Lv+JxowmP0+H0Uyn3DMIPawZHOnQ6yWbt084g579qNkz8YrFwsDn4wgWBfqI
         dpPEhm9C4lbxve6ktMrKhKrj9EzyI+N6LS0m2OVcghOLeq8tMS/k0Cz9JPd5VMmGrPdx
         cGC0wNvK4aIH4ZjhlDw3arXCUhWxqGTp1I3a5Gpzly79rPLdtHLayi52XItv0yCQsuZh
         qUbw==
X-Forwarded-Encrypted: i=1; AKwUvBzF42oV+BKcLEpb4Nn6+00/vOf39rrCxUvnO7AcA2G9uKLWlgkd53B62QU9XKTLTJBFiiBzSe/L2dc9cYdVUw==@vger.kernel.org
X-Gm-Message-State: AFuF++kpgxn50aHgAc3orRJlct8vlIVCZVfwB1ZzXAepo/t0SrUrEM/M
	3G+j1vciwg3Jgt+cQWk/b7zvhCTERH4yUFIOI9UPsW5+bDQvQ0bnZSjKQFBZo7HmJdmPWZYPZb1
	FfqEWkYThhfN7NGUTtSoe2hdiZLe9fKAbUwmAYwRC7AcW7ftz8YWTGDvaqCPF7jFsa+JY
X-Gm-Gg: AYBFou0fBK0IKuqcj8upd+Z14cUY98Z8/T4LL+8AgmUpU1jCwIjwGey8cChBrTKLFal
	FFzr3YJ+I8V5ESQyAWgAo7HQGlIbv2xy1N6f6lDMB2OtKzlgap/IEtT+MtxWoOQyfi9erL/QeYC
	b0H/C/GJSYj09X20wdMGVX7t0/SPcMdIa2b4pFPVgDy6GVf6y5WSAva/H3qYJH+f4uxJbnGfZkS
	aDTg9vKEZI14IL9Anv183gzBfymgM/d1xriZBDETTqF5d7TEgYkW7COnd9S7N3Ru1pJa2ytyEyH
	+L0f/XFu1uYyqu8fbJQ8hErtG8LkZjV18jtondG/pEBkHnOkpZTyCGW6ukqAZlT76IqbVjVt4rV
	7IG2zw9ahbb8bqjaKdHJl0yUAb0Ntk6GfJFhEgMrUQNb4TN6V+LMg7lIe0O+mhnkSwltTOeuHta
	OXhnLW7Jtb7HVieN67EvEK8A==
X-Received: by 2002:a17:902:ce82:b0:2d9:2ff6:2497 with SMTP id d9443c01a7336-2db12599b07mr340310325ad.13.1788813219953;
        Mon, 07 Sep 2026 13:33:39 -0700 (PDT)
X-Received: by 2002:a17:902:ce82:b0:2d9:2ff6:2497 with SMTP id d9443c01a7336-2db12599b07mr340309845ad.13.1788813219492;
        Mon, 07 Sep 2026 13:33:39 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:38 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:16 +0530
Subject: [PATCH wireless-next 07/18] wifi: nl80211/mac80211: Add SMD BSS
 Transition sub-state STA flags
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-7-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=QNBYgALL c=1 sm=1 tr=0 ts=6a9f1fa4 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=olGzuFvk815fMYXliRYA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: FRG00uOkQfiMhVt8jlrLDsHYBosneZZz
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX16u7NkSpTICf
 PzKUfO4l3bjeUo2g2Eq53vFsY2BYTjKLZE+VUS3v4jVrjQGK5kFmiFnwwcLSepYFcZTKL8HZKxx
 apfULvWBYBoJ4WMps2MS52z0A53bHCA=
X-Proofpoint-GUID: FRG00uOkQfiMhVt8jlrLDsHYBosneZZz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX++EtSud+pXsr
 PsOXOKiKlgLJxeOziaMH4wDAae6mQ/sLFMb3AToF/CFnV98QSkayRszguTmzvEy6QzYZqgKjgr7
 7vybaEb6Z3j5SA3P4vgVe6k6s4flzoJRZn+GRbABR2b4DKO1aCa5Vm/pH/S4BGFOc5WRheSgGo7
 jNBNZcZ6k4Vskf5fFP/k3kDjYY/iS4mGJfklCX9+oq2w4TO/AODcBk7YfylEjB+d71/Ja16zI3d
 0QOmHqK6c72nzOp0J6T7rwJaMCfsUzKM2mGV2dA3YblKPp/79lChtnBcw28laxsXHblGR006X+G
 V2DG7kVXuFYVx4LZUDueMv1ERcXAvYzMNbqH96KnKLSlZwozrTGsB9MJEsSEqzf/89h79Jo6SBh
 xQUQpfD9MjFwgCqoZCK4IAR9aNlZ7es9ct3elSJwxk/FbsCZzX3jQOjugZm0KvgPvhwZvfVs6WC
 ury5LLJoisniAqu4d0Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

IEEE P802.11bn/D2.0, Aug 2026, subclause 11.3.1, defines three new MLD
state sub-states (4a, 4b, 4c) that apply when a non-AP MLD and its
associated SMD-ME are in state 4 and an SMD BSS Transition is
in progress.

Add the corresponding nl80211 STA flags:
  NL80211_STA_FLAG_SMD_PREP_TARGET -- State 4a: target AP MLD prepared;
    Class 3 frames blocked except ST execution request/response.
  NL80211_STA_FLAG_SMD_EXEC_CURRENT -- State 4b: ST execution active on
    current AP MLD; UL Class 3 data blocked.
  NL80211_STA_FLAG_SMD_DL_DRAIN -- State 4c: DL draining period; only
    control frames and UHR Reconfiguration Notify permitted on current
    AP MLD.

Add three internal station flags to track the 802.11bn SMD BSS
Transition sub-states (4a/4b/4c) in mac80211:

  WLAN_STA_SMD_PREP_TARGET - State 4a
  WLAN_STA_SMD_EXEC_CURRENT - State 4b
  WLAN_STA_SMD_DL_DRAIN - State 4c

These are transient sub-states of WLAN_STA_AUTHORIZED with the SMD-ME.
The station remains authenticated, associated, and RSNA-established
throughout; only the frame-filtering rules change. At most one of the
three may be set at a time; mutual exclusion is enforced in
sta_apply_smd_state_flags().

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 10 ++++++++
 net/mac80211/cfg.c           | 60 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_sta.c   |  3 +++
 net/mac80211/sta_info.h      |  8 ++++++
 net/wireless/nl80211.c       | 18 ++++++++++---
 5 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5e474fda2a49..65c7eefe9db5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3965,6 +3965,13 @@ enum nl80211_iftype {
  *	previously added station into associated state
  * @NL80211_STA_FLAG_SPP_AMSDU: station supports SPP A-MSDUs
  * @NL80211_STA_FLAG_SMD: station has negotiated SMD.
+ * @NL80211_STA_FLAG_SMD_PREP_TARGET: station is prepared at SMD target AP MLD
+ *	(State 4a). Class 3 frames blocked except ST execution req/resp.
+ * @NL80211_STA_FLAG_SMD_EXEC_CURRENT: current AP MLD is executing SMD BSS
+ *	Transition (State 4b). Uplink Class 3 data blocked after exec-req Tx.
+ * @NL80211_STA_FLAG_SMD_DL_DRAIN: current AP MLD is in DL draining period
+ *	(State 4c). Both directions restricted; only control and UHR Reconf
+ *	Notify frames are permitted.
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -3979,6 +3986,9 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_ASSOCIATED,
 	NL80211_STA_FLAG_SPP_AMSDU,
 	NL80211_STA_FLAG_SMD,
+	NL80211_STA_FLAG_SMD_PREP_TARGET,
+	NL80211_STA_FLAG_SMD_EXEC_CURRENT,
+	NL80211_STA_FLAG_SMD_DL_DRAIN,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 138b67f4bda4..69b3ac0b48f3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2452,6 +2452,55 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	return 0;
 }
 
+static int sta_apply_smd_state_flags(struct sta_info *sta,
+				     u32 mask, u32 set)
+{
+	bool smd_prep_target, smd_exec_current, smd_dl_drain;
+	u32 expected_mask = BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+			    BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+			    BIT(NL80211_STA_FLAG_SMD_DL_DRAIN);
+	u32 smd_flags;
+
+	if (!(mask & expected_mask))
+		return 0;
+
+	smd_flags = mask & expected_mask & set;
+	if (WARN_ON(hweight32(smd_flags) > 1))
+		return -EINVAL;
+
+	smd_prep_target =
+		!!(smd_flags & BIT(NL80211_STA_FLAG_SMD_PREP_TARGET));
+	smd_exec_current =
+		!!(smd_flags & BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT));
+	smd_dl_drain =
+		!!(smd_flags & BIT(NL80211_STA_FLAG_SMD_DL_DRAIN));
+
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) &&
+	    (smd_exec_current || smd_dl_drain))
+		return -EINVAL;
+
+	if (smd_prep_target) {
+		clear_sta_flag(sta, WLAN_STA_SMD_EXEC_CURRENT);
+		clear_sta_flag(sta, WLAN_STA_SMD_DL_DRAIN);
+		set_sta_flag(sta, WLAN_STA_SMD_PREP_TARGET);
+	} else if (smd_exec_current) {
+		clear_sta_flag(sta, WLAN_STA_SMD_PREP_TARGET);
+		clear_sta_flag(sta, WLAN_STA_SMD_DL_DRAIN);
+		set_sta_flag(sta, WLAN_STA_SMD_EXEC_CURRENT);
+	} else if (smd_dl_drain) {
+		clear_sta_flag(sta, WLAN_STA_SMD_PREP_TARGET);
+		clear_sta_flag(sta, WLAN_STA_SMD_EXEC_CURRENT);
+		set_sta_flag(sta, WLAN_STA_SMD_DL_DRAIN);
+	} else {
+		/* all flags revert back to none being set */
+		clear_sta_flag(sta, WLAN_STA_SMD_PREP_TARGET);
+		clear_sta_flag(sta, WLAN_STA_SMD_EXEC_CURRENT);
+		clear_sta_flag(sta, WLAN_STA_SMD_DL_DRAIN);
+	}
+
+	return 0;
+}
+
 static int sta_apply_parameters(struct ieee80211_local *local,
 				struct sta_info *sta,
 				struct station_parameters *params)
@@ -2538,6 +2587,17 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (params->smd_params.smd_sta)
 		sta->sta.smd_params = params->smd_params;
 
+	/*
+	 * SMD BSS Transition sub-states (IEEE P802.11bn/D2.0, Aug 2026,
+	 * subclause 11.3.1).
+	 * Only meaningful for SMD-capable stations (WLAN_STA_SMD set).
+	 */
+	if (test_sta_flag(sta, WLAN_STA_SMD)) {
+		ret = sta_apply_smd_state_flags(sta, mask, set);
+		if (ret)
+			return ret;
+	}
+
 	/* mark TDLS channel switch support, if the AP allows it */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
 	    !sdata->deflink.u.mgd.tdls_chan_switch_prohibited &&
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index d7e7c9c578e4..24c985687bd2 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -79,6 +79,9 @@ static const char * const sta_flag_names[] = {
 	FLAG(USES_ENCRYPTION),
 	FLAG(DECAP_OFFLOAD),
 	FLAG(SMD),
+	FLAG(SMD_PREP_TARGET),
+	FLAG(SMD_EXEC_CURRENT),
+	FLAG(SMD_DL_DRAIN),
 #undef FLAG
 };
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 506aeb241a6d..89137b18a862 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -73,6 +73,11 @@
  *	so drop all packets without a key later.
  * @WLAN_STA_DECAP_OFFLOAD: This station uses rx decap offload
  * @WLAN_STA_SMD: this station is associated to an SMD-ME.
+ * @WLAN_STA_SMD_PREP_TARGET: this SMD station is prepared at the target AP MLD.
+ * @WLAN_STA_SMD_EXEC_CURRENT: this SMD station has started execution at
+ *	the current AP MLD.
+ * @WLAN_STA_SMD_DL_DRAIN: this SMD station has started draining at
+ *	the current AP MLD.
  *
  * @NUM_WLAN_STA_FLAGS: number of defined flags
  */
@@ -106,6 +111,9 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_USES_ENCRYPTION,
 	WLAN_STA_DECAP_OFFLOAD,
 	WLAN_STA_SMD,
+	WLAN_STA_SMD_PREP_TARGET,
+	WLAN_STA_SMD_EXEC_CURRENT,
+	WLAN_STA_SMD_DL_DRAIN,
 
 	NUM_WLAN_STA_FLAGS,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7577eb31ff65..282d3c82dce8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7707,6 +7707,9 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_TDLS_PEER] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_SMD] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_PREP_TARGET] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_EXEC_CURRENT] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_DL_DRAIN] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -7773,7 +7776,11 @@ static int parse_station_flags(struct genl_info *info,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
-		params->sta_flags_mask = BIT(NL80211_STA_FLAG_SMD);
+		params->sta_flags_mask =
+			BIT(NL80211_STA_FLAG_SMD) |
+			BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+			BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+			BIT(NL80211_STA_FLAG_SMD_DL_DRAIN);
 		fallthrough;
 	case NL80211_IFTYPE_P2P_GO:
 		params->sta_flags_mask |= BIT(NL80211_STA_FLAG_AUTHORIZED) |
@@ -8920,7 +8927,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 12);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -9015,7 +9022,10 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_WME) |
 				  BIT(NL80211_STA_FLAG_MFP) |
 				  BIT(NL80211_STA_FLAG_SPP_AMSDU) |
-				  BIT(NL80211_STA_FLAG_SMD)))
+				  BIT(NL80211_STA_FLAG_SMD) |
+				  BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+				  BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+				  BIT(NL80211_STA_FLAG_SMD_DL_DRAIN)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -9702,7 +9712,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 12);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:

-- 
2.34.1

