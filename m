Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367049;
	b=Cj6CogXLFGscRizXwKuqyAHChyC6e44EbqHuFH9d2Vjt5yg3VeyEZA+OhuQJveHkO79b
	 O/XhekSasJI+3ewGiPreSgeFsWT3+bVBZGR0Qb5+mTnr7bolwzTnQ7uROHesN/hMqsp4u
	 55jYy1s1I3zw/VKozH+J1AEPEgj6pqNyJmdTHH3EzSiDgtc59wRLA1zZaLUk5gjaSpbvi
	 XRKPnTVvJt4vk4p7BPNAwhPeWPBeCPXvG4qMps0H8vWG0Fx3jmeGulMWZerxd3YanNrXm
	 /04ExcyG9JGdb5rNi5P3pFK4uuU1aqdUrGitrpRzPTCW48m3IB01Py7nBEnn4cGLU4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367049;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Kp7Kyk0OtC17PxPZs3XNy0mNa/QF5YuBXvFtJ1wvAmo=;
	b=DZEWkkVX9Hcg61lMyhN9L7A1xJPxEBken00iN2oYshw/V/TBt3Wz/txqz+ofpMxebiz8
	 CbBbH8Puo8gkE7hFrEJ1y98Nc04LamlLrKoEgK3duu3KI7khJRJCRvBx4JD3RzTyNJWcb
	 DDNe3R0Y6pJ52Zn7AwaLvcQgEFn5/QviT7fWo0DYaJpCDRl1EiIiTDd1sOzXyF32YooYG
	 T76TK4tgK/hZjkOaniEZg1TPxde5lKxkxrP23mRdEdDIMao+lR9ZeIyy0rMKlQATScybo
	 LUFO2NurNMrvbt18oDc5sjkcmLZue7rL0vbJnPKu7HqafRxJlxBnqvxFV+nzvDL2fAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=a7qYY43E;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BsZajEph;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DB606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 845DB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=a7qYY43E;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BsZajEph
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG6Sh2072304
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Kp7Kyk0OtC1
	7PxPZs3XNy0mNa/QF5YuBXvFtJ1wvAmo=; b=a7qYY43EK7JVGxQ+yKuBlQAFXgC
	/qa/kyEfLGFxq6zSTrV2QGZ1Exve1kN53sIsUpjEOfxpvDeEinHlnyKn7Qz2sZtN
	4rv7QHOrxoCjHHJ88HerTyE+jthSat9nJPK/+bXJAGqu3DNvlKXhcXmPNF8eR4+Y
	ulZc1wz70fLiCyG7D049yT+evyXS9yTem+LiHM4uuHoEtvCEUy0EtRZny3dGQm5+
	e9YSUdnegsQtXoOikuBL/2BXqNcB7UOZY1TqXfCOhEDAdpTFxL6VZgS+jnaZw3tH
	1kq6Vs6JFwafqykBlUIBFbmjuustCqrWySonFfvsH1AZBQRmUbokpIAhpXw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6p390b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:47 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso649547a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367046; x=1793971846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kp7Kyk0OtC17PxPZs3XNy0mNa/QF5YuBXvFtJ1wvAmo=;
        b=BsZajEphVHO4GOnOq95iiWNfODit9OKcAdlqrOREviEnARFQQshb2MI7DGYyv4qsSs
         lwi6DDIr1UA+ADuAJWi7R1vPgOrnfXXbrBdjVIm7I3LARnAbtgfmZJwaRK+ZV15MI90B
         vhKuih0+2eiHAtzvnl1o2UerMujVF2vF+9WCVtmeKYGZsf1wK6HCxctDQeF1wyjU24fB
         +IXExHxgZMTQ5hRVL/dI/bD2+HLrHoIBj9GnC2mtDHZCu8n8T9tdUOjOdhyzf/KfYkW4
         PFJKV9zqHXLQW2R1zVrydwfGld0zbs4TG4X4vhcxH9WuQw+wiD/ZEsniE5egCnuEW9o+
         +C+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367046; x=1793971846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kp7Kyk0OtC17PxPZs3XNy0mNa/QF5YuBXvFtJ1wvAmo=;
        b=faW1DSYhbQDmbaPKR5H58ZfyAU3cUxvPcRRjBQ7zUJp/mPI2S8mXEHbi8Pcqacxhyh
         iiUUsisG/UyvIFeUBlgtMvu4n9wTAtTCioAOyneBAAUqUWrbZbwa6cxQMdzS+PicHaXR
         VKUfz9PM2bNfED8mfiJ2/RyA0nhRpckKfz9ongtN8W+V/0PL4REcM7rcSYIbhcqnrBtY
         kk7N0yyKfAzBBmWkNcS3B2m5ZzAMn9ZOSBKVg05ZiOlmX+xxFJbarXoPzQLWaTRRjgZI
         gbLK9jYC8ILtqZyISWbw9VUIuUjf4Pk+KnK+yUwBoRSD4COMB66NzhNnWIqJjeeEHZFA
         nK9A==
