Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F9557C732
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790196206; cv=none; b=KPfNiejQIrjT4YhmC/UeUGrgQ+sIAAgnDS7UOr8OSTps3hN88aUnBzew1IH7TkGEy18YAcymBoqzP3qB42dNXe5XWjzPENh5vPVAsF32ys15nAPnPzBONtHpVxGhX0gcBQAheGqc7eGodqVkqYs35dbWZ3rhkYr/70H8i0+VjPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790196206; c=relaxed/simple;
	bh=MkdxfzNK3Aw/xczi5euKuiD+ogoT8JhdeeYotSXEeEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqBIW8T++KtSjcQAQ/9SiFlGAPNlMLs8aqVW7LhY7+jqwZRIzo0IeK0SYCkYzJ5K85PSbE00OMf/l3XcfoAArQYjBZl8tF4Fbx4SCvTXXTzxywp1HXuvRmjXOlh7Xv2BXuhWCHXtEL0AXjoRSVWhcRz/8UtvhILcWsCAGwQOBW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=mhs4PXU+; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="mhs4PXU+"
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B7C123F32D
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1790196202;
	bh=E0S4RGo400gWyKWjQ6KReY99+fLF22ntkggQIWdD5/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=mhs4PXU+tDH9wva3U5RbhCrybJyUwyl41YVnGyVu/wLKoevIOZvd/AONgk5kfp9lV
	 61U4b61JbLWVsfi2YUq/ZguUm5swQRXSnihSqgqj2B1nXw9whv4+PJxdOfM3FiIaVN
	 9E4bHFn/dz6DS37uro86bh03A0/ZTiWqSlVa08QkEVod23Ficxzwh4mRZ8ypwMaxJp
	 UqKQsXFPzjyQGgaas1Qfc8tfHw2xciLSvOuh7XSRKECubizKgbGTweX9L3PI1mvKAC
	 xA015E0PU76bEdx5r3yfXDQVrFgWx3crhGK1NrhJQB5R8ZWnCzB5gDY+4b3MxbKJB5
	 5NRQcnvHeGOvw/Lx5WzipgMg3+PZbr2cPciBj3ZNE1HQFXvfmSixPQtC5sWYzEv5b9
	 MVggwLwMZGShr4A8KLusY8dJf06KKlG6HlOoQtbsPO+0Cu0zfM03X1e+5lVWoPrNzQ
	 j0OaZAtiOntUguLNWbf5igxLvfh1dNMCZVGfJYQK+sJDOUp3j1607a7wobr9PT1et7
	 LW7xq8iAz5RGyksBCs0UDkzv1EudpXbktT7zZBO0X9vLucO+4wT5BC0VfY8x5jaE0z
	 flpCMUlk/y/iEnNEMVo0FiwdlCI7COBQT/I1K8U5vUyN/5/SyRzr4Rxb6ToJOdilTt
	 uOGfHr36QENiZaq56WuvD3kk=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c293bac1764so145761766b.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790196202; x=1790801002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E0S4RGo400gWyKWjQ6KReY99+fLF22ntkggQIWdD5/A=;
        b=j/xsCwMWkab1UXXHqP4pG7YqxjdArXvVPs536e/jieWsOhLtWJG5QFObo0rHQvmmFx
         NPd/AvVCXdU5/VNw+UI7kt66FeywpGokl2AMQ+mja66fdvY4zu5hzISJhO1EEAD7V54s
         RDzgdir0ytnExZlzj3Kum3pgiVa4N3uaFk816YsNzRCzMhgQxo33PS5l5Ii0gNUZDU6a
         l0JrQe83wXkJyPTiihlF/8KIi//tHvDN6OGXsrzMLVX7UllN6l3/XrR5R/b3zggDK9s5
         CEI/JgsVuiLP29EZ0ikrGk60b+rk7rWmypZqYPNJ29MOvOd8LAtorLElJ0NcfEAJb9RK
         LYbQ==
X-Gm-Message-State: AFuF++lcp1L2zq2cNax49X/9e30c7Do0f/y1rNLfKZEdtwMtSTp3sFY3
	QsKi/4ckLdbqXQZd8ZDil3qf4LVNkLdLzqqyqcQE6swUwxaf/w+voSLYn7rxY0a0JZciEMJHmkV
	EegBTVY7u3AfkgXgXmQZtu/NFYCWbmd1FI+aTvdEj8crzcfJoHZrAKv/0+she87gBrE56pozHix
	oFefF/4Ahw
X-Gm-Gg: AYBFou2zaMSC9k4nFG2qXLYFjjFk1S6nj2ys4G6ESHZdxpZr4d9nTH3qJUqs7FGMyvT
	N8QaYrshIu1oHOso5v/FLRuvDzvW4jMsWIplyhDLMJ788zmt/Vj1dHNvJ5JcCWMbjwvXr2J+sGA
	0hftw2En11C97rvyPKkeaAk3TGoOg1UqjoVEMMqdRrMH/s02TQJ+vmS/XXD7wmIvC5EZ+30upLJ
	iOZIh5N6UR98xK4PKx3rwbKz0fcArmqLNNFYip4cWNUxEaEhYcXKF6/Kyly2gsNdCBUdyqicTNz
	CW6XdlwiIsO2Jhsn3vSHf6FajWB3GXaLF8q1xzWkt2eDwC/urZ1TkJVb7GM1cQK2zhtUcXZKInq
	5I+Tx8Ug0lSbwFvNjnP+1ryZ0rQJK3OOc5aMXva+j/4sSom0h+KIVi/XzhFEpGN8MQJVd9QsD
X-Received: by 2002:a17:906:f588:b0:c2a:6c3:9e98 with SMTP id a640c23a62f3a-c2ac22a7cf7mr23776166b.40.1790196202380;
        Wed, 23 Sep 2026 13:43:22 -0700 (PDT)
X-Received: by 2002:a17:906:f588:b0:c2a:6c3:9e98 with SMTP id a640c23a62f3a-c2ac22a7cf7mr23775766b.40.1790196202124;
        Wed, 23 Sep 2026 13:43:22 -0700 (PDT)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2aae6a4a00sm185431466b.46.2026.09.23.13.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 13:43:21 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Matthias Brugger <mbrugger@suse.com>,
	Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 2/2] wifi: brcmfmac: Add clm_blob firmware for brcmfmac43456-sdio
Date: Wed, 23 Sep 2026 22:37:39 +0200
Message-ID: <20260923203739.2560527-3-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923203739.2560527-1-benjamin.drung@canonical.com>
References: <20260923203739.2560527-1-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Ubuntu 26.10 these firmware file are missing inside the initrd when
including the brcmfmac kernel module:

```
/usr/lib/firmware/brcm/brcmfmac43436-sdio.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob.zst
```

So include the clm_blob firmware file for brcmfmac43456-sdio similar to
the other firmware files.

Bug-Ubuntu: https://launchpad.net/bugs/2168109
Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3cff0f1fe25f..cea52d408817 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -618,7 +618,7 @@ BRCMF_FW_CLM_DEF(43430A1, "brcmfmac43430-sdio");
 BRCMF_FW_DEF(43430B0, "brcmfmac43430b0-sdio");
 BRCMF_FW_CLM_DEF(43439, "brcmfmac43439-sdio");
 BRCMF_FW_CLM_DEF(43455, "brcmfmac43455-sdio");
-BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
+BRCMF_FW_CLM_DEF(43456, "brcmfmac43456-sdio");
 BRCMF_FW_CLM_DEF(4354, "brcmfmac4354-sdio");
 BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-sdio");
 BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
-- 
2.53.0

