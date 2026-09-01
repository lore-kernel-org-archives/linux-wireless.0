Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43D0476CC3
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288584; cv=pass; b=F6bOBcFgI3IcbyNqLvsDpy8V7Lm4Buws5tofsw2L4UmLJ8PKTkTSfB+EuytxP5QRShqe1TRftcE6KSbUuIkcUORiMDMJ58nzaS3qMZyvWrNXYVUSso2QOG33DmWC+PemO73PBeI+j9i88qVCWREtmKLCv251SyjPXj3l7PYajiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288584; c=relaxed/simple;
	bh=ODDKSEGUX36HrHhP+QmmYV5FWH0+4pri4u9TtrMt2gU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TS5nRkA7NNSdvimvFc/6u86zEWBPYNnfBHaHE/3NrT+ocQ5dokSvi2tp0F/wnRTooy88IsUZTK1MffJ0Sumz2kXsdoZXp3LZ7fnnpUfBRA3IMtgrUPRFBrpH0PBjSvh8xj4GFKsEkHXdX96lhckMtKOVFWxcSoZot1fxOlwply0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTMASDE9; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTMASDE9"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c250c6a6a9aso14985366b.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 11:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788288578; cv=none;
        d=google.com; s=arc-20260327;
        b=AUnA7NNYKSQInzdGfGbadUt7nAZy7YNeYxddXggZRCbW/g9ofgaH/uJ/DccHzJ4W/N
         XWhDS/dl4mTLnmhfn3KrDlGYtfTyfFzT0IRHZhNV02L7ZE7g5AYu5cxBmCQkqyMgXw23
         sH9sA2d/4Los2Xb69vJNSF7JTDJC0iuSEij2t5GABB2R1V498HAmBVBAxX9VGUDSjDyM
         k5okogCJWZ1KVSLpH7XIiaY/sxFCV3HTC4hsa4QIUJy0HxPy+Yv38VfsSHbyHEOfOTkf
         mfd128TzOCO984xVfVX7HKLRf2iVlKN5fWpV+xmdtcVxFOS+1qIOdLirXYHFTAIWL5DU
         F8Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=ic7IY1tCHu3gWFgXVPzx+1RT4y5KILIZ0cDGhx4O3jA=;
        fh=NyK30OAk+Qec8ixA6i3rQ9u4CyXm5LYSheKUuvvSyTc=;
        b=mehwyyhhOdp4W3UvjyHLCNb7X3XKGgTl9iW1yFZUf/HKHoUiwLT8r6UlkeuRepLedF
         ThZPbPTjKJtO3muJW9Erlj7UYhnEW9sOB/1/GxDyPQB5ZgYvs/YhTX4zQXpSRQtVzQay
         PgZW/2nopy6OMxWDsg4SYQIRi8z/A7jQmrkemZRtvvqtiT3fmBrqg7o+QSQMZgpr9QEr
         Nth+vbgPU6h+lS3dmCWGtWvf/lQJe6EJIIKV+tlPXWZe4FEirknP1qXxTLwvVH4WRU1O
         cGlNR8FyGso9zt2b2fzUhckp2xSUhwNcU0fr1G+QQfOc1z1cTDIBKwOgrIQJR9e+bFCP
         bCCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788288578; x=1788893378; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ic7IY1tCHu3gWFgXVPzx+1RT4y5KILIZ0cDGhx4O3jA=;
        b=gTMASDE9lB01kCQKTIi+NjrXot6tg99TQ0eXs+1cP0W1AUIe6nXoa4jkx2MkkoilZ+
         3weAvg7GJmTLo9I82NsyvBd5W2nbZBQgkYEoUiXyUvbBxY92YUx8yt1HTz8snPwFJ5xq
         EpMaPlXXorOT6c3+i9vgsewpaWLXAA/dCAtYCrU3ThGZ0usTSKQZwo6qtINW+thzAnto
         yHDhVtTKBMebvB05099Ln11ms7fxSccmtMh+gnt/XxFJsWjqtBKlZiv0N6V5w6v9FJFm
         ITxJ+89+OVHeW8zFCtb3vSqt9RXduedzNlflvk6a5srn9yJontYkFA4lGtTK26mVq2d1
         VeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788288578; x=1788893378;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ic7IY1tCHu3gWFgXVPzx+1RT4y5KILIZ0cDGhx4O3jA=;
        b=UNZUAXSPpz/Ik9649hAdPBc3GzIUDh7ntILO9RtEjr+M1dzgIftxdCMhtVeDEOoPHX
         i2avcOWralLxD3Tper2cFU/7f1X7G9PO98DBya2LTcsZGgkRXcNnj9w8L4VUtIHpINop
         wzTBVKL1j8RJz8lB4CiJIXZicmYPymiO3JsiGlbptQJdQvb9/d4calKRrHAtz6WP2Y6U
         uH5uWFCDi3AIV4BqjpdP+2aA27s1BTgTy+sTfvPL/0svG5wNoItjHnFM8bSIlRDW+gTe
         tzrUorgfk/BSZvF/QmQ3MQBDU1QLWuYfan0BXqtJZMpBLgz8PZVVwoi4WQKh2eRV8y79
         4tqQ==
