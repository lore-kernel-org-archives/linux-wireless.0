Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699669;
	b=aUNGjroU8PzXgiRMku0uZ+z+1IByhR+pxS19ZlBnfxjdlNuK8xeduXmonksXNIYQ39i8
	 QtOfZCUJtfzfy+Sjx0aT65Ja/iRnOYwEmMTrOJGEIEklqfLOG+wAD4YHFYtRNKI8GYtjM
	 V3A/gSkiObJTNJZ+XwBkVUjfCTAIoYNyDBckT+4TTWdOR9Np0fTf7/DO28iqqbdjHrtOs
	 pf2CeeKa+W69zVn53wVQyJGxvLfzeQeVUTn1+hQZh+PbA2uDA6Y4cW0oGgLkSMjP09WBu
	 eMgAGG8LtG7CP3nu3s7tWrJ+FXzV4fFaVTQoaXHzEJPwgzmkYjByAkMte1lV0H0oO+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1DrmLhOc3MXaompyGxcHHoD5L3ZlNcw3m6Bj9oCs4I=;
	b=ybH7uEa3AhsrpnfYxyeeAD6IXkztZjinpj5OKjNr9CZ8LtbyLnxDHenG+SxKRFX09onB
	 vpHnzy7Z4R6GRRThRKgoClPo96o10jJSWchJ5+4ih2znqVtXMs7iCXZ2dt17/VJXq9vMO
	 W5eJyRmn/9fAD3kpzInRTqDb9Ig8HwfaokkG9nn9BTrcu/STRcgrdRX3wCubpPqgI9yV5
	 bVSmpNVoUkIFLFSmXHVAlllqPcxpcHBTZ57/tDUl4wkninLtRfZIRXKFgg4gK69fITeue
	 eYEluVUne+phqOiu5aZ2z1alj+VeAnzBn0DTyyKl4v6HnmocSMloS9fI8/QV9CUl8cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5C16085081
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B5C16085081
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1ae58d17cd9so997319c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699658; x=1794304458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l1DrmLhOc3MXaompyGxcHHoD5L3ZlNcw3m6Bj9oCs4I=;
        b=Zg3uL83E9KFWqiJc3kKjlgKWitAniqjMvZQc2gWpVGxj4Qep/TmlBLmwTvg6OS4kYc
         QUw/Tr4Y1nsQA0spOBxuQo6yYQfCaWFRKbmgNSYiIP7bxmaN+TPuyUCQYX7/1fePT53+
         QpcCBhkE4rMYeyoGTI6t0oXYWai1d6BKGCH0MuXsJQCZwFoOLoHZAYjZT2jEBqSxsNxe
         WSCn11ZwT8iIjAyyjjAx7SWWbdi/AAKpuPvoMUYgFdCVHGcFHOOwAjkuuBJyxpQzRqzN
         FYeifowytzGWzVTfpWoINzxgTxhN97sijhXWZJajxJkCu6uF5ip1QHNN2vYI1uTzpgXG
         fxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699658; x=1794304458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l1DrmLhOc3MXaompyGxcHHoD5L3ZlNcw3m6Bj9oCs4I=;
        b=SBdhEYZPQDI69gQFYjCVQl+r1RR0Q0fekZeihvgeEk/X75ehDa6XpJTG2pnhgg7fB+
         la5+GlASqnqZllf5KM3F/lynbvkzuxya+XLtbE2HdOy8LZSHrvCULwI8UDV7q7WigHPC
         P5Sn9zf9Y/CY8GQ/ZvhKh11Ocbgb6XGC0BnyV1l+9JyUPyH8zHLhRpYKB5+aVj4hiHLt
         60RAGpbJfaZ69pSZ8ZFv346bJEmVDfPs9wwgWiQPtY9lwcHCbJvUsurH3TFy/l3FYvAT
         gpFpqdwN/5kErUg8tjnRBmGoxoxDSFFWqW7SDuMeGQ2VrSw9pC5eIR0E+wX7Pv65DNDv
         7skw==
X-Forwarded-Encrypted: i=1; AKwUvBwWTJACiQNVKUaB+JuRT15iet5599vM4l9lM3RfTkpynFS0xapUt0VhEQZqhZgz40N//U1bXmk72k8V2UWEPA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/SOwCz58kaMvA6EoKeeRQPjbFjxVCwFE5I3sMxOJm4UOghPMoo
	J5ZTppNHZDfuvSpXAZM7I9MFXByltiFulVs8PfyPOg6++h/X/b7dRA4LZkYtrg==
