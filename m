Received: from mail-wr2-f17.google.com (mail-wr2-f17.google.com [74.125.225.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5674C6815
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 06:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790058406; cv=none; b=S9JwxrVRsoc6ZdBTWgXGMc77KuCXPNl1s1uUQBsWyiuwV9xB6IYkYuZ7yWj0zVqoejzQD9Qv2bCQI4VyWGGkkOr/19ZQ9RWFJdGoVpn/tppr8CwUmtBL6/TsNToHyChORt0558QWdZrouPz540okcXJV12BUATzLwgnfUXn7nkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790058406; c=relaxed/simple;
	bh=gCCZTNytWnIxWCYHEoPTrOwIW/6pCspfX62WAIvm7w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJUqo8tNnMnoOh/x6yE+WHnbAaPkUU688hZTQbxhORzp+lT088j1i9528tGaN9CaX8W4YAwMLJA4qPkX4B4bNiu6WYUS5YmdeqHVguKB+87wo789KGJpbKP2gGTYXoZuwqaWoPMQm0yN2N/CRfXea8nLmdWUgRFZVfv+JZOJcBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3Qf0WxV; arc=none smtp.client-ip=74.125.225.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3Qf0WxV"
Received: by mail-wr2-f17.google.com with SMTP id ffacd0b85a97d-484366874b0so2179409f8f.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 23:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790058403; x=1790663203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+vbqlDVlDE9plp1xBzyFomZPRR9qR+IwVJ7RoXadrJk=;
        b=W3Qf0WxV/aiS0u30iTUkTFHKFVAZynfYDwACCP/07qhF2l0A8NKnM0hOlnSQ1+7pxc
         j2LU/pxrbO5VcJzUKWjWQafAto5XIMiNNrDd2MnL7bzMHyl/OntqO0KddyKSkHkPj3Pn
         mE6AeHc00epaqn+lc1L9b4QgDoePAykGvGRXKtI6eSiXN1Xy2M9KNXhJaPEFimnzGPVA
         MffsbIaVRrW2g0RxRG334QqSNEXEp1XkQA5YFrlxsJlGhoT4ZIO4sP/NTDVCDwiDUGiM
         rtgSbFDXEB2ftMp6RIhNB+6CVxM3rYsUgu52TUgkmuqcW5ux0d7zg3M/00YO/SLj1orc
         uFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790058403; x=1790663203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+vbqlDVlDE9plp1xBzyFomZPRR9qR+IwVJ7RoXadrJk=;
        b=Wysi6GLK06F8wupJUvQv4BlN31YJuHhTREKaG/fpSWrcdM81aiv7TwQb5dCzQ5BFZD
         a42Lhwoxkn+jz6hX1nwY+TIEinoNgxeQY1lATjB9ylQELRGCMLLQ4G93xYScctahpjPE
         bzRtjhd/e+hIGhqOBemEKnp6Dr1s/gYPzt24CZREKVTqlpEQOBpEM507nLvNw8vWmref
         j4Pry0DLHFrfMoa9hcNJ/Ea1n37c7mKpuq/tUuYEdXy51moKHjFWMH7tY3/XPWj5KWwr
         yzirbSJnc2TP23ETMi4XaKlV9MA0c9aQzIpf0j+7mXYVG8rXoRFCpXPyIuuT2Qiff1H8
         ValQ==
X-Forwarded-Encrypted: i=1; AKwUvBwz0OJrm01i4jiGyaiyEKl1zPTDTU+76pWKpQrvpQE/Djj9VKI6ztVFWoDQ7fxwZHgNI340nFp5Ixsi+xPNzA==@vger.kernel.org
X-Gm-Message-State: AFuF++kCJO4A4Q7SvxwyzlmCW40HYyGlfWShY07Iq2kqhNel+1Cz4nLu
	xXk+aYV0+ZRzmb1ppIqFPZVJQzVnvdizAcMEl+/R7H+ln1TLdwweIB4t
X-Gm-Gg: AYBFou0BsaMLhkeYDZ5G4Y37p63KCFjYF/16Cvv6l5mHwpVCcj1ixKQL8fG9Uw/4H4N
	GyU56MTzO45zZHRzXtwjQARB2RMRb/JRGZjjowUfgvvdFckO9XdllrQsT9BU0pdGGbMKaDjq5/J
	O92mCANVnLl2ILgAS7J1N0rNnquOATnEVToknYtmCT4cjctLxMqUTt5cvFBRGrOtVRIfm7QU/NY
	1hfFqA2qGiEjHHf6V3TEMoRpHq2Z6hpaQKft7iAqQ+un5WTT63PeTfGlemFUTV1UQidLC+Grik7
	MMbmRgNUMIMZGYneS7eio8wBkt2AJJ8+07A5Q4+VDv6xSNCDO5mYqY5aDBT+i+xEUX5ga+LGhPY
	KULl0NqxLrbxkTj6tYFYScFjKLB3POUEp+so00gk0qQYO6Fe4FD39IFzIfHTDC2l5/BXKTcCR6l
	TGPAgOFDtefuh7ouUuBAOgUYFxX3boBnEvzhyOUXFlzmkg/oReY2+4UC2g0B+ILyL+QRC7QKGl8
	VWx
X-Received: by 2002:a05:600c:5020:b0:49d:726:cc9f with SMTP id 5b1f17b1804b1-49fc56716f3mr171280135e9.5.1790058403025;
        Mon, 21 Sep 2026 23:26:43 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fda8f04f7sm41006555e9.0.2026.09.21.23.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 23:26:42 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211 asks for
Date: Tue, 22 Sep 2026 08:26:41 +0200
Message-ID: <20260922062641.1313856-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <dc09d252a96c4992ad18e2ba70cfad31@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Sep 2026, Ping-Ke Shih wrote:

> How did you measure the TX power decreasing as your expectation?

Two ways. The exact check is the tx_pwr_tbl debugfs table on the AP
before and after "iw phy phy0 set txpower fixed <mBm>": with fixed 1000
on the RTL8822BU every rate that sat above 10 dBm moved to the 7 dBm
index (10 dBm less the 3 dB two-path share) and the rates already below
it kept their index; fixed 100 gave index 0 instead of the wrap that
patch 1 of v2 fixes; fixed 2000 and "auto" left every index as the
stock driver programs it.

Over the air, a second radio (an RTL8821CU in station mode on a second
unit, at a fixed distance) read the AP's beacons at about -52 dBm with
"auto", -59 with fixed 1000, -62 with fixed 500 and -66 with fixed 100,
and about -52 again after "auto". The drop is smaller than the request
because the beacon goes out at the 1 Mbit/s CCK rate, whose calibrated
index already sits below the channel maximum, so the table is the exact
check and the second radio confirms direction and order.

> And, curiously, what is the purpose you added this? which application?

A handheld measuring instrument that carries the module as its access
point. The hardware team wanted to be able to run the module a fixed
number of dB below the regulatory maximum for an RF exposure
assessment. On the other products of the family the module is an
ath9k_htc one, where "iw set txpower" is the knob we use; on this one
the same command was accepted and mac80211 reported it as in force
while the chip kept transmitting at the maximum.

When I wrote v1 I did not know that rtw88 already exposes
set_sar_specs. I have since verified it on the RTL8822BU: it caps the
per-path index from the given dBm and covers our exposure case, so we
will use it. That leaves the patch as a consistency question rather
than a need of ours: should rtw88 honour the level mac80211 hands over,
as ath9k and most other drivers do, instead of accepting it and letting
mac80211 report it as applied? If you want that, a v2 with your review
points addressed is ready and I will send it. If you prefer SAR to be
the only way to lower the power on these chips, I will drop it.

> Miss to add pwr_param->pwr_user to rtw_debugfs_get_tx_pwr_tbl() to
> show the correct final TX power and pwr_user factor.

Done in v2: a "usr" column, and the effective ceiling column now takes
it into account.

> > +	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
> > +		rtw_set_channel(rtwdev);
> > +	else if (changed & IEEE80211_CONF_CHANGE_POWER)
>
> Should it be 'if' instead of 'else if'?

rtw_set_channel() ends with rtw_phy_set_tx_power_level(), so when the
channel changed the tables are already programmed with the level kept
in rtw_hal, and a second pass would program the same values again. The
explicit call is only needed when the level changed on its own, so I
kept the else. If you prefer the plain if for readability I will change
it.

> In reverse X'mas tree order.

Fixed in v2.

> > +	return (s8)clamp_t(s32, idx, -chip->max_power_index - 1,
> > +			   chip->max_power_index) - base;
>
> Should it clamp after 'idx - base' ?

The function returns an offset relative to the by-rate base, like the
limit and SAR values it is compared with, and that offset has to go
negative to pull a rate below its base; clamping idx - base would forbid
exactly that. What has to stay inside the chip's index range is the
requested absolute index, so that is what is clamped, and the final sum
is clamped in patch 1 of v2. In v2 the clamp is on its own line before
the subtraction so the order is visible.

Mehmet
