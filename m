Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038551;
	b=r2pVlwk7iuPmdtwvXcm2vMjLg6VLj902bxPHhn+76vIpH7tHh1S+CwTkdXUy9kFYuxYR
	 39lnWpY9dcPRx6Htwd1eMIK9xm7YibFcll11KR0o3XwToItpNRji/gg0TMVtlev0rFIHK
	 WXpoUVfGNOqxRbRIQW8EvoNS8de8C99yH3AzX6X/Lm9h9olAEYZbUDYcNzWUJeq4u6sOL
	 GqSBUE/SnSQice6rc3RlDrZ/KlSjRw5pAeI7ylRom5oBysZ/ixyzfaSSVJNBeks7XTfQU
	 aHHnX6p+zMji+PY/1CaE9WPHAsGVCqfDOx1s508Fs+zQINkOUZYqPdNAoiQ399PP9sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038551;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IoS1hk0n4alufQMVHtiKS9OzIMlrLv+vxsfijbiQtXw=;
	b=OAlv2N9bdNwM6uaviLt3ELA83YrfDxBPken93iSDvARxiaAcCgM8XedO8rEGuvGdHKyr
	 6ZheaMlQZgnwXRmWPWJVMhW6XE8bPxCIb0pJZQej2XegzwPgXF5UWADxl10GHnpTZyRQE
	 32KLQ4cSOIKgZHAUJAUdUtIy372SaD/XaPYXiyY3kP7gS+a7WWkRwpPov87CU2E2ayB5G
	 IyNJcQUJ5u5reb3PF3MJMMTMrhv/0qjlN0p+JCNdu98sO2vXjWGEA/TmmvURBhtYH6nnJ
	 8vWyjBOWbWL5RsbNWEq4kp8BVOq5yFNtYqsjc1YV/7hVMPrMx5NrHxJI7FqRVRnpMCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lC7eW0Fx;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E03606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:15:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82E03606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lC7eW0Fx
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e47347279so1258014f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038550; x=1793643350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IoS1hk0n4alufQMVHtiKS9OzIMlrLv+vxsfijbiQtXw=;
        b=lC7eW0FxsXIwq21DmemU27OVwQzlVTzqgTg76eOXcnndseCX9Dv06b/zmfCkzBB4gr
         cpE/ZtmahMmW95+aUrJBvmCpTDVidNgBaeHpmbu5N9XAMytWuc9NfGZfRHI27gd5tlWB
         99608mqYdlrEX0gouDd74jiSlEgtzoyxeUNQQxgMuy8KK/sVuULZyR9YKevYTrp01s7g
         0sMirZ3SPIhg5c+EstbA2Gd2hrBgF+g0FqNko6Cotep2XtDvD1wvF14Rd99H8wlMUBb6
         PsH9usFuDtUlJnikkvDIcLkrhrCHCc/QMEIc14qwIjjqNFy0h/I7dVyuvYQpIXDqsOV5
         C7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038550; x=1793643350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IoS1hk0n4alufQMVHtiKS9OzIMlrLv+vxsfijbiQtXw=;
        b=bk2pkBMeOnZ8IRZ293OJLBX8vEFsB9lCxSDrX/upm+Q7/AVYpY8UE2Ia76ofZXG/Om
         JjYSEU8zhDOU/X+RpedTsRzMzKFSgcbSm/HxyqwZw5ZYfdpdkE1Q/uo0uqu3eA90U6DC
         cbJoLGEBxj18uB5vfwuLMmiFNFzSi2F+T8W8l05uzYIYOinfvX9zGb4ErULiiPMAL95b
         hCBUQvpQWUKgCYkzqvemYAw0omm33u+FFv46xEpi3gT+IWzEamDxR8BZW9cooG4nHd8w
         Wf07HH/oljg6Xa9nmXoBO9k/H5GxvQ6rEpxc/IkqtFv1mt1ShQ9kk5cK0ELo/2/cJxVf
         qPmQ==
X-Gm-Message-State: AFq9FYI2NMKde5d/vMVaVOswYSimgPoA6Tmx7XbXPaIh9z4qpIoPYknz
	qPl/zLpBU+9KYxybl6NyCvv1XpU0ewe/xnx36XpDWhWGy2lctKb7m2O+4P8T1/YJ
