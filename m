Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D759501289
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025504; cv=none; b=CbENV/84/1dDIDugEnossO6JzarPX1lHE89GwCQ01Q9datAE4FHyI3yKejOZvlYczdVBmpWMcM1O4Bl+MSsE1BR0FhyY+Qk7VLNTPPT1LCYk0+uLN6EgfngJElnngANWhGN5/5mfz0vsPg+sS4eXr2IzT5eTYy40sdomUW4IqbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025504; c=relaxed/simple;
	bh=VRpXZvIUbinbYCp8XtmrFt27Dn7YUlcSLIPDdw8ygUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZwUUepMFUStGZduf1pNB9ZzL47/5sCQ6UMXUhtbXeYb6E+q4x4GlIZSDIoPxWzba3WB7GNS3rDNTXcUYS+rL18w9QSJaFEEG1KN4a6CSojElDe69LayQ+Pp03ced+AeZI+yTVKO7VT0sMwRyfBgMbK0nLax3/REZZ476u6GczY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com; spf=pass smtp.mailfrom=brivo.com; dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b=p5JXF1dm; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b="p5JXF1dm"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530e2f50d01so41393241cf.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 14:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brivo.com; s=google; t=1790025502; x=1790630302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SnvuzFJ+dz4WWctMbBwhpqeLCGhBdru2A4mbwIW3v84=;
        b=p5JXF1dmRz3t9HsN+GGYB7YgxVeGocXigSKNl5uAcuU8DZDA/d5yGViKUNV9vdQsB9
         akc9y29tGl+S1mr8ZP7IBxAWmxdCW9lDg14eWOyhwGP8kkwCZTZ3BPJ6WeVgAI0TRXPg
         /LAtySmr58SRKRP3MD5wjodCUT8Ya27bHHEC93BAqVybbnP4/JRHLn6R0Og39+BUV0CZ
         +4PAKxcClG+YwEetrj5Ts453pDMwjlvvi0BudESIHaurjsYxRlh9g/i+MEd+MvdJOfQ3
         Z3uIAxB823KS4ylknvkqz5DB42475WODnE2MUz5rQoV7BwGq8mFwdLT1hOcmolno+/kA
         DwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790025502; x=1790630302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SnvuzFJ+dz4WWctMbBwhpqeLCGhBdru2A4mbwIW3v84=;
        b=ezf4jWd30X2PfLtIto55FY8YWpY+Y5kPNPUuRrRB24iucpNYlwFpdKdSIbRg/PkJqM
         42VdT55gNYx3K4WEI0L6XTNQgeAsn6+StNdcYbipbBuOM+PQrBqyawwgeB8alCManJ9o
         hfan4lkTfxvu/4vQRp6HNKdk2oRHBS/ypSmyZ8rEFa1x5XW/sTfePwEWaD73VkW6aBw8
         fj8g6Xj4j5Wm21/ucbhkaChX6G8sBPfEef8HY1LfbCDz3/lfAScMPf+z3X4CYdy76JrQ
         r0hEDGE76M5Fkecbj+HfY1tK43eTFYOdw33QVL2/73e9KHd7cbcm9l7zfLdtAaWsN1GB
         0hgA==
X-Forwarded-Encrypted: i=1; AKwUvByj5w9uYPEfTzlNzHo4dBe3Gf9DsQ0FuZQpdqdF18HWEU9t7JLBBk+TafrH5hluk+NLSrmhpjnda0lp74bA0Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nJT1JUrUWvSnDPX3lYHdl3VySfo2x/6CKiieyO8tPYBqiOfRuO
	gnazozYTVnI+NaGnVhno6Ts9tKp5OTmY0FJzRp27qdIB8jjhM8ii5UBMczgRZdUu8xfoF3o567+
	HOPHt2jheQ/IWJfajNLHlkjVDDEyh2OMv98F/t1LmhPzl4bco9HTS76o4EBhdmg==
X-Gm-Gg: AYBFou0R7B4is68eTT7fv3s57ASe7/kCfS1BQsWvVickK7cKeHUZaBeiy4j6IMldjWd
	WPFQ4NEob/VX4Rt8MJVxchwce/4IaBUBZKvcf2fAhjpFeyRURbDCTuf1GCyBerdrjlOQGUujsh1
	JpooF8SnOkiTn+jRpamfRZMuYByeF0TqtRZbJnLGu3r35+yu6y506vJ28QRyKeEQf6e3EDl6nnD
	44QhRDDudz2M4WTWtsiZ+R7w8ggMZOtaQar7sJwd5bI5lN4CInVHw8n9cR4KKH3A6++TbuBwhtT
	oLbWlyXu+LheSxxSb14uk93735DktDCYt8nITfQs+9astDBoVPD8ePrhKCV3UbiBqNe0/bH0/OX
	IQILukwPPJ6iPQMfdB5huNJYrpy8EPPYh439MX83OFOL9d8s9fFIYXn7+OMzwT7Yp49TUemN28k
	uMc0qk9R36XrgPqnG6XjvJ80p7/r87liyamgAiXVwqnxTeGi5nziIjY+nj6G1kahL6cJhgifU/o
	PI=
X-Received: by 2002:ac8:5e4f:0:b0:532:ca19:afc1 with SMTP id d75a77b69052e-532d8d8a849mr27485671cf.29.1790025501481;
        Mon, 21 Sep 2026 14:18:21 -0700 (PDT)
Received: from strozzi ([66.193.28.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532df63ab0dsm267121cf.26.2026.09.21.14.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:18:21 -0700 (PDT)
From: Sean Anderson <sanderson@brivo.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	brcm80211@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	Sean Anderson <sanderson@brivo.com>,
	Franky Lin <franky.lin@broadcom.com>
Subject: [PATCH 2/4] wifi: brcmfmac: Fix brcmf_pno_detach NULL-pointer deference
Date: Mon, 21 Sep 2026 17:18:12 -0400
Message-ID: <20260921211817.2432341-3-sanderson@brivo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921211817.2432341-1-sanderson@brivo.com>
References: <20260921211817.2432341-1-sanderson@brivo.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

brcmf_pno_attach is called when firmware is loaded, which may not have
happened yet at removal time. Skip the rest of the cleanup if pi is
NULL.

Fixes: efc2c1fa8e14 ("brcmfmac: add support multi-scheduled scan")
Signed-off-by: Sean Anderson <sanderson@brivo.com>
---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index d9fc94076791d..07d195e4d2832 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -533,6 +533,8 @@ void brcmf_pno_detach(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(TRACE, "enter\n");
 	pi = cfg->pno;
 	cfg->pno = NULL;
+	if (!pi)
+		return;
 
 	WARN_ON(pi->n_reqs);
 	mutex_destroy(&pi->req_lock);
-- 
2.53.0

