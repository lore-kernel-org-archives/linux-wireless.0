Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19C0384CD3;
	Thu, 30 Jul 2026 06:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391771; cv=none; b=BJoB3bQ5kwFpN9fHu0+/2NHukBYYzFmv7GFZxlux5ZAOvnvSjO9CBvPtVA3rRZqqjgpLW+DxQETlRP5fhiz/QJxrK3EYtdwRw90HbYxQ2li9tDqxxSCmODHe7A3beT+M2JLNxvWUNIubgN8jSYOnmVrrA7TqHNW8zsiypEIMd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391771; c=relaxed/simple;
	bh=NvNj2mGdU+Dp+eTjacg4WlEPEjJxHCulIA5m+IheOLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqNZPKr0qeTy5pfiv+8flou2SK+7nbvYjSiHb+5h/WKZPA+zL64Y1Tqbm+TW0WMOjur88mR63CsfGenBR0rzv0g7g9gliwqskZz4MuXGisQcix2ktJ+NxZUkLpNeB64Di+q11Te/mj0cHfYPmaoq5CVaAuH2dSEhQkaxyBFdZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PARpcB5c; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PARpcB5c"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvNj2mGdU+Dp+eTjacg4WlEPEjJxHCulIA5m+IheOLA=;
	b=PARpcB5ci7oX1Ezk9Ulq5dppq3ufHwbYmuhC9oe8xaE046y/IKtN67Nq/2k2GStfLaS+Wo
	fZebgMKhv41cU+bO0JHgr1JfC7IUU3Ttl6OFvrounLuf5MreAhr+Yiyvm781UR6eYifWcp
	VnLlKS3wsIVr6dAT3Sw+jzwi7cRtYh4=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 19/19] wifi: rtw88: advertise the correct receive capabilities on RTL8723BS
Date: Thu, 30 Jul 2026 06:08:57 +0000
Message-ID: <20260730060903.30187-10-luka.gejak@linux.dev>
In-Reply-To: <92272d90-a549-437d-886e-308807418485@gmail.com>
References: <92272d90-a549-437d-886e-308807418485@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 01:29, Bitterblue Smith wrote:
> You can do that too instead of adding special code here. You can
> make your own rtw8723b_read_efuse() which calls rtw8723x_read_efuse()
> and also fills hw_cap.

Done, in the chip driver.

> The driver is supposed to set that bit. The default value of
> rtwdev->hal.rcr includes it. I think that should work for this
> chip too.

You are right, and the reason it did not was a bug of mine:
rtw8723b_init_wmac_setting() assigned WLAN_RCR_CFG over hal.rcr
wholesale and so cleared BIT_APP_FCS, where the 8723x siblings only
write the register. With the bit set in the chip's WLAN_RCR_CFG the
descriptor carries the FCS and the core needs no special case.

Both changes are in the chip driver series rather than the
preparations, so they will not be visible until that one is sent.

Best regards,
Luka Gejak
