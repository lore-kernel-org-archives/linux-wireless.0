Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9D733469C;
	Wed, 15 Jul 2026 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127154; cv=none; b=AwIQkXJeyOaApSzgb8LSivtuW+khxX8ADEv0CsH4099iGhggFg+7CJzCJ00wBpvKa9/sXde8Z2zLe83d+yOyCGAZ/HY+wP45rxQdxXhFyk+/jQVXdmGLA7p7oBQ1jpsiqmcCDpq+s84CD+/p/8RQUXqFX7FX7nT/7/j1bZ6knHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127154; c=relaxed/simple;
	bh=vHgBUHX+/XSjr9QSOM/9UI1kqYnaRD65SLqzT1s8rVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJ+m/Lkebp7B5jr6KfSwH4BhX2vOq7igHT4al17mXzC17W40Jc+QmN1AspUwK9HHJjOTGo31inhCAP7mzvvVFCo8kXkEocqI0ptoXcQY2AcHdROLT3wKjQ8wIk06/FxOmQo9JydCfStvwT1DUmedsPwlcz5CxPzJzcJVibnOnCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=mElQBtnL; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="mElQBtnL"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 2BE7E1FC21;
	Wed, 15 Jul 2026 16:52:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784127150;
	bh=gZrZxgBQBgSwOdMZWsGBEbi3vv8Ic2jgD4hEcb4Cahk=; h=From:To:Subject;
	b=mElQBtnLq6ygcdKwFVsC2RXhVSndlWQWQ6QJV+KOv4TwsmiNiq+OCobFN+r0BANWK
	 ToCUHwjUCKkiWGO+1bCee8oOv8DHNeLsE2afat5u9dnFOVotSkBkK9mwvMZs0DP00Q
	 1KO2XzC3qqUJtAtD0ZG6iREahgRgU7w5wa/LhqIXhegolztm4wRqYyzbPlj0JGB4YW
	 FdZi9tb8TeHALMSnC6jQltEwKgtnEeUiofW9Nh60+9DfkDJmmHBQdoawh3o+ZbuM6z
	 lagV1WBDmHluB5XOJWaUTx6vTcvERCHU1nzat9m/bdDlxMCAI4xxaEiSGNCUEHXetV
	 gHI/uX2a8yMLg==
Date: Wed, 15 Jul 2026 16:52:28 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Georgi Valkov <gvalkov@gmail.com>
Cc: briannorris@chromium.org, francesco@dolcini.it,
	s.kerkmann@pengutronix.de, johannes.berg@intel.com, kees@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: fix freeze for 60 seconds caused by
 request_firmware
Message-ID: <20260715145228.GG56330@francesco-nb>
References: <20260712221709.7099-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712221709.7099-1-gvalkov@gmail.com>

On Mon, Jul 13, 2026 at 01:17:09AM +0300, Georgi Valkov wrote:
> Fix regression in rgpower table loading, caused by using
> request_firmware(): when the requested firmware does not exist, e.g.
> nxp/rgpower_WW.bin does not exist on OpenWRT builds for WRT3200ACM,
> request_firmware() falls back to firmware_fallback_sysfs(), which expects
> the firmware to be provided by user space using SYSFS. No such utility is
> provided in this configuration, so the entire system locks up for 60
> seconds, until the request times out. During this time, no other log
> messages are observed, and the device does not respond to commands over
> UART.
> 
> The request_firmware() call is performed in the following context:
> current->comm kworker/1:2  in_task 1  irqs_disabled 0  in_atomic 0
> 
> Fixed by using request_firmware_direct(). This prevents fallback to SYSFS,
> and avoids delay. The rgpower table is optional. The driver falls back
> to the device tree power table if the firmware is not present.
> 
> The error code is printed for debugging and returned to the caller,
> which only cares for success or failure, so there are no side effects.
> 
> Fixes: 7b6f16a25806 ("wifi: mwifiex: add rgpower table loading support")
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

