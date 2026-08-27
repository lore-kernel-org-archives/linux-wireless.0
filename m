Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01D12DE70D
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809817; cv=none; b=Qz/wCWuZpRbNh/E1p2UB9MkphBnBBtjfDoro5WpYz2+dyL5HHWogKY1qnDPVqMSZfCLeKl+qkIYq83oaw6X3AkppIzM9mb1KX5XbICaOfdZeHalByPNh2t247LRhv5Kx4c1mcu2MEY2iqIdjHbfG95ut494KF5nJZuT0MaLMqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809817; c=relaxed/simple;
	bh=nMDUhOJVTinmcnk6gdNQyNcxwtnvBXS/Fh5wyqnPzt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tc1QRBwSoePyq4u/j04sljXnv7TUlXBNaF5bqGTPGcywImdzWGHmj2fp3nm7nSkISBIHQ3YRqaIS3d3BqFhLHzoUzMzqSFSmNwnAGRGqirIHykxG152pvmGh1xjoSYV5pLYdixCCo7o2Gq19mF4qE5Xpxw0NSlqQ5/rPy9XTA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=wglZLSw4; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="wglZLSw4"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso1505412b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809815; x=1788414615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nNMebGSZAQh2P0DsjJGP5MtdlAPelKFLwDmulJaEQpE=;
        b=wglZLSw4VobV2cKZXrfZLQKj83F2KWyZylRgiZYotg8NlHk1fbVFUi4YSs/v4FwbYl
         INF7IZ0PA4EjmikeJVD9t9t8NVw4Ze0IF+7f/iWE9kSlZHAXxzKjcfVY5Nh3dkzbgCkz
         TT2B4rgtyhadWvddc4/H4zB3PP4/7K4TaJaI/uuUyjmoijOLYlEGFItxXr6mD8r5/iiw
         prLOQIaIoE2zcj+eVHxHhhEGr/PxTtLX7lD4+E4k7puSJSlWl9i9larmqgTPHFIpbY4D
         sIRsx/LyMz/15U1/fss8tELInN/8F3IZyUxt/RZnVsK1UDicG/39v0EP/83jCNqZNp8o
         4bFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809815; x=1788414615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nNMebGSZAQh2P0DsjJGP5MtdlAPelKFLwDmulJaEQpE=;
        b=Gd8G9yQ4GlUJ0TedylhgZPBLYKrH+Ezh78os+qlKH/RjKTuXqyLPMpPAEdK9cYWkBn
         v8QrNx7+dVjN1aKYEl5miqIZCRU/Ay/jFcptI/SKYALj54Yx/EKPSiC+FRXIKXRtH64K
         kT3npp8/JIOLR8Kmf2USOJEyIqkKpijM4MikTBSDtA9qa/7KFSAxFcKGYf6ryEj+7FkL
         D9rarjVppSMB6K9iC+fDH+EkRrYNbsmyvn+lddfR+oxlw9cwt6dejw32Uf33gZ4trcGa
         MNn61GS4DlPcwUJXb6H+KXHnC7wJ3EiNB3Ntq9MOHWHtsvePWX+t/RG9PBcjE1/3A/TE
         AKmA==
X-Gm-Message-State: AFuF++ndxrhWlczV72PP3BNAMZOcsZfwZc+oQgv/+kNA+pGD0vDddsOZ
	OCQaB4YAvv1FUjQP6TydcjZ5sY0IF9mlDWmO8g+HU/Io+B+ya1L53QuFk+Svj66WO6o=
X-Gm-Gg: AR+sD11+eurslY7zw595rjOxmltgH3EpsHIlmDsTxTnTiGsnoEQdNKQvkUUiDJVZ3Y+
	GkfTuYfxtgDxdFu4uq6x0krNYiPPcIqjnvLJ1VFPuy2NIRuPOJGFhKfVl/ZgKz2hTvY0GFnTAqp
	fZI+rfLKfzs3wkX/JF5Rzz6x367AASVRa2bCYzK9CReXT7mJKT0bBUPs79k9dLB+DFj8K0gwZlz
	YJIG8mwZ3jhqoHIWlDWLO7SuxizU7+aWwOnqTuhicdxrADD8onkuOcLWSCxZclj+RSwDxDkRV42
	9pkj9QX1KT91IIRGDXK2F2/+eXs2H5XDqpIOPLrLoVDnDGZXwcGyu8UeaXz2eURw0F2KKtzcOM5
	1EJu4KxywjKtaRu2yRacGaZTgdsePiVdnmWM1pP63Ba7AdTY+3nE5qOdAwR3iHdGLQcVkqAWgWt
	rNY56LVqXeT5/3nPq/AhAXTbI94Xdjkyvx/9WTqgf/vDJ+wGJRyE+Wx9GCFDtSOPkeajxki1kVg
	+xRzZslSCfY4vLp2w9TXmPfxmh3iRldhsXHeoG7nJpS4647/pR2dDWxmcYVznu3b0yF+zZ8XDv0
	zlVRDrfLHTs=
X-Received: by 2002:a05:6a21:898e:b0:3d1:60d3:99f8 with SMTP id adf61e73a8af0-3d160d3ce78mr4255687637.5.1787809815053;
        Wed, 26 Aug 2026 22:50:15 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:14 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 3/8] wifi: mm81x: do not drop PS filtered frames in AP mode
Date: Thu, 27 Aug 2026 15:49:12 +1000
Message-ID: <20260827054917.255584-4-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
References: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the firmware reports a frame as filtered because the station has
entered power save, the AP-mode path dropped the frame and returned
"handled". In AP mode mac80211 owns the per-station power-save
re-buffering, so the frame must instead be reported with
IEEE80211_TX_STAT_TX_FILTERED and left for mac80211 to re-queue once
the station wakes.

Return false for AP interfaces so the tx-status path flags the frame as
filtered rather than silently dropping it.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/skbq.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/skbq.c b/drivers/net/wireless/morsemicro/mm81x/skbq.c
index 25655bd56d14..3bf15e7c38d8 100644
--- a/drivers/net/wireless/morsemicro/mm81x/skbq.c
+++ b/drivers/net/wireless/morsemicro/mm81x/skbq.c
@@ -231,10 +231,9 @@ static bool mm81x_tx_h_is_ps_filtered(struct mm81x_skbq *mq,
 	WARN_ON_ONCE(!(le32_to_cpu(tx_sts->flags) &
 		       MM81X_TX_STATUS_FLAGS_PS_FILTERED));
 
-	if (vif->type == NL80211_IFTYPE_AP) {
-		__mm81x_skbq_drop_pending_skb(mq, skb);
-		return true;
-	}
+	/* mac80211 buffers frames in AP mode */
+	if (vif->type == NL80211_IFTYPE_AP)
+		return false;
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		mm81x_skbq_insert_pending(mq, skb, tx_sts->pkt_id);
-- 
2.43.0

