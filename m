Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601549;
	b=5NGgtKyFfveSP9cnmIp3lPPW+XZNsOBtwDOT1pvFvUDhOoxnW6AH3+Nb8J1Y5nUar2j9
	 MTDKVldMbQCpFHIuDmNzewoPapMnViE0HhR0FgKLlVC5FRvX5OafWiAGDdMPQI2MQ70Zk
	 P1w8SKQWu0RWFQwSdVBzuCUJviOQPbi9OQnXrTP9Ewq4CwjTya36Bg/VMsr9hmPCb44GC
	 ZAZWeY3yVRjx+qDL7EeJnZFbztPp8NnhLJSu5JkqJRf0lZA9ruGJq5K3Gl5Sj60hS1pNd
	 K/g91XyaJyBbEIllf0r+Rc39O0Yc5ahEhFHq0K/LtORu57wN+kDRiwE30ZreJWQeN3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601549;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=30hNboA5vDWIzu7p4g9YsHRcZFHxLVMIekJQJ/Su1pQ=;
	b=wxzV6pWS8j7T+4rNlARYZi1dPjuVj4YW83UsgPeG/UypwJUvT9uvGENF9iejefdj/5vd
	 bsSHw4s+bExSuYO2pjSNJwGjCnvrGhKxSQB1LXwSmxtzYN1hqZBkiJ6vXd5Yqzf/23o/J
	 cbNbMaOmtfwc1Kfxr+AP9T4ed2DA94VVVZ7VaiYU4v8unbTvn+GnzrRky2ALsECJdmYEz
	 XHXm5LHKmYGqsPbEJzIEuiU7TgalkXPFN3oCpokwrL3ovYIdXo4AsvxwgJjtBxDow1m38
	 CpY86e/j83iLUowKraLDAMX9x8XKqzkM/Ln2BU2I1D0AKcNb6Jdtl5GmMbbDq/gYFhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=O97OMIgd;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hOdcTxM7;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB27D606A32D
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB27D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=O97OMIgd;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hOdcTxM7
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23v8I43768687
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	30hNboA5vDWIzu7p4g9YsHRcZFHxLVMIekJQJ/Su1pQ=; b=O97OMIgdPBa+m19F
	0QtkAnEULWr+LliALsMxliGg5PAXzfIMpNjXFNi/C0LtFqSDloM1SUZjIEeyJOq3
	FHVYUFGlbLESB3243P0hxl/lOlC8nfQseY/XYyWtPbtQsMpunSNwydYTINVQUZb5
	5FlIP5zLZbPAPqgpfHMNZgRmkK2glYs9U1bDw14nzUlwQNI8EJ57Aqd06kOABllz
	7i05WDoY1jnCJuUC1d1hU+BdQehzyXd5jk02zeBtLIb4GqQRdtQKdSNo6APrV7We
	tDSh9/nV5PBDIITZPxvSgy6HO7zFXaV3jLe2Iw7oCb7aSJeZt7JBXmCj61XGDKcG
	54LA2A==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn79rwm99-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:39:07 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so2457872a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601547; x=1794206347; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=30hNboA5vDWIzu7p4g9YsHRcZFHxLVMIekJQJ/Su1pQ=;
        b=hOdcTxM7TJX2FggDEEv5ornnyWSuTHm4QYWJJp/Ki8iC36tXlCUob6HuTHsnf5U1vQ
         Glgq3RW2uKMdPriL7ym6VU0gleEn9LM2xmytwAbqEEYqBec5V5tv4+WSYSlyKUiq3FYJ
         tu2QIhabcrd0l4ZJqM4kLtjEwc65zRNGJajsA6I48yCWDb/v6P8KG6LeZKq9xx+UTJwM
         bXCrm3yqZwQ5DsVpvvyhq72VfwjnwsXCz0z1cfRTCCeenmlaHcA5wHdAkKGQ7SPaG+uu
         qYElDjrEjRpCUVp8xHJjLos/5CDVkMLc2yiUDIN3CF3ms1CbeYDcFaeaPLFdGTfVN3oe
         2Kcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601547; x=1794206347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=30hNboA5vDWIzu7p4g9YsHRcZFHxLVMIekJQJ/Su1pQ=;
        b=ZNXOd8Oqu4VoAWRv4W1WWRy3aSw0fC1QYeHODf8AnelDNVTsgBV2OoeSisdP/Gdr8h
         /vOq4TsZ/a19fl7FaEdIJ3KsT7Pl9HdNOd2oD1KxPf6EsnCakZM0KYnP41mTWOvHfRwj
         dLz6uNGfCZEQ2JmCmosdMGkVP+7ojIATf2nPnnlGLPGbHWrSSr1cbavdensgF8fnUzG7
         OTtbQu+rSmt+jB/n9Q+40nhaOp+M2afJYrrcwc0ymxdGqviJ79SJHdJgyLHKn6+iADJf
         OldVdCOabhzW3zUb4MaY20mDvVwx03JGa3ilRplWmrqww0e1J4hI9EZ5xl1WAOxVLfI+
         R0VA==
