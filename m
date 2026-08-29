Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E30118FC97
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 10:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787998548; cv=none; b=iMJplRhw1zgOlL0cp3gMcuZZE2kOVfycoFfj8/lBLvZtGvdaA1KqBK9EQ38/x2WXR8SRsdDXpbXo6phz1I9Be+dh0W4lIgblsMTjZ4fGBYaISaijhd8/1R74a7LV7UERg20J0FT4iOon/SrCQO/5YH0z+pVa8hDY2jQa+9EqbTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787998548; c=relaxed/simple;
	bh=KAZpAufm9mY4Vi7JaMtV/dylFfUr1203jvM1ywXIWX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f3T1NwYB5u7JmgNM0QYbIOYfFrhMv5mKD9cSgzR+zPh3FRQxn2eAAtSKanDqJ9m8ow7xyOhtJhvZ6DnAeR/QEeYLHYnozM5JDsDmsBKqicBMDCrEb+TioW9+mU0Y6X/eIL9PyV5nYHvmQeXtwqSxYZF3Ce5napYgLfvH/8HF+fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MPPojqJZ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPPojqJZ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso22520045e9.2
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 03:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787998545; x=1788603345; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7EdZa0g63zlpWXBiLsDvt8kChhkbnx7osFInxK6j0I0=;
        b=MPPojqJZysp4cM3WfSCRNLKhKlpmekp6eL8W5R9bJ4M8H8EYrMNBLkzr85OPukdumW
         OLRkWuIi8q06H5ft0xiCU/aatfulPD4PoEelxuCD4OP2OmOvHYj9jwsPd2Fxm1I341ns
         cEALyqHhFueFClG2Vz87ULz9e0EtXR69Unvw1JPjGmkz4XUVtMOWrDRO1KOdcdDaIWRL
         /1E5/wi8PaLyH+R6uH64qVWFeJGpp8uMU6sDrOo/QVhggsCJLq7Ldx2r4TGQ7dd8N05p
         MdzLbEB86z796egt5mMKhDRaLit17dNqn1XXKhKYlhWDovagzMI7p75CuslVOlGgeQhJ
         xWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787998545; x=1788603345;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7EdZa0g63zlpWXBiLsDvt8kChhkbnx7osFInxK6j0I0=;
        b=nrtW/EDaJNV5hFhdbQMTjoXyN47aAjd4pZTQHjlkaIcUDwoJ0DqE4wFRNaTmtzbULs
         sanxLZR4JvU06kfHe3N3Dn8UKalot/hboTGIUW0yEliNdElLFOQ0xE7qn2GPxzh777UI
         9vJxEHdhg9GxL5g2Nx/4k+oYVuzIB2f5jBNKI1BBw5uiNPq1JHn8oeJDAAiZ2E+FF+7K
         caxgnbELx9ejN2lWyGfprJnnvP6YI1bIXdPQRdW+6+ZUNoc2sYuQ9kpguRIgDxApuIBc
         TozLQvPi+fzaCfU9jEyqXDFJ5EvrG6BHLM50UzfjRdfv0MKcQ5pJuhY2KGKghyuhrOaU
         Jqzw==
X-Forwarded-Encrypted: i=1; AHgh+RopXMF7TYvC7zAOZXP7vZLVMywBOGCrCFPZcEGaIQPuB2+8EQWu7J8pMzU+SjZ2KKCoHdi331c5UIrJlVkaBQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nnfY0HPsYGYo/sfu+oXxn8x+WiCwPS4EMEo+ted3MQsDE8wYVW
	n8sFT4ldVr3Mma/eIN4h6AaQCVF/gjhqNGiucI+WM/f79HP9KkIG9aA=
X-Gm-Gg: AR+sD10D8q3/15UvTlHbKmXieD+rCx/V9RmgH3e1JQQJikL7SHxYWHgacmWmWe49Bo+
	GNqO5qRj9+oUbd/SU5O8fjrqMbAtMO4Labcv/fefSJg84rps8w7/z9LxLtoQxWFoO1olRMaoqdt
	KzNPxE0TH2lSeZGE+IAAUn+M+zy7BK9QQaVyCjfIhBLzvSgbE4v638lFdMhi7Lb1wKniZAu+wL/
	DlQ4sVQNNTpvZ2RfraK0WBAsJiIcbwbPqz/wFdmn2+cKf/8U1oSCRebJCoWYxE5A9RrO6cCIMJV
	dsX+cBtvH0WSfz+iOG5isj6/LRQI+eMft5L/DcrafTloCwktfaPAs0E76MI4cZ3bH4MmQdzt3FO
	FlMZ8/GATkUNj+FrRwTZGRwThacOKUQBRa9mfvEg7qaGFbYCi1+4IEtYk+yi6fmN+jbw4P1oy7+
	33iF5D0HLR1yh8Q/b1foVc5Ji9H1N5eseFzuf4gannpC3nMkPPwaB9jg7tWpacFlBt5Cin5Mrph
	ohfErm49DRj8bQlpn8jXyZaM7rQ8+WBrYqXWPyYaOdqd9+6mhhoFwRSYLCpgg4uljWE2M5T7Tdu
	sFrc
X-Received: by 2002:a05:600c:8b35:b0:499:7a19:408b with SMTP id 5b1f17b1804b1-49b91c3b71dmr194656745e9.11.1787998544573;
        Sat, 29 Aug 2026 03:15:44 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b95013d06sm166010555e9.12.2026.08.29.03.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 03:15:44 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: skip reconfiguration when the last emulated chanctx goes
Date: Sat, 29 Aug 2026 13:15:32 +0300
Message-ID: <20260829101532.1471682-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Drivers without native channel contexts get the emulated ops, and
ieee80211_emulate_remove_chanctx() reconfigures the hardware with no
context left, which ieee80211_calc_hw_conf_chan() turns into a channel
change to the default channel. A monitor-mode retune releases its
context before using the next one, so every retune costs the driver two
channel changes: one to the default channel and one to the channel that
was asked for. Nothing is on the air without a context and the next
context sets the channel, so drop that reconfiguration; the radar flag
is still cleared for the next configuration to carry.

On an AR9271 (ath9k_htc), where every channel change is a full reset
over USB, hopping across the 13 standard 2.4 GHz channels with an
unmodified driver showed 2006 drv_config CHANGE_CHANNEL calls for 1000
hops with the reconfiguration and 1006 without, a median hop of 123.5 ms
against 92.0 ms (p95 183 ms against 105 ms), and 99.1% against 98.3% of
injected frames delivered on a second card.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 net/mac80211/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59837b9f480..b3f9b3bc3cac 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -289,9 +289,14 @@ void ieee80211_emulate_remove_chanctx(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	/*
+	 * With no context left there is nothing to configure: nothing is on
+	 * the air, and the next context sets the channel. Parking the radio
+	 * on the default channel here only to move it again when the next
+	 * context is added costs drivers without native channel contexts a
+	 * full channel change per retune.
+	 */
 	local->hw.conf.radar_enabled = false;
-
-	_ieee80211_hw_conf_chan(local, NULL);
 }
 EXPORT_SYMBOL(ieee80211_emulate_remove_chanctx);
 

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.55.0

