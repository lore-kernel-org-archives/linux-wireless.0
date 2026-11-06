Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951998;
	b=kfCt8BJ5Y7RiAJKHvjTJVNJmSIi6ocdFtVgaUSXojaZkBj81I2Xf9eFwne/cuRULZzW9
	 q2a85bqcMDlq8MvvhlFtvLteugn2rodwRZSfMdHSQyWR0IGUZnEQ2TkTd1WES6KpaSuYV
	 2Zw1W2iYOM4RxhGXOjbgeOUXgghPLZvlrdac5IhLWlnkti5sGHEWpptdP7X8hMgzZQUy7
	 2cTbXtagBVxt5JkTD/882NmmhF5DSkTqkWbbvPJw+OBh1uQruZwh34twHe8ppzs83wOkP
	 XrDLkdcpwZhsFt0lYoVVGaXdNIp6cWU/zM9Uwy/IMA+MRWOKuX6unt8RYkTMMZylejQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951998;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=K7Rs0bymkxjSQVmD5S9xd52rJVwRLbCLDF7LJZQJuzc=;
	b=kXodUBfFeIb6gimqw73RlYHjOscEeAUfADMAjfMV9wyaPXd24v2X54i3vkw100CjJxqS
	 h55EyuRVQpqreZiklYaxmpXpoirUY6I5MysvVMQTZapgoSqwmfkjx2aS98txMh+/nFpu7
	 pXO0ufzj4q81e4RLo40liiE+9QpSjyofwb4e6v04pBWRQFgDbo6r0pGd7EO40NX6KlN5G
	 A4rQMwuIKk1jybyE/fXQ1ne49BrJv7RGeQnIan2711Ya8VDhowji4uLX5rJfUtQXUGtyF
	 nmRQvZAgKi0+M8iVsJ3ZJ54w7J069zIQdAvGcH5jlCIkoalNjEIFzXdnebvq6g943bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ERqIW8ty;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CiRZC6pm;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99668606EEB2
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99668606EEB2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ERqIW8ty;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CiRZC6pm
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RPKx1679899
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K7Rs0bymkxjSQVmD5S9xd52rJVwRLbCLDF7LJZQJuzc=; b=ERqIW8tyqgK8hWAK
	P/m1HlAf3ZbQqrHCDTJhfO5Zbyyi/zOFOuMiCzibRLXf+Cc6uFZaK+JBcT9/3Usf
	DFnt3x6Tnlnzi9sLtxYBoTYO3c9zyE4zDng70CzEJJBWtHvaJltwQBDFCPWunGrs
	A2pDV6vYwNlRJIxuvHox6gxavsHf5gHfg9CL5vaRoyoyYE11eKdBCzPlO7FCUJGi
	JwQgc4S2TSPm9By57K+wA6V/yJ9b+Ld3BARWdSarsRMUzgmk2umYSYs8ohGuRsTf
	uQAtaJJaH+6kQQU6aLMTG/J0Iv+kPF3QsmmMoOUZ+FzP1VKz+CFx1ZpjEbUu3a3u
	Tii38A==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pc9qgk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:57 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b0a9de9c2aso340066a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951996; x=1794556796; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K7Rs0bymkxjSQVmD5S9xd52rJVwRLbCLDF7LJZQJuzc=;
        b=CiRZC6pmPDjCyn5dXpSaV85UAro4Wl2kmt3TWuP+Oo1x3i6UqQlDvMsPpWrdReYU4b
         +wp1DWtaq4dKdcM/nLGmCQ2N0ZAu/+Q2bXnYlBuNUFZME/CxTqqL8xxXkldx0m8+cOUi
         dNbAGWVXNoOLuaUyLSXzbQ5NMfxMtXIVvZxS15gou5WmxCfyqRC7ahjQXfQJWUKIVSdv
         mS5GWBPS1HhLcgMf1FtDUT+4epxTKyZ3mblOl7hhcmw1a9ivcoB0eYX36Q2Yrq1hTDwW
         PX72l9VvZpEugFrzMtZc2OyEahIgaD/XKsnAyPGHvClPBkng070rZ4VSAZioG6vTGevf
         pgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951996; x=1794556796;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K7Rs0bymkxjSQVmD5S9xd52rJVwRLbCLDF7LJZQJuzc=;
        b=ZvMSI5HTxTLhW0YBjEHenecNZrwilTigCOFYGvu1FK5PdfrqlRRSYbTdPlX9seg5Fl
         2vTRB5OhP33HWaxYZB48Gjd8JGAwJTcWgBBdYpOa1TYACVh2Z1jLZEcWobJXotOhZfYO
         gT0/6b2BlyvbH4B+7zG/aVF8GyFfwz/OI4GcoLeunVapmwsVVXzEaSFmGc8j+gcZfL3j
         CQT+dyrSoxHyP9ogXIVSO4rgdEJpve5cP3BSD8oJwbZI6QFYS5+/caqZ6NTduIb2cxPS
         JaG9QSo3RGdE2BlXdhLfj8fH4muSB6WBlTIXhtQULFmplbrK+8bC0VQ0FTudKkr3WJoX
         WeSQ==