X-Gm-Message-State: AFq9FYJA3YoU2IacFmVSyHkkCWvIW8VaX3BMv9ZLbtCEKNGHmD+dfzNG
	Ob8F8VXKUZMy6Y8SV2/dgeupJ6Yk74S/ABDzLUjABz0IscNs2YZS7Q08jCofMAQ5ZA9rnuIs3JV
	73mSx6PIVIzLv7n8LoZm4Oyxds6A20tQ9GA23tNaJyAjWipasxSngATf/GkiA4vwdPR8pW6SR3Y
	5WFQ==
X-Gm-Gg: AYBFou3P8C14lEXLWN500UQQhFim8prt729MniaCrzCLstXSaPMeT4qSsSrEC13Y1lF
	UChlG+YmPT/olGOzbgxfCyumup52g8Y43k/Oa/MUzP9eSxhAHC7jZ2SuglqBc1QJlZoGX5gOojH
	5O7W54j7Hd0jVLLEQWiuXCzstwM4gyoX/T7AndJkRYI25dQ5AGRuhayV3EKq/1R68P8li/3U6Ua
	ZThwuOwoNU+dj7fwTzKwZs7YC+N0Ajl2DaEMcGiJqvszXmj+yj1b8rKr3hFbhVGW8gIT+lprB0c
	Z3gqzX886I3w7LC/xQs4VWQmt5n0lP/7uupiUDL86f3cP/dmG5zDGSqOr1hRGdrCdkoOIVzIsJS
	1/oSeGcsggD0zCURMOY6w/pTy/sJatckuAPB3AuzLGsV4LTO8ucPNdy4lSk6gSkLDXDE95+p/2+
	DIqtWmcuZpow==
X-Received: by 2002:a17:90b:4a4d:b0:3ab:f38:2b3b with SMTP id 98e67ed59e1d1-3ae897ccc08mr1822867a91.21.1793367045952;
        Fri, 30 Oct 2026 06:30:45 -0700 (PDT)
X-Received: by 2002:a17:90b:4a4d:b0:3ab:f38:2b3b with SMTP id 98e67ed59e1d1-3ae897ccc08mr1822835a91.21.1793367045209;
        Fri, 30 Oct 2026 06:30:45 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:44 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 05/16] wifi: nl80211/cfg80211: advertise NAN ranging support
Date: Fri, 30 Oct 2026 19:00:01 +0530
Message-Id: <20261030133012.3009774-6-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
References: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX/vcAx16ZI4iM
 11KoFxF82O28doOYn+Kw6a107w4B1p0ofDmWLuLdL0oTENR/oYP967d66eUhszqGQmaOmxBWNCB
 iD4ario8wzTLDHHQP4Es2+0l7fi5afKkoQqMnUjF1A6afyubqqiL48iqmYEkoIuRKMD9YRCopvd
 f81G/0RX7+58mbUF4WDrjP5JMNRjmPST7KuMXuXWAN0beSLGPt2TssZi0OhSk4rS+kfpQqQl6r6
 nmpBDigtRNc7ExeoMOnIfqty2FsSS0mQtjcbWfOJ77jvHUbxSJ0PxIyRMMIWa9/06RNnNYjSLot
 1ViyvtTBhZCegPatxGDvBzZ0XWxtXrSuJhXqG8ydqCdz3yxWS6NYtJDTU4Bs77NWNqu76ld5S/T
 OyX2LdzJnARMK+yIB2qxZinI3psWfSatSit+QOZQ1pvnIg7JSuPDhVm/4nEOF1/iv9pBjAg9QqO
 urxZGNf1MXrQQVZkicA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3KKPNez6VV9z
 KlhgO9X2IW8jKrGWzbjZf3usWQAUsItceMQMlYVj8QUOTKYYfvP0gzRnnK604Wpf/znC3ifNdvJ
 isEfOAbCr5pTHylE3e398yuRVG3RxPA=
