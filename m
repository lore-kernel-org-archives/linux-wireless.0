Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907648;
	b=pNoFYbvyi8tqhFN7veWUBAuWM6Uhm7OceKOFUnQ5bzOcq2/4lzbcAvBxEJF7G07amkBc
	 7nPtWFGRrX60bU8twh6anbIqDfZ11Otzh6nEcDvZUzul1oX/SCNiWF3XoCgFzt1txPjVE
	 RsETJhrW2JGw/T3hMcsWL/FGTJb6HmRbkai5Ld4g/5cRq1m3eQXd9wFpf9cJgTrIF0Lg7
	 E60P5RE6gsss4TRNJFkZZxtW8eACIgJx5GZH1xvMZP2QZJ4fD4cjcRWLHQG/cSvImuaEo
	 KCkS6C7tJwBHvMr5HRZl7LbI9SA7mXCQezIjZHbzZ3N0Cf/vPtAEXdRZ7DK9bNfSPMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907648;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=clhys4CQaKnPc3jhrMSj1m0KYYir2kxiA5JTYn80wVY=;
	b=4zmTqRfLV4R9+Gl77W3xAknyfQH/qFs0mFMZnmHs1WJCd72ojYBXFxnXBsOGHowp2G+S
	 k5nA/Y33cD9JSzPcwwpfhHBzu42L8Pq2E89oxp7z7+fmGQfvBa1uMeWzh1TyPYweeG9aB
	 I42o/U6+ubJ4MEq5XNtCKb5P+IYMTt+vr0+zsWVd3eOX6pMSxrTOxISWTzP7NHY9zK69q
	 8nlfVEQrFSLo9GgLLgXhKxyMVhlgVOa5SDk1Z21JGoPn2SMx45kV1lCB23fykDJTHTpjz
	 l62m3FX475yyJQIlc5ZX9o6sOwcH1JBgyF5uW2SqZ21jhQKjggx1uUSyN9pgKtBYHlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FqWiSy3H;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DPa8bz8H;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763BB608068D
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 763BB608068D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FqWiSy3H;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DPa8bz8H
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeMkU1440027
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	clhys4CQaKnPc3jhrMSj1m0KYYir2kxiA5JTYn80wVY=; b=FqWiSy3Hjm78EH+O
	KbtC83PWBHmtm87D4KH/dA7CPhu21Dd3IdTqjwSK3PgH3odU/DkPsaB4V4pdppkE
	UPULm5BlYk0pgmgyDf/e121Nh2Nact8EPiMSc/YzcJhlQ6a/p7srhrB+AenNt3mh
	FAM7ES5jibpX2VlZhoCEbehOMfuMzBIfkIQfWvE8m92lM7MA9E76pEaDbxO8jziC
	hvB3eNzmSNQ7GQrqamfuUC2P1otPNKLg5CRwZk6PdyltbcVYP4YsRmr/fH5TDiT0
	0SF8Z+NpyHanlyeIJUM4IjcW1FgMcc89GzaId4Bv9a4/IzEEb4oz3U8JzmE2fAOp
	CvyCuQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrm9v3fjh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:47 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36f479b9819so360707eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907647; x=1794512447; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=clhys4CQaKnPc3jhrMSj1m0KYYir2kxiA5JTYn80wVY=;
        b=DPa8bz8Hw8O5oVIZXr/mMOi+Psy9FOkbnEIf4yl2H3bdHBxnkpjg74TlPk0gtPUz9L
         K0SE2zUmP9sRqtkvlScNXEsAh7KYwKrgSzHnk2WnkoLrxXpALMIbEmkC6cxSyiNJDPSf
         Cx8SpDdesQETrTofnqjmU8XhyC2ykiT+d/fT2PuHVcj0at3lGTF74BcPJqa8tEytToXS
         PdQNpwRYHQ9JZojf6hDb7h6waYc9/EVTTp5AluOa1jLBi9BPfNfW+VZH5bY4nMYMcRrx
         jp1oXtUTb4QPFLsvjZ1G2ROCdNpdIPgp4Hio3NoORuDS4Sn3WeiWJhKbqodqHzFWh3ti
         VsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907647; x=1794512447;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=clhys4CQaKnPc3jhrMSj1m0KYYir2kxiA5JTYn80wVY=;
        b=YjxYIwpZWRTxSanVPr5A4NR3fqFD1EkYw/Ql8mHIyvpQpGbJ78f9yWzubqs2uWlNrU
         SSoBI1SnH2eHWILxxuv6s1XZRe9QcLzWdumd08Y9EhiL61V9LRrlFgL9eLuvTkmXoAUE
         Yj0JF3dHvQGR/YKjaABvT9HdskuGzi+7IR5U181a/6MJYOCDAcsuSnwWDnoI4PmL20Ck
         Nm2gSgstAQNLmHKY5OGjrOj0Q/y32htvHxhrpvpaJzR+IWYMDX2E7HZSQqWSe/f7Gz68
         2Mh1bfDYBXF7P3G1TVoma8PnIn0YhdsdvNc8hfSbDPnWlEX6sZrMXvv76y1F+pkP7nZX
         NBKg==