X-Gm-Message-State: AFuF++kYWJ0pqnq9JMiKLj5AxltxQDS4an23JCgzw65A136J2IkeOaCj
	7VXeBW83Zd1hOdrdU5W6Y/rPw//AeYaBNC/BsDI4mA7e3Y3g/AHvVnASh0U4iNARAGd35kBrFUR
	qqp7ujrwTdY3A6rSOtOFmuz1vzYnJ5f65yg==
X-Gm-Gg: AR+sD13vbRtMzdiDwWtT62oDrdqmoO238RJ3mFRuZxzNLwdewZ2jszHrHWYNpqdnIcr
	o8yssilr4uHbygbJkzKn2jsFDcNYbDc7qwBfNOPUMroVd1jfJNvjHSi4EpTlULljVkEtAxZi7H/
	M6nHQKf+UwiwjIU02Ek2ZaQx9goOogr3uu/qlXw0SLUPO+mN31OyQhuVUBzAD1gpjSOwNWz5mXs
	zqE3ZL/fwgqS4jjAKeF+rwJ9ff8V+rVy3PoqwXjC3l+UOluY2IqbpDBTp9Cq4AvfescWjt761qU
	s+dlHmrNxFk3XgIRsRWbCBgFxwUj2keZsPjYo/RmH6Q=
X-Received: by 2002:a17:907:72d0:b0:c24:87e5:6491 with SMTP id
 a640c23a62f3a-c25b3b80b3amr742600966b.2.1788288578159; Tue, 01 Sep 2026
 11:49:38 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 1 Sep 2026 11:49:37 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 1 Sep 2026 11:49:37 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Vin=C3=ADcius_Ramon_Fontanela?= <vfontanela@gmail.com>
Date: Tue, 1 Sep 2026 11:49:37 -0700
X-Gm-Features: AcwNN1UBorG74abm2Klh7rD57gWa3Wyc_yeCawRSJkVUCfc1aYehbujbOrBQ6po
Message-ID: <CAKuTqBQoU9sSN7AzOQ5kBbBjt0CD=N0KBK8GwocBn1dOEVdVNA@mail.gmail.com>
Subject: [PATCH] wifi: brcmfmac: allow ISO3166 fallback for BCM4350
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vin=C3=ADcius Ramon Fontanela <vfontanela@gmail.com>

BCM4350 devices using brcmfmac on x86/PCIe may have no platform-provided
country code map. In that case brcmf_translate_country_code() falls back
to ISO3166 codes only for chips accepted by
brmcf_use_iso3166_ccode_fallback(). BCM4350 is currently missing from
that list, despite the adjacent BCM4345 and BCM4356 being present.

Without a country_codes table, BCM4350 therefore returns -EINVAL from
brcmf_translate_country_code(). brcmf_cfg80211_reg_notifier() silently
returns at that point, so the firmware never receives the requested
country iovar. On a MacBookPro14,1 with BCM4350 PCI device 14e4:43a3,
this left the firmware unable to scan UNII-2e DFS channels 100-144 even
though cfg80211 exposed those channels as available.

Adding BCM4350 to the ISO3166 fallback fixes the issue. Tested on a 2017
13-inch MacBook Pro (MacBookPro14,1), Fedora 44, kernel 7.1.12, with an
AP on channel 116 (5580 MHz). Before the change the AP was absent from
scans; after the change it is detected and NetworkManager connects to it
normally.

Signed-off-by: Vin=C3=ADcius Ramon Fontanela <vfontanela@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 000000000000..000000000000 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7948,6 +7948,7 @@ static bool
brmcf_use_iso3166_ccode_fallback(struct brcmf_pub *drvr)
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43430_CHIP_ID:
 	case BRCM_CC_4345_CHIP_ID:
+	case BRCM_CC_4350_CHIP_ID:
 	case BRCM_CC_4356_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
 		return true;
--=20
2.51.0
