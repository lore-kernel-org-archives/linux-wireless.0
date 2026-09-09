Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88638C406
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939100; cv=none; b=kWZJ1VyVzhqDhBImgMy8H7WfScgqs61M/dxv9h8b2geHnm+HSFkiL4cu+Zt9q+qRySQWLDrkpASQu2SLdpKTbA/RoiOAyWfKnxl4fZMhpahdS3ay/q6kOshgstuMqBzWzVq92xaU2/OL5X6ReFTl9W8VWst/Bzudfr0c+tnXeag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939100; c=relaxed/simple;
	bh=OIVFqAucL1U1NCzgA5z6DXWrjzXSwibeLQzbK4m5u9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRRfd7IvUnitMEQUEGTDO5u45KAT2YznGrSvr32Jh9fXhFjhCYLclp1SSo4dAVGZryMirxiT4EX4Etx7JL962TofcglIGRU+vNa5HZ9xrN7pcDmBmeoFKa0KgV2tJkWv0pU+ymlVDGgsLYBKlNwUlwZfh8iDXvbuy/p9o7EW3Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=tkPwtbA+; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="tkPwtbA+"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38511175ad3so4686065a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 00:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788939094; x=1789543894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HZAi5w87ASNSFnBjTvWYxTit40zoM8oybJIbzbTRf0g=;
        b=tkPwtbA+ZbLGhV4DB7mK3dh/tap1+Pttsks92JkLdHTNG4zwCpf9bzyMbr3IPrqOo7
         UOilKR6yCqkJM7Bf4Q9effMJNDJq+fxsR4YZOMy/dltSygY83kx9ao8e1QSFzZIDE90N
         VB3XCXJfxeX7gkV9F4rKTwMeg3t7H8ppdNFQ/QfcpgteDOb4Iq7AOy6trVe+vQJan/It
         dqB6NvRcr5TQ//45ToUaIKGCN2sl5ecJ9aH0PB7UShp5cC2LAsymCVpocxRXR15vl0EJ
         eSKeGQDyE4ZDQT3IflRrfnEmfnHynGb9mldYRjISsMMh8n20NtXkDA62t4POKLobwpNe
         p7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788939094; x=1789543894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HZAi5w87ASNSFnBjTvWYxTit40zoM8oybJIbzbTRf0g=;
        b=YWlucaq+HE13AzfWgVyX/H9XeJ3dHIzI7s+xOj1WRhFWCNI63hnzmyYR1H06R83UyM
         E/YkFOuqktSAfKhp2nBXQytGlNq44qngcbVla8ZCrvd3y+vOS0lnZ2S2E6TtsspKHFD3
         XjApxmWieCbOqtD6h0ZkaFzf9TDB8oAsnF4FM8W/RH7AKFlREsZ0d0OB4QoQ+O4xlyoE
         cqMttVppoX8boypB1ZT2tPXc7yJsZEYVeHrXKi/kE8RjWMIVWJ+Gvvkqsc8cbov9Yrob
         mYyB06hgSoT5QyWHbE+RAd8zRfWpGr4auVJI4u2YOv9YzXvI5XyeeJ2oIgpKRCYpTqFZ
         ExVQ==
X-Gm-Message-State: AFuF++nfgjUcOIKOAcFkTsXptJdsNIQZ+X+0LCEb3iXsNwQjm24qZw6P
	bxruvVS9tz6KKyZPDIXDs3GPuY7AEI3N3F/8aBmNAJR/hYYtFqOubgKB9LOtgWV5PdI=
X-Gm-Gg: AYBFou1nvpaUyvgV4XrLkVm7Yb6mA9e7BkwDXhW/4jB3tzHtfxYWgEY+O+J0RXv3txH
	ZJwNxPLML3upityMBwfxJMSxtQ8+LJ0aa4kXHcli3Sobkcui7yR+ufSZEnCji9Faot9pd5WMgjO
	QN1RQzZRQRsKbtwCuK9Xqolo4MWRJ/lLvZZY88t6raADitHPdAcoBVfBQsAGn2Aj0tqrykc9jLu
	d+ejVV48w1WMDUUDyR52GQAmGney0MVVIaxJU2JANWEFpAvSuwnhM9EgIAQvWp8c5SMSauSPV8W
	TOdBWBU3TVzYSOUYVNWfVAw2y55UstPTIFuhDbJRS9bSpG36hEqRk2uLNy8tgjdKRLMdjFwujy1
	R7rsGAYqVxTNVPNmcpMpDvV51cSMh3IRaFDw3r+3vdNg3af0rdqRAaAX3zIPNt4EP5EHzqFVek1
	T4AIBfjBCaG3PWAzuO2GDlngZGZRTv8MrBNyx/0RFVQKGQ/w4Nb/yPF3Y+PpvXtJ06d4FMrgIIL
	zoQxaePxYmKeDubusMhuwpoF0Isy/63BKXRS1TdSrBwPjTRB0FW8rQB/6+yeP1Gbp7UFMmRPIJ6
	ZOUBXo/GU2sPrg==
X-Received: by 2002:a17:90a:e7ce:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-39b2624a1bbmr48344085a91.19.1788939093576;
        Wed, 09 Sep 2026 00:31:33 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2615039asm30891776a91.15.2026.09.09.00.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:31:32 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 1/2] wifi: radiotap: add S1G TLVs and channel frequency
