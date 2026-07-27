Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4CA3BBFB1
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785134556; cv=none; b=MpZaRWjE+XMwwpZH1JHIodKTiF7HJyyooh59Tu+j9mTpJhwmCiMOC6nbo94tYXhuB8WDyRRlsoJ2QG8SPeSCkklGKjK3WzCb/akYNgK9LsNCgNyviUafwos0OBcTwneooOiRaGRMbqv9XFpKdNGnrU1DcM5oAp1G1+kZ4O3OQak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785134556; c=relaxed/simple;
	bh=+m0zdBu5/ts+2IyJqXW9aSlshtzUwb5CgVTjDsTkIKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DS63B1nhC11jBIzOMnlKziNlqYI76FBZCaHH58E1sK3USL23OfLjcn3dD8SLqRl1OWSyF4noA5yS8LMzbWhHouRUA4zht8UVlAeLRwL5URqEIYOvlk407eaevEO+2vdZrBA1qLB8zxD7gO7MPSe3/BA1cpFvFaifnscHjNNE8Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=yZEst0I5; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="yZEst0I5"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so2357936a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 23:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1785134552; x=1785739352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5IixglYEm7G+4GcyJJRAUCqerJmEAIojYlRmU2MgKqo=;
        b=yZEst0I55QkPDp2YFX7rg/eRYZHOA5RZXEYTAGvQv78sSwBInXIP3GOJckMSPzUbcv
         ng8uhfG+7DtM+6S159oFz5Pmd4CLvMeOUI/4EH+5F+7uiZAzugNUKFDI80/pWUqcXBVC
         8VsFjpQq40qnccnoKVmnGdlWhTXQ7Rs59nQ8Ai7CnDhRVFK2ymIO0bskAseDi1xAj5Yl
         DDKCBl749dYfrXumXoGKPwL4xAxFgU/LUEsGEzZ6M3LeiH7FcPtK7mC83kk4QgXm7kmO
         KDmKsRXOS+d6JtpJagCjINYbDHtLhb2c1XKs01tgUsGeSn93ypK0EmeDGT5U+WsFY/hg
         zmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785134552; x=1785739352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5IixglYEm7G+4GcyJJRAUCqerJmEAIojYlRmU2MgKqo=;
        b=YDrUkVg1lDbOrLVOohFALFxtl1K+fOgjgJcpn6AMWZft+G/8MR49UxUoiYixuA9av2
         Zb5N1HP8oy8+LBE94VY1QR5XuV1pPnS+biATQpbRcP76b1hGeKO582WKRWFbUCjLpRR9
         109Fpru7+z0T7hhCdauTfYaqwZxidlY1INPdgslxxKOQkr5d6LLGUxz8GLOBOKpdnNZd
         W2JobRjhYcvL0/XhZUPVSrPcImgqjPnkfhU6Jmma15lo3ShTyqoq1V5fq9wbLXW84JMf
         yf0zAIpUOqPS0chIIiUo74Jn7NKCT5QxAkPxLTTzv6k/BEjwy0JNNeubAZPPBvYyGjy0
         54dQ==
X-Forwarded-Encrypted: i=1; AHgh+RoHhIccWZj6M7OGdU8IiMqK3gQTiPmYQwXfrsF1jeapFJ/ycMQLUjfOdLgnUsYyr93P6mHLsH4jkaE7SsTVWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzG1CvZfccs26o9Lh0FyE7adVBvnkJYwOniZyBeJTKc8tjCqUCZ
	HGqasTBzXlqpu5VCNm0sh7Gu21c2jQlTh8rWVuO4J4rwHJkV3xag/MB5TF2kkhYKf2EPTLbsl/Q
	AgwXEuhc=
X-Gm-Gg: AR+sD11OTci67/RqLiKA9qHc35trWUD/3dKlysWPc8QnHUWEzrcKIps+AJa4hmtv7fY
	N+Kwg5DOyL8KJMx7GCp9JUsitjK/BYBoEH80+L7COmpNjbv8UraQ/AU3GqT1++D+TlUkzG0LtUu
	0bor2bq9Krie4vLPtl6EpOyj1TWWNrjw8K3arS0PLeDtc0Ddu8EtZ96So0UCPoAv+x5T+drNA9T
	x8kGyGzkasAPTAt1u0Jc2YyFfLVPTNh4HbmRmJwJ4L66Ug8nq2T/p2ZYnuNpaM4ftgRQ8+e8RPJ
	SUBnILwanf1ZGZibvG5ErXieyW+ZUIJAiVq5uW6HUGNp6iiHP0bgC/tsoe+pKwTRky2wUiFeJMS
	7H3De19iLXhu3K0hohmHXpigeb+/r6tAIMSClRNqs6Af75ZswFish0AhYHVlaiPjM8UWMovYAzr
	Yr9uSF0Kcj8QHLgc7XY39zK345na4m/IKeEYDpB32XNtfi6Kl1ikzP8HlBZDLvhG+edvnsV2231
	EbGigcRitHr43iLuxQuqp1O8MLDrO50
X-Received: by 2002:a05:6a20:a128:b0:3c3:89ce:b5bc with SMTP id adf61e73a8af0-3c67d9b3d98mr6944920637.15.1785134552562;
        Sun, 26 Jul 2026 23:42:32 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm29043443eec.29.2026.07.26.23.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 23:42:31 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: pkshih@realtek.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Mon, 27 Jul 2026 12:12:22 +0530
Message-ID: <20260727064223.61836-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The skb passed to the rtw_hci_tx_write() is expected to be freed when
the function fails, but the error path in rtw_txq_push_skb() does not
free the skb before returning. This can lead to a memory leak in
rtw_txq_push() where a dequeued skb is passed to rtw_txq_push_skb().

Fixes: aaab5d0e6737 ("rtw88: kick off TX packets once for higher efficiency")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis

 drivers/net/wireless/realtek/rtw88/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 9d747a060b98..8786bbb421c2 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -619,6 +619,7 @@ static int rtw_txq_push_skb(struct rtw_dev *rtwdev,
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	return 0;
-- 
2.43.0

