Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038554;
	b=jOOFI4gyKlQblcchrg47p0xQcPlNS8t1c+0oq4AcRrgdwM/+5K4sB1Ed5SLHZ6SvcWpj
	 kMNvqDbLoWUC/bBGsItIVvqj/3KYjjU14qLC3TuqLgKCsPV3jSH2gqLrk+m1RGCqFGz77
	 RUWsOas6mXHuW3hRISnwaLXsHmwItL82/4F17NLspulhB6+EhLePBnJabSCKCSCugx4Dd
	 V6CiSaSFnRrSrjfFw7FCGXqoQAHv8VVh3FNEnC9QTOyO0FW8BUTGlI8dkHKOZy6i0wrWf
	 DkoxN+dQJ/zOcYYGcquwNliCpQyHwY+9SQZqStehPfF353gazpsrOCR2VrH9UQajO7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038554;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IXiEUIeYZfm/Z+uDz/6gAhnO088xmqngV8ebCTTry2o=;
	b=tlIVE4bUJoPx0XqfUWFa02Kpkg0fRqk9IYFpPYDQMlGPbd7KTz7TVIgjJgI1Bv7pfVlv
	 Ea0D188Rx5eLZPo86SPD0HUVSCU7Jxm4Vmg1O6hzJs6v/jM4KkwFoHsGnT+qMS+qA01BR
	 6Av7VbuPzMvbPqd5kcfz4sjLvck3KJjrCrsRnCxEi8QMRlMXuoDFP/ner2nQFgZ7Wh4Wn
	 kuPoBoHVWoeLnYd9s9GTdmgw2tBpGbzFrSvuEIO84LYY3pbOiijoi2Qe4880vB2R76SMV
	 VL21h7aqLbdReB1rOAWKMA16YyT8jSeJgbVIhxF7ohAQjiqgBt/egN6zk4I1QT0eyQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SUdwMSY3;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA452606A331
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA452606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SUdwMSY3
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48df4f540ebso1648543f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038552; x=1793643352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IXiEUIeYZfm/Z+uDz/6gAhnO088xmqngV8ebCTTry2o=;
        b=SUdwMSY3OsO5FAk/vhbWTHl8t+7qOIbnjYarWYb43vB0bJmbQlzKmIymQQtfouzo2n
         DkK8vwRiGcPPGmjk9y2jnibiyWY6azo2FH0gm6cR2uotQt4VPcQq5pP3n9cuMQqCQzFf
         Xmnf7rT5ffY5oaVMAk+xgpoKUCbZb8MFXUO3g6HbclP7u9UGYucClJ3rQQWomGS+CBfM
         n0pQwUCeoNFIoHb79YnWLDU6kSrJMKfa0Sifj2TIl4fYrHANBn9yay8zqwDrSY9jTk9C
         x0JOAeiwSdYQgPV+s3IxH6WQhDGGt0GtpbEICfTACyD9pWPQO92S8PSIlIh9EVnjhVVh
         KNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038552; x=1793643352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IXiEUIeYZfm/Z+uDz/6gAhnO088xmqngV8ebCTTry2o=;
        b=nKhtV9evdluDYlaJpwbplB1O/K5tvfGMV2CTWV8HK5xfPZ7pxA1STpALW2qEKRR9Ry
         n+vxzMjxx2rJEzb/R79RgUJiZcZJFYBdl86COX5rjve2jpSr1yOFcuhfBKpuLHBRP9iB
         tA8YBPAn2pckXTWXYxy4CGlvqGsrGnVPdjeEElJFOtKCnXFbebs8gN4TEnIx7hUWSugt
         2gD4q+P4dhbJp2nJiGBIroxbbFHurBXzEGv+mYpV42QhhDU3OdGogouNuYfCEtb/lKv+
         iYXhhdoWy1/wR46dbCt7epidbU3TxGynV7lpznEknOBKIr+cMe5IHWUlxp63Lv/ul0ka
         cSdg==
X-Gm-Message-State: AFq9FYIAwmoI3sGeiwSa6mKfh7sRKUCYz4nFK/iF0/dy6LrNEwsb+2fA
	7NPxLQQDR5sRZOI7keDa1B/W1IZDNJg3fvUuZIswkrrDpWfw44F+/tthyVyC1dNp
