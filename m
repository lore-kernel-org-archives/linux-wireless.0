Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ED63B19C2
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788100320; cv=none; b=PaOypmiHiu/ay3usT6AMebZd0B+slhaga0TUMAunaP1ekRqhRthUXRMo7rMvWMYuTvkM+pPqJ1mqC4eosqaUXLXIWy1gOXrrrvObueYjvO3aJQ5YyZHv+yMl5E+apUj4O6XjIT+HZaXdyoAupvhQKQJTsFvMUvRz94EVJxtoJKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788100320; c=relaxed/simple;
	bh=ZhO7T/KODzJDH9cl+5s8l+N7oWrQNDZ9TakHn3UoRnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g98q6vS8hDUgGQlHoH6eR5dE0Xk3ANAFVm/Tlx/ltC7SvGxdfjhdAjwgAUzh/xa293AW9b4bgj4SsArHgTA1jtuO98QZ7dSPsROKpmELqceo5+KsMWfO2Pp6eJVEeW6P8nspSY1glngeDcC7uP5yR033Fc3px8Ax5y2JISiY5Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dhx4dOxF; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dhx4dOxF"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so18723475e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 07:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788100316; x=1788705116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VqL3m/kWUFx3apMB9seIB00v+GAfFyrKKdC2EF4QFnE=;
        b=Dhx4dOxFASuOzXQBZySlEPLrhh0TDBHK5M6tqyEuEFByyzZAmgWbCyWGxoiX2UP9ZM
         2dA7cgtOm4R7uw1OubAHkCv7I1SNssjqmXrdcCJw3OaiYMalJfyQ16Qkbhwm6ofayJMj
         ekqwNdoSV/TsYq/H9sOe/KPBKcWmA8/2hsPffnQNStXiDeu6Rm92a4VIG33LxJUzoGxn
         dJsu6jNTR4Q0f43+cre9g5U+5B8EDcdhDRP//PSteDQlxUr4cYNWhJDxtYse54RWBhcK
         +FwTf9itGKFKtRuy7eibHFxFTTylQ63JgCCkQsUTEKf+Yhn5XgfZI9EVbea1N5epIeDA
         gboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788100316; x=1788705116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VqL3m/kWUFx3apMB9seIB00v+GAfFyrKKdC2EF4QFnE=;
        b=Hu9y8a+LftDU14lGISf+dI29mNaDNejrgEYeI6HDAZ/tyLER7RYMTxGcHzO5lCxIV2
         7dasKQBoEtH7ejMbRqOtOUaLk+dnRBhL5IGEDyscgGNX8b/rWVuKKddoOpli70srmNGD
         GzHKEx6oKnLgXH/LLyq6FYZ/JeEX5Yv9sfE/Yfs/FOYapBTxpcux3+YXRZAAv+uTCoDW
         plTjyg3QrlO7Ap1FIb0vP1L1Egk8JZdKiLrBu9jWUIXsViUWaR3MvM0F3jmf0K9dz4HS
         YzlW6MXSa5Lo+A6CmLPVAxIP+R2gx7y8b9Q0iNTWIlE7KVv4kwn2a9fckJzOf62NZgvM
         VQTQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro3a1s3+dy7wZuQs0XEov4kXWi0nKq5qkORLITKfQEx0NpzseCYuCNpYOey/F9SvNM+Pe1CQPhgFBJgFpbqww==@vger.kernel.org
X-Gm-Message-State: AFuF++k3fny8djIFKY23B9TwwDwMybGE6hpXBm2226jNCaehvuBs+cjF
	ItZ0D22w6leuWIiBlAb8R3KJ7NDJvaL2A4VBsbYFlvv1p+s51oyZqIE=
X-Gm-Gg: AR+sD12JHu79xvMUzxrYeX/1OwygGfPc77UKZlQ6K2KqntsUGcoCWahNay0av+CZsxO
	KKkT2yQe3VItN+9Qp1W3uXLZn/rSZ5tSWkfaZesXqJNB/0V8+jKSsjMKWVJ0Cabto4PZOVjULUD
	qMVsHra/UznlEFhu+GWObnsCkWsRr8Q3wRJc0Wy99yAf3T5F+QpWwxw4GGiC/H+KyETe3h8qpr2
	X4+TQAlcIWUZSqmDR6hMr0ihxPbrL1Ddbrvd89Y4p5SWUDmsGR8JgKM6chcXWS+t41hfHsUo/fP
	XJ9zanweqfvNoPYMR90inElXAKVy1JgxU+fugu9hUx5HeKWjYs+j2LALOEf7NLW+XiJXqNxqlQl
	8ENuXzHjU1DYi4WzxkcQIctbILaFS+juNaR5ucgAALSDTZh3lw20/S7BWThTsJh5fzWAfZ4dbNV
	XfcOmAzp3lbEvDTQMO04DpsYDCGytUgA==
X-Received: by 2002:a05:600c:4715:b0:499:cd34:f7c with SMTP id 5b1f17b1804b1-49b91c26a01mr291541505e9.5.1788100315529;
        Sun, 30 Aug 2026 07:31:55 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccae954f9sm146319065e9.13.2026.08.30.07.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 07:31:54 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Po-Hao Huang <phhuang@realtek.com>,
	Chin-Yen Lee <timlee@realtek.com>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 1/2] wifi: rtw89: fix OOB read in rtw89_core_cancel_6ghz_probe_tx()
Date: Sun, 30 Aug 2026 14:31:52 +0000
Message-ID: <20260830143154.1751910-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

rtw89_core_cancel_6ghz_probe_tx() computes a pointer to the IE area
with

    ies = mgmt->u.beacon.variable;

and then passes skb->len as the IE data length to cfg80211_find_ie():

    ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, skb->len);

skb->len is the total frame length, not the length of the IE portion.
The IEs start at offset 36 (24-byte header + 12-byte fixed fields), so
the correct IE length is skb->len minus that offset.  Passing the full
frame length causes cfg80211_find_ie() to walk up to 36 bytes past the
end of the skb data buffer, triggering a slab-out-of-bounds read.

Additionally, the function does not verify that the frame is long enough
to contain the fixed beacon/probe-response fields before computing the
IE pointer.

Fix by returning early when skb->len is shorter than the variable-IE
offset, and pass the correct IE data length to cfg80211_find_ie().

Fixes: c6aa9a9c4725 ("wifi: rtw89: add RNR support for 6 GHz scan")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 68dad6090f87e..7b46715ea12db 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2532,9 +2532,11 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	size_t hdr_len = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	struct list_head *pkt_list = rtwdev->scan_info.pkt_list;
 	struct rtw89_pktofld_info *info;
 	const u8 *ies = mgmt->u.beacon.variable, *ssid_ie;
+	size_t ie_len;
 	bool queue_work = false;
 
 	if (rx_status->band != NL80211_BAND_6GHZ)
@@ -2545,7 +2547,12 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 		return;
 	}
 
-	ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, skb->len);
+	if (skb->len < hdr_len)
+		return;
+
+	ie_len = skb->len - hdr_len;
+
+	ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, ie_len);
 
 	list_for_each_entry(info, &pkt_list[NL80211_BAND_6GHZ], list) {
 		if (ether_addr_equal(info->bssid, mgmt->bssid)) {
-- 
2.47.3

