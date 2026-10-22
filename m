Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792697029;
	b=BGIGERmQdV4ndg5duJXkT4MGL8lQsuggQ14WpUpo0t1w4hM2liySrzZ+/eBD+/sEXKH7
	 E/oNyOTLaq5LKkpYGd+VT/yGpm8Tj7COZ+vueQsbZ3u70KgOQG6UTO6pgZaAZIJ2A7laC
	 x3dtR9uDtNceIVfvUL5PrRthEJNUsegepvT5Z93iRt5rAGqdDytmRv9sQg5uipORg2yHT
	 kqHKgdJT4kOcpYY0hsqKnKyQvoeU+8Im3Xrdbb8xAFTSjKMZPQE+mzwlIxB81+Z4+sJ6O
	 TiKcGY7k1Qnc4E7hZrB4EozcXgb8EEM9LEyPbKV76Gs8nsxCrk3F5bnP8mQwieIlbGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697029;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mWyRbyYobbwew4V6IGeQkBhZcI3WNmI+oWsGUUslDMk=;
	b=Ntpx+yGqU2+BzVy7ibyHCaF0ozAhAEqOrq2vt/LnTyG6C8U/3o4v4O4KCnkKSO6Oezec
	 T9HTl82tlDyuyQKYxtHGCzZ4LUhvnRexPgP5YAq7Sfs72UQ+5IBgVW2rgxiRVQZHWXpyY
	 yHFOCsz+o1DsMWYcdyhK5TraMwkVkoK5/8MrqWDkD0hbc5kKG/j0isPmInzxyBsb3/JQ8
	 7kEjOME2SnlVBJeMzdaxPi/orvYgvcmSJkWBEPAk1Du6ygeiMJ0pub4igRMotSLN54zLI
	 VC9n6zXq1+xn0HQJ7Hc7oqgD1YQqXUCBdaLNpVqbWP1U3HWuFfW6+Micrk2tWyTPaXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f2aWndYO;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F50606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1F50606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f2aWndYO
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so90395a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 12:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792697028; x=1793301828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mWyRbyYobbwew4V6IGeQkBhZcI3WNmI+oWsGUUslDMk=;
        b=f2aWndYOi0BcQtBJ/P4f0GNsHNQutqimzrnIgfZZhby1J0ouHPMov00i5R57dbvV71
         yws5H/5pTjO8znLBTEfLWLI0dPqMPn1+jbyGunxMZcuoUrKXpq5fUTvgX8a2DJwNou84
         Rnqvvhi/UTkyeNFaJwb3m/5sk3GITBCyHcHEFyf5ae8k1jiHoPFPpjfAvBzbAoUj1pyA
         mb2CcfMfaWjjwk93qTqqRNXC/6yk9yQg+zlI1dxah1tPnvxO8D6KzReAX262NrRGN+Sv
         mPygRLcSDb4wJVmsAqmMlt1icXaHC0/gtQXiQr/l46h4m43go5D4YhN67eQtdLBC5Dat
         gCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792697028; x=1793301828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mWyRbyYobbwew4V6IGeQkBhZcI3WNmI+oWsGUUslDMk=;
        b=aKYVWoyrmnVAfeE8V3+82iswgCDi/w8CRorsdT8KADe46NyIlABnQzEo38CwXRt3xB
         2c7dt05CUDX+peby2Ai3OqTR87hSDxONxUw3TF1lU8kSPemtj2vRMkMAUS+TRJ0DImpX
         v7YvybHfphTYyVKTCd/pFmAL4qQjmjAbqa22VFjs23BsUjI2deJn1SSYzprLpNatphs5
         DPuyI8IF1qfXQn5I22gXANIpiEOLVfUcWMKhN3sSq5QVH30cWfJRjxaT9QLnEk1ojYry
         x/jj7a3HTmzOnIId+6LSuojufcV0N8QQJju5O1Ys4QsO3bNmABJcbcbaHJOxwm7gdbiU
         TK8Q==
X-Gm-Message-State: AFq9FYJTWx6pfX2KNnIMsChqlmoTTLMDcaNp2Qmkk5iKTJlu+tbxFx2A
	gsd+p4bWk4ka3gXNTccvgBgJFAunb4WMRZoTXTqbSOkaWGKPUBksYXVZFBihu1f7
