Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7961F2B88
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786888759; cv=none; b=CA9l4YJ5wUZPLPAkg5+KEdrBEmjeOlBV7oQGYcDU3MQFEqxZw1o7z3PinNBBvv6wbBGJOSVkHVHSZddxKt5MOJ8Aqzv0L6vdmZHVYJwt8HCHOUssXQzTA9KoJlo1XFg0AOajTaS5+RlniDxADdYc6sEFhkeDD/O8j01Zj490rog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786888759; c=relaxed/simple;
	bh=F9HEXESutLpOiaj8UhWCcmiSUavGLm/Yffesz0tGfsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvdDQ18aKzVLCclCvn2Nmj89S2N7qRHuepUsg+gQAmTM1ug4PbpqWQcOep0LES/K0efwERSl2TGosThxR3he39Ea1YmmQLnzPgHj2I+Ze+2I59WFShaD+zax2ie8bkGidcN9yII69rVruVMQBGsQI2SSGhqDRbtzWIn7MWGZmqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLpekTue; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLpekTue"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aeb59d54b1so2575451e87.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 06:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786888756; x=1787493556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9HEXESutLpOiaj8UhWCcmiSUavGLm/Yffesz0tGfsc=;
        b=MLpekTueZfLv04sDL5NH7HfEDmC77F8D6XwifkL85B9Y4piT/7Vy0/TLYvfPz3/1d7
         zfZGFc5m3FytBZJdNdrDGv17LPVeon7LdcqdKCzw+QUXxHxwSi7dEfO5hBW7lsAZ+RaR
         fHm6JN4s0u0TQ2iymLJtoHbJNY/xw3apoq7QxMAZW54wGXxqrnIkZuQfLXnxwrsFVBIj
         qWBmot5g77xN2ZYmPDy4cSbOJu1i3Od/IRpVV7TwHt/DJc8ZTBbmqBnYKmcSZJnJj32g
         +YCJik1VXqJKU9syNlcDXPkpEaxzKU1TyFMDlqNnKypS7pDF5M4U/xTKUufw7M+u9zYi
         YZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786888756; x=1787493556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F9HEXESutLpOiaj8UhWCcmiSUavGLm/Yffesz0tGfsc=;
        b=f+rqenGBxJHxnF1gxrfGD1vkS6v9Q2cnW5E+9gsTHhdC32Tzdex2oZC7WxV2j35IlL
         hp9CqgOQ1AV5S2E6WfGMAATC/I/hF7axwca9GX+MgeBYOZ8QBWURWzCgtWk9EQV+WZ4b
         aAOmvS0OXTwSpM2fsHK8gUC1pbrNyydGtiM/LsDKnnZr7XKxiyfI5EHmZu5UhD9uGm/A
         npiyE1Zz1Yj733P2Mtxb3nFNZfVh+lV88WkT4S6ayZ3xIYhvMAPGg7me5RHgEXOBDAt2
         C/f2s8YdCEjWyf0u7taRGRiaJqSayKJ50zHULiTyn60xIFuIl2fEwMVRoEspI9RLDPct
         d6Pg==
X-Forwarded-Encrypted: i=1; AHgh+Ro4kqPlLsyOGR5m8f04fmmASHT0mi3PAo+3lXP7rPVyavcQmIlS9wk7lYXJ5ujuTmsKJg0VZb+W4Qb+YzVkSw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLuk48iG1/h922v9INmhneOv+/pIXreZqLzm3eu3zERcPBxojK
	/aMDRcrIpM4ubHBF6aU1qHVWBFdeeQ7DdOyD7KYcyPPWMOIl0jroL5y/
