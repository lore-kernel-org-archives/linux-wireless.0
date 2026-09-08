Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D09F595725
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887428; cv=none; b=suBJKfYhfbgzBxiYr3fGL2TNS44/TqoYCJUWNEN3dV0mbJlHppO0occQ/TuwhMB023XNpFW243/dS9q534s7Zlh4cURigY2Beh8EzxH1pVk/q+V7AkUeCbbvd0TfQseNwlw4ET8uNQ4kWUQM0/J6y5FjAPfRxF37Xssb3hHFJY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887428; c=relaxed/simple;
	bh=okDgO6J3Qp+rfKQOFHaR0Wyt8fws8ufD69oII3M+1Jg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svNMuziTK6lLCawFsfZr7VfZAStg6zZfwdc+X6ovqc0swppraFRnRnY7rmCiET4qelavz7pz2BMSfKR/ve9FM39s8zByomTZ3p4q98C9y4hBMhx1Jzbh0e9svp7KITa1JYKihbahH+nC6Bv4wg8tSxK6K+F9snoC2+pIy1QJ3gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WvFh2BoL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GeRWPd38; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WvFh2BoL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GeRWPd38"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdZuN3964232
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nlCSODNKgYyiYLj0bQxf12brdADlE9sLW5aEHOCrxXQ=; b=WvFh2BoL9HIwJNts
	rU57dRzSbWn+0mHU9byhzVGTpgLSqm6fIKPTQ+OfZFeKGFP1BEsLGGOZ0AUPqoOF
	pLlTgvYaJ9Zq+dSYlzlsju2+HgPHTgHEJ3l2Pn//6HAw16Sn9AvAWtowJNaLQOw2
	kFggbH9C9eWZ510EOmw4XVMqQQ3qi2h8jLWYGBmRj7UdRFISpvocOApUFWb0MrwI
	DN1HrwTUoo69xLuoiCAJKntHjwfrEgkYYjYRv1xV4VXwd5JFJy9k8YjTGUoVtBj+
	l+8oeBTEWVzYAuODkDhGDyisNwEtGG8iqdpHQLccyC4O4P+nsJNl1n08R6wWeCmx
	PE9nmw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjfp4a311-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so10118674a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887422; x=1789492222; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nlCSODNKgYyiYLj0bQxf12brdADlE9sLW5aEHOCrxXQ=;
        b=GeRWPd38Q2omTDPFsYuJuAwcsyk0vdGtW/f0eg5vW+TIBV+hguZuB/R119PIv4O0NX
         YXTP4ur9G8aBAXxZG4yZirA9HzdMgHfoJi6uIbauPdNYg7u5LjYe4d4/6RWzdtOuvMvG
         rk2OCnOnacl4yRJqXvrqL7Wa/NkzVJFj829Qt5vZhNtJyYsIG029YcTR9QHsfekAp2Un
         rB1MOhHHk17PkfbuTIZ5BpFtbCWIB4YXl52uYTy4KOWVBvvPUq+8C0ZnajAZ034pMyH0
         1nNvyodQdR39BIYuFjdytAtoSEZA2Thrq3mo0sWRvW/K62yHW6QG5NTunyDM8r3BFyPe
         kYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887422; x=1789492222;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nlCSODNKgYyiYLj0bQxf12brdADlE9sLW5aEHOCrxXQ=;
        b=Gx/QwH5CQik5hTwxDIDY3Hx4J6FNPZoPZNzWKxIoMuF9z0qjQYNdnQ7+0z634N9FaV
         r9HhSj5nR5t0JfbBpkGVAuAL8k+mmxfGMlZCB8Nm5cCWUJazqknk49uaynSF7vqjxioZ
         GzpXni+gpbW7hqWFh0GCWPNeZSY1X/Tl5KGVLHQ3hJUG3alyQ1oIZD9I3Ui24oUj/OKO
         syaXLFBc9XhuSWbWWfS4UKlYIkjpAvYHknEzI+kEhjvF3TWTpP2EBl9NEamuiIEiV7kB
         1+L3UMdxlN2S/AZnedSLJOdt1P0Y5RmzT4OWQGpKuLFeqXdFUGtnqJYsKLK28mKLJ92N
         tVSA==