X-Gm-Message-State: APuU4Z9tHMwp04+t8zJW3WB3mB6eDjTkMzfaIo9x5Qi6dmIw2loEhnjq
	Vd0xUo2S0TNwE0N6WyNbqshxMyNoKAOE0G+dtkBXE0rAlYhh51bbs3IP9Yq7BUifevMXkve59j1
	4ZsUjLvJLIdfzVC/EiwNFEvBWsqCAHoOCFmUQFgBfY0poQg5t/ZPjIkveWvhPsSXTH+jLrn1qOA
	fdcV8g
X-Gm-Gg: AYBFou0lfNyxh9xs3HeFHOui8WRYYaqcNTAaLW2xItiYeO9rfhwLfWdaIefJ+KDxeoa
	WowklGkPXolmo/3T7NQoSxc2BdNmpSovgRqZoCbkGqs/YiIIoTe2+1tCNdWq1l8Kqy0kg5yPoGg
	HydqjywoSeev+v07Drz9xltFrXyNuaCWR1VWlwzxMxatPnUkzoPEfVp1im1EETVh+3Xtt+x/Ohy
	MJY0d+GAs1+sykJ2Kocf0BF6sqdPMaUy9/+QvuHKjiIAcQVFoULMM4lVwJ81DmHt1DPrA6wyyZH
	7W69tiB0KYHWTW7HsktJfLwpbxMhOhZ1+xC+r9vYQF+B06bNunju1gdl1CozswggdOQ18nW3ddp
	y5wWDLEw6RpBhUfvCrU/fxOtK0iPKVId0ka2aflTJS8aSXsQVNjkRY9dvUp0T1kwPLx/YfJv0jw
	4J3gtdh8GWSLwUEPJcO26pKrWGn8Dv
X-Received: by 2002:a17:90b:52c6:b0:3ab:be66:ddc7 with SMTP id 98e67ed59e1d1-3ae897ccab8mr9184031a91.10.1793601546999;
        Sun, 01 Nov 2026 22:39:06 -0800 (PST)
X-Received: by 2002:a17:90b:52c6:b0:3ab:be66:ddc7 with SMTP id 98e67ed59e1d1-3ae897ccab8mr9184014a91.10.1793601546412;
        Sun, 01 Nov 2026 22:39:06 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:39:06 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:20 +0800
Subject: [PATCH ath-next v4 11/11] wifi: ath12k: use link_id_map to resolve
 RX link id for all devices
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
Message-Id: <20261102-ath12k-logical-link-id-v4-11-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: znsdsjMyRVpZMXvo-njUs-cPutuZQtPx
X-Authority-Analysis: v=2.4 cv=Wtq+otfv c=1 sm=1 tr=0 ts=6ae8300b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=KXmYhDJzFV-ZoC0c644A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXyZQAkPe5UAbS
 pdbCXVRMTZNRepHNIid/kmGnkqPxTITkbUtufZf7KkxM8WpgpYmRMiMnxGGM4urksXegV1mvjsh
 wKA6+ZUcGt7tJrCKUx5MV6E/G6UKXUA=
X-Proofpoint-GUID: znsdsjMyRVpZMXvo-njUs-cPutuZQtPx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX8aCgxW51onFp
 hFMCsObcLStR/XfXEHUHBGvDF2S92VJwGlpLGUwUClXUvfm4fvQzmjfwjvObBiBIo7ICETF3Jnf
 X0Mm5f4ZJKcXafHuFyLFlWn5w1vh97+CjeTQ8q8nu/VxmUm/w1XN1OV+SRq264PtwnA6weJE7Km
 THXHFNe9tPD4DR8GUQvkyTZZ8eychFvvx93n4tui2/hTmVMI3iRnLKIqXvdWmyOVJZcxLXpWZ5n
 Dz3MAKI5CVMTpbCxnMkfhARtgZYobHH7k4o25vWAaLwyTujxA4NtYqID+qf3lPONXPWhXcjfDza
 euDJHSi0YrA9h+CJ1p+ajcHYlngkjQiPy8N5MOk5QPCRUUpdlqvl1nqG57UJ5dD1Vi7URxoedof
 q0esO56l93dNCZ9W2i2ivUdJAMD72q84ImQBC77IChSnVx8Fin5JXYcLFXNXO2tCFlNVGym8pTn
 ryfjglR0fRAFYOnnYYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

