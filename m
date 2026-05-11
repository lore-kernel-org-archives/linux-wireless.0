Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CEA477981
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778522651; cv=none; b=qvE98x/Xjb/v0fT98GMAjweTgcYX8nIarymkqvaCKNdk+YpM5d+Non+NVg0ojonbTvycpdYtedreORB8e8Dw/YBpPvqzey5Tl+CMgN5PjvrIb47zpsW2n7j4pgc/AOuks/2TBSzDkFCFknXUQCWNdZcRiFkV8FWrNl+Bfc4WRbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778522651; c=relaxed/simple;
	bh=iqaPGA6uJh9mAJ60XUot7QXyNPyybOQ25m/dHICxbeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0T8Iit94g0NBfmMN3iUL24XnWXlbXYObNTgMforx/EU0SYQkwRosMQ048zL88ywJovBgytT2zC4tW2LnVkUAPx8f2ULP6xVTN8097NwMCGC3GjdKpF5nZbhXrT9Nqe31gr8IE42J453d1xo3wE6n76AT4YIerRIa41SHzXM0SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ZVPKy8tn; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ZVPKy8tn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1778522645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x5hLRsDX8WKV6E61UaLID6xPAUowT23m6dYllWJ3JCY=;
	b=ZVPKy8tnrGGscRpFoyDf1y4B2Y32xdGtwyO9ubXfqIzGkxzYyyepQqBhoyfoDkGLHp3pJi
	7D2H1xtMYy74Z6xobI7yReDHNg3np+RkM6IFtmFHlnN9WSc4N3JoUgkkwFGhsqArtyXiVn
	59psJczmlaH+3or0EGLSgOPLhZAw8Hzx9tUSXb+oKaCSDUf+KYogtCHdo2+Kl8QsTNky8D
	82s8zADUsBEEdgzT5PHIVCobiR29YqksjVYNGlNE2dLPA2paV6Ltf4EpmlnVOQEMcJkusQ
	ab7D7BE8kixkK6egOcxRqw22jSSBT6KBT8nQ12bmjU3rbAUlFtx1zVAR0WrqHA==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	rtl8821cerfe2@gmail.com,
	linux-kernel@vger.kernel.org,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: Re: [PATCH rtw-next v2 1/1] wifi: rtw89: usb: Support switching to USB 3 mode
Date: Mon, 11 May 2026 11:03:51 -0700
Message-ID: <20260511180351.26471-1-lucid_duck@justthetip.ca>
In-Reply-To: <6d553cffcb0ae84e141006ae1430f6f37909ad2b.camel@sipsolutions.net>
References: <6d553cffcb0ae84e141006ae1430f6f37909ad2b.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 2026-05-11 at 19:26 +0200, Johannes Berg wrote:
> > +static bool rtw89_switch_usb_mode = true;
> > +module_param_named(switch_usb_mode, rtw89_switch_usb_mode, bool, 0644);
> > +MODULE_PARM_DESC(switch_usb_mode,
> > +         "Set to N to disable switching to USB 3 mode to avoid potential interference in the 2.4 GHz band (default: Y)");
>
> We shouldn't really add new module parameters.

This module parameter follows the pattern Bitterblue established for
rtw88: same user-facing name (switch_usb_mode), same description, same
default. Commit 315c23a64e99 "wifi: rtw88: usb: Support USB 3 with
RTL8822CU/RTL8822BU" (2024-07-10) added it to rtw88/usb.c and it
remains in-tree.

Three v3 paths I see:

1. Drop the param. Users hitting USB3 2.4 GHz harmonic interference
   would need to use a USB 2 port instead.
2. Move the escape hatch behind a sysfs or nl80211 control. New UABI
   surface; open to design suggestions on that.
3. Keep it for rtw89/rtw88 symmetry on the same USB3 / 2.4 GHz
   harmonic interference issue.

Any of the three works on my side. If the rtw88 param is grandfathered
and we should not add new module parameters even in this case, I will
respin without it in v3.

Devin
