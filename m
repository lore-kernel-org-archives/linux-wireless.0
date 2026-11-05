Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907662;
	b=kerDCPUf73cfC5Ksweg8543fLk+jaFr2/327CoIAlsxx6V+8/VGFYDuBWBhYUkSBemrf
	 owsYJ4g4FIV3n+tgej9xd3gHSc36teBMKn+kEnpK9D6yXUxV/WMH7cRFhMGiNE2FQ7KUX
	 q1AuiacpMJuDrFqNJfu7Lg/IKqE9P+eTLizlm/scx2TZBBFl8ROBQHECLL5gP95HtUvJU
	 7Lz+AI5n6Kg9YxkwPGea2baZX0IeH0WoG5bmAVTYhUrL5rGXh80QaLN5SVxpKvVteQvVj
	 I4WmROAh606ngEdDpcmMQEArJKJOxxbBdnPxbE8dOvK5L/CH5d1mAP0x9O+z2wxXDBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907662;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=;
	b=fpHKGBdVdgwYZ5m+xVfJ1StyLf6tgIWzJwH3RXiDts2TPYkugIfQXpaIf9vGzOU1/rpQ
	 nTA28LeG70bLFdCLE+7WMEWFDu9Kro8V3aAoR4pCOAxWCiCV1dj1Zb/d/Euq2w23jy7j4
	 4hRqi87FGeB28dkYeFnOrnhhfW3KtJFbrKecwyeY1QFsPaF0vzPv8q99qmb6bEbjyzMDr
	 Iu2ZMq87U3ViG4xPdOyUZDiB6kaPhjKgBJ94YYvD+Aqk8zj+7dHdWgj6IarPlgQDuaoZV
	 t+DT1LuF3gor61wOG7oEJul3eCRWGexKfn0lan28fR31OTvGdwyu68JxKYIhCorFX3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TYte3Bd2;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IvdEhKAG;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B18660772A2
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B18660772A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TYte3Bd2;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IvdEhKAG
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeAS52433585
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=; b=TYte3Bd2Bhla4G6H
	NV+oFjHSA5vR2L/T9D0lGUMU7ZTlJQUDt0XvvGVz/iKPFOpTs5kDWToy+GN5mKUg
	qGr/D7BHCw1UblV/fFp8jOGwKDVUcgjJlgXOkIaFtuHXsUOJNmovRYBNfVcknHGP
	KOivUfPrvLHu6rxB5bZyJ3BMNWKSwJB6F88z0mSDmy1zeY9XzPtGLqWD2gCeCS4o
	nq+GJ3bOxbHtDcwtmnnm2nnrdFZ737hyNIQ7LX7FyOIqrKTqJ9vPvSDQaF+p/Odv
	dR/tJaEGX4iYDKftcPJ98um8CSZJkLCZw2JuyikHjhZ2NRB+SzQFlyHuA+gC+qdi
	ozTy6g==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrqpd2h7r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:41:00 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3662e7a9299so1259311eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907660; x=1794512460; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=;
        b=IvdEhKAGsKC65+AN2+xICYydsusARVrNwTW+xl4L8CMr7PD2Ffhmiw1CpR3eKoA+GJ
         hZW21vcJAlIprbK6Ez3iKT+C/B6NXAs1pLmqC7xkBa+rhNj+6RgIlOfNE0Nr/R3Qsmd2
         HVcBkS7oAdPG1k/TvUdXppk1l+TZOTIeCsCYM/2VqnyhPCAEAcpJgLo2xl3KIRfb0Gxa
         aL6HothNJ/63mQ2d8syk3LFLP/gOPoWHWiqOCyRl/Z6c5/t7afhDrzGFnOTKBI5zsMcn
         hocxo3d0bbtL+3A89zF0rzG4G0TGS4LXb8HLd0fnUDTiaKNYl+OWO+th5D/Vkvaerws5
         J4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907660; x=1794512460;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=;
        b=m5U0mT6n/BlX65QX0mvT/7Rqw8w1wpWOEvkxAeBC7XmNV27bQcQw61DdulsEDbBMx8
         sTLQbDV4leifP4BstiFOEZadfNMrFqk/gJOlo0x5CxaNEY7A5JX76RdZdMxDKQpFtuqh
         etFzWdtl+dIfla4zqv62hP0KIyVOk4yblizHwBJ950vqsDwX8slC5JA4t2TmObdOZyOm
         Aauj09a12xWfkx0D2Nj0Qc5gjaz7ryFRZi017akG/d9cUI+LXxOb7s78KwvrrDwDPQF7
         OOW6zzj8yUqWx4mVutngpPYqX03KctitSyP0fh2/ZHnVeFTzEKWrNh/EVt8V1gdlXMFd
         Ch4w==