Commit a2fe9dc70f3b ("wifi: ath12k: Fix low MLO RX throughput on
WCN7850") added a set_rx_link_id() op so that each device could resolve
the RX link id in its own way: QCN9274/IPQ5332 index
dp_peer->link_id_map[] with the hw_link_id, while WCN7850/QCC2072 walk
dp_peer->link_peers[] and match by peer_id, tracked with a link_peers_map
bitmap.

Now that ath12k_skb_rxcb::drv_link_id carries the driver link id for all
devices (the hw_link_id on QCN9274/IPQ5332 and the logical link id on
WCN7850/QCC2072) and ath12k_dp_peer::link_id_map maps it to the IEEE80211
link id, the RX path can resolve the link id uniformly.

Revert the set_rx_link_id() machinery and the link_peers_map bitmap, and
derive the link id directly from link_id_map[drv_link_id] in
ath12k_dp_rx_deliver_msdu() for all devices. The NULL dp_peer guard added
to ath12k_mac_peer_cleanup_all() is kept as it is an independent fix.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c     |  4 ----
 drivers/net/wireless/ath/ath12k/dp_peer.h     |  1 -
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  8 ++-----
 drivers/net/wireless/ath/ath12k/hw.h          | 18 ----------------
 drivers/net/wireless/ath/ath12k/mac.c         |  2 --
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 30 ---------------------------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h |  6 ------
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    |  3 ---
 8 files changed, 2 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index ee3cdd7ca460..ff88c694e1e3 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -658,8 +658,6 @@ int ath12k_dp_link_peer_assign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_hw,
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
 	rcu_assign_pointer(dp_peer->link_peers[peer->link_id], peer);
-	WRITE_ONCE(dp_peer->link_peers_map,
-		   READ_ONCE(dp_peer->link_peers_map) | BIT(peer->link_id));
 
 	rcu_assign_pointer(dp_hw->dp_peers[peerid_index], dp_peer);
 
@@ -728,8 +726,6 @@ void ath12k_dp_link_peer_unassign(struct ath12k_dp *dp, struct ath12k_dp_hw *dp_
 	peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 
 	rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
-	WRITE_ONCE(dp_peer->link_peers_map,
-		   READ_ONCE(dp_peer->link_peers_map) & ~BIT(peer->link_id));
 
 	rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.h b/drivers/net/wireless/ath/ath12k/dp_peer.h
index c2d060de88ea..2ac4c6c6d535 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.h
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.h
@@ -159,7 +159,6 @@ struct ath12k_dp_peer {
 
 	/* Info used in MMIC verification of * RX fragments */
 	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
-	unsigned long link_peers_map;
 	struct ath12k_dp_link_peer __rcu *link_peers[ATH12K_NUM_MAX_LINKS];
 	struct ath12k_reoq_buf reoq_bufs[IEEE80211_NUM_TIDS + 1];
 	struct ath12k_dp_rx_tid rx_tid[IEEE80211_NUM_TIDS + 1];
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index f11810c6e0d4..52838ade1b1d 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1370,13 +1370,9 @@ void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struc
 
 	if (pubsta) {
 		if (pubsta->valid_links) {
-			int link_id =
-				ath12k_hw_get_rx_link_id(dp->hw_params, peer,
-							 rxcb, status);
+			int link_id = peer->link_id_map[rxcb->drv_link_id];
 
-			if (link_id >= 0)
-				link_pubsta =
-					rcu_dereference(pubsta->link[link_id]);
+			link_pubsta = rcu_dereference(pubsta->link[link_id]);
 		} else {
 			link_pubsta = &pubsta->deflink;
 		}
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 106d858efc44..3a7d1959f19f 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -13,10 +13,6 @@
 #include "wmi.h"
 #include "hal.h"
 
-struct ath12k_dp_peer;
-struct ath12k_skb_rxcb;
-struct ieee80211_rx_status;
-
 /* Target configuration defines */
 
 /* Num VDEVS per radio */
@@ -255,9 +251,6 @@ struct ath12k_hw_ops {
 	bool (*dp_srng_is_tx_comp_ring)(int ring_num);
 	bool (*is_frame_link_agnostic)(struct ath12k_link_vif *arvif,
 				       struct ieee80211_mgmt *mgmt);
-	int (*get_rx_link_id)(struct ath12k_dp_peer *dp_peer,
-			      struct ath12k_skb_rxcb *rxcb,
-			      struct ieee80211_rx_status *status);
 };
 
 static inline
@@ -288,17 +281,6 @@ static inline int ath12k_hw_mac_id_to_srng_id(const struct ath12k_hw_params *hw,
 	return 0;
 }
 
-static inline int ath12k_hw_get_rx_link_id(const struct ath12k_hw_params *hw,
-					   struct ath12k_dp_peer *dp_peer,
-					   struct ath12k_skb_rxcb *rxcb,
-					   struct ieee80211_rx_status *status)
-{
-	if (hw->hw_ops->get_rx_link_id)
-		return hw->hw_ops->get_rx_link_id(dp_peer, rxcb, status);
-
-	return -1;
-}
-
 struct ath12k_fw_ie {
 	__le32 id;
 	__le32 len;
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01c048046290..4ac31cb9a5dc 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1241,8 +1241,6 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 		if (dp_peer) {
 			peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
 			rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
-			WRITE_ONCE(dp_peer->link_peers_map,
-				   READ_ONCE(dp_peer->link_peers_map) & ~BIT(peer->link_id));
 			rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
 		}
 		spin_unlock_bh(&dp_hw->peer_lock);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 4132578085cc..473887ed4bb1 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -2374,33 +2374,3 @@ ath12k_wifi7_dp_rxdesc_mpdu_valid(struct ath12k_base *ab,
 
 	return tlv_tag == HAL_RX_MPDU_START;
 }
-
-int
-ath12k_wifi7_dp_rx_get_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
-				       struct ath12k_skb_rxcb *rxcb,
-				       struct ieee80211_rx_status *status)
-{
-	return dp_peer->link_id_map[rxcb->drv_link_id];
-}
-
-int
-ath12k_wifi7_dp_rx_get_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
-				       struct ath12k_skb_rxcb *rxcb,
-				       struct ieee80211_rx_status *status)
-{
-	struct ath12k_dp_link_peer *link_peer;
-	unsigned long links_map;
-	int i;
-
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
-			 "ath12k set rx link id called without rcu lock");
-
-	links_map = READ_ONCE(dp_peer->link_peers_map);
-	for_each_set_bit(i, &links_map, ATH12K_NUM_MAX_LINKS) {
-		link_peer = rcu_dereference(dp_peer->link_peers[i]);
-		if (link_peer && link_peer->peer_id == rxcb->peer_id)
-			return link_peer->link_id;
-	}
-
-	return -1;
-}
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
index 8a16fb3dd005..3da80da19ced 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
@@ -59,10 +59,4 @@ ath12k_wifi7_dp_rxdesc_mpdu_valid(struct ath12k_base *ab,
 				  struct hal_rx_desc *rx_desc);
 int ath12k_wifi7_dp_rx_tid_delete_handler(struct ath12k_base *ab,
 					  struct ath12k_dp_rx_tid_rxq *rx_tid);
-int ath12k_wifi7_dp_rx_get_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
-					   struct ath12k_skb_rxcb *rxcb,
-					   struct ieee80211_rx_status *status);
-int ath12k_wifi7_dp_rx_get_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
-					   struct ath12k_skb_rxcb *rxcb,
-					   struct ieee80211_rx_status *status);
 #endif
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index b073282e5525..080ead233106 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -159,7 +159,6 @@ static const struct ath12k_hw_ops qcn9274_ops = {
 	.get_ring_selector = ath12k_wifi7_hw_get_ring_selector_qcn9274,
 	.dp_srng_is_tx_comp_ring = ath12k_wifi7_dp_srng_is_comp_ring_qcn9274,
 	.is_frame_link_agnostic = ath12k_wifi7_is_frame_link_agnostic_qcn9274,
-	.get_rx_link_id = ath12k_wifi7_dp_rx_get_link_id_qcn9274,
 };
 
 static const struct ath12k_hw_ops wcn7850_ops = {
@@ -170,7 +169,6 @@ static const struct ath12k_hw_ops wcn7850_ops = {
 	.get_ring_selector = ath12k_wifi7_hw_get_ring_selector_wcn7850,
 	.dp_srng_is_tx_comp_ring = ath12k_wifi7_dp_srng_is_comp_ring_wcn7850,
 	.is_frame_link_agnostic = ath12k_wifi7_is_frame_link_agnostic_wcn7850,
-	.get_rx_link_id = ath12k_wifi7_dp_rx_get_link_id_wcn7850,
 };
 
 static const struct ath12k_hw_ops qcc2072_ops = {
@@ -181,7 +179,6 @@ static const struct ath12k_hw_ops qcc2072_ops = {
 	.get_ring_selector = ath12k_wifi7_hw_get_ring_selector_wcn7850,
 	.dp_srng_is_tx_comp_ring = ath12k_wifi7_dp_srng_is_comp_ring_wcn7850,
 	.is_frame_link_agnostic = ath12k_wifi7_is_frame_link_agnostic_wcn7850,
-	.get_rx_link_id = ath12k_wifi7_dp_rx_get_link_id_wcn7850,
 };
 
 #define ATH12K_TX_RING_MASK_0 0x1

-- 
2.25.1

