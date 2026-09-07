Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BC23AE188
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813202; cv=none; b=FqXWZMBdrSAgA2SPRbma4vz5HMPSFYroO1TEHSaMwevzoD7BL+5x/7Q7T1WyPgMk+8yomnaKKke7QBWq9UEPODSWARYWYzw9qaZcRanJialJ01szZn/vOpqlnW6vmaF27eQTavUqi75OPK+BDyTz0PtYU0km+C7WWELh2kkxpCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813202; c=relaxed/simple;
	bh=ODuW2nybW3REfD8SbUhi8QOhAYOU2HQqcQkaxRn64Q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OZ9HfoLFFJ18lDRC76if+APzN3PPCTJcfDNi4CegsmyD7EzG3rdiYDt35+sDgD7JVoRKN7s+i5t04qjn8i1A8vr/+r50XkAyE3iMatr8+tVbFEK666hr3hHPTZJYOiVx0RCXym2RNXwnhLJIPbHLbG3lgG42tNwJRUlie3hlWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c3xL5C26; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TtDh4qGL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c3xL5C26";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TtDh4qGL"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H8WUc4184833
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s4tTeUVXrP8PDX4fDGv3MD0jVy8bbBgnnC6+ayxYRRA=; b=c3xL5C26/U1riqgx
	Uvn6EZppMDW6QU/3BUBxWZ8A62BeydPjaDc7d/II7QOqgJMpdk/Dy4VpjlEywTNh
	ohChqOUHGhvQ/uXIBkq3DUrBoAwT/++jyqsGhMEvRW8VWLty7WxZa8TsFGol4rXx
	GjG11RuC4DCIGVg6IO70ucPhzNGuRMi4b0D2HZPN9tf87OPlZXgAPtwBrXuCPv6E
	jI78W2EIEOUzSE2gZEt9jLDig/x8lZceO2WtNW1nRS3gaYuSDn0m0MBluse7gu1u
	qBh+tXpYPiVA9DHmUIbKKs/Jl+vtEu249+s8ygmLzieVMgQcT5LSqvbvcfExx5tN
	KRHdTA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghtfx2930-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:20 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so8025686a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813200; x=1789418000; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4tTeUVXrP8PDX4fDGv3MD0jVy8bbBgnnC6+ayxYRRA=;
        b=TtDh4qGLadDdbGwJVzglotsoD41NBjNwsqOqQTaUbqn0rxwWXxDaoFsV/sdu1ikark
         ika6YcuE6UI9Wm7jlWZGrx2eqfz/6MrLa6jwPK7S0rMDTb6SRJ1xnsp/x05TZEb4U65N
         TDmx3/yhDoTMjhJHNE6Dgo7g0yDg9e/KTNGnjzX3bE4K/AYZABeTUbKiWytpE9LDiGXj
         qy0J4/qWnGtsF3Rv5V0a6PwG2BAnlbgPDwVhFzToD6z4ZIH0Sx7VLFiWegcfxrEzJo9r
         3BOSuWOmKOA6YxdtSnF9sehjTEIgu4i57ncaPGp0l/fqeVmymvqshP3QlC3lAaBVeu99
         74qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813200; x=1789418000;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s4tTeUVXrP8PDX4fDGv3MD0jVy8bbBgnnC6+ayxYRRA=;
        b=VPQ/5FuQLNE3pGaw55gLnOcVcTeMWOgWfAOCA0k9ChUJzv9wTfyCPIYl0sSXdTdpx1
         o/DU+eEVH+PYuazoDTqdhlKwomYCjD4Vbyew2rxp0wJF443+Mq5z8iH8SgGYvqtvr57Q
         +A8YhEFCpBg5AEJgNhC7c7cADFQmRgK/iF4ARoYuG3cTjjBOXD/6Qfuq+7P8wa2V1Ye6
         oNq255F2aXLFNQsImswXj6XZJ8inj86ktXyeIA2A9X46cXAQ9iTxP/5YVXvHY0dR6YE4
         noSwqgLLfz1OZreRtcwsqksMXDc9MzB+V7vfBrPP0uzlEsQbIHWtfZT+rOi+CW54iSLn
         lZ+Q==
X-Forwarded-Encrypted: i=1; AKwUvBy8CrXV+Fvy63bhcsWl4R2aEiPWzj2DwuPcq9P1SsoGvPSinqbCUCv4xhAxUcCOhq7j/z01DXXPiosN0bjgNA==@vger.kernel.org
X-Gm-Message-State: AFuF++ld9RIjEVzZo9vGVGtea5GPRK9HFNbwXLGPrqJAvECeRrJzM8eF
	AT0P8L2YLRFUALdwYFZBk3N8TsJbUP6rsSOv/HJ30/Wl5LqiMYxsErNljMm3rpMt0UFoUNSII8S
	2Y3IVTxSMYj7sF/Fbic90vtyPJSHcr2uxdd+qmDnyQznRMNBdUkFcLKMZo3C8BRWGnpvA
