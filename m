Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907656;
	b=Jj2tR0eEA0f3LP41vPVBW5cM0Utv2o5jZsO5QSAdu2qMZAeB9LVX0O9lDit+9HUQMHM3
	 gyVvhbss4VBq3utitGNWmOe7DuKYouejqtsByD4mKBeTpVdEO6ahVW/u0+fXD78scf9CW
	 xKo3LNcQM8C+JbuoXND57+clR91LC50WdxlfFd/NWSmdcKlS9PTf1rOAoFQpejcI4kBAI
	 skM7uRj8wsRb8532HdqiZxeUUNTAQaIrLYVVnNDKbvKUoodBwAKcH44UxgAbVXpelcv4k
	 Mc6jFH1Ztntv51d2jVkpvRr9Bkkx3fdM3LBcJQmajZIZ1wOaGvQ2ocW/zm8b23fWrvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907656;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=fKYri61OGhi/wgn25KBuupgoVfkejSRXbBTtvGVv0uM=;
	b=zhu2S706RGfzW8wjhYLcS4Owvf4WCachrpuzAoF6MPA0ecDnSjjF0t9NcPnUkHnKPIej
	 EFsez/5ZaVoQA7lsCe/4ADhqAA9WA7JxLuozSMTiVLxLe93GkJw6yQUQV2RGArbFq8/Qr
	 ZrTxPhtH0h3IDb1TWeZQGZ/ZjryNCwm2hMNTg6hsEKdmTZkX7PJ46T+mqLmVxHlFZWg7U
	 tN6K+0e0n+CwKVyM03MvQaB9mYTvOfvY63erPvjJwVdGNUetKXahZAz0tFpMQtwu+MmDm
	 JLN5v1ghl67D3ouEGQ1NE9JDYsgEmMkaJIlxyIkcjq7Axy2vAAAQ+bGkel4KZ+piAdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mBYubT+0;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AZMWXYYV;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D62607728C
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8D62607728C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mBYubT+0;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AZMWXYYV
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5JLc8f752581
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fKYri61OGhi/wgn25KBuupgoVfkejSRXbBTtvGVv0uM=; b=mBYubT+0aH0Cdu8Z
	JS3ERN0kjk8DgMIIhUvrhamjYPSXKu8BWwX5UL6lgsR0Y1H0wFGCdYlyNf9YizXY
	UnvPYzQ4nvZ1tkdlxNQWR/7vPJisff9HY1H/dNzzCJTW6fBhzZBCj5cq5PJphLms
	w2ap5fCjcQd7YDFFgVMpMc6Jf441ZxUgWZ2Gd4gpnRJEfaHGb/M4vTo8sLJiOSKv
	iYJZedLSYekNB9Oxe3ZnxpZ1CR3oJ5vazB24qRpH/ilIm/nUE+bkFhor27FzhgQj
	2B9JljLZ25k5SLqDCu5f/RE/OLpa+q1WtGe1rDyaL4cJ9MOIpQB9pSI2FoskZexE
	O9MKUw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hryvp82gx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:55 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36f1e7d9d4dso742475eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907654; x=1794512454; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKYri61OGhi/wgn25KBuupgoVfkejSRXbBTtvGVv0uM=;
        b=AZMWXYYVfPVGUCfWv9BPfw+3FkW2mxECWc3gGugNKXX31y/rlCMEWq1GoD8mPVqktg
         uUSOHfTmmVUno04XGMWBEPlkEWFVI84TTFu9GxRqSNbYTaVCXow3ZcFT53Ei5TlFUe4w
         rJJz7y34QJPGBZADwBrfBTy+ADoNLZt5dDNxPt79/5FeXOTnp8hb7QRLrpGPDeDY/ppz
         aYgz4FIuEFugHScGV6UJvT/Z+l3WSVS2dwQ6nFhn1Qu93htUVyU5iZ6X9mruz6zmmTGT
         9sqSrjwBrSS9qOGT2TqbCKFNRdVpo0Qi9/suWhi3n0JXVPC5ouhhvyg2lMs6nKbudcoU
         Oh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907654; x=1794512454;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fKYri61OGhi/wgn25KBuupgoVfkejSRXbBTtvGVv0uM=;
        b=ERlIaiKIRlc/+N4eOqHl/lGIqO3ase9B5IJp/mAmXP/wwS5LHV3aYVVdO9dCTzRDAX
         B+XkZcrLHbUj6dKDv/T1SmA0y5Oc1ovPJ11ffmQzSq+xDJ26iF1nR4jTSYAyjEfDoqO9
         AMikhEgTlbUCVqmplCluYjSDV7Eidgs0eiKhA1gLjTE6caaWBh++HSrPn200RnzdzVZV
         cgf3F1E6O0Jw9CVzVOs8OZ8JceiDxf5e9GJqaONyWqJCGN4eZMpnvcz3sYyU/1De4KA/
         AoBr0fXukZ3VQLYWCXMZEUZAqEQLeRXjf6E+Vb9RSAySAlkJe+6WXKxMrJLZ+GgJIWI3
         qMMQ==
