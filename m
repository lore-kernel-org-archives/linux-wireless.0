Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281713;
	b=giLh7c5DVyzF7K1jys+iU0PFVV6BqYXuvdTW/HA7En0Ue+oO35lPC4hZ7NTy7jZz6Vwb
	 PO2Nnv4bdeqB5LulPvV/kR5svmMaEnP4WhvZTEH7sIXNg4Z5S0RP2uF8+zyquM8/n6JDP
	 fIJrjXssnmEOUdidQ9IB4PYYZ9UZp3Xn0tbYaJXAVbYhSq9yOteBkZy6ryarwieHRe5Wo
	 EBWqD9bpEpCj/FNgFWnb0Alk/HVzpW9WkLKDOgpeqq00jeW5dC+MOv/tynZnqsHgpMF6L
	 xNk+4ROFdjtj3Wlx8cxsUPLcu8IGFCdvqSbOdY+EZGkfGj77hme20ZNh6BZP/xV1S0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281713;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LiWyaPQMeEQ4XuFw6vwkxxT8nw4alPycyzQAHN0Qa8Y=;
	b=TCCzwD7ypL+WTKj7IMjMZjJLIRBCNOdl9f3MCZU2g1/66LjOWM1Dc/YBpfAN8GcleI7T
	 u+UBZHIAoKJlVmMzHjgy8M7e6vhwgCkFTfU/2pB/IlkNUUW+lmSjbO35Cr0FLJ7LZYX2Q
	 nORb6G5ikfaso4MNqDQysx36OjNYMHb9INmw1RpJ22wkT7tFYyLDFAfUPVPXVpbYCaUVF
	 TiXle2jviii55DPT0J6Naskgq9spUHPfPvtvANSKrSP4JI6MT1bjngTyAId8ACc5Q6uso
	 tnT+hsBuoCzrvvkykbON2FI6uLdUFvb7xXEjXjUkJ0jAb67Fpi6VWgoZyFY1F/NjJEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ucaIss8u;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E59860A261E
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E59860A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ucaIss8u
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a06e79e152so1206117b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281712; x=1793886512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LiWyaPQMeEQ4XuFw6vwkxxT8nw4alPycyzQAHN0Qa8Y=;
        b=ucaIss8uAhSqyxJ1oyO6Fbwqn4gPEaTwQUUCLODXCd0h0GEV6R1GiPxY4d6oewxZbL
         SXp65Np1YIhe5Je7NEcq6j41GKhaEHlk+V4BNXV05aZUjzfjJz0IxuJfhSoXhUPaMSiN
         rHwjJ63qAxu1wWpHcjJeoW9v+WtzSC8RvMufuOvgMgC3DLtgHdZLoUtvHz9g6WE/uEjm
         JAf6g+L7qM0dYwlNJdKJ7hS/BizSCoUwWwiw2VlgYnj9Jn2bsukUm1Hkl6IC++wxNA9g
         5IrOb2IA1nVGbU8Mu0vGnoorqbpB2utYwDuKAf7SutX5HTgNIWxyDX/txKp18hNeiRg9
         MNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281712; x=1793886512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LiWyaPQMeEQ4XuFw6vwkxxT8nw4alPycyzQAHN0Qa8Y=;
        b=A9i7+nYeAI3GsAaO4HIXq9dP1E8WoYLW6SiRtZUU4QbqiB1rBPB8JbP/6ca00eWA+h
         FzHTASDaH+PX4K+NdlMHiLkISyAzD7UqiW6XGmeAZFv3Okaz0JKAEi1+XfF7gJz6d7Hx
         P45ZnrQHRQY2JFSGJyIvkfWOt1I5sdpKxiBCTtuHnSrOoY3qNVlGYATzw5N5zFUU7sJt
         8YvVsRUcTXBqJd7ro/vRDgtp6H3zW31OL8U93gP8PdQgEzWNE7wWp+jLguYhchHpmig/
         j4eph4QLXn8OnjGtbXmH1jAL1kHQnJHfMpcj1o7Nb2yS+3+1ZR5pmZjZIaR9iury4oAi
         6RlA==
X-Gm-Message-State: AFq9FYLVgvqiR/SGGt3eK1gXTNGGvMtnmoD2n6YMEXIpZdL3cwhknuJ7
	Afg5/h70HxqMfZ3kQ0CroAcLPJJXXujqsgWDWxl7+onlnNf7jKwYtAhe
