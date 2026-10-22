Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792647230;
	b=NichAb2OhG6+i+iQB3IuwUlSamBgbJqpeaa9kQFXN3ge1I2C2puMf0HqowMC2x8AmZin
	 ZkyoLHHOh0XIMAaMFwb69pdlc1eqWmI4Z7kGnxcouOBYEP/R7ea58smEEG6evJMLxjsRb
	 IjZGvxVKkFX/Q/JnwBWU7/xpmrJzSs05jxYJxXu45/8HheFWPVn7MA8jQZY4H+AkO9JZe
	 QbRGgp2C0A6sP2fTxnYcbUxzbzZSeOghVAdyLzD1eaENzuPuPENFghPhE5UDZ9RCImC1T
	 WmMjRg4Ww6ASqh2rUS7A3PytnlLTfQf/EfEOsqX4rGbouu+pe0VlV+42w1c56UTOfkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792647230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=0+2f3s0CtXWQrTFVVsiCaUvhU4+K4IjiLxQuIlkAlO8=;
	b=qtpQuukpJnDbSfexcqQqB68OtqTrCGP7sN1OLfKu1wdeqQ1/WdSR6hAKRcalBORSrRTK
	 Cc09oevkiZoklXtW9lafHfMd7CJSmlosMRP3JF5uoAV0U8qchW1vcZLsdZwBSkZGfaAJd
	 cPWaRRLwkiekSnCuMwVWywnXklN8tkDU6jyZFoVqcgUp7z+qP1a28kWmPoF+RlK8f/MQA
	 x98VLtOsd0jmsbgWsHBZr3rghr5RZ1CoxyaVpOdVXbDesHvD2Vj1u/pq/XAmTiYHbY3ih
	 BfJaVj3JsynGio6SO7hXyass1A7O0+IPpPjXdgZSrh2/ecmzr41RqLjS6/NNRA9+lxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RhhR5ONM;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F80F606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 05:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F80F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RhhR5ONM
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15dd124bbe7so2751397c88.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 22:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792647229; x=1793252029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+2f3s0CtXWQrTFVVsiCaUvhU4+K4IjiLxQuIlkAlO8=;
        b=RhhR5ONMJx4JHCq3509giep7c9myggid22oFQzhjp6mvzPs9iZ6FIVtYit/SfuBvBO
         RoDGZDk8gOhBdtf82q3V3FT+bRjQNGK14l8S6uQVpRBf+qOCHZ3F024sAxW9A0kq/psD
         1jDnOLN2PDBrsOSLhXXDPj/Nl+5e62fu65ORKgr2vEZ4asuqHFqD48dfutwnA2u3l6VW
         K2SrcZLWrreRUrxwfLYeWHO6ajSHcBP+0D3wZ02bHfC0xXpDKb4qgLMMyM8fekeOLvaa
         QH59sr9uV8rgMBqJNHOO1MxrwWL8f6EPsh6CdD7UJrcgUxoFonTh1axcUe45MQWIOCs/
         2cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792647229; x=1793252029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+2f3s0CtXWQrTFVVsiCaUvhU4+K4IjiLxQuIlkAlO8=;
        b=QGQ0WkJQlkN5IKCLvvlKegyE2aN7j3mVoPEPSeu3v57zsWJTqF4bYRG6YuSm3Ee4ZF
         HZ4211+3yj0WI3ho/aJhS5pTgikIl7bKV6helhwV1ZBo+13jM5OHo2GLvSBgXUCTXvQN
         4eJ/G7yOmMz3x2HgLR8NphothKok8u9nY9QcudwQr0jELZno1AVZm1duOmKcHPzILzfi
         5sMjRJQh+NOdMuWH6Ko+/HHIWIKC5ODBGA/kzm24Nmn15BfWa7wC1TjK7mNf0T2dqCPi
         WoZsgL7eYnNWIE1iJNI7fDo7wFIdE7lqjrVUMTnOLFmy2R3mXB8buaSk3sXTGKlK4wdj
         E+sg==
X-Gm-Message-State: AFq9FYLf63n4z4Y4gRPkXS2vF0dj1M80pTTPYeaM5GeFLU6H846gYCIm
	cdmpq8hVw+Z9oWWrk6S1ClvkksKe3//Qz7n6WhP+9WgZPqBTSqGbsuDm