X-Forwarded-Encrypted: i=1; AKwUvBycrVJy/f/Tn0d1lTxKhnXRmI7r7TSoyll3bmnJnrIfbjkdHfnGGEjbhW1suBfuN5XdeK6o60oiIsfSyP7pag==@vger.kernel.org
X-Gm-Message-State: AFuF++lNvcp4yEbaz8pPNp4djQ+/XduA9GVgniEzTYPNUyI1ThfYILiz
	QvGorN0Oy8KpMw6C7A8SMwON/gRfC436Y8oF3SSQ6VGHy6md26oh35U8oFHzo/MUwzDVqSOI6F6
	0r70Dno+C+kp8u+lAh7LNHS2lXSlKzprY8Ot1AwZkDvcCizO3WViwxGUehdiGkd/PTaBO
X-Gm-Gg: AYBFou1nGdxZCGET0k2rdJhosZeScMG7IOoVTWQDWwPlVT/UGsy0LUWpi31uOg1/TUH
	NTCQBWsSUo8/CNu0iI7yW9RvB9wpItkPNowJAGQSuc9Rk3nWdL2nW7hbuaBhtzSk1lZOQFXDLb5
	6t7ocOXnSkoWFVPBisX9+eCeh885NPsLGc8CPJlI1Ikow3ErBjWSreNOb1liZAzn3UPcjhMt9xu
	Js98rp8HTXHSRgMMok+92P9kHVjiO6e+KW347uDiyJTtwjlsZz+tbPYCyOjiyfgprcrdw8H1GHG
	j/rWf+m8X7MfLdSFKo0yeNsKqFjE854k0pprLQ9THhCUOKE2crLeaemi+pOKw2WruSsOBPL2iIR
	pc4/5IjYmuLLlUnzVy8MzjH3MBHp5ANUJJbEx6PGib94neSecgE8ZkuWtPhd4eUfwpwVtg3hRHa
	BCoB+QdeG4kn8UHv/au2mXZA==
X-Received: by 2002:a17:90a:1188:b0:39b:a8d8:985 with SMTP id 98e67ed59e1d1-39ba8d80b06mr1301990a91.12.1788887422109;
        Tue, 08 Sep 2026 10:10:22 -0700 (PDT)
X-Received: by 2002:a17:90a:1188:b0:39b:a8d8:985 with SMTP id 98e67ed59e1d1-39ba8d80b06mr1301889a91.12.1788887420741;
        Tue, 08 Sep 2026 10:10:20 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:19 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 05/18] wifi: cfg80211/mac80211: Parse SMD parameters in STA addition/modification
Date: Tue,  8 Sep 2026 22:39:33 +0530
Message-Id: <20260908-smd-v1-5-9fd2d876a1fb@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=Qu9uG1yd c=1 sm=1 tr=0 ts=6aa04180 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=Y27KnQjsX7IjzuVWbagA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: -BWrBv8pzmUM14PaXezotIoBGgEMlbt1
X-Proofpoint-GUID: -BWrBv8pzmUM14PaXezotIoBGgEMlbt1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX/5bfzb7RmcUg
 rzjLpMPaaEaov+xTwCdri+8dHDHetsZiZZ70Dhjiguo4hGH1n5g429SMJxY1+BEYyUHz5Z0mWRH
 ZTD5K8Ps8rX62v+gkIsvd9Zu2fx7z8+6x+DiVCGuYNDmGZ99sH7opJdKkNmQ733DzKDMFpAk9gV
 tyJgkZQd2oOi5J82PHYYESmfYEQ/TLZJVAMAttATJNY/ocuUIoLhz5Ex0o95f/1eQE3EsZzXDLv
 AyptzUeRCeYgQOPNP5kquxB0B6OFM5g54eWsItBFYIqiCNPbbTBKNIws2GXHPwTl+dfcp9GlZA5
 /fz/poOt+sjdFy3rmnFDHHCGS2frcGHQYDNw+6L7KbwVVzy3dbctOunGEgSVozUiQHHUvN1evwX
 R6lLB1CalwKrSFSrW/ioRZU/ehMDnZDG1itAIDWsV+nJyGF79QzES9WOkpKROrjEGDrKSeWe803
 jMH7ASHQPAoSVp6ZXYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX7opexemzex/P
 MkohfmCyqfcjkE8P686oCOAjESZqvV1SPylLiGnI7jygGckLQekhZTDZgWbOaLK/zVufogGENOX
 RjKMSQlSmY409xhR0aDZfEvUhrgiMp8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

