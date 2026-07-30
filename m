Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA053BE628
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397548; cv=none; b=PJBHWB297V296LDmwDks55m/hoXp+BOxHQL5sfVj4vgp+vs8bIjapPR8J96e4mFSw6Ji0a7n2BfGOocz6WJIZ1g2Y3b0EGXP60Rj093E7hvn8wDzkGbasuaWA15OaZp5PtapePqd5h7A649YBysMGMztRNOJxKQB1n4+7Zl6Vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397548; c=relaxed/simple;
	bh=A1m/GtkP8vXZbRkCedtwR/LJGgQ8AQXl2uiPzjYANLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSZqT2hIwuKizuFgIh0EGqGrlg/htRhIWoNujIy9dVKnfbcoXw9UjutHkxwEHMc4v0zz/wFAzfrRLpGZA4cvOyG5txaEX/gcunahzmdLO7tGnR0i2su35YB8nBGL6cvZ2Ro8aqZ29sMuiEa5Kqf5XZGvecg91jAbgQrk9WvuYnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sQiNuZaO; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sQiNuZaO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N7IBkCn2miWSg7TB4m+M//Ksa8Qu2PiXRYgSyZLew4c=;
	b=sQiNuZaORXuObqJzHq3SsWSaWX8srL+kDZsH93rmLbY5DbRWAz6ZLE+hVtZgxR4HY3KJBf
	9sAisB8scXjI8V7wkzfUyNfr3X9rg2a1y/+B8iBS/b86zfn+ZM/o1BeDXt53HJlLqxLg1Q
	CqHvd2hrYTUVBXkAnRRZZFl8vTfImFI=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association register sequence
Date: Thu, 30 Jul 2026 07:45:04 +0000
Message-ID: <20260730074504.19725-10-luka.gejak@linux.dev>
In-Reply-To: <611b495996b74b278bfd769a9c045582@realtek.com>
References: <611b495996b74b278bfd769a9c045582@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 09:33, Ping-Ke Shih wrote:
>> +       if (rtw_is_8723bs(rtwdev)) {
[...]
> I'm surprising that RTL8723BS needs so many special handing. Can you reduce
> them? At least, use rtw_chip_prepare_tx() to implement its specific
> functions.

Done. v3 adds a chip_ops::prepare_tx callback, and
rtw_ops_mgd_prepare_tx() is back to a single common path:

	mutex_lock(&rtwdev->mutex);
	rtw_leave_lps_deep(rtwdev);
	rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
	rtw_chip_prepare_tx(rtwdev, vif, info);
	mutex_unlock(&rtwdev->mutex);

rtw_chip_prepare_tx() calls the chip callback when one is set and
otherwise keeps the existing deferred RF calibration, so no other chip
changes behaviour. The RTL8723BS callback does the IPS wake and the
join sequence, and the chip driver in the follow-up series points
.prepare_tx at it. That also removes the chip test from the helper
below it, per your comments on patch 05.

On reducing the rest: this patch is smaller in v3, but not as much as
I would like, and I want to be straight about why. Two things went:

 - the beacon wait, once you made me measure it (see my reply on
   patch 10), which took struct rtw_auth_sync with it
 - two dead bool arguments, rtw8723bs_auth_rx_filter(accept_all) and
   rtw_coex_8723bs_restore_pad_ctrl(keep_pta_owner), both of which had
   a single value at every call site

What is left is the vendor start_clnt_join() register programming
itself: the BSSID-scoped receive filter, the response and basic rate
set from the BSS rate elements, preamble and slot time, TSF update, the
retry limit and the security config. I have removed these individually
on hardware and association fails or the AP drops us shortly after,
which is why they are still here rather than because I have not tried.

If the concern is that it sits in mac80211.c rather than a chip file, I
agree, and I would rather move the whole rtw8723bs_* block into
rtw8723b.c in the driver series than leave it in the common file. It is
in mac80211.c today only because this series lands before the chip
file exists. Tell me which you prefer and I will do it that way.

Best regards,
Luka Gejak
