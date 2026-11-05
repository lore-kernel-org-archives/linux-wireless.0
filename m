Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854578;
	b=TU8k8rhj3ZmnO2XhBHhOVu2wHTjpgzjmovtR/ieSEVmdV5xKlftv+0YiL2GlwLOrEkJv
	 PONk37l6Eem4XMXWZqyTCjMJxZga1TlqUu2U+ebufPaOEYe2E44PEzyLI+f6SeHpg9iJi
	 M9EzHPKhOobyGg/Y+FaYi+3gtdsijzoOonhNnZS3nbeJXnOPoIBmxdivUTbPk1RgGCorF
	 ZHH1bCG65GlVZBy8hzjsbcxBO1MsMGnJwqS05yNqiSap6oBKjQ0eNPHAIBYT6zqRKZzSD
	 T5A/2d2qF21QrE+BHC6Dy+k3f4xAz+/0c1kqvIaSYlZ4dihFLKbmDmDhsfKVQr3DH1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/FvJ2N4RGKnQJ3jXcrpsYNt4wnVSvOY4yLdo05CNbJo=;
	b=YZmvxqnqsCHs3fyXf1CB9is3IS6D4PWbIo7Q8dmuXNVALzVybaAj60YGTl2YNfz/pumg
	 kgvxwbqTzRwKNDDaRjiymypdykGygZz+JWLEkjfVzAuT+JiGn4JmknFOggGeFiNZ1jrk2
	 Xz+id1FV/R3jDDJYHUuqa+p5G0EsfVL1O8TZsITyqOnVnYoQ+S8lnDu75c3bokqJaLCbM
	 kBqQzDH/fvTonlTejgiba90NSxRq9hZruCpZARvI+o8Ag3crVjOxeULHtEsAU0l++qau6
	 TorOqaxNOy1ojk325dQLyYjGj+byX+N4toNB+HJg7OWSjH47uKGpaD1CErYeSsenRXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+eTEHl8;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0201A606A328
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 04:56:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0201A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+eTEHl8
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so1118346a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 20:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793854577; x=1794459377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/FvJ2N4RGKnQJ3jXcrpsYNt4wnVSvOY4yLdo05CNbJo=;
        b=S+eTEHl8fAt05fzkYtHIqUnNrJYgWvbg2+slq5ZBQ1+kV8MBO8+o6roHSk9vX3S7ep
         A5bcQacUgNRsA9y/As5uKYio0inPkUKXpY+Kp8ey6D6TMeixWVhXkNlI5d7ArTwLGddf
         kZeNrtdeQnhtDvkoKEur/45/S9odaU6rO+RQqygctn7KVt2+MoqbGS+KPxqpXUyt5mFg
         46THEQa5Di/GVxmCkYt72cZVDAqYtfxULAIsMeXzn2CQyYXpHYsC1s7KGekM6usjIPvp
         CLy2EUOIWPf0eioIKoi7if5WDzfP5YH81FXQTPeXdwQb2R14YoYzh7CnBuI5rwyaPT2j
         OkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854577; x=1794459377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/FvJ2N4RGKnQJ3jXcrpsYNt4wnVSvOY4yLdo05CNbJo=;
        b=Crz+gJGkDkSKi28zP2BysdJPUViQFqDSzZ7/e4kS8XdLMLP5lyOYBLYukWhFnefm+k
         x2pbacq1NKo1c6C77EDR5w2qSntXoHomzEI4GX7XI5z6dELzOYP8hFvyXboGscSXyRay
         p1PcPiU7CVecjjn5lAT72tPTGXvbgAq7FZHlWQGD8WS3I+sp3PoDWzK/Km0G4n4gnu1K
         AW8vtcbK0B2kPKBAKnyk5nUvc0tefsdqgk3VC5mEK58wS9gAWWOC9DQvxesaQdnoRlwY
         OYIyU78nD9Rm39F+TslBGuAslKuXoeE6QR0aGz2Tmho+m+sdUZ1BbJN51ZJOcCs27QsD
         FT+g==
X-Gm-Message-State: APuU4Z9imud3BboND0cF9UBxfmgAyPKoiF3Sijjkd6FFSRlEhmQJTa2+
	Q7ld9V3rL8kB/LHppCdzTzccXgKZ2GZtQA2teKqqavjuO2iPihqUmJry