X-Gm-Gg: AYBFou0LSvdxIJCox6OxdqV9mesNmLE+/Z3bAc9WPkRsFlCpDhEi09NfygqgduFQ2m6
	lLV4YjcZsMf86rxxiV5OXv+zpY+V39bmHTXvZWMGRrVNjTtRlLEgKK1cK3rkZkczDJ8n41A0EEN
	z6zmd+a6W1QnsQZI/dca700Z7356AxG7G4hoe11Ru96ZV4fsa43x91HvNDgE8v9f1kRG6076ovx
	eUPQDQ1nD9wH8iqF3u+n3tiyJFtB4bevqEP3EtOaJ0Mq+7iS/2wtphxHKdHH5eQbRQDJYbLPCgV
	kr5/HuVf+EBqXSsvSX98qCnGW/mrdDVIMrgUxguIOJ7vUHXHE8sirCZPrUUjEdrKenG8Rl0OsU8
	YIBROhdbpzZ3gpFwyeHNTnDSI8B8I9oRbK378CpWqNF/9wiNmkpeNgZfRFRnlkKW4swgKpy8Xt+
	2GH3qpxDUZrr44lddecySgSopO3DSCPvXMAoJsSmpWCrJOlggVXlh13Wz9skopdci8+TuoUHdfR
	ofTKRBedgaTG0yuOiFvvKmz/Q9ncHzYlVHNkPDlJX6y/o6HKYQnVR46FWRo6S2IKDF3VN5EZ0Ry
	zwy3X1mWzMtRGFgViY+m/v3+KAg14TeqM5JLlmKT9ZSOmifUzkaUotctVGs12KO+2OK+QH04ouT
	7MPdr24mr
X-Received: by 2002:a05:7022:eb44:10b0:154:dc96:c1d8 with SMTP id a92af1059eb24-1ac56c9fda4mr19080291c88.2.1793699658098;
        Tue, 03 Nov 2026 01:54:18 -0800 (PST)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:9e8b:5db3:accd:585c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm44178383c88.12.2026.11.03.01.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:54:17 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next 5/5] wifi: rtlwifi: rtl8192d: let the firmware use all rates
Date: Tue,  3 Nov 2026 17:52:54 +0800
Message-ID: <20261103095256.949327-6-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103095256.949327-1-hjf3108@gmail.com>
References: <20261103095256.949327-1-hjf3108@gmail.com>
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

The rate mask is chosen based on rssi_level, however rssi_level
is always 0, since:
- for rtl8192de, call to rtl92d_dm_refresh_rate_adaptive_mask is
  commented out and function is not implemented
- for rtl8192du, it is also not called.

This makes the branch always choose less than optimal allowed MCS rates.
Enable all the rates.

Test results (2.4 GHz):
   before after
TX 6.4    12.6
RX 32.0   39.1

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192d/hw_common.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
index cfefbe86380fbc..0c921c049b5178 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
@@ -903,7 +903,7 @@ static void rtl92d_update_hal_rate_mask(struct ieee80211_hw *hw,
 		else if (rssi_level == 2)
 			ratr_bitmap &= 0x00000ff0;
 		else
-			ratr_bitmap &= 0x00000ff5;
+			ratr_bitmap &= 0x00000fff;
 		break;
 	case WIRELESS_MODE_A:
 		ratr_index = RATR_INX_WIRELESS_G;
@@ -922,7 +922,7 @@ static void rtl92d_update_hal_rate_mask(struct ieee80211_hw *hw,
 			else if (rssi_level == 2)
 				ratr_bitmap &= 0x0007f000;
 			else
-				ratr_bitmap &= 0x0007f005;
+				ratr_bitmap &= 0x000fffff;
 		} else {
 			if (rtlphy->rf_type == RF_1T2R ||
 			    rtlphy->rf_type == RF_1T1R) {
@@ -932,14 +932,14 @@ static void rtl92d_update_hal_rate_mask(struct ieee80211_hw *hw,
 					else if (rssi_level == 2)
 						ratr_bitmap &= 0x000ff000;
 					else
-						ratr_bitmap &= 0x000ff015;
+						ratr_bitmap &= 0x000fffff;
 				} else {
 					if (rssi_level == 1)
 						ratr_bitmap &= 0x000f0000;
 					else if (rssi_level == 2)
 						ratr_bitmap &= 0x000ff000;
 					else
-						ratr_bitmap &= 0x000ff005;
+						ratr_bitmap &= 0x000fffff;
 				}
 			} else {
 				if (curtxbw_40mhz) {
@@ -948,14 +948,14 @@ static void rtl92d_update_hal_rate_mask(struct ieee80211_hw *hw,
 					else if (rssi_level == 2)
 						ratr_bitmap &= 0x0f0ff000;
 					else
-						ratr_bitmap &= 0x0f0ff015;
+						ratr_bitmap &= 0x0fffffff;
 				} else {
 					if (rssi_level == 1)
 						ratr_bitmap &= 0x0f0f0000;
 					else if (rssi_level == 2)
 						ratr_bitmap &= 0x0f0ff000;
 					else
-						ratr_bitmap &= 0x0f0ff005;
+						ratr_bitmap &= 0x0fffffff;
 				}
 			}
 		}
-- 
2.53.0

