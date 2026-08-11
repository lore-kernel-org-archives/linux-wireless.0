Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86C937B036
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472780; cv=none; b=R+pRHHvwamKXZRPxnEceNJjtCY26MjcXySVn1Sz+9kpJO9rfdQwbf4GM/5eO0JAsb0OPURUDGQg4ewYgTjfqmqjwuQy5/QLrQWg2ajpek8W6PauESZFn40RWnWjPf7iBa8I335gR3pbhlumih/1YmgbR7/LfZgta7DhBvnBpHZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472780; c=relaxed/simple;
	bh=6Xe1746UNq/VOnSEu7vXJkaQtYqib8g/axAwoeAFVR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WntPKZ4adWTaOW5atOm5GF4TJfgSUAV/Ek27giuExCEU5hB2FtncMzldmyP2wAPluuzLjvHCJ7zow2IT3LOA6tOs5rTW+QMLIRVK0VgYA67+/b0jHuRIjo2W7uEHzJIttuttVGCHdfrCQBUMVHENgQs3c9Di8zemgolu79wD9FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8R8LU7d; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8R8LU7d"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954b3c5cbeso104645e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 11:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786472777; x=1787077577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Xe1746UNq/VOnSEu7vXJkaQtYqib8g/axAwoeAFVR0=;
        b=k8R8LU7dEeVYTvRgHvVljiQBa1zxQJaHCCzwARp4qCdnHgA7Gt4Egn5oI8GX2BfNHl
         3JUekR+B0CkJyQKcEXFwx6dcYC80FqHlT+nF13c+DtvY72zAm5vfN5T+OP2EjJmBEqOD
         uaLwORtg6nMzuI7Wzgi2zI2YBVyca3z5TCtre6VO9XTiM0YStai3d8y5nOm7VGPDx85k
         z5CmO/cQ1Dix37Coxp5ObY0gDZmRmnmcJxyobFif+s9S1E9mn0vWLCqmwjVFKxZnHVML
         w5S87k09q95khUinktENBTTzxjx5np3FzMVaSOZSLJa4KwnlholM6McEJv5e6UOKjckR
         FPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786472777; x=1787077577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Xe1746UNq/VOnSEu7vXJkaQtYqib8g/axAwoeAFVR0=;
        b=T+sI1bSPEbjRtrugpBXd2sCmazvFDIRq081cY2RL97rsf+yzkn9boDJgp7CDFwdjqm
         Yx8qFUuwx/BDKZxssGiGGhOqBKYArMbqzOsHN92A6nL2hezVbmqCDWJ/GUcfzifYIHVo
         R8BSXJpMIZSjz3o6o0TMLp6V8LOz7aCwY3exRXJhphLJ/PSexuQ+YqmXNDSxseap/xN2
         Tp0BQ31XmifIGMBJtDmZgmeX76b2TDDjGm4XUd44kzToBoYYKGX+5hPco1/XdlfaomQ2
         q7HPQKqjcOUzPdRi6yOEWohQy5uk3yHTsU7m4fbVa4S/cgsvrh45hGc2cQ2HuvUGPhV/
         IkBQ==
X-Forwarded-Encrypted: i=1; AHgh+RofFBxIRrEPtdtv0F6uCGkNSA558VWCQGnEkixLAciD0NcBQPPgqbjSVJRXW1EC/Kx7RPrd30dJAbz4RxPXZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4ICbxRQhndkHewLciCrjENESdYgp8CyOYcdOv/+t6zfHzcln1
	GDCv/+deedSuQASf3ZtkKiQ1YhB7gLWYDOomty6PPEyuDiyZzDxtXRl9
X-Gm-Gg: AR+sD13MhB9sbzg8NYEoP4m9WMknL+eOQh5FAfP4wGDurMQB7COcBviIfNi5MVS1UH0
	T+eL5xpgzujhAxbbdM6PGpZFxgGXzaIj3U20KndwfHxp7jNi64yvPvHho4tNIFLIstCZVnmWijj
	/pM4h2oA+EjJdwCjl5yDebVAF5HvLPi2m0fytTox9qaA4yw+2oytAfTa5LhqnBH6WGQqNOGg1lw
	9Pyt5dxotheYb71AMaosKc3q0yIz9QFfiiXBWwQbe+7gBiM+RjHtKsCeZ7qjZsBLAzIrY7JEC4e
	LmojJNIS0rFyDyHgdedAty1s7AKDOI4vBE1SCoSQxTW80SJogb8l7mQJ/0ISGQdzQ+W6JePxwQ+
	KEgqyYeUz6U098y+iA9MzW/eSfGnrdsgCr9+YH4oIIkIGIHg33ICMOi7vaYvFXSMIcvKiVXI66B
	HwNXMRH58OEen4TCdMcLzPC3ez4mFs4bevlr/KPdkHEaoFXKkv1T6eBnZQgae3RtbA3S09XbFWQ
	nph2IpGw7CJgjn/EKxEJBHw0RZl0UC3+HE+GuwJN8J1cwog/nuO1Yo=
X-Received: by 2002:a05:600c:4fcd:b0:493:f42e:1b3f with SMTP id 5b1f17b1804b1-4997b0694a0mr2390355e9.3.1786472776788;
        Tue, 11 Aug 2026 11:26:16 -0700 (PDT)
Received: from m715q (host-79-35-51-177.retail.telecomitalia.it. [79.35.51.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm2628155e9.7.2026.08.11.11.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 11:26:16 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: James Prestwood <prestwoj@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until association
Date: Tue, 11 Aug 2026 20:25:43 +0200
Message-ID: <20260811182545.256241-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <30d659c8-f568-4903-9dc0-1a78e16229ce@gmail.com>
References: <20260730161531.3535100-1-andcov23@gmail.com> <219ac494-deb2-41f7-a762-7b5e666499e3@gmail.com> <20260811173509.179926-1-andcov23@gmail.com> <30d659c8-f568-4903-9dc0-1a78e16229ce@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi James,

> Another case I forgot to mention is the client will FT roam and
> immediately start dropping _ALL_ IP traffic (despite the 802.11 layer
> remaining connected/stable). We've seen this with several vendors and
> actually had to create a watchdog to monitor for this situation and force
> a deauth on the client side. I wonder if this is closer to the issue here.

Yes, that is much closer to the failure mode I would expect here. The FT
reassociation can complete because the initial set_key() failure is not
propagated as an association failure. After calling the void
wpa_ft_install_ptk() helper on WPA_ASSOC_FT, the caller unconditionally sets
sm->ft_completed = 1; there is no success value to check. If that retry also
fails, the AP and station can remain associated at the 802.11 state-machine
level while the AP has no usable PTK, leaving the protected data path
inoperable until a disconnect and reassociation.

That does not establish that the vendor APs you observed hit this exact
mac80211 ASSOC gate; a different key/peer ordering bug, or another data-path
problem, could produce the same symptom. For this specific race, the strongest
signature would be a successful FT reassociation followed by no working
protected data, together with a failed pre-association key installation and a
failed or absent post-association retry on the AP.

Even without useful AP logs, a station-side monitor capture covering the FT
exchange through the watchdog-triggered deauthentication could help narrow
this down. In particular, protected data continuing to be transmitted and
acknowledged at the 802.11 layer without any higher-layer response would be
consistent with a key/data-path failure on the AP.

Thanks,
Andrea
