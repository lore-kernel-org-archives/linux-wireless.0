Received: from mail-oo1-f99.google.com (mail-oo1-f99.google.com [209.85.161.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636B4175D53
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501352; cv=none; b=DBnWa7YIAfwhFvuKOHC1J1JMA+BupujXXG+5Zx5FjPj5gnbDwNKJiKnzGkCFTRffyWJd1nlU/TtQ1l/cbQk8Z6/urU50xZOx6xaE2tAXDejF9G4Ox3SKUHBYxlbkeVdXBQg4yi5oORBmvInQ18t6cFpcDBMFqyV8Hf/SBAPphpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501352; c=relaxed/simple;
	bh=1ukQPGZfnGJpH0PCLbtQgHHHM4pWuS0+vY4qQpidol8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmDWK+pjYJs3lAIFRkxIPkWv8FfLlF+54oVJzPK1ReJn26v9lu6J7ugJMLePDUjFBg2Snihs7pmCNNN/yCtjpQ/hBSbdclHwruWIDdY9kzZMny4tNpmoE7w1q4gY0kHpGe3TqFC4e8EGYsA7D6XIz6E6RK0pB6UKoKFq9q1zDX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=d2X+m5BI; arc=none smtp.client-ip=209.85.161.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="d2X+m5BI"
Received: by mail-oo1-f99.google.com with SMTP id 006d021491bc7-6ab021f1daeso265595eaf.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501350; x=1786106150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6OlePq0hG08Pbp6Rj/6MQSCYKEAeScklhwdBNiR+MvA=;
        b=IzNXqUw9bBNRrfp07C8fZSWuNRty4IossvGsDjoCJ+sagsVbtRcCCQKacRv6EOiSpW
         Iuz63YJx81cJRxJfZYKl1Q7AWcGBHkT196skdFI65yGNEw0y0wHTiE+72vhBkVruECDk
         AMHH4SydKpAEL+aYS+9J+TUhWRJ/TWazPmDI0fjq1/ftQR0N+R/JsoGoK556pK6TLBu+
         e03qiHljJ+eBxH7XfjCnQapf0myu1YrXicAfoQAeK4bXPrasHwV5mrSeBeqz9i+hrv6n
         RgM/ND60MY/rZu242PFF+ogbPrJKe44BLdhpqxH3zKB46/SHe2OTc4wHP7uEY4psobeC
         jMqA==
X-Gm-Message-State: AOJu0YyDw9AZq9G0eSb4KujiTnHh9QiKYWKs3BO7u3nYtFchMbTUdzpQ
	219OGxWAA0435JCSR+Z3x37iE5CDmWqtIsD7yE7EOl8sX/Zr841qdrA2SltobiI7sZQJLx9lm1I
	J5m7PN3SvAD86Xega/utCGGv4cPaFwYiU7iveQzVLJiLG8zPIgphc5i+eGDA0A2TggAWTnUyWIt
	3ebSuf/SBpHTkOM+QClE4FTHbMmLG8/dlyrubj6cp95Tczbjmt+lUtG4sqzRUihPJ2EjNEK/O7W
	bENSQSAf2TKHb/hMdwCiXr5kn7M
X-Gm-Gg: AR+sD11e6ThMixO7m9hJceBaxO0cBQwyCqR4aR2vCqrTLv6R0nD5Q0HfbmDCyZRfAMw
	DaYHCIY8evkYDLGfkSukd39Xi1n+16c5QkceaHj9NDg05feRL1UaraOKfsZYN1KfcU8U1RDKhwi
	E7g4qOgwFGpRkqt1Hci8Fih9KTPCtWIJjfWUGd+DsvY8nuiANHSdr6fddoX+ZBGv0Mg5yJCReNg
	b60DeoIac4xaDgyPEDhAT+8Pv2ooV+xeI9UT0l6HY/hVoROaP+NSWE37NPm/l2gsFulfBWSfZHo
	p728zQGH7hwfK9/QhwVEZznws8qBAd4f2mp6EFFYEFpfSmtcJjBdg20w//Q5EmZxEC8CMTe7OFc
	EwPeVzyWX1PDQYW98eA5uejTvwUjVfU+C/lfeMP2voD97gUTuwy0G0C7L32RtYLR/JVTxl0nRVf
	B89zUm7kHeBw5SwUcMIC2sSy6P2lks5+wCIHWCPCk=
X-Received: by 2002:a05:6820:61a:b0:6a1:963d:a040 with SMTP id 006d021491bc7-6ae37cd12d4mr1952073eaf.2.1785501350225;
        Fri, 31 Jul 2026 05:35:50 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6ae39fa6315sm68294eaf.23.2026.07.31.05.35.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:50 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb711c88f2eso503165a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501348; x=1786106148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6OlePq0hG08Pbp6Rj/6MQSCYKEAeScklhwdBNiR+MvA=;
        b=d2X+m5BIvuXJPR+BBfBEg4CPLHwe8CgpW9PL+owupH7+IZnZnE2JyeN/f5Lbji4EyR
         PRdJPAQrXKcDshjP+eAz4x6E96YPfEL0sWE/Op1+qTGyN1n9bHEDdeCXuLj6htpYcrlq
         fWn7lP0oK4zCTXYyCNfiuDgcF12o5QzFw8YHE=
X-Received: by 2002:a05:6a21:513:b0:3bf:7eb5:9459 with SMTP id adf61e73a8af0-3c91b0b8a45mr1916998637.20.1785501347500;
        Fri, 31 Jul 2026 05:35:47 -0700 (PDT)
X-Received: by 2002:a05:6a21:513:b0:3bf:7eb5:9459 with SMTP id adf61e73a8af0-3c91b0b8a45mr1916979637.20.1785501347047;
        Fri, 31 Jul 2026 05:35:47 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:46 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 13/13] wifi: nl80211: send frame tx status event only for non-zero cookie
Date: Fri, 31 Jul 2026 14:35:09 +0200
Message-ID: <20260731123509.1975281-14-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The cookie value assigned by cfg80211_assign_cookie() is guaranteed to be
non-zero. So the zero cookie value has special use in tx_control_port where
userspace can indicate dont_wait_for_ack, ie. not interested in status. The
wil6210 driver also uses the zero cookie when wil_cfg80211_mgmt_tx() is
invoked from debugfs api the driver provides so the event is also redundant
in that scenario.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d12bef11b94f..ac895e02cd41 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -22046,6 +22046,10 @@ static void nl80211_frame_tx_status(struct wireless_dev *wdev,
 	struct sk_buff *msg;
 	void *hdr;
 
+	/* userspace not interested in zero-cookie status */
+	if (!status->cookie)
+		return;
+
 	if (command == NL80211_CMD_FRAME_TX_STATUS)
 		trace_cfg80211_mgmt_tx_status(wdev, status->cookie,
 					      status->ack);
-- 
2.54.0