X-Gm-Message-State: APuU4Z+YL0tOBv47MYTApMrZAZ+8HNgWH1KevaTnAyE/ola6w31lm8BY
	NnrpWzB3lNdfGpGMY1VjiCzWXpI7aW5+cTjovZvsXUXIafC2J0vpoq7JTeEamevqPGqqSFE7dfo
	qAtWod54bRlBT6s1yRXYPGKX/wdVj/LOhZZVr98jw3/bMta67YE2G2n7OBlIFQnO47c2k
X-Gm-Gg: AYBFou14tzfSff60iZlgLqZ+O2NJc5QsGy0/VaBZVv9Mdew0sCy3Q1z47bySiUOqvXu
	QWJl902SswDJzq1kb5L+OVAnQ2DIzgimuCTv6elg96Hk/GRD5K1EDnoDCtmIplLzTv/hIYadHLH
	cxGDd2BU23cj3RmgvDW0SAfBUbjOKq9sQIOcxXV/QBRtcAwiGXJtIfmCeI+YP0j02d1iosVWwF6
	DubEi3277XJwOum/Ft+TMpj13ufqKVC025lUSVDZldm2ipS7dY/ya1t/xd9+UCcWrNigLk6gAbn
	dIxTcqIkcxju0xX+jAqXtc8Dh1O93JCuwrJFZW/5svT5CLO9Njqx3ONmEHPtMwQH0XGpeiS6p9C
	/O7J+/oOvlF3eBAjyAzfT3ubgkKxpsMQIFT0tV+mqPf5g+7SsziD5HixqNWeQDGkeNzodTV1hwx
	Lh7lEyxUj6uTZOxcus2Hy/WHwnng4ud9/CaWedRENlnDdezrLF7k1nhqT6uEPctuToFTEB4A==
X-Received: by 2002:a05:693c:881b:10b0:351:1bdb:e3b7 with SMTP id 5a478bee46e88-36f75b2c6e8mr173847eec.15.1793907654335;
        Thu, 05 Nov 2026 11:40:54 -0800 (PST)
X-Received: by 2002:a05:693c:881b:10b0:351:1bdb:e3b7 with SMTP id 5a478bee46e88-36f75b2c6e8mr173796eec.15.1793907653589;
        Thu, 05 Nov 2026 11:40:53 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:53 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:50 +0530
Subject: [PATCH wireless-next v3 15/21] wifi: mac80211: filter uplink and
 downlink frames based on SMD states
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
Message-Id: <20261106-smd-v3-15-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=Ib4Symqa c=1 sm=1 tr=0 ts=6aecdbc7 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=AigL14bPCbaQZCUQxqEA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: bGidO8PXucnA2ITlOydS7Hshq2z1mST6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXz/by56pQ1wn2
 Oxkb52TRPmJgMkfovnzKj04TDynQgEevzYFouOz4G4/iOt0pyI96Qse4OEox8Qf6dWJ8TWhCUv6
 07AoF2FHMkW92jPfSeKUneNX59TeNC85C276AGIwfXdWvN+pIB5ut3A9ruosHL8mRXFbLtpyAuO
 oCiQB/Q9YWL+vVjO1/O7w24H7v14ASWweE/Y5QiLCrDl7EL8RuQZwef89+5yxHeKHUD42/x1lr1
 0P99DG4Q6jhCLG2nthUjQpKyGt8wRRTvcNXEH6BCF/JAg8GDGIeRvKiNjdPebXCrPojzWSzG40f
 yYhtf6vwIIBLKCpCDQJ6/IIOaeeSPmp2DmeLlmJrRK0yiJi5P5XJvJXFGWeJA5fmGye7RVjpyj4
 7Fk0a/N9UrEV0UVnTx2h8bIM/kb0hYjfYXZeUJFDvMlKTI53khoRAvj3ltXY2Zdr+foMV1AQ+ey
 yHNOi5i2+FUT9qjaGxA==
X-Proofpoint-ORIG-GUID: bGidO8PXucnA2ITlOydS7Hshq2z1mST6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX98odVpr4eP0N
 +pK69+3Re1DyqpPukSfVROCxMzA1yF1weT6NnOhIrHQ7GC0bhWK0uyTW9RAXVbMsgNaV5cM+7Q7
 /Uo3q33RQYZVjPVz20ciU50JSrIWCuc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

During SMD BSS Transition, based on the state that the non-AP MLD is
currently in, there are frame filtering conditions imposed in both
uplink and downlink directions, as per IEEE P802.11bn/D2.0, Aug 2026,
subclause 11.3.1.

State 4a:
 - UL/DL: All Class 3 frames except ST Execution Request and Response
   frames are disallowed.

State 4b:
 - UL: Class 3 data frames are disallowed.
 - DL: All Class 3 data, control, management frames are disallowed.

State 4c:
 - UL: All Class 3 frames except QoS Null, Control, and UHR
   Reconfiguration Notify frames are disallowed.
 - DL: All Class 3 frames except Data, Control, and UHR
   Reconfiguration Notify frames are disallowed.

