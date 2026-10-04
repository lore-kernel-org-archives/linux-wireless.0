Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271E3EC835
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791107127; cv=none; b=L3kDeEzAQu+jDvIXd0RKCRiG+UupjWZDf6Xg+W1MTvoDDCD6CR41HeZAMGlGQ7yw3A7ISEdCAyLw/qj+d9yPGDWJTe4xYLM+24tx7aBY7Owa6LKznf4J0/30QMFC8qC9VvCKx7nW8LPC1ALXt0CapzPvvrPLoWi1vSbr3lMIcu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791107127; c=relaxed/simple;
	bh=INRGB+/ti9rjpjFdoKVgunKwtrTAl+XMQ4DCWtMzBgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFKA6MY4scPCP8ozhqZmLZgjq1ybUWThILMgN4HjPyZovBxQ+mIBdrCKJPfvjYGKcX+SeYxJhtEoYg6ScnV5vrWKv0bk3BupZpDVqhm6ZBLDV/l7qO0lmcwvZ/eFtu0uPRrAO+cOrsl34RKU2y1I9NpdKcfH63PTOSNpxd63LzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hGTA3+oh; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hGTA3+oh"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc73a80ede5so243818a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791107119; x=1791711919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JoFX+YMXd60kpER0QJajp4LEvvy2XvMbrnb9b5wYktk=;
        b=mW9keK5m49wVx+N3jhuzqdnwRLTAgWoSSMVPd13joFydmagz656XF5E7YqrlVftX81
         YrK0ZLoS0NRtzTwSPfqav2P5X0VPy94veiSNUAWVelTg2fryplq+SG5wt78qCMUPuscc
         x9RDIxkLa96y2ixlTVqi04o9JtaLFxC042BJuae5YjRDPP3DpcWT0YULpGLaUbOPwJCb
         jDn8CK9WnDSsItbcdIGsjKASAvh2wpLwWdefiIrb4x28GwW9D0kxKxYWExy7Dim2k2ol
         UzP/Rhv8m58hwz8DQdE8NL0fA/Zqc0KQrl0xb/liRatrXan0elRU+AgqF8H3nIGZXIUZ
         pOyA==
X-Forwarded-Encrypted: i=1; AKwUvBxoomPVJJTZGrNUPR/hR51Opf5UOGCUKWeRVrj86etB+/W9u33p2F7JquadTyicS5Dfxb5m9PFgtzfxFbbzzg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKVIxbFzLvpbPPSL/wNYcZ01L/d0WI5KWRZtpC6YA1k/bhdZ1mS
	L+m8edamcqoSrGCnfObE2FembZcxOBUIi3HktQK+iDEvbBes7HW1qQh0B/hcznYkSs9vz0jZ65X
	EggkjteQ/Lh/cBgNybMRJ9NmbHrGwaSIXdzmNQVCnPMgq9hxrg8Znw4XbK+/9pM1C1Hj9tX90Db
	m7DWKbLR4J+Wis11lRIk8xoKSq3NAcMwojn/uo0yGlvCLPDnBCyDzVK3PssgKA2u5oB3O7IIY7e
	yRGi4ByGIhgov+J6qC/UGYgWE+9
X-Gm-Gg: AYBFou03otHpeOs6X7sWTsEXUJg6xNk4sRhg6QkeOR1z8r86EYgHG08UG9NZwnD/fat
	y0Qe+LRjAEunww/5q3QNXk4U1gouheYEFDZP/CH3KuyIve7ETP8t4D6TOnKOiAkjZim+nm8qtR/
	S0fD7qmcpTDGcggVan2UcijcS1wT3Ml+xoWx1onNaCSTtlNEeK+cKhToOOvUaL78IShfMsLN5mf
	jF1iZwRCB1aKD+YL/0Qbfy4+8lRp4apBO8oHIG2ywyD0vcGFiVxBlTQ8Q1L6/FayLlLiya3tTUK
	77YoLPkBJJePFevD0vm4yNuxNNIq5ZXl9xpslzFG6zenZHkB2bkQACZJvftf6k7qHsZH3z/g9M1
	OVNHTaKTOEzs19n1f0KxBIzav8ECKNnYb4qpp3o/5cvZnuzYtZQV4DTZnxYnFcAG/WUAiTsW7cq
	RoRAqkgoefsUnoa6knRjvgT38eBX4yE/fjSB8toQQ=
X-Received: by 2002:a17:90b:164b:b0:3a5:3f7:27f with SMTP id 98e67ed59e1d1-3a7877767f2mr3286967a91.66.1791107119023;
        Sun, 04 Oct 2026 02:45:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a78e49134asm2497682a91.6.2026.10.04.02.45.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 02:45:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1383723dfddso1245632c88.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791107117; x=1791711917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JoFX+YMXd60kpER0QJajp4LEvvy2XvMbrnb9b5wYktk=;
        b=hGTA3+ohXjmQXWkgkJ1FSUXtIYSaLjwbYi7/V6POhMa5V6Ya2PaezWpFwkrfkEywvj
         tSEwYdmkB5ZJHbaB/NDv9qdxAnhz4V1xiDRIpCCJmZgqn6nA3768XqS6q6YbhKEm1pmZ
         yQSB7IbmLiGZ91AprMVlvQzksM25uQcDJ5f6A=
X-Forwarded-Encrypted: i=1; AKwUvBy5iMq0aCVSdMqEPLsP/IWdYlO87AI71R6vLHfoXTJhXgww0/ONH6WNnOu8uvoFVWfRSMdgYsddO83YZJKNiw==@vger.kernel.org
X-Received: by 2002:a05:7022:eb42:20b0:144:fc5b:2121 with SMTP id a92af1059eb24-151c30ec64cmr5879791c88.17.1791107116957;
        Sun, 04 Oct 2026 02:45:16 -0700 (PDT)
X-Received: by 2002:a05:7022:eb42:20b0:144:fc5b:2121 with SMTP id a92af1059eb24-151c30ec64cmr5879764c88.17.1791107116264;
        Sun, 04 Oct 2026 02:45:16 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fcec9a95sm12736954c88.15.2026.10.04.02.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:45:15 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kernel@collabora.com,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH wireless-next v2] wifi: brcmfmac: Improve D3 substate entering timeout handling
Date: Sun,  4 Oct 2026 02:45:10 -0700
Message-ID: <20261004094510.1323851-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260915-brcmfmac-bcm43752-suspend-fix-v2-1-1bd84914998b@collabora.com>
References: <20260915-brcmfmac-bcm43752-suspend-fix-v2-1-1bd84914998b@collabora.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 15 Sep 2026 02:50:39 +0200, Sebastian Reichel wrote:
> Some firmwares (e.g. BCM43752) do not service the D3_INFORM mailbox
> handshake when idle, so the D3 ACK never arrives. If WoWL is not armed
> the device is going to be powered off during system suspend and
> re-probed on resume anyway (brcmf_pcie_pm_leave_D3() handles that), so
> the missing ACK is harmless and must not abort the whole system suspend.
> When WoWL is active the device has to stay powered with its state
> preserved, so keep treating the timeout as fatal.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
