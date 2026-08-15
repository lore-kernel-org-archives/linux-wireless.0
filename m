Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC25235BE2
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 01:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786758219; cv=none; b=JHCkTCOXohVbhCXSleqgaMVMgdDLLs8paLcghIumBS0aPJcv59hCfm/raQVH+Yj/05wgE2pDRWBKdQJxwZHm1xZadkO2COYLCmR9oaKp10eIEsn7D+6z/pRV1YhGdVGwPs+5B69Su0rl7TnlLR0QBlvhirZMySrVva5016PEvxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786758219; c=relaxed/simple;
	bh=+JaYK3lvTGqZWfDgrV6pHHo5zKiraVEFX0Wr9MgC5fY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YQonelGR62J2ITpx7Sj86Pfr8LQz2fOD8f950Lq2qXIcZa4z329bkViUNZbzBf9/M+yew5sws/K4/evnKgZ0Dg1WTPsYWzKPTwZR/1fBZWxIM/8NnkC6rr8Y2QDChTNleztwQwjbL6JwNAF2Uk/UEXjjo2kAs/nXAG7FSyS3dTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Zbngagli; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XWSlEp3s; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Zbngagli";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XWSlEp3s"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ENCG7P3122092
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 01:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=HJICPyMYD71slts6QyaSLY21UYKJuFWLkG8
	AaM+C45g=; b=ZbngagliMlc2ECMrHwp8wE39CJ2cv8CVHJ0SC9loOJkoQOtpkR2
	bx6TPxeoSk6li+fwBgnM6xu7+LtUIGeoLQjiqhxItJqdcxJqZJI5UwtRgL2cdXbG
	YWcXXGHaX13hXl1MyaOtiJZv1HdJbD48QDatxoIDxptka2XNN+3HtkYKl9szNxkn
	bem1rAmSwso8+kTBEotLm5kAA+UJhNjmMSaVSMofoz2XtP2x8Yj9W6ycZiwH4F//
	3bgt15me8eD5bNn8oRNwRU0vhDrxsA0zu3ochmA/xnvAYp9YVSEjgaXqTSMIpH+g
	H8OpaAjtopO5lu0R96cpULXELXnCTxNqjUw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g20gnbjr7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 01:43:37 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccb687f82eso24117705ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 18:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786758216; x=1787363016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HJICPyMYD71slts6QyaSLY21UYKJuFWLkG8AaM+C45g=;
        b=XWSlEp3sB+PUIYvLWQBjIOqSA+Cu6qMaFZ5sjQb71KWPSqh/k0BHRFfavdeGQBgF5P
         cZgQNshoxQMtmJjdxrFm/CYrP84jJUusocdCpgWlyCqv4BMT84JkpPc01EMa74lf9qoS
         X9sWVQVKMdpsXWU/gaSdUVslTEViVZHtMmcw7rtPUJY5G3f0zMMysiP7q21QDxq0uf1E
         l5JXGr/XiZOeZG57XMtl4krkdkEn6+JZ8P+oG098G2xCcnmM5biMJFFt6QvCPev/ZtJ3
         Kjr6nB5MfGCknvv3FvAnkEvEgobHZUuD+Mfn9OPw7aisooK6aX5pIOTz1A9Ba5LAQ5QR
         6W+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786758216; x=1787363016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HJICPyMYD71slts6QyaSLY21UYKJuFWLkG8AaM+C45g=;
        b=Lddk9CxRsNVjmbHfZN8Nfp8EG7rZHUPos9id0BbNo5JiW9ttRqPJoHDXL/d3fkEKOA
         PE9o5FRMGOxShI85OuCtYbIL7fVd1HStSCWSiuMCTvhimoN7gQVNytV6MkD4u1jgLn1i
         cIK21LLKymq+NljvLf8MHw63yWd55/KAJ5H9jVEeunS7oM1Cu0Km1fxIQXsPxTEzaFaE
         LVFaUTJFBIbZxkdst6tI2SdlI5ozMmOiwwihqp0g4geTC1uoYIOPyIRxw6bn3grknafQ
         SHLPvZWKhSwK20mrXmWyRKb60lh1z9LUiMHbaJGioV7gMG7Kr7ME0oqNGFT7m4n9LXKS
         TrdQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrm4f+xr7HFSd77+Xl8wY/i9VQwR7O0u8hwUcctQruktB+lhWnCJh/cQM6Qv72FSiR9V5m/sG5yBeWHovmrvA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5+7Nkx1Y466i0ThyI6TIxrlWRchRrJhqc+b7I2HEQvJoKATUT
	/dgnFoHnVBmFUegHDARH3YDDLbJtqbkncXJUqZzaO4C3vVmfddiutii89Wft8DnUzxETC9WVG5t
	oM5IG8RLHWni2/0+IPNWpAJ6mqw/UT1ybJilMZ3eN3Z8vuSjVOSkeEdEiJrLPTWVGSwcCbw==