X-Gm-Gg: AYBFou2NiwiWLim1R0cLYWTVOX6oRI7A/k55vgZeCjaANm4//k8Ro6PVTWZ1Ufx4xz6
	h4v9UtRLFSL/eFgN78yfsosx9XYTajcsz2/6e6+x2O7uaZeI8dQabCQ3wu1XqWP3M05U8sst9DJ
	3yVML0GF1bOudxUKly4NYWxjx8FVvvq6rlY7qDZdG3ZCu9Qg+WIXt+EernCoC2wae6tZu3gzV5c
	M2krNqmSrWbBeDPHsgL+rhCq/LD9ggOPYoV8/AvNaBr74glbn2knrq6o//Xm8xUuidGp7SyU985
	7RKrzpDG153olL9PLstXoESNOQKmr5h3h9Nu+7tekaccG9QVtlwAlHwf7jEGO1BbwTSwSJuz0iF
	0xi5d7NLTXN/bqT5/5QOhOeoshv8bVNGXNIPemJhJU+KLS1DxpSSqvmczmuR/PvFsK+Kp+W0EFs
	aBbOwNTIsweWH9CYSxX7lUt0oP+JbAY0khDR1RI6SPoaXgAXQQtbhkWKmQ0Tdan7ZqE+SpiYwhU
	y0W8anFcIWMpPUMtsykrgelO6bbRN1RpBoJpxra9AM50s27b9EE4qIr5soEFn/aGnj7ymx6k3iX
	fWw7VJ5bMCa6AL91XkeGY2zY2h4z1FaF75efqW3lIGzfX32n15EJwmckNdgBQW3nRAXZvlb9ie9
	IXIXBD/Qe
X-Received: by 2002:a05:6a00:1d99:b0:886:ead5:6d3b with SMTP id d2e1a72fcca58-8a6e81b6fe8mr4515322b3a.53.1793281711917;
        Thu, 29 Oct 2026 06:48:31 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:31 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 4/8] wifi: rt2800: report the MCS16 to MCS8 fallback of RT3593 in TX status
Date: Thu, 29 Oct 2026 21:47:45 +0800
Message-ID: <20261029134752.1299130-5-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
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

The RT3593 retry chain is now MCS 16 to MCS 8, skipping 7 MCS
rates in between. Reflect that in the retry calculation code.

Test results:
   before after
TX 27.0   29.4
RX 70.0   70.0

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |  8 ++++++++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 9d88ee698b854..de234bcc7a065 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1116,6 +1116,14 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 		 */
 		__set_bit(TXDONE_SUCCESS, &txdesc.flags);
 		txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
+
+		/*
+		 * On RT3593 MCS16 falls back to MCS8, so a frame that was
+		 * sent below MCS16 after a three stream rate skipped MCS9
+		 * to MCS15.
+		 */
+		if (rt2x00_rt(rt2x00dev, RT3593) && mcs >= 16 && real_mcs < 16)
+			txdesc.retry -= 7;
 	} else {
 		/*
 		 * Transmission failed. The number of retries is
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4d94b7062f440..823785088a308 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -329,10 +329,10 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	 * lowest rate was used.
 	 */
 	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
-		tx_info->status.rates[i].idx = rate_idx - i;
+		tx_info->status.rates[i].idx = rate_idx;
 		tx_info->status.rates[i].flags = rate_flags;
 
-		if (rate_idx - i == 0) {
+		if (rate_idx == 0) {
 			/*
 			 * The lowest rate (index 0) was used until the
 			 * number of max retries was reached.
@@ -340,8 +340,17 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 			tx_info->status.rates[i].count = retry_rates - i;
 			i++;
 			break;
+		} else if (rate_idx == 16) {
+			/*
+			 * TX_FBK_CFG_3S_0 makes MCS16 fall back to MCS8 on
+			 * RT3593, the decrement below shifts it back to 8.
+			 */
+			if (rt2x00_rt(rt2x00dev, RT3593) &&
+			    (rate_flags & IEEE80211_TX_RC_MCS))
+				rate_idx = 9;
 		}
 		tx_info->status.rates[i].count = 1;
+		rate_idx--;
 	}
 	if (i < (IEEE80211_TX_MAX_RATES - 1))
 		tx_info->status.rates[i].idx = -1; /* terminate */
-- 
2.53.0

