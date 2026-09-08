Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80BE337BA4
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887429; cv=none; b=cP5QoaY7tKVNFR9vG3X4jJwBd8fwcttgy2tMYdBcFBCXFT2jSfUPH9DCRKcxFell7uS5M8PWajidknqByxRCHYNGbtodwNM+O0qiOHkS/87m1ena2mkVBX5NUyFLGG03FFbPxv7BUTp4k7oDHdgSsKitF/Z0oscGMOhO8rJVQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887429; c=relaxed/simple;
	bh=n6QZOZ4ipBg1ZD4KtCHhdn0h3EQTsWMtpUTn1ZHyNpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SflX6QxKmRbHslPzaJTk0oGGS4Z6rZ9rZu99qIxebqKNX0BKihl4MKKpKfFOUyoqMVBZoShNpBgetfwNkskmmSVAa3HpMVjdXlkYDVEqr0PZnjjRR/VDBh2o35dwtv3XtyvTSDK3x0cTY1gZyop6hhxTh4ESrUYWQgWrmXULRpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P14et4ST; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c5ZSajN0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P14et4ST";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c5ZSajN0"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fdun63613881
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4cSKp76Wny+ccMBfbKuXS85MttxoIgTePwgcdN/NDrU=; b=P14et4STYhZg+RU/
	kkrax5emSypPbcKPFH0rDmaMyJZRXBfoM3RSSWHDTH4iMbwHsQhDIZtaZVyNUtVC
	TZ/3nwE7x8GxJdfruiRx7tFSvWGS5QBTBcPc2zNTOydaicr82pdG6VJ/uMyJ30EF
	uRfnvgdx3socpHCBLYKP8wFNXy+jWNwe7OtaX/Pj6CPTHzx4S6Sdb/kLn0e1fRo4
	5NFPEuKDGnGJmBPWtfwduUsPFMk203Z0YJqEOaCICIolmZEvdDKjakQteMPcb1Le
	6eIKopTDbjOfirnfN5t0zSQO9yVKkRqaecgZpwIbxIxcjquIs0CNN1fDsGljeHM+
	h2VhVw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjagukduk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2db3734d06dso61327575ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887426; x=1789492226; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4cSKp76Wny+ccMBfbKuXS85MttxoIgTePwgcdN/NDrU=;
        b=c5ZSajN0Mh2Z+DnAuVpFhy+ylQswyS1SRYtKPLv+PiJRy1QQOfgpufuNvJUyYjmGyf
         9+4eOCOM1mCGcPew9IdFIReRVExCOllHJPCggYE/MVz8Cz3buVOHBvOQE0nvNQpWd2/c
         RhLIzLcakrOdM295bNkYdNohUF33nyBNgmJxA7xRasZMA47tz+WRglagwdY1iZtHgx1q
         UNJg8sGB9Fw2LTGCNYc0RymGtWWveldmPeu8bSZoOkqQ0SLCzVkbQ5BWa4euwz367QPH
         8CwE/ONWwauSYqaEbgK7ACpVWHLSC8/+TUWX328svL+uvaNQplTKkqPSChUVBH4HUAEV
         9v6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887426; x=1789492226;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4cSKp76Wny+ccMBfbKuXS85MttxoIgTePwgcdN/NDrU=;
        b=oNa7vFZR/X7bIvoNmWQGWP09pASUB0xZg8bvnT/DBAI4mxFN+qBowAMeOg9p98qAhW
         0psi5P4QI2JYkEjaBKE4M2YB1BFhN9nF3Ej6RicEQrG1btKs5y67ng/F47YG+Wp1FW4r
         wEe1oV4IP/lLrqHXc1IR49amEtec59tc3uirmTevMV2sIJRWwywt1JTePE3LNX78dRSl
         iVrP3VzM9EgPY5E0udyJj0zw1ye0zs8m3/surxCo3LFIdeIevQFw/seN5Z7zgCDrnbzy
         9Pc84PFZBdVKxQahYEt7F/i4N3BU4srFLFPI4NtcrDxRn93cO6k4RJqfxWciCXBCrIx/
         ksXA==