X-Gm-Gg: AYBFou1xH3cIl9r8KJeGR82+9n4Bsxj9dRBbkEY6OizWgY2QR/bAvJgPLqTMpL2IDuk
	zod7KjNW2XtU00MG39O467GOcF+R8a2BNGfO8olemxLZ50YTierqgtIk3tIAu+WrgbnIHvQxVbX
	HoAVBmW55LHnzjvSQb5+yqPncAiMf0gU0mDuAEEXOn9GSnirKmO2YiIlqmR7i28/7EXzbuTMjgj
	xRWKRdqJH1IcEnbaeoJGmn2mPr8iGK0Gtlx04Q4kCGx1AMahjQWTmFq/IqIcKU1FMxgZGmsYVXi
	2VGd3oUHuwGJFTBkfQa/b5sBoJppdejdY1/DqXy+4Oy2ppsK/htJtaT6h+w2AgzI8UR7rQPpDzD
	KyRwP5R7GpkLAR3Ules47qsmkgJWa0+fEOji9e3dFxFf/sHnDRWiDEx3fPkScMCumCke3EvVqCW
	EfKB9UzXM5b/oN347kT3pmUiU+Fndst6pBMCHrKZtiAjAsF53T+rM+fFpxnnQVele5YtkO6JnKX
	z+4TwJRxJ6Np7nWctrYtxK8hmE8tv4k8UbbRI845C8g0vKXE6b0z97ZZmTcS4yZaR352mh/0ML/
	KebY
X-Received: by 2002:adf:e889:0:b0:48e:932:aef5 with SMTP id ffacd0b85a97d-48e3eb8bafdmr10513713f8f.21.1793038549855;
        Mon, 26 Oct 2026 11:15:49 -0700 (PDT)
Received: from luca-HP-ProBook-650-G1.lan ([2001:b07:6454:c33e:6c42:b004:d90b:d191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20967847f8f.45.2026.10.26.11.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:15:49 -0700 (PDT)
From: Luca Casati <luk00casati@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com,
	b43-dev@lists.infradead.org,
	Luca Casati <luk00casati@gmail.com>
Subject: [PATCH wireless-next 0/5] b43: N-PHY: fix calibrations on rev7+ (BCM43228)
Date: Mon, 26 Oct 2026 19:15:38 +0100
Message-ID: <20261026181543.77763-1-luk00casati@gmail.com>
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

On a BCM43228 (14e4:4359, N-PHY rev 16, radio 2057 rev 9) b43
associates but transmits poorly: high retry counts and low rates.
Comparing mmiotraces of b43 and the proprietary wl driver
(6.30.223.271) on the same card, together with brcmsmac, turned up
several bugs in the N-PHY calibration code:

 1. The TX tone sample table was loaded as all zeros, so every
    tone-based calibration ran without a signal.
 2. TX IQ/LO calibration: inverted busy poll, reversed final copy,
    and missing rev7+ cleanup that left TX dead after a cal.
 3. RSSI calibration: wrong VCM written on rev7+, wrong distance
    formula, wrong rounding of negative offsets.
 4. 2057 RC calibration: the first run was polled before it started,
    leaving SCAP at 0 and the TX low-pass filter detuned.
 5. A missing field in the rev7 TX_PU RF override.

After these, the register writes for the cals match wl's on this card.

Patches 4 and 5 and the cleanup parts of patch 2 only affect rev7+.
Patch 1, the poll and final-copy fixes in patch 2, and the
distance/rounding fixes in patch 3 also change code that runs on older
N-PHYs (rev3+); I could only test rev 16, so testing on other N-PHY
cards would be welcome.

Tested on the BCM43228 only (2.4 GHz, 11g/HT20), on v7.0; the series
also applies to wireless-next. Throughput to the internet went from
about 5.7/4.1 to 11.1/5.2 Mbit/s down/up, with fewer TX retries. That
number is limited by the line and noisy, so take it as a rough
indication; wl reaches 21-32 Mbit/s down on the same setup, so there
is more to do (PAPD and TX power control on rev7+).

Comments and changelogs refer to wl where the fix was checked against
its register writes. If citing the proprietary driver is not
acceptable here, I am happy to reword them.

The bugs were found and the fixes drafted with the help of an AI
coding assistant (Claude Opus 5.5), working from the mmiotrace diffs
between b43 and wl and from brcmsmac. I reviewed and tested every
patch on the hardware above.

Luca Casati (5):
  b43: N-PHY: fix the TX tone sample table
  b43: N-PHY: fix TX IQ/LO calibration
  b43: N-PHY: fix rev3+ RSSI calibration
  b43: N-PHY: wait for the first 2057 RC calibration run
  b43: N-PHY: add the missing override to the rev7 TX_PU command

 drivers/net/wireless/broadcom/b43/phy_n.c | 120 +++++++++++++++++++---
 1 file changed, 106 insertions(+), 14 deletions(-)


base-commit: 028ef9c96e96197026887c0f092424679298aae8
-- 
2.43.0