X-Gm-Gg: AR+sD12pEu2fqbrVOS1/x/9R76fElV0+wwkzpRr6y2hUXVLmS3IU18IT+k/K9Y0xuWR
	iv1yIBdkpYaEHcCbzpMEWEb9Z1pvv+UoudbisJdRcBeDA4CC7w2rXKAMcCpCLNXW4TGbVUJ+Pyn
	nlL4N3tQBMtaVlr9UAODks9T3qJBkwh7ZJXWIipF8V3qpgf1Xzq2SUNgG+W6VF+yt3m7jZHQ6U8
	fUDKWmmEpW7Kf3hSpf3sGsnJ8PyK6En5AztoPsqeGVKe/27+IdW74aNF+KSateYeRdIfBQtMDzR
	L5JMmVGrwvrWrMu9KIAXn2XFsE/oLII8/4WXdRTeTeZ/ggs7d48O6xc34Wsd8idjAq3+Q2wd4b0
	eqUkf+Qr+ReA+X0n/SgA4sC6C7X6Nsg7V6x3cUbkJMtx2vE/VsteI9Brdfgw=
X-Received: by 2002:a17:902:e948:b0:2d0:cc92:f7a7 with SMTP id d9443c01a7336-2d3b0e440a4mr122923825ad.13.1786758216089;
        Fri, 14 Aug 2026 18:43:36 -0700 (PDT)
X-Received: by 2002:a17:902:e948:b0:2d0:cc92:f7a7 with SMTP id d9443c01a7336-2d3b0e440a4mr122923445ad.13.1786758215670;
        Fri, 14 Aug 2026 18:43:35 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aeb8937bsm16418705ad.65.2026.08.14.18.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 18:43:35 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: fix MLO 4-way handshake timeout on QCC2072
Date: Sat, 15 Aug 2026 09:43:29 +0800
Message-Id: <20260815014329.3748059-1-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE1MDAxMCBTYWx0ZWRfX9h1q/SE+2b8s
 Czg1HaqIje/10EuFrbG21lOp1VpbkvyeyqCKurcy5a4Fn0I+YIlzKKjeSuurDFl/Ip3Ar16c7SN
 ImUj1hJZm/gjswLhX8+WTSY6c32+ryysqdJUmMjjPUNVzJlK2Gx3xRtBkYvr2nQRH4PlKbU7idA
 oL+jIHz9x9r4RGsoQVtTR9HdUDUmeLZYOJKXmJ1AMsH1YMTpHgwodGXTnU0Jg8OwpiyuITjeknj
 4tWQWEMYbQOBoPuLrmoPfZVrozjSG1q5gd3aN7psluG4ytkNOm656JtGepBYSg73oImlq7+4Ivp
 w2618ed1lyMlVZoR6GM7oz4yc9APzt5aVpuFiRCeePoy7ZKLT3waGiTikMy55MocEcDbye5QApY
 VvF1sbY7pdomB0qc2QT08rndriv0ut0V0wX8JoYK5Ve6TCZwkDrEockKm8GR0VPRTevsAEBt1UZ
 /HhVgla9qOWZ0RAqEpw==
X-Authority-Analysis: v=2.4 cv=DdMnbPtW c=1 sm=1 tr=0 ts=6a7fc449 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=wvyN2lhKwasRc6zrnsMA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE1MDAxMCBTYWx0ZWRfX7+O42D1UeJuh
 1vhJ4MTNq4+HpVaS+oemZtUVBKJterCHkS0TXVaMRtihXCIe8rX1xFuqsJgYPNJWciM8jjT8xtA
 L0oCbRxYEVBZv6wZ2yhUIH5UljKavWk=
X-Proofpoint-GUID: qwhiAdD6dyTZfAqO1n3pLynMWVynxxJ8
X-Proofpoint-ORIG-GUID: qwhiAdD6dyTZfAqO1n3pLynMWVynxxJ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_08,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608150010