X-Gm-Message-State: APuU4Z/PVKj9/3GGQgdI4wxESvd4CkmJMmHruFS5mPrj8UqURnIDwABM
	MH7mvQD42qzryErSp0dq5ePdYSvWUy+PFvRTJS8xBwZHBduLn5ZVPejzvId9nbAakGwx8ynyNxp
	gXFB+SqnmGJPOOuFCHkWmQZsTVLpUNjB2dsNEFtx5FIpXZsBq8f2m3WQlig5ZNmZV7Ywo
X-Gm-Gg: AYBFou29eVIeXwBWJjujIMJRHae8tE74OYpvqfsQhciu/BCRgC69g63E1B+h/X11l94
	1oV9kKSj5Aqj6qP92d2s+2UxOVCLMypDkkrbzFN/EeH6d9LmbWtZvzcyz6VUl6vMNvuDxoc0TWJ
	M0qe7AcS2IBEpJdrLSpiajRv8+y77zL/rlhsKeafBBdooIU8oWyvn/FApZTjYjRkmQ/HgKnocE7
	3mTSY3Qdri25tw0CW22D82RiPFGmm4qp4wAHKnB1sxsG+O+ZwlH6D8GnkZ75GY6bQu/efDsj0/m
	FfNQPLWmQsVLEzy0Bje31Im2FyWf/xfvPvGvWyJEpsu1u2pkzV5NNiq0rFIFS62fB8OtKC9IEHs
	NHnmM8luo4GObm2oUgtyuz5pW//ZBQ3JmWWQjD0g2Vn4mk4Nzgo4xjs3JFX0LkaNVxGQIFT63cS
	0BmumdSmxEL+Duy8k2f8O2nixEX85GFuVLPXKQhLd/6oKrwBvyNYevee8b9OhP+H3YkKrTEA==
X-Received: by 2002:a05:7301:4605:b0:35e:f1a5:9ba6 with SMTP id 5a478bee46e88-36f729cfab7mr209725eec.5.1793907646988;
        Thu, 05 Nov 2026 11:40:46 -0800 (PST)
X-Received: by 2002:a05:7301:4605:b0:35e:f1a5:9ba6 with SMTP id 5a478bee46e88-36f729cfab7mr209692eec.5.1793907646477;
        Thu, 05 Nov 2026 11:40:46 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:46 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:47 +0530
Subject: [PATCH wireless-next v3 12/21] wifi: mac80211: set SMD parameters
 for AP setup and STA update
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
Message-Id: <20261106-smd-v3-12-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX2PylC5d9Kp3G
 7bMi30RtYOxFV+2mKxuclXSoZFES/vWr1trF+G4aQ3TyjPs/DUc3aMPJkmj6SSldJwZ4Ox+s5V/
 TTKl5OnPqCjDHHAl8MTzk9k9Hpx3kQc=
X-Authority-Analysis: v=2.4 cv=KrHYSmWN c=1 sm=1 tr=0 ts=6aecdbbf cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=c5vwGiuQIk8ddjU8bDkA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXxUTgTDwYVi0p
 nNx/gF4VMNIyLWpfPzHBmU5RnhePK+8EFfyV6l7AW2vpBQVQ/9/n8/kxBSeTJ2TMJzNmvFX8ke8
 9j9elnvoPihJjN2+UwYRkJm+gH986WSU2TZNL4txKMzEDmoamKxlw7iUScxtasaPNMI2aIhkqcF
 b9gVTvvEcoLy69yXZ/B83Dtgu/t0vXQ0TBWoDXWTXTCFNg4NtsRzlCbXuHAnRZdplrY2dyHk/gy
 sNsZQLxxGv70krvXMl+xeeA+8wg3nZbiz1X039HkUcNtIEwVf4FeSWMLKW9VehnXwZ+tdElyYKg
 utIlLHUQtvtLkuQGtasWGevkTrJAiXKBoMbARpEnFP/kKD21wHzxGEOR0jzkTU1oK0yoRisD9SB
 /5ZwSlu8jp45yjtvnx5c8unSA7y9WPceleNG39al9ywvKnypn0Q1S81nzNWk741VY8m66TphPUK
 oMZSu/7IJbSrvLIfIgQ==