X-Proofpoint-ORIG-GUID: EkfpOtz6D9WH7P6Dw7pJ9guI1feT7NTd
X-Proofpoint-GUID: EkfpOtz6D9WH7P6Dw7pJ9guI1feT7NTd
X-Authority-Analysis: v=2.4 cv=TL3Q2Fla c=1 sm=1 tr=0 ts=6ae49c07 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=AEF9MEfIqb847dwsdnUA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300053

From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>

Add NL80211_NAN_CAPA_OFFLOAD_RANGING so userspace (e.g., wpa_supplicant)
can determine whether firmware supports fully offloaded NAN ranging
before starting a NAN ranging session.

Add WIPHY_NAN_FLAGS_OFFLOAD_RANGING for drivers to report this
capability and expose it through the NAN capabilities handler.
Fully offloaded NAN ranging includes ranging session setup, update,
and termination, FTM protocol and procedure, and ranging report.

Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 4 ++++
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6fc7b2513904..30269e370caf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6384,12 +6384,16 @@ struct wiphy_radio {
  *     (IC) mode. Can only be set along with %WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC.
  * @WIPHY_NAN_FLAGS_OFFLOAD_NDP: Driver handles NAN Data Path (NDP) handshake
  *	frames and data path key installation autonomously.
+ * @WIPHY_NAN_FLAGS_OFFLOAD_RANGING: Firmware supports fully offloaded NAN
+ *	ranging procedure, including ranging session setup, update, and
+ *	termination, FTM protocol and procedure, and ranging report.
  */
 enum wiphy_nan_flags {
 	WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC = BIT(0),
 	WIPHY_NAN_FLAGS_USERSPACE_DE   = BIT(1),
 	WIPHY_NAN_FLAGS_INSTANT_COMM = BIT(2),
 	WIPHY_NAN_FLAGS_OFFLOAD_NDP = BIT(3),
+	WIPHY_NAN_FLAGS_OFFLOAD_RANGING = BIT(4),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 96d1b072d4a5..793015750f3f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -9233,6 +9233,9 @@ enum nl80211_s1g_short_beacon_attrs {
  *	of the Wi-Fi Aware Specification v4.0. Can only be set if
  *	%NL80211_NAN_CAPA_CONFIGURABLE_SYNC is set. When IC is enabled, the IC
  *	schedule is expected to be configured by user space.
+ * @NL80211_NAN_CAPA_OFFLOAD_RANGING: flag attribute. Firmware supports the
+ *	fully offloaded NAN ranging procedure, including ranging session setup,
+ *	update, and termination, FTM protocol and procedure, and ranging reports.
  * @__NL80211_NAN_CAPABILITIES_LAST: Internal
  * @NL80211_NAN_CAPABILITIES_MAX: Highest NAN capability attribute.
  */
@@ -9247,6 +9250,7 @@ enum nl80211_nan_capabilities {
 	NL80211_NAN_CAPA_CAPABILITIES,
 	NL80211_NAN_CAPA_PHY,
 	NL80211_NAN_CAPA_INSTANT_COMM,
+	NL80211_NAN_CAPA_OFFLOAD_RANGING,
 	/* keep last */
 	__NL80211_NAN_CAPABILITIES_LAST,
 	NL80211_NAN_CAPABILITIES_MAX = __NL80211_NAN_CAPABILITIES_LAST - 1,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d92673c67407..059194e512b0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3152,6 +3152,10 @@ static int nl80211_put_nan_capa(struct wiphy *wiphy, struct sk_buff *msg)
 	    nla_put_flag(msg, NL80211_NAN_CAPA_INSTANT_COMM))
 		goto fail;
 
+	if ((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_RANGING) &&
+	    nla_put_flag(msg, NL80211_NAN_CAPA_OFFLOAD_RANGING))
+		goto fail;
+
 	if (nla_put_u8(msg, NL80211_NAN_CAPA_OP_MODE,
 		       wiphy->nan_capa.op_mode) ||
 	    nla_put_u8(msg, NL80211_NAN_CAPA_NUM_ANTENNAS,
-- 
2.34.1