In MLO connections, ath12k_wifi7_dp_rx_set_link_id_wcn7850() attempts
to resolve the IEEE 802.11 link ID for received frames by matching
rxcb->peer_id against the link_peer->peer_id entries in
dp_peer->link_peers[].

This fails for EAPOL frames because the firmware delivers them via
the MLD peer path. In this case, rxcb->peer_id contains an MLD peer
ID while link_peer->peer_id contains a link peer ID. The mismatch
prevents status->link_valid from being set.

When mac80211 receives a data frame with link_valid=0 for an MLO
station, it calls link_sta_info_get_bss() with hdr->addr2 to resolve
the link ID. If hdr->addr2 contains the AP MLD address rather than a
link address, the lookup fails because link_sta_info_get_bss()
indexes by link address, and the frame is dropped in
__ieee80211_rx_handle_packet(). This is observed on QCC2072 where
EAPOL M3 uses the MLD address,

  deauthenticated (Reason: 15=4WAY_HANDSHAKE_TIMEOUT)

Fix this by resolving the link peer using the current operating
frequency associated with each link peer.

For 6 GHz links, the received frequency corresponds to the operating
center frequency, while for other bands it corresponds to the primary
channel frequency. Match the received frame against associated links
using the appropriate frequency for each band.

The frequency-based lookup is used only when exactly one associated
link matches the received frequency. If multiple links share the same
frequency, the match becomes ambiguous and no link ID is assigned. In
that case, leave status->link_valid unset and let mac80211 fall back
to its own link resolution logic.

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00228-QCACOLSWPL_V1_TO_SILICON-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: a2fe9dc70f3b ("wifi: ath12k: Fix low MLO RX throughput on WCN7850")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 55 +++++++++++++++++--
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 95d87dd67872..a3d016d0fb5c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -2331,20 +2331,63 @@ ath12k_wifi7_dp_rx_set_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
 				       struct ath12k_skb_rxcb *rxcb,
 				       struct ieee80211_rx_status *status)
 {
-	struct ath12k_dp_link_peer *link_peer;
+	struct ath12k_dp_link_peer *lp, *link_peer = NULL;
+	struct ieee80211_bss_conf *link_conf;
+	struct ieee80211_chanctx_conf *ctx;
+	struct ieee80211_vif *vif;
+	struct ath12k_sta *ahsta;
 	unsigned long links_map;
+	int freq;
 	int i;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
 			 "ath12k set rx link id called without rcu lock");
 
+	if (!status->freq)
+		return;
+
 	links_map = READ_ONCE(dp_peer->link_peers_map);
 	for_each_set_bit(i, &links_map, ATH12K_NUM_MAX_LINKS) {
-		link_peer = rcu_dereference(dp_peer->link_peers[i]);
-		if (link_peer && link_peer->peer_id == rxcb->peer_id) {
-			status->link_valid = 1;
-			status->link_id = link_peer->link_id;
-			return;
+		lp = rcu_dereference(dp_peer->link_peers[i]);
+		if (!lp || !lp->sta)
+			continue;
+
+		ahsta = ath12k_sta_to_ahsta(lp->sta);
+		if (unlikely(!ahsta->ahvif))
+			continue;
+
+		vif = ahsta->ahvif->vif;
+		link_conf = rcu_dereference(vif->link_conf[lp->link_id]);
+		if (!link_conf)
+			continue;
+
+		ctx = rcu_dereference(link_conf->chanctx_conf);
+		if (!ctx)
+			continue;
+
+		/*
+		 * For 6 GHz, rx_status->freq contains the operating center frequency.
+		 * For other bands, it contains the primary channel frequency.
+		 */
+		freq = status->band == NL80211_BAND_6GHZ ?
+			ctx->def.center_freq1 : ctx->def.chan->center_freq;
+		if (freq != status->freq)
+			continue;
+
+		/*
+		 * Skip freq-based lookup if multiple links share
+		 * the same frequency; the match would be ambiguous.
+		 */
+		if (link_peer) {
+			link_peer = NULL;
+			break;
 		}
+
+		link_peer = lp;
+	}
+
+	if (likely(link_peer)) {
+		status->link_valid = 1;
+		status->link_id = link_peer->link_id;
 	}
 }

base-commit: e07447e654476262558bee570f4cf456e2b32565
-- 
2.34.1