X-Gm-Gg: AYBFou2dQlqVucnpQrXG4t6b6C/GbKAtI+Gb4zgLWkwiaAQ/DRPQ1HmZkJsxxISj/DN
	PcaN1lhpT0feDQgc2Kksz8iXOizo8h5eqAMnqXDT19KtBHduG0p+ew/28MtSg7xSXwnFgMJos3U
	cIeuwJcIcydBnDy1nBjyvJq/pyP09c1JW2yAIVvFSWINewqqXjPJD/qcBzI5UaevuNyF3bJnVlT
	DWVTuNgMpWcNNtoYkUPVgvSeKTUJufvs9V8yPfF0VKc+2nSsqFBERoAQJp0m5VRR3JAViTUo4jA
	7XkGalEYegiolbyHvUKDvvVQTJ2uiWII4YboM/3kosJf7z3ZCo89oQlgRJtiSUkvWQQQLw1TvGj
	dnlYEqv0UCtqE/Y3cJH39eBzm1q+p+KypiB0oiYL9RrHlGR4WlVUKxBUI9NxpUHclC7mGE86TFN
	8X4mtVXanFDWo49RrNay9vJg==
X-Received: by 2002:a17:90b:2f46:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-39b260de5c6mr40578519a91.2.1788813199899;
        Mon, 07 Sep 2026 13:33:19 -0700 (PDT)
X-Received: by 2002:a17:90b:2f46:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-39b260de5c6mr40578476a91.2.1788813199447;
        Mon, 07 Sep 2026 13:33:19 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:19 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:11 +0530
Subject: [PATCH wireless-next 02/18] wifi: nl80211: Define Seamless
 Mobility Domain (SMD) device capability
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-2-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=Weg8rUhX c=1 sm=1 tr=0 ts=6a9f1f90 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=-9rhnhb8Ej--qkh-m00A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: aDFdWJnJNI8cVqlDunCbTZ8-y2fwYORM
X-Proofpoint-ORIG-GUID: aDFdWJnJNI8cVqlDunCbTZ8-y2fwYORM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX7p6uB1mr8uDT
 pz6Im2ZAmn8U3LLIpoq72cnxLEl9Cij+Bi5mPn5NDp2pJNQdGowuuM3eJOgMfqRqW2bAbjXSd9d
 Y38fx4DcBjfLw5g7nCtT63C9ReSEE0Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX/HOvy3e6goQ/
 vkZTya1GYlEe/4Udt5Euz4HwhTmA+psZcxkC5bexyVQ31OkB6h02PctRDREzHnKZhbia8G3blPP
 9RYQLwez6DqNTNvqjQM1CInBRoEh6R5K2p8yJiWk+yUeDxf8l2ncuobVa/4AkBy8X7ylJ9Ps/Cz
 nOsbfuf1MRQDcKjfqfo8KDcqOV5kKLAModbDMcy4L77xe3h64D/KoiBoW79Dua+LgtrK5xdHrgI
 IPZgZVQCLjPQWaADeLNipJzAiwQpCUKy0axSYuJ2S7KCmC6783ak0kG03Gl/5FZmhpkKJHcr9iS
 b1sn8HbnsRjoqpvQJiGjqnNDa2XuUwa3PB7Q9axS7N6mumlzc2qMpQ8fRTZgZolXQnmABysm+NL
 w8F2L+o6B3J/XNkscJPe2DOk8Bl2nNT+NcBC6b0wxiq1Lnkj22Rpq9/5QMXVsjZDE4dkGm2BGye
 xrPVBXz2EZoMNLpiuig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 suspectscore=0 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

From: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>

Per IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16, an AP MLD can be
managed by a Seamless Mobility Domain Management Entity (SMD-ME) along
with partner AP MLDs to enable seamless transition of an associated
non-AP MLD from the current AP MLD to a target AP MLD. A non-AP MLD
advertising SMD supports association to an SMD-ME and SMD BSS
Transition between AP MLDs within an SMD.

Subclause 37.16.11 defines an optional capability for the current AP
MLD to forward buffered downlink (DL) data frames for the non-AP MLD to
the target AP MLD.

Userspace needs a way to be aware of the driver's SMD capabilities so that
it can enable SMD configuration and operation only on capable devices.

Define two extended feature flags
 - NL80211_EXT_FEATURE_SMD for SMD management and BSS Transition
   capability
 - NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING for DL data forwarding
   capability

so that userspace can gate SMD setup and data forwarding configuration
on driver support.

Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d8fefefc11a9..d9ce185b0ef1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7114,6 +7114,15 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
  *	in STA mode using @NL80211_CMD_PROBE_PEER.
  *
+ * @NL80211_EXT_FEATURE_SMD: Driver supports Seamless Mobility Domain (SMD)
+ *	and is managed by an SMD-ME to support SMD BSS Transition in AP mode
+ *	and supports association to an SMD-ME and SMD BSS transition in
+ *	non-AP STA mode.
+ *
+ * @NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING: Driver supports forwarding of
+ *	buffered downlink (DL) data packets in AP mode to the non-AP STA during
+ *	SMD BSS Transition.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -7196,6 +7205,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
+	NL80211_EXT_FEATURE_SMD,
+	NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,

-- 
2.34.1