X-Gm-Gg: AYBFou0xFXtYmUiKi07ZmmPK9HJQ6VupnBme4+sOPnvhoES4B7QX6vKW2YsUTZwboys
	U60KzGzA90zJsIKe4HTghzBhT8kOr+ixPzEfBlgb3PtcRSfd9s45b3HQrMIPfAkCltQbTVIfRFO
	nwVTgtIY47KydMP/otiaY+vtI2Ie3tHsVfOr5wc/rWi3frW59+TFKvysyjdAAnPbhYyUdXI/dgI
	dT8pOmGct+NxTq5QSWaexnRn1DqdFIjkWXwFn95ytYS88bKHqBkG/2po+LEU6EheNSWlfL3o4gQ
	GkqsKBQnwrO9Dhp4DPzJmouLdb1De2fZ5w41cJxk1bQJzzVNtmPdgGgisBDTmOSOwSDwGErZvOi
	jYx/3n+ciXeTnLTcHYeEozKGxM5gbtNlwA2Mgsa/0QkPy3ODI++qjYdYoCg4TA1VuyYmf+W9fv3
	QR2gG5S0CUsLclX7Wgp9Etg0ZlJn/FoUa5/fzvbjioOn2zmgrLRa7EgVwrUmYZZPGfbks6HT7tf
	ME57HcxE/GK2z1wpHv+2FbwUAZS/hbh8zrRdl+JpHtnTpsHDfu4TOuCwQfAecmF/pbprjKWfuQ8
	xM8G
X-Received: by 2002:a5d:5d10:0:b0:48b:1a0:5630 with SMTP id ffacd0b85a97d-48e3eb9e397mr12917817f8f.41.1793038552064;
        Mon, 26 Oct 2026 11:15:52 -0700 (PDT)
Received: from luca-HP-ProBook-650-G1.lan ([2001:b07:6454:c33e:6c42:b004:d90b:d191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20967847f8f.45.2026.10.26.11.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:15:51 -0700 (PDT)
From: Luca Casati <luk00casati@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com,
	b43-dev@lists.infradead.org,
	Luca Casati <luk00casati@gmail.com>
Subject: [PATCH wireless-next 3/5] b43: N-PHY: fix rev3+ RSSI calibration
Date: Mon, 26 Oct 2026 19:15:41 +0100
Message-ID: <20261026181543.77763-4-luk00casati@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
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

Three bugs in b43_nphy_rev3_rssi_cal():

- On rev7+ the selected VCM was written using the loop counter (8 after
  the search loop) instead of vcm_final; the 3-bit field turned that
  into VCM 0 on every rev7+ PHY.
- The distance used I*I + Q*I instead of I*I + Q*Q (brcmsmac
  wlc_phy_rssi_cal_nphy_rev3()).
- Negative W1/W2 offsets were rounded as -(abs(x + 4) / 8) instead of
  -((abs(x) + 4) / 8).

Found and fixed with the help of an AI coding assistant (Claude Opus 5.5),
by comparing mmiotraces of b43 and wl on the same card.

Signed-off-by: Luca Casati <luk00casati@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index cabf61870..44769dbb7 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -2167,7 +2167,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 				continue;
 			for (vcm = 0; vcm < 8; vcm++) {
 				currd = results[vcm][i] * results[vcm][i] +
-					results[vcm][i + 1] * results[vcm][i];
+					results[vcm][i + 1] * results[vcm][i + 1];
 				if (currd < mind) {
 					mind = currd;
 					minvcm = vcm;
@@ -2179,12 +2179,16 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 			results_min[i] = minpoll;
 		}
 
-		/* Select the best VCM */
+		/*
+		 * Select the best VCM. (This used to write the loop counter,
+		 * 8, which the 3-bit field turned into VCM 0 on every rev7+
+		 * PHY.)
+		 */
 		if (dev->phy.rev >= 7)
 			b43_radio_maskset(dev,
 					  core ? R2057_NB_MASTER_CORE1 :
 						 R2057_NB_MASTER_CORE0,
-					  ~R2057_VCM_MASK, vcm);
+					  ~R2057_VCM_MASK, vcm_final);
 		else
 			b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC,
 					  0xE3, vcm_final << 2);
@@ -2219,7 +2223,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 				if (j / 2 == core) {
 					offset[j] = 232 - poll_results[j];
 					if (offset[j] < 0)
-						offset[j] = -(abs(offset[j] + 4) / 8);
+						offset[j] = -((abs(offset[j]) + 4) / 8);
 					else
 						offset[j] = (offset[j] + 4) / 8;
 					b43_nphy_scale_offset_rssi(dev, 0,
-- 
2.43.0

