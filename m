Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197429;
	b=FNZDiWw6I5uCrGuSx0cfJPar1DnKV+2hskURSLiMS9g5+t79E5a99AyQNQyat7jbBJC4
	 VnyYrNHIjdHUIhuKEeXqciW+o8tfBeQj8A5HbKWDsVyUA3/VKO+PANC2CeP4twoCrQgUX
	 7Hp3ycg3qc11MW/bbXYq/IkXs7Y5Ln4ZA0qhwXQt6AuHarQrLwlT1Pasqdqolih34rDEf
	 fABRCacUl50YeO/QW6lrFOK1VUFj4t0NZiwKLnzF3KmBSxW0UkOTESRVcJQsOX1JjhnGk
	 iR/twSMamu9viSvguWaA66JvE+osnYNOrw0QpRyL5uHosycDb6NqrXrlK0LHaPAve6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197429;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=72nI0VUnworKyC9ySo63hS603nPN0FBwzBwYMgTAKTw=;
	b=U8aXqIcZgxOZ/w4p/sDkR9OQBsUs528MjQgNYEt1y/N2Ad6dviOSSRS5q0sTqhHISvJp
	 q5/DRpsfbgmP71A1kIA0oTzLgYFtH3MGUAZtYd320R3vX1ne7fZRLKTbMTL2SnS+4WkNf
	 rEf5B2Hq/d0Z01dXbQ8drTdtC4fQA2C6R4TLFEsD3+WvhNEh932k33348mHltT7aw97KQ
	 gGqkpoSmtnlF7BP6gTZURWqsMrHqYRd+nFBV88VMjhhlAiCov3COYrYBgfUt8q0H5X66D
	 lp5gZDY1f2Ik7WEZ3iZIwPt0hgqVNHRdC0iByfSDHcYzABPbJAC1Bl5PtZ2O2zV9Iiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e4kYrUet;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8554C606A325
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8554C606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e4kYrUet
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e987b4a710so10348105ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197429; x=1793802229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=72nI0VUnworKyC9ySo63hS603nPN0FBwzBwYMgTAKTw=;
        b=e4kYrUetrjcEDDR0lWWg6jQYYYTRRReJDHjeRw01rBebuY3A4xmk/eMjhcqxiANfGg
         gr6tertjrTZLpJiUsQ9y/dIeOtMNk3YCXOQj+eSi0wrGBgJ0Mhr0SbX6gL7a8/4Nanno
         KmEBWupsixusUoZRps1ELLBKHTheeaVo+hbjt4G5eBAxt10pMDMd/9wFL99bQeqXHQCz
         nVDvPExBnLqjF5/DHcS1KXZwfyA0TwA8RdMtyjOnHaPRrh4UVeyAu0OWQxt6vW5FpmBG
         9C6JlC+yIx5i7u8r4ezh+oSEJ/MhTX4ue3EGfTWMOQOmasCp+Q1MvgUmVM/yEwDrZAFO
         b6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197429; x=1793802229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=72nI0VUnworKyC9ySo63hS603nPN0FBwzBwYMgTAKTw=;
        b=2I1VEdLofMhczgYlUvVs/EO3zuUKdNJ+msw/8/3a/Q6TwL+psQFBPaHDLkDmULCOzf
         M4gLHV2KCeYg7KYxM6h1qF3ghWkTOMoekmF+XylUQdX9/LZuzPMY7LINeuut7uPraCiH
         dXSzh72nczINcut1cdzlPnj+5ntZ75T3HFN2ETaewBpcRkmRcC0wZQ+1xX2YEwFoWyuT
         Wi7eoAMljyAaz15V52MEgcIb7EqvC14vnZ5cDpSoqUSBq7Dcy/6h1HkIYDJmvzyo+v6M
         A/x5h/3/15bjuwpWUL5mrk300FXokCSIoDpsFvcRqghZq8VEDIaL49pGOLC4vvKgELjn
         svuw==
X-Forwarded-Encrypted: i=1; AKwUvBx28Yk7j1thWvqpYfN0Qih8z80idv6fOVml5X2i/RA7AWiOVOwQeOSdif5Czp6sZCNZcrlorKuOYnhr6p/dHQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLAvMazVeLkTmTJa3IzTo3vukZHCnAh7MeXmNgy/1pGlgMI6PCk
	Uc/v5gH3CHUjEMr18r8TDcSpqndthH4X47G47nal3WoMkYhXO8zgIwjA
X-Gm-Gg: AYBFou1XVMa30+mL6iF387MVcq0sjMcRJdYwyqCp34BUi/LcbVLEAIj4aUgWYZyyRXm
	Q+Uekc+qNr5nNhM8SK/Z0TIwsg+UGPe88c/zaUVQQCutLg84kVNr/GU3TtULa8oZFd2DUuFaVXW
	15PZLnuyX/+rVeHLrFXufBaZgJRsOD8w4+e/pvgufoNmRLcYfFaqwfgye5nO0r1l/iVgUu3QGI2
	hvoKaaI8J+CQovafsb8gI+MsTAtrFdxY37pQ1TWMyINnQLhmuwVV/eNzvGXA0/tSm9sTDXrFcGO
	CFifVvM+xRSBpG6zPDHlZgZ0jmUwXPgeg1HjfGoOei2QNrZREwXBRmharxA6hKllb9NFk5PunfO
	cqgf3fDAPrsp5A1/h1YmYB9YAO9H/Ybhi62EiydBDVq7Hmf9KmThpaSW8iMSAbXD14IxlIZUCU5
	nFyn4WfkIRCYC28DR2YXaMFbaLr52ou4iXW8XZJHaH0jhnRRw5pZfFuvM2dMM/QeeSAPQ9fAuv1
	xLnGFqZhiYU/HOWv1+yUrXgBxMFMlG1swjjWh9fad2IAh2dVAc2cOwJLlM7xEvSIjnbuDTqi2R6
	+N1ir+0ueUy+MJA0dwvkrMghu3sacRfOwEgFqlAQzg/vPCW5QUzDiNs+hTdNGKYf+CQh
X-Received: by 2002:a17:903:946:b0:2e9:4f49:111c with SMTP id d9443c01a7336-2eae3fb7b62mr36528165ad.27.1793197428606;
        Wed, 28 Oct 2026 07:23:48 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b79ff3sm23590505ad.17.2026.10.28.07.23.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:23:48 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: iwlegacy: unregister the LED if 3945 hardware registration fails
Date: Wed, 28 Oct 2026 22:23:28 +0800
Message-ID: <20261028142328.18560-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

If ieee80211_register_hw() fails during 3945 setup, later LED callbacks
can access hardware and driver state that probe has already freed.

il3945_setup_mac() registers the LED before the mac80211 hardware, but
its registration error path does not call il_leds_exit(). The analogous
4965 failure releases the driver and reaches its existing remove cleanup.

Unregister the 3945 LED before unwinding a failed hardware registration.

LLM assistance was used to find the bug and review.

Fixes: 5ed540aecc2a ("iwlwifi: use mac80211 throughput trigger")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. Not
reproduced; 3945 hardware was unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index f7ca182d1494..5e11f0597255 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3529,6 +3529,7 @@ il3945_setup_mac(struct il_priv *il)
 	ret = ieee80211_register_hw(il->hw);
 	if (ret) {
 		IL_ERR("Failed to register hw (error %d)\n", ret);
+		il_leds_exit(il);
 		return ret;
 	}
 	il->mac80211_registered = 1;

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

