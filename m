Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B9C4DE706
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974087; cv=none; b=Eufvj2Xlhq2UvQyUpQZdSEBHw1fgpQ/jtVDlnYKkdyVPVPb22D7KCmYAr6p3rNxFXLIOO+pVGetHozYUA4QBn6iq9XVBcwGuwfoVeKY2aJjrSw7QctZkbXi/WsE2xR1S+Xyy2eTeAjj2NLFdkhZrRUl7WJSN4UkY3CivWyrjATg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974087; c=relaxed/simple;
	bh=FG8KE4if4V4mDQ5Kt/tyshHPP3fc4w7c8GMUC0TE7c8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EFRlWGDD/kbh+eNa+KdcA/ke/a2slYsKZ4/+GvYu9z9kTpmlacoz/7z5xKqMkpUd6LTO5BE13CHByHy8BZKwontnz62PL3h34fGAA3lkSTm5NaXLUU5yV9A/pZCLyOr8VOpLx6Do563B9cgp/442Wi2vIxdi+YiAD8PwGBPIgYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JFWrji1P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YuuaTmNm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JFWrji1P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YuuaTmNm"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E684Pd2515931
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=kYfOwr75+77
	T3ZiAS5xnzsoW7cTSGfJ4vkovGyXfna0=; b=JFWrji1PSpjICk/QMWP1ytNR6gy
	DjmddF0hOXeKXRYrDeglAFEypNsUKsDs8LnO1nI53tHEBBHm1alkUl9/pfo/WZOy
	waTpuU+eywdYr7/ff3k6cG3WHVzsywua/r07XkeFAzMWujxoUnDMDPLBOzwE+y91
	QO6gxjeAGkRgWtIXN4DC4jX/y+nQEYJ7ZKy+zY3T7eBQ1BL5753qll48g9Yx81XK
	mDo192XWsXkKKNKO6cQj38U9AaDmukiY3r3Mmixg9LBgEh+vMXPGk3C9M0XZ5OrN
	UuCPINROj0MQO7pBnzrgYA+Gi76n7CCb0qfOoOHmnQaiCR7BN4Civ9C2Tgg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha47093bb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:44 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-357e2bc3b1bso6631200eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974084; x=1792578884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kYfOwr75+77T3ZiAS5xnzsoW7cTSGfJ4vkovGyXfna0=;
        b=YuuaTmNmlfsA1bHoB0LRT361TOqovyhKaMZMYMAqxTmMRyGUNctQ/yA13j8LjI9HXy
         gDQcP+zYUswH80wLEFHvZemFhabviGyHUT7I/o4tmcfoxU4PDOEPJ2brWThwBAVkU9Xs
         y5dz+t9eIIT7o9JPvwXgEeTtUGZtruVpZ77hO45YLEGcIzLfxxov7pUoxAYqsD/Fcwxr
         N6r+DmcBvp8BkRg8Yi52ftsqPlNnWpWOyNklgAMwLy1XKamumV6qkczRON4tw0iqw5HW
         39uhhEGMgC4d4Xnk+ZYZPOgyrzXZ9UAsBRwy6oExmiMLOW0oYekoqd+qrSXmxcbqLfrl
         //KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974084; x=1792578884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kYfOwr75+77T3ZiAS5xnzsoW7cTSGfJ4vkovGyXfna0=;
        b=OuXqmhhPAeiELXE2M9WkslFT+SiAOcumh0VW3z5z+Kg+A6os/RMCq4S2kXtsD1ZCve
         64G+dFDUIxR5idg3hoIAjZM82hlebLNxruF91u3gKr3+eUhKZ7IhGziHjZCmZHHAoYVc
         hqvYFdNkwTo91FCls7eMVIkdwcOQrI+W+I4pOt4Hb3zBn2Xn+jFYVl3G1LGPASkpIPHL
         g3y0OEy+H+vONoAqgtQq2VwRQXrpTXuagR8M8m4uE+Z/LnkBYPX6ugaT9kK07J5W8BmM
         IgnPgZ6ob3eWHcZs560LlOmcsXePs8Sagii2KpOAg928EekPKlHafB+37KewiReml433
         bbuw==
X-Gm-Message-State: AFq9FYIL7aPxkcTa9RaLNjSJoKgCf5FcE56YzYvrPF4SBaQV36W61BtQ
	exfCRwWAdpwVUJRoZh7S1DBA73DNB+XzB8u91t8wRJMjjX9EW9rV0M9arFrCj8psrKupQ4mQ5ED
	InVV5AoGvbwgN5eH4Gb4eS7WCBIL9q+mo39zxjKwfnJAWzqTqrmub0IWgI5u47fS8MlOQvw==