X-Gm-Gg: AYBFou3riRABiUfjOZUxbw2Dvir+k+zXtmKme5o34ct91J05KgGIwq4WJ3kDiNRsIcm
	VX4ppS3Xkxpe/hR9uQHOHIU5l1DaQraWO267lbDZAmQ54jbLk28AmNH5kTuY6sZjTSbJqvzcNNw
	xTqf27XFtPO0u5I37iW7lLKWeOrsatoG+UL+rGsWomjn7sGaOabuTfxUXC3oIHDcxWw/I3tGlpk
	kXSqrcDFsh8o4cl0gipPGYw1jgsslLOwGcMatdCJdU01TUoUuVL8zZ+L+/fgXnbFCD2cnkVHFSn
	eALTGT7xfMGx4K20it97QhK2+wrKiAE0ZzD0oUNBScDzwVhnLFhAG6cfIGPxMeOXM47Fr2bxfnH
	bh/UWhvhxyTws746Z/hCFNGRjLtN4zz6bYvcvn5ckB07I+3zIyBI6wRZP7Ino7tofHSOD3fAJ0J
	C7Wc8s5XGlJQxspG3/b+hrR7epEDh5IrKhelTGkySUKRBbbaoJ09b7z9ndaYBeKoa1+X9k7+R6k
	UvMx4pxpq7RPCK8Lrz0O68bLFxmgJNd/7jciFYUvtcv8sDz0R09GWAfxt3bD15UPb6WUT9LHDUz
	96QZjTf8fiYkEY7TlNQVzPZrAsHb4W5e/EVW8yk6/rGJ9hqG2p/nu5cpT9fP3KmAyiGRLzd1wul
	216+QNuBtt6D/2GgMnbAh0qUrtEpX
X-Received: by 2002:a17:90b:4c52:b0:3ac:80dc:f409 with SMTP id 98e67ed59e1d1-3ad86f39201mr4606639a91.61.1792697028146;
        Thu, 22 Oct 2026 12:23:48 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed6c0sm5532585a91.6.2026.10.22.12.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 12:23:47 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: don't read the LPF bandwidth on N-PHY rev 3-6 for TX calibration
Date: Thu, 22 Oct 2026 12:23:46 -0700
Message-ID: <20261022192346.3327061-1-rosenp@gmail.com>
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

b43_nphy_tx_cal_phy_setup() reads the LPF bandwidth control from the RF
sequence table on all N-PHY revisions from 3 on, but only uses it on
rev 7 and later, as brcmsmac only reads it there. On a BCM4716 with an
N-PHY rev 5 (ASUS RT-N16), the read causes a data bus error, so the
TX IQ/LO calibration oopses there.

b43 does not run that calibration on these revisions yet, as
nphy->perical is 2, so this only shows when it is called. Read the LPF
bandwidth control only where it is used. With this, the calibration
runs and returns success on the RT-N16.

Fixes: 40c68f20e63c ("b43; N-PHY: write most of the missing code for revs 7+")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 22359bd9db47..41a8ba8e8736 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5108,13 +5108,16 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 		b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x0001);
 		b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x0001);
 
-		tmp = b43_nphy_read_lpf_ctl(dev, 0);
-		if (phy->rev >= 19)
+		/* The RF sequence table of older revisions is shorter */
+		if (phy->rev >= 19) {
+			tmp = b43_nphy_read_lpf_ctl(dev, 0);
 			b43_nphy_rf_ctl_override_rev19(dev, 0x80, tmp, 0, false,
 						       1);
-		else if (phy->rev >= 7)
+		} else if (phy->rev >= 7) {
+			tmp = b43_nphy_read_lpf_ctl(dev, 0);
 			b43_nphy_rf_ctl_override_rev7(dev, 0x80, tmp, 0, false,
 						      1);
+		}
 
 		if (nphy->use_int_tx_iq_lo_cal && true /* FIXME */) {
 			if (phy->rev >= 19) {
-- 
2.56.0

