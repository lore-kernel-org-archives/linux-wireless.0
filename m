Received: from mail-qt1-f225.google.com (mail-qt1-f225.google.com [209.85.160.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEE6451049
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249978; cv=none; b=t3GLYKijD/7JxeUP8I2dyVIKh7k03oAonnuX+VSzq1Nf0WGg8m+791n9vi9F59oBBraVt7O4FmBMaQR8edffiNAHS6zRvvcZHjix0X8jazKRXmwDPYkwRUCGAjBDJt/8moyBogxoc1zr1+ao3N1MIWoGzuZwVJt/KyK/5fXN8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249978; c=relaxed/simple;
	bh=YN70RHjCwmQ83vx3SX+04RYNQVnGpUEZQcVazfzYY2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrVEwXhQc4rYWavx1dXnbH8PyTjfZ/1qQUnxw315q3SItCHnoNGcajrmh81rKVql1FKzDO4/KlIScHmDoTrYKXeTE58eWH2loiPAKiqfau0MB9TnoF5N7U/5TCZaYqVyPEGLgv4STOgLbbdXehBqx2QWt1evO5VeoCTeTYvDn/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VpesBTO0; arc=none smtp.client-ip=209.85.160.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VpesBTO0"
Received: by mail-qt1-f225.google.com with SMTP id d75a77b69052e-51c04bf4711so38058971cf.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249976; x=1785854776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mAAQLzPAI07RqkNYsgKLJ0dCN5z/oc54+anUQNCXX8=;
        b=cq1TdsasQMyUAxusIJknKA2P5v3IK1fRcnnzjXHeXDZFfbdKQMcmD2k9f7WPS9alP3
         wyHLJuoZAaVUnJwblpvSPgOY/hjNiHxMGnAtGRk8mSe2jgv63ef2zcW+p81uOHJLAg5+
         1xMgQPAa/Fvoqcz3BPMGtJzuarAyDdHXI0nyNe8s/ypilJpROtqIeGyYX8bhFTu8u6h0
         LA8EkF/XRlYffP8UDpjZv7VXjhG5u1XotoRlszqNIWNG8bz3Q53UyoU4kSYqcn8y2yBl
         ABCmwrANPn8E7ZvVXxTWgSBZaNUTzhDiFzhjrFclNFUDuHJIqOBHvq08S71gBfL3b6Er
         NNYg==
X-Gm-Message-State: AOJu0Yw84rAR+J9TQo1PA6kMoWpz5jKzt59myjnlnBFN4bjopxlJ6BK0
	lMW5vM7t1x9msovBhhkDYah+Ptq6wi+4GPFfpy5YMikWv5/DQlq2dZ+5dr2i0PG7Cr+bx8wQYK0
	hMFmxzMy0B/G56mCAhmbCKiqFmDRb2bVZ8hfaGUu/sAKCEI/kPf/OHMwsaM7BYI/vy/8ueehqSi
	KoeLvLawh44NSzqo16BbCSPWozQxCTJdGjvxq1cnUzRcsIGhM7fz363TAeTfSTdLIpJSuJGWoi7
	JbjV17cLF6USYxpyKTShWMtNX88
X-Gm-Gg: AR+sD137R12v3Ioehx+csWQdQ+QdaNOvvhaAFWKoI3MZLJtc2M14nmMr3rvewfPSB0w
	J5nbhA2LFKP8GBC1YBKfQznznmUFUYsTN4737edUttz3jX6Zg9EH+a0HdzruMnNSSSYaYL5g1vd
	RYW3YUfj8B2NwW/6HVFWxIi4VSqU6vu8GFzJwbsGyo30eczhxVeqD9Red12FfHmlrIOgHa0fyzF
	OW60RCqXWGv/5Gf0oYPHQ5Sg8heT9r1SDChU1kuNINRak0SxW6+4LqaelnKMlZpMELT1Gq5yNrQ
	0S/tnGg+AnZRz6BDUQUJC5urTB2NVvoNvrEdMH8NbJbNrcnxLWtybHeUCjEj+igeURJ2lnSlgm/
	hatWaZwlMAd2YGJKFZp5JmJUfkH0OXLoOCXM0fDoztXPNju/CNnvnsVDaenb8Hu3eTYLlgQQWPj
	4i+OjNwzKfL3wT2UXGqZM6icXeSDFVzbZCgfei0YI=
X-Received: by 2002:a05:622a:4d47:b0:514:9ece:a15a with SMTP id d75a77b69052e-529d70e4c86mr26461881cf.45.1785249976129;
        Tue, 28 Jul 2026 07:46:16 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-529a29ccdc1sm2441341cf.27.2026.07.28.07.46.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:16 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92ec3146553so759777885a.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249975; x=1785854775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9mAAQLzPAI07RqkNYsgKLJ0dCN5z/oc54+anUQNCXX8=;
        b=VpesBTO0Sg3OaULMXsNAYxN4pLWFaZLcFq7D5QBDbUY+Rt7ewZPO3rwGKhdUkWtT+R
         0475gxZkRFniaiuDEAc3dn+OCffDETtS81n6fVMaKFVvjNaekhdn0G0hGH90LGQkFWl1
         VGHFFnTcwdyZqZ4kUr74Cz7fLrWv5Z8AO871I=
X-Received: by 2002:a05:620a:2993:b0:92e:6b16:6a0a with SMTP id af79cd13be357-933026c9378mr252094085a.40.1785249975384;
        Tue, 28 Jul 2026 07:46:15 -0700 (PDT)
X-Received: by 2002:a05:620a:2993:b0:92e:6b16:6a0a with SMTP id af79cd13be357-933026c9378mr252090485a.40.1785249974891;
        Tue, 28 Jul 2026 07:46:14 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:13 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 09/12] wifi: qtnfmac: use pre-assigned cookie for mgmt_tx
Date: Tue, 28 Jul 2026 16:45:46 +0200
Message-ID: <20260728144549.2207061-10-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop overwriting *cookie with a random value in qtnf_mgmt_tx(). The
internal firmware frame identifier (short_cookie) is unchanged.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 9e44c85d2051..284bc61c46d0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -454,8 +454,6 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	u16 flags = 0;
 	u16 freq;
 
-	*cookie = short_cookie;
-
 	if (params->offchan)
 		flags |= QLINK_FRAME_TX_FLAG_OFFCHAN;
 
-- 
2.54.0