From: Aditya Sathish <asathish@qti.qualcomm.com>

When a non-AP MLD is getting added or having its capabilities updated,
handle the SMD parameters passed from userspace. Otherwise, drivers will
not be able to identify that the non-AP MLD has negotiated SMD with this
AP MLD during association nor can they support SMD BSS Transition if it
has been requested later by the non-AP MLD.

Signed-off-by: Aditya Sathish <asathish@qti.qualcomm.com>
Co-developed-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Co-developed-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 15 +++++++++++++
 include/net/mac80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 17 ++++++++++++++
 net/mac80211/cfg.c           | 10 +++++++++
 net/mac80211/debugfs_sta.c   |  1 +
 net/mac80211/sta_info.h      |  2 ++
 net/wireless/nl80211.c       | 53 ++++++++++++++++++++++++++++++++++++++------
 7 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d0a269f4c711..bf33cf5366ef 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1897,6 +1897,19 @@ struct cfg80211_ttlm_params {
 	u16 ulink[8];
 };
 
+/**
+ * struct cfg80211_sta_smd_params - SMD parameters for an added station
+ *
+ * @smd_sta: SMD-negotiated STA
+ * @smd_identifier: SMD Identifier
+ * @dl_data_fwd: MSDU forwarding supported
+ */
+struct cfg80211_sta_smd_params {
+	bool smd_sta;
+	u8 smd_identifier[ETH_ALEN];
+	bool dl_data_fwd;
+};
+
 /**
  * struct station_parameters - station parameters
  *
@@ -1937,6 +1950,7 @@ struct cfg80211_ttlm_params {
  * @link_sta_params: link related params.
  * @epp_peer: EPP peer indication
  * @nmi_mac: MAC address of the NMI station of the NAN peer
+ * @smd_params: SMD params for this station
  */
 struct station_parameters {
 	struct net_device *vlan;
@@ -1965,6 +1979,7 @@ struct station_parameters {
 	struct link_station_parameters link_sta_params;
 	bool epp_peer;
 	const u8 *nmi_mac;
+	struct cfg80211_sta_smd_params smd_params;
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6b82ca07fbf0..d8f5e5d8a021 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2727,6 +2727,7 @@ struct ieee80211_link_sta {
  * @nan_sched: NAN peer schedule for this station. Valid only for NMI stations.
  * @ext_mld_capa_ops: the MLD's extended MLD capabilities and operations
  *	NOTE: currently only tracked for AP STAs
+ * @smd_params: SMD parameters of the STA
  */
 struct ieee80211_sta {
 	u8 addr[ETH_ALEN] __aligned(2);
@@ -2761,6 +2762,8 @@ struct ieee80211_sta {
 	/* should only be accessed with the wiphy mutex held */
 	struct ieee80211_nan_peer_sched *nan_sched;
 
+	struct cfg80211_sta_smd_params smd_params;
+
 	/* must be last */
 	u8 drv_priv[] __aligned(sizeof(void *));
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f5c8dbe5f26a..f1d8db31f17e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3191,6 +3191,17 @@ enum nl80211_commands {
  *	%NL80211_EXT_FEATURE_SMD.
  *	Used with %NL80211_CMD_START_AP. See &enum nl80211_smd_params_attrs.
  *
+ * @NL80211_ATTR_PEER_SMD_ENABLED: Flag indicating a peer STA has SMD enabled.
+ *	Used with %NL80211_CMD_NEW_STATION.
+ *
+ * @NL80211_ATTR_PEER_SMD_MAC_ADDR: Binary attribute with the 6-byte MAC
+ *	address of the SMD-capable peer STA.
+ *	Used with %NL80211_CMD_NEW_STATION.
+ *
+ * @NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING: Flag indicating the peer STA
+ *	supports DL data forwarding within the SMD domain.
+ *	Used with %NL80211_CMD_NEW_STATION.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3793,6 +3804,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMD_PARAMS,
 
+	NL80211_ATTR_PEER_SMD_ENABLED,
+	NL80211_ATTR_PEER_SMD_MAC_ADDR,
+	NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3942,6 +3957,7 @@ enum nl80211_iftype {
  *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
  *	previously added station into associated state
  * @NL80211_STA_FLAG_SPP_AMSDU: station supports SPP A-MSDUs
+ * @NL80211_STA_FLAG_SMD: station has negotiated SMD.
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -3955,6 +3971,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_TDLS_PEER,
 	NL80211_STA_FLAG_ASSOCIATED,
 	NL80211_STA_FLAG_SPP_AMSDU,
+	NL80211_STA_FLAG_SMD,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b4b42790c5d7..138b67f4bda4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2528,6 +2528,16 @@ static int sta_apply_parameters(struct ieee80211_local *local,
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
index ef75255d47d5..d7e7c9c578e4 100644
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
index ee0d32877c5b..506aeb241a6d 100644
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aa7aa70a5b41..0d20c2ab3d5e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1114,6 +1114,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_STA_DUMP_LINK_STATS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SMD_PARAMS] =
 		NLA_POLICY_NESTED(nl80211_smd_params_policy),
+	[NL80211_ATTR_PEER_SMD_ENABLED] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PEER_SMD_MAC_ADDR] = NLA_POLICY_ETH_ADDR,
+	[NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -7702,6 +7705,7 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_TDLS_PEER] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -7768,11 +7772,13 @@ static int parse_station_flags(struct genl_info *info,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
+		params->sta_flags_mask = BIT(NL80211_STA_FLAG_SMD);
+		fallthrough;
 	case NL80211_IFTYPE_P2P_GO:
-		params->sta_flags_mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
-					 BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
-					 BIT(NL80211_STA_FLAG_WME) |
-					 BIT(NL80211_STA_FLAG_MFP);
+		params->sta_flags_mask |= BIT(NL80211_STA_FLAG_AUTHORIZED) |
+					  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+					  BIT(NL80211_STA_FLAG_WME) |
+					  BIT(NL80211_STA_FLAG_MFP);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
@@ -8913,7 +8919,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -9007,7 +9013,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
 				  BIT(NL80211_STA_FLAG_WME) |
 				  BIT(NL80211_STA_FLAG_MFP) |
-				  BIT(NL80211_STA_FLAG_SPP_AMSDU)))
+				  BIT(NL80211_STA_FLAG_SPP_AMSDU) |
+				  BIT(NL80211_STA_FLAG_SMD)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -9261,6 +9268,30 @@ static int nl80211_parse_sta_txpower_setting(struct genl_info *info,
 	return 0;
 }
 
+static int nl80211_set_station_smd(struct genl_info *info,
+				   struct station_parameters *params)
+{
+	struct nlattr *smd_mac;
+
+	params->smd_params.smd_sta =
+		!!info->attrs[NL80211_ATTR_PEER_SMD_ENABLED];
+
+	if (!params->smd_params.smd_sta)
+		return 0;
+
+	smd_mac = info->attrs[NL80211_ATTR_PEER_SMD_MAC_ADDR];
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR] || !smd_mac)
+		return -EINVAL;
+
+	nla_memcpy(params->smd_params.smd_identifier, smd_mac, ETH_ALEN);
+
+	params->smd_params.dl_data_fwd =
+		!!info->attrs[NL80211_ATTR_PEER_SMD_DL_DATA_FORWARDING];
+
+	return 0;
+}
+
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -9399,6 +9430,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	err = nl80211_set_station_smd(info, &params);
+	if (err)
+		return err;
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -9627,6 +9662,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, wdev->iftype, &params))
 		return -EINVAL;
 
+	err = nl80211_set_station_smd(info, &params);
+	if (err)
+		return err;
+
 	/* HT/VHT requires QoS, but if we don't have that just ignore HT/VHT
 	 * as userspace might just pass through the capabilities from the IEs
 	 * directly, rather than enforcing this restriction and returning an
@@ -9660,7 +9699,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:

-- 
2.34.1

