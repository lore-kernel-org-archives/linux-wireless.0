Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAA14DE718
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 21:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792357336; cv=none; b=G7iIJBBwGzsrVPeb/JXmtrmnUEwKS7znIyMHEXm6mKhpvQeBBjXzIHRN/MmdepPDn705ZuPhexI0ScssmIk7lh7BAGMMwJzjd8od0M0oetFJQMEhWnWzqgfzmCg0blLYTU96USVPc7sayCG4g4goYxG46C+5evq+aBf5V7d4OcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792357336; c=relaxed/simple;
	bh=Bh0G+GiW7IdzC2VLw1OK+qEnICaHtllRiw1SW8B4yCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q18bSommpTb0tp5eh54qwbcVfQsWVZijPwE+OWGfU+ZdeU6h35Xys1wt+Ngd9oFuwcL0XxhCoBdeymURMwLJVLLVanRK450wqFW+BIZffSAFqcfFC7Am0lwIUZA8UNZ4J2TCBnOmghzbCZH0s6ucBtLFoPMYSpooLUM+EdJOA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=na0wPMid; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="na0wPMid"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso4357567a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 14:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792357327; x=1792962127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gp82D46O8wvY4gHZCDROdmv/VEli/DkrbpYd3Iw4T+M=;
        b=na0wPMidcfaG1z09rGfd8M+tncj+amL6W9WXqXFVF6OWIUkmGgxWg3ri1Gl+SrE2Vl
         uzn9EqU/RWoQ3IZ5e84xO+LXQ/nHJsd0tYuTlcj4Hg+qcua2RmovQdDDuOkyCtQZ0ly1
         S+j5V5gOMSGh9I86gt50GmThMZKFji6tNY3GyshApwhvLGlK6y8SSNNA4T/xk+W9i17K
         2i1KEykW2FtwUh6wCBTSb8HIe9mwpHKVkXSrIjF2DoB/BpNZTMjAcMORpUPA64TRswfS
         PRMQ1MnMGbFIDRgcEnM7DBjLTLlWHHWx/s+avGuiEAse24zPXzoT9rz/YFhsI7FlEkC3
         kpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357327; x=1792962127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gp82D46O8wvY4gHZCDROdmv/VEli/DkrbpYd3Iw4T+M=;
        b=fuiiBHl9C5rwdhEi3tfkql6H+5rv42hAIgJTUgAUpBg13ZZvvymygEd5naDnb3L6Ak
         ZoUsUKQ7vTgKJN24Aeg9ROhzLnmBIEemTcPS8xp+VMPehohWtCc90ndWbcb1JXgmvlpG
         +m9hOV2iG7Txtl6WivFrHcVg85UMQuK/zFftD+uPj5/HWzjCJNy59jLjwaejxABWPOv0
         XOOUgkZr8C6dlNoF9lWnBKvDC2dMmqWDm/0ABpKaoF8TizuaAM7GidTz3ktfpGvIlwKv
         bN7oRb64tyVDrbS/EsGgOYCJrIxbdEj9flD8PhPBzyMP7D9I++aXfYIcUyzmDIoaRqnY
         9gJw==
X-Forwarded-Encrypted: i=1; AKwUvBzPdgia41zB5U5mDKCe77WW26w7MbWZa8TKrdaRav1ihx5L5tUVIz1g+F1VQgPTDinttRo1Lvu3K9CT9tvxLg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK1u3m1aCi9oxRkreU3DvzsrvDO93qLSlL4XHjaUwT+o6V2N+gq
	rjWz8AU2BJBe/HsHIKbyNxegYZcI8i5pE3JUiY6HizQxBuxVkPlyeGgePf8NkCxHNg==
X-Gm-Gg: AYBFou1OFn7IBJadd60hf/WWzQr3y/8Khx6asxXUcaAZHfJ3BaLJFZCGkaR0zDLfruM
	I6dC0r8spAd3czRiXhbvGp884zD1GzDrG6FVYYkIm1hl/ZwdHWpDp0YvRy7AclvK+1v9Wj0NxPD
	aaTpaHJviZcgMZGHVN5LfrU+qGl1y8bo/xfg1yb7gHA1oiCYy17T+IOky5eCiJKwWBQkGt9SXHx
	x1opYI9C31X4iAuc32ttdviDt0gT4A/zzqvm6LXu5S0JFyoISqDvbkZLhBSF/aoq9uynD4ydB9P
	KvwOazdCn232NMcxgJMBRAdYO6iCjhOt0SL+kiimV3bWWcbRXtLhWig0blevgWYnhlRJZWOxGRq
	aA5Hy8LVPp5HXqYv49+6JiKqf6l+FR8FRUWw8yeWhBDV3La1sQPPVrW+r475oRDxFXHgjtA4cCb
	QwyQRnpreoLLR2n+z9KjF1WiDyvfku81zbnQp0M7fsomA+N8g2Fvqr1ZAPxzhHDXoYrVTQcMQQD
	/OhSogq+1/M38wl5T4uTwWr6GUkRMtFe4oZyniOmoG0ZpP0X3WsGXSiO4Srr+zOgweDg8RXZ+pU
	HDzwetDrcuDRJSt8uMYpxI+koTJqjbUZX7sKqmDL4OiEHKZKD0+aJ0yTbqRRNfXqJPT/NHNzVBT
	SOYoz11HvoVS8h/UzZJmh5pqMKPEtYfN/lq/VJwqbwlRjrXiU8F/eUbSq3jZJvriQSZL2to4T0r
	AKtrIUgoBWt7JLsTU6Lws=
X-Received: by 2002:a17:907:d19:b0:c2d:c6e7:9e9a with SMTP id a640c23a62f3a-c419e23799cmr365428566b.11.1792357326420;
        Sun, 18 Oct 2026 14:02:06 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912cefd4sm291618666b.35.2026.10.18.14.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 14:02:05 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: [PATCH ath-next v2 5/5] wifi: ath11k: hold back WMI commands while the firmware restarts
Date: Sun, 18 Oct 2026 23:01:53 +0200
Message-ID: <20261018210153.1925962-6-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018210153.1925962-1-julius@bairaktaris.de>
References: <20261018210153.1925962-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_core_restart() brings the firmware up outside mac80211's restart,
so cfg80211 operations keep sending WMI commands while the HTC services
reconnect and before the firmware reports ready. These commands crash
the restarting firmware again, and recovery then fails on the unified
ready timeout:

  ath11k c000000.wifi: failed to receive wmi unified ready event: -110
  ath11k c000000.wifi: failed to reconfigure driver on crash recovery

With iw setting the RTS threshold in a loop from the moment the firmware
stops, the firmware crashed 15, 15 and 11 times on three triggers
before recovery succeeded. With this patch it crashed once per trigger
(5 of 5).

Return -ESHUTDOWN for commands from outside the restart worker while
ATH11K_FLAG_RECOVERY is set. mac80211 replays the configuration when the
driver restarts the hardware.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 3d5b6605eace8..5c27e7057e6ad 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -312,6 +312,10 @@ int ath11k_wmi_cmd_send(struct ath11k_pdev_wmi *wmi, struct sk_buff *skb,
 
 	might_sleep();
 
+	if (test_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags) &&
+	    current_work() != &ab->restart_work)
+		return -ESHUTDOWN;
+
 	if (ab->hw_params.credit_flow) {
 		wait_event_timeout(wmi_ab->tx_credits_wq, ({
 			ret = ath11k_wmi_cmd_send_nowait(wmi, skb, cmd_id);
-- 
2.53.0