Add the filters in both tx and rx handlers to implement the conditions
to avoid exchanging those frames while the station is transitioning
'seamlessly' (state-4) to the target AP MLD. The unexpected frames will
cause out-of-state operations and leaks in the context transferred.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 net/mac80211/drop.h |  1 +
 net/mac80211/rx.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/tx.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/net/mac80211/drop.h b/net/mac80211/drop.h
index f433ee17cce5..fe037c94b2ca 100644
--- a/net/mac80211/drop.h
+++ b/net/mac80211/drop.h
@@ -109,6 +109,7 @@ typedef unsigned int __bitwise ieee80211_rx_result;
 	R(RX_DROP_U_UNHANDLED_MGMT_STYPE)	\
 	R(RX_DROP_U_NO_LINK)			\
 	R(RX_DROP_U_DEFRAG_OVERFLOW)		\
+	R(RX_DROP_U_SMD_FILTERED)		\
 /* this line for the trailing \ - add before this */
 
 /* having two enums allows for checking ieee80211_rx_result use with sparse */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee1f33178d26..12ba9fbcc983 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1628,6 +1628,49 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_smd_state(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	__le16 fc = hdr->frame_control;
+
+	if (!rx->sta ||
+	    (rx->sdata->vif.type != NL80211_IFTYPE_AP &&
+	     rx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
+	    !test_sta_flag(rx->sta, WLAN_STA_ASSOC) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return RX_CONTINUE;
+
+	switch (rx->sta->smd_state) {
+	case IEEE80211_STA_SMD_NONE:
+		break;
+	case IEEE80211_STA_SMD_PREP:
+		/* 4a: Class 3 disallowed except ST Execution Request */
+		if (ieee80211_is_st_exec_req(rx->skb))
+			break;
+		if (ieee80211_is_class3(rx->skb))
+			return RX_DROP_U_SMD_FILTERED;
+		break;
+	case IEEE80211_STA_SMD_EXEC:
+		/* 4b: Class 3 Data frames disallowed */
+		if (ieee80211_is_data(fc))
+			return RX_DROP_U_SMD_FILTERED;
+		break;
+	case IEEE80211_STA_SMD_DRAIN:
+		/*
+		 * 4c: Class 3 frames disallowed except QoS Null, Control, and
+		 * UHR Reconfiguration Notify frames.
+		 */
+		if (ieee80211_is_qos_nullfunc(fc) || ieee80211_is_ctl(fc) ||
+		    ieee80211_is_uhr_link_reconf_notify(rx->skb))
+			break;
+		if (ieee80211_is_class3(rx->skb))
+			return RX_DROP_U_SMD_FILTERED;
+		break;
+	}
+
+	return RX_CONTINUE;
+}
 
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
@@ -4279,6 +4322,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 
 	CALL_RXH(ieee80211_rx_h_check_dup);
 	CALL_RXH(ieee80211_rx_h_check);
+	CALL_RXH(ieee80211_rx_h_smd_state);
 
 	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415d6a..17735fd0946b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -308,6 +308,47 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_smd_state(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	__le16 fc = hdr->frame_control;
+
+	if (!tx->sta ||
+	    (tx->sdata->vif.type != NL80211_IFTYPE_AP ||
+	     tx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
+	    !test_sta_flag(tx->sta, WLAN_STA_ASSOC) ||
+	    !(tx->flags & IEEE80211_TX_UNICAST))
+		return TX_CONTINUE;
+
+	switch (tx->sta->smd_state) {
+	case IEEE80211_STA_SMD_NONE:
+		break;
+	case IEEE80211_STA_SMD_PREP:
+		/* 4a: Class 3 disallowed except ST Execution Response */
+		if (ieee80211_is_st_exec_resp(tx->skb))
+			break;
+		if (ieee80211_is_class3(tx->skb))
+			return TX_DROP;
+		break;
+	case IEEE80211_STA_SMD_EXEC:
+		/* 4b: no restriction */
+		break;
+	case IEEE80211_STA_SMD_DRAIN:
+		/* 4c: Class 3 disallowed except Data, Control,
+		 * UHR Reconfiguration Notify
+		 */
+		if (ieee80211_is_ctl(fc) || ieee80211_is_data(fc) ||
+		    ieee80211_is_uhr_link_reconf_notify(tx->skb))
+			break;
+		if (ieee80211_is_class3(tx->skb))
+			return TX_DROP;
+		break;
+	}
+
+	return TX_CONTINUE;
+}
+
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
  * happen often during normal operation, so dropping the oldest buffered packet
@@ -1881,6 +1922,7 @@ static int invoke_tx_handlers_early(struct ieee80211_tx_data *tx)
 
 	CALL_TXH(ieee80211_tx_h_dynamic_ps);
 	CALL_TXH(ieee80211_tx_h_check_assoc);
+	CALL_TXH(ieee80211_tx_h_smd_state);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);

-- 
2.34.1

