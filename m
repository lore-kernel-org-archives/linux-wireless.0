Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9392144A41A
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543466; cv=none; b=ofK4sx4YeQaOUtI2K17lLpVRYFz3VmBwXpq5LIE4kBU/fhtyfckAdq4jWPqjX4H6f+s0WfBtkxISct0gQ2R0Fiabhk2XOv2gz359UO3gGYmSzh/oQLoaMbeJNmzvb1lNpkawiCXbh5eHQwc80AbaTwysmD8sPz+PIbOK2iSwKq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543466; c=relaxed/simple;
	bh=H82DS6gj6htwLKgCrTJ8mbD3x2NKs1SGk8FN/o+Rlf4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/N4u0DrmMRifieFsX7mEfJtc/IsOkk5O3YMQWKVvg7z7KfLZlf8olK+rAqgswjbZk1iBusN6xPGRIIuevigNqcjBafEFK1rmut6seyvyqDNwhsPDfTlYVh6aeNwbisIPU5mQbIZpn5dEz2U43FsXD31eAEtPpIb31JD3C7RpIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=l9CUM/x8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="l9CUM/x8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NmdK62168469, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543428; bh=6lOZJJ+Lq7VVWt2AOaVtjTRbYh2qSPkrlxH/WcEpbc8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=l9CUM/x8XVKTsFM3GdhUsaZ0sakrTEsw948zzvHoHZuz+qydzFJw4Gogy/Dd+zt6S
	 HtTGr7ULK2ci+g23RiQ+Dgue/lLaq35A0JJ4W8AMgu1En/UuexD+GHtKkBK8vbjAGp
	 4T4gOjxQ1QjoO13VbQ61QgoRpYK4LxzHPE6TUTYwWN4HRox9Js0EkpYhbst4pdbgN9
	 D0PsBUW7qSaOigY0iZqoGX9k6fPT6sjRZT9WL7dDmWAd7RVba0mqGwkjINjb8+eWAN
	 9K8A+W/kU+pozrjwxRAL92sYprvI+1c5vo683UlydWUzg7AioEoXQWGgIQUGXpCv/6
	 H+xwbdK5FM0lQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NmdK62168469
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:48 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:47 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 07/15] wifi: rtw89: coex: route BT sub-reports by bt_id for dual-BT support
Date: Wed, 16 Sep 2026 15:22:30 +0800
Message-ID: <20260916072238.62574-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

RTL8922D supports dual BT (BT0 + BT1). The C2H report structs for
fcxbtscan_v8 and fcxbtdevinfo carry a bt_id field that indicates which
BT device sent the report; without routing the data always landed in
bt0, silently dropping BT1 information.

fcxbtscan_v8: the existing code used a local 'tbt' for the scan array
copy but then wrote scan_info_update to the outer 'bt' (always bt0).
Reassign 'bt' from bt_id so the update flag reaches the correct device.

fcxbtdevinfo_v8: no bt_id routing existed at all. In v8 the rsvd byte
carries bt_id; add a version check and redirect 'a2dp' to the selected
device's a2dp descriptor.

btver_v8 and btafh_v8 already route correctly and are untouched.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 785060acf508..2513af4d727c 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1591,11 +1591,10 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 		} else if (ver->fcxbtscan == 8) {
 			struct rtw89_btc_fbtc_btscan_v8 *pscan_v8 =
 				(struct rtw89_btc_fbtc_btscan_v8 *)pfinfo;
-			struct rtw89_btc_bt_info *tbt =
-				pscan_v8->bt_id ? &btc->cx.bt1 : &btc->cx.bt0;
 
+			bt = pscan_v8->bt_id ? &btc->cx.bt1 : &btc->cx.bt0;
 			for (i = 0; i < CXSCAN_MAX; i++) {
-				tbt->scan_info_v2[i] = pscan_v8->para[i];
+				bt->scan_info_v2[i] = pscan_v8->para[i];
 				if ((pscan_v8->type & BIT(i)) &&
 				    pscan_v8->para[i].win == 0 &&
 				    pscan_v8->para[i].intvl == 0)
@@ -1653,6 +1652,10 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 		break;
 	case BTC_RPT_TYPE_BT_DEVICE:
 		pdev = (struct rtw89_btc_fbtc_btdevinfo *)pfinfo;
+		if (ver->fcxbtdevinfo == 8) {
+			bt = pdev->rsvd ? &btc->cx.bt1 : &btc->cx.bt0;
+			a2dp = &bt->link_info.a2dp_desc;
+		}
 		a2dp->device_name = le32_to_cpu(pdev->dev_name);
 		a2dp->vendor_id = le16_to_cpu(pdev->vendor_id);
 		a2dp->flush_time = le32_to_cpu(pdev->flush_time);
-- 
2.25.1