X-Gm-Message-State: APuU4Z+JppIm2YbBExgO3shYzYwkZQt0Fok43Si75TAjoXOYjOF12fR7
	p46DgZJNo2ZQeRhxPvdoFCMCfuW6LKpxUkM6ZzifuWvegFEbmp8VhzxVrBs7Q0xKgz6F29LaLWN
	zgWFSL1627KxFWo0ZlUh24Kx+klX87gMLvOEpnFk0uJU70zo8hFjueVj90r7KFA9bhUlW
X-Gm-Gg: AYBFou3mztoK3bpUXCkTvp+pi7yftyAAfmJPAW152vB8GOjXGk8nQuUu2LFl2qUhsFg
	wUSzlWuAD363GKnWA7+FG+96N2Hu6nBWu8TWAj9aw2tPQ6EECfokkOltDgMNFIJ3sFS7HU/EAWd
	ygh2ZAoSEEDC4deX6bbDuSrQeRZ0y5r5Ja/JhqlxM3MzsE0FAuhh3r6qazpMcBRtf222QBzTi5E
	aO/8iU0W6cnM3legIUP+fmrs9irbp+jhXIxOIzyj8zDd6ZFfX8aQmLul7GszUXHTgvN9ldUY/nI
	PXKTs0AEWkMJ7RnoRNLdoj/MMnhC//nWqvPAcSyyXkLpu2Wj1FuGVI4dUT+8u21Jb9b+zupvMGl
	C90tKegT4e5Ktj4vpcO2qgGI9+3BGAH/fLgSllhZTg4XqBBzuxHvHhOePFDSoMrWApns0kQFF2/
	1ueir/6CEs2IcslAGTPHkpt+gMtuhkeHvRAgAsjyKYvjUwHzChKgcXRu1hNXp1QNPFxhLn3Q==
X-Received: by 2002:a05:7300:ac90:b0:36a:1e0c:e28d with SMTP id 5a478bee46e88-36f727d4322mr344132eec.4.1793907659696;
        Thu, 05 Nov 2026 11:40:59 -0800 (PST)
X-Received: by 2002:a05:7300:ac90:b0:36a:1e0c:e28d with SMTP id 5a478bee46e88-36f727d4322mr344077eec.4.1793907659071;
        Thu, 05 Nov 2026 11:40:59 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:58 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:52 +0530
Subject: [PATCH wireless-next v3 17/21] wifi: mac80211: pass rx_data
 directly from ieee80211_rx_list()
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
Message-Id: <20261106-smd-v3-17-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX//PfO/OCQpiq
 qKS4TC8m+Q8U19TC8YZjrEVl1qwxUukC1xQ3OF5Hxy63P//6sRTigwX4lk/kSDwNKIQ5M5PxVLM
 cX2C/VAIfk15kf8Ymfp32vOzQ/h+2LA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX7PyoPhyFmOzq
 JqeRC8wQIbiDro34VDkQyXwmJW0iV1nLXFYmQvrAdRvAUjMrRGuOJBQ8GDxo+aaTEbrY/T/u1zi
 Ux7rqOdF52iP2okG97NnUHuWOlzPtGEljDzg2eN4iFucYFB4h0QqmPkthuQvL9JxgV157WxfyO9
 KKXKUm+q6kQSJ77I4gHT0chMPELmv1f72DTeScdPcpJvArWjNB88+q9Kyjtyiu/JPQTGLOpGW74
 m0duTFKbCLMb6tffq+0ActxxyhO1G1EjnMumubVIRfTzyTO/dszmScHNrQoeSvhER1N0vQpZ1jQ
 foUauv0UR/hyfucB0GXLSX8yKbsJbLoTvQPdPHloLH+azLzr3y5y3KFoYbay0Vl/JBpqkcGSBRy
 BIq2ez+Hk0M9G/3pAWrcuX6HVM/gvfE2G8mdXDSxFj5VeJeHBd8tg789mNqVeUCoh/2vmXa6DQB
 +hW9reB4aX5pJCw9bUg==
X-Proofpoint-ORIG-GUID: 4NSUaIEhwyHReSq4SUI1v5Ftw5EiSWnj
X-Proofpoint-GUID: 4NSUaIEhwyHReSq4SUI1v5Ftw5EiSWnj
X-Authority-Analysis: v=2.4 cv=Y5JtIReN c=1 sm=1 tr=0 ts=6aecdbcc cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=QaRRATVtn6WKYfhituAA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

rx_data is currently defined inside __ieee80211_rx_handle_packet() and
is passed to the rx handlers called inside. Define it early in
ieee80211_rx_list() so that new transient data that live just between
the driver and mac80211 interface layer can be passed to the rx handlers
as well.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 net/mac80211/rx.c | 60 +++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 12ba9fbcc983..78967ac95343 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5374,7 +5374,8 @@ static bool ieee80211_rx_valid_freq(struct ieee80211_rx_status *status,
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct ieee80211_link_sta *link_pubsta,
 					 struct sk_buff *skb,
-					 struct list_head *list)
+					 struct list_head *list,
+					 struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -5383,16 +5384,14 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct link_sta_info *link_sta;
 	struct sta_info *sta;
 	__le16 fc;
