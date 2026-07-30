Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC28367280
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391763; cv=none; b=gy9d6We9KVwvmMv0mRBiMt1m/qBbJ9IVDcCayQJBzudOVlCsXgkfL3xcdguEDs1tAOL2z4cK9vnDPEoZZCQvFI0TI+HqBt7k4n9rkTqFaGlYUTOlOWQaO8UAXAezQfvM7MBPcWrlMezdsT61GN9xtop2il7Fdd0+Kms4VHZg4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391763; c=relaxed/simple;
	bh=cMRHW5rNkYJRNQLff7L96yh3ojPO8UNrg0QnbPXu/dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzfKCW/1K84oJUn8M9mTmIBSSgHtr69xZr6JrTjsY3N7ZnPpHtwEhXwNM/PlT2TMl2aWb8a5hIdy6ouID7tKktXDjlpR8+iR7aw7xRGyjU1I0rNrI6DQFMl9UrhUgAB7Q25enINIWhGTY39PgVn/ZjrScHZPOu+StdXNTCmkaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J7oxhrvN; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J7oxhrvN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMRHW5rNkYJRNQLff7L96yh3ojPO8UNrg0QnbPXu/dg=;
	b=J7oxhrvND7xWHIiuCk6omtothFXltw9FlM8VB4yW98r5yFTKTIM9gtG+Zcw9LtQa6gKmRa
	VD6dTcc6z1c18ZaLgBSC5VG/IFf4eDKihDL8aQC7KtJvipwcsmrqhB/Rtw9nWcUZpyRJUE
	1b471Dk8QBQWksbSsNtE2xnfcJcYl2U=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 05/19] wifi: rtw88: fw: send rate adaptation and RSSI info in the vendor layout
Date: Thu, 30 Jul 2026 06:08:50 +0000
Message-ID: <20260730060903.30187-3-luka.gejak@linux.dev>
In-Reply-To: <aa006f43-bb28-4067-8538-a63529ab546b@gmail.com>
References: <aa006f43-bb28-4067-8538-a63529ab546b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 02:46, Bitterblue Smith wrote:
> Not sure where you found the value 0x04. I see in
> hal/phydm/phydm_rssi_monitor.c that it's setting bit 1, same as rtw88.
> The other bytes you set here are equivalent to the macros in the else
> branch.

Agreed, there is nothing here the existing macros do not already do.

> This doesn't look like the vendor driver's behaviour. To me it
> looks like rtw88 is already handling the no_update bit correctly.
>
> I bet you don't need to modify rtw_fw_send_ra_info() at all.

You are right. Without the patch the negotiated rate and uplink are
unchanged, MCS7 either way, so the whole patch is dropped in v2.

Best regards,
Luka Gejak
