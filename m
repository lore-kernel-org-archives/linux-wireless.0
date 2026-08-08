Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C543A16B8
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 19:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786218140; cv=none; b=meG+k7b9ELIwjf6541gHb+N/jjStdcwOzU9OC3W71IEUI9d5UrEqqhA7QBtQ6ykijGURnorOJBxTFGW6YisN9/fNOHOMvC2SB3cVBWOuT2SHo57nRCcCgkb6qB2+dSlwGrt6uTj5In/rGznKGInFOrboDNhMjCJy93FBU/EeQ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786218140; c=relaxed/simple;
	bh=moJaXvOMqK/YmC3noaUqVdHPCKjv33FYSKvD9c5ye3E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pogC1tmWqIoCdWbxfwNFq2pkIjMo7fY7gjrAp3AAJB9hmmuTalN169/qfeBJbH2OBWT++c9z41ThODZQBuleTlt/7DOof+hAWNxR/ApLtNIJkiYfmTGa+F1V4tLKhWlsFuUO+t9J14xT3i7GiH4CEU6wpfJdi5ZgZLS4Vv3kSEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxsTziNw; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxsTziNw"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f84023916so500984f8f.3
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 12:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786218137; x=1786822937; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YyMuh+QoZaZhYW4X239Yn+CCyFauxpCnt0y9pHjn0Gs=;
        b=fxsTziNwv0jjP9K1g+LvXzJPV+5nx+fGNdH0/GHFlWPLWwy2ltUQjU9cRa1LD2tXvK
         i/TAtnDKBfkbGv+Wh0Qvfpa5n7eoHeaVEMxKjkkjzpt2OJl3yTocayqDdvKr7CaNj7ef
         OtiEHfmgQkrj1CiGq9yUEiBNOAFX7RXngOtQKvSS4HIyr0ExM9qdyUsSNcB4G0syfamH
         kPjVR161TpG06z9X1X0Yu0R9jl4d0mFy6u2/A8QYFHnGGsYv0YaWevApdYwUQMnGTABo
         gnYT1kz4BSYUk2T2kaX4QiicXmwbaG7u34QoW1LQx9NNBzl3zscVTD2PXali6InYF3ZJ
         KZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786218137; x=1786822937;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YyMuh+QoZaZhYW4X239Yn+CCyFauxpCnt0y9pHjn0Gs=;
        b=tPPgK+oFengd4Yjo9XbE4Yreb9ylOqTUYq/iL8wGmoYj9MUc0vWkMNa0wjN8utcZpo
         nrWaAq36ft/ouwFBQIyQdUvn61lKBRg6b+53U37iJwtU75FHzqv0mg21kltCVX7+PW9k
         yGyEvug05A62MKD7oHOpxMJaEJ/zz16tiM+s0IHKVla1TyKlOKE8pbDdIaMbK/oZ5Jr9
         W3368lDx4yKk05te1bkrh0UY4LTp3gM1aX843ciGukW4fld+06dm6ubhZIoeToA99Fnk
         4g+X+F/TpwL/zMuHzXRAkYvLcw7G5HIi6leXPx73OXUTbSi4hPcvYPznAs3Molz1zWK1
         Jyvg==
X-Gm-Message-State: AOJu0YysP2DcSxpGcmZucAmqEbKbq9wR1ZAPgRvYIrGaJI0amq9bgxlU
	pUVXWWmGv18yFE+V9iJTvtRvog/+Puk38be09pza3VJ55e86r8RDpqgHTRGSY6nxKx0=
