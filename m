Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BE43115B8
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 12:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792241049; cv=none; b=ugiGHWlIOnYSyC7CZaMzqZTCdQolr2UH0PW5mP+OaOhEdBZSEKvtrIzLUn2KlUulTyvtN4gPdI7Zao8hVO+b6BXEUA0Ycwqcow3Qjos8qOhGWdEzz7VJ2ubOjkms0SNitHSFk3drFRiPjwcre5ci0WRNtjJbN1RvX83pB6x2sls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792241049; c=relaxed/simple;
	bh=zJwMkOtPOfuQFS4PlbnbuHs5ipX3kW2iyrDYzviygP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7pSzEREzF3lS7HiXGhQr2EVjOXNTM8fWEZINAR3m5EsLrYCf7uIV077ngFn9O1ns2gaC9Kf2JLzfo0aruotNXf72ws4vxHjI4V6l1CIeDoaIcqM8uWj8eJUjHEh4HbdigFl0zWG5xK8/j0zO14VDnW3JCvl0JKT0OLDQ+kR6Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kep1s9fv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kep1s9fv"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a021c809e3so7662575e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 05:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792241046; x=1792845846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zJwMkOtPOfuQFS4PlbnbuHs5ipX3kW2iyrDYzviygP4=;
        b=Kep1s9fvagnqpS6y6cfrv8Z12dn4MnEUFx+SCKzV2ncyaEIP+8dLfMw/bd+Tw7AjCH
         8dWSWJXlh6UHeITVTDaCTSLMv1LWmJNsyPmIXBQhfJZPuWynCjYMaTeRBMnQu1ssPJxO
         F+Bl6T3st7ENc6aBHZyl1FyuNx0+Z5fsBuwvKhTDuxi6QVBwaki/rUh0rFmCyAJVKMb2
         qIEXAh4T3vDgWgH+5Ta9zqxrm32jSW/VYEd/baimgJ24eDtMs9PzzZWdI9LsODCU2sqD
         SmAa3E0HeU/6GSApj2f3JwZffgcK+P47Hn0YebRh8tMuZM+r2RIwEYf0LtKkEqn8afzH
         R1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792241046; x=1792845846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zJwMkOtPOfuQFS4PlbnbuHs5ipX3kW2iyrDYzviygP4=;
        b=o+Cm7RMI59PuhwSdQmRScMD0C6Ul0pakPxBK0LqZhGh3Tp/ES7tcOQ7ocSCCpDUBsq
         3Xcee7I3sxLJkL/t9aO77/MpiqFbR34aP07GIRVqGnLuAK7Vv9A/REUFRUwm59Q7pqpX
         apCgK3fj2Z3RyLmacO1u7oORyuWAWPJ0IncgT0CtBwS03R5Xn+DKlv1x5FwkvB7d/FZb
         3UrTdqgI6Hi1+35a9V2bYQpsJ+5MHBiY/Oul5OiP/pQv2PqDdc9mAWegLcrDGc2q1Kre
         XnxZ7Nrj87fhebvICfGgsB7o6H/8ntMPHJi2tkhIE+73CVIvGRpKtX3zOeoNeMlASBZ1
         PQVg==
X-Gm-Message-State: AFq9FYKMsqG8qv2fTR1iQ6PKtjfixOiRTZ+tP7Qrqdw8xEdo1CwBlRBR
	x3W2lbR9Jsp4ZGmLdEbKE6hEjRRw8rd6sywVrL3Om5vHpEBzyBRuoq8CDFOOAfgU
X-Gm-Gg: AYBFou2XLcM2uzqf+ZkABxw/w0KsA5v81VpYGkHzVhRo+gCintab4HvJExCpRrhvtPA
	F11odXehkRvLzEFazfDDMjVNkyUuHSwpm9N298F/7BkHWoMRGtTLWQQ508Qpf4/m9eGRwkuU6oy
	i2ELYAwvwrXl/KgNgLLssh5/7TKKj15D5OwkeMzznRhxQoPKziqOjoUlK7snPk44BXPKbJ4dhur
	xIV3G+pT/SwCzmneK46Z4hT307QIPNLTLcNRZKfQCctHPac4s4tT5pIf/7qTTNecFbkM8omVXw6
	Jnj3FXK3IzSU5HEl/z9J8hj8uMgtAu8Rklj5DCpYUWbXpgWr6mySmWIChrZowK97MzzkvESlbJ8
	fymitp97/F79y0ljiCILqHtPHmYE4H/2zuljBjLtTxwoz8mZU/mPDzxH4A7oJlqDzIn9X6TC/Vk
	wNDtYJVLetNGkjYmdCnDrsIqljHNGkhPJ1GyOj0kTHSqZ6cciu9cFpsF9lHCclLjcV
X-Received: by 2002:a05:600c:3155:b0:4a0:251f:a726 with SMTP id 5b1f17b1804b1-4a1d760dce9mr62292115e9.24.1792241046120;
        Sat, 17 Oct 2026 05:44:06 -0700 (PDT)
Received: from omarchy ([154.160.53.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cc642573sm102608115e9.2.2026.10.17.05.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 05:44:05 -0700 (PDT)
From: Carl Quist <equalizerjr@gmail.com>
To: luka.gejak@linux.dev,
	pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Date: Sat, 17 Oct 2026 12:40:50 +0000
Message-ID: <20261017124050.33663-1-equalizerjr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <DM71TCO0TBZI.1W7JBUVH0CMG7@linux.dev>
References: <DM71TCO0TBZI.1W7JBUVH0CMG7@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

Thanks for the review, and for testing it on an RTL8723DU.

On Sat Oct 17, 2026 at 10:41 AM, Luka Gejak wrote:
> Where does the AP beacon fit in the reserved pages?
>
> This chip has 8 pages of 128 bytes, while rtl8822c has 16, so the 8822c
> never had to squeeze a beacon in next to the station pages.

You are right, I missed this. I went through rtw_build_rsvd_page() and
get the same numbers: the five station packets take 6 of the 8 pages,
which leaves 2 pages, so the beacon must stay at or below 216 bytes.

> Can the station pages be trimmed while an AP is present, or maybe this
> combination should only be used on the chips with the bigger page budget?

I think they can be trimmed for every station, not only while an AP is
present. Two of the five packets, RSVD_LPS_PG_DPK and RSVD_LPS_PG_INFO,
take 3 pages, but their locations are only read by rtw_fw_set_pg_info(),
which only runs in LPS_DEEP_MODE_PG. rtw_update_lps_deep_mode() never
picks that mode unless the chip sets BIT(LPS_DEEP_MODE_PG) in
lps_deep_mode_supported, and only 8822c does; 8723d has 0.

So for v2 I plan to add a patch before this one that only reserves those
two pages on chips with LPS PG. That leaves 5 pages for the beacon next
to a station on 8723d, i.e. up to 600 bytes, and changes nothing for
8822c.

Before sending v2 I will repeat your check on my RTL8723DE: grow the
beacon past 216 bytes with vendor_elements in hostapd and confirm there
is no "rsvd page over size" and the beacon is actually transmitted.

Ping-Ke, does that approach look acceptable to you, or would you prefer
to keep the combination limited to 8822c?

Best regards,
Carl