X-Gm-Gg: AYBFou1iRaQaKXNGohLZxdXyfNM8Hm3L3ehYYchNpMNh39J5sTf2cqTRq5yjeYA10Yd
	dGZL6gTwlMjZJhkv5rRoAUXdDluMmDVxpumyTqwIsG8ZWfXP4jfKc6lnB8ovQdrJIDGB9/xNlHF
	c494qMqKzvG2KddyPpn5wNuuxbT5KQgJVoz9/iOLKaBVGG3IfRo+zbumXwzVpsh2VIHdVaQ0VTr
	r33QRU05G96Z5OG8K36Bc+bn1TKSOOmzat7R3np/J/21fekkl2gNXDyg/pdu7Ud2+Bk4j9URaXQ
	227qZk7hGUPuTt4Y1UbrhLAz/tBAPL6fsONGrc43+xJqrVy3052iE5BGU+7MAAhjrqz3rhh4c9o
	TrxoPrRJYKOnKBJlWdQhRA6SWvURRkb06aBgkmHfYh2+6njBlaQSW/E2ppi1+lsUiRPrna2tLI3
	lGACI3Cb/BR5VxT4MbBmSQn5XMZtdP6IPX8mIUKiORmWFCvZNMSBNcst9oCeQPa7VASquCkHmI/
	5ibRJ3nzZ4wSwc6DLPuLcwFhYfKQG+xMe3x8cXG3ORrnIERGkas/Sz9p89lsQmd7No3Wxwk4m8J
X-Received: by 2002:a05:7022:7e89:b0:14c:be8e:69f2 with SMTP id a92af1059eb24-190a599a074mr6253784c88.21.1792647228908;
        Wed, 21 Oct 2026 22:33:48 -0700 (PDT)
Received: from ZephyrLabServer.internal ([165.162.64.148])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903bf5d0a1sm11654331c88.14.2026.10.21.22.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 22:33:48 -0700 (PDT)
From: John Macias <dencity7@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: ath12k: ML Association Response accepting a partner link is not transmitted when the 5 GHz link is 160 MHz (QCN6432, WLAN.WBE.1.4-01734)
Date: Wed, 21 Oct 2026 22:33:21 -0700
Message-ID: <20261022053321.1897324-1-dencity7@gmail.com>
X-Mailer: git-send-email 2.47.3
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

Hello,

On an AP MLD with a 2.4 GHz link and a 5 GHz link, an Association
Response that accepts the partner link is never transmitted when the
5 GHz link runs at 160 MHz. At 80 MHz the same response goes out in about
2 ms. Single-link responses at 160 MHz are transmitted normally, even
when they are larger than the two-link response.

Setup:
- GL.iNet GL-BE3600 (Slate 7): IPQ5332 (2.4 GHz link) + QCN6432
  (5 GHz link), ath12k AHB
- Firmware WLAN.WBE.1.4-01734-QCAHKSWPL_SILICONZ-1 (also what the
  vendor's current 4.10.1 image ships)
- OpenWrt, kernel 6.18.55, mac80211/ath12k from backports-7.2 with
  local patches (diagnostic logging and one REO descriptor flush
  change); hostapd 2026.08.07
- AP MLD: 2412 MHz EHT20 + 5180 MHz (channel 36), EAP-TLS
- Client: MediaTek MT7925 (two-link MLO)

What happens at 160 MHz:
- hostapd builds the accepting response (485 bytes, primary link and
  partner link status 0) about 4 ms after the request and submits it
  over WMI (return 0).
- The management TX completion arrives 185-236 ms later with
  status 1 (six observed cases: 185.4, 230.1, 235.9, 236.0, 228.3 and
  218.9 ms). No accepting response was seen in an external capture
  (capture absence only, not proof of no transmission).
- Meanwhile the client retries about 100 ms later. Without a hostapd
  change the retry gets a partner-link reject (295 bytes, which is
  transmitted), and the client associates on one link at 160 MHz
  (authentication, DHCP, traffic and 3-minute stability are fine).
- At 80 MHz (same channel, same client) the accepting response
  completes in about 2 ms with status 0 and both links come up.

Size is not the trigger: with a 200-byte vendor element added to every
Association Response (assocresp_elements), the single-link response
(about 495 bytes) is still transmitted at 160 MHz, while the two-link
responses still fail. A DFS-free 160 MHz channel could not be tested
(channel 149/163 is not allowed for AP mode by this firmware's
regulatory data), and an 80 MHz MLO link on a DFS channel (52) aborts
CAC after one second, so DFS involvement could not be isolated; at
160 MHz on channel 36 CAC completes and the link comes up.

So the failure appears tied to the partner-link setup on the 160 MHz
link around the time the response is queued, rather than to the frame
itself. I can provide full WMI/hostapd timelines, the frame bytes for the
80 and 160 MHz cases, and run test builds or additional logging on
this hardware.

Is this a known firmware limitation for QCN6432 at 160 MHz, or is there
something in the host-side peer/link setup ordering at 160 MHz that
could cause the firmware to drop the frame?

A related hostapd change (replacing the AP MLD's own stale link STA on
a retried association) is being sent to the hostap list separately; it
does not fix this, since the retried two-link response is not
transmitted either.

This analysis was prepared with the help of an AI assistant; all
measurements are from the hardware described above.

Thanks,
John
