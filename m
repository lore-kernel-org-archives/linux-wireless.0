Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6FF382298
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391769; cv=none; b=IwQAJ49Bg0JlzX5MDVLkvZ7I4mt+F3eF5CBEp05f1TGeqz1vJeliqC8DXJJUknLgeadorPOc1lTqxBwZX1teaMWfF3FBK5rqDn76ky7q2d2sn2PcC62BTudkrHphZkso56B2KkqQa1+Iq3LikPBJ8suAJGQLecLGjYQDoL9PhVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391769; c=relaxed/simple;
	bh=YoKT+RMRC0Vh/t6369YyxeFt474ao8mnuaWNjvSxklg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8V7ZG7VwIkgxr5XNCv7RLetNfsNGTGunZFMYVZzgalHeXHIEf8kh3dBVHB/jyw5GXZztRkMCSxLgF6Dc8DS8ZdiJ1BReXdvYxiiCFP326LbJJHsIeTdlr8fosqhyqmWiMXGU/qMiA0BxiVsDXW+lTlCgmM3NueC6rX2EMDgal4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ocSUzJvi; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ocSUzJvi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YoKT+RMRC0Vh/t6369YyxeFt474ao8mnuaWNjvSxklg=;
	b=ocSUzJviUwouy5eNE+XOAxY/SWZsLwWdy4/S1iwfnqOb6PXD98SfOi7WgkxUQaqVbUERxf
	oInWhziEB3ErGhr2DABHZjVmdOYXB/Ztr+eUX6Kt1K5LzxQWGWi2Yi21FwKGjQwTB/atLh
	8/LJ4gU2PGVj7l+Hvu0y7duSGDz8wYc=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 17/19] wifi: rtw88: calibrate and tune the PHY for RTL8723BS
Date: Thu, 30 Jul 2026 06:08:55 +0000
Message-ID: <20260730060903.30187-8-luka.gejak@linux.dev>
In-Reply-To: <efef00cb-8369-48d5-859f-623663ddac56@gmail.com>
References: <efef00cb-8369-48d5-859f-623663ddac56@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 00:05, Bitterblue Smith wrote:
> These are three separate things, so they should be three patches.

The patch is dropped entirely in v2. None of the three survived
re-testing.

> This behaviour is already implemented for all the chips, although with
> even higher gain (0x1c) than what you're setting here (0x1e). See
> rtw_phy_dig_set_max_coverage(). Does it not work?

It works, and better than the override: five scans found 41 BSSes
without it against 34 with it.

> This chip only handles the 2.4 GHz band, so checking the current band
> should not be necessary.

True, though the function is gone now.

> With this you are always setting the same TX power, hardcoded in
> rtw8723bs_pg_txagc. What is the reason for that?
>
> Normally the TX power depends on values burned into the chip's efuse
> (so they vary from device to device), and values hardcoded into the
> driver are only used if there is nothing in the chip's efuse.

There is no good reason, and this one was the worst of the three. The
efuse path works: the by-rate table gives sensible values with the
regulatory limit applied, and the hardcoded table was overriding them
by up to 22 index units and bypassing that limit.

> In rtw88 the IQ calibration is normally done in the phy_calibration
> function (from rtw_chip_ops) which runs right before connecting to a
> network, not in the power on code. Wouldn't that be fine for this chip
> too?

It is fine. v2 uses the normal phy_calibration path.

Best regards,
Luka Gejak
