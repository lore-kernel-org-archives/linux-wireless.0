Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB749EC7B
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813218; cv=none; b=ZBmi/T5Nb1uUChnA5zLjKvHUmiMykMII8JXDeEKOJdlnaBzTpE3C6sGSCecjuq/y57+Ko25WxvDsctpC5738Z6pT0CAAT3AWNv3UOLUWi+megw6j67TqXjHM1qHgNqTvsi4lL5tLLMrnij7+6pB3SRRwIj4Bi/wazOMtwz1xCjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813218; c=relaxed/simple;
	bh=n6QZOZ4ipBg1ZD4KtCHhdn0h3EQTsWMtpUTn1ZHyNpw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pCH62ZSx4kYCuZAlcUEDd9eDbALZU+NhW92PTydkKtWvwEsqdewWG2J2ma994E+LPOQHLh9P/MXZnZ0RR56gillsQ4EXHpA9IYQCfSyAFJ1orq44AxVGKXBkNy80C2EVJcRDNSte22zSvnlKiqrXEOKO4Hj8zd/k5eoKUCs0WP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VfTHNGbA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NCncq8oE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VfTHNGbA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NCncq8oE"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H8YbO4184838
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4cSKp76Wny+ccMBfbKuXS85MttxoIgTePwgcdN/NDrU=; b=VfTHNGbAqawR0xvl
	vlP2wlJ7T0WonKha64ImA46JyV07ZyMgjV5Xj5eoxcVNJL/r5A74sZxRt+tMx9CI
	m/JO2dYrQctSuTIrfIs9O7OQwRr3PCCA9GQYn0wtpWmLu5isXfU1qAJ6rmFPkzQg
	pPQLg/ObcEzhCDD3qATlccxXm2BFNfWtFq7semEPY0P5NrjJvDuJIkLCqs7xLwH9
	q/1avRtfyOi6sITix36FLsR69NeChJ3PVwK8O5zv0x6rUJbvfDdXCmlXQARm6Y3k
	iT1krPbTP2kLWdMeChZGUxnSjsdljS/5PBqaEebpayaKbQknPU0O0xXPDsGdTxOC
	MxHfDQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghtfx294f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:36 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c85798977dcso5648809a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813216; x=1789418016; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4cSKp76Wny+ccMBfbKuXS85MttxoIgTePwgcdN/NDrU=;
        b=NCncq8oE9oYH4zxb6ejEsJ4DVAqGG7/SHaRWROLokS344UDWFcTOOKErAWul31QZyJ
         Yee621h7FLd7Rlhw9Bxk1ix6qKL/QvUOOP934od7JkoyqE0e5AL4qOGB+LeOlA0l2Gkt
         3IEsYlmlmgc18ZVnvQI9v/2f5PBV3hwE79TE+EcpMrduR+vxFyY+RpU72wrdpMJcqcQ4
         Sx0QTk7mIaN9JlpGSAYfQ2GSXv687vPIElBcDaBIaIg7hdrM4jFX7FLEcXFc/NLEm6ME
         QnLXWOdHuAEAmCCQdp6FNjQ1JVdj+Kxz65Fz6mrc0hrMWbHdvqS95VeAE6lFZA2+4rV3
         Uc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813216; x=1789418016;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4cSKp76Wny+ccMBfbKuXS85MttxoIgTePwgcdN/NDrU=;
        b=sBn0o9qKbxnNjWMcICHCYWGUItx3FkeenSfPmpKxGr51aGQ5jp43VBEhrzmhswtgdn
         UEO8gb0jDKPBP25yTqcfZ+3shZBNPzAzwAFaVUzIOpGtNNOEu6WxH/D46nmXNPK8JsyO
         e6833CtJ3Dvd2dExAEkNwO2OPWbELeFKzrU4PiR6cUQo7IWiPWMucDioGSqaypMMDJRG
         feTN2Cl96lzHXAjvu81C3Vpnqz9/uboSHYAoNE0GES7KJqyjH3mSg9AdCGj50SeyLnhM
         7mstKoAafQkh7ZzSd3o4Br6heac001coBqnlJxRo0oOZtktktYgXZocCLW10uRzMqTtU
         2o4Q==
X-Forwarded-Encrypted: i=1; AKwUvBw0hQ2JVpG398u6c7KOwj1qOsbbquhZr0HENTKf/cYdoEP4Ll+aNrUwRXOrUTm8qYMmfRKAZ0i3koJSAUhYZw==@vger.kernel.org
X-Gm-Message-State: AFuF++n5ITFd3CrG+LK7ZBRNaUIvVUZInBWbx7uknLVpoNcsn90onX2J
	PAwGTGnDO2qgtH6ycwjbgqdT0a4au9ZHU3CCesM5M8yhee1rPZzia0UpvlXYo+a5ynRZ39MsbyS
	ETS4Si+Z1P2DXD4VGEvioWA/cIoD7Pj0hJIjqVrZUjFdfEqRwXKCmL01XLX39WZPOEric
