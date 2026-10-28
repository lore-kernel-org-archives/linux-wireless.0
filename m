Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197122;
	b=wWzhg1Dt0Ihxr/g214tNK2qIFrFOZf3ghPDG998zNiY+6wUqOqtZ82KfFILgQK/lr3HS
	 nhIIuAMMWA8qo5cbreRtng1XjVA51tLXIAdpEzwIvbMJC+l7VkXLo6gBddxfoccEt+w+I
	 wjlp3bX06pPqbZq8th21QEY5uKNmBnoPD1jWiS19e4/lpF8fAPGg5oyxzXrt2m5EQ+0xb
	 9rEg9OgYxWomYAevz0EJKJ9RwxqXvqchaJmGdrgA6ulm/+UDEsxA2/QWvDw4jlHFdN/8v
	 fNnacIUXnytcU6y6baoFTQ9apqU3jqYTO3L+rFq8GPiEHiLHJHMWRzUONo9KOB+77NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197122;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uhged07YjYHVSfrcQ8AV5LddG8+yWyQJ6mwgUwS9Twg=;
	b=dMysqc3+4OugvJd0Rw+femT2rwJ9y56rHkhGJsfeGerxbjcSLPFzGtr0TyQVJLqa556v
	 EnKIM0PEmRdkuFGaGLUUMYJkIEJ/L2/7Yx3EytdsxZrjafeXQ9RcdINIefd/j3AEBYlAv
	 xPKbqq05aiOq3zwoz9MioPLrNn4ejMn8R+7v2/uQwVZd0jsLU8skNs7SZalJiR0yvKu6B
	 5NaoR1Uk+PTxOwxUjXw8yEhu3DTdtCiu73qNC631Zj2TCALXHW3+XyPFAZEsVV6nRMhJX
	 SqF1grKuJrKxXGHqDc9MZxm/tMsf9qwf2k9q9HUkwXAxQwKkLg9EDo3r9ZXIIjFwnTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LyQTjCIB;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7D6606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A7D6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LyQTjCIB
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so873396a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197121; x=1793801921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uhged07YjYHVSfrcQ8AV5LddG8+yWyQJ6mwgUwS9Twg=;
        b=LyQTjCIB6nzqoYRvuAJddT3ibncTV4Gsil83rGFuES/5IOQrtYtaqkBJ020mNZTPY0
         lrR7WliJAxZB0IwXX6lUGzgvq9LG8qKYJ4/bU2aAB7dinRvp8EDnk3f9/IbyLneqENKo
         Rz+c88Vju+YomHtLDeJRs5ah93AVAuP8f2XdJFYoc27LqQIrKG7fW6ClUO/KIiC8X8Aa
         cYzu3MGAmZcfv9gv86WkwOJqLwCIqCFBbq4x23QA+rCbZUrmRMINE0qVwssRII5FqEyf
         fnB0hoTlcNrNbLCuIY9j1LAINM2pJvH3wp6xtmjHjSGlRUIcI14c29hPx+75IXd2ouwH
         6eMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197121; x=1793801921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uhged07YjYHVSfrcQ8AV5LddG8+yWyQJ6mwgUwS9Twg=;
        b=Uh+Ix+PvzSDJNh4etJExv3VNy5/7POML+yeK4OO+c2fbesyXST2nQEaT2iw17Nqu06
         mjvVgd/sXbZKTOKOo5wF6iqOxSq1kW5NdggmF1k91qXCgH9V3Z869WqCSIa1aLJbj1Ey
         epfM4LtF0tAO2sXC0T5eY+3R3JGAHBNWCKx9zKT0GVf5br9/8r7JGBugKN8HIg0NzkiS
         EGwHoNX/2KILcATW3TbSpHxwcQRcbbtOgvwqtePsbBUwaNA8LDOIbtsnCooXT5P1FchC
         ESKobjLXyGKtygjGC1JIk8jLuzX74eFsCnndsLuyrRf9nj50TkE4gwsI23I+K5uW8boa
         kNnw==
