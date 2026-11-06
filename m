Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952008;
	b=kkVMROIm0HhaGNmh4nlx71+w51K15GF6CP6zN//ZhM9Og0Du3KdXGhGcWtCbmCXVT568
	 7od3qaR15ATAzhTLj9o6BSslExUJ+FKvDofn92htliyUy4yENb0WRBBGpkhqVte2SUSs3
	 dyk8tKD6U362yzaqQiApwv8VeUtO2YqudFFfSVlNoMVqBe/hXJnGQEP8PT7TSNwHqYoI7
	 6Y2x89PF4gs12mGPZR156fgA4NJyKP3pj4isBYgmyQZlJca0eBprUNh4aNkMXuMgIiRK8
	 lKsTjWNYLYyfEu2Hq6+CxfE378NiBU9H4UhBKoRMlckc23hRUGWmDWgVj1MfLyeP3QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952008;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=;
	b=TbYPfpC65+PBh+AlhoF6b75wJ20kDvyUaZoHJ3rqnOfFiCDJ1kgNTyynoa6kRsiCE3kW
	 qc3QtdlO1dGlYNGRJCJq2LzFqPN5Fw94+q39JBboKolL9/gdKy/whemU0D5NiI4Nlvg72
	 42V41W9RJrXfwEswFKDfwYSS8NBnGmixirPCpuAVvIg83s8dZ0WuyT+1fRy73H4W3pPEt
	 VHtjSnDub3y2uDZk+RRKzh9/F6qBx3vJO+qs73QJxEvBkfzR3R/OpA1hYYPH3K0MTmKzV
	 MRFBZd7NQJ6crA8SYCTCwRcaihlSA3tw+tyXTOtZvPR+YyEUvXxh9ESt4LU1k6grJNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kvNXp2v8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PunsyVGh;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E66083620
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 196E66083620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kvNXp2v8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PunsyVGh
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RR5O2194380
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 08:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=; b=kvNXp2v8lDGWCcMk
	1WyFV+3BqaFEcaGOXk8/RHoChzEJEEkMM/fbsC4yn8JBm1O6aiAvTJgeooFEwt2d
	WfuhPkrs4JRc/zRi6FOHFs1DtgVyIA5yvkHKF3p4CREZNClrFXt6L94iGLo5U+76
	sLmfxmNuvQou2NezVJJicjCfFiG5Z04ZaJAMoYUGRUQJ2BNvaMowWDZkXjMV0+3f
	jAGrrSAznM73sB/h14Rwl8ySCgjlNjDIFP650Ui/zSgTCsQsIg6KRvm4RCy6e6u3
	EX/cfS4PtbtM0KT0neoWGVG1IgrkHx0Ju7zXJ0AxmZHJs+4ZBiGUZIG1cdT2IvJq
	SNxdKQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa9q8m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 08:00:06 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd67d4bbdffso320710a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 00:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793952006; x=1794556806; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=;
        b=PunsyVGh3pfQ8MheGD/K2cwFRB3D7BmywCeZXYkjlHJbSWqF+jaH/sZtW0i2iVlCgl
         Z37lm5z3vzeQJv4NwjZ1TVadLxACbzgFV3xS454jnYsxL3B6mUGcoTZBwHR9Yhf78EcV
         Yd2zkbmcondW/1LKkMOFNdWVH6iyEbVZHpXSVwwpYG31dts9bhGNH4S0VyoFt8okeaDr
         CorW4rMISM+Fyx7E++Eyrw+VWC3KSjp0X4uucI88Kl17aSliJ+fQTaqVw8EzmATgoZR1
         tfatvYRtUu+tGmy3WUTvin6TjNe9t0qDcdErp4jBLWLAap4RRQTloLwZDWuJSzKo9tC+
         PIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793952006; x=1794556806;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jshofKC0QdDfPF/zBkVJlmFjxY3GE8tXQO7KwbzIz1k=;
        b=ikhnV53RMGx9APzZ1JR2UbwOXaD/JlSjDOpwtzdQ4c6ZOUOKeHU3/4AkSB9keEIe49
         uiIHNBdslRLbMBNtQ0V5v4SfxKKOiLr0b8VMW/hwn6ugIWdX+bo2ut9jOPEFh5yKZrRi
         77+xjufRRJ/szmclMLPnLHXREr5XWWauHKBBwIZ88x2kwEAEhMEV4Tbo0D8mWOF0636+
         fqUGsqWRm++9jFBVI15Oy3m6uxkYt2Xx13zTY2ONmte70X2/9u6aRinKL88p/gORXT3x
         uzfAU5eweE+cVFdzmpMZgn1Nlyay0xt6Ob2GimZh+RMEiihBrpfraryo25VxKmzajOeB
         G8aA==