X-Gm-Gg: AYBFou0Q/2KxrBfKfwRYkbnKjxpqMZh52Z/7I2+a/RKqUibKwmjAfDoDJ51OlC5VCE9
	CSqvryhqVHkyLt/dWKuucjJFDXljwf2hMx6yNc7u8r8jYqRm8hqTw11b0cSdFNlAAA1xokFcwlU
	wtZFylVOxhRMjArTH91Lm7lGbk0IKOKbJSHwZ7PBRvlqjEc/VxfaWzIyoBdVxJ6hySQJWBre4pE
	JRFVjnSgWbVIseSU4ZfHZipfswTe5BpngRkjuPxdJsZRYUyTuWPy2j0JJSUjuzJyLlPmx3CmsvF
	s0MEuvg3nsb7SzrJpIpR8r3Dt3nMQa0XiEubqXxI9oyz93yObQYGEY4MxWNBgFqoIS00xBgzidR
	UoEWSHvHwv7DMjx3yKQVOLj4ga4UIBSCUA1zG
X-Received: by 2002:a05:7300:22de:b0:351:595f:a941 with SMTP id 5a478bee46e88-3537df5139dmr23261947eec.8.1791974083886;
        Wed, 14 Oct 2026 03:34:43 -0700 (PDT)
X-Received: by 2002:a05:7300:22de:b0:351:595f:a941 with SMTP id 5a478bee46e88-3537df5139dmr23261916eec.8.1791974083325;
        Wed, 14 Oct 2026 03:34:43 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:42 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 09/15] wifi: nl80211: add NDP offload capability advertisement
Date: Wed, 14 Oct 2026 16:03:53 +0530
Message-Id: <20261014103359.1508345-10-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX0H7SOf+91bHU
 H1xVXyzQxmclsI1ZmfGszSdSOWriPJDBV+QIxrHnDcROXva3dG4ZkiAVGHAt6LaM/9kWGYDTeGm
 zFf9rF+wdco4E6p4aIYqngroKnfOhZn0WFgfnt0hDzWgQtS/+vTtDXS6x2NMhHiCxP8bY9rJvFN
 GKOMCo9iThyGtJ5LvjSpLt8kU12dAeRpPeX5Vq0TMq6b5CYGD0mgD9pDVyp3z9WuLpNFf4wNesb
 L15MVMcFIi88vQYklrakJx78UVzyPgKX2k06YxNwJKHRr5seaPdoaSWen+T8Dzdk3T7g4p2YlrB
 +wFgNClRAr2IVsdbImfx2kBm5YWtvosp604oeOvPOoIFVSUusWqHjPMVAK3DyDEaZ74d/cl5FFd
 1GCs4kbuNzRk75AqPcamLZxAOdp+M609VWQ+yRvydLSHNdo3+L0sxCpIHOUCSP5NZXSm2KpEJMa
 Jx14bFskFi6J5WXnlpw==
X-Proofpoint-GUID: GMprHfzHHS2ZfaIhg_JI8fUYtrGkNyhC
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf5ac4 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=p0aosYo9whJMOrixj-kA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: GMprHfzHHS2ZfaIhg_JI8fUYtrGkNyhC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX4G+4TDP6qF6s
 j3XHHIz3tNTnZwJw+/3rSNmGm/hHtgNZYWxDFofdjBEaRxT5+A6XOKSIfyt9psHzfkVeElgwr+z
 A3RnaeCi+wG0hEOZOeLPjUVxm3iv4H4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

Add support for drivers to advertise NDP offload capability through
the NAN capabilities response so userspace can determine whether the
driver supports firmware-assisted NDP session management.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index af2b3a12572e..05ab24b10bf9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -9279,6 +9279,9 @@ enum nl80211_s1g_short_beacon_attrs {
  * @NL80211_NAN_CAPA_OFFLOAD_RANGING: flag attribute. Firmware supports the
  *	fully offloaded NAN ranging procedure, including ranging session setup,
  *	update, and termination, FTM protocol and procedure, and ranging reports.
+ * @NL80211_NAN_CAPA_OFFLOAD_NDP: flag attribute. Driver handles NAN Data
+ *	Path (NDP) handshake frames and data path key installation.
+
  * @__NL80211_NAN_CAPABILITIES_LAST: Internal
  * @NL80211_NAN_CAPABILITIES_MAX: Highest NAN capability attribute.
  */
@@ -9294,6 +9297,7 @@ enum nl80211_nan_capabilities {
 	NL80211_NAN_CAPA_PHY,
 	NL80211_NAN_CAPA_INSTANT_COMM,
 	NL80211_NAN_CAPA_OFFLOAD_RANGING,
+	NL80211_NAN_CAPA_OFFLOAD_NDP,
 	/* keep last */
 	__NL80211_NAN_CAPABILITIES_LAST,
 	NL80211_NAN_CAPABILITIES_MAX = __NL80211_NAN_CAPABILITIES_LAST - 1,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3147eeab84da..ecab5ca2b690 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3168,6 +3168,10 @@ static int nl80211_put_nan_capa(struct wiphy *wiphy, struct sk_buff *msg)
 	    nla_put_flag(msg, NL80211_NAN_CAPA_OFFLOAD_RANGING))
 		goto fail;
 
+	if ((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP) &&
+	    nla_put_flag(msg, NL80211_NAN_CAPA_OFFLOAD_NDP))
+		goto fail;
+
 	if (nla_put_u8(msg, NL80211_NAN_CAPA_OP_MODE,
 		       wiphy->nan_capa.op_mode) ||
 	    nla_put_u8(msg, NL80211_NAN_CAPA_NUM_ANTENNAS,
-- 
2.34.1

