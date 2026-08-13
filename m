Received: from mail-wm2-f1.google.com (mail-wm2-f1.google.com [74.125.225.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85617468C37
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786624700; cv=none; b=Qf/Zp5LeDEZE0MsxLYIf38UZbPglpIBBRyJ80RiCPXn98+0h8ovPFkuUrGxSI6YKekIzoMqdXoIGAODI0BvsLgrnNo5djw2/dBe+R7Y19VIaCQn5Vmwx9Lk0d/MYvHCKvbr9PJZzu68ktUbGmJtGdpd4yp/xpB3E+wnoROpu4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786624700; c=relaxed/simple;
	bh=T0H/eBSmqO6yV6iGZkFSIxQFJRx1fiGosOAhp7281Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpNaNPEge0hPFgW/X/OwTUFLgKOjKI2nePUAzyY06ip6e6fEnjJbvFs3X6JxX0MkipbzjLJBUvNlqJjIeB4447qLC4D4O5wMMn622MeRPiLaewj3nHAahFx44Iba/i4/E7tCJluXnk49R4t/X/cKJaBlzvlnDTk3Ih+yO2vcc88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jaGmujQm; arc=none smtp.client-ip=74.125.225.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaGmujQm"
Received: by mail-wm2-f1.google.com with SMTP id 5b1f17b1804b1-492367f3094so2738815e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 05:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786624697; x=1787229497; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qozE/6Jsz/i/baB0e57vxp0gFaz1rBUfSBvJdVPfpxI=;
        b=jaGmujQmUY3cjqpXDKhhBO3KbW+ESHNCMRcHWB80i+Ud2Ta+ROvsGP2rqFmQU3z5vd
         GB23Khz4Q2sEKa3T4ohprEKbT3dqZ26RT064BeM0yc/igSM1oiLvrL6MldGb+xOdCYFg
         ngIP1nBZfVmAVVGtITUZKBoCvdauPyaHqjkgyQMfwBnwzIOFNTVkTHHuP7k2P5vtQaO7
         vKRV5dxPNruKIKKG74cqF0yf7IUkSfkVA/wjUQRNLXc0r30ZfznQiJ+L6u+7B3l4EX4j
         pHdljT3dFlOtJbZsBl4yhT9NTXnf2HwrxBaz79uOSB7zsGeyn/njmTrtrSoazQ3mHe2N
         K3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786624697; x=1787229497;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qozE/6Jsz/i/baB0e57vxp0gFaz1rBUfSBvJdVPfpxI=;
        b=hoigNXSsskOrhH3MfgufMC8PZ6lV4fiIgMJYUPxVqFckEADDQ3ZLoUPOAhd0d6bDsD
         1OE3OD0X2xYB73pKs8YQ/I/cbYnuldDPSYlRn6V4HYopThANPt3NqTPlnc+ZxzE43fAu
         r8FAJQDjRr14ujlqaWHt1wPH3UW0/A6gfJT4DSmBTuIwe2ZYonZnnupC+ts2Ahd+tUjd
         yYfaKb4hrG0r+PKnMU4G79ePGeDOmgQWFnPBILN2UOYCLY0nJCvsCYJ86PVgw59esBl7
         GLwBXGWpfUIVkWuXYJ9eZSW62lPYLfSkE88qPWw79IVD96ketEfM2e1M/d5XHXJrinLO
         4XtA==
X-Forwarded-Encrypted: i=1; AHgh+RqJy8yGAU9uJR1ujh8x55WnQmqNgPLSt2tu14J6sUeDerntdywQX8iXPbOoW0fmYRJy/iqxQhrcn2pEFNhyHA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0LwaEoW4M3XqUttUKf3abR6Xqj8yiKqAA48F4HP4V4tQ1pysh
	iu2QZCg4JEs40SF2mnjB3uSySxEMt88bq2dqkURwYu9VplNi9A6EbsIw
X-Gm-Gg: AR+sD11PUyEjVxYr59oocOTwyCjuHa3tvrOL8bYJNFfH21CYbsZR+T7c7FD3eA83BaF
	So41s3O/akMAj29UuCSiHtCoLXgb5czG0eZ4GPjHDgKvj0jr0rbQ1UYENi1yY2an2C4DRO4/1c6
	2nDEv2cP1qUWCwZgfwgnyMyTYuS27mHxwZjLiJJmqLTaId0XWzHrIlaZnDJK4TgqL/jU3BosPlt
	oS9ti8tR5rrOSFH+jLXcugKM6OhC/gwKchR2qgNAtK52dIr2LyOW1KmyB2RwhSdK354iGx5zj0c
	uSMG9G5bVTa3LT+c5N9ucxZIlseCh2ybXI6mxE4C4X9RBuJvpr3Vg8UvvVs0MZITMGPzi6ecEEx
	hX8P/7fEcpEmKD1od8BoB0zMJv2wv9FXhgLoG82ds/6X26e2WOJUjon/yDH3OK7RHnlgGra27x0
	pG6fmIiIfp25MmzdLIWmfdN70MZbX4s3CFLnbzubHn3GynaUHA3SfWU5bSDF9J1ccHfYPbFS3I0
	QuYoclmD1nvl6fJvy7bFollD03Tvao2eRbiEn2qBHo6rNG5KM1ink+9Tag=
X-Received: by 2002:a05:600c:1d19:b0:496:c379:b2a1 with SMTP id 5b1f17b1804b1-499821548efmr77322515e9.2.1786624696381;
        Thu, 13 Aug 2026 05:38:16 -0700 (PDT)
Received: from fedora.fritz.box (dynamic-adsl-84-220-246-20.clienti.tiscali.it. [84.220.246.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b585b3sm67349925e9.10.2026.08.13.05.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 05:38:15 -0700 (PDT)
Date: Thu, 13 Aug 2026 14:37:56 +0200
From: moosager <moosager90@gmail.com>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Deren Wu <deren.wu@mediatek.com>
Subject: Re: [PATCH wireless] wifi: mt76: mt7921: check drv_pmctrl return in
 the PCIe reset path
Message-ID: <an23_8DALILoGLP6@fedora.fritz.box>
References: <20260809012309.43657-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809012309.43657-1-lucid_duck@justthetip.ca>

Hello,

I can confirm the patch works as advertised:

> With the return checked, 26 ownership failures produced no firmware
> download, and mt7921_mac_reset_work() got as far as logging "chip reset
> failed", which it never did otherwise.

I would like to reiterate, though, that a more complete fix should be pursued by 
anyone who has more knowledge of the driver or firmware. Previously, a marginal 
improvement like this one was applied, but the issue persists to this day 
(see [1]).

Thanks in advance.

[1] https://patchwork.kernel.org/project/linux-wireless/patch/727eb5ffd3c7c805245e512da150ecf0a7154020.1659452909.git.deren.wu@mediatek.com/