X-Gm-Gg: AYBFou0Mtm7SBL1XpiZL8ScbAIav/eOQRxSFe0X4rdD8C1g0BVUU3JkuH5GzxkLmBwl
	AKqH4pU/eaAI++1AVi/NGu7Nr8UtrgpBShbrp6244UKja+53bn1qHFM+kJVwnUtoWxIcJBzLUsP
	5gnRS81ZSItzXycqsbh7AqLOGcRtqMQZJNjbBDPOBkpcoOsUmaKDjydII3HUgZKWqflLqgbi5Ss
	fNrvKtol3SypIWRguGXlG7bq8EkW/AXx5mbdAJJ88mTLGzkOzRGlaJ/CNvjX/qysF0i4mKxFCwj
	mxkGJ/8KdoqsVdER9EhqChOhH2aQYH2PF/GE4hVIU0ucn+AADboNye0j+tPP5iC/kq888PAl+o2
	zXLHaCryaJ4ntH7YhRozmA/NkCH32RqArVUa+s3N6vHSA3jPnnH7d+29xvsjHWOkQln3cT/+w+B
	8bEXGn1KXp19iPl9BS5ZuccCR5Oi+YP6nH+YdTLJiPXsUX9HmBYG2V/NjYldY2pjTs6nHrO0jxP
	tUYrE7b8Z1bRXjTsHBwMBeysBN7Fq3TOVrbPD8RvSOwnfX86JxCulQHyz4eluqoeihxdvADA+sX
	60GBGZL1j3LQshRMKXicq9CfDsy/jzpV1gaBUgwVW3yGXkC6
X-Received: by 2002:a17:90b:5147:b0:3ac:b3e5:428f with SMTP id 98e67ed59e1d1-3ae897ce445mr16219107a91.53.1793854577220;
        Wed, 04 Nov 2026 20:56:17 -0800 (PST)
Received: from hj.. ([163.239.22.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323cd47sm1783704a91.6.2026.11.04.20.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:56:16 -0800 (PST)
From: HyunjungKo <hj351016@gmail.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	HyunjungKo <hj351016@gmail.com>
Subject: [PATCH] wifi: ipw2200: cancel qos_activate work on device removal
Date: Thu,  5 Nov 2026 13:55:49 +0900
Message-ID: <20261105045549.1287413-1-hj351016@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ipw_priv::qos_activate (handler ipw_bg_qos_activate) is scheduled on the
system workqueue from the QoS association/probe-response paths
(ipw_qos_association_resp(), ipw_handle_assoc_response()) via
schedule_work(&priv->qos_activate).

ipw_pci_remove() cancels ~two dozen other priv works with
cancel_work_sync()/cancel_delayed_work_sync() (associate, disassociate,
scan, rf_kill, roam, link_up/down, led_*, merge_networks, ...) but never
cancels qos_activate. The driver has no private workqueue, so the work
runs on the system workqueue and is not drained by any destroy_workqueue()
at teardown either.

If a qos_activate work is still pending when the device is removed,
ipw_pci_remove() goes on to free_irq(), free the libipw/netdev and
kfree(priv); the worker then dereferences the freed priv
(ipw_bg_qos_activate(): priv->mutex, priv->status, priv->assoc_network ->
ipw_qos_activate()) = use-after-free.

Cancel qos_activate alongside the other works in ipw_pci_remove(). The
handler takes priv->mutex and does not reschedule qos_activate, and this
cancel is not performed under priv->mutex, so cancel_work_sync() neither
deadlocks nor races a re-arm.

Found by code review; not reproduced. Trigger needs a QoS
association/probe-response frame racing device unbind. Same class as
commit (atm: fore200e) "fix use-after-free in tasklets during device
removal" and CVE-2024-27052 (wifi: rtl8xxxu): a teardown path that omits
cancelling an async callback racing the object free.

Signed-off-by: HyunjungKo <hj351016@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11786,5 +11786,6 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&priv->led_link_off);
 	cancel_delayed_work_sync(&priv->led_act_off);
 	cancel_work_sync(&priv->merge_networks);
+	cancel_work_sync(&priv->qos_activate);

 	/* Free MAC hash list for ADHOC */
--
2.43.0
