Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F2228BAB9
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 00:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790382195; cv=none; b=ndHLvNDkP8ORqGCPoLgWWG3TijpqYbm6FWi3bZHxn+MlSGo3El5odUglhMWWqFYJZ30N96AlsraMHydZ+b0e/BBhsPIEht7Y+tDWwuJxnfEiTGjvF4WF7kNNUw95arwogql3FIUX2Q/ZuxWHkNKxBOuAW3VG8gq+0T3bKjF6HZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790382195; c=relaxed/simple;
	bh=YkLt3pwW8wTRXXoKWYw6RnJA8o+O9ilGAZICALlkytg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CKVZlEhEdpnNThyMSJcqZuZ8cbjZvDeRI+rI/186kTU9vMlpPATlYzpjnPdUdtJcN+OXp7CshiIrf9a84sT23h7E95cwAyCPSEwTZxmme+SbjpuGquKfhboIr/Av3yVAePVIJtZgoX6P1rT7RMJ+OLAFSndiWpueQDFPysI7yIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Dx74PtbJ; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Dx74PtbJ"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3429bca3880so678523eec.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 17:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790382193; x=1790986993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CqukwQkSLk0aj4isiu0ObgzItwxW1NrXrIMOeRiNUQs=;
        b=Dx74PtbJ6RcbfRdXs0ldelMSsBHcA7+qmRWaBMZIiUzqB+pGWB8Qw9iRmcC1Sw0CYR
         7G7rexzj8KbD3A4QdvnJnqP82Le1BWiKoecFaT+7eXifQKVY+B6GQe1dqMNUVJWGz4Cl
         LPdAFbyyqGaT1D/6BhroerVZUxq8FazFRS0+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790382193; x=1790986993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CqukwQkSLk0aj4isiu0ObgzItwxW1NrXrIMOeRiNUQs=;
        b=o/59bHLsjZmOQKHTsDOgQKC+jBB7S0ba4RxjxZZPxWvl1lzOHEX4RofjhiBMr2jeb3
         R6uifJ9SAoWmkWQqmbEmGWcMuYgAeV9hRgEt0t61bndGIVeXwGff1ozm8ZkDPLNpY/9E
         uKEK38kEyDGVmIUhh/its7HgoFGopFZUrpBrPrz33xTFJcWSZNP9AU/yfO+zSadKO43+
         trov5KDhYC8iwb1dzdwrPJrXH7zd3GwuCn+e1T2O2Gpr0DhB/mYDCnqu+CRjOmqv+xAs
         SZhA62xUwz8a678of/TTA304k5unb+zlGUp0QnTfVRX8ifq8CvL3ZQpRM7C22Rj2ka7t
         uZHQ==
X-Gm-Message-State: AFuF++kHfKkG78ARK+qGbBRGtdLbIj/bMm9siOsR6ZaKQ9l5xs08coHY
	XmX7VMggJT5Q1Ohh0lC8EBgiynFRcKdRjZCT7foYrvIOaYCWoCx+tQoDa94ieJVRnoonJcaRUcC
	mKHQ=
X-Gm-Gg: AYBFou1/EUbcR3xYVPtephVR1KsFCLy9rUwB/dS6OTzAmp61w3qw9nacM+4sE6j4Pnb
	OXkPEFBw+UXD2SMlW7qbVqEhNTCnZ7rer1lqRSRbPJ0pHDCj7CstvNXMEiNk8EiraMwjS8/u0AN
	5P4JaJtW9ICFd4B6wEXBoAOqPwpGCnW6k4e115nay5I8OhNIp0olC5kL2m7h3siQSczazGvqdLr
	QKC0g8oGMQA6ot0DBeNS1TGvmtrEqQzVQi1ezhXSwulxcBgZR6IduJuswsZ+9t98PzHlL/snwsw
	ur9oK+2T4rDyr6ngg2dR83/UKZ+9szCsQyMjLgcCnm37ojzDQFjBSHk0sUbamcvCw2+7Cd5CAef
	V4AhEFm/feSSU4TgHUBrwTxDOgE8KPe/da25YM5mEW8XldammAfISuamiWwep44g77dDhISj25e
	cTU3Fe+3U7FiZgU7a3r6WwX7ixfSmbGxL4KuEb/2e/RRhM9AaIddezxNPuJnnzGRkO5SkQWYzvT
	MqGrG5ohPXVUYuZv8iGM5ZJpAjYx1GJUxZCdQ==
X-Received: by 2002:a05:7022:d43:b0:143:26eb:18ea with SMTP id a92af1059eb24-146d00b7b89mr1524721c88.29.1790382193104;
        Fri, 25 Sep 2026 17:23:13 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:41fb:1648:4395:5cc4])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-145ad8e43d2sm9497733c88.12.2026.09.25.17.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 17:23:12 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Francesco Dolcini <francesco@dolcini.it>,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH] wifi: mwifiex: Reattach interfaces on suspend failure
Date: Fri, 25 Sep 2026 17:22:18 -0700
Message-ID: <20260925172218.1.Ie4146d413a6be79caa11cf34e19b23f514ad3f5e@changeid>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If our .suspend() fails, we forget to unwind the early steps -- namely,
re-attaching our network interfaces. This commonly occurs if, for
example, we fail to program WoWLAN patterns to the device. Without this,
the interface won't work again.

Tested on a Rockchip RK3399 Gru/Kevin Chromebook, with Marvell 8997
PCIe WLAN.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This bug has existed for a very long time. I couldn't pick an easy "Fixes"
target, so I didn't bother.

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index d7f20ec0bb3e..2fc092635e10 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3562,6 +3562,14 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		mwifiex_dbg(adapter, ERROR, "Failed to set HS params\n");
 
 done:
+	if (ret) {
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (priv->netdev)
+				netif_device_attach(priv->netdev);
+		}
+	}
+
 	sta_priv->scan_aborting = false;
 	return ret;
 }
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