-	struct ieee80211_rx_data rx;
 	struct rhlist_head *tmp;
 	bool rx_data_pending;
 	int err = 0;
 
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
-	memset(&rx, 0, sizeof(rx));
-	rx.skb = skb;
-	rx.local = local;
-	rx.list = list;
+	rx->skb = skb;
+	rx->local = local;
+	rx->list = list;
 
 	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
 		I802_DEBUG_INC(local->dot11ReceivedFragmentCount);
@@ -5424,8 +5423,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	ieee80211_parse_qos(&rx);
-	ieee80211_verify_alignment(&rx);
+	ieee80211_parse_qos(rx);
+	ieee80211_verify_alignment(rx);
 
 	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control) ||
 		     ieee80211_is_beacon(hdr->frame_control) ||
@@ -5446,9 +5445,9 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					   sta);
 			link_sta = rcu_dereference(sta->link[link_pubsta->link_id]);
 
-			rx.sdata = sta->sdata;
-			if (ieee80211_rx_data_set_link_sta(&rx, link_sta) &&
-			    ieee80211_prepare_and_rx_handle(&rx, skb, true))
+			rx->sdata = sta->sdata;
+			if (ieee80211_rx_data_set_link_sta(rx, link_sta) &&
+			    ieee80211_prepare_and_rx_handle(rx, skb, true))
 				return;
 
 			goto out;
@@ -5468,13 +5467,13 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				continue;
 
 			if (rx_data_pending) {
-				ieee80211_prepare_and_rx_handle(&rx, skb,
+				ieee80211_prepare_and_rx_handle(rx, skb,
 								false);
 				rx_data_pending = false;
 			}
 
-			rx.sdata = sta->sdata;
-			if (!ieee80211_rx_data_set_link_sta(&rx, &sta->deflink))
+			rx->sdata = sta->sdata;
+			if (!ieee80211_rx_data_set_link_sta(rx, &sta->deflink))
 				continue;
 
 			rx_data_pending = true;
@@ -5492,20 +5491,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				continue;
 
 			if (rx_data_pending) {
-				ieee80211_prepare_and_rx_handle(&rx, skb,
+				ieee80211_prepare_and_rx_handle(rx, skb,
 								false);
 				rx_data_pending = false;
 			}
 
-			rx.sdata = sta->sdata;
-			if (!ieee80211_rx_data_set_link_sta(&rx, link_sta))
+			rx->sdata = sta->sdata;
+			if (!ieee80211_rx_data_set_link_sta(rx, link_sta))
 				continue;
 
 			rx_data_pending = true;
 		}
 
 		if (rx_data_pending) {
-			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
+			if (ieee80211_prepare_and_rx_handle(rx, skb, true))
 				return;
 
 			goto out;
@@ -5560,14 +5559,14 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		if (link_sta && link &&
 		    ieee80211_rx_valid_freq(status, link)) {
 			if (rx_data_pending) {
-				ieee80211_prepare_and_rx_handle(&rx, skb, false);
+				ieee80211_prepare_and_rx_handle(rx, skb, false);
 				rx_data_pending = false;
 			}
 
 			/* No valid_links check as we need to RX beacons */
 
-			rx.sdata = sdata;
-			if (ieee80211_rx_data_set_link_sta(&rx, link_sta))
+			rx->sdata = sdata;
+			if (ieee80211_rx_data_set_link_sta(rx, link_sta))
 				rx_data_pending = true;
 
 			continue;
@@ -5596,22 +5595,22 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		}
 
 		if (rx_data_pending) {
-			ieee80211_prepare_and_rx_handle(&rx, skb, false);
+			ieee80211_prepare_and_rx_handle(rx, skb, false);
 			rx_data_pending = false;
 		}
 
-		rx.sdata = sdata;
-		rx.local = sdata->local;
-		rx.link = link;
-		rx.link_id = link != &sdata->deflink ? link->link_id : -1;
-		rx.sta = NULL;
-		rx.link_sta = NULL;
+		rx->sdata = sdata;
+		rx->local = sdata->local;
+		rx->link = link;
+		rx->link_id = link != &sdata->deflink ? link->link_id : -1;
+		rx->sta = NULL;
+		rx->link_sta = NULL;
 
 		rx_data_pending = true;
 	}
 
 	if (rx_data_pending &&
-	    ieee80211_prepare_and_rx_handle(&rx, skb, true))
+	    ieee80211_prepare_and_rx_handle(rx, skb, true))
 		return;
 
  out:
@@ -5631,6 +5630,7 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_rx_data rx = {};
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -5782,7 +5782,7 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 			__ieee80211_rx_handle_8023(hw, link_pubsta, skb, list);
 		else
 			__ieee80211_rx_handle_packet(hw, link_pubsta, skb,
-						     list);
+						     list, &rx);
 	}
 
 	kcov_remote_stop();

-- 
2.34.1