X-Proofpoint-GUID: q9apn-Fy0JYEhu7r_ewmnPMZNVPtbPrC
X-Proofpoint-ORIG-GUID: q9apn-Fy0JYEhu7r_ewmnPMZNVPtbPrC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

From: Rohan Dutta <drohan@qti.qualcomm.com>

When userspace marks SMD parameters for AP setup and STA update (during
association and ST Preparation procedure), mark them in mac80211 so that
SMD operations are properly routed and handled in the drivers.

Signed-off-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h     |  5 +++++
 net/mac80211/cfg.c         | 12 ++++++++++++
 net/mac80211/debugfs_sta.c |  1 +
 net/mac80211/sta_info.h    |  2 ++
 4 files changed, 20 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..23a3f08c72e3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -796,6 +796,7 @@ struct ieee80211_bss_npca_params {
  * @s1g_long_beacon_period: number of beacon intervals between each long
  *	beacon transmission.
  * @npca: NPCA parameters
+ * @smd_ap: AP supports SMD
  */
 struct ieee80211_bss_conf {
 	struct ieee80211_vif *vif;
@@ -902,6 +903,7 @@ struct ieee80211_bss_conf {
 	u8 s1g_long_beacon_period;
 
 	struct ieee80211_bss_npca_params npca;
+	bool smd_ap;
 };
 
 #define IEEE80211_NAN_MAX_CHANNELS 3
@@ -2731,6 +2733,7 @@ struct ieee80211_link_sta {
  * @nan_sched: NAN peer schedule for this station. Valid only for NMI stations.
  * @ext_mld_capa_ops: the MLD's extended MLD capabilities and operations
  *	NOTE: currently only tracked for AP STAs
+ * @smd_params: SMD parameters of the STA
  */
 struct ieee80211_sta {
 	u8 addr[ETH_ALEN] __aligned(2);
@@ -2768,6 +2771,8 @@ struct ieee80211_sta {
 	/* should only be accessed with the wiphy mutex held */
 	struct ieee80211_nan_peer_sched *nan_sched;
 
+	struct cfg80211_sta_smd_params smd_params;
+
 	/* must be last */
 	u8 drv_priv[] __aligned(sizeof(void *));
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6e466f8e1653..37329d8748ae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1864,6 +1864,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
+	link_conf->smd_ap = params->smd;
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP &&
 	    params->mbssid_config.tx_wdev) {
 		err = ieee80211_set_ap_mbssid_options(sdata,
@@ -2778,6 +2780,16 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (mask & BIT(NL80211_STA_FLAG_SPP_AMSDU))
 		sta->sta.spp_amsdu = set & BIT(NL80211_STA_FLAG_SPP_AMSDU);
 
+	if (mask & BIT(NL80211_STA_FLAG_SMD)) {
+		if (set & BIT(NL80211_STA_FLAG_SMD))
+			set_sta_flag(sta, WLAN_STA_SMD);
+		else if (test_sta_flag(sta, WLAN_STA_SMD))
+			clear_sta_flag(sta, WLAN_STA_SMD);
+	}
+
+	if (params->smd_params.smd_sta)
+		sta->sta.smd_params = params->smd_params;
+
 	/* mark TDLS channel switch support, if the AP allows it */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
 	    !sdata->deflink.u.mgd.tdls_chan_switch_prohibited &&
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 690c186e3bb9..c2268f79601b 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -78,6 +78,7 @@ static const char * const sta_flag_names[] = {
 	FLAG(PS_DELIVER),
 	FLAG(USES_ENCRYPTION),
 	FLAG(DECAP_OFFLOAD),
+	FLAG(SMD),
 #undef FLAG
 };
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..54c4c613a2da 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -72,6 +72,7 @@
  * @WLAN_STA_USES_ENCRYPTION: This station was configured for encryption,
  *	so drop all packets without a key later.
  * @WLAN_STA_DECAP_OFFLOAD: This station uses rx decap offload
+ * @WLAN_STA_SMD: this station is associated to an SMD-ME.
  *
  * @NUM_WLAN_STA_FLAGS: number of defined flags
  */
@@ -104,6 +105,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PS_DELIVER,
 	WLAN_STA_USES_ENCRYPTION,
 	WLAN_STA_DECAP_OFFLOAD,
+	WLAN_STA_SMD,
 
 	NUM_WLAN_STA_FLAGS,
 };

-- 
2.34.1

