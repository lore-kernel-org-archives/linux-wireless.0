Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4DD13C672;
	Tue, 23 Jul 2024 07:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721721193; cv=none; b=kjjwiccBuPAiyBMLqjzLAoCogLakOP/wjE0Es/Ic16XB5bRFFlQIcCSNhRon+QbnATYYwWqPCVO+N4OIUhdIvNu+897RIapRbymeJGhnymBEvBhbTAKUiO1c/hFGEXiK8/y08QlA+DIqUKvp7tMX8ppcGDZ1e9LkDoqAb8WUOEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721721193; c=relaxed/simple;
	bh=MPKrWgCJX8kuQqmsrrNaFWSNDTe2jSFjoOdeUwMEZZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEzd7Fcmp5llpZzTE93UTxqR7dX0G6cLFH9E6e7EEPeVJvg5IxlDnfUmA0x7kvQKTxtg6Qs86Djvb3Tjwa7ECUJ60rSeF63iOXV6ps4fZ1Ze/dtR1uVE2K2p+Jx0HYiODmjQTzR0lPRTFsfn79WwqkYkXFqtfvIzANoW3JJqovY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=hA9N+9Gc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="hA9N+9Gc"
Received: from gaggiata.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id F3EF01FA1F;
	Tue, 23 Jul 2024 09:52:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1721721180;
	bh=Zq3WobKhZlNyUclaAoMGdR7zs6lyy9+0XoA9l1rUHls=;
	h=Received:From:To:Subject;
	b=hA9N+9GcOG6snopYpbyWDIcrEriP0RqY1wCplHcKLtFQXFmJ3NxjEnazwqZObv2+F
	 MaB9HbhoP7mC5oD1z+t4sjfeLvdlBgbMpoz7+wI8DckM2vi0TdyzCiSOprKVE08t2G
	 eDQw1oEPBjIT5StomeCaoZlwzLHLdl+O64SZ27OZe07DjUqVpLanGE3PyhnSODSyV4
	 /lkyP9+OMEcidNpX2lRs/Hk1Yf1iu7ugaQGYezO0gg3i/ffERL6Hp78nUYVgLMerR1
	 rA7yoeN8P/fBho0JLPW6cqOZGfykLnIgBoO9tD2YEB/0ZcwSf/eDkR9b6rveX5BAJg
	 bLuF39c06ovQg==
Received: by gaggiata.pivistrello.it (Postfix, from userid 1000)
	id A66747F9A5; Tue, 23 Jul 2024 09:52:59 +0200 (CEST)
Date: Tue, 23 Jul 2024 09:52:59 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Kalle Valo <kvalo@kernel.org>, David Lin <yu-hao.lin@nxp.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] wifi: mwifiex: fix key_mgmt setting
Message-ID: <Zp9hW-TIoJvPiGFh@gaggiata.pivistrello.it>
References: <20240723-mwifiex-wpa-psk-sha256-v3-0-025168a91da1@pengutronix.de>
 <20240723-mwifiex-wpa-psk-sha256-v3-2-025168a91da1@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723-mwifiex-wpa-psk-sha256-v3-2-025168a91da1@pengutronix.de>

On Tue, Jul 23, 2024 at 09:09:58AM +0200, Sascha Hauer wrote:
> bss_config->key_mgmt specifies the AKM suites that are usable in
> hardware. This variable is set to specific values while iterating
> over the advertised AKM suites. This means the final value of the
> variable depends on the order of the entries in the AKM suites
> array. Instead of setting the variable, just set the relevant bits
> in the key_mgmt bit field to make us independent of the order of
> entries.
> This behaviour is derived from the downstream driver that does the
> same.
> Also, set bss_config->key_mgmt to zero explicitly right before the
> loop. bss_config has been zero allocated by the caller already, but
> do so again to safe the reader from following the code path.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco

