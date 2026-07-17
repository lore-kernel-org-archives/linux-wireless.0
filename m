Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249CF3D1AA2
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271542; cv=none; b=UIyXzTmSZHHJmoevo0b/JqLTdmPrjGRp090PKjQrxu41XJ3/6FL0+3mrUPsSPYLwm+MaqcTRS/ItTRUZJzrDLJgMYfBGNK7mnxD/W1h2dgYQ2NkMCiwKjVSo9t1RrppJOEyqboCYzjThyUrMB+47HPB5WvF2xFHLRdBcfquUXe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271542; c=relaxed/simple;
	bh=Fpm2RbwkkCe8co+LWhqN+gcN+P72zDIwZMGcqWBkNpo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZRxjK+kjZkIOZlDGRTPL5nwdkNP0BzPaRah/YKWO9Q1gRHl0a30FLKJ0I5FhshxTEWHATn2H4Zkk1LoJIEyddvNUrA/vexfH8c5RSYYaFAMmmdeuOUPDbOgZ9aOrzlhiyapPmLX4S18G2N8npi8WAel2TYdOfCOsvWfV0T0nY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rNavMAFP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rNavMAFP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6wwGiB4176351, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271538; bh=3ryGbHcLF84oEqBxLR0dPUAGtL7YdCPWQ7BFdUNkJBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=rNavMAFPE3KNOySZJ8wGGbrUrnha3IpsPo0KWtEqovz1t1+SNC1iMhh5IK/9PBoYO
	 kd8Aw1CtnTKOUVI5EqHLJocq6cMbfZNQYJhE7Emfi+ARBuAZrrnM43cj3enDShtAsT
	 DVmViyW6Qbl+RvblSgKx3MX0UMimau6PDYg/XbLxKbqY0Xa8fuygXLPiWAM2JCN6Jq
	 gSYv+AurnOH1i6znl6bBJvpNBENp9B3cWaHYyEONnbQrvO/S+m7gLGgBFA5b9UXIxG
	 BGE1qebWkd9x1koKqRsDb5TJ3BIFkpCYqiT2TtSozmPUtYLzCVJZYBUPUXlVie/Dfu
	 GpTDYeGyYGjQw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6wwGiB4176351
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:58:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:58:59 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:58:58 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:58:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 03/13] wifi: rtw89: coex: Fix unexpected grant-signal assignee
Date: Fri, 17 Jul 2026 14:57:29 +0800
Message-ID: <20260717065739.64124-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717065739.64124-1-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The C2H report is for knowing what the grant-signal setting is now,
not for applying new grant-signal setting.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 1bfd3f3d67de..5f2658eb516c 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1935,8 +1935,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			dm->wl_fw_cx_offload = !!le32_to_cpu(prpt->v4.wl_fw_info.cx_offload);
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
-				memcpy(&dm->gnt_set[i], &prpt->v4.gnt_val[i],
-				       sizeof(dm->gnt_set[i]));
+				memcpy(&dm->gnt_val[i], &prpt->v4.gnt_val[i],
+				       sizeof(dm->gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le32_to_cpu(prpt->v4.bt_cnt[BTC_BCNT_HI_TX]);
@@ -1967,8 +1967,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			dm->wl_fw_cx_offload = 0;
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
-				memcpy(&dm->gnt_set[i], &prpt->v5.gnt_val[i],
-				       sizeof(dm->gnt_set[i]));
+				memcpy(&dm->gnt_val[i], &prpt->v5.gnt_val[i],
+				       sizeof(dm->gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v5.bt_cnt[BTC_BCNT_HI_TX]);
@@ -1994,8 +1994,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			dm->wl_fw_cx_offload = 0;
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
-				memcpy(&dm->gnt_set[i], &prpt->v105.gnt_val[i],
-				       sizeof(dm->gnt_set[i]));
+				memcpy(&dm->gnt_val[i], &prpt->v105.gnt_val[i],
+				       sizeof(dm->gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v105.bt_cnt[BTC_BCNT_HI_TX_V105]);
@@ -2020,8 +2020,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			wl->ver_info.fw = le32_to_cpu(prpt->v7.rpt_info.fw_ver);
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
-				memcpy(&dm->gnt_set[i], &prpt->v7.gnt_val[i],
-				       sizeof(dm->gnt_set[i]));
+				memcpy(&dm->gnt_val[i], &prpt->v7.gnt_val[i],
+				       sizeof(dm->gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v7.bt_cnt[BTC_BCNT_HI_TX_V105]);
@@ -2052,8 +2052,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			wl->ver_info.fw = le32_to_cpu(prpt->v8.rpt_info.fw_ver);
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
-				memcpy(&dm->gnt_set[i], &prpt->v8.gnt_val[i],
-				       sizeof(dm->gnt_set[i]));
+				memcpy(&dm->gnt_val[i], &prpt->v8.gnt_val[i],
+				       sizeof(dm->gnt_val[i]));
 
 			bt->bcnt[BTC_BCNT_HIPRI_TX] =
 				le16_to_cpu(prpt->v8.bt_cnt[BTC_BCNT_HI_TX_V105]);
@@ -2137,8 +2137,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			       sizeof(wl->ver_info.build_date));
 
 			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
-				memcpy(&dm->gnt_set[i], &prpt->v11.gnt_val[i][0],
-				       sizeof(dm->gnt_set[i]));
+				memcpy(&dm->gnt_val[i], &prpt->v11.gnt_val[i][0],
+				       sizeof(dm->gnt_val[i]));
 
 			for (i = BTC_BT_1ST; i <= BTC_BT_EXT; i++) {
 				if (i == BTC_BT_EXT) {
-- 
2.25.1