X-Gm-Gg: AR+sD13aItfOF1NM8Ibv2K5FjRuyfMJHJpbhHfeIYn9eX4q4KIQp0W2tMk4p6bAgIoE
	JSCrBLWXCF5bARgIb04tK2canicajwVdmDUFcJ2WqY5vFfpgzxa4yPgf7/wJzTJKcx9v0KCTBVt
	vlob/Ysu0HTzd+Icvz3zC/BayMldQI4YWTaXbVwykRPBd/Jx6Vl1Cc3zONGHww6pfq8BKdeCpp9
	POZBdSUISwZUu5hoBMfR3B8GZqdiKNdOT1rVskLa/G5DcwPq0tByh7GSpz3o/He+vOxXjn7qnOY
	I3BU34sJIFu+SddaY30H1bRoD+tjSlZt6GHODwf2Fba5Y34a3EFC7ZDFK7blTZ9tl8AejcAzZZP
	dSQKfurlpSQQixrvxhzG0q4Qmn06wCBcRYPu8yOK9c7fi5Lrg1xc3I4eFO+MkZ9RJ5Pu5PGoFTV
	ywk7upgiA10h9rM5PTg+HVuoyfqr1DvS8iZ1OYu4Gavj/JtlldW8577jCe
X-Received: by 2002:a05:600c:138a:b0:498:943:ccc0 with SMTP id 5b1f17b1804b1-4994e714d8fmr420608495e9.6.1786218137636;
        Sat, 08 Aug 2026 12:42:17 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995ea2dc4esm159795445e9.13.2026.08.08.12.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 12:42:16 -0700 (PDT)
Date: Sat, 8 Aug 2026 22:42:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] wifi: mac80211: factor out part of
 ieee80211_calc_expected_tx_airtime
Message-ID: <aneGlCMVnqRhlf6p@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Felix Fietkau,

Commit 094dc1619cb0 ("wifi: mac80211: factor out part of
ieee80211_calc_expected_tx_airtime") from Jul 24, 2026 (linux-next),
leads to the following Smatch static checker warning:

	net/mac80211/airtime.c:798 ieee80211_rate_expected_tx_airtime()
	error: uninitialized symbol 'overhead'.

net/mac80211/airtime.c
    756 u32 ieee80211_rate_expected_tx_airtime(struct ieee80211_hw *hw,
    757                                        struct ieee80211_tx_rate *tx_rate,
    758                                        struct rate_info *ri,
    759                                        enum nl80211_band band,
    760                                        bool ampdu, int len)
    761 {
    762         struct ieee80211_rx_status stat;
    763         u32 duration, overhead;
    764         u8 agg_shift;
    765 
    766         if (ieee80211_fill_rx_status(&stat, hw, tx_rate, ri, band, len))
    767                 return 0;
    768 
    769         if (stat.encoding == RX_ENC_LEGACY || !ampdu)
    770                 return ieee80211_calc_rx_airtime(hw, &stat, len) * 1024;
    771 
    772         duration = ieee80211_get_rate_duration(hw, &stat, &overhead);

All but one of the return paths which don't initialize "overhead" have
a WARN_ON_ONCE(), but it would be nice to initialize overhead...

    773 
    774         /*
    775          * Assume that HT/VHT transmission on any AC except VO will
    776          * use aggregation. Since we don't have reliable reporting
    777          * of aggregation length, assume an average size based on the
    778          * tx rate.
    779          * This will not be very accurate, but much better than simply
    780          * assuming un-aggregated tx in all cases.
    781          */
    782         if (duration > 400 * 1024) /* <= VHT20 MCS2 1S */
    783                 agg_shift = 1;
    784         else if (duration > 250 * 1024) /* <= VHT20 MCS3 1S or MCS1 2S */
    785                 agg_shift = 2;
    786         else if (duration > 150 * 1024) /* <= VHT20 MCS5 1S or MCS2 2S */
    787                 agg_shift = 3;
    788         else if (duration > 70 * 1024) /* <= VHT20 MCS5 2S */
    789                 agg_shift = 4;
    790         else if (stat.encoding != RX_ENC_HE ||
    791                  duration > 20 * 1024) /* <= HE40 MCS6 2S */
    792                 agg_shift = 5;
    793         else
    794                 agg_shift = 6;
    795 
    796         duration *= len;
    797         duration /= AVG_PKT_SIZE;
--> 798         duration += (overhead * 1024 >> agg_shift);
    799 
    800         return duration;
    801 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