X-Forwarded-Encrypted: i=1; AKwUvByDEEr+0Hn6Tq9rKqzUbFO55ddcmfJYHj/x+XICEGHpb9AKsqW90bD0i1/wZOl94ds6enJ+ci0YZRzvxCMNtw==@vger.kernel.org
X-Gm-Message-State: AFuF++nbwL4LRIFVCuOfFC9p8Rqpj2uP7d5n7Qx+A810LIgKDoyrh57x
	sutQK7CBfKQtu0zCqwsdvafpNAqwVmx84/+Dd7JAGcAxr70ceshJL0Mi2tUGnAen/IGHCS1P8RI
	XReAeEYjRQBbVDEnndwUF8qrmuh5ABmSTzf8GBmck3r0CPkKBtyFluWBg8F9ubM8t3Unw
X-Gm-Gg: AYBFou1dRY2Wa2BklVMWJltw543wRfu744135a/FD7tiwljvUOXlXSd1uo/ad/REaN5
	4VhyODpZTCtFq+heGLZOi6LzC/jwe9I58UxPyL4O5LvyQhfafNkMa46HvDsTCsQQexVSZLhZMou
	Ys4z+c09MNuUa0qAWHcRF/SQf2COJEIrW95DMTjWkjW1iaX6xSDRkfIv2dlRds62X6f/gMb4GeN
	XtEB4oX1MX4qaCtXUPw9j2SjhBsg/Ya12eafixHC51kuZmqV33rBjuY5gzMUbJaqRgHqTwkK2y3
	8uQaWLn2aVbFiU+rQ1uAzd37nt9eV1ha7iX2oknkPj1rzArmtfRGJpcAwmm4JMrXNg3Bc0H6uiD
	e8cZSCGiniDjntUTBYodecyQlG5gbn9szqPqGSEsLbiHP8BdjQ3PAcQPsc36btUKBqjbGQjKjuD
	cX71IK9E1sQADNx4r3LbRDfw==
X-Received: by 2002:a17:90b:538b:b0:392:e5b1:d833 with SMTP id 98e67ed59e1d1-39b261d5148mr44232781a91.13.1788887425609;
        Tue, 08 Sep 2026 10:10:25 -0700 (PDT)
X-Received: by 2002:a17:90b:538b:b0:392:e5b1:d833 with SMTP id 98e67ed59e1d1-39b261d5148mr44232726a91.13.1788887425070;
        Tue, 08 Sep 2026 10:10:25 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:24 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 06/18] wifi: nl80211/cfg80211: Indicate STA creation via SMD BSS Transition
Date: Tue,  8 Sep 2026 22:39:34 +0530
Message-Id: <20260908-smd-v1-6-9fd2d876a1fb@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=TqLWQjXh c=1 sm=1 tr=0 ts=6aa04182 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=YW6yegcWvZZGXztGtDAA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: DgktfXcUu4P8RRCdQHTFxCevO1NQTdWf
X-Proofpoint-ORIG-GUID: DgktfXcUu4P8RRCdQHTFxCevO1NQTdWf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX+WSYqe8dkgwM
 9LsTxF9X1BjyOnGR+XVwlIjbxrwupg3YPyUlxzbBCze7FaAtExjlG2t3eui5ZpYsSdb0jcqWD0s
 b/kyrejD6ZDAAVca5+Bi48hSJUo7yPA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX4pftQ4mYSKjt
 5ODFFsFV1f180ASt6SvUWKgZhwYIWPBgWptA7v7vV2jRINqMdAO1KuafhnsWmqSGh6ivD9FXInE
 Pn0jWylF7LMbyfdcscgVHdG0zdTgF13f2WvMT9Eem4Qz4ui59vPProhvNGF6St2ITxoTjQEu8TF
 sjSJknq35U+hteDJvhahf7nF8/7o9RycilVrWvXbXLD/WRALwj0Q+a4BAjme/A3HtCZE7iqvdU5
 4tVr9OjK4nYc7PzIxiScL+M24o4mYdBPB6V/sLlSy0bc7z9/WQbWXvI6XZLJzopWdYH9o5UTVDI
 51BUaNlPBoX+X8UqEl4+U1ooN9h+FGxmHV/MKVrIq39xTdhDL99nKYjW4T/PcekH3xbZBbCZJj+
 NPjqZV+S/ntJHx09Q3kJSS+wZ0cxHyn18qjmBW9WiDX/fVaAYZLYhRX+rF+lGYZqfpivNWpHHKB
 NK91Mlj7M6iEDSMJYeg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 malwarescore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

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