Date: Wed,  9 Sep 2026 17:30:13 +1000
Message-ID: <20260909073014.53344-2-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>
References: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the necessary definitions to create radiotap S1G TLVs
and channel flags for S1G sniffers.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 include/net/ieee80211_radiotap.h | 66 ++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 8bbaf77da7cf..27ee67b38ea8 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -93,6 +93,7 @@ enum ieee80211_radiotap_presence {
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
 	IEEE80211_RADIOTAP_VENDOR_NAMESPACE = 30,
 	IEEE80211_RADIOTAP_EXT = 31,
+	IEEE80211_RADIOTAP_S1G = 32,
 	IEEE80211_RADIOTAP_EHT_USIG = 33,
 	IEEE80211_RADIOTAP_EHT = 34,
 	IEEE80211_RADIOTAP_UHR_ELR = 37,
@@ -112,6 +113,9 @@ enum ieee80211_radiotap_flags {
 
 /* for IEEE80211_RADIOTAP_CHANNEL */
 enum ieee80211_radiotap_channel_flags {
+	IEEE80211_CHAN_700MHZ = 0x0001,
+	IEEE80211_CHAN_800MHZ = 0x0002,
+	IEEE80211_CHAN_900MHZ = 0x0004,
 	IEEE80211_CHAN_CCK = 0x0020,
 	IEEE80211_CHAN_OFDM = 0x0040,
 	IEEE80211_CHAN_2GHZ = 0x0080,
@@ -792,6 +796,68 @@ enum ieee80211_radiotap_uhr_user_info {
 	IEEE80211_RADIOTAP_UHR_USER_INFO_2X_LDPC		= 0x02000000,
 };
 
+/*
+ * ieee80211_radiotap_s1g - content of S1G TLV (type 32)
+ * see www.radiotap.org/fields/S1G.html for details
+ */
+struct ieee80211_radiotap_s1g {
+	__le16 known;
+	__le16 data1;
+	__le16 data2;
+} __packed;
+
+enum ieee80211_radiotap_s1g_known {
+	IEEE80211_RADIOTAP_S1G_KNOWN_PPDU_FORMAT	= 0x0001,
+	IEEE80211_RADIOTAP_S1G_KNOWN_RESPONSE_IND	= 0x0002,
+	IEEE80211_RADIOTAP_S1G_KNOWN_GI			= 0x0004,
+	IEEE80211_RADIOTAP_S1G_KNOWN_NSS		= 0x0008,
+	IEEE80211_RADIOTAP_S1G_KNOWN_BW			= 0x0010,
+	IEEE80211_RADIOTAP_S1G_KNOWN_MCS		= 0x0020,
+	IEEE80211_RADIOTAP_S1G_KNOWN_COLOR		= 0x0040,
+	IEEE80211_RADIOTAP_S1G_KNOWN_UPLINK_IND		= 0x0080,
+};
+
+enum ieee80211_radiotap_s1g_data1 {
+	IEEE80211_RADIOTAP_S1G_DATA1_PPDU_FORMAT	= 0x0003,
+	IEEE80211_RADIOTAP_S1G_DATA1_RESPONSE_IND	= 0x000c,
+	IEEE80211_RADIOTAP_S1G_DATA1_GI			= 0x0020,
+	IEEE80211_RADIOTAP_S1G_DATA1_NSS		= 0x00c0,
+	IEEE80211_RADIOTAP_S1G_DATA1_BW			= 0x0f00,
+	IEEE80211_RADIOTAP_S1G_DATA1_MCS		= 0xf000,
+};
+
+enum ieee80211_radiotap_s1g_data2 {
+	IEEE80211_RADIOTAP_S1G_DATA2_COLOR		= 0x0007,
+	IEEE80211_RADIOTAP_S1G_DATA2_UPLINK_IND		= 0x0008,
+	IEEE80211_RADIOTAP_S1G_DATA2_RSSI		= 0xff00,
+};
+
+enum ieee80211_radiotap_s1g_ppdu_format {
+	IEEE80211_RADIOTAP_S1G_PPDU_FORMAT_1M		= 0,
+	IEEE80211_RADIOTAP_S1G_PPDU_FORMAT_SHORT	= 1,
+	IEEE80211_RADIOTAP_S1G_PPDU_FORMAT_LONG		= 2,
+};
+
+enum ieee80211_radiotap_s1g_response_ind {
+	IEEE80211_RADIOTAP_S1G_RESPONSE_IND_NONE	= 0,
+	IEEE80211_RADIOTAP_S1G_RESPONSE_IND_NDP		= 1,
+	IEEE80211_RADIOTAP_S1G_RESPONSE_IND_NORMAL	= 2,
+	IEEE80211_RADIOTAP_S1G_RESPONSE_IND_LONG	= 3,
+};
+
+enum ieee80211_radiotap_s1g_gi {
+	IEEE80211_RADIOTAP_S1G_GI_LONG			= 0,
+	IEEE80211_RADIOTAP_S1G_GI_SHORT			= 1,
+};
+
+enum ieee80211_radiotap_s1g_bw {
+	IEEE80211_RADIOTAP_S1G_BW_1MHZ			= 0,
+	IEEE80211_RADIOTAP_S1G_BW_2MHZ			= 1,
+	IEEE80211_RADIOTAP_S1G_BW_4MHZ			= 2,
+	IEEE80211_RADIOTAP_S1G_BW_8MHZ			= 3,
+	IEEE80211_RADIOTAP_S1G_BW_16MHZ			= 4,
+};
+
 /**
  * ieee80211_get_radiotap_len - get radiotap header length
  * @data: pointer to the header
-- 
2.43.0