X-Forwarded-Encrypted: i=1; AKwUvBzPaMv2bJStQXDwMZZ92W1Vkvfd/7itx0TaGMOXE7nsVW9RD2ft2SBs7uphAR9lM22UpDrdiKWBNXoi8KuB/g==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6iPJv3JwCpw+XsJsKIXCYo8fB2qzvc5VnJmOqCb03zVgrh/02
	kPdHhqBjQYMud85s82eK1KTuwbTk1G3kgsILlWmaKz5OaTckrOha4g3B
X-Gm-Gg: AYBFou3KCjqKxwcF+n0tKqjcvOPcpQi74r8vdam98+PbhD6WRIjf/hp1ZKMpahph5qT
	ja0CCvz1wsJ165j5ltiNH9yFl7uxupSXPJLI5m0H60egd2krntLvl5gJUc1MD5gPNw83zMEMxA7
	D4bZjeAG5BNJ98hqU+ijgAbY1OUacE/XUry6WgwzeTKORkscb6VmyqC44XaI+flId9tvCBjV7mM
	KFbgyid+c0JbPe12nYXTU+FF754gLJqY0PyCaskg6lD/ZwM9sax/u5USHBrZDMBmBus4cdLmJQE
	NMCBHuUZpsb9Ob61VpAWiJCo+bsWD5uxuI3Xq+533LrF8CAFHbMqP7u7Z4rXoMe+usqJrArntyN
	+cWKBITochBsEiqs942YwHe9+RAJUFs4TbYVhlGEDE1DyjSK92EFfQ/aHHoexGLyoHZPDbL8W+m
	taToCwalpX/sw9DM2YJ7uyV8lBTlTYP2uhmtb6vcvoIN+zN1w06LwuIQwv7PUxn6P5BKoQTfyQL
	XlFaq2jK2bKrAG6r+yt2sjbhjcr226aU3fm/e48/rNIHLK/BN1Ifh8fUg7eP5yfAVaphrvKdEl9
	68R3UPsOghEJBGYF0m/HOd77OJ8JLc+hJx+JCBa+9ML/3kx49Weso56DnwLB7iArpiKB
X-Received: by 2002:a17:90b:2c85:b0:3ad:8769:8741 with SMTP id 98e67ed59e1d1-3ae57e4207emr2104742a91.4.1793197120513;
        Wed, 28 Oct 2026 07:18:40 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a0482e9sm3437223a91.0.2026.10.28.07.18.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:18:40 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Linmao Li <lilinmao@kylinos.cn>,
	Kees Cook <kees+treewide@kernel.org>,
	Rosen Penev <rosenp@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] wifi: nxpwifi: fix AP channel-switch lifetime and failures
Date: Wed, 28 Oct 2026 22:18:15 +0800
Message-ID: <20261028141819.7556-1-enderaoelyther@gmail.com>
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

NXPWIFI retains request-owned beacon buffers for delayed AP channel-switch
work. Once the nl80211 request is released, the IE parser can read freed
memory and copy stale bytes into management-IE commands sent to firmware.

Deep-copy that beacon data, cancel pending work when the AP stops, defer
blocking AP traffic until switch preparation succeeds, and stop the
interface when delayed work cannot complete the switch.

The series was not run on IW61x hardware. Testing from IW61x users would
be helpful. All four patches apply without changes to v7.3. Patch 3 has
144 hunk-body lines with context, above the stable tree's 100-line limit,
so patches 3 and 4 need a smaller reviewed backport.
LLM assistance was used to review this series.

Zhao Li (4):
  wifi: nxpwifi: cancel channel switch work on teardown
  wifi: nxpwifi: stop AP TX after preparing channel switch
  wifi: nxpwifi: own beacon data used by channel switch work
  wifi: nxpwifi: stop AP when delayed channel switch fails

 drivers/net/wireless/nxp/nxpwifi/11h.c      | 22 ++++--
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 74 ++++++++++++++++++---
 drivers/net/wireless/nxp/nxpwifi/main.h     |  2 +-
 3 files changed, 81 insertions(+), 17 deletions(-)


base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