X-Gm-Gg: AR+sD13DErBiacmyoECQGaQ4YHKcJV8zDGsT0ABAET6wmDTOODkNQECt6+vGXNuH4wi
	gAV6ofcnCsLrkOAVl3Uye1kQGELUf3axbWcW8+F4L4mKJ8udqEs8saxe4PZwgHucbom7j/F5fEz
	8wN1UEUi4n98W/o1W86PeiIfpd+MvuZ/X0tD/tg7qCwsE7KTT3r6ppKy8Ocp5IgSSpWm08CBB9P
	MNJQ5Wj+a6keVvlVZ9SQ8YCVT2TCVs9sa4V/+SSOp5fgyOsN+0WdejEbYtIYNdIb8K140olSiTo
	256LVo8x2JwOBK9lPr5+uW6qp1yEi+H7JU1VeYDqf0VMKWeYMKzTxLbxDe9rLTjGn4uDmcF8k1M
	wYO0MmE6ukkkla1xIAnMZlBGfXYrBLWATSUNhKMZscTC1B7V8RldVQhdxfdsDUKlQBPUGJSNpHH
	7Qeazimi+TaNry6bO6gU3F6aq+Yv8cTMTrT3WE9vEgCPJ8ZqVdx393XYbfsRrUwjVrO5ubcTVj1
	ikbQ8wQvpXFk3YdzFuMb/BJIWD7eHkyFl4yQ+Tq3ebZN+ikBRT9N7DT1frTrtZVdRC7JJr9
X-Received: by 2002:a05:6512:32c5:b0:5b3:cd0:6be6 with SMTP id 2adb3069b0e04-5b45914b25cmr3159910e87.54.1786888755964;
        Sun, 16 Aug 2026 06:59:15 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bac120sm1796996e87.35.2026.08.16.06.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 06:59:14 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: JB Tsai <jb.tsai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Charlie-cy Wu <charlie-cy.wu@mediatek.corp-partner.google.com>,
	Charlie-cy.Wu@mediatek.com,
	Deren.Wu@mediatek.com,
	Sean.Wang@mediatek.com,
	Quan.Zhou@mediatek.com,
	Ryder.Lee@mediatek.com,
	Leon.Yen@mediatek.com,
	litien.chang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: Re: [PATCH] wifi: mt76: mt7921: refactor regd update to fix recursive mutex deadlock
Date: Sun, 16 Aug 2026 18:59:09 +0500
Message-ID: <20260816135909.52136-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260629083543.153564-1-jb.tsai@mediatek.com>
References: <20260629083543.153564-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I hit this deadlock on an MT7922 (mt7921e) and arrived at the same split
independently before finding this commit in linux-next.

Without it, associating with a 6 GHz AP self-deadlocks: mt76_sta_state()
holds &dev->mt76.mutex and mt7921_regd_set_6ghz_power_type() takes it
again via mt7921_mcu_regd_update(), on both the sta_add and the
sta_remove path. wpa_supplicant then blocks while holding wiphy.mtx,
NetworkManager blocks on wiphy.mtx while holding rtnl, and the machine
is left with no working network stack and needs sysrq to reboot. Because
NetworkManager retries the saved profile on every boot, an affected
kernel stops reaching a usable state at all once a 6 GHz profile exists.

With this commit applied to mainline at 3eb40771c00a (post-v7.2-rc7), on
a lockdep and UBSAN build: association with a 6 GHz AP completes
(channel 37, 6135 MHz, 160 MHz), switching back and forth between a
5 GHz and a 6 GHz BSS exercises both call sites, "iw reg set NL" reaches
the regulatory notifier and visibly takes effect - the link moves off
6 GHz - and "iw reg set RU" restores it, and an 88 s deep suspend/resume
cycle reconnects to the 6 GHz BSS. dmesg is clean throughout.

One request while this is fresh: the regression this fixes was
introduced in v7.2-rc1 by e88098133ed4, so it ought to be fixed within
7.2 rather than carried into 7.3. This commit is only in wireless-next
and has no Cc: stable. Could it go in through the fixes tree before the
7.2 release, or failing that into 7.2.y as soon as it opens?

Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