X-Gm-Gg: AYBFou3hPGnw9ubUQusPnCee9/IaJNDHRdQ1VjECua2CWh3meGWjl49T9ZUYovX5nes
	nwO6pOF+CfL9rvoDiJLCiOA5qFoYAaj5r7GS4UB6EG4siNYHeeRKuXqUoMXaOZt8xidYJQULIuW
	RH9v7GfiF3tIkmSm94adTVuYa8oC1aGjtVTEY1HmErjQis4xIbNJ5AMKOMqn7V7xuP39X88DoXS
	ZPBnKXyEz2hbtywwhDwXHsysa/XBijCySgQ84ekcgv5ateSE54CZA/FbvDnfkzOT8PF7zY6nKnT
	Q4YzghO/OLeEy9C69QqmIzzFAFvsnMWeeAckY96mSdHYtaZs3LsS7BHPA06HcnVHAMurgS5dTF4
	2WqQfHVZJqtgQ7EKOwzrp/x96TpqwH1Rs4DnEDXjgEt++u7BbsCZfgLr2eTb5Kcy2m6G6KM5rI7
	8IdpsZ8HtpSN7Zckuwx26CvQ==
X-Received: by 2002:a05:6a21:2983:b0:3d9:6f0:b42f with SMTP id adf61e73a8af0-3da39fd0822mr41240287637.17.1788813215927;
        Mon, 07 Sep 2026 13:33:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:2983:b0:3d9:6f0:b42f with SMTP id adf61e73a8af0-3da39fd0822mr41240244637.17.1788813215525;
        Mon, 07 Sep 2026 13:33:35 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:35 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:15 +0530
Subject: [PATCH wireless-next 06/18] wifi: nl80211/cfg80211: Indicate STA
 creation via SMD BSS Transition
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-6-65ad4ab30fbd@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=Weg8rUhX c=1 sm=1 tr=0 ts=6a9f1fa0 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=YW6yegcWvZZGXztGtDAA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: XRYZDG0VSRAPl8YLDD0qDdkfb80w0Gze
X-Proofpoint-ORIG-GUID: XRYZDG0VSRAPl8YLDD0qDdkfb80w0Gze
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX4nxrb69bLErQ
 S5c0lDXHlOKTLiD/CYZMurqU3gMqYhrBKFK1yai+jEQlZNzx4huvf/b3/R9vZPvBujA867a5ZmE
 YEAfFo/PWPUeI6IG/SfiCWZ8ZOFwhIQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX0jhkdy2w4Mwf
 ONBLWor0TQWhvvYdUoY+BmPmgsTKGS2EpYmRtb+rbssaZoLpLrFNnUy23Xr2jTdd4jEIBrtIj//
 9V1AJdJF5t4Q4G48b27PorVLsP3ElQPCBFrQqpL+Q2GCNeFvlJNgoTOwldPTgJeBqbXIZAeX8uA
 xN2nkaVwmY+BJHgoeh9NpWnb+jtysUw5Co6cfXRevaZvNpDAiWj9kX1eDK7Dc6v4SKMcbhu40TL
 Ct/lXCJK74vk0yvaGJ5irrZZMiJ82e79T4MqgQn5rubMIRUuRQG8SF9a4nX0WFQuD2its1Fg2Hx
 zMOj1eBwx+EUeW1aM9AP2iOnci0cohL5CptstZjzm5hOlv22SeGSJNG46WGaRLTIfbVnLLpv89q
 o4KngRH+V0szvMx46ePO3A7s1SlNz4UdXNAhJwSqyzlkeezbFu+6HSzbNWfeNPjwHLFmfzoyzuG
 hczI26jpGoz1MruytHQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 suspectscore=0 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

From: Rohan Dutta <drohan@qti.qualcomm.com>

When the peer STA is created via SMD BSS Transition Preparation on the
target AP MLD, indicate that the STA is created as part of SMD procedure
unlike STA creation using typical association. This indication helps the
drivers and lower layers to prepare the STA for handling ST Execution
and datapath switch once the ST procedure is completed.

Signed-off-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 7 +++++++
 net/wireless/nl80211.c       | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bf33cf5366ef..75d0123fbb5d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1903,11 +1903,13 @@ struct cfg80211_ttlm_params {
  * @smd_sta: SMD-negotiated STA
  * @smd_identifier: SMD Identifier
  * @dl_data_fwd: MSDU forwarding supported
+ * @roam_sta: station was created via SMD BSS Transition procedure
  */
 struct cfg80211_sta_smd_params {
 	bool smd_sta;
 	u8 smd_identifier[ETH_ALEN];
 	bool dl_data_fwd;
+	bool roam_sta;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1d8db31f17e..5e474fda2a49 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3202,6 +3202,11 @@ enum nl80211_commands {
  *	supports DL data forwarding within the SMD domain.
  *	Used with %NL80211_CMD_NEW_STATION.
  *
+ * @NL80211_ATTR_SMD_ROAM_STA: Flag attribute indicating this station was
+ *	created via SMD BSS Transition Preparation at the Target AP MLD (refer
+ *	IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.6).
+ *	This flag is carried in %NL80211_CMD_NEW_STATION.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3808,6 +3813,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PEER_SMD_MAC_ADDR,
 	NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING,
 
+	NL80211_ATTR_SMD_ROAM_STA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0d20c2ab3d5e..7577eb31ff65 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1117,6 +1117,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_PEER_SMD_ENABLED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PEER_SMD_MAC_ADDR] = NLA_POLICY_ETH_ADDR,
 	[NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMD_ROAM_STA] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -9289,6 +9290,8 @@ static int nl80211_set_station_smd(struct genl_info *info,
 	params->smd_params.dl_data_fwd =
 		!!info->attrs[NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING];
 
+	params->smd_params.roam_sta = !!info->attrs[NL80211_ATTR_SMD_ROAM_STA];
+
 	return 0;
 }
 

-- 
2.34.1

