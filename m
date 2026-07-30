Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BB13B71AA
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397546; cv=none; b=PKXCr74hRM4OVGjO00G+ByqYxqd2OT/Cku2yl4T7VAG+0HZlckcsxFFeGa2CnyPbPJUUdm+M9pJpiSR5mEM3tUCcgzaZpYLmys75s0wfIr6DcNh7M4SwFEP2U9TW2uxJNpF9xK/Q5rK5ng16++y2xWJCJ8v02o4T//G8ce5FnGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397546; c=relaxed/simple;
	bh=61wxV976goZk4ys3aZ4z0zRZG1dWPrOTyI5M3bbDBRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siksQF4W7GhZEqat8cGlNZfEhb8WYpIUD4ygqbs7N11/8Uwf/9iF+ZclqWKY9iFsEAbGzXNih6/sxsx2Q9GpcmLbBj/7Zk6sJG6dzH1rQ4XbFYaLB6JmuY0bWnbsWwd9OXErOiUitXCqkE/hlhGzslDLFKmEY7Jy9FAKHB/Q3F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FFFvCLef; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FFFvCLef"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxVSLpMi6K4YPViUCDUJ143axNgN81MsAVaBgjYFL/0=;
	b=FFFvCLefUtE2Wntfvgy7QzIlYVkb/D5kyGZtN5534wXChY2PDBwRN0lUp/c8n7Nx+kU1gz
	Fjwhdm0f7FBnJAH8NcJ6SHiA4A+e5x4aPAvhsMa3s569dGIDSjzuu/e+wg05PNfWzYQmv9
	KObfCrxvfU92RWUo5I/9CYR6Z9zdRPQ=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 10/11] wifi: rtw88: record beacons from the target BSSID before authenticating
Date: Thu, 30 Jul 2026 07:45:03 +0000
Message-ID: <20260730074504.19725-9-luka.gejak@linux.dev>
In-Reply-To: <e3158b4edeb649839eb8063367a97a06@realtek.com>
References: <e3158b4edeb649839eb8063367a97a06@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 09:27, Ping-Ke Shih wrote:
> I know vendor driver does wait for a beacon, but I don't think this can
> affect connection. Could you confirm this again?

Confirmed, and you are right. This patch is dropped in v3.

I built the series with the wait removed and left everything else
alone, then ran association attempts from a cold module reload and from
a warm reconnect:

  with the wait:     10/10 cold, 10/10 warm
  without the wait:  12/12 cold, 12/12 warm

Time to wpa_state=COMPLETED was the same in both, around 4 s, with one
outlier either way.

Looking at it again the reason is visible in the patch itself: the
pre-auth deauth in patch 11 already sleeps 100 ms afterwards, and the
recording window opens before that sleep, so on a 100 ms beacon
interval the wait had almost always already been satisfied by the time
it was reached. It was measuring the sleep, not doing anything.

Dropping it also removes struct rtw_auth_sync, so your point about
using a completion instead of the spinlock, and the caller check in the
RX path, are both moot. Thanks for pushing on it.

Best regards,
Luka Gejak