X-Gm-Message-State: APuU4Z9DEJKcznwS7SqKDEtQtiO4CAA7C9brSshbVeFC2ivWGPKSaWbz
	KzsrEWlyFANTaMF7WDsKWDSzJdOKU21cgP+Pf0KwKLG8mhd07sD82mnnm13yd5I+7KO0L79GPr+
	WgkknATYU67//offRtL3QGehxWkYdNLmZHhnFD8fGOlKp4MIMxEuoxKmM575QIyKXM8y/2HWuJl
	CY
X-Gm-Gg: AYBFou2UWgyBmVXG6MUgtuu+VFpIx3At4Kwhbsy15F1HfKFanPd9MQK3iOhgFESQ3c8
	dXOFDH9d65mcuklhegZeWV0jSdv1cRu6+lUTB9kWgdJUbivosv+J4BMduMYWEHAD54oLJO+ZGHg
	HZYe0v1l0kzJJ6D5kItpY+XY36fK3lPve3fH78kssX13hAeVkwP36HdzloeF4JBBaGzig6K/kqz
	6Q+oQAFqE9d6159zRQW0h6O+fkeo3bVq/+I/uTzHdaphCKKqCd043OdwWql5yxysBoazejT0zBC
	HUZ4J2GSq51NEgAIfRe07R2x3HTK1tqgzARuyRqVcu8Jg3Bp8hdGTFRABEvpVr6mM8cifno2mVg
	oNpvlL6bhwqzaoZjvnU0uI39jAPsDIblysqU1Y02sRw7hPJf9gotuBuAF3/rhu1jZZGLqEPVSRX
	8S0b8PTkSbCPItdw/u8GyFWJ87qROyEnjmtJFJo4edSm6cROU1mk/XT3hEXaJPz+F28O9Bw5Q=
X-Received: by 2002:a17:90b:47:b0:3b0:ce1c:e754 with SMTP id 98e67ed59e1d1-3b0db70120emr1678494a91.62.1793952005653;
        Fri, 06 Nov 2026 00:00:05 -0800 (PST)
X-Received: by 2002:a17:90b:47:b0:3b0:ce1c:e754 with SMTP id 98e67ed59e1d1-3b0db70120emr1678477a91.62.1793952005189;
        Fri, 06 Nov 2026 00:00:05 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.06.00.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:00:04 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:54 +0530
Subject: [PATCH wireless-next v4 17/21] wifi: mac80211: pass rx_data
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
Message-Id: <20261106-smd-v4-17-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: MIjUPXknpGGvCRyBVynsVxpjbTQpiQRb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX2QfQAbhvluw9
 fRkxAnMAzRz4pLrCfpQV9Dczh8/KNi+/AZazNmjHTZshqKwF9GM6rFDPnko5ze8CospwL3uCgDh
 OzHkgdDvz6C44Zy8wc9Bfz4SGgtdYogZVGBK6orvwaSVNICS8L0pZxX+EYOJGx8qHtgivxxAj70
 WXIcpEZ6rUOlgo41pY/8W6b7FgHS/kli/3kzadgXxVf2Uvx4b6SkMLsKE3z7TbyYC2VN+/NcTup
 HC14vmEovtoqRixCg/sk51yv37aToNb1angQ2PqXffsfGK3U6zLwkBGkS8gny0xQyNTbD+VN00s
 cPS2HL+PuGDuj3eh7kPeJ6tqJ8g4QtgmTYutsnctISLc7+srAU2ZKiRzSTMvjV3u1coJqxIoOSb
 NBaXQmJm04KuEfXWgh1a+YEAyRrvytHolJKhPJh1/JFvgZ12mQ6EmocGuiik0O7qOTeEVqXVyjg
 wQq/AGBDwxfoz3vkAMg==
X-Proofpoint-ORIG-GUID: MIjUPXknpGGvCRyBVynsVxpjbTQpiQRb
X-Authority-Analysis: v=2.4 cv=X7rHu2Te c=1 sm=1 tr=0 ts=6aed8906 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=QaRRATVtn6WKYfhituAA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX1TcTsWJE7cbY
 Z4kRyU+e6hA4CP2+XSdeJnjJ98nt7mYCgjwEEBgYlsbxRfD3oHgKIk0iX8v3QoFtSRuwBAdi8xd
 Oj9d80gisd9N2NNjqwg8vty1x2Stz90=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

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