X-Gm-Message-State: APuU4Z/0JJCAJt/JE+h3h5rN2QUXxS+Q0PIsH3dpbQJTlzdfITOqNdYh
	25IBciCSCiueFJASfXSZEtf7UJrpIxpNg30xzSNZrBF4d9lTUxSU67nOA4sbuQPSaKs3ETKGDAt
	IS79scyyGUWrMgUBJ6eSr/OZWTtdrBTlTdDzh8Bd839nOVwV3yolTD7WiPLd0W/KupP83
X-Gm-Gg: AYBFou1n6pqT6JZwEQ5qwMQ7G7dtbPMn3e6mv81XrXRdymsfChEBEJw7jM4LyTty9FQ
	cArdxLaxKZqstJX8lzp4oH1Xi5ItH1SmlvyfUMbIkEGruWrJ8Xm4k5c/f7QMsjw3dJvbl1IAg3g
	JdwaYH3HusrLcEsuhj3lmgfIgbkQvnXTMs7AJk11g/d4e0LzKc9j2dixGHWQdf0ybUtI57KZViI
	Nz4naih2wXzNif53iTWMuH+Q4/6BoyvcXBlPoNtBKD0FW0i7glisV67G/qaz2o+mSAe/5wNy3Pz
	Hc9OIoetl1kZ5F1YZeXuRYMbD6sWZZ632CcnUXMI/eihO1Fp/xdxPwEWtIIo134ja3JwR2cxZbt
	7q2iz9l6DA8VhL2vUuWoI6BcnIhHhfw7MurQaNnN9nfHa6rD4fObpHsVHoicLmU5/AG2wqHmTvq
	Ouc4PgQZSEIwGXI6Fe4Jo9MZy/m5GmbiSHz5ZN5Elk+OHPmGZGg42h2UVJv4QbebsTPpXJ2UY=
X-Received: by 2002:a17:90b:1642:b0:3ab:b764:826c with SMTP id 98e67ed59e1d1-3b0db6c9c9dmr1739782a91.12.1793951996283;
        Thu, 05 Nov 2026 23:59:56 -0800 (PST)
X-Received: by 2002:a17:90b:1642:b0:3ab:b764:826c with SMTP id 98e67ed59e1d1-3b0db6c9c9dmr1739761a91.12.1793951995745;
        Thu, 05 Nov 2026 23:59:55 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:55 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:50 +0530
Subject: [PATCH wireless-next v4 13/21] wifi: mac80211: apply SMD BSS
 Transition STA sub-states
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
Message-Id: <20261106-smd-v4-13-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: Ksn7ncnTdto4T0gYqzrfJLBcG_VCMUjP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX+T8wFxvH6xHE
 aPZtpKXoO44pqJpJrENAWWOlFGO8FhgOJ57AApVJ680d3hZxfwFAJ6xF4fVXdLQ+J+89V5i0JpT
 XmlG82+0/MpMqZK/7oH8QxocbQIMuBDwVkuwhEmuIU9aPpo8zd+Tz1/SHiZ2J777LMOpeo5bDrL
 pH+vXnA4VPA9f5DIHiz6UJ0Umx7S2oQg919ZZ8481iT4rKqcEdQTf594xi8jinJBieJ+PUD6jp9
 tKfF3X4bYEiiuf2G4fX3QHXsLsg7aRW5jFk7BEbQY/3QOWpXTv5cwQSHhqowc0yTitv7Pl8IDhS
 guZGvTkxd6FqoYARvmrARqK48ty6tgj2b/qFNEV7DRU5oIyA+DGCVN09K9oHoXitIdrxgTnBcbK
 GxopWmX4cN+6LvsXx2CzwKV7IxD5A/tbzn2nNmPHacPoePo8g5yxt9++kn2NsraTax+yr9ZkHnz
 PMyj7InzjiJceSlosYg==
X-Proofpoint-GUID: Ksn7ncnTdto4T0gYqzrfJLBcG_VCMUjP
X-Authority-Analysis: v=2.4 cv=TI3Q2Fla c=1 sm=1 tr=0 ts=6aed88fd cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=S5cDeCcwn0inUhub9TMA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX+WSwAJNZdWuj
 cjNn7OxbA8gFQTron+Z3GoCog0Cov/oSNtZEdWLdlGnIorbmByKre+OirpLojCdliFce4W5lv3A
 cfGCKceqLQ6xsJ8MeLZZr4KbSiepUoc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

During SMD BSS Transition, the non-AP STA MLD roaming from the current
AP MLD to the target AP MLD switches its new SMD sub-states. Capture
these state transitions to track the station roaming.

These are transient sub-states of WLAN_STA_AUTHORIZED with the SMD-ME.
The station remains authenticated, associated, and RSNA-established
throughout. At most one of the three may be set at a time; mutual
exclusion is enforced in sta_apply_smd_state_flags().

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 net/mac80211/cfg.c         | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_sta.c |  3 +++
 net/mac80211/sta_info.h    |  8 +++++++
 3 files changed, 71 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 37329d8748ae..1e0ef74a7420 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2704,6 +2704,55 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
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
@@ -2790,6 +2839,17 @@ static int sta_apply_parameters(struct ieee80211_local *local,
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
index c2268f79601b..8071ca4c5f06 100644
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
index 54c4c613a2da..2e9bb2ab567f 100644
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

-- 
2.34.1

