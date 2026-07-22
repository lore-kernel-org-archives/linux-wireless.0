Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9134BCAB2
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 11:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784718443; cv=none; b=JfuPkTuF0d1Ww/sYNpHPSQ+SIiMH+vgfGMFnLnWU3QpnSS49WR66YgOEPgCBNtH0I+zK3o2SfUAoSsFdDzN1EavzjNEKNUfhi4fEvGg8ddbSgU/j/zved5V1QHbXY+Y8xdYNzPqu7Hf4st6meTdKzYE6mWCjF2IqmJRD1/LX9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784718443; c=relaxed/simple;
	bh=Gvq8bn9U5dieapHENn6/tVPX84MtSWPT3qgQXTSmcc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Eg7UCLlPsEP6MBH2tMAhQIlkJsLVj60WhWOwc7FRyahxYk57sxw3DiORlWTuvjaYiVAEQqkUV1Lqzq5s4CLI2F+aNvx9fLOc80Ubgmke8LJuVnjMlaVipQBpZwwX9ZGc566QbbLpDYDHarFyQk94cqsqR2hQxKdGBu1y7lsnJVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=nhul7KZ5; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="nhul7KZ5"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca7c1176317so9113211a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 04:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1784718441; x=1785323241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pn78C/RraBqASlFsZzfGipH4Pd/7ButyH44MMOGEmn8=;
        b=nhul7KZ5qD0HjlCk6J4jD9jUHvB5LRm5qIKfGa2iyt3dnJS4hHWlwHcQyqMc0o4Ds+
         hxr2Nyg8o6004vR3tGdZFJEOuq2A9HE9NdzkWg2KD4i8kjndLQ/vqqkD/oDLFT25gqfE
         vfQg4asLj3/S463ZVccc+dRF9/EXrKEwwhyQIlr5ZwRLtS8er5Ps3MEQZuVXiMCLChmF
         Lp4Z0SwpTNZUT9JD5LZL5khVzTQbEoJVHe8R6DtlQ/RCaS3/YtG3O1yOI+zyrbpKsLWZ
         3QZVQW2GP/z2BGxOAzXUcg39RCtlRPeGhP2A8RnSVzohQ0UcGTKlD7XKZPCO0GMF8YUX
         vEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784718441; x=1785323241;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pn78C/RraBqASlFsZzfGipH4Pd/7ButyH44MMOGEmn8=;
        b=VKS+DTd3xu/XYQqergJX3RuYmUWvtkopaGTsntCrX4hKtumG45+fw9KOvASduPSmpC
         R365T6TnJlkYTt93lHRixHKI0kEAuMrUX7kDAint88yJu1EC2NnDYWeTcqAOhyk+YgRy
         t6YFIYpXdzGyt9hJpdtX3wYiDA+sz8D34rbqNoKBNaxBPiGR2YGnihcw2oZIXl6DJpdf
         9Nzm/m9JWsRYLlqWtNygVI8YvopmctvQYoUVq5EtqgNwBd37M+fWjiMgJTYezIvuSlQg
         dvutMX1fgpbVX74ng72AbI0y0NhGnrKklJU5UiBcpbGRCCER6QL1StYW9fulJotYKkKW
         Styw==
X-Forwarded-Encrypted: i=1; AHgh+Rq6/EhXSK52EB6PI5kcMaWbuWlJWaVPIp11skwpTts0Jsc68M97sRAwD6jftdZMAybO8PrLEZ2smSBolcOeUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8HolmjU+/EJGesaQgXxdFFpjotfWAEtsFdpj1BylOEtDDJQSu
	QBLw/nRQMLZmOykQTsBVhfhfr/ClVlIdurraQbzudvl/v0Y9VH1vkNXHfEbhiPb7pQM=
X-Gm-Gg: AR+sD13j9M6aLKsIT3xXYKweRNExbNak5PyhRbLncmVqoG64O9/+5GbF9/D0PchbUjm
	IPlLxS9Yhl9uHfhvjGYLnBkwI83UhQdrL3ZJmlfefCl7f//nwmXqY2hMdEBM9ZpzY+Q8b/Hfk8g
	i83nP6e6qKZ31IsKG27LXX+6nLtAVcxVFiJF2mJavV2XaOL6t5SjVKDSqVE7IqFA8CdLhk4OI5X
	4v8Ipo8xx93M7KgXOlwqAewfrYq6zYLs+2+H9Gcec6jZUMmZRmUXiQUue7fk9Clh1MTG+Q3Byqo
	RDyopdu/pjUkvFuljEtByN2YigVWv3DpmYfH/SLKM02TL2oMDF6hyV2uhUbCcQur5SYCLfRrsbH
	jIp7q3F8cru77AfKORkln81NQQOM5AVFCFgO70/v3MwxZi8PWdp0Y1NwtJEdOfJmrCchxAtRAsy
	mwgOaaOeqL6Ico3Y2uEMFzGmL+a7ga4KN1k67FGdcpbmWUDyAqsEezon5eJLkBauPfyhVavGvif
	7zrqdnMHrRSzd/L+gpc/37JIazDWZEa
X-Received: by 2002:a05:6a21:b94:b0:3bc:5284:5445 with SMTP id adf61e73a8af0-3c3ad7d7fc8mr25322681637.21.1784718441385;
        Wed, 22 Jul 2026 04:07:21 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-3147e07000fsm15952879eec.21.2026.07.22.04.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 04:07:20 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: arend.vanspriel@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Wed, 22 Jul 2026 16:37:12 +0530
Message-ID: <20260722110713.115988-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated for buf is not freed in some of the error paths in
brcmf_sdio_read_control(). Fix that by adding vfree() calls.

Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b725c64e5b5c..0900211ba2fe 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1792,6 +1792,7 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
 		brcmf_sdio_rxfail(bus, false, false);
+		vfree(buf);
 		goto done;
 	}
 
@@ -1800,6 +1801,7 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdio_rxfail(bus, false, false);
+		vfree(buf);
 		goto done;
 	}
 
@@ -1813,6 +1815,7 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 			  rdlen, sdret);
 		bus->sdcnt.rxc_errors++;
 		brcmf_sdio_rxfail(bus, true, true);
+		vfree(buf);
 		goto done;
 	} else
 		memcpy(buf + BRCMF_FIRSTREAD, rbuf, rdlen);
-- 
2.43.0

